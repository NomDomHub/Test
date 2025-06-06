local LoadingLib = {}

local TweenService = game:GetService("TweenService")

-- Bảng ánh xạ tên màu -> Color3
local colorMap = {
    Red = Color3.fromRGB(255, 0, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Purple = Color3.fromRGB(128, 0, 128),
    Pink = Color3.fromRGB(255, 192, 203),
    Black = Color3.fromRGB(0, 0, 0),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(128, 128, 128)
}

function LoadingLib:CreateLoading(config)
    config = config or {}
    local title = config.Title or "Default Title"
    local imageUrl = config.Image or ""
    local scriptName = config.ScriptName or "Default Script"
    local colorName = config.Color or "Black"
    local backgroundColor = colorMap[colorName] or Color3.fromRGB(0, 0, 0)

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, -250, 0.5, -150)
    frame.BackgroundColor3 = backgroundColor
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0
    frame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 20)
    frameCorner.Parent = frame

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0, 80, 0, 80)
    imageLabel.Position = UDim2.new(0, 10, 0, 10)
    imageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = imageUrl ~= "" and imageUrl or ""
    imageLabel.Parent = frame

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 25)
    imageCorner.Parent = imageLabel

    if imageUrl == "" then
        local placeholderText = Instance.new("TextLabel")
        placeholderText.Size = UDim2.new(1, 0, 1, 0)
        placeholderText.BackgroundTransparency = 1
        placeholderText.Text = "IMAGE HERE"
        placeholderText.TextColor3 = Color3.fromRGB(0, 0, 0)
        placeholderText.TextScaled = true
        placeholderText.TextTransparency = 1
        placeholderText.Parent = imageLabel
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 400, 0, 40)
    titleLabel.Position = UDim2.new(0, 100, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextTransparency = 1
    titleLabel.Parent = frame

    local scriptLabel = Instance.new("TextLabel")
    scriptLabel.Size = UDim2.new(0, 400, 0, 60)
    scriptLabel.Position = UDim2.new(0, 100, 0, 50)
    scriptLabel.BackgroundTransparency = 1
    scriptLabel.Text = "Loading Script\n" .. scriptName
    scriptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptLabel.TextScaled = true
    scriptLabel.TextWrapped = true
    scriptLabel.Font = Enum.Font.Bangers
    scriptLabel.TextTransparency = 1
    scriptLabel.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 480, 0, 15)
    progressBar.Position = UDim2.new(0, 10, 0, 260)
    progressBar.BackgroundColor3 = backgroundColor
    progressBar.BorderSizePixel = 0
    progressBar.BackgroundTransparency = 1
    progressBar.Parent = frame

    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 5)
    progressBarCorner.Parent = progressBar

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = backgroundColor
    progressFill.BorderSizePixel = 0
    progressFill.BackgroundTransparency = 1
    progressFill.Parent = progressBar

    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(0, 5)
    progressFillCorner.Parent = progressFill

    local progressLabel = Instance.new("TextLabel")
    progressLabel.Size = UDim2.new(0, 100, 0, 20)
    progressLabel.Position = UDim2.new(0, 10, 0, -25)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "0%"
    progressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressLabel.TextScaled = true
    progressLabel.Font = Enum.Font.Bangers
    progressLabel.TextTransparency = 1
    progressLabel.Parent = progressBar

    local spinnerFrame = Instance.new("Frame")
    spinnerFrame.Size = UDim2.new(0, 40, 0, 40)
    spinnerFrame.Position = UDim2.new(1, -50, 0, -45)
    spinnerFrame.BackgroundTransparency = 1
    spinnerFrame.Parent = progressBar

    local numDots = 8
    local dotSize = 8
    local radius = 15
    for i = 1, numDots do
        local angle = (i - 1) * (2 * math.pi / numDots)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, dotSize, 0, dotSize)
        dot.Position = UDim2.new(0.5, math.cos(angle) * radius - dotSize / 2, 0.5, math.sin(angle) * radius - dotSize / 2)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        dot.BackgroundTransparency = 1
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        dot.Parent = spinnerFrame
    end

    -- Tween In
    local tweenIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(frame, tweenIn, {Size = UDim2.new(0, 500, 0, 300)}):Play()
    TweenService:Create(imageLabel, tweenIn, {BackgroundTransparency = 0}):Play()
    if imageLabel:FindFirstChild("TextLabel") then
        TweenService:Create(imageLabel.TextLabel, tweenIn, {TextTransparency = 0}):Play()
    end
    TweenService:Create(titleLabel, tweenIn, {TextTransparency = 0}):Play()
    TweenService:Create(scriptLabel, tweenIn, {TextTransparency = 0}):Play()
    TweenService:Create(progressBar, tweenIn, {BackgroundTransparency = 0}):Play()
    TweenService:Create(progressFill, tweenIn, {BackgroundTransparency = 0}):Play()
    TweenService:Create(progressLabel, tweenIn, {TextTransparency = 0}):Play()

    for _, dot in pairs(spinnerFrame:GetChildren()) do
        if dot:IsA("Frame") then
            TweenService:Create(dot, tweenIn, {BackgroundTransparency = 0}):Play()
        end
    end

    -- Spinner rotation
    TweenService:Create(spinnerFrame, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    -- Spinner blinking
    for i, dot in ipairs(spinnerFrame:GetChildren()) do
        if dot:IsA("Frame") then
            TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, (i - 1) * (1 / numDots)), {
                BackgroundTransparency = 0.5
            }):Play()
        end
    end

    -- Progress fill
    TweenService:Create(progressFill, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()

    local startTime = tick()
    while tick() - startTime < 3 do
        local percent = math.clamp((tick() - startTime) / 3, 0, 1) * 100
        progressLabel.Text = math.floor(percent) .. "%"
        task.wait()
    end

    -- Tween Out
    local tweenOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(frame, tweenOut, {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(imageLabel, tweenOut, {BackgroundTransparency = 1}):Play()
    if imageLabel:FindFirstChild("TextLabel") then
        TweenService:Create(imageLabel.TextLabel, tweenOut, {TextTransparency = 1}):Play()
    end
    TweenService:Create(titleLabel, tweenOut, {TextTransparency = 1}):Play()
    TweenService:Create(scriptLabel, tweenOut, {TextTransparency = 1}):Play()
    TweenService:Create(progressBar, tweenOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressFill, tweenOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressLabel, tweenOut, {TextTransparency = 1}):Play()

    for _, dot in pairs(spinnerFrame:GetChildren()) do
        if dot:IsA("Frame") then
            TweenService:Create(dot, tweenOut, {BackgroundTransparency = 1}):Play()
        end
    end

    task.wait(0.6)
    screenGui:Destroy()
end

return LoadingLib
