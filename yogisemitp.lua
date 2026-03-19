local function safeCall(func, ...)
    local start = tick()
    local success, result = pcall(func, ...)
    return success, result
end

if _G.YogiTPCleanup then
    pcall(_G.YogiTPCleanup)
end

_G.YogiTPCleanup = function()
    if _G.YogiTPConnections then
        for _, conn in ipairs(_G.YogiTPConnections) do
            pcall(function() conn:Disconnect() end)
        end
        _G.YogiTPConnections = {}
    end
    
    local playerGui = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local existingGui = playerGui:FindFirstChild("YogiTPMain")
        if existingGui then pcall(function() existingGui:Destroy() end) end
    end
    
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("YogiESP") then hrp.YogiESP:Destroy() end
        end
    end
end

pcall(_G.YogiTPCleanup)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local connections = {}
_G.YogiTPConnections = connections

print("Yogi TP Loading")

if _G.MyskypInstaSteal then 
    pcall(_G.YogiTPCleanup)
    task.wait(0.1)
end
_G.MyskypInstaSteal = true

local IS_MOBILE = UserInputService.TouchEnabled

local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true,
    AngularVelociryLimit = 360,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
    S2PhysicsSenderRate = 15000,
    DisableDPIScale = true,
    MaxDataPacketPerSend = 2147483647,
    PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21,
    MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true,
    SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647,
    DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1,
    InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647,
    InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10,
    WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5,
    TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true,
    TimestepArbiterOmegaThou = 1073741823,
    MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}

local function setFFlag(name, value)
    pcall(function() setfflag(tostring(name), tostring(value)) end)
end

if not _G.YogiDesyncApplied then
    for name, value in pairs(FFlags) do
        setFFlag(name, value)
    end
    
    task.spawn(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end) end
            task.wait(0.1)
            pcall(function() char:ClearAllChildren() end)
            local newChar = Instance.new("Model")
            newChar.Parent = workspace
            pcall(function() LocalPlayer.Character = newChar end)
            task.wait()
            pcall(function() LocalPlayer.Character = char end)
            pcall(function() newChar:Destroy() end)
        end
    end)
    
    _G.YogiDesyncApplied = true
    print("Yogi TP Desync Activated")
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

local TP_POSITIONS = {
    BASE1 = {
        MIDDLE_POS   = CFrame.new(-354.04, -7.21, 90.42),
        BRAINROT_POS = CFrame.new(-334.60, -5.00, 101.30),
        FINAL_TP_POS = CFrame.new(-351.00, -7.00, 75.00)  
    },
    BASE2 = { 
        MIDDLE_POS   = CFrame.new(-354.04, -7.21, 28.00), 
        BRAINROT_POS = CFrame.new(-334.60, -5.00, 19.30), 
        FINAL_TP_POS = CFrame.new(-351.00, -7.00, 43.42)  
    }
}

local SpeedEnabled = false
local playerESPEnabled = false
local SPEED_VALUE = 29
local speedConnection = nil
local isExecuting = false
local CONFIG = { SELECTED_TARGET = "BASE1" }

local pulseInfo = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local function applyMainStroke(parent)
    local blackStroke = Instance.new("UIStroke")
    blackStroke.Color = Color3.fromRGB(0, 0, 0)
    blackStroke.Thickness = 6
    blackStroke.Transparency = 0
    blackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    blackStroke.Parent = parent

    local waveStroke = Instance.new("UIStroke")
    waveStroke.Color = Color3.fromRGB(255, 255, 255)
    waveStroke.Thickness = 3.5
    waveStroke.Transparency = 0.3
    waveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    waveStroke.ZIndex = 2
    waveStroke.Parent = parent

    local waveGradient = Instance.new("UIGradient", waveStroke)
    waveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
    waveGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.45, 0),
        NumberSequenceKeypoint.new(0.55, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    TweenService:Create(waveStroke, pulseInfo, {Thickness = 5.5, Transparency = 0.05}):Play()

    local conn = RunService.Heartbeat:Connect(function(dt)
        waveGradient.Rotation = (waveGradient.Rotation + 180 * dt) % 360
    end)
    table.insert(connections, conn)
end

local function applyButtonStroke(parent)
    local waveStroke = Instance.new("UIStroke")
    waveStroke.Color = Color3.fromRGB(255,255,255)
    waveStroke.Thickness = 3
    waveStroke.Transparency = 0.35
    waveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    waveStroke.ZIndex = 2
    waveStroke.Parent = parent

    local waveGradient = Instance.new("UIGradient", waveStroke)
    waveGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
    waveGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.4,0),
        NumberSequenceKeypoint.new(0.6,0),
        NumberSequenceKeypoint.new(1,1)
    })

    TweenService:Create(waveStroke, pulseInfo, {Thickness = 5, Transparency = 0.08}):Play()

    local conn = RunService.Heartbeat:Connect(function(dt)
        waveGradient.Rotation = (waveGradient.Rotation + 145 * dt) % 360
    end)
    table.insert(connections, conn)
end

local animatedGradients = {}
local espGradientColor = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
})

local function applyRadiantStroke(parent, thickness, cornerRadius, isEsp)
    if cornerRadius then
        Instance.new("UICorner", parent).CornerRadius = cornerRadius
    end
    local stroke = Instance.new("UIStroke", parent)
    stroke.Thickness = thickness or 1.2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.05
    
    local gradient = Instance.new("UIGradient", stroke)
    gradient.Color = espGradientColor
    table.insert(animatedGradients, gradient)
    return stroke
end

local gradConn = RunService.Heartbeat:Connect(function()
    for _, grad in ipairs(animatedGradients) do
        if grad.Parent then
            grad.Rotation = (grad.Rotation + 2) % 360
        end
    end
end)
table.insert(connections, gradConn)

local playerESPConnections = {}

local function createPlayerESP(p)
    if p == LocalPlayer then return end
    
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
        
        applyRadiantStroke(f, 1.2, UDim.new(0,6), true)
        
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
            if not LocalPlayer.Character then return end
            local lhrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not lhrp or not hrp then return end
            local d = (hrp.Position - lhrp.Position).Magnitude
            dist.Text = math.floor(d + 0.5) .. " studs"
        end)
        
        table.insert(playerESPConnections, heartbeat)
        table.insert(connections, heartbeat)
    end
    
    if p.Character then task.spawn(setup, p.Character) end
    
    local charConn = p.CharacterAdded:Connect(function(char)
        if playerESPEnabled then
            task.wait(0.3)
            setup(char)
        end
    end)
    table.insert(playerESPConnections, charConn)
    table.insert(connections, charConn)
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

local function applySpeed(enabled)
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if not enabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        end
        return
    end
    
    speedConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            local moveDirection = humanoid.MoveDirection
            hrp.AssemblyLinearVelocity = Vector3.new(
                moveDirection.X * SPEED_VALUE,
                hrp.AssemblyLinearVelocity.Y,
                moveDirection.Z * SPEED_VALUE
            )
        end
    end)
    table.insert(connections, speedConnection)
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "YogiTPMain"
mainGui.ResetOnSpawn = false
mainGui.Parent = PlayerGui

-- RE-OPEN BUTTON (the one that appears after minimize) - now small perfect circle + bigger text
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "YogiOpenBtn"
OpenBtn.Size = UDim2.new(0, 52, 0, 52)   -- smaller
OpenBtn.Position = UDim2.new(0.04, 0, 0.15, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
OpenBtn.Text = "YOGI"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 19                     -- bigger text
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = mainGui
local openCorner = Instance.new("UICorner", OpenBtn)
openCorner.CornerRadius = UDim.new(1, 0)  -- perfect circle
applyMainStroke(OpenBtn)

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, IS_MOBILE and 235 or 255, 0, 295) 
mainFrame.Position = UDim2.new(1, -290, 0, 75)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
applyMainStroke(mainFrame)

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -85, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "YOGI TP"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- MINIMIZE BUTTON (the "-" button) - restored exactly to how it was before
local MinimizeBtn = Instance.new("TextButton", header)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizeBtn.Text = "−"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local minCorner = Instance.new("UICorner", MinimizeBtn)
minCorner.CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(0,8)

-- PROGRESS BAR
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.88, 0, 0, 8)
barBg.Position = UDim2.new(0.06, 0, 0, 62)
barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
barBg.BorderSizePixel = 0
barBg.Parent = mainFrame
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- BUTTON CREATOR
local function createUIBtn(text, yPos)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.9, 0, 0, 42)
    btnFrame.Position = UDim2.new(0.05, 0, 0, yPos)
    btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btnFrame.Parent = mainFrame
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 11)
    applyButtonStroke(btnFrame)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14.5
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = btnFrame
    return btnFrame, btn
end

local b1Frame, b1Btn = createUIBtn("ATTACK BASE 1", 82)
local b2Frame, b2Btn = createUIBtn("ATTACK BASE 2", 132)
local spdFrame, spdBtn = createUIBtn("SPEED: OFF", 182)
local espFrame, espBtn = createUIBtn("PLAYER ESP: OFF", 232)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function useGreenPotion()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local potion = nil
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and string.find(string.lower(t.Name), "green potion") then
            potion = t
            break
        end
    end
    
    if not potion and LocalPlayer:FindFirstChild("Backpack") then
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") and string.find(string.lower(t.Name), "green potion") then
                potion = t
                break
            end
        end
    end
    
    if potion then
        hum:EquipTool(potion)
        potion:Activate()
        print("Yogi TP Auto Potion Used")
    end
end

local function getPromptNear(targetCFrame)
    local nearest = nil
    local minDist = 30 
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, obj in ipairs(plots:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.ActionText == "Steal" and obj.Enabled then
            local pPos
            if obj.Parent:IsA("BasePart") then 
                pPos = obj.Parent.Position
            elseif obj.Parent:IsA("Attachment") then 
                pPos = obj.Parent.WorldPosition
            elseif obj.Parent:IsA("Model") and obj.Parent.PrimaryPart then 
                pPos = obj.Parent.PrimaryPart.Position 
            end
            
            if pPos then
                local dist = (targetCFrame.Position - pPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function executeChezTP(targetBase, btnFrame, btnLabel)
    if isExecuting then return end
    isExecuting = true
    CONFIG.SELECTED_TARGET = targetBase
    
    btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btnLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not hum then 
        isExecuting = false
        btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        return 
    end
    
    local carpet = char:FindFirstChild("Flying Carpet") or LocalPlayer.Backpack:FindFirstChild("Flying Carpet")
    if carpet then hum:EquipTool(carpet) end
    
    local tpData = TP_POSITIONS[targetBase]
    
    task.spawn(function()
        local prompt = getPromptNear(tpData.BRAINROT_POS)
        local d = {h = {}, t = {}}
        
        if prompt then
            local s1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
            if s1 and c1 then for _,c in ipairs(c1) do if type(c.Function)=="function" then table.insert(d.h, c.Function) end end end
            
            local s2, c2 = pcall(getconnections, prompt.Triggered)
            if s2 and c2 then for _,c in ipairs(c2) do if type(c.Function)=="function" then table.insert(d.t, c.Function) end end end
            
            for _,f in ipairs(d.h) do task.spawn(f) end
        end
        
        local startTime = tick()
        local phase1Done = false
        local phase2Done = false
        local phase3Done = false
        
        while tick() - startTime < 1.3 do
            local progress = (tick() - startTime) / 1.3
            pcall(function() barFill.Size = UDim2.new(progress, 0, 1, 0) end)
            
            if progress >= 0.48 and not phase1Done then
                phase1Done = true
                hrp.CFrame = tpData.MIDDLE_POS
            end
            
            if progress >= 0.67 and not phase2Done then
                phase2Done = true
                hrp.CFrame = tpData.BRAINROT_POS
            end
            
            if progress >= 0.96 and not phase3Done then
                phase3Done = true
                hrp.CFrame = tpData.FINAL_TP_POS
            end
            
            task.wait()
        end
        
        pcall(function() barFill.Size = UDim2.new(1, 0, 1, 0) end)
        
        if prompt then
            for _,f in ipairs(d.t) do task.spawn(f) end
            pcall(function() fireproximityprompt(prompt, 1) end)
        end
        
        task.wait(0.1)
        useGreenPotion()
        
        task.wait(0.15)
        pcall(function() barFill.Size = UDim2.new(0, 0, 1, 0) end)
        btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        isExecuting = false
    end)
end

b1Btn.MouseButton1Click:Connect(function()
    executeChezTP("BASE1", b1Frame, b1Btn)
end)

b2Btn.MouseButton1Click:Connect(function()
    executeChezTP("BASE2", b2Frame, b2Btn)
end)

spdBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        spdBtn.Text = "SPEED: ON"
        spdFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        spdBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        spdBtn.Text = "SPEED: OFF"
        spdFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        spdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    applySpeed(SpeedEnabled)
end)

espBtn.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    if playerESPEnabled then
        espBtn.Text = "PLAYER ESP: ON"
        espFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        espBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        for _, p in ipairs(Players:GetPlayers()) do
            createPlayerESP(p)
        end
    else
        espBtn.Text = "PLAYER ESP: OFF"
        espFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        removeAllESP()
    end
end)

CloseBtn.MouseButton1Click:Connect(function() mainGui:Destroy() end)
MinimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    mainFrame.Visible = true
end)

local manualHoldConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, who)
    if who ~= LocalPlayer then return end
    if isExecuting then return end 
    if prompt.Name ~= "Steal" and prompt.ActionText ~= "Steal" and prompt.ObjectText ~= "Steal" then return end
    
    task.spawn(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        task.wait(1.3 * 0.48)
        if hrp then hrp.CFrame = TP_POSITIONS[CONFIG.SELECTED_TARGET].MIDDLE_POS end
        
        task.wait(1.3 * 0.20)
        if hrp then hrp.CFrame = TP_POSITIONS[CONFIG.SELECTED_TARGET].BRAINROT_POS end
        
        task.wait(1.3 * 0.28)
        if hrp then hrp.CFrame = TP_POSITIONS[CONFIG.SELECTED_TARGET].FINAL_TP_POS end
        
        task.wait(0.2)
        useGreenPotion()
    end)
end)
table.insert(connections, manualHoldConn)

print("Yogi TP Loaded Successfully - Re-open button is now smaller perfect circle")
