#!/usr/bin/env terra

-- vim: set filetype=terra :miv ---

local function load(program)
  -- Separate integers into a sequence
  local code = {}
  for instruction in program:gmatch('%d+') do
    table.insert(code, tonumber(instruction))
  end
  -- Copy the instructions into a global memory region
  local memory = constant(int[#code], `array(escape
    for i, instruction in ipairs(code) do
      emit(instruction)
    end
  end))
  return memory, #code
end

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

for i, arg in ipairs{...} do
	local file = io.open(arg)
	local code = file:read('*a')

	file:close()

	local original, len = load(code)

	for i=1,99 do
	  for j=1,99 do
		  local code = terralib.new(original.type, original:getpointer()[0])
		  code[1], code[2] = i, j
		  run(code, len)
		  local hit = code[0] == 19690720
		  if hit then
			  print(i, j, 'HIT')
		  end
	  end
	end
end
