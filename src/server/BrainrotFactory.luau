local Config = require(script.Parent:WaitForChild("Config"))

local BrainrotFactory = {}

local function makeNameTag(parent, title, subtitle, color, topY)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTag"
	billboard.Adornee = parent
	billboard.Size = UDim2.fromOffset(220, 56)
	billboard.StudsOffset = Vector3.new(0, topY + 1.1, 0)
	billboard.MaxDistance = 70
	billboard.LightInfluence = 0
	billboard.Parent = parent

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, 0, 0, 30)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.FredokaOne
	nameLabel.TextSize = 17
	nameLabel.Text = title
	nameLabel.TextColor3 = color
	nameLabel.TextStrokeTransparency = 0.4
	nameLabel.Parent = billboard

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, 0, 0, 22)
	infoLabel.Position = UDim2.new(0, 0, 0, 28)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Font = Enum.Font.GothamBold
	infoLabel.TextSize = 14
	infoLabel.TextColor3 = Color3.new(1, 1, 1)
	infoLabel.TextStrokeTransparency = 0.4
	infoLabel.Text = subtitle
	infoLabel.Parent = billboard
	return billboard
end

function BrainrotFactory.CreateFigure(def, gold)
	if type(def) ~= "table" or type(def.Parts) ~= "table" or #def.Parts == 0 then
		return nil
	end
	local model = Instance.new("Model")
	model.Name = def.Id
	local topY = 0
	local rootPart
	for index, spec in ipairs(def.Parts) do
		local part = Instance.new("Part")
		part.Name = spec.Name or ("Part" .. index)
		if spec.Shape == "Ball" then
			part.Shape = Enum.PartType.Ball
		elseif spec.Shape == "Cylinder" then
			part.Shape = Enum.PartType.Cylinder
		else
			part.Shape = Enum.PartType.Block
		end
		part.Size = spec.Size
		part.Color = if gold and not spec.KeepColor then Color3.fromRGB(255, 190, 40) else spec.Color
		part.Material = if gold and not spec.KeepColor then Enum.Material.Metal else (spec.Material or Enum.Material.SmoothPlastic)
		part.Transparency = spec.Transparency or 0
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		local rotation = spec.Rotation or Vector3.zero
		part.CFrame = CFrame.new(spec.Offset) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
		part.Parent = model
		if index == 1 then
			rootPart = part
		end
		topY = math.max(topY, spec.Offset.Y + spec.Size.Y / 2)
	end
	if not rootPart then
		model:Destroy()
		return nil
	end
	model.PrimaryPart = rootPart
	local effectiveIncome = def.Income * (gold and Config.GOLD_INCOME_MULTIPLIER or 1)
	makeNameTag(rootPart, (gold and "★ " or "") .. def.Name, string.format("$%d/s", effectiveIncome), def.RarityColor, topY)
	model:SetAttribute("BrainrotId", def.Id)
	model:SetAttribute("Rarity", def.Rarity)
	model:SetAttribute("Income", effectiveIncome)
	model:SetAttribute("Price", def.Price)
	model:SetAttribute("Gold", gold == true)
	return model
end

function BrainrotFactory.CreateEgg(tierDef)
	if type(tierDef) ~= "table" then
		return nil
	end
	local model = Instance.new("Model")
	model.Name = tierDef.Name
	local egg = Instance.new("Part")
	egg.Name = "Egg"
	egg.Shape = Enum.PartType.Ball
	egg.Size = Vector3.new(2.2, 2.8, 2.2)
	egg.Color = tierDef.Color
	egg.Material = Enum.Material.SmoothPlastic
	egg.Anchored = true
	egg.CanCollide = false
	egg.CanQuery = false
	egg.CanTouch = false
	egg.CFrame = CFrame.new(0, 1.4, 0)
	egg.Parent = model
	model.PrimaryPart = egg

	local spots = {
		Vector3.new(-0.55, 0.35, -0.87), Vector3.new(0.55, 0.35, -0.87),
		Vector3.new(-0.8, 1.05, -0.5), Vector3.new(0.8, 1.05, -0.5),
		Vector3.new(-0.48, 1.85, -0.55), Vector3.new(0.48, 1.85, -0.55),
	}
	for index, offset in ipairs(spots) do
		local spot = Instance.new("Part")
		spot.Name = "Spot" .. index
		spot.Shape = Enum.PartType.Ball
		spot.Size = Vector3.new(0.45, 0.45, 0.45)
		spot.Color = Color3.new(1, 1, 1)
		spot.Material = Enum.Material.SmoothPlastic
		spot.Anchored = true
		spot.CanCollide = false
		spot.CanQuery = false
		spot.CanTouch = false
		spot.CFrame = CFrame.new(offset)
		spot.Parent = model
	end
	makeNameTag(egg, tierDef.Name, "$" .. tostring(tierDef.Price), Color3.new(1, 1, 1), 2.8)
	return model
end

return BrainrotFactory
