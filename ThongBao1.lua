-- Thongbao.lua

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Thongbao = {}
local activeNotifications = {}
local maxNotifications = 3
local spacing = 10 -- Khoảng cách giữa các thông báo
local notifyHeight = 70

function Thongbao:Notify(info)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Tạo giao diện
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HungHubNotification_" .. tick()
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local notifyFrame = Instance.new("Frame")
	notifyFrame.Size = UDim2.new(0, 260, 0, notifyHeight)
	notifyFrame.Position = UDim2.new(1, 300, 1, -100)
	notifyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	notifyFrame.AnchorPoint = Vector2.new(1, 1)
	notifyFrame.ClipsDescendants = true
	notifyFrame.Parent = screenGui

	Instance.new("UICorner", notifyFrame).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke", notifyFrame)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1
	stroke.Transparency = 0.5

	local title = Instance.new("TextLabel")
	title.Text = info.Title or "Thông báo"
	title.Font = Enum.Font.SourceSansSemibold
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Size = UDim2.new(1, -40, 0, 20)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = notifyFrame

	local content = Instance.new("TextLabel")
	content.Text = info.Content or "Nội dung trống"
	content.Font = Enum.Font.SourceSans
	content.TextColor3 = Color3.fromRGB(180, 180, 180)
	content.TextSize = 16
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, 10, 0, 30)
	content.Size = UDim2.new(1, -20, 0, 20)
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.Parent = notifyFrame

	local closeButton = Instance.new("TextButton")
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.TextSize = 16
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundTransparency = 1
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -30, 0, 0)
	closeButton.Parent = notifyFrame

	local progressBar = Instance.new("Frame")
	progressBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
	progressBar.BackgroundTransparency = 0.3
	progressBar.Size = UDim2.new(0, 0, 0, 4)
	progressBar.Position = UDim2.new(0, 0, 1, -4)
	progressBar.BorderSizePixel = 0
	progressBar.Parent = notifyFrame

	-- Thêm vào danh sách
	table.insert(activeNotifications, {
		Frame = notifyFrame,
		Gui = screenGui
	})

	-- Loại bỏ thông báo đầu nếu vượt quá giới hạn
	if #activeNotifications > maxNotifications then
		local oldest = table.remove(activeNotifications, 1)
		TweenService:Create(oldest.Frame, TweenInfo.new(0.3), {
			Position = UDim2.new(1, 300, 1, -100)
		}):Play()
		task.delay(0.3, function()
			oldest.Gui:Destroy()
		end)
	end

	-- Dịch lại vị trí các thông báo
	for i, notif in ipairs(activeNotifications) do
		local yOffset = -((notifyHeight + spacing) * (#activeNotifications - i))
		TweenService:Create(notif.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -20, 1, yOffset - 20)
		}):Play()
	end

	-- Tween hiện
	TweenService:Create(progressBar, TweenInfo.new(info.Duration or 5, Enum.EasingStyle.Linear), {
		Size = UDim2.new(1, 0, 0, 4)
	}):Play()

	-- Tự đóng
	local function close()
		for i, notif in ipairs(activeNotifications) do
			if notif.Frame == notifyFrame then
				table.remove(activeNotifications, i)
				break
			end
		end

		TweenService:Create(notifyFrame, TweenInfo.new(0.3), {
			Position = UDim2.new(1, 300, 1, -100)
		}):Play()
		task.wait(0.3)
		screenGui:Destroy()

		-- Cập nhật lại vị trí các thông báo còn lại
		for i, notif in ipairs(activeNotifications) do
			local yOffset = -((notifyHeight + spacing) * (#activeNotifications - i))
			TweenService:Create(notif.Frame, TweenInfo.new(0.3), {
				Position = UDim2.new(1, -20, 1, yOffset - 20)
			}):Play()
		end
	end

	closeButton.MouseButton1Click:Connect(close)
	task.delay(info.Duration or 5, close)
end

return Thongbao
