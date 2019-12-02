local function fuel(num)
  local f = math.floor(tonumber(num) / 3) - 2
  if f > 0 then
    return f + fuel(f)
  else
    return 0
  end
end

for i, arg in ipairs{...} do
  local file = io.open(arg)
  local acc = 0
  for line in file:lines() do
    acc = acc + fuel(line)
  end
  print(acc)
  file:close()
end
