local endgame = false

while not endgame do
  print("End game? Y/N")
  local c = io.read()
  if c == "y" or c == "Y"  then
    print("Game Over!")
    endgame = true
  end
end
