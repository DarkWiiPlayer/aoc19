local intcode = require 'intcode'

for i, arg in ipairs{...} do
  local file = io.open(arg)
  local code = file:read('*a')
  print(intcode(code))
  file:close()
end
