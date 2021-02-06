io.write("x: ") -- sem quebra de linha
local x = tonumber(io.read())

io.write("y: ")
local y = tonumber(io.read())

if x > y then
  print("x é maior que y")
elseif x < y then
  print("x é menor que y")
else 
  print("x é igual a y")
end
