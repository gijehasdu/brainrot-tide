local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("BrainrotRemotes")
local hudStateRemote = remotes:WaitForChild("HudState")
local waveStateRemote = remotes:WaitForChild("WaveState")
local noticeRemote = remotes:WaitForChild("Notice")

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotHud"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function makeLabel(parent, name)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.TextStrokeTransparency = 0.5
	label.Parent = parent
	return label
end

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.AnchorPoint = Vector2.new(0.5, 0)
topBar.Position = UDim2.new(0.5, 0, 0, 8)
topBar.Size = UDim2.new(0, 580, 0, 48)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
topBar.BackgroundTransparency = 0.25
topBar.BorderSizePixel = 0
topBar.Parent = gui
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar
local topConstraint = Instance.new("UISizeConstraint")
topConstraint.MinSize = Vector2.new(340, 48)
topConstraint.MaxSize = Vector2.new(580, 48)
topConstraint.Parent = topBar
local topLayout = Instance.new("UIListLayout")
topLayout.FillDirection = Enum.FillDirection.Horizontal
topLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
topLayout.Padding = UDim.new(0, 18)
topLayout.Parent = topBar

local cashLabel = makeLabel(topBar, "CashLabel")
cashLabel.Size = UDim2.new(0, 170, 1, 0)
cashLabel.TextSize = 21
cashLabel.Text = "💰 $100"
local incomeLabel = makeLabel(topBar, "IncomeLabel")
incomeLabel.Size = UDim2.new(0, 170, 1, 0)
incomeLabel.TextSize = 21
incomeLabel.TextColor3 = Color3.fromRGB(120, 255, 130)
incomeLabel.Text = "📈 +$0/s"
local rebirthLabel = makeLabel(topBar, "RebirthLabel")
rebirthLabel.Size = UDim2.new(0, 170, 1, 0)
rebirthLabel.TextSize = 21
rebirthLabel.Text = "⭐ Rebirths: 0"

local waveBox = Instance.new("Frame")
waveBox.Name = "WaveBox"
waveBox.AnchorPoint = Vector2.new(1, 0)
waveBox.Position = UDim2.new(1, -10, 0, 8)
waveBox.Size = UDim2.new(0, 200, 0, 48)
waveBox.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
waveBox.BackgroundTransparency = 0.25
waveBox.BorderSizePixel = 0
waveBox.Parent = gui
local waveCorner = Instance.new("UICorner")
waveCorner.CornerRadius = UDim.new(0, 12)
waveCorner.Parent = waveBox
local waveLabel = makeLabel(waveBox, "WaveLabel")
waveLabel.Size = UDim2.fromScale(1, 1)
waveLabel.TextSize = 19
waveLabel.Text = "🌊 Wave in 1:23"

local warningBanner = Instance.new("Frame")
warningBanner.Name = "WarningBanner"
warningBanner.AnchorPoint = Vector2.new(0.5, 0)
warningBanner.Position = UDim2.new(0.5, 0, 0, 66)
warningBanner.Size = UDim2.new(0, 640, 0, 54)
warningBanner.BackgroundColor3 = Color3.fromRGB(205, 45, 45)
warningBanner.BackgroundTransparency = 0.1
warningBanner.BorderSizePixel = 0
warningBanner.Visible = false
warningBanner.Parent = gui
local warningCorner = Instance.new("UICorner")
warningCorner.CornerRadius = UDim.new(0, 12)
warningCorner.Parent = warningBanner
local warningLabel = makeLabel(warningBanner, "WarningLabel")
warningLabel.Size = UDim2.fromScale(1, 1)
warningLabel.TextSize = 24
warningLabel.Text = "⚠ TSUNAMI IN 10s — RUN TO YOUR BASE! ⚠"

local carryLabel = makeLabel(gui, "CarryLabel")
carryLabel.AnchorPoint = Vector2.new(0.5, 0)
carryLabel.Position = UDim2.new(0.5, 0, 0, 64)
carryLabel.Size = UDim2.new(0, 420, 0, 30)
carryLabel.TextSize = 18
carryLabel.TextColor3 = Color3.fromRGB(255, 230, 130)
carryLabel.Visible = false
carryLabel.Text = "🎒 Carrying: Croissant Boxer"

local noticeLabel = makeLabel(gui, "NoticeLabel")
noticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
noticeLabel.Position = UDim2.new(0.5, 0, 0.38, 0)
noticeLabel.Size = UDim2.new(0, 700, 0, 44)
noticeLabel.TextSize = 26
noticeLabel.TextColor3 = Color3.fromRGB(255, 240, 160)
noticeLabel.Visible = false

local hintLabel = makeLabel(gui, "HintLabel")
hintLabel.AnchorPoint = Vector2.new(0.5, 1)
hintLabel.Position = UDim2.new(0.5, 0, 1, -10)
hintLabel.Size = UDim2.new(0, 760, 0, 26)
hintLabel.TextSize = 15
hintLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
hintLabel.Text = "Grab or STEAL brainrots → carry them to YOUR base pads → lock your base, hatch eggs, dodge the tsunami!"

local function formatCash(n)
	n = math.floor(n)
	if n >= 1000000 then
		return string.format("$%.2fM", n / 1e6)
	end
	if n >= 10000 then
		return string.format("$%.1fK", n / 1e3)
	end
	return "$" .. tostring(n)
end

local warningActive = false
local carrying = ""
local function updateCarryVisibility()
	carryLabel.Visible = carrying ~= "" and not warningActive
end

hudStateRemote.OnClientEvent:Connect(function(state)
	cashLabel.Text = "💰 " .. formatCash(state.Cash)
	incomeLabel.Text = "📈 +" .. formatCash(state.IncomePerSec) .. "/s"
	rebirthLabel.Text = "⭐ Rebirths: " .. tostring(state.Rebirths)
	carrying = state.Carrying
	if carrying ~= "" then
		carryLabel.Text = "🎒 Carrying: " .. carrying
	end
	updateCarryVisibility()
end)

waveStateRemote.OnClientEvent:Connect(function(state)
	local seconds = state.SecondsLeft
	if state.Phase == "Calm" then
		warningActive = false
		waveLabel.Text = string.format("🌊 Wave in %d:%02d", math.floor(seconds / 60), seconds % 60)
		warningBanner.Visible = false
		warningBanner.BackgroundTransparency = 0.1
	elseif state.Phase == "Warning" then
		warningActive = true
		waveLabel.Text = "🌊 TSUNAMI!"
		warningBanner.Visible = true
		warningLabel.Text = string.format("⚠ TSUNAMI IN %ds — RUN TO YOUR BASE! ⚠", seconds)
		warningBanner.BackgroundTransparency = seconds % 2 == 0 and 0.05 or 0.3
	elseif state.Phase == "Sweep" then
		warningActive = true
		waveLabel.Text = "🌊 WAVE!"
		warningBanner.Visible = true
		warningLabel.Text = "🌊 THE WAVE IS HERE! 🌊"
		warningBanner.BackgroundTransparency = 0.1
	end
	updateCarryVisibility()
end)

local noticeToken = 0
noticeRemote.OnClientEvent:Connect(function(message)
	noticeToken += 1
	local thisToken = noticeToken
	noticeLabel.Text = message
	noticeLabel.Visible = true
	task.spawn(function()
		task.wait(2.6)
		if thisToken == noticeToken then
			noticeLabel.Visible = false
		end
	end)
end)
