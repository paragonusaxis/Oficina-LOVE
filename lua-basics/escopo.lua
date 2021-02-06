playerHP = 0 -- global
print(playerHP)

if true then
  local playerHP = 10 --local para este bloco (if/end)
  print(playerHP) -- irá imprimir a variável local
end

print(playerHP) --irá imprimir a variável global