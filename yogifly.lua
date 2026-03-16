-- Yogi Fly - Flying Carpet Edition (MAX SPEED CAPPED AT 80)
-- Speed box starts EMPTY • All text white • Max flying speed = 80
-- Equips/hides "Flying Carpet"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Controls
local PlayerScripts = player:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "YogiFlyGui"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 130)
frame.Position = UDim2.new(0.5, -80, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = sg

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
waveStroke.Thickness = 3
waveStroke.Transparency = 0.35
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

local pulseInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(waveStroke, pulseInfo, {Thickness = 4.8, Transparency = 0.1}):Play()

RunService.Heartbeat:Connect(function(dt)
    waveGradient.Rotation = (waveGradient.Rotation + 160 * dt) % 360
end)

-- Title - WHITE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 2)
title.BackgroundTransparency = 1
title.Text = "Yogi Fly"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

-- Fly Toggle Button - WHITE
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.88, 0, 0, 36)
flyButton.Position = UDim2.new(0.06, 0, 0.28, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBlack
flyButton.TextSize = 18
flyButton.Text = "FLY OFF"
flyButton.Parent = frame

local flyCorner = Instance.new("UICorner", flyButton)
flyCorner.CornerRadius = UDim.new(0, 10)

local flyWave = Instance.new("UIStroke", flyButton)
flyWave.Color = Color3.fromRGB(255,255,255)
flyWave.Thickness = 2.5
flyWave.Transparency = 0.4
flyWave.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
flyWave.ZIndex = 2

local flyGrad = Instance.new("UIGradient", flyWave)
flyGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
flyGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.4,0),
    NumberSequenceKeypoint.new(0.6,0),
    NumberSequenceKeypoint.new(1,1)
})

TweenService:Create(flyWave, pulseInfo, {Thickness = 5, Transparency = 0.12}):Play()
RunService.Heartbeat:Connect(function(dt)
    flyGrad.Rotation = (flyGrad.Rotation + 130 * dt) % 360
end)

-- Speed Box – STARTS EMPTY, placeholder WHITE
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.88, 0, 0, 34)
speedBox.Position = UDim2.new(0.06, 0, 0.65, 0)
speedBox.Text = ""                           
speedBox.PlaceholderText = "ENTER SPEED"
speedBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
speedBox.ClearTextOnFocus = false
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.GothamBlack
speedBox.TextSize = 16
speedBox.Parent = frame

local speedBoxCorner = Instance.new("UICorner", speedBox)
speedBoxCorner.CornerRadius = UDim.new(0, 10)

local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(255, 255, 255)
speedStroke.Thickness = 2.5
speedStroke.Transparency = 0.4
speedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
speedStroke.ZIndex = 2
speedStroke.Parent = speedBox

local speedGrad = Instance.new("UIGradient", speedStroke)
speedGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
speedGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.4,0),
    NumberSequenceKeypoint.new(0.6,0),
    NumberSequenceKeypoint.new(1,1)
})

TweenService:Create(speedStroke, pulseInfo, {Thickness = 4.5, Transparency = 0.15}):Play()
RunService.Heartbeat:Connect(function(dt)
    speedGrad.Rotation = (speedGrad.Rotation + 150 * dt) % 360
end)

-- Hover effects
for _, el in {flyButton, speedBox} do
    el.MouseEnter:Connect(function()
        el.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    el.MouseLeave:Connect(function()
        el.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

-- Draggable frame
local dragging, dragStart, startPos
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
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fly variables
local flying = false
local currentSpeed = 50  -- fallback (under max)
local MAX_SPEED = 80     -- ← updated max cap
local bv, bg, flyConn
local carpetTool = nil
local TOOL_NAME = "Flying Carpet"

local function hideToolVisuals(tool)
    if not tool then return end
    for _, obj in tool:GetDescendants() do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
        if obj:IsA("BasePart") then obj.CanCollide = false; obj.Massless = true end
    end
    for _, v in tool:GetDescendants() do
        if v:IsA("SelectionBox") or v:IsA("SurfaceGui") or v:IsA("BillboardGui") then v.Enabled = false end
    end
end

local function showToolVisuals(tool)
    if not tool then return end
    for _, obj in tool:GetDescendants() do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then obj.Transparency = 0 end
        if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 0 end
    end
    for _, v in tool:GetDescendants() do
        if v:IsA("SelectionBox") or v:IsA("SurfaceGui") or v:IsA("BillboardGui") then v.Enabled = true end
    end
end

local function findAndEquipCarpet()
    local backpack = player:WaitForChild("Backpack")
    local char = player.Character
    if not char then return false end

    carpetTool = backpack:FindFirstChild(TOOL_NAME) or char:FindFirstChild(TOOL_NAME)
    if carpetTool and carpetTool:IsA("Tool") then
        if carpetTool.Parent == backpack then
            char:WaitForChild("Humanoid"):EquipTool(carpetTool)
            task.wait(0.2)
        end
        hideToolVisuals(carpetTool)
        return true
    end
    return false
end

-- Speed update with MAX 80 cap
local function updateSpeed()
    local raw = speedBox.Text
    local cleaned = raw:gsub("[^%d]", "")
    local num = tonumber(cleaned)

    if num then
        currentSpeed = math.clamp(num, 10, MAX_SPEED)
        if cleaned ~= raw or num > MAX_SPEED then
            speedBox.Text = tostring(currentSpeed)
        end
    elseif cleaned == "" then
        currentSpeed = 50
    else
        speedBox.Text = tostring(currentSpeed)
    end
end

speedBox:GetPropertyChangedSignal("Text"):Connect(updateSpeed)

-- +/- keys when focused (respect max 80)
speedBox.Focused:Connect(function()
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or not speedBox:IsFocused() then return end

        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        local step = shift and 10 or 1

        if input.KeyCode == Enum.KeyCode.Plus or input.KeyCode == Enum.KeyCode.KeypadPlus then
            currentSpeed = math.clamp(currentSpeed + step, 10, MAX_SPEED)
            speedBox.Text = tostring(currentSpeed)
        elseif input.KeyCode == Enum.KeyCode.Minus or input.KeyCode == Enum.KeyCode.KeypadMinus then
            currentSpeed = math.clamp(currentSpeed - step, 10, MAX_SPEED)
            speedBox.Text = tostring(currentSpeed)
        end
    end)

    speedBox.FocusLost:Once(function()
        if conn then conn:Disconnect() end
    end)
end)

local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    findAndEquipCarpet()

    flying = true
    flyButton.Text = "FLY ON"
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)

    hum.PlatformStand = true

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    bg.P = 15000
    bg.Parent = hrp

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flyConn = RunService.Heartbeat:Connect(function()
        if not flying or not hrp or not hrp.Parent then return end

        local cam = workspace.CurrentCamera
        local move = Controls:GetMoveVector()

        local right = cam.CFrame.RightVector
        local look = cam.CFrame.LookVector
        local horiz = right * move.X + look * -move.Z

        local vert = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vert += 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then vert -= 1 end

        bv.Velocity = horiz * currentSpeed + Vector3.new(0, vert * currentSpeed, 0)
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    flyButton.Text = "FLY OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)

    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end

        if carpetTool and carpetTool.Parent == char then
            showToolVisuals(carpetTool)
            carpetTool.Parent = player.Backpack
            carpetTool = nil
        end
    end
end

flyButton.Activated:Connect(function()
    if flying then stopFly() else startFly() end
end)

player.CharacterAdded:Connect(function()
    stopFly()
end)

print("Yogi Fly loaded – max speed is now 80. Enjoy the faster flights!")
