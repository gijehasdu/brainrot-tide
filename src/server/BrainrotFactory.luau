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

local MUTATION_TINTS = {
	Gold = { Color = Color3.fromRGB(255, 190, 40), Material = Enum.Material.Metal, Transparency = 0 },
	Diamond = { Color = Color3.fromRGB(140, 225, 255), Material = Enum.Material.Glass, Transparency = 0.15 },
	Rainbow = { Color = Color3.fromRGB(255, 90, 90), Material = Enum.Material.SmoothPlastic, Transparency = 0 },
}

function BrainrotFactory.CreateFigure(def, mutation)
	if type(def) ~= "table" or type(def.Parts) ~= "table" or #def.Parts == 0 then
		return nil
	end
	local tint = mutation and MUTATION_TINTS[mutation] or nil
	local model = Instance.new("Model")
	model.Name = def.Id
	local topY = 0
	local rootPart
	for index, spec in ipairs(def.Parts) do
		local part = Instance.new("Part")
		local tinted = tint ~= nil and not spec.KeepColor
		part.Name = tinted and "TintPart" or (spec.Name or ("Part" .. index))
		if spec.Shape == "Ball" then
			part.Shape = Enum.PartType.Ball
		elseif spec.Shape == "Cylinder" then
			part.Shape = Enum.PartType.Cylinder
		else
			part.Shape = Enum.PartType.Block
		end
		part.Size = spec.Size
		part.Color = tinted and tint.Color or spec.Color
		part.Material = tinted and tint.Material or (spec.Material or Enum.Material.SmoothPlastic)
		part.Transparency = tinted and tint.Transparency or (spec.Transparency or 0)
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
	-- A simple friendly face on the front (-Z) of the root part: two eyes and a smile.
	local rootSpec = def.Parts[1]
	local rs, ro = rootSpec.Size, rootSpec.Offset
	local faceZ = ro.Z - rs.Z / 2
	local function facePart(shape, size, offset, color)
		local p = Instance.new("Part")
		p.Name = "FacePart"
		p.Shape = shape
		p.Size = size
		p.Color = color
		p.Material = Enum.Material.SmoothPlastic
		p.Anchored = true
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.CFrame = CFrame.new(offset)
		p.Parent = model
		return p
	end
	for _, side in ipairs({ -1, 1 }) do
		local eyePos = Vector3.new(ro.X + side * rs.X * 0.21, ro.Y + rs.Y * 0.16, faceZ - 0.04)
		facePart(Enum.PartType.Ball, Vector3.new(0.26, 0.26, 0.26), eyePos, Color3.new(1, 1, 1))
		facePart(Enum.PartType.Ball, Vector3.new(0.13, 0.13, 0.13), eyePos + Vector3.new(0, 0, -0.1), Color3.fromRGB(15, 15, 20))
	end
	facePart(Enum.PartType.Block, Vector3.new(math.max(0.3, rs.X * 0.3), 0.09, 0.06), Vector3.new(ro.X, ro.Y - rs.Y * 0.17, faceZ - 0.04), Color3.fromRGB(15, 15, 20))
	local multiplier = mutation and Config.MUTATIONS[mutation] and Config.MUTATIONS[mutation].Multiplier or 1
	local effectiveIncome = def.Income * multiplier
	makeNameTag(rootPart, (mutation and "★ " or "") .. def.Name, string.format("$%d/s", effectiveIncome), def.RarityColor, topY)
	model:SetAttribute("BrainrotId", def.Id)
	model:SetAttribute("Rarity", def.Rarity)
	model:SetAttribute("Income", effectiveIncome)
	model:SetAttribute("Price", def.Price)
	model:SetAttribute("Mutation", mutation or "")
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
