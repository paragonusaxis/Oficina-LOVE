local monstros = {
    orcs = {
      jose = {name = "José", description = "Um orc lindo que adora cantar.", hp = 40, type = "normal"},
      otavio = {name = "Otávio", description = "Um orc feioso e burro.", hp = 50, type = "normal"},
      maria = {name = "Maria", description = "Uma senhora Orc, esposa de José.", hp = 45, type = "normal"},
      madruga = {name = "Madruga", description = "Líder dos orcs. É o bichão!", hp = 100, type = "chefe"}
    },
    
    dragoes = {
      ernesto = {name = "Ernesto", description = "Um dragão muito sábio.", hp = 120, type = "normal"},
      hepaminondas = {name = "Hepaminondas", description = "Um dragão muito ganancioso", hp = 110, type = "normal"},
      xarope = {name = "Xarope", description = "O rei dos dragões.", hp = 300, type = "chefe"}
    },
    
    goblins = {
      luisa = {name = "Luísa", description = "Triste e gótica.", hp = 800, type = "normal"},
      rocco = {name = "Rocco", description = "Triste e cansado.", hp = 800, type = "normal"},
      dorival = {name = "Dorival", description = "Um mistério...", hp = "???", type = "chefe"}
    }
  }
  
  -- Acessando todos os monstros de uma única vez
  for k, v in pairs(monstros) do
    print(k..":")
    for k, v in pairs(v) do
      io.write("\t") -- imprimir um tab
      print(k)
      for k, v in pairs(v) do
        io.write("\t\t") -- imprimir dois tabs
        print(k .. " - " .. v)
      end
    end
  end
  
  print()
  
-- Acessando monstros individuais
print("HP do Madruga: " .. monstros.orcs.madruga.hp)

print()

if monstros.dragoes.hepaminondas.type == "chefe" then
  print("Hepaminondas é o rei dos dragões")
else 
  print("Hepaminondas é um dragão normal...")
end

print()

print("Dorival é um goblin de tipo " .. monstros.goblins.dorival.type .. ", sua descrição é " 
  .. monstros.goblins.dorival.description)
