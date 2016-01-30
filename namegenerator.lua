generator = {}

local prefixes = {
  "Greater",
  "Flaming",
  "Shocking",
  "Petrifying",
  "Scrumptious",
  "Confusing",
  "Blistering",
  "Stupefying",
  "Supercalifragilisticexpialidocious",
  "Copyright Infringing",
  "Dancing",
  "Singing",
  "Thieving",
  "Lingering",
  "Malnourished",
  "Pro",
  "Broken",
  "Rapping",
  "Healing",
  "Monstrous",
  "Overly Complicated",
  "Rube Goldbergian",
  "Eldritch",
  "Cute",
  "Surprisingly Cheap",
  "Unexpected",
  "Totally Balanced Guys Trust Me",
  "Childish",
  "Kinda Slimy",
  "Your Mom's",
  "[REDACTED]",
  "Formerly Famous",
  "Used",
  "Boring",
  "Annoying",
  "Not Implemented Yet",
  "Pizza Making",
  "undefined",
  "Exploding",
  "Memetic",
  "Mistaken",
  "Narcissistic",
  "Nihilistic",
  "Condescending",
  "Fearmongering",
  "Elvish",
  "Orcish",
  "Dwarven",
  "Angelic",
  "Demonic",
  "h4xXx0r",
  "Shifty Looking",
  "Yodeling",
}

local suffixes = {
  "Stabbing",
  "Singing",
  "Dancing",
  "Destruction",
  "Annihilation",
  "Deliverance",
  "Surprises",
  "Segmentation Faults",
  "Hacking",
  "Slashing",
  "Discredited Rogues",
  "Former Child Stars",
  "Mid Bosses",
  "Last Bosses",
  "Nerfing",
  "Aimbotting",
  "Copyright Infringement",
  "Slaying",
  "Draining",
  "Cold",
  "Fire",
  "Ice",
  "Thunder",
  "Typos",
  "Bugs",
  "undefined",
  "[REDACTED]",
  "Sugar",
  "Faeries' Bane",
  "Steel",
  "Pong Paddles",
  "test string do not use",
  "Chocolate",
  "Explosions",
  "Pizza",
  "Memes",
  "Spoilers",
  "Angels",
  "Demons",
  "Elves",
  "Orcs",
  "Dwarfs",
  "Yodeling",
  "Cakes",
}

function generator.generate(weaponname, blinglevel)
  local iterations = 1
  local blingleft = blinglevel/2
  while blingleft >= 1 do
    iterations = iterations + 1
    blingleft = blingleft/2
  end
  -- print (weaponname)
  local name = prefixes[love.math.random(#prefixes)].." "..weaponname.." Of "..suffixes[love.math.random(#suffixes)]
  -- print(name)
  if iterations > 1 then
    for i = 2,iterations do
      name = prefixes[love.math.random(#prefixes)].." "..name.." And "..suffixes[love.math.random(#suffixes)]
    end
  end
  return name
end

return generator