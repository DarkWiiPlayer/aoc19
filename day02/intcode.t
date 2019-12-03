-- vim: set filetype=terra :miv --

local stdio = terralib.includec 'stdio.h'

function compile(program)
  -- Separate integers into a sequence
  local code = {}
  for instruction in program:gmatch('%d+') do
    table.insert(code, tonumber(instruction))
  end
  -- Copy the instructions into a global memory region
  local memory = global(int[#code], `array(escape
    for i, instruction in ipairs(code) do
      emit(instruction)
    end
  end))
  local memsize = #code
  -- Return a terra function
  return terra()
    var pc = 0 -- Program Counter (instruction pointer)

    while 0 <= pc and pc < memsize do
      var instruction = memory[pc]
      if instruction == 1 then
        memory[memory[pc+3]] = memory[memory[pc+1]] + memory[memory[pc+2]]
        pc = pc + 4
      elseif instruction == 2 then
        memory[memory[pc+3]] = memory[memory[pc+1]] * memory[memory[pc+2]]
        pc = pc + 4
      else
        break
      end
    end

    -- Output the program memory
    for i=0, memsize-1 do
      stdio.printf("%i,", memory[i])
    end
    stdio.printf("%i\n", memory[memsize])
  end
end

for i, arg in ipairs{...} do
  local file = io.open(arg)
  local code = file:read('*a')

  local main = compile(code)
  terralib.saveobj(arg..".elf", { main = main })

  file:close()
end
