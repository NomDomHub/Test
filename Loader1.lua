local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Tween helper
local function tween(object, tweenInfo, goal)
	return TweenService:Create(object, tweenInfo, goal)
end

-- Làm mờ nền
local blur = Instance.new("BlurEffect")
blur.Size = 30
blur.Parent = Lighting

local function smoothRemoveBlur()
	for i = 30, 0, -1 do
		blur.Size = i
		task.wait(0.008)
	end
	blur:Destroy()
end

-- Tạo GUI
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "IntroLoading"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local container = Instance.new("Frame")
container.BackgroundTransparency = 1
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.Size = UDim2.new(0, 600, 0, 100)
container.Parent = gui

local title = "Lag Cat"
local spacing = 90
local totalWidth = (#title - 1) * spacing
local letterLabels = {}

for i = 1, #title do
	local char = title:sub(i, i)
	local label = Instance.new("TextLabel")
	label.Text = char
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 100
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.TextTransparency = 1
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Size = UDim2.new(0, 100, 0, 100)

	local offsetX = (i - 1) * spacing - totalWidth / 2
	label.Position = UDim2.new(0.5, offsetX, 1.5, 0)
	label.Parent = container

	table.insert(letterLabels, label)

	task.delay((i - 1) * 0.1, function()
		tween(label, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, offsetX, 0.5, 0),
			TextTransparency = 0
		}):Play()
	end)
end

-- Mờ dần và rơi xuống
task.delay(#title * 0.1 + 2, function()
	for i = #letterLabels, 1, -1 do
		local label = letterLabels[i]
		task.delay((#letterLabels - i) * 0.1, function()
			tween(label, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				Position = label.Position + UDim2.new(0, 0, 0.5, 0),
				TextTransparency = 1
			}):Play()
		end)
	end

	task.delay(1.2 + #letterLabels * 0.1, function()
		gui:Destroy()
		smoothRemoveBlur()
	end)
end)
