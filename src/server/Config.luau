local Config = {
	START_CASH = 100,
	PADS_PER_PLOT = 6,
	PLOT_COUNT = 8,
	LOCK_DURATION_SECONDS = 60,
	LOCK_SPAWN_PROTECTION_SECONDS = 30,
	MUTATIONS = {
		Gold = { Chance = 0.05, Multiplier = 2 },
		Diamond = { Chance = 0.02, Multiplier = 3 },
		Rainbow = { Chance = 0.008, Multiplier = 10 },
	},
	MUTATION_ROLL_ORDER = { "Rainbow", "Diamond", "Gold" },
	REBIRTH_BASE_COST = 50000,
	WAVE_PERIOD_SECONDS = 90,
	WAVE_WARNING_SECONDS = 10,
	WAVE_SWEEP_SECONDS = 7,
	WILD_TARGET_COUNT = 10,
	NORMAL_WALKSPEED = 16,
	CARRY_WALKSPEED = 11,
	DATASTORE_NAME = "BrainrotTideData_v1",
	RARITIES = {
		{ Name = "Common", Color = Color3.fromRGB(180, 180, 180) },
		{ Name = "Uncommon", Color = Color3.fromRGB(90, 200, 90) },
		{ Name = "Rare", Color = Color3.fromRGB(60, 140, 255) },
		{ Name = "Epic", Color = Color3.fromRGB(170, 80, 255) },
		{ Name = "Legendary", Color = Color3.fromRGB(255, 180, 40) },
		{ Name = "Mythic", Color = Color3.fromRGB(255, 70, 120) },
	},
	CHARACTERS = {
		{ Id = "croissant_boxer", Name = "Croissant Boxer", Rarity = "Common", Income = 1, Price = 50, Parts = {
			{ Shape = "Block", Size = Vector3.new(2.4, 1.5, 1.5), Offset = Vector3.new(0, 0.75, 0), Color = Color3.fromRGB(205, 145, 75), Rotation = Vector3.new(0, 0, -8) },
			{ Shape = "Block", Size = Vector3.new(1.8, 1.2, 1.3), Offset = Vector3.new(0, 1.45, 0), Color = Color3.fromRGB(240, 195, 115), Rotation = Vector3.new(0, 0, 12) },
			{ Shape = "Block", Size = Vector3.new(0.35, 1.1, 0.35), Offset = Vector3.new(-1.25, 1.45, 0), Color = Color3.fromRGB(205, 145, 75), Rotation = Vector3.new(0, 0, 30) },
			{ Shape = "Block", Size = Vector3.new(0.35, 1.1, 0.35), Offset = Vector3.new(1.25, 1.45, 0), Color = Color3.fromRGB(205, 145, 75), Rotation = Vector3.new(0, 0, -30) },
			{ Shape = "Ball", Size = Vector3.new(0.75, 0.75, 0.75), Offset = Vector3.new(-1.65, 1.9, 0), Color = Color3.fromRGB(220, 45, 55) },
			{ Shape = "Ball", Size = Vector3.new(0.75, 0.75, 0.75), Offset = Vector3.new(1.65, 1.9, 0), Color = Color3.fromRGB(220, 45, 55) },
		} },
		{ Id = "toaster_pup", Name = "Toaster Pup", Rarity = "Common", Income = 1, Price = 60, Parts = {
			{ Shape = "Block", Size = Vector3.new(2.4, 1.8, 1.7), Offset = Vector3.new(0, 0.9, 0), Color = Color3.fromRGB(175, 180, 188), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(1.6, 0.12, 0.3), Offset = Vector3.new(0, 1.86, 0), Color = Color3.fromRGB(55, 58, 64), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(0.45, 1.3, 0.35), Offset = Vector3.new(-1.2, 2.1, 0), Color = Color3.fromRGB(120, 125, 135), Rotation = Vector3.new(0, 0, 25) },
			{ Shape = "Block", Size = Vector3.new(0.45, 1.3, 0.35), Offset = Vector3.new(1.2, 2.1, 0), Color = Color3.fromRGB(120, 125, 135), Rotation = Vector3.new(0, 0, -25) },
			{ Shape = "Ball", Size = Vector3.new(0.9, 0.7, 0.7), Offset = Vector3.new(0, 1.1, -1.05), Color = Color3.fromRGB(205, 165, 130) },
			{ Shape = "Block", Size = Vector3.new(0.45, 0.4, 0.9), Offset = Vector3.new(0, 0.8, 1.1), Color = Color3.fromRGB(120, 125, 135), Rotation = Vector3.new(25, 0, 0) },
			{ Shape = "Block", Size = Vector3.new(0.55, 0.5, 0.65), Offset = Vector3.new(-0.8, 0.25, 0), Color = Color3.fromRGB(80, 85, 95) },
			{ Shape = "Block", Size = Vector3.new(0.55, 0.5, 0.65), Offset = Vector3.new(0.8, 0.25, 0), Color = Color3.fromRGB(80, 85, 95) },
		} },
		{ Id = "shark_sneakers", Name = "Shark in Sneakers", Rarity = "Uncommon", Income = 3, Price = 150, Parts = {
			{ Shape = "Ball", Size = Vector3.new(3.2, 1.5, 1.5), Offset = Vector3.new(0, 1.25, 0), Color = Color3.fromRGB(105, 135, 155) },
			{ Shape = "Block", Size = Vector3.new(0.55, 1.7, 0.25), Offset = Vector3.new(0, 2.45, 0.1), Color = Color3.fromRGB(85, 115, 140), Rotation = Vector3.new(0, 0, -12) },
			{ Shape = "Block", Size = Vector3.new(0.45, 0.9, 0.25), Offset = Vector3.new(1.8, 1.4, 0), Color = Color3.fromRGB(85, 115, 140), Rotation = Vector3.new(0, 0, -35) },
			{ Shape = "Ball", Size = Vector3.new(0.22, 0.22, 0.22), Offset = Vector3.new(-0.8, 1.65, -0.72), Color = Color3.fromRGB(15, 20, 25), KeepColor = true },
			{ Shape = "Block", Size = Vector3.new(1, 0.45, 1.5), Offset = Vector3.new(-0.8, 0.35, 0), Color = Color3.fromRGB(245, 245, 250) },
			{ Shape = "Block", Size = Vector3.new(1, 0.45, 1.5), Offset = Vector3.new(0.8, 0.35, 0), Color = Color3.fromRGB(245, 245, 250) },
		} },
		{ Id = "banana_butler", Name = "Banana Butler", Rarity = "Uncommon", Income = 4, Price = 200, Parts = {
			{ Shape = "Ball", Size = Vector3.new(1.5, 2.8, 1.2), Offset = Vector3.new(0, 1.4, 0), Color = Color3.fromRGB(255, 220, 35), Rotation = Vector3.new(0, 0, -12) },
			{ Shape = "Block", Size = Vector3.new(0.35, 1, 0.35), Offset = Vector3.new(-0.45, 2.7, 0), Color = Color3.fromRGB(255, 235, 70), Rotation = Vector3.new(0, 0, 35) },
			{ Shape = "Block", Size = Vector3.new(0.35, 1, 0.35), Offset = Vector3.new(0.4, 2.65, 0), Color = Color3.fromRGB(255, 235, 70), Rotation = Vector3.new(0, 0, -35) },
			{ Shape = "Block", Size = Vector3.new(0.7, 0.45, 0.18), Offset = Vector3.new(0, 1.8, -0.58), Color = Color3.fromRGB(20, 20, 25) },
			{ Shape = "Ball", Size = Vector3.new(0.6, 0.6, 0.6), Offset = Vector3.new(-1, 1.1, 0), Color = Color3.fromRGB(250, 250, 245) },
			{ Shape = "Ball", Size = Vector3.new(0.6, 0.6, 0.6), Offset = Vector3.new(1, 1.1, 0), Color = Color3.fromRGB(250, 250, 245) },
		} },
		{ Id = "cactus_cowboy", Name = "Cactus Cowboy", Rarity = "Rare", Income = 9, Price = 550, Parts = {
			{ Shape = "Cylinder", Size = Vector3.new(2.5, 1.4, 1.4), Offset = Vector3.new(0, 1.25, 0), Color = Color3.fromRGB(55, 155, 75) },
			{ Shape = "Cylinder", Size = Vector3.new(1.4, 0.4, 0.4), Offset = Vector3.new(-1, 2.1, 0), Color = Color3.fromRGB(70, 175, 85), Rotation = Vector3.new(0, 0, -55) },
			{ Shape = "Cylinder", Size = Vector3.new(1.4, 0.4, 0.4), Offset = Vector3.new(1, 2.1, 0), Color = Color3.fromRGB(70, 175, 85), Rotation = Vector3.new(0, 0, 55) },
			{ Shape = "Cylinder", Size = Vector3.new(0.25, 2.8, 2.8), Offset = Vector3.new(0, 2.65, 0), Color = Color3.fromRGB(110, 70, 40) },
			{ Shape = "Cylinder", Size = Vector3.new(0.9, 1, 1), Offset = Vector3.new(0, 3.15, 0), Color = Color3.fromRGB(135, 90, 50) },
			{ Shape = "Ball", Size = Vector3.new(0.38, 0.38, 0.38), Offset = Vector3.new(0.55, 2.7, -0.8), Color = Color3.fromRGB(255, 100, 175) },
		} },
		{ Id = "fridge_penguin", Name = "Fridge Penguin", Rarity = "Rare", Income = 11, Price = 700, Parts = {
			{ Shape = "Block", Size = Vector3.new(2, 2.8, 1.5), Offset = Vector3.new(0, 1.4, 0), Color = Color3.fromRGB(245, 245, 240) },
			{ Shape = "Block", Size = Vector3.new(0.2, 2.8, 1.55), Offset = Vector3.new(-0.9, 1.4, 0), Color = Color3.fromRGB(30, 35, 45) },
			{ Shape = "Block", Size = Vector3.new(1.25, 1.5, 0.15), Offset = Vector3.new(0, 1.1, -0.82), Color = Color3.fromRGB(255, 255, 250) },
			{ Shape = "Block", Size = Vector3.new(0.12, 1.1, 0.12), Offset = Vector3.new(0.68, 1.8, -0.9), Color = Color3.fromRGB(70, 70, 75), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(0.6, 0.35, 0.55), Offset = Vector3.new(0, 2.1, -0.9), Color = Color3.fromRGB(255, 140, 25), Rotation = Vector3.new(0, 0, 8) },
			{ Shape = "Block", Size = Vector3.new(0.85, 0.35, 0.75), Offset = Vector3.new(-0.55, 0.2, 0), Color = Color3.fromRGB(255, 140, 25) },
			{ Shape = "Block", Size = Vector3.new(0.85, 0.35, 0.75), Offset = Vector3.new(0.55, 0.2, 0), Color = Color3.fromRGB(255, 140, 25) },
		} },
		{ Id = "disco_mushroom", Name = "Disco Mushroom", Rarity = "Epic", Income = 24, Price = 1900, Parts = {
			{ Shape = "Cylinder", Size = Vector3.new(2.5, 1.1, 1.1), Offset = Vector3.new(0, 1.25, 0), Color = Color3.fromRGB(245, 225, 190) },
			{ Shape = "Ball", Size = Vector3.new(3.8, 1.2, 3.2), Offset = Vector3.new(0, 2.85, 0), Color = Color3.fromRGB(220, 55, 70) },
			{ Shape = "Ball", Size = Vector3.new(0.55, 0.55, 0.55), Offset = Vector3.new(-0.9, 3.25, -0.85), Color = Color3.fromRGB(255, 255, 245), KeepColor = true },
			{ Shape = "Ball", Size = Vector3.new(0.5, 0.5, 0.5), Offset = Vector3.new(0.8, 3.35, -0.8), Color = Color3.fromRGB(255, 255, 245), KeepColor = true },
			{ Shape = "Ball", Size = Vector3.new(0.5, 0.5, 0.5), Offset = Vector3.new(0, 3.4, 0.75), Color = Color3.fromRGB(255, 255, 245), KeepColor = true },
			{ Shape = "Ball", Size = Vector3.new(0.25, 0.25, 0.25), Offset = Vector3.new(1.55, 2.2, 0), Color = Color3.fromRGB(100, 210, 255), KeepColor = true, Material = Enum.Material.Neon },
		} },
		{ Id = "robo_noodle", Name = "Robo Noodle", Rarity = "Epic", Income = 30, Price = 2400, Parts = {
			{ Shape = "Ball", Size = Vector3.new(2.6, 0.8, 2.1), Offset = Vector3.new(0, 0.6, 0), Color = Color3.fromRGB(190, 65, 50) },
			{ Shape = "Block", Size = Vector3.new(2, 1.8, 1.6), Offset = Vector3.new(0, 2, 0), Color = Color3.fromRGB(130, 140, 150), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(1.5, 0.75, 0.12), Offset = Vector3.new(0, 2, -0.86), Color = Color3.fromRGB(20, 220, 255), KeepColor = true, Material = Enum.Material.Neon },
			{ Shape = "Cylinder", Size = Vector3.new(0.8, 0.12, 0.12), Offset = Vector3.new(0, 3.25, 0), Color = Color3.fromRGB(100, 110, 120), Material = Enum.Material.Metal },
			{ Shape = "Ball", Size = Vector3.new(0.35, 0.35, 0.35), Offset = Vector3.new(0, 3.65, 0), Color = Color3.fromRGB(255, 80, 100), KeepColor = true, Material = Enum.Material.Neon },
			{ Shape = "Cylinder", Size = Vector3.new(1.4, 0.18, 0.18), Offset = Vector3.new(-1.4, 1.7, 0), Color = Color3.fromRGB(240, 205, 90), Rotation = Vector3.new(0, 0, 45) },
			{ Shape = "Cylinder", Size = Vector3.new(1.4, 0.18, 0.18), Offset = Vector3.new(1.4, 1.7, 0), Color = Color3.fromRGB(240, 205, 90), Rotation = Vector3.new(0, 0, -45) },
			{ Shape = "Block", Size = Vector3.new(0.15, 1.6, 0.15), Offset = Vector3.new(0.45, 3, 0), Color = Color3.fromRGB(70, 45, 30), Rotation = Vector3.new(0, 0, 8) },
		} },
		{ Id = "dragon_taco", Name = "Dragon Taco", Rarity = "Legendary", Income = 70, Price = 6800, Parts = {
			{ Shape = "Block", Size = Vector3.new(2.8, 1.6, 1.4), Offset = Vector3.new(0, 0.8, 0), Color = Color3.fromRGB(220, 160, 75), Rotation = Vector3.new(0, 0, -12) },
			{ Shape = "Block", Size = Vector3.new(2.8, 1.5, 1.3), Offset = Vector3.new(0, 1.45, 0), Color = Color3.fromRGB(235, 185, 95), Rotation = Vector3.new(0, 0, 12) },
			{ Shape = "Block", Size = Vector3.new(1.4, 1.2, 1.2), Offset = Vector3.new(0, 2.3, -0.35), Color = Color3.fromRGB(55, 160, 70) },
			{ Shape = "Cylinder", Size = Vector3.new(0.8, 0.25, 0.25), Offset = Vector3.new(-0.45, 3, -0.4), Color = Color3.fromRGB(245, 240, 210), Rotation = Vector3.new(0, 0, 25) },
			{ Shape = "Cylinder", Size = Vector3.new(0.8, 0.25, 0.25), Offset = Vector3.new(0.45, 3, -0.4), Color = Color3.fromRGB(245, 240, 210), Rotation = Vector3.new(0, 0, -25) },
			{ Shape = "Block", Size = Vector3.new(1.5, 1.4, 0.25), Offset = Vector3.new(-1.4, 2, 0.35), Color = Color3.fromRGB(120, 60, 155), Rotation = Vector3.new(0, 0, 25) },
			{ Shape = "Block", Size = Vector3.new(1.5, 1.4, 0.25), Offset = Vector3.new(1.4, 2, 0.35), Color = Color3.fromRGB(120, 60, 155), Rotation = Vector3.new(0, 0, -25) },
			{ Shape = "Ball", Size = Vector3.new(0.7, 0.5, 0.5), Offset = Vector3.new(0, 1.6, -1), Color = Color3.fromRGB(80, 190, 65) },
		} },
		{ Id = "wizard_baguette", Name = "Wizard Baguette", Rarity = "Legendary", Income = 85, Price = 8200, Parts = {
			{ Shape = "Ball", Size = Vector3.new(1.2, 3.5, 1.1), Offset = Vector3.new(0, 1.75, 0), Color = Color3.fromRGB(210, 160, 90), Rotation = Vector3.new(0, 0, -10) },
			{ Shape = "Cylinder", Size = Vector3.new(1.8, 1.2, 1.2), Offset = Vector3.new(0, 3.5, 0), Color = Color3.fromRGB(100, 55, 170), Rotation = Vector3.new(0, 0, -20) },
			{ Shape = "Ball", Size = Vector3.new(0.5, 0.5, 0.5), Offset = Vector3.new(0.55, 4.15, 0), Color = Color3.fromRGB(255, 220, 70), KeepColor = true },
			{ Shape = "Block", Size = Vector3.new(1.1, 0.9, 0.3), Offset = Vector3.new(0, 2.1, -0.55), Color = Color3.fromRGB(245, 240, 225) },
			{ Shape = "Cylinder", Size = Vector3.new(2.1, 0.16, 0.16), Offset = Vector3.new(1.2, 1.8, 0), Color = Color3.fromRGB(95, 55, 35), Rotation = Vector3.new(0, 0, 65) },
			{ Shape = "Ball", Size = Vector3.new(0.42, 0.42, 0.42), Offset = Vector3.new(2.1, 2.7, 0), Color = Color3.fromRGB(100, 220, 255), KeepColor = true, Material = Enum.Material.Neon },
		} },
		{ Id = "galaxy_lobster", Name = "Galaxy Lobster", Rarity = "Mythic", Income = 210, Price = 26000, Parts = {
			{ Shape = "Ball", Size = Vector3.new(1.55, 1.6, 1.5), Offset = Vector3.new(0, 0.8, 0), Color = Color3.fromRGB(90, 35, 145) },
			{ Shape = "Ball", Size = Vector3.new(1.5, 1.55, 1.45), Offset = Vector3.new(0, 1.95, 0), Color = Color3.fromRGB(115, 45, 180) },
			{ Shape = "Ball", Size = Vector3.new(1.35, 1.4, 1.35), Offset = Vector3.new(0, 3.05, 0), Color = Color3.fromRGB(90, 35, 145) },
			{ Shape = "Ball", Size = Vector3.new(1.35, 1.35, 1.2), Offset = Vector3.new(-1.15, 1.5, -0.5), Color = Color3.fromRGB(180, 45, 95) },
			{ Shape = "Block", Size = Vector3.new(0.35, 0.7, 0.35), Offset = Vector3.new(-1.65, 2.05, -0.6), Color = Color3.fromRGB(220, 65, 115), Rotation = Vector3.new(0, 0, 25) },
			{ Shape = "Cylinder", Size = Vector3.new(1.8, 0.12, 0.12), Offset = Vector3.new(-0.45, 4.05, 0), Color = Color3.fromRGB(160, 95, 220), Rotation = Vector3.new(0, 0, -35) },
			{ Shape = "Cylinder", Size = Vector3.new(1.8, 0.12, 0.12), Offset = Vector3.new(0.45, 4.05, 0), Color = Color3.fromRGB(160, 95, 220), Rotation = Vector3.new(0, 0, 35) },
			{ Shape = "Ball", Size = Vector3.new(0.22, 0.22, 0.22), Offset = Vector3.new(0, 3.2, -0.75), Color = Color3.fromRGB(255, 255, 255), KeepColor = true, Material = Enum.Material.Neon },
		} },
		{ Id = "tv_titan", Name = "TV Head Titan", Rarity = "Mythic", Income = 260, Price = 32000, Parts = {
			{ Shape = "Block", Size = Vector3.new(2.3, 2.5, 1.8), Offset = Vector3.new(0, 1.25, 0), Color = Color3.fromRGB(105, 115, 130), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(0.7, 2.5, 0.8), Offset = Vector3.new(-1.65, 1.5, 0), Color = Color3.fromRGB(125, 135, 150), Rotation = Vector3.new(0, 0, 12) },
			{ Shape = "Block", Size = Vector3.new(0.7, 2.5, 0.8), Offset = Vector3.new(1.65, 1.5, 0), Color = Color3.fromRGB(125, 135, 150), Rotation = Vector3.new(0, 0, -12) },
			{ Shape = "Block", Size = Vector3.new(2.8, 2.1, 1.6), Offset = Vector3.new(0, 3.55, 0), Color = Color3.fromRGB(35, 40, 55), Material = Enum.Material.Metal },
			{ Shape = "Block", Size = Vector3.new(2.35, 1.45, 0.12), Offset = Vector3.new(0, 3.55, -0.86), Color = Color3.fromRGB(20, 230, 255), KeepColor = true, Material = Enum.Material.Neon },
			{ Shape = "Cylinder", Size = Vector3.new(1.3, 0.12, 0.12), Offset = Vector3.new(-0.55, 4.8, 0), Color = Color3.fromRGB(100, 110, 125), Rotation = Vector3.new(0, 0, -25) },
			{ Shape = "Cylinder", Size = Vector3.new(1.3, 0.12, 0.12), Offset = Vector3.new(0.55, 4.8, 0), Color = Color3.fromRGB(100, 110, 125), Rotation = Vector3.new(0, 0, 25) },
		} },
	},
	EGG_TIERS = {
		{ Name = "Basic Egg", Price = 200, Color = Color3.fromRGB(245, 222, 160), Weights = { Common = 55, Uncommon = 30, Rare = 11, Epic = 3.5, Legendary = 0.5, Mythic = 0 } },
		{ Name = "Shiny Egg", Price = 1200, Color = Color3.fromRGB(140, 220, 255), Weights = { Common = 0, Uncommon = 45, Rare = 35, Epic = 15, Legendary = 4.5, Mythic = 0.5 } },
		{ Name = "Royal Egg", Price = 6000, Color = Color3.fromRGB(255, 170, 60), Weights = { Common = 0, Uncommon = 0, Rare = 40, Epic = 35, Legendary = 20, Mythic = 5 } },
	},
	WILD_WEIGHTS = { Common = 52, Uncommon = 28, Rare = 12, Epic = 5.5, Legendary = 2, Mythic = 0.5 },
}

Config.RARITY_ORDER = {}
local rarityColors = {}
for index, rarity in ipairs(Config.RARITIES) do
	Config.RARITY_ORDER[rarity.Name] = index
	rarityColors[rarity.Name] = rarity.Color
end

Config.CHARACTERS_BY_ID = {}
for _, def in ipairs(Config.CHARACTERS) do
	def.RarityColor = rarityColors[def.Rarity]
	Config.CHARACTERS_BY_ID[def.Id] = def
end

return Config
