io.write("Digite um número: ") -- não quero quebra de linha
local i = tonumber(io.read())

if i % 2 == 0 then
  print(i .. " é par.")
else
  print(i .. " é impar.")
end
