-- pedimos um número para o usuário
local n
repeat
  io.write("Digite um número:") -- usamos io.write porque não queremos quebra de linha
   n = io.read("*n")
until n > 0

-- imprimimos uma coluna de n blocos no terminal
for i = 1, n do
  print("#") -- print ja possui uma quebra de linha por padrão.
end
