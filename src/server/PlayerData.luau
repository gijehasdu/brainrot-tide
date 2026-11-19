local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local Config = require(script.Parent:WaitForChild("Config"))
local PlayerData = {}
local sessions = {}

local loadedEvent = Instance.new("BindableEvent")
loadedEvent.Name = "Loaded"
loadedEvent.Parent = script
PlayerData.Loaded = loadedEvent

local function refresh(player)
	local session = sessions[player]
	local leaderstats = player:FindFirstChild("leaderstats")
	if not session or not leaderstats then return end
	local cash = leaderstats:FindFirstChild("Cash")
	local rebirths = leaderstats:FindFirstChild("Rebirths")
	if cash and cash:IsA("IntValue") then cash.Value = math.floor(session.Cash) end
	if rebirths and rebirths:IsA("IntValue") then rebirths.Value = math.floor(session.Rebirths) end
end

function PlayerData.Setup(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats
	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Parent = leaderstats

	sessions[player] = { Cash = Config.START_CASH, Rebirths = 0, Roster = {}, Loaded = false }
	refresh(player)
	task.spawn(function()
		local ok, result = pcall(function()
			local store = DataStoreService:GetDataStore(Config.DATASTORE_NAME)
			return store:GetAsync("Player_" .. player.UserId)
		end)
		local session = sessions[player]
		if not session then return end
		if ok and type(result) == "table" then
			if type(result.Cash) == "number" then session.Cash = math.max(0, result.Cash) end
			if type(result.Rebirths) == "number" then session.Rebirths = math.max(0, result.Rebirths) end
			if type(result.Roster) == "table" then
				for _, entry in ipairs(result.Roster) do
					if #session.Roster >= Config.PADS_PER_PLOT then break end
					if type(entry) == "table" and type(entry.Id) == "string"
						and Config.CHARACTERS_BY_ID[entry.Id] and type(entry.Gold) == "boolean" then
						table.insert(session.Roster, { Id = entry.Id, Gold = entry.Gold })
					end
				end
			end
		end
		session.Loaded = true
		refresh(player)
		PlayerData.Loaded:Fire(player)
	end)
end

function PlayerData.Get(player) return sessions[player] end
function PlayerData.Refresh(player) refresh(player) end

function PlayerData.AddCash(player, amount)
	local session = sessions[player]
	if not session then return end
	session.Cash = math.max(0, session.Cash + amount)
	refresh(player)
end

function PlayerData.IncomeMultiplier(player)
	local session = sessions[player]
	return session and (1 + 0.5 * session.Rebirths) or 1
end

function PlayerData.RebirthCost(player)
	local session = sessions[player]
	return Config.REBIRTH_BASE_COST * ((session and session.Rebirths or 0) + 1)
end

function PlayerData.Save(player)
	local session = sessions[player]
	if not session or not session.Loaded then return end
	pcall(function()
		local store = DataStoreService:GetDataStore(Config.DATASTORE_NAME)
		store:SetAsync("Player_" .. player.UserId, {
			Cash = session.Cash, Rebirths = session.Rebirths, Roster = session.Roster,
		})
	end)
end

function PlayerData.Init()
	Players.PlayerRemoving:Connect(PlayerData.Save)
	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do PlayerData.Save(player) end
	end)
end

return PlayerData
