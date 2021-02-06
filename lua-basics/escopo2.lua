for i = 1, 10 do
  local x = i
  print(x, i)
end

print(x , i) -- ambas as variáveis são locais com relação ao bloco for, portanto não existem fora dele