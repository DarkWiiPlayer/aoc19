local function fuel(num)
  return math.floor(tonumber(num) / 3) - 2
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
