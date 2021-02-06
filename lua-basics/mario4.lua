-- pedimos um número para o usuário
local n
repeat
  io.write("Digite um número:") -- usamos io.write porque não queremos quebra de linha
   n = io.read("*n")
until n > 0

-- imprimimos um bloco n x n no terminal usando dois blocos for aninhados
for i = 1, n do
  for j = 1, n do
    io.write("#") -- sem quebra de linha
  end
  print() -- quebrea de linha, pois estamos trocando de fileira
end
