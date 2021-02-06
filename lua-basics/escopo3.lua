local x = 0 -- local dentro do escopo deste programa
print(x)

if true then
  x = 10
  print(x)
  local x = 5
  print(x)
end

print(x)