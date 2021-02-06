local counter
print(counter)

--[[ 
  Variáveis declaradas mas não inicializadas sempre possuem
  o valor nil
]]

counter = 0 -- Inicialização
print(counter)

counter = counter + 1
print(counter)