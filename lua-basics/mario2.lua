-- pedimos um número para o usuário
local n
repeat
  io.write("Digite um número:") -- usamos io.write porque não queremos quebra de linha
   n = io.read("*n")
until n > 0

-- imprimimos pontos de interrogação igual ao número que recebemos do usuário
for i = 1, n do
  io.write("?")
end

print() -- necessário para criar uma quebra de linha no terminal
