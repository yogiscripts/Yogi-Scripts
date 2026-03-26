-- Yogi Duels GUI - FULL SCRIPT
-- Added Infinite Jump & Slow Falling buttons with same design as others
-- All previous features unchanged

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

-- Clear old GUI
local oldGui = playerGui:FindFirstChild("YogiDuelsGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YogiDuelsGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Outer container
local outer = Instance.new("Frame")
outer.Name = "Outer"
outer.Size = UDim2.new(0, 200, 0, 220)
outer.Position = UDim2.new(0.5, -100, 0.5, -110)
outer.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
outer.BorderSizePixel = 0
outer.ClipsDescendants = true
outer.Parent = screenGui

local outerCorner = Instance.new("UICorner")
outerCorner.CornerRadius = UDim.new(0, 14)
outerCorner.Parent = outer

local blackStroke = Instance.new("UIStroke")
blackStroke.Color = Color3.fromRGB(0, 0, 0)
blackStroke.Thickness = 5
blackStroke.Transparency = 0
blackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
blackStroke.Parent = outer

local waveStroke = Instance.new("UIStroke")
waveStroke.Color = Color3.fromRGB(255, 255, 255)
waveStroke.Thickness = 2.8
waveStroke.Transparency = 0.3
waveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
waveStroke.ZIndex = 2
waveStroke.Parent = outer

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

local pulseInfo = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(waveStroke, pulseInfo, {Thickness = 4.5, Transparency = 0.05}):Play()

RunService.Heartbeat:Connect(function(dt)
    waveGradient.Rotation = (waveGradient.Rotation + 180 * dt) % 360
end)

-- Title bar - DRAGGABLE
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
titleBar.BorderSizePixel = 0
titleBar.Parent = outer

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Yogi Duels"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize & Exit
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -54, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 24, 0, 24)
exitBtn.Position = UDim2.new(1, -28, 0, 6)
exitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
exitBtn.Text = "×"
exitBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 20
exitBtn.BorderSizePixel = 0
exitBtn.Parent = titleBar

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 6)
exitCorner.Parent = exitBtn

-- ScrollingFrame
local scroller = Instance.new("ScrollingFrame")
scroller.Name = "Scroller"
scroller.Size = UDim2.new(1, -14, 1, -50)
scroller.Position = UDim2.new(0, 7, 0, 42)
scroller.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
scroller.BorderSizePixel = 0
scroller.ScrollBarThickness = 6
scroller.ScrollBarImageColor3 = Color3.fromRGB(160, 160, 160)
scroller.ScrollBarImageTransparency = 0.3
scroller.CanvasSize = UDim2.new(0, 0, 2, 0)
scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroller.ScrollingDirection = Enum.ScrollingDirection.Y
scroller.ScrollingEnabled = true
scroller.Parent = outer

local scrollerCorner = Instance.new("UICorner")
scrollerCorner.CornerRadius = UDim.new(0, 10)
scrollerCorner.Parent = scroller

local scrollerBlackStroke = Instance.new("UIStroke")
scrollerBlackStroke.Color = Color3.fromRGB(0, 0, 0)
scrollerBlackStroke.Thickness = 4
scrollerBlackStroke.Transparency = 0
scrollerBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
scrollerBlackStroke.Parent = scroller

local scrollerWave = Instance.new("UIStroke")
scrollerWave.Color = Color3.fromRGB(255, 255, 255)
scrollerWave.Thickness = 2.5
scrollerWave.Transparency = 0.35
scrollerWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
scrollerWave.ZIndex = 2
scrollerWave.Parent = scroller

local scrollerWaveGrad = Instance.new("UIGradient")
scrollerWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
scrollerWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
scrollerWaveGrad.Rotation = 0
scrollerWaveGrad.Parent = scrollerWave

TweenService:Create(scrollerWave, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    scrollerWaveGrad.Rotation = (scrollerWaveGrad.Rotation + 140 * dt) % 360
end)

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scroller

-- Button container
local btnContainer = Instance.new("Frame")
btnContainer.Name = "ButtonContainer"
btnContainer.Size = UDim2.new(1, -20, 1, -10)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = scroller

-- Auto Steal Toggle
local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, 0, 0, 32)
autoButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
autoButton.TextColor3 = Color3.fromRGB(220, 220, 220)
autoButton.Font = Enum.Font.GothamBold
autoButton.TextSize = 14
autoButton.Text = "Auto Steal: Off"
autoButton.Parent = btnContainer

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoButton

local autoBlackStroke = Instance.new("UIStroke")
autoBlackStroke.Color = Color3.fromRGB(0, 0, 0)
autoBlackStroke.Thickness = 4
autoBlackStroke.Transparency = 0
autoBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
autoBlackStroke.Parent = autoButton

local autoWave = Instance.new("UIStroke")
autoWave.Color = Color3.fromRGB(255, 255, 255)
autoWave.Thickness = 2.5
autoWave.Transparency = 0.35
autoWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
autoWave.ZIndex = 2
autoWave.Parent = autoButton

local autoWaveGrad = Instance.new("UIGradient")
autoWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
autoWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
autoWaveGrad.Rotation = 0
autoWaveGrad.Parent = autoWave

TweenService:Create(autoWave, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    autoWaveGrad.Rotation = (autoWaveGrad.Rotation + 140 * dt) % 360
end)

-- Steal Speed Toggle (25)
local stealSpeedButton = Instance.new("TextButton")
stealSpeedButton.Size = UDim2.new(1, 0, 0, 32)
stealSpeedButton.Position = UDim2.new(0, 0, 0, 42)
stealSpeedButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
stealSpeedButton.TextColor3 = Color3.fromRGB(220, 220, 220)
stealSpeedButton.Font = Enum.Font.GothamBold
stealSpeedButton.TextSize = 14
stealSpeedButton.Text = "Steal Speed: Off"
stealSpeedButton.Parent = btnContainer

local stealSpeedCorner = Instance.new("UICorner")
stealSpeedCorner.CornerRadius = UDim.new(0, 8)
stealSpeedCorner.Parent = stealSpeedButton

local stealSpeedBlackStroke = Instance.new("UIStroke")
stealSpeedBlackStroke.Color = Color3.fromRGB(0, 0, 0)
stealSpeedBlackStroke.Thickness = 4
stealSpeedBlackStroke.Transparency = 0
stealSpeedBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stealSpeedBlackStroke.Parent = stealSpeedButton

local stealSpeedWave = Instance.new("UIStroke")
stealSpeedWave.Color = Color3.fromRGB(255, 255, 255)
stealSpeedWave.Thickness = 2.5
stealSpeedWave.Transparency = 0.35
stealSpeedWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stealSpeedWave.ZIndex = 2
stealSpeedWave.Parent = stealSpeedButton

local stealSpeedWaveGrad = Instance.new("UIGradient")
stealSpeedWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
stealSpeedWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.35,0),
    NumberSequenceKeypoint.new(0.65,0),
    NumberSequenceKeypoint.new(1,1)
})
stealSpeedWaveGrad.Rotation = 0
stealSpeedWaveGrad.Parent = stealSpeedWave

TweenService:Create(stealSpeedWave, pulseInfo, {Thickness = 4.3, Transparency = 0.06}):Play()

RunService.Heartbeat:Connect(function(dt)
    stealSpeedWaveGrad.Rotation = (stealSpeedWaveGrad.Rotation + 220 * dt) % 360
end)

-- Regular Speed Toggle (55)
local regularSpeedButton = Instance.new("TextButton")
regularSpeedButton.Size = UDim2.new(1, 0, 0, 32)
regularSpeedButton.Position = UDim2.new(0, 0, 0, 84)
regularSpeedButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
regularSpeedButton.TextColor3 = Color3.fromRGB(220, 220, 220)
regularSpeedButton.Font = Enum.Font.GothamBold
regularSpeedButton.TextSize = 14
regularSpeedButton.Text = "Speed: Off"
regularSpeedButton.Parent = btnContainer

local regularSpeedCorner = Instance.new("UICorner")
regularSpeedCorner.CornerRadius = UDim.new(0, 8)
regularSpeedCorner.Parent = regularSpeedButton

local regularSpeedBlackStroke = Instance.new("UIStroke")
regularSpeedBlackStroke.Color = Color3.fromRGB(0, 0, 0)
regularSpeedBlackStroke.Thickness = 4
regularSpeedBlackStroke.Transparency = 0
regularSpeedBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
regularSpeedBlackStroke.Parent = regularSpeedButton

local regularSpeedWave = Instance.new("UIStroke")
regularSpeedWave.Color = Color3.fromRGB(255, 255, 255)
regularSpeedWave.Thickness = 2.5
regularSpeedWave.Transparency = 0.35
regularSpeedWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
regularSpeedWave.ZIndex = 2
regularSpeedWave.Parent = regularSpeedButton

local regularSpeedWaveGrad = Instance.new("UIGradient")
regularSpeedWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
regularSpeedWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.35,0),
    NumberSequenceKeypoint.new(0.65,0),
    NumberSequenceKeypoint.new(1,1)
})
regularSpeedWaveGrad.Rotation = 0
regularSpeedWaveGrad.Parent = regularSpeedWave

TweenService:Create(regularSpeedWave, pulseInfo, {Thickness = 4.3, Transparency = 0.06}):Play()

RunService.Heartbeat:Connect(function(dt)
    regularSpeedWaveGrad.Rotation = (regularSpeedWaveGrad.Rotation + 220 * dt) % 360
end)

-- Infinite Jump Toggle (new)
local infJumpButton = Instance.new("TextButton")
infJumpButton.Size = UDim2.new(1, 0, 0, 32)
infJumpButton.Position = UDim2.new(0, 0, 0, 126)
infJumpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infJumpButton.TextColor3 = Color3.fromRGB(220, 220, 220)
infJumpButton.Font = Enum.Font.GothamBold
infJumpButton.TextSize = 14
infJumpButton.Text = "Infinite Jump: Off"
infJumpButton.Parent = btnContainer

local infJumpCorner = Instance.new("UICorner")
infJumpCorner.CornerRadius = UDim.new(0, 8)
infJumpCorner.Parent = infJumpButton

local infJumpBlackStroke = Instance.new("UIStroke")
infJumpBlackStroke.Color = Color3.fromRGB(0, 0, 0)
infJumpBlackStroke.Thickness = 4
infJumpBlackStroke.Transparency = 0
infJumpBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
infJumpBlackStroke.Parent = infJumpButton

local infJumpWave = Instance.new("UIStroke")
infJumpWave.Color = Color3.fromRGB(255, 255, 255)
infJumpWave.Thickness = 2.5
infJumpWave.Transparency = 0.35
infJumpWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
infJumpWave.ZIndex = 2
infJumpWave.Parent = infJumpButton

local infJumpWaveGrad = Instance.new("UIGradient")
infJumpWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
infJumpWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
infJumpWaveGrad.Rotation = 0
infJumpWaveGrad.Parent = infJumpWave

TweenService:Create(infJumpWave, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    infJumpWaveGrad.Rotation = (infJumpWaveGrad.Rotation + 140 * dt) % 360
end)

-- Slow Falling Toggle (new)
local slowFallButton = Instance.new("TextButton")
slowFallButton.Size = UDim2.new(1, 0, 0, 32)
slowFallButton.Position = UDim2.new(0, 0, 0, 168)
slowFallButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
slowFallButton.TextColor3 = Color3.fromRGB(220, 220, 220)
slowFallButton.Font = Enum.Font.GothamBold
slowFallButton.TextSize = 14
slowFallButton.Text = "Slow Falling: Off"
slowFallButton.Parent = btnContainer

local slowFallCorner = Instance.new("UICorner")
slowFallCorner.CornerRadius = UDim.new(0, 8)
slowFallCorner.Parent = slowFallButton

local slowFallBlackStroke = Instance.new("UIStroke")
slowFallBlackStroke.Color = Color3.fromRGB(0, 0, 0)
slowFallBlackStroke.Thickness = 4
slowFallBlackStroke.Transparency = 0
slowFallBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slowFallBlackStroke.Parent = slowFallButton

local slowFallWave = Instance.new("UIStroke")
slowFallWave.Color = Color3.fromRGB(255, 255, 255)
slowFallWave.Thickness = 2.5
slowFallWave.Transparency = 0.35
slowFallWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slowFallWave.ZIndex = 2
slowFallWave.Parent = slowFallButton

local slowFallWaveGrad = Instance.new("UIGradient")
slowFallWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
slowFallWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
slowFallWaveGrad.Rotation = 0
slowFallWaveGrad.Parent = slowFallWave

TweenService:Create(slowFallWave, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    slowFallWaveGrad.Rotation = (slowFallWaveGrad.Rotation + 140 * dt) % 360
end)

-- Xray Toggle (shifted down)
local xrayButton = Instance.new("TextButton")
xrayButton.Size = UDim2.new(1, 0, 0, 32)
xrayButton.Position = UDim2.new(0, 0, 0, 210)
xrayButton.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
xrayButton.TextColor3 = Color3.fromRGB(245, 245, 245)
xrayButton.Font = Enum.Font.GothamBold
xrayButton.TextSize = 14
xrayButton.Text = "Xray: OFF"
xrayButton.Parent = btnContainer

local xrayCorner = Instance.new("UICorner")
xrayCorner.CornerRadius = UDim.new(0, 8)
xrayCorner.Parent = xrayButton

local xrayBlackStroke = Instance.new("UIStroke")
xrayBlackStroke.Color = Color3.fromRGB(0,0,0)
xrayBlackStroke.Thickness = 5
xrayBlackStroke.Transparency = 0
xrayBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
xrayBlackStroke.Parent = xrayButton

local xrayWave = Instance.new("UIStroke")
xrayWave.Color = Color3.fromRGB(255,255,255)
xrayWave.Thickness = 3
xrayWave.Transparency = 0.4
xrayWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
xrayWave.ZIndex = 2
xrayWave.Parent = xrayButton

local xrayWaveGrad = Instance.new("UIGradient")
xrayWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
xrayWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 0),
    NumberSequenceKeypoint.new(0.58, 0),
    NumberSequenceKeypoint.new(1, 1)
})
xrayWaveGrad.Rotation = 0
xrayWaveGrad.Parent = xrayWave

TweenService:Create(xrayWave, pulseInfo, {Thickness = 5, Transparency = 0.1}):Play()

RunService.Heartbeat:Connect(function(dt)
    xrayWaveGrad.Rotation = (xrayWaveGrad.Rotation + 130 * dt) % 360
end)

-- Anti-Ragdoll Toggle (shifted down)
local antiRagdollButton = Instance.new("TextButton")
antiRagdollButton.Size = UDim2.new(1, 0, 0, 32)
antiRagdollButton.Position = UDim2.new(0, 0, 0, 252)
antiRagdollButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
antiRagdollButton.TextColor3 = Color3.new(1,1,1)
antiRagdollButton.Font = Enum.Font.GothamBold
antiRagdollButton.TextSize = 14
antiRagdollButton.Text = "ANTI-RAGDOLL: OFF"
antiRagdollButton.Parent = btnContainer

local antiCorner = Instance.new("UICorner")
antiCorner.CornerRadius = UDim.new(0, 8)
antiCorner.Parent = antiRagdollButton

local antiBlackStroke = Instance.new("UIStroke")
antiBlackStroke.Color = Color3.fromRGB(0,0,0)
antiBlackStroke.Thickness = 5
antiBlackStroke.Transparency = 0
antiBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
antiBlackStroke.Parent = antiRagdollButton

local antiWave = Instance.new("UIStroke")
antiWave.Color = Color3.fromRGB(255,255,255)
antiWave.Thickness = 3
antiWave.Transparency = 0.4
antiWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
antiWave.ZIndex = 2
antiWave.Parent = antiRagdollButton

local antiWaveGrad = Instance.new("UIGradient")
antiWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
antiWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 0),
    NumberSequenceKeypoint.new(0.58, 0),
    NumberSequenceKeypoint.new(1, 1)
})
antiWaveGrad.Rotation = 0
antiWaveGrad.Parent = antiWave

TweenService:Create(antiWave, pulseInfo, {Thickness = 5, Transparency = 0.1}):Play()

RunService.Heartbeat:Connect(function(dt)
    antiWaveGrad.Rotation = (antiWaveGrad.Rotation + 130 * dt) % 360
end)

-- Player ESP Toggle (shifted down)
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, 0, 0, 32)
espButton.Position = UDim2.new(0, 0, 0, 294)
espButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espButton.TextColor3 = Color3.fromRGB(220, 220, 220)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 14
espButton.Text = "PLAYER ESP: OFF"
espButton.Parent = btnContainer

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

local espBlackStroke = Instance.new("UIStroke")
espBlackStroke.Color = Color3.fromRGB(0, 0, 0)
espBlackStroke.Thickness = 4
espBlackStroke.Transparency = 0
espBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espBlackStroke.Parent = espButton

local espWave = Instance.new("UIStroke")
espWave.Color = Color3.fromRGB(255, 255, 255)
espWave.Thickness = 2.5
espWave.Transparency = 0.35
espWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espWave.ZIndex = 2
espWave.Parent = espButton

local espWaveGrad = Instance.new("UIGradient")
espWaveGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
espWaveGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
espWaveGrad.Rotation = 0
espWaveGrad.Parent = espWave

TweenService:Create(espWave, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    espWaveGrad.Rotation = (espWaveGrad.Rotation + 140 * dt) % 360
end)

-- Hover effects
for _, btn in {autoButton, stealSpeedButton, regularSpeedButton, infJumpButton, slowFallButton, xrayButton, antiRagdollButton, espButton} do
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = btn.Name == "XrayToggle" and Color3.fromRGB(28, 28, 32) or Color3.fromRGB(30, 30, 30)
    end)
end

-- ────────────────────────────────────────────────
-- AUTO STEAL LOGIC (unchanged)
local stealCooldown = 0.2
local autoStealEnabled = false
local loopThread = nil

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local HRP = getHRP()

player.CharacterAdded:Connect(function(newChar)
    HRP = newChar:WaitForChild("HumanoidRootPart", 5)
end)

local function getPromptPart(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Model") then
        return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
    end
    if parent:IsA("Attachment") then return parent.Parent end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

local function findNearestStealPrompt()
    local nearestPrompt = nil
    local minDist = math.huge
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for _, desc in pairs(plots:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled and desc.ActionText == "Steal" then
            desc.HoldDuration = 0
            
            local part = getPromptPart(desc)
            if part and HRP then
                local dist = (HRP.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPrompt = desc
                end
            end
        end
    end
    return nearestPrompt
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsDescendantOf(workspace) then return end

    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = 9e9
    prompt.RequiresLineOfSight = false
    prompt.ClickablePrompt = true

    pcall(function()
        fireproximityprompt(prompt, 9e9, 0)
    end)

    pcall(function()
        prompt:InputHoldBegin()
        prompt:InputHoldEnd()
    end)
end

local function autoStealLoop()
    while autoStealEnabled do
        if HRP then
            local prompt = findNearestStealPrompt()
            if prompt then
                triggerPrompt(prompt)
            end
        end
        task.wait(stealCooldown)
    end
end

local function updateAutoUI()
    autoButton.Text = autoStealEnabled and "Auto Steal: On" or "Auto Steal: Off"
end

local function toggleAutoSteal()
    autoStealEnabled = not autoStealEnabled
    if autoStealEnabled then
        if not loopThread then
            loopThread = task.spawn(autoStealLoop)
        end
    else
        loopThread = nil
    end
    updateAutoUI()
end

autoButton.Activated:Connect(toggleAutoSteal)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleAutoSteal()
    end
end)

updateAutoUI()

for _, desc in pairs(workspace:GetDescendants()) do
    if desc:IsA("ProximityPrompt") and desc.ActionText == "Steal" then
        desc.HoldDuration = 0
    end
end

-- Steal Speed logic (25)
local stealSpeedEnabled = false
local stealSpeedConnection

local function enableStealSpeed()
    if stealSpeedConnection then stealSpeedConnection:Disconnect() end
    stealSpeedConnection = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if humanoid and root then
            local state = humanoid:GetState()
            if state ~= Enum.HumanoidStateType.Seated and state ~= Enum.HumanoidStateType.Dead then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.Velocity = Vector3.new(
                        moveDir.X * 25,
                        root.Velocity.Y,
                        moveDir.Z * 25
                    )
                end
            end
        end
    end)
end

local function disableStealSpeed()
    if stealSpeedConnection then stealSpeedConnection:Disconnect() stealSpeedConnection = nil end
end

local function updateStealSpeedButton()
    stealSpeedButton.Text = stealSpeedEnabled and "Steal Speed: On" or "Steal Speed: Off"
end

local function toggleStealSpeed()
    stealSpeedEnabled = not stealSpeedEnabled
    updateStealSpeedButton()
    if stealSpeedEnabled then enableStealSpeed() else disableStealSpeed() end
end

stealSpeedButton.Activated:Connect(toggleStealSpeed)

player.CharacterAdded:Connect(function()
    task.wait(0.6)
    if stealSpeedEnabled then enableStealSpeed() end
end)

-- Regular Speed logic (55)
local regularSpeedEnabled = false
local regularSpeedConnection

local function enableRegularSpeed()
    if regularSpeedConnection then regularSpeedConnection:Disconnect() end
    regularSpeedConnection = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if humanoid and root then
            local state = humanoid:GetState()
            if state ~= Enum.HumanoidStateType.Seated and state ~= Enum.HumanoidStateType.Dead then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.Velocity = Vector3.new(
                        moveDir.X * 55,
                        root.Velocity.Y,
                        moveDir.Z * 55
                    )
                end
            end
        end
    end)
end

local function disableRegularSpeed()
    if regularSpeedConnection then regularSpeedConnection:Disconnect() regularSpeedConnection = nil end
end

local function updateRegularSpeedButton()
    regularSpeedButton.Text = regularSpeedEnabled and "Speed: On" or "Speed: Off"
end

local function toggleRegularSpeed()
    regularSpeedEnabled = not regularSpeedEnabled
    updateRegularSpeedButton()
    if regularSpeedEnabled then enableRegularSpeed() else disableRegularSpeed() end
end

regularSpeedButton.Activated:Connect(toggleRegularSpeed)

player.CharacterAdded:Connect(function()
    task.wait(0.6)
    if regularSpeedEnabled then enableRegularSpeed() end
end)

-- Infinite Jump logic (new button)
local infJumpEnabled = false
local infJumpConn

local function toggleInfiniteJump(enabled)
    infJumpEnabled = enabled
    infJumpButton.Text = enabled and "Infinite Jump: On" or "Infinite Jump: Off"
    
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end

    if enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 52, hrp.Velocity.Z)
                end
            end
        end)
    end
end

infJumpButton.Activated:Connect(function()
    toggleInfiniteJump(not infJumpEnabled)
end)

-- Slow Falling logic (new button)
local slowFallEnabled = false
local slowFallConn

local function toggleSlowFalling(enabled)
    slowFallEnabled = enabled
    slowFallButton.Text = enabled and "Slow Falling: On" or "Slow Falling: Off"
    
    if slowFallConn then
        slowFallConn:Disconnect()
        slowFallConn = nil
    end

    if enabled then
        slowFallConn = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Velocity.Y < -1 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -12, hrp.Velocity.Z)
                end
            end
        end)
    end
end

slowFallButton.Activated:Connect(function()
    toggleSlowFalling(not slowFallEnabled)
end)

-- Xray logic (unchanged)
local xrayOn = false
local originalCache = {}

local function findDecorationParts()
    local parts = {}
    for _, plotFolder in ipairs(workspace:GetChildren()) do
        if plotFolder:IsA("Folder") and plotFolder.Name == "Plots" then
            for _, model in ipairs(plotFolder:GetChildren()) do
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

local function updateXrayButton()
    xrayButton.Text = xrayOn and "Xray: ON" or "Xray: OFF"
end

local function toggleXray()
    xrayOn = not xrayOn
    if xrayOn then
        local parts = findDecorationParts()
        for _, part in ipairs(parts) do
            if not originalCache[part] then
                originalCache[part] = part.Transparency
            end
            part.Transparency = 0.5
        end
    else
        for part, orig in pairs(originalCache) do
            if part and part.Parent then
                part.Transparency = orig
            end
        end
        originalCache = {}
    end
    updateXrayButton()
end

xrayButton.Activated:Connect(toggleXray)

-- Anti-Ragdoll logic (unchanged)
local antiRagdollEnabled = false
local isBoosting = false
local ragdollConnections = {}
local cachedCharData = {}
local BOOST_SPEED = 400
local DEFAULT_SPEED = 16

local function cacheCharacterData()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    cachedCharData = {character = char, humanoid = hum, root = root}
    return true
end

local function disconnectAll()
    for _, conn in ipairs(ragdollConnections) do pcall(conn.Disconnect, conn) end
    ragdollConnections = {}
end

local function isRagdolled()
    if not cachedCharData.humanoid then return false end
    local state = cachedCharData.humanoid:GetState()
    if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then return true end
    local endTime = player:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
    return false
end

local function forceExitRagdoll()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    pcall(function() player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    for _, v in ipairs(cachedCharData.character:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or (v:IsA("Attachment") and v.Name:find("Ragdoll")) then
            v:Destroy()
        end
    end
    if not isBoosting then
        isBoosting = true
        cachedCharData.humanoid.WalkSpeed = BOOST_SPEED
    end
    if cachedCharData.humanoid.Health > 0 then
        cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    cachedCharData.root.Anchored = false
end

local function antiRagdollLoop()
    while antiRagdollEnabled do
        task.wait()
        if not cachedCharData.character or not cachedCharData.character.Parent then
            task.wait(0.4)
            cacheCharacterData()
            continue
        end
        local currentlyRagdolled = isRagdolled()
        if currentlyRagdolled then
            forceExitRagdoll()
        elseif isBoosting and not currentlyRagdolled then
            isBoosting = false
            if cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = DEFAULT_SPEED end
        end
    end
end

local function toggleAntiRagdoll(enable)
    if enable == antiRagdollEnabled then return end
    antiRagdollEnabled = enable
    if enable then
        if not cacheCharacterData() then
            task.delay(1, function() if antiRagdollEnabled then toggleAntiRagdoll(true) end end)
            return
        end
        local camConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end
        end)
        table.insert(ragdollConnections, camConn)
        local respawnConn = player.CharacterAdded:Connect(function()
            isBoosting = false
            task.wait(0.4)
            cacheCharacterData()
        end)
        table.insert(ragdollConnections, respawnConn)
        task.spawn(antiRagdollLoop)
    else
        if isBoosting and cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = DEFAULT_SPEED end
        isBoosting = false
        disconnectAll()
        cachedCharData = {}
    end
end

local function updateAntiButton()
    antiRagdollButton.Text = antiRagdollEnabled and "ANTI-RAGDOLL: ON" or "ANTI-RAGDOLL: OFF"
end

antiRagdollButton.Activated:Connect(function()
    toggleAntiRagdoll(not antiRagdollEnabled)
    updateAntiButton()
end)

-- Player ESP logic (unchanged)
local playerESPEnabled = false
local playerESPConnections = {}

local function createPlayerESP(p)
    if p == player then return end
    
    local function setup(character)
        local hrp = character:WaitForChild("HumanoidRootPart", 8)
        if not hrp then return end
        
        if hrp:FindFirstChild("YogiESP") then hrp.YogiESP:Destroy() end
        
        local bb = Instance.new("BillboardGui")
        bb.Name = "YogiESP"
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 110, 0, 32)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = hrp
        
        local f = Instance.new("Frame", bb)
        f.Size = UDim2.new(1,0,1,0)
        f.BackgroundColor3 = Color3.fromRGB(10,10,10)
        f.BackgroundTransparency = 0.35
        f.BorderSizePixel = 0
        
        local name = Instance.new("TextLabel", f)
        name.Size = UDim2.new(1, -6, 0.55, 0)
        name.Position = UDim2.new(0, 3, 0, 1)
        name.BackgroundTransparency = 1
        name.Text = p.DisplayName or p.Name
        name.TextColor3 = Color3.fromRGB(255, 255, 255)
        name.Font = Enum.Font.GothamBold
        name.TextScaled = true
        
        local dist = Instance.new("TextLabel", f)
        dist.Size = UDim2.new(1, -6, 0.4, 0)
        dist.Position = UDim2.new(0, 3, 0.55, 0)
        dist.BackgroundTransparency = 1
        dist.TextColor3 = Color3.fromRGB(220, 220, 220)
        dist.Font = Enum.Font.GothamMedium
        dist.TextScaled = true
        
        local heartbeat = RunService.Heartbeat:Connect(function()
            if not playerESPEnabled then return end
            if not player.Character then return end
            local lhrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not lhrp or not hrp then return end
            local d = (hrp.Position - lhrp.Position).Magnitude
            dist.Text = math.floor(d + 0.5) .. " studs"
        end)
        
        table.insert(playerESPConnections, heartbeat)
    end
    
    if p.Character then task.spawn(setup, p.Character) end
    
    local charConn = p.CharacterAdded:Connect(function(char)
        if playerESPEnabled then
            task.wait(0.3)
            setup(char)
        end
    end)
    table.insert(playerESPConnections, charConn)
end

local function removeAllESP()
    for _, c in ipairs(playerESPConnections) do
        pcall(function() c:Disconnect() end)
    end
    playerESPConnections = {}
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local esp = hrp:FindFirstChild("YogiESP")
                if esp then esp:Destroy() end
            end
        end
    end
end

local function toggleESP()
    playerESPEnabled = not playerESPEnabled
    espButton.Text = playerESPEnabled and "PLAYER ESP: ON" or "PLAYER ESP: OFF"
    if playerESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            createPlayerESP(p)
        end
    else
        removeAllESP()
    end
end

espButton.Activated:Connect(toggleESP)

-- Init buttons
updateAutoUI()
updateStealSpeedButton()
updateRegularSpeedButton()
updateXrayButton()
updateAntiButton()

-- Minimize logic
local minimized = false
local originalSize = outer.Size

local function toggleMinimize()
    minimized = not minimized
    if minimized then
        TweenService:Create(outer, TweenInfo.new(0.3), {Size = UDim2.new(0, 200, 0, 36)}):Play()
        scroller.Visible = false
        minimizeBtn.Text = "+"
    else
        TweenService:Create(outer, TweenInfo.new(0.3), {Size = originalSize}):Play()
        scroller.Visible = true
        minimizeBtn.Text = "-"
    end
end

minimizeBtn.Activated:Connect(toggleMinimize)

-- Exit
exitBtn.Activated:Connect(function()
    screenGui:Destroy()
end)

-- Drag on title bar
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    outer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = outer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then updateInput(input) end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

print("[Yogi Duels] GUI loaded - Infinite Jump & Slow Falling buttons added with matching design")
