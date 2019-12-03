#!/usr/bin/env terra

-- vim: set filetype=terra :miv --

local intcode do
  local path = package.path; package.path = ''
  intcode = require 'intcode'
  package.path = path
end

for i, arg in ipairs{...} do
  local file = io.open(arg)
  local code = file:read('*a')

  print(intcode.run(code))
  --terralib.saveobj(arg..".elf", { main = intcode.compile(code) })

  file:close()
end
