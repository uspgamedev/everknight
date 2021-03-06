generator = {}

local prefixes = {
  "Greater",
  "Fancy",
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
  "Retro",
  "Nostalgic",
  "Pro",
  "Broken",
  "Futuristic",
  "BR BR hu3hu3hu3",
  "Rapping",
  "Healing",
  "Monstrous",
  "Overly Complicated",
  "8-Bit",
  "Vintage",
  "Ancient",
  "Jurassic",
  "Rube Goldbergian",
  "Eldritch",
  "Cute",
  "Socially Awkward",
  "Extroverted",
  "Heavy",
  "Strogonoffic",
  "Warsong",
  "Grim",
  "Undergrad",
  "Heavy Metal",
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
  "Suspicious",
  "Tired Looking",
  "Sleepless",
  "Bleeding",
  "Brand New",
  "Caffeinated",
  "Hard Working",
  "Megalomaniac",
  "Handmade",
  "Vampiric",
  "Pirated",
  "Slightly Assimetric",
  "Cheating",
  "Konami Coded",
  "Rebellious",
  "Mana Flooded",
  "Mana Screwed",
  "Overused",
  "Impossibly Large",
  "Omnislashing",
  "Teleporting",
  "Smug",
  "Arrogant",
  "Leaky",
  "Really Really Old",
  "Outdated",
  "State Of The Art",
  "Prerelease",
  "Beta",
  "Alpha",
  "Electronic",
  "Digital",
  "Analog",
  "Corrupted",
  "Hand Drawn",
  "Computer Generated",
  "Reality Warping",
  "Universal",
  "Quixotic",
  "Overpriced",
  "Photoshopped",
  "Epic",
  "Legendary",
  "Common",
  "Mythic",
  "Unreal",
  "Godly",
  "Mystic",
  "Volunteer",
  "Untouchable",
  "Combo Breaker",
  "Swordbreaker",
  "Ultra",
  "Super",
  "Hyper",
  "Mass Produced",
  "Redundant",
  "Cursed",
  "Blessed",
  "Uncursed",
  "Ho Hum",
  "Average",
  "Master Race",
  "Probably Over-Prefixed",
  "Faster",
  "Checkered",
  "Downloadable",
  "Rampaging",
  "Random",
  "RNG Blessed",
  "RNG Cursed",
  "Mutually Exclusive",
  "Post Graduate",
  "Master",
  "Upgradeable",
  "Bulk Bought",
  "Amazon Prime Ordered",
  "Play Station Exclusive",
  "Indie",
  "Mainstream",
  "Hipster",
  "Warmongering",
  "Peaceful",
  "Rated By Most People As Having An Excessively Long Prefix",
  "Self Destructing",
  "Newborn",
  "Pointlessly Epic",
  "Parody",
  "Hatted",
  "Guilty",
  "Blue",
  "Red",
  "Purplish",
  "Magenta",
  "Fuchsia",
  "Raibow Colored",
  "Archaic",
  "Formulaic",
  "Well Drawn",
  "3D Modelled",
  "Sarcastic",
  "Ironic",
  "Windowed",
  "Mobile",
  "Unity Made",
  "Love Powered",
  "Löve Powered",
  "Kid Tested Mother Approved",
  "Democrat",
  "Underrated",
  "Overrated",
  "Republican",
  "Episodic",
  "Cinematic",
  "Roguelike",
  "Free To Play",
  "Pay To Win",
  "Protected By Law",
  "Unfocused",
  "Murderous",
  "Bloodthirsty",
  "Star Eyed",
  "Fanatic",
  "Stowing",
  "Part-Time Worker",
  "Real",
  "Anime",
  "Spiky Haired",
  "Dark And Edgy",
  "Realistic",
  "Triple A",
  "Misplaced",
  "Testing",
  "Training",
  "Terminating",
  "Unemployed",
  "Rogue",
  "Steampunk",
  "Cyberpunk",
  "Steam Powered",
  "Original",
  "Virtual",
  "Left Handed",
  "Politically Incorrect",
  "Enviromentally Friendly",
  "Electric",
  "Photorealistic",
  "Cel Shaded",
  "Cartoony",
  "Dead",
  "Poorly Compressed",
  "Smuggled",
  "Enchanted To +7",
  "Dark Web Acquired",
  "Ludicrously Tiny",
  "Nice Smelling",
  "Poorly Encoded",
  "Poorly Aligned",
  "Elbereth Engraved",
  "Faster Than Light",
  "Unstoppable",
  "Flawless",
  "Urban",
  "Dark",
  "Overweight",
  "Facebook Addicted",
  "Culturally Significant",
  "Unearthed",
  "Recursive",
  "Pre Order Exclusive",
  "DLC Only",
  "Sealed",
  "Hilarious",
  "Dull",
  "Sharp",
  "Shaper",
  "Sharpest",
  "Extra Pointy",
  "Final Form",
  "Atomic",
  "Radioactive",
  "Unpaid",
  "Borrowed",
  "Partially Eaten",
  "Wished For",
  "Eternal",
  "Planeswalking",
  "Special Summoned",
  "Ritual Summoned",
  "Ritualistic",
  "Tribal",
  "Forward Thinking",
  "Agile",
  "Bugfixed",
  "Heroic",
  "Musical",
  "Virtuoso",
  "Shredded",
  "Banzai",
  "LEGO Made",
  "Nutritious",
  "Delicious",
  "Lawful",
  "Chaotic",
  "Neutral",
  "Good",
  "Evil",
  "Poorly Assembled",
  "Unlimited",
  "Stolen",
  "Tool Assisted",
  "Fried",
  "Hard Boiled",
  "Tempered",
  "Axereaving",
  "Timed",
  "Buggy",
  "Lost",
  "Optimistic",
  "Arachnophobic",
  "Confident",
  "One-Of-A-Kind",
  "Rated Tem Out Of Tem",
  "Easiest",
  "Dummy",
  "Ghostly",
  "Lonely",
  "Sad",
  "Happy",
  "Wordy",
  "Protected From Red",
  "Cool",
  "Totally Rad",
  "Self Made",
  "Lottery Winner",
  "Very Sussa",
  "Quaking",
  "Surfing",
  "Flying",
  "Supporting",
  "Slow",
  "Gutsy",
  "Paralyzed",
  "Sleeping",
  "Furry",
  "Poisonous",
  "Poisoned",
  "Frozen",
  "Champion",
  "First",
  "Second",
  "Third", --Here's hoping for Third <WEAPON> Of Half-Life
}

local suffixes = {
  "Stabbing",
  "Resolve",
  "Wrath",
  "Fury",
  "Life Saving",
  "Slow Digestion",
  "Jumping",
  "Disappointment",
  "Justice",
  "Headbanging",
  "Singing",
  "Dancing",
  "Cards",
  "Destruction",
  "Annihilation",
  "Puzzles",
  "Spaghetti",
  "Magi",
  "ALL CAPS",
  "Deliverance",
  "Surprises",
  "Segmentation Faults",
  "Hacking",
  "Fallen",
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
  "Weeaboos",
  "Seals",
  "Cakes",
  "Burgers",
  "Digging",
  "Spellslinging",
  "Hammertiming",
  "Generating Affixes",
  "Driving Recklessly",
  "Fiscal Irresponsibility",
  "Extreme Particle Effects",
  "Going Fast",
  "Speedrunning",
  "Speedteching",
  "Wavedashing",
  "Combo Breaking",
  "Lazyness",
  "Bug Hunting",
  "Procrastination",
  "Game Jamming",
  "Poor Programming",
  "Mismanagement",
  "Redundancy",
  "Firefighting",
  "Zombie Smashing",
  "Forgetfulness",
  "Mojo",
  "Indignation",
  "Hunger",
  "Restful Sleep",
  "Looking At A Distraction Over There -->",
  "Recycling",
  "Incineration",
  "Communism",
  "Genocide",
  "Capitalism",
  "Anarchism",
  "Gadgeteering",
  "Freedom",
  "Sinergestic Management Solutions",
  "Extreme Programming",
  "Algorithm Analisys",
  "Photosynthesis",
  "Adventure",
  "Grinding",
  "Crawling",
  "Easy Money",
  "Cooking",
  "Inception",
  "Recursion",
  "Dijkstra",
  "Donald Knuth",
  "Git Pushing",
  "Gardening",
  "A True Hero",
  "Judgment",
  "Special Effects",
  "Aether",
  "The Occult",
  "The Illuminati",
  "The Zodiac",
  "Chaos",
  "Slam Dunking",
  "Parkour",
  "Cruelty",
  "Swimming",
  "Water Walking",
  "Lagging",
  "Respawning",
  "Debugging",
  "Tutoring",
  "Quarter-Life",
  "Half-Life",
  "Full Life Consequences",
  "Extra Suffixing",
  "Pokémon Menuing",
  "Pokédex Completing",
  "Dismembermert",
  "Screen Cheating",
  "Screen Shaking",
  "Doom",
  "Carmackian Speeches",
  "The Homeworld",
  "Danmaku",
  "Grazing",
  "Gun Kata",
  "Exploration",
  "Memory Thrashing",
  "Operational Systems",
  "Corrupt Database",
  "Federal Accusations",
  "Pokerfacing",
  "Handshaking",
  "Blade Works",
  "El Psy Congroo",
  "Sudoku",
}

local EXTRA_EFFECT = {
  'sparkle', 'flame', 'shock', 'puffs', 'bleeding', 'vortex', 'wisps'
}

function generator.generate(weaponname, blinglevel)
  local iterations = 0
  -- local numpref = 0
  local numsuf = 0
  local blingleft = blinglevel/4
  while blingleft >= 1 do
    iterations = iterations + 1
    blingleft = blingleft/4
  end
  local name = weaponname
  -- --print (weaponname)
  -- local name = prefixes[love.math.random(#prefixes)].." "..weaponname.." Of "..suffixes[love.math.random(#suffixes)]
  -- --print(name)
  for i = 1,iterations do
    if love.math.random() > 0.5 then
      --prefix
      name = prefixes[love.math.random(#prefixes)].." "..name
    elseif numsuf == 0 then
      name = name.." Of "..suffixes[love.math.random(#suffixes)]
      numsuf = 1
    else 
      name = name.." And "..suffixes[love.math.random(#suffixes)]
    end
    -- name = prefixes[love.math.random(#prefixes)].." "..name.." And "..suffixes[love.math.random(#suffixes)]
  end
  local extras = {}
  for i=1,math.floor(math.log(blinglevel)/2.5) do
    table.insert(extras, EXTRA_EFFECT[love.math.random(#EXTRA_EFFECT)])
  end
  return name, extras

end

return generator
