local WorldBuilder = {}

local function makePart(parent, name, size, cframe, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Anchored = true
	part.CanCollide = true
	part.CanQuery = true
	part.CanTouch = true
	part.Parent = parent
	return part
end

local function makeDisc(parent, name, diameter, height, centerY, color, material)
	return makePart(parent, name, Vector3.new(height, diameter, diameter),
		CFrame.new(0, centerY, 0) * CFrame.Angles(0, 0, math.rad(90)), color, material or Enum.Material.SmoothPlastic)
end

local function makeBillboard(adornee, name, text, size, fontSize)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	billboard.Adornee = adornee
	billboard.Size = UDim2.fromOffset(size.X, size.Y)
	billboard.StudsOffset = Vector3.new(0, 0.5, 0)
	billboard.LightInfluence = 0
	billboard.Parent = adornee
	local label = Instance.new("TextLabel")
	label.Name = name == "OwnerSign" and "SignText" or "SignText"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.TextSize = fontSize
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.3
	label.Text = text
	label.Parent = billboard
	return billboard, label
end

local function rollBetween(low, high)
	return low + math.random() * (high - low)
end

function WorldBuilder.Build()
	local worldFolder = Instance.new("Folder")
	worldFolder.Name = "BrainrotWorld"
	worldFolder.Parent = workspace

	local water = makePart(worldFolder, "Water", Vector3.new(1600, 2, 1600), CFrame.new(0, -3.4, 0), Color3.fromRGB(38, 110, 210), Enum.Material.Glass)
	water.Transparency = 0.3
	water.CanCollide = false
	makeDisc(worldFolder, "Beach", 424, 3, -3.2, Color3.fromRGB(233, 206, 150), Enum.Material.Sand)
	makeDisc(worldFolder, "Grass", 400, 4, -2, Color3.fromRGB(94, 186, 82), Enum.Material.Grass)
	makeDisc(worldFolder, "Plaza", 64, 0.6, 0.3, Color3.fromRGB(158, 158, 164), Enum.Material.Concrete)

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PlazaSpawn"
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.Position = Vector3.new(0, 0.8, 0)
	spawn.Transparency = 1
	spawn.CanCollide = false
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.Parent = worldFolder

	local plotColors = {
		Color3.fromRGB(244, 164, 164), Color3.fromRGB(244, 196, 132),
		Color3.fromRGB(240, 230, 150), Color3.fromRGB(168, 226, 160),
		Color3.fromRGB(150, 210, 235), Color3.fromRGB(170, 175, 245),
		Color3.fromRGB(225, 170, 235), Color3.fromRGB(245, 190, 205),
	}
	local plots = {}
	for index = 1, 8 do
		local angle = math.rad((index - 1) * 45)
		local center = Vector3.new(math.sin(angle) * 128, 0, math.cos(angle) * 128)
		local plotCFrame = CFrame.lookAt(center, Vector3.new(0, 0, 0))
		local color = plotColors[index]
		local trimColor = Color3.fromRGB(math.floor(color.R * 255 * 0.75), math.floor(color.G * 255 * 0.75), math.floor(color.B * 255 * 0.75))
		local plotFolder = Instance.new("Folder")
		plotFolder.Name = "Plot" .. index
		plotFolder.Parent = worldFolder
		makePart(plotFolder, "Trim", Vector3.new(49, 0.5, 49), plotCFrame * CFrame.new(0, 0.25, 0), trimColor, Enum.Material.Neon)
		local platform = makePart(plotFolder, "Platform", Vector3.new(46, 1.2, 46), plotCFrame * CFrame.new(0, 0.85, 0), color)
		local walls = {}
		for _, wallData in ipairs({
			{ Vector3.new(0.6, 7, 47), CFrame.new(-23.4, 4.7, 0) },
			{ Vector3.new(0.6, 7, 47), CFrame.new(23.4, 4.7, 0) },
			{ Vector3.new(47, 7, 0.6), CFrame.new(0, 4.7, -23.4) },
			{ Vector3.new(47, 7, 0.6), CFrame.new(0, 4.7, 23.4) },
		}) do
			local wall = makePart(plotFolder, "SafeWall", wallData[1], plotCFrame * wallData[2], color)
			wall.Transparency = 0.78
			wall.CanCollide = false
			table.insert(walls, wall)
		end
		makePart(plotFolder, "OwnerSignPost", Vector3.new(0.6, 4.4, 0.6), plotCFrame * CFrame.new(0, 3.6, 19), Color3.fromRGB(105, 80, 60))
		local signBoard = makePart(plotFolder, "OwnerSignBoard", Vector3.new(11, 3.4, 0.5), plotCFrame * CFrame.new(0, 6.2, 19), Color3.fromRGB(60, 50, 45))
		local _, signText = makeBillboard(signBoard, "OwnerSign", "EMPTY BASE", Vector2.new(240, 60), 20)
		makePart(plotFolder, "LockPost", Vector3.new(0.45, 2.4, 0.45), plotCFrame * CFrame.new(7.5, 2.65, -19), Color3.fromRGB(70, 70, 78))
		local lockButton = makePart(plotFolder, "LockButton", Vector3.new(1.7, 0.45, 1.7), plotCFrame * CFrame.new(7.5, 4.05, -19), Color3.fromRGB(255, 200, 40), Enum.Material.Neon)
		local pads = {}
		for _, z in ipairs({ -8, 8 }) do
			for _, x in ipairs({ -11.5, 0, 11.5 }) do
				local pad = makePart(plotFolder, "DisplayPad", Vector3.new(6.4, 0.8, 6.4), plotCFrame * CFrame.new(x, 1.85, z), Color3.fromRGB(238, 238, 238))
				makePart(plotFolder, "PadInset", Vector3.new(5.2, 0.25, 5.2), plotCFrame * CFrame.new(x, 2.32, z), Color3.fromRGB(200, 200, 205))
				table.insert(pads, pad)
			end
		end
		plots[index] = {
			Index = index,
			CFrame = plotCFrame,
			Center = center,
			Platform = platform,
			Pads = pads,
			SignText = signText,
			SpawnPosition = plotCFrame * Vector3.new(0, 3.2, -17),
			Folder = plotFolder,
			Walls = walls,
			WallColor = color,
			LockButton = lockButton,
		}
	end

	-- Dressing: cobblestone paths from the plaza to every base, glowing lamps, bushes.
	for index = 1, 8 do
		local angle = math.rad((index - 1) * 45)
		local mid = Vector3.new(math.sin(angle) * 68, 0.1, math.cos(angle) * 68)
		local path = makePart(worldFolder, "Path", Vector3.new(6, 0.2, 74), CFrame.lookAt(mid, Vector3.new(0, 0.1, 0)), Color3.fromRGB(178, 164, 140), Enum.Material.Cobblestone)
		path.CanCollide = false
	end
	for index = 1, 6 do
		local angle = math.rad((index - 1) * 60 + 30)
		local x, z = math.sin(angle) * 40, math.cos(angle) * 40
		makePart(worldFolder, "LampPost", Vector3.new(0.35, 7, 0.35), CFrame.new(x, 3.5, z), Color3.fromRGB(50, 50, 58))
		local lamp = makePart(worldFolder, "LampGlow", Vector3.new(1.15, 1.15, 1.15), CFrame.new(x, 7.3, z), Color3.fromRGB(255, 236, 180), Enum.Material.Neon)
		lamp.Shape = Enum.PartType.Ball
		lamp.CanCollide = false
	end
	for index = 1, 12 do
		local angle = math.rad((index - 1) * 30 + 15)
		local radius = rollBetween(146, 182)
		local bush = makePart(worldFolder, "Bush", Vector3.new(rollBetween(2.4, 4), rollBetween(1.8, 3), rollBetween(2.4, 4)), CFrame.new(math.sin(angle) * radius, 0.6, math.cos(angle) * radius), Color3.fromRGB(52, 140, 60))
		bush.Shape = Enum.PartType.Ball
	end

	math.randomseed(2026)
	for index = 1, 14 do
		local angle = math.rad((index - 1) * (360 / 14) + rollBetween(-5, 5))
		local radius = rollBetween(162, 186)
		local x, z = math.sin(angle) * radius, math.cos(angle) * radius
		local trunk = makePart(worldFolder, "PalmTrunk", Vector3.new(8, 0.9, 0.9), CFrame.new(x, 4, z) * CFrame.Angles(0, 0, math.rad(12)), Color3.fromRGB(140, 100, 60))
		trunk.Shape = Enum.PartType.Cylinder
		for leafIndex = 1, 4 do
			local yaw = math.rad((leafIndex - 1) * 90 + index * 11)
			local leafOffset = Vector3.new(math.cos(yaw) * 2.3, 7.5, math.sin(yaw) * 2.3)
			local leaf = makePart(worldFolder, "PalmCrown", Vector3.new(6, 0.7, 2.4), CFrame.new(x, 0, z) * CFrame.new(leafOffset) * CFrame.Angles(math.rad(18), yaw, math.rad(12)), Color3.fromRGB(60, 160, 70))
			leaf.Shape = Enum.PartType.Ball
		end
	end
	for index = 1, 10 do
		local angle = math.rad((index - 1) * 36 + 18)
		local radius = rollBetween(48, 100)
		local rock = makePart(worldFolder, "Rock", Vector3.new(rollBetween(2, 4), rollBetween(1.2, 2), rollBetween(2, 4)), CFrame.new(math.sin(angle) * radius, 0.2, math.cos(angle) * radius), Color3.fromRGB(130, 130, 135))
		rock.Shape = Enum.PartType.Ball
	end
	local flowerColors = { Color3.fromRGB(255, 90, 120), Color3.fromRGB(255, 220, 80), Color3.fromRGB(150, 120, 255), Color3.fromRGB(255, 255, 255) }
	for index = 1, 24 do
		local angle = math.rad(index * 137.5)
		local radius = rollBetween(44, 100)
		local flower = makePart(worldFolder, "Flower", Vector3.new(0.5, 0.5, 0.5), CFrame.new(math.sin(angle) * radius, 0.35, math.cos(angle) * radius), flowerColors[(index - 1) % #flowerColors + 1])
		flower.Shape = Enum.PartType.Ball
	end
	for index = 1, 5 do
		local cloudCenter = Vector3.new(rollBetween(-160, 160), rollBetween(55, 70), rollBetween(-160, 160))
		for puffIndex = 1, 3 do
			local puff = makePart(worldFolder, "Cloud", Vector3.new(10, 2.5, 6), CFrame.new(cloudCenter + Vector3.new((puffIndex - 2) * 5, (puffIndex % 2) * 1.2, 0)), Color3.new(1, 1, 1))
			puff.Shape = Enum.PartType.Ball
			puff.Transparency = 0.15
			puff.CanCollide = false
		end
	end

	local shopCFrame = CFrame.lookAt(Vector3.new(26, 0, 20), Vector3.new(0, 0, 20))
	makePart(worldFolder, "EggShopCounter", Vector3.new(11, 2.6, 3), shopCFrame * CFrame.new(0, 1.3, 0), Color3.fromRGB(150, 100, 60))
	for _, x in ipairs({ -5.2, 5.2 }) do
		makePart(worldFolder, "EggShopPost", Vector3.new(0.5, 5.4, 0.5), shopCFrame * CFrame.new(x, 2.7, 0), Color3.fromRGB(130, 85, 55))
	end
	makePart(worldFolder, "EggShopRoof", Vector3.new(13, 0.5, 7.5), shopCFrame * CFrame.new(0, 5.6, 0), Color3.fromRGB(230, 90, 90))
	local shopSign = makePart(worldFolder, "EggShopSign", Vector3.new(8.5, 1.9, 0.4), shopCFrame * CFrame.new(0, 4.3, -1.8), Color3.fromRGB(125, 55, 55))
	makeBillboard(shopSign, "EggShopSignGui", "EGG SHOP", Vector2.new(240, 70), 22)
	local pedestals = {}
	for tierIndex, x in ipairs({ -7.5, 0, 7.5 }) do
		local pedestal = makePart(worldFolder, "EggPedestal", Vector3.new(1.5, 3.6, 3.6), shopCFrame * CFrame.new(x, 0.75, -6.5) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(120, 120, 128))
		pedestal.Shape = Enum.PartType.Cylinder
		pedestals[tierIndex] = { TierIndex = tierIndex, Part = pedestal, DisplayCFrame = shopCFrame * CFrame.new(x, 1.5 + 1.4, -6.5) }
	end

	local shrineCFrame = CFrame.lookAt(Vector3.new(-26, 0, 20), Vector3.new(0, 0, 20))
	local shrinePedestal = makePart(worldFolder, "RebirthPedestal", Vector3.new(1.2, 4.2, 4.2), shrineCFrame * CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(70, 60, 90))
	shrinePedestal.Shape = Enum.PartType.Cylinder
	local crystal = makePart(worldFolder, "RebirthCrystal", Vector3.new(2.6, 4.2, 2.6), shrineCFrame * CFrame.new(0, 3.3, 0), Color3.fromRGB(175, 85, 255), Enum.Material.Neon)
	crystal.Shape = Enum.PartType.Ball
	makeBillboard(crystal, "RebirthSign", "REBIRTH", Vector2.new(220, 60), 20)

	return {
		Folder = worldFolder,
		Plots = plots,
		PlazaSpawnCFrame = CFrame.new(0, 3.5, 0),
		WildInnerRadius = 40,
		WildOuterRadius = 104,
		ShopPedestals = pedestals,
		RebirthAnchor = crystal,
	}
end

return WorldBuilder
