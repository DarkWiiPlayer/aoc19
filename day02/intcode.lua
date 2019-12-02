return function(program)
  local memory = {}
  for code in program:gmatch('%d+') do
    table.insert(memory, tonumber(code))
  end

  for i=1,#memory,4 do
    local op = memory[i]

    if op==99 then
      break
    end

    local src_a, src_b, dst =
      memory[i+1]+1,
      memory[i+2]+1,
      memory[i+3]+1
    
      if op == 1 then
        memory[dst] = memory[src_a] + memory[src_b]
      elseif op == 2 then
        memory[dst] = memory[src_a] * memory[src_b]
      else
        error('Unknown opcode: '..tostring(op))
      end
  end

  return table.concat(memory, ',')
end
