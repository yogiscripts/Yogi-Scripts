-- LocalScript (place in StarterPlayerScripts or StarterGui)

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YogiXray"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ── Main Frame ────────────────────────────────────────────────
local frame = Instance.new("Frame")
frame.Size       = UDim2.new(0, 190, 0, 115)
frame.Position   = UDim2.new(0.5, -95, 0.88, -60)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
frame.BorderSizePixel = 0
frame.Active     = true
frame.Parent     = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

-- Black outer stroke
local blackStroke = Instance.new("UIStroke")
blackStroke.Name = "BlackBase"
blackStroke.Color = Color3.fromRGB(0,0,0)
blackStroke.Thickness = 6
blackStroke.Transparency = 0
blackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
blackStroke.Parent = frame

-- Circulating wave stroke
local waveStroke = Instance.new("UIStroke")
waveStroke.Name = "WaveTop"
waveStroke.Color = Color3.fromRGB(255,255,255)
waveStroke.Thickness = 3.5
waveStroke.Transparency = 0.35
waveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
waveStroke.ZIndex = 2
waveStroke.Parent = frame

local waveGradient = Instance.new("UIGradient")
waveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
waveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
waveGradient.Rotation = 0
waveGradient.Parent = waveStroke

-- Pulse animation
local pulseInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(waveStroke, pulseInfo, {
    Thickness = 5.5,
    Transparency = 0.08
}):Play()

-- Wave rotation
RunService.Heartbeat:Connect(function(dt)
    waveGradient.Rotation = (waveGradient.Rotation + 165 * dt) % 360
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.Text = "Yogi Xray"
title.TextColor3 = Color3.fromRGB(235, 235, 240)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.88, 0, 0, 52)
button.Position = UDim2.new(0.06, 0, 0.48, 0)
button.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
button.TextColor3 = Color3.fromRGB(245, 245, 245)
button.Font = Enum.Font.GothamBlack
button.TextSize = 19
button.Text = "Xray: OFF"
button.AutoButtonColor = true
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = button

-- Button black stroke
local btnBlackStroke = Instance.new("UIStroke")
btnBlackStroke.Color = Color3.fromRGB(0,0,0)
btnBlackStroke.Thickness = 5
btnBlackStroke.Transparency = 0
btnBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnBlackStroke.Parent = button

-- Button wave stroke
local btnWaveStroke = Instance.new("UIStroke")
btnWaveStroke.Color = Color3.fromRGB(255,255,255)
btnWaveStroke.Thickness = 3
btnWaveStroke.Transparency = 0.4
btnWaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnWaveStroke.ZIndex = 2
btnWaveStroke.Parent = button

local btnWaveGradient = Instance.new("UIGradient")
btnWaveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
btnWaveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 0),
    NumberSequenceKeypoint.new(0.58, 0),
    NumberSequenceKeypoint.new(1, 1)
})
btnWaveGradient.Rotation = 0
btnWaveGradient.Parent = btnWaveStroke

TweenService:Create(btnWaveStroke, pulseInfo, {
    Thickness = 5,
    Transparency = 0.1
}):Play()

RunService.Heartbeat:Connect(function(dt)
    btnWaveGradient.Rotation = (btnWaveGradient.Rotation + 130 * dt) % 360
end)

-- Hover effect
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
end)

-- ── Xray Logic ─────────────────────────────────────────────────────
local isOn = false
local originalCache = {}   -- part → original transparency

local function findDecorationParts()
    local parts = {}
    local ws = workspace
    for _, plots in ipairs(ws:GetChildren()) do
        if plots:IsA("Folder") and plots.Name == "Plots" then
            for _, model in ipairs(plots:GetChildren()) do
                if model:IsA("Model") then
                    local dec = model:FindFirstChild("Decorations")
                    if dec and dec:IsA("Folder") then
                        for _, p in ipairs(dec:GetDescendants()) do
                            if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("UnionOperation") then
                                table.insert(parts, p)
                            end
                        end
                    end
                end
            end
        end
    end
    return parts
end

local function updateVisuals()
    if isOn then
        button.Text = "Xray: ON"
        button.BackgroundColor3 = Color3.fromRGB(55, 140, 90)   -- green = active
    else
        button.Text = "Xray: OFF"
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 32)    -- dark = off
    end
end

local function setOn()
    local parts = findDecorationParts()
    for _, part in ipairs(parts) do
        if not originalCache[part] then
            originalCache[part] = part.Transparency
        end
        part.Transparency = 0.5
    end
    isOn = true
    updateVisuals()
end

local function setOff()
    for part, orig in pairs(originalCache) do
        if part and part.Parent then
            part.Transparency = orig
        end
    end
    isOn = false
    updateVisuals()
end

button.Activated:Connect(function()
    if isOn then
        setOff()
    else
        setOn()
    end
end)

-- Dragging
local dragging, dragStart, startPos = false, nil, nil

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
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Initial state
updateVisuals()

print("[Yogi Xray] Loaded — black base + circulating white wave")
