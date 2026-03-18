-- RakNet Desync + Freeze Animation (PURE FROZEN STATUE while you can MOVE) — Yogi Style GUI
-- Added AUTO clone placement + Change With Clone swap on Desync ON
-- GUI exactly as your example: 170×155, waves/pulse/dragging/hover/strokes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ====================== GUI SETUP ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YogiDesync"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 170, 0, 155)
frame.Position = UDim2.new(0.5, -85, 0.88, -77)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local blackStroke = Instance.new("UIStroke")
blackStroke.Color = Color3.fromRGB(0, 0, 0)
blackStroke.Thickness = 5
blackStroke.Transparency = 0
blackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
blackStroke.Parent = frame

local waveStroke = Instance.new("UIStroke")
waveStroke.Color = Color3.fromRGB(255, 255, 255)
waveStroke.Thickness = 2.8
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

local pulseInfo = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(waveStroke, pulseInfo, {Thickness = 4.5, Transparency = 0.05}):Play()

RunService.Heartbeat:Connect(function(dt)
    waveGradient.Rotation = (waveGradient.Rotation + 180 * dt) % 360
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.new(0, 8, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Yogi Desync"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextScaled = true
title.Parent = frame

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -20, 0, 95)
btnContainer.Position = UDim2.new(0, 10, 0, 42)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = frame

local desyncButton = Instance.new("TextButton")
desyncButton.Size = UDim2.new(1, 0, 0.49, -4)
desyncButton.Position = UDim2.new(0, 0, 0, 0)
desyncButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
desyncButton.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncButton.Font = Enum.Font.GothamBlack
desyncButton.TextSize = 20
desyncButton.Text = "Desync: OFF"
desyncButton.AutoButtonColor = true
desyncButton.Parent = btnContainer

local desyncCorner = Instance.new("UICorner")
desyncCorner.CornerRadius = UDim.new(0, 10)
desyncCorner.Parent = desyncButton

local desyncBlackStroke = Instance.new("UIStroke")
desyncBlackStroke.Color = Color3.fromRGB(0, 0, 0)
desyncBlackStroke.Thickness = 4
desyncBlackStroke.Transparency = 0
desyncBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
desyncBlackStroke.Parent = desyncButton

local desyncWaveStroke = Instance.new("UIStroke")
desyncWaveStroke.Color = Color3.fromRGB(255, 255, 255)
desyncWaveStroke.Thickness = 2.5
desyncWaveStroke.Transparency = 0.35
desyncWaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
desyncWaveStroke.ZIndex = 2
desyncWaveStroke.Parent = desyncButton

local desyncWaveGradient = Instance.new("UIGradient")
desyncWaveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
desyncWaveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1)
})
desyncWaveGradient.Rotation = 0
desyncWaveGradient.Parent = desyncWaveStroke

TweenService:Create(desyncWaveStroke, pulseInfo, {Thickness = 4.2, Transparency = 0.08}):Play()

RunService.Heartbeat:Connect(function(dt)
    desyncWaveGradient.Rotation = (desyncWaveGradient.Rotation + 140 * dt) % 360
end)

local freezeButton = Instance.new("TextButton")
freezeButton.Size = UDim2.new(1, 0, 0.49, -4)
freezeButton.Position = UDim2.new(0, 0, 0.51, 2)
freezeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
freezeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
freezeButton.Font = Enum.Font.GothamBlack
freezeButton.TextSize = 20
freezeButton.Text = "Freeze: OFF"
freezeButton.AutoButtonColor = true
freezeButton.Parent = btnContainer

local freezeCorner = Instance.new("UICorner")
freezeCorner.CornerRadius = UDim.new(0, 10)
freezeCorner.Parent = freezeButton

local freezeBlackStroke = Instance.new("UIStroke")
freezeBlackStroke.Color = Color3.fromRGB(0, 0, 0)
freezeBlackStroke.Thickness = 4
freezeBlackStroke.Transparency = 0
freezeBlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
freezeBlackStroke.Parent = freezeButton

local freezeWaveStroke = Instance.new("UIStroke")
freezeWaveStroke.Color = Color3.fromRGB(255, 255, 255)
freezeWaveStroke.Thickness = 2.5
freezeWaveStroke.Transparency = 0.35
freezeWaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
freezeWaveStroke.ZIndex = 2
freezeWaveStroke.Parent = freezeButton

local freezeWaveGradient = Instance.new("UIGradient")
freezeWaveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
freezeWaveGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.35,0),
    NumberSequenceKeypoint.new(0.65,0),
    NumberSequenceKeypoint.new(1,1)
})
freezeWaveGradient.Rotation = 0
freezeWaveGradient.Parent = freezeWaveStroke

TweenService:Create(freezeWaveStroke, pulseInfo, {Thickness = 4.3, Transparency = 0.06}):Play()

RunService.Heartbeat:Connect(function(dt)
    freezeWaveGradient.Rotation = (freezeWaveGradient.Rotation + 220 * dt) % 360
end)

-- Hover effects
for _, btn in {desyncButton, freezeButton} do
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

-- Dragging
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
    if dragging and dragInput then update(dragInput) end
end)

-- ====================== DESYNC & AUTO CLONE PLACEMENT ======================
if not raknet or not raknet.desync then
    print("ERROR: raknet.desync not found! Update Delta.")
else
    print("raknet.desync FOUND!")
end

local desyncEnabled = false

local function updateDesyncUI()
    desyncButton.Text = desyncEnabled and "Desync: ON" or "Desync: OFF"
end

local function autoPlaceCloneAndSwap()
    print("[AUTO CLONE] Starting placement + swap...")

    local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
    local useItem = net and (net:FindFirstChild("RE/UseItem") or net:FindFirstChild("UseItem"))
    local onTeleport = net and (net:FindFirstChild("RE/QuantumCloner/OnTeleport") or net:FindFirstChild("OnTeleport") or net:FindFirstChild("QuantumCloner/OnTeleport"))

    if not useItem or not onTeleport then
        print("[AUTO CLONE] Remotes not found - manual placement needed")
        StarterGui:SetCore("SendNotification", {Title = "Auto Clone", Text = "Remotes not found. Place clone manually.", Duration = 5})
        return
    end

    local char = LocalPlayer.Character
    if not char then print("[AUTO CLONE] No character") return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then print("[AUTO CLONE] No HRP") return end

    local backpack = LocalPlayer:WaitForChild("Backpack")

    local clonerTool = backpack:FindFirstChild("Quantum Cloner") or char:FindFirstChild("Quantum Cloner") or backpack:FindFirstChild("QuantumCloner")
    if not clonerTool then
        print("[AUTO CLONE] No Quantum Cloner tool")
        StarterGui:SetCore("SendNotification", {Title = "No Cloner", Text = "Equip Quantum Cloner first!", Duration = 5})
        return
    end

    print("[AUTO CLONE] Equipping tool...")
    clonerTool.Parent = char

    -- Activate placement
    pcall(function() clonerTool:Activate() end)
    pcall(useItem.FireServer, useItem)
    pcall(useItem.FireServer, useItem)

    print("[AUTO CLONE] Lag spike + swap...")
    setfflag("WorldStepMax", "-9999999")

    pcall(onTeleport.FireServer, onTeleport, root.Position)
    pcall(onTeleport.FireServer, onTeleport)

    task.wait(0.8)
    setfflag("WorldStepMax", "-1")

    print("[AUTO CLONE] Placement + swap attempted")
end

local function toggleDesync()
    desyncEnabled = not desyncEnabled
    
    if raknet and raknet.desync then
        if desyncEnabled then
            autoPlaceCloneAndSwap()  -- Auto place clone + swap when turning ON
        end
        raknet.desync(desyncEnabled)
        print("Desync toggled to " .. (desyncEnabled and "ON" or "OFF"))
    else
        desyncEnabled = false
        print("raknet.desync not available!")
    end
    
    updateDesyncUI()
end

desyncButton.Activated:Connect(toggleDesync)

-- ====================== FREEZE LOGIC (frozen statue - you can move) ======================
local freezeEnabled = false
local freezeConnection = nil

local function freezeStatue()
    if not freezeEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Stop ALL animations every frame (no sway, no run, no jump anim)
    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    
    -- Optional: force no state animations
    hum:ChangeState(Enum.HumanoidStateType.None)
end

local function toggleFreeze()
    freezeEnabled = not freezeEnabled
    
    if freezeEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            hum:ChangeState(Enum.HumanoidStateType.None)
        end
        
        if not freezeConnection then
            freezeConnection = RunService.Stepped:Connect(freezeStatue)
        end
        
        freezeButton.Text = "Freeze: ON"
    else
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
        
        freezeButton.Text = "Freeze: OFF"
    end
end

freezeButton.Activated:Connect(toggleFreeze)

-- Respawn fix
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.8)
    if freezeEnabled then
        local hum = newChar:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            hum:ChangeState(Enum.HumanoidStateType.None)
        end
        if freezeConnection then freezeConnection:Disconnect() end
        freezeConnection = RunService.Stepped:Connect(freezeStatue)
    end
end)

-- Hotkey RightShift for Desync
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleDesync()
    end
end)

-- Init
updateDesyncUI()

print("Yogi Desync GUI loaded — 170×155, same layout as your example")
print("Desync ON → auto places clone & tries Change With Clone swap")
print("Freeze ON = frozen statue (no animation), but you can move freely")
print("RightShift toggles Desync")
