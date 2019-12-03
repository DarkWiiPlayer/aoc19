-- vim: set filetype=terra :miv --

local intcode = {}

local stdio = terralib.includec 'stdio.h'

local terra run(memory : &int, memsize: int)
    var pc = 0 -- Program Counter (instruction pointer)

    while 0 <= pc and pc < memsize do
      var instruction = memory[pc]
      if instruction == 0x01 then
        memory[memory[pc+3]] = memory[memory[pc+1]] + memory[memory[pc+2]]
        pc = pc + 4
      elseif instruction == 0x02 then
        memory[memory[pc+3]] = memory[memory[pc+1]] * memory[memory[pc+2]]
        pc = pc + 4
      else
        break
      end
    end
end

local terra dump(memory : &int, memsize : int)
  for i=0,memsize do
    if i%5==4 or i==memsize-1 then
      stdio.fprintf(stdio.stderr, '0x%08x\n', memory[memsize])
    else
      stdio.fprintf(stdio.stderr, '0x%08x\t', memory[i])
    end
  end
end

local function parse(program)
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
  return memory, #code
end

function intcode.compile(program)
  local memory, memsize = parse(program)
  return terra()
    run(memory, memsize)
    dump(memory, memsize)
  end
end

function intcode.run(program)
  local memory, memsize = parse(program)
  (terra() run(memory, memsize) end)()
  local buffer = {}
  memory = memory:getpointer()[0]
  for i=1,memsize do
    buffer[i] = memory[i-1]
  end
  return table.concat(buffer, ',')
end

return intcode
