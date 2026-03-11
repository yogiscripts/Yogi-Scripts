-- Yogi Allower GUI - title text size 25

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("YogiAllowerGUI") then
    playerGui.YogiAllowerGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YogiAllowerGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 110)
frame.Position = UDim2.new(0.5, -100, 0.88, -55)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 13)
corner.Parent = frame

-- Black base stroke
local blackStroke = Instance.new("UIStroke")
blackStroke.Color = Color3.fromRGB(0, 0, 0)
blackStroke.Thickness = 6
blackStroke.Transparency = 0
blackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
blackStroke.Parent = frame

-- Circulating white wave stroke
local waveStroke = Instance.new("UIStroke")
waveStroke.Color = Color3.fromRGB(255, 255, 255)
waveStroke.Thickness = 3.5
waveStroke.Transparency = 0.3
waveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
waveStroke.ZIndex = 2
waveStroke.Parent = frame

local waveGradient = Instance.new("UIGradient")
waveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
waveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.45, 0),
    NumberSequenceKeypoint.new(0.55, 0),
    NumberSequenceKeypoint.new(1, 1)
})
waveGradient.Rotation = 0
waveGradient.Parent = waveStroke

-- Pulse animation
local pulseInfo = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(waveStroke, pulseInfo, {
    Thickness = 5.5,
    Transparency = 0.05
}):Play()

-- Wave rotation
RunService.Heartbeat:Connect(function(dt)
    waveGradient.Rotation = (waveGradient.Rotation + 180 * dt) % 360
end)

-- Title (size 25)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 2)
title.BackgroundTransparency = 1
title.Text = "Yogi Allower"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 25   -- changed to 25
title.TextScaled = false
title.Parent = frame

-- Toggle button (lowercase, size 24)
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.88, 0, 0, 50)
button.Position = UDim2.new(0.06, 0, 0.42, 0)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBlack
button.TextSize = 24
button.Text = "disallowed"
button.TextScaled = false
button.AutoButtonColor = true
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 11)
btnCorner.Parent = button

-- Button black stroke
local btnBlackStroke = Instance.new("UIStroke")
btnBlackStroke.Color = Color3.fromRGB(0, 0, 0)
btnBlackStroke.Thickness = 5
btnBlackStroke.Transparency = 0
btnBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnBlackStroke.Parent = button

-- Button wave stroke
local btnWaveStroke = Instance.new("UIStroke")
btnWaveStroke.Color = Color3.fromRGB(255, 255, 255)
btnWaveStroke.Thickness = 3
btnWaveStroke.Transparency = 0.35
btnWaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnWaveStroke.ZIndex = 2
btnWaveStroke.Parent = button

local btnWaveGradient = Instance.new("UIGradient")
btnWaveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
btnWaveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
btnWaveGradient.Rotation = 0
btnWaveGradient.Parent = btnWaveStroke

-- Pulse on button wave
TweenService:Create(btnWaveStroke, pulseInfo, {
    Thickness = 5,
    Transparency = 0.08
}):Play()

-- Button wave rotation
RunService.Heartbeat:Connect(function(dt)
    btnWaveGradient.Rotation = (btnWaveGradient.Rotation + 140 * dt) % 360
end)

-- Hover effect
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- Dragging
local dragging = false
local dragStart, startPos, dragInput

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Cooldown + state
local onCooldown = false
local isAllowed = false  -- starts false → disallowed

-- Fire function
local function fireAllPanels()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return 0 end

    local count = 0
    for _, plot in ipairs(plots:GetChildren()) do
        local friendPanel = plot:FindFirstChild("FriendPanel", true)
        if friendPanel then
            local main = friendPanel:FindFirstChild("Main")
            if main then
                for _, obj in ipairs(main:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        fireproximityprompt(obj)
                        count += 1
                    end
                end
            end
        end
    end
    return count
end

-- Button click: toggle + fire every time + cooldown
button.Activated:Connect(function()
    if onCooldown then return end

    onCooldown = true
    button.Text = "wait 1s..."
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

    isAllowed = not isAllowed

    if isAllowed then
        button.Text = "allowed"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        button.TextColor3 = Color3.new(1,1,1)
    else
        button.Text = "disallowed"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        button.TextColor3 = Color3.new(1,1,1)
    end

    fireAllPanels()

    task.delay(1, function()
        onCooldown = false
    end)
end)

print("Yogi Allower GUI loaded - title size 20")
