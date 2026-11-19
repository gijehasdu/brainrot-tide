local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(script:WaitForChild("Config"))
local BrainrotFactory = require(script:WaitForChild("BrainrotFactory"))
local WorldBuilder = require(script:WaitForChild("WorldBuilder"))
local PlayerData = require(script:WaitForChild("PlayerData"))
PlayerData.Init()

local remoteFolder = ReplicatedStorage:FindFirstChild("BrainrotRemotes")
if not remoteFolder then
	remoteFolder = Instance.new("Folder")
	remoteFolder.Name = "BrainrotRemotes"
	remoteFolder.Parent = ReplicatedStorage
end

local function getRemote(name)
	local remote = remoteFolder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remoteFolder
	end
	return remote
end

local HudState = getRemote("HudState")
local WaveState = getRemote("WaveState")
local Notice = getRemote("Notice")
local BuyRequest = getRemote("BuyRequest")
local catalogRemote = remoteFolder:FindFirstChild("GetCatalog")
if not catalogRemote then
	catalogRemote = Instance.new("RemoteFunction")
	catalogRemote.Name = "GetCatalog"
	catalogRemote.Parent = remoteFolder
end

-- Lighting polish: warm afternoon light, shadows, a touch of bloom and haze.
local Lighting = game:GetService("Lighting")
Lighting.ClockTime = 14.5
Lighting.Brightness = 2
Lighting.GlobalShadows = true
Lighting.Ambient = Color3.fromRGB(110, 115, 135)
Lighting.OutdoorAmbient = Color3.fromRGB(150, 155, 175)
if not Lighting:FindFirstChildOfClass("Atmosphere") then
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.22
	atmosphere.Haze = 1.4
	atmosphere.Color = Color3.fromRGB(199, 220, 255)
	atmosphere.Decay = Color3.fromRGB(110, 130, 180)
	atmosphere.Parent = Lighting
end
if not Lighting:FindFirstChildOfClass("BloomEffect") then
	local bloom = Instance.new("BloomEffect")
	bloom.Intensity = 0.4
	bloom.Size = 24
	bloom.Threshold = 0.9
	bloom.Parent = Lighting
end
if not Lighting:FindFirstChildOfClass("SunRaysEffect") then
	local sunRays = Instance.new("SunRaysEffect")
	sunRays.Intensity = 0.06
	sunRays.Spread = 0.7
	sunRays.Parent = Lighting
end

-- Background music: an APM track from Roblox's Creator Store pool, licensed for experiences.
local SoundService = game:GetService("SoundService")
if not SoundService:FindFirstChild("BrainrotMusic") then
	local music = Instance.new("Sound")
	music.Name = "BrainrotMusic"
	music.SoundId = "rbxassetid://1843404009"
	music.Looped = true
	music.Volume = 0.35
	music.Parent = SoundService
	music:Play()
end

local world = WorldBuilder.Build()
local plotOwner = {}
local placedByPlayer = {}
local carriedByPlayer = {}
local wildEntries = {}
local setupPlayers = {}
local lockedUntil = {}
local wallsLit = {}

local function notice(player, message) Notice:FireClient(player, message) end
local function noticeAll(message) Notice:FireAllClients(message) end

local function rollRarity(weights)
	local total = 0
	for _, rarity in ipairs(Config.RARITIES) do total += math.max(0, weights[rarity.Name] or 0) end
	if total <= 0 then return Config.RARITIES[1].Name end
	local value = math.random() * total
	for _, rarity in ipairs(Config.RARITIES) do
		value -= math.max(0, weights[rarity.Name] or 0)
		if value <= 0 then return rarity.Name end
	end
	return Config.RARITIES[1].Name
end

local function randomCharacterOfRarity(rarityName)
	local matches = {}
	for _, def in ipairs(Config.CHARACTERS) do
		if def.Rarity == rarityName then table.insert(matches, def) end
	end
	return matches[math.random(1, #matches)]
end

local function rollMutation()
	for _, name in ipairs(Config.MUTATION_ROLL_ORDER) do
		if math.random() < Config.MUTATIONS[name].Chance then return name end
	end
	return nil
end

local function findPlot(player)
	for _, plot in ipairs(world.Plots) do
		if plotOwner[plot.Index] == player then return plot end
	end
	return nil
end

local function findFreePad(player)
	local plot = findPlot(player)
	if not plot then return nil, nil end
	local placed = placedByPlayer[player] or {}
	for _, pad in ipairs(plot.Pads) do
		if not placed[pad] then return plot, pad end
	end
	return plot, nil
end

local function syncRoster(player)
	local session = PlayerData.Get(player)
	if not session then return end
	local roster = {}
	for _, plot in ipairs(world.Plots) do
		if plotOwner[plot.Index] == player then
			for _, pad in ipairs(plot.Pads) do
				local entry = (placedByPlayer[player] or {})[pad]
				if entry then table.insert(roster, { Id = entry.Def.Id, Mutation = entry.Mutation }) end
			end
		end
	end
	session.Roster = roster
end

local function sellPlaced(player, pad)
	local placed = placedByPlayer[player]
	local entry = placed and placed[pad]
	if not entry then return end
	PlayerData.AddCash(player, entry.Def.Price)
	entry.Model:Destroy()
	placed[pad] = nil
	syncRoster(player)
end

local trySteal
local function placeFigureOnPad(player, plot, pad, def, mutation)
	if not plot or plotOwner[plot.Index] ~= player then return false end
	placedByPlayer[player] = placedByPlayer[player] or {}
	if placedByPlayer[player][pad] then return false end
	local model = BrainrotFactory.CreateFigure(def, mutation)
	model.Parent = world.Folder
	model:PivotTo(CFrame.new(pad.Position + Vector3.new(0, pad.Size.Y / 2, 0)))
	local primaryPart = model.PrimaryPart
	if not primaryPart then model:Destroy(); return false end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SellPrompt"
	prompt.ActionText = "Sell"
	prompt.ObjectText = "+$" .. def.Price
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = primaryPart
	prompt.Triggered:Connect(function(triggeringPlayer) sellPlaced(player, pad) end)
	local stealPrompt = Instance.new("ProximityPrompt")
	stealPrompt.Name = "StealPrompt"
	stealPrompt.ActionText = "Steal"
	stealPrompt.ObjectText = def.Name
	stealPrompt.MaxActivationDistance = 12
	stealPrompt.RequiresLineOfSight = false
	stealPrompt.Parent = primaryPart
	stealPrompt.Triggered:Connect(function(triggeringPlayer) trySteal(triggeringPlayer, player, pad) end)
	placedByPlayer[player][pad] = { Model = model, Def = def, Mutation = mutation }
	syncRoster(player)
	return true
end

local function placeFigure(player, def, mutation)
	local plot, pad = findFreePad(player)
	if not plot or not pad then return false end
	return placeFigureOnPad(player, plot, pad, def, mutation)
end

local function randomMeadowPoint()
	local angle = math.random() * math.pi * 2
	local radius = world.WildInnerRadius + 4 + math.random() * (world.WildOuterRadius - world.WildInnerRadius - 8)
	return Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
end

local tryPickup
local function addGrabPrompt(entry)
	local primaryPart = entry.Model.PrimaryPart
	if not primaryPart then return end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "GrabPrompt"
	prompt.ActionText = "Grab"
	prompt.ObjectText = entry.Def.Name .. "  $" .. entry.Model:GetAttribute("Income") .. "/s"
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = primaryPart
	prompt.Triggered:Connect(function(player) tryPickup(player, entry) end)
end

local function removeWildEntry(entry)
	for index, current in ipairs(wildEntries) do
		if current == entry then table.remove(wildEntries, index); return end
	end
end

local function releaseCarried(player, destroyFigure)
	local entry = carriedByPlayer[player]
	if not entry then return end
	carriedByPlayer[player] = nil
	entry.CarriedBy = nil
	if destroyFigure then
		entry.Model:Destroy()
		removeWildEntry(entry)
	else
		entry.TargetPos = randomMeadowPoint()
		entry.PauseUntil = 0
		addGrabPrompt(entry)
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = Config.NORMAL_WALKSPEED end
end

tryPickup = function(player, entry)
	if carriedByPlayer[player] then notice(player, "Your hands are full!"); return end
	if entry.CarriedBy then return end
	entry.CarriedBy = player
	carriedByPlayer[player] = entry
	local prompt = entry.Model.PrimaryPart and entry.Model.PrimaryPart:FindFirstChild("GrabPrompt")
	if prompt then prompt:Destroy() end
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = Config.CARRY_WALKSPEED end
end

trySteal = function(thief, owner, pad)
	if thief == owner then return end
	if carriedByPlayer[thief] then notice(thief, "Your hands are full!"); return end
	local placed = placedByPlayer[owner]
	local entry = placed and placed[pad]
	if not entry then return end
	if lockedUntil[owner] and os.clock() < lockedUntil[owner] then
		notice(thief, "🔒 That base is locked!")
		return
	end
	placed[pad] = nil
	syncRoster(owner)
	local model = entry.Model
	local primaryPart = model.PrimaryPart
	if primaryPart then
		for _, child in ipairs(primaryPart:GetChildren()) do
			if child:IsA("ProximityPrompt") then child:Destroy() end
		end
	end
	local wildEntry = {
		Model = model, Def = entry.Def, Mutation = entry.Mutation,
		TargetPos = randomMeadowPoint(), PauseUntil = 0,
		Phase = math.random() * math.pi * 2, CarriedBy = thief, Stolen = true,
	}
	table.insert(wildEntries, wildEntry)
	carriedByPlayer[thief] = wildEntry
	local humanoid = thief.Character and thief.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = Config.CARRY_WALKSPEED end
	notice(owner, "🚨 " .. thief.DisplayName .. " stole your " .. entry.Def.Name .. "!")
	notice(thief, "You stole a " .. entry.Def.Name .. " — run it home!")
end

local function spawnWild()
	local rarity = rollRarity(Config.WILD_WEIGHTS)
	local def = randomCharacterOfRarity(rarity)
	local mutation = rollMutation()
	local model = BrainrotFactory.CreateFigure(def, mutation)
	model.Parent = world.Folder
	local position = randomMeadowPoint()
	model:PivotTo(CFrame.new(position) * CFrame.Angles(0, math.random() * math.pi * 2, 0))
	local entry = { Model = model, Def = def, Mutation = mutation, TargetPos = randomMeadowPoint(), PauseUntil = 0, Phase = math.random() * math.pi * 2, CarriedBy = nil }
	table.insert(wildEntries, entry)
	addGrabPrompt(entry)
end

local function addPrompt(parent, name, actionText, objectText, distance)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = name
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.MaxActivationDistance = distance
	prompt.RequiresLineOfSight = false
	prompt.Parent = parent
	return prompt
end

local function setupPlotPrompts()
	for _, plot in ipairs(world.Plots) do
		for _, pad in ipairs(plot.Pads) do
			local prompt = addPrompt(pad, "PlacePrompt", "Place", "Your base pad", 10)
			prompt.Triggered:Connect(function(player)
				local carried = carriedByPlayer[player]
				if plotOwner[plot.Index] ~= player then
					if carried then notice(player, "This is not your base!") end
					return
				end
				if not carried then return end
				if placedByPlayer[player] and placedByPlayer[player][pad] then notice(player, "That pad is taken!"); return end
				releaseCarried(player, true)
				if not placeFigureOnPad(player, plot, pad, carried.Def, carried.Mutation) then
					notice(player, "That pad is taken!")
				end
			end)
		end
	end
end

local function setWallsLocked(plot, on)
	for _, wall in ipairs(plot.Walls) do
		wall.Transparency = on and 0.15 or 0.78
		wall.Color = on and Color3.fromRGB(110, 215, 255) or plot.WallColor
	end
end

local function setupLockPrompts()
	for _, plot in ipairs(world.Plots) do
		local prompt = addPrompt(plot.LockButton, "LockPrompt", "Lock Base", "60s protection", 12)
		prompt.Triggered:Connect(function(player)
			if plotOwner[plot.Index] ~= player then
				notice(player, "This is not your base!")
				return
			end
			local now = os.clock()
			if lockedUntil[player] and now < lockedUntil[player] then
				notice(player, "Already locked — " .. math.ceil(lockedUntil[player] - now) .. "s left")
				return
			end
			lockedUntil[player] = now + Config.LOCK_DURATION_SECONDS
			wallsLit[player] = true
			setWallsLocked(plot, true)
			notice(player, "🔒 Base locked for " .. Config.LOCK_DURATION_SECONDS .. " seconds!")
		end)
	end
end

local function setupShop()
	for _, pedestal in ipairs(world.ShopPedestals) do
		local tier = Config.EGG_TIERS[pedestal.TierIndex]
		local egg = BrainrotFactory.CreateEgg(tier)
		egg.Parent = world.Folder
		egg:PivotTo(pedestal.DisplayCFrame)
		local prompt = addPrompt(pedestal.Part, "HatchPrompt", "Hatch", tier.Name .. " — $" .. tier.Price, 12)
		prompt.Triggered:Connect(function(player)
			local session = PlayerData.Get(player)
			if not session then return end
			if session.Cash < tier.Price then notice(player, "You need $" .. tier.Price .. " for a " .. tier.Name); return end
			local _, freePad = findFreePad(player)
			if not freePad then notice(player, "No free pad on your base!"); return end
			PlayerData.AddCash(player, -tier.Price)
			local rarity = rollRarity(tier.Weights)
			local def = randomCharacterOfRarity(rarity)
			local mutation = rollMutation()
			if placeFigure(player, def, mutation) then
				notice(player, "Hatched " .. def.Name .. " (" .. rarity .. ")" .. (mutation and (" ★ " .. string.upper(mutation) .. "!") or ""))
			end
		end)
	end
end

local function setupRebirth()
	local prompt = addPrompt(world.RebirthAnchor, "RebirthPrompt", "Rebirth", "Rebirth Shrine", 12)
	prompt.Triggered:Connect(function(player)
		local session = PlayerData.Get(player)
		if not session then return end
		local cost = PlayerData.RebirthCost(player)
		if session.Cash < cost then notice(player, "Rebirth needs $" .. cost); return end
		for _, entry in pairs(placedByPlayer[player] or {}) do entry.Model:Destroy() end
		placedByPlayer[player] = {}
		session.Rebirths += 1
		session.Cash = Config.START_CASH
		session.Roster = {}
		PlayerData.Refresh(player)
		notice(player, "REBORN! Income is now +" .. math.floor(PlayerData.IncomeMultiplier(player) * 100 - 100) .. "% forever")
	end)
end

local function assignPlot(player)
	for _, plot in ipairs(world.Plots) do
		if not plotOwner[plot.Index] then
			plotOwner[plot.Index] = player
			plot.SignText.Text = player.DisplayName .. "'s Base"
			return plot
		end
	end
	return nil
end

local function teleportCharacter(player, character)
	task.wait(0.3)
	local root = character:WaitForChild("HumanoidRootPart", 5)
	if root then
		local plot = findPlot(player)
		character:PivotTo(CFrame.new(plot and plot.SpawnPosition or world.PlazaSpawnCFrame.Position))
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = carriedByPlayer[player] and Config.CARRY_WALKSPEED or Config.NORMAL_WALKSPEED end
end

local function setupPlayer(player)
	if setupPlayers[player] then return end
	setupPlayers[player] = true
	PlayerData.Setup(player)
	local plot = assignPlot(player)
	if plot then
		lockedUntil[player] = os.clock() + Config.LOCK_SPAWN_PROTECTION_SECONDS
		wallsLit[player] = true
		setWallsLocked(plot, true)
	end
	placedByPlayer[player] = {}
	local function restoreRoster(loadedPlayer)
		if loadedPlayer ~= player or not player.Parent then return end
		local session = PlayerData.Get(player)
		if not session then return end
		for _, saved in ipairs(session.Roster) do
			local def = Config.CHARACTERS_BY_ID[saved.Id]
			if def and not placeFigure(player, def, saved.Mutation or (saved.Gold and "Gold")) then break end
		end
	end
	PlayerData.Loaded.Event:Connect(restoreRoster)
	-- Cover a very fast local/mock DataStore load that finishes before the event connection.
	local session = PlayerData.Get(player)
	if session and session.Loaded then restoreRoster(player) end
	player.CharacterAdded:Connect(function(character) task.spawn(teleportCharacter, player, character) end)
	if player.Character then task.spawn(teleportCharacter, player, player.Character) end
end

local function cleanupPlayer(player)
	if carriedByPlayer[player] then releaseCarried(player, true) end
	for _, entry in pairs(placedByPlayer[player] or {}) do entry.Model:Destroy() end
	placedByPlayer[player] = nil
	lockedUntil[player] = nil
	wallsLit[player] = nil
	for _, plot in ipairs(world.Plots) do
		if plotOwner[plot.Index] == player then
			plotOwner[plot.Index] = nil
			plot.SignText.Text = "EMPTY BASE"
			setWallsLocked(plot, false)
		end
	end
	setupPlayers[player] = nil
end

local function incomeOf(player)
	local total = 0
	for _, entry in pairs(placedByPlayer[player] or {}) do
		total += entry.Def.Income * (entry.Mutation and Config.MUTATIONS[entry.Mutation].Multiplier or 1)
	end
	return math.floor(total * PlayerData.IncomeMultiplier(player))
end

local function isInWild(position)
	local flat = Vector3.new(position.X, 0, position.Z)
	if flat.Magnitude < world.WildInnerRadius + 2 or position.Y > 25 then return false end
	for _, plot in ipairs(world.Plots) do
		local localPosition = plot.CFrame:PointToObjectSpace(position)
		if math.abs(localPosition.X) <= 25 and math.abs(localPosition.Z) <= 25 then return false end
	end
	return true
end

catalogRemote.OnServerInvoke = function(player)
	local list = {}
	for _, def in ipairs(Config.CHARACTERS) do
		local c = def.RarityColor
		table.insert(list, {
			Id = def.Id, Name = def.Name, Rarity = def.Rarity,
			Income = def.Income, Price = def.Price, Color = { c.R, c.G, c.B },
		})
	end
	return list
end

BuyRequest.OnServerEvent:Connect(function(player, characterId)
	if type(characterId) ~= "string" then return end
	local def = Config.CHARACTERS_BY_ID[characterId]
	if not def then return end
	local session = PlayerData.Get(player)
	if not session then return end
	if session.Cash < def.Price then
		notice(player, "You need $" .. def.Price .. " for a " .. def.Name)
		return
	end
	local _, freePad = findFreePad(player)
	if not freePad then
		notice(player, "No free pad on your base!")
		return
	end
	PlayerData.AddCash(player, -def.Price)
	local mutation = rollMutation()
	if placeFigure(player, def, mutation) then
		notice(player, "Bought " .. def.Name .. (mutation and (" ★ " .. string.upper(mutation) .. "!") or ""))
	end
end)

setupPlotPrompts()
setupLockPrompts()
setupShop()
setupRebirth()
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)
for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end

RunService.Heartbeat:Connect(function(dt)
	local now = os.clock()
	for _, entry in ipairs(wildEntries) do
		if entry.CarriedBy then
			local character = entry.CarriedBy.Character
			local head = character and character:FindFirstChild("Head")
			if head then entry.Model:PivotTo(CFrame.new(head.Position + Vector3.new(0, 3, 0)) * head.CFrame.Rotation) end
		elseif now >= entry.PauseUntil then
			local current = entry.Model:GetPivot().Position
			local offset = Vector3.new(entry.TargetPos.X - current.X, 0, entry.TargetPos.Z - current.Z)
			local distance = offset.Magnitude
			if distance < 1.2 then
				entry.PauseUntil = now + 0.5 + math.random() * 1.5
				entry.TargetPos = randomMeadowPoint()
			else
				local step = math.min(distance, 3.2 * dt)
				local direction = offset.Unit
				local nextPosition = Vector3.new(current.X, math.abs(math.sin(now * 2.2 + entry.Phase)) * 0.25, current.Z) + direction * step
				entry.Model:PivotTo(CFrame.lookAt(nextPosition, nextPosition + direction))
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(2)
		local count = 0
		for _, entry in ipairs(wildEntries) do if not entry.CarriedBy then count += 1 end end
		while count < Config.WILD_TARGET_COUNT do spawnWild(); count += 1 end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.3)
		local color = Color3.fromHSV((os.clock() * 0.12) % 1, 0.6, 1)
		for _, model in ipairs(world.Folder:GetChildren()) do
			if model:IsA("Model") and model:GetAttribute("Mutation") == "Rainbow" then
				for _, part in ipairs(model:GetDescendants()) do
					if part.Name == "TintPart" then part.Color = color end
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(1)
		for _, player in ipairs(Players:GetPlayers()) do
			if wallsLit[player] and lockedUntil[player] and os.clock() >= lockedUntil[player] then
				wallsLit[player] = nil
				lockedUntil[player] = nil
				local plot = findPlot(player)
				if plot then setWallsLocked(plot, false) end
			end
			local session = PlayerData.Get(player)
			if session then
				local income = incomeOf(player)
				if income > 0 then PlayerData.AddCash(player, income) end
				HudState:FireClient(player, {
					Cash = session.Cash, IncomePerSec = income,
					Carrying = carriedByPlayer[player] and carriedByPlayer[player].Def.Name or "",
					Rebirths = session.Rebirths, RebirthCost = PlayerData.RebirthCost(player),
				})
			end
		end
	end
end)

task.spawn(function()
	local cycleSeconds = Config.WAVE_PERIOD_SECONDS - Config.WAVE_WARNING_SECONDS - Config.WAVE_SWEEP_SECONDS
	while true do
		for remaining = cycleSeconds, 1, -1 do
			WaveState:FireAllClients({ Phase = "Calm", SecondsLeft = remaining + Config.WAVE_WARNING_SECONDS })
			task.wait(1)
		end
		noticeAll("TSUNAMI INCOMING — get back to a base!")
		for remaining = Config.WAVE_WARNING_SECONDS, 1, -1 do
			WaveState:FireAllClients({ Phase = "Warning", SecondsLeft = remaining })
			task.wait(1)
		end
		local wall = Instance.new("Part")
		wall.Name = "TsunamiWall"
		wall.Size = Vector3.new(10, 70, 470)
		wall.Color = Color3.fromRGB(40, 130, 230)
		wall.Transparency = 0.35
		wall.Material = Enum.Material.Glass
		wall.Anchored = true
		wall.CanCollide = false
		wall.CanQuery = false
		wall.CanTouch = false
		wall.CFrame = CFrame.new(-235, 18, 0)
		wall.Parent = world.Folder
		local hitSet = {}
		local startedAt = os.clock()
		local lastWaveSecond = -1
		while true do
			local elapsed = os.clock() - startedAt
			local fraction = math.clamp(elapsed / Config.WAVE_SWEEP_SECONDS, 0, 1)
			local remaining = Config.WAVE_SWEEP_SECONDS - elapsed
			wall.CFrame = CFrame.new(-235 + 470 * fraction, 18, 0)
			local second = math.ceil(math.max(0, remaining))
			if second ~= lastWaveSecond then
				lastWaveSecond = second
				WaveState:FireAllClients({ Phase = "Sweep", SecondsLeft = second })
			end
			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				if root and not hitSet[player] and isInWild(root.Position) then
					hitSet[player] = true
					if carriedByPlayer[player] then
						releaseCarried(player, true)
						notice(player, "The wave took your brainrot!")
					else
						notice(player, "The wave knocked you back to base!")
					end
					local plot = findPlot(player)
					character:PivotTo(CFrame.new(plot and plot.SpawnPosition or world.PlazaSpawnCFrame.Position))
				end
			end
			if fraction >= 1 then break end
			task.wait()
		end
		wall:Destroy()
	end
end)
