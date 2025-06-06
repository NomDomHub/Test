local LoadingLib = {}

function LoadingLib:CreateLoading(options)
    options = options or {}

    -- Thiết lập mặc định chỉ khi không có người truyền vào
    local title = options.Title or "Lag Cat Hub"
    local colorName = (options.Color or "Gray"):lower()
    local image = options.Image ~= "" and options.Image or "rbxassetid://72597850320651"
    local scriptName = options.ScriptName or "Happy use"
    local duration = options.Duration or 5

    local colorMap = {
        red = Color3.fromRGB(255, 0, 0),
        orange = Color3.fromRGB(255, 165, 0),
        yellow = Color3.fromRGB(255, 255, 0),
        green = Color3.fromRGB(0, 255, 0),
        blue = Color3.fromRGB(0, 0, 255),
        purple = Color3.fromRGB(128, 0, 128),
        pink = Color3.fromRGB(255, 105, 180),
        white = Color3.fromRGB(255, 255, 255),
        black = Color3.fromRGB(0, 0, 0),
        gray = Color3.fromRGB(128, 128, 128)
    }

    local chosenColor = colorMap[colorName] or Color3.fromRGB(128, 128, 128)

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = chosenColor
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.1
    frame.AnchorPoint = Vector2.new(0.5, 0.5)

    local uiCorner = Instance.new("UICorner", frame)
    uiCorner.CornerRadius = UDim.new(0, 12)

    if image and image ~= "" then
        local icon = Instance.new("ImageLabel", frame)
        icon.Image = image
        icon.Size = UDim2.new(0, 80, 0, 80)
        icon.Position = UDim2.new(0.5, -40, 0, 10)
        icon.BackgroundTransparency = 1
    end

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 100)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.BackgroundTransparency = 1

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 140)
    statusLabel.Text = scriptName
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 18
    statusLabel.BackgroundTransparency = 1

    task.wait(duration)

    for i = 1, 10 do
        frame.BackgroundTransparency += 0.1
        titleLabel.TextTransparency += 0.1
        statusLabel.TextTransparency += 0.1
        task.wait(0.05)
    end

    gui:Destroy()
end

return LoadingLib
