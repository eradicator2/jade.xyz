--// ========== LOADING SCREEN ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingGui.DisplayOrder = 999999999
loadingGui.Parent = PlayerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.ZIndex = 999999
bg.Parent = loadingGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 40)
label.Position = UDim2.new(0, 0, 0.5, -20)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 24
label.Font = Enum.Font.GothamBold
label.ZIndex = 9999999
label.Parent = bg

task.spawn(function()
    local dots = {".", "..", "..."}
    local i = 0
    while loadingGui and loadingGui.Parent do
        i = (i % 3) + 1
        label.Text = "script is loading" .. dots[i] .. "pls wait <3"
        task.wait(0.4)
    end
end)

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.4, 0, 0, 4)
barBg.Position = UDim2.new(0.3, 0, 0.5, 25)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBg.BorderSizePixel = 0
barBg.ZIndex = 9999999
barBg.Parent = bg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
barFill.BorderSizePixel = 0
barFill.ZIndex = 99999999
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 2)

task.spawn(function()
    local startTime = tick()
    local duration = 5
    while loadingGui and loadingGui.Parent do
        local elapsed = tick() - startTime
        local progress = math.clamp(elapsed / duration, 0, 1)
        barFill.Size = UDim2.new(progress, 0, 1, 0)
        if progress >= 1 then break end
        task.wait()
    end
end)

local hiddenGuis = {}
for _, gui in ipairs(PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui ~= loadingGui then
        hiddenGuis[gui] = gui.Enabled
        gui.Enabled = false
    end
end

local childAddedConn
childAddedConn = PlayerGui.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") and child ~= loadingGui and loadingGui.Parent then
        hiddenGuis[child] = child.Enabled
        child.Enabled = false
    end
end)

task.delay(5, function()
    childAddedConn:Disconnect()
    for gui, wasEnabled in pairs(hiddenGuis) do
        if gui and gui.Parent then
            gui.Enabled = wasEnabled
        end
    end
    local fadeTime = 0.5
    local startT = tick()
    while true do
        local alpha = 1 - math.clamp((tick() - startT) / fadeTime, 0, 1)
        bg.BackgroundTransparency = 1 - alpha
        label.TextTransparency = 1 - alpha
        barBg.BackgroundTransparency = 1 - alpha
        barFill.BackgroundTransparency = 1 - alpha
        if alpha <= 0 then break end
        task.wait()
    end
    loadingGui:Destroy()
end)

--// ==========================================
--// ОСНОВНОЙ СКРИПТ
--// ==========================================
task.delay(5.5, function()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHumanoidRootPart = LocalCharacter:WaitForChild("HumanoidRootPart")
local Stats = game:GetService("Stats")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "SWILL ESP + VISUALS",
    Theme = "Dark",
    Size = UDim2.fromOffset(650, 600),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

local Themes = {
    Light = {
        Primary = Color3.fromRGB(232, 232, 232), Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245), Interactables = Color3.fromRGB(235, 235, 235),
        Tab = Color3.fromRGB(50, 50, 50), Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100), Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210), Icon = Color3.fromRGB(100, 100, 100),
    },
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30), Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40), Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200), Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220),
    },
    Void = {
        Primary = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(20, 20, 20),
        Component = Color3.fromRGB(25, 25, 25), Interactables = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200), Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220),
    },
}
Window:SetTheme(Themes.Dark)

local activeConnections = {}
local mainLoopConnection = nil
local miniTabBarGui = nil
local isUnloaded = false
local visibilityCache = {}
local visibilityCacheTime = {}
local VISIBILITY_CACHE_DURATION = 0.1
local noFogConnection = nil

local function AddSlider(props)
    local slider = Window:AddSlider(props)
    task.defer(function()
        if slider then
            pcall(function()
                if typeof(slider) == "table" then
                    if slider.Set then slider:Set(props.Default)
                    elseif slider.SetValue then slider:SetValue(props.Default) end
                end
            end)
        end
        if props.Callback and props.Default ~= nil then props.Callback(props.Default) end
    end)
    return slider
end

--// =========================
--// MINI TAB BAR — ПЛАВНЫЙ + ИГРОКИ + КРЕДИТЫ
--// =========================
local function createMiniTabBar()
    local sg = Instance.new("ScreenGui")
    sg.Name = "MiniTabBar"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    sg.IgnoreGuiInset = true
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    miniTabBarGui = sg

    local mf = Instance.new("Frame")
    mf.Name = "MainFrame"
    mf.Size = UDim2.new(0, 280, 0, 50)
    mf.Position = UDim2.new(1, -280, 0, 0)
    mf.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    mf.BackgroundTransparency = 0.05
    mf.BorderSizePixel = 0
    mf.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mf

    local topMask = Instance.new("Frame")
    topMask.Size = UDim2.new(1, 0, 0, 12)
    topMask.Position = UDim2.new(0, 0, 0, 0)
    topMask.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    topMask.BackgroundTransparency = 0.05
    topMask.BorderSizePixel = 0
    topMask.ZIndex = 2
    topMask.Parent = mf

    local rightMask = Instance.new("Frame")
    rightMask.Size = UDim2.new(0, 12, 1, 0)
    rightMask.Position = UDim2.new(1, -12, 0, 0)
    rightMask.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    rightMask.BackgroundTransparency = 0.05
    rightMask.BorderSizePixel = 0
    rightMask.ZIndex = 2
    rightMask.Parent = mf

    -- Градиентная линия снизу
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = Color3.fromRGB(100, 255, 255)
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 5
    accentLine.Parent = mf

    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
    })
    accentGradient.Parent = accentLine

    task.spawn(function()
        local offset = 0
        while not isUnloaded do
            offset = (offset + 0.005) % 1
            accentGradient.Offset = Vector2.new(offset, 0)
            task.wait(0.03)
        end
    end)

    -- Плавная радужная обводка
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Color = Color3.fromRGB(255, 0, 0)
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Transparency = 0.4
    rainbowStroke.Parent = mf

    local hue = 0
    table.insert(activeConnections, RunService.RenderStepped:Connect(function(dt)
        if isUnloaded then return end
        hue = (hue + dt * 0.25) % 1
        rainbowStroke.Color = Color3.fromHSV(hue, 0.7, 1)
    end))

    -- Верхняя строка (инфо)
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, -12, 0, 22)
    topRow.Position = UDim2.new(0, 6, 0, 3)
    topRow.BackgroundTransparency = 1
    topRow.ZIndex = 10
    topRow.Parent = mf

    -- === Jade.xyz ===
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(0, 55, 1, 0)
    nl.Position = UDim2.new(0, 0, 0, 0)
    nl.BackgroundTransparency = 1
    nl.Text = "Jade.xyz"
    nl.TextColor3 = Color3.fromRGB(100, 255, 255)
    nl.TextSize = 11
    nl.Font = Enum.Font.GothamBold
    nl.TextXAlignment = Enum.TextXAlignment.Left
    nl.ZIndex = 11
    nl.Parent = topRow

    -- Плавная пульсация
    task.spawn(function()
        while not isUnloaded do
            for i = 0, 1, 0.008 do
                if isUnloaded then break end
                local brightness = 0.7 + 0.3 * math.sin(i * math.pi * 2)
                nl.TextColor3 = Color3.fromRGB(
                    math.floor(100 * brightness),
                    math.floor(255 * brightness),
                    math.floor(255 * brightness)
                )
                task.wait(0.03)
            end
        end
    end)

    -- Разделитель 1
    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(0, 1, 0, 14)
    sep1.Position = UDim2.new(0, 58, 0.5, -7)
    sep1.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sep1.BorderSizePixel = 0
    sep1.ZIndex = 11
    sep1.Parent = topRow

    -- === FPS ===
    local fl = Instance.new("TextLabel")
    fl.Size = UDim2.new(0, 50, 1, 0)
    fl.Position = UDim2.new(0, 63, 0, 0)
    fl.BackgroundTransparency = 1
    fl.Text = "-- FPS"
    fl.TextColor3 = Color3.fromRGB(100, 255, 100)
    fl.TextSize = 10
    fl.Font = Enum.Font.GothamSemibold
    fl.TextXAlignment = Enum.TextXAlignment.Left
    fl.ZIndex = 11
    fl.Parent = topRow

    -- Разделитель 2
    local sep2 = Instance.new("Frame")
    sep2.Size = UDim2.new(0, 1, 0, 14)
    sep2.Position = UDim2.new(0, 118, 0.5, -7)
    sep2.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sep2.BorderSizePixel = 0
    sep2.ZIndex = 11
    sep2.Parent = topRow

    -- === PING ===
    local pl = Instance.new("TextLabel")
    pl.Size = UDim2.new(0, 55, 1, 0)
    pl.Position = UDim2.new(0, 123, 0, 0)
    pl.BackgroundTransparency = 1
    pl.Text = "-- ms"
    pl.TextColor3 = Color3.fromRGB(100, 255, 100)
    pl.TextSize = 10
    pl.Font = Enum.Font.GothamSemibold
    pl.TextXAlignment = Enum.TextXAlignment.Left
    pl.ZIndex = 11
    pl.Parent = topRow

    -- Разделитель 3
    local sep3 = Instance.new("Frame")
    sep3.Size = UDim2.new(0, 1, 0, 14)
    sep3.Position = UDim2.new(0, 183, 0.5, -7)
    sep3.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sep3.BorderSizePixel = 0
    sep3.ZIndex = 11
    sep3.Parent = topRow

    -- === PLAYERS COUNT ===
    local playerCountLabel = Instance.new("TextLabel")
    playerCountLabel.Size = UDim2.new(0, 80, 1, 0)
    playerCountLabel.Position = UDim2.new(0, 188, 0, 0)
    playerCountLabel.BackgroundTransparency = 1
    playerCountLabel.Text = "0 players"
    playerCountLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
    playerCountLabel.TextSize = 10
    playerCountLabel.Font = Enum.Font.GothamSemibold
    playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerCountLabel.ZIndex = 11
    playerCountLabel.Parent = topRow

    -- === НИЖНЯЯ СТРОКА: by niokaqwe & cursed.child. ===
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(1, -12, 0, 18)
    creditLabel.Position = UDim2.new(0, 6, 0, 26)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = "by niokaqwe & cursed.child."
    creditLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    creditLabel.TextSize = 10
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.TextXAlignment = Enum.TextXAlignment.Center
    creditLabel.ZIndex = 11
    creditLabel.Parent = mf

    -- Плавная пульсация кредитов
    task.spawn(function()
        while not isUnloaded do
            for i = 0, 1, 0.006 do
                if isUnloaded then break end
                local b = 0.6 + 0.4 * math.sin(i * math.pi * 2)
                creditLabel.TextColor3 = Color3.fromRGB(
                    math.floor(255 * b),
                    math.floor(60 * b),
                    math.floor(60 * b)
                )
                task.wait(0.03)
            end
        end
    end)

    -- FPS Counter (плавный)
    local frameCount = 0
    local lastTime = tick()
    local smoothFps = 60

    table.insert(activeConnections, RunService.RenderStepped:Connect(function()
        if isUnloaded then return end
        frameCount = frameCount + 1
        local currentTime = tick()

        if currentTime - lastTime >= 0.5 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime

            smoothFps = smoothFps + (fps - smoothFps) * 0.3
            local displayFps = math.floor(smoothFps)

            fl.Text = tostring(displayFps) .. " FPS"

            if displayFps >= 55 then
                fl.TextColor3 = Color3.fromRGB(100, 255, 100)
            elseif displayFps >= 30 then
                fl.TextColor3 = Color3.fromRGB(255, 220, 100)
            else
                fl.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end))

    -- PING Detector (плавный)
    task.spawn(function()
        local smoothPing = 50
        while not isUnloaded do
            local ping = 0

            pcall(function()
                ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end)

            if ping == 0 then
                pcall(function()
                    local networkStats = Stats:FindFirstChild("Network")
                    if networkStats then
                        for _, child in ipairs(networkStats:GetDescendants()) do
                            if child.Name:lower():find("ping") then
                                pcall(function() ping = math.floor(child:GetValue()) end)
                                if ping > 0 then break end
                            end
                        end
                    end
                end)
            end

            if ping > 0 then
                smoothPing = smoothPing + (ping - smoothPing) * 0.3
                local displayPing = math.floor(smoothPing)
                pl.Text = tostring(displayPing) .. " ms"

                if displayPing <= 50 then
                    pl.TextColor3 = Color3.fromRGB(100, 255, 100)
                elseif displayPing <= 100 then
                    pl.TextColor3 = Color3.fromRGB(255, 220, 100)
                else
                    pl.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
            else
                pl.Text = "~50 ms"
                pl.TextColor3 = Color3.fromRGB(150, 150, 150)
            end

            task.wait(0.5)
        end
    end)

    -- PLAYER COUNT (плавное обновление)
    task.spawn(function()
        while not isUnloaded do
            local count = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers
            playerCountLabel.Text = tostring(count) .. "/" .. tostring(maxPlayers)

            if count >= maxPlayers * 0.9 then
                playerCountLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            elseif count >= maxPlayers * 0.6 then
                playerCountLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
            else
                playerCountLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
            end

            task.wait(2)
        end
    end)

    return sg
end
createMiniTabBar()

--// SETTINGS
local espSettings = {
    enabled = false, showBoxes = false, showTracers = false, showNames = false,
    showDistance = false, showItems = false, showHP = false, showSkeleton = false, showChams = false,
    visibilityCheck = false, showVisLabel = true,
    visibleBoxColor = Color3.fromRGB(0, 255, 0), hiddenBoxColor = Color3.fromRGB(255, 0, 0),
    visibleNameColor = Color3.fromRGB(0, 255, 0), hiddenNameColor = Color3.fromRGB(255, 0, 0),
    visibleTracerColor = Color3.fromRGB(0, 255, 0), hiddenTracerColor = Color3.fromRGB(255, 0, 0),
    visibleDistanceColor = Color3.fromRGB(0, 255, 0), hiddenDistanceColor = Color3.fromRGB(255, 0, 0),
    visibleItemColor = Color3.fromRGB(0, 255, 0), hiddenItemColor = Color3.fromRGB(255, 0, 0),
    visibleArrowColor = Color3.fromRGB(0, 255, 0), hiddenArrowColor = Color3.fromRGB(255, 0, 0),
    visibleChamsColor = Color3.fromRGB(0, 255, 100), hiddenChamsColor = Color3.fromRGB(255, 50, 50),
    tracerType = "Top",
    boxColor = Color3.fromRGB(255, 255, 255), nameColor = Color3.fromRGB(255, 255, 255),
    distanceColor = Color3.fromRGB(255, 255, 255), itemColor = Color3.fromRGB(255, 255, 255),
    tracerColor = Color3.fromRGB(255, 255, 255), skeletonColor = Color3.fromRGB(255, 255, 255),
    chamsColor = Color3.fromRGB(255, 100, 100),
    boxThickness = 2, tracerThickness = 1, chamsTransparency = 0.5,
}

local arrowSettings = {
    enabled = false, showDistance = false, showGlow = true,
    style = "Classic", fillType = "Filled",
    color = Color3.fromRGB(255, 0, 0), colorTip = Color3.fromRGB(255, 255, 0),
    outlineColor = Color3.fromRGB(0, 0, 0),
    shadowEnabled = true, shadowColor = Color3.fromRGB(0, 0, 0), shadowTransparency = 0.5,
    glowColor = Color3.fromRGB(255, 0, 0), glowTransparency = 0.3, glowThickness = 5,
    highlightEnabled = true, highlightColor = Color3.fromRGB(255, 255, 255), highlightTransparency = 0.3,
    size = 15, radius = 150, thickness = 1, outlineThickness = 2, transparency = 1,
    pulseSpeed = 4, pulseMin = 0.85, pulseMax = 1.15,
    bobbingEnabled = false, bobbingSpeed = 3, bobbingAmount = 5,
    rotationOffset = 0,
}

local plotSettings = {
    enabled = false, showHighlight = false, showTracers = false, showNames = false, showDistance = false,
    highlightFillColor = Color3.fromRGB(255, 255, 0), highlightOutlineColor = Color3.fromRGB(255, 0, 0),
    highlightFillTransparency = 0.5, highlightOutlineTransparency = 0.3,
    tracerColor = Color3.fromRGB(255, 255, 0), nameColor = Color3.fromRGB(255, 255, 0),
    distanceColor = Color3.fromRGB(255, 255, 0), tracerThickness = 1,
}

local worldSettings = {
    fullbright = false, nofog = false, skyboxEnabled = false, currentSkyColor = nil,
    angelHalo = false, haloColor = Color3.fromRGB(255, 215, 0), haloSize = 2,
    jumpCircleEnabled = false, jumpCircleColor = Color3.fromRGB(100, 200, 255),
    jumpCircleSize = 15,
    originalBrightness = Lighting.Brightness, originalClockTime = Lighting.ClockTime,
    originalFogEnd = Lighting.FogEnd, originalFogStart = Lighting.FogStart,
    originalAmbient = Lighting.Ambient, originalOutdoorAmbient = Lighting.OutdoorAmbient,
    originalGlobalShadows = Lighting.GlobalShadows,
}

--// COMBAT SETTINGS
local combatSettings = {
    aimbotEnabled = false,
    aimbotKey = Enum.UserInputType.MouseButton2,
    aimbotKeyName = "RMB",
    aimbotSmoothing = 0.5,
    aimbotFOV = 150,
    aimbotShowFOV = false,
    aimbotTargetPart = "Head",
    aimbotTeamCheck = false,
    aimbotVisibilityCheck = true,
    aimbotPrediction = true,
    aimbotPredictionAmount = 0.12,
    fastKnifeEnabled = false,
}

local toolCache = {}
local lastUpdateTime = {}

-- Aimbot Circle
local aimbotFOVCircle = Drawing.new("Circle")
aimbotFOVCircle.Color = Color3.fromRGB(255, 255, 255)
aimbotFOVCircle.Thickness = 1
aimbotFOVCircle.Filled = false
aimbotFOVCircle.Transparency = 0.5
aimbotFOVCircle.Visible = false

--// ===== ANGEL HALO 3D (ПОВЁРНУТ НА 90°) =====
local haloLines = {}
local haloGlowLines = {}
local haloConnection = nil
local HALO_SEGMENTS = 24

local function removeHalo()
    if haloConnection then
        pcall(function() haloConnection:Disconnect() end)
        haloConnection = nil
    end
    for _, line in ipairs(haloLines) do
        pcall(function() line:Remove() end)
    end
    for _, line in ipairs(haloGlowLines) do
        pcall(function() line:Remove() end)
    end
    haloLines = {}
    haloGlowLines = {}
end

local function createHalo()
    removeHalo()

    for i = 1, HALO_SEGMENTS do
        local glow = Drawing.new("Line")
        glow.Thickness = 6
        glow.Color = worldSettings.haloColor
        glow.Transparency = 0.25
        glow.Visible = false
        table.insert(haloGlowLines, glow)

        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = worldSettings.haloColor
        line.Transparency = 1
        line.Visible = false
        table.insert(haloLines, line)
    end

    haloConnection = RunService.RenderStepped:Connect(function()
        if isUnloaded or not worldSettings.angelHalo then
            for _, l in ipairs(haloLines) do l.Visible = false end
            for _, l in ipairs(haloGlowLines) do l.Visible = false end
            return
        end

        local character = LocalPlayer.Character
        if not character then
            for _, l in ipairs(haloLines) do l.Visible = false end
            for _, l in ipairs(haloGlowLines) do l.Visible = false end
            return
        end

        local head = character:FindFirstChild("Head")
        if not head then
            for _, l in ipairs(haloLines) do l.Visible = false end
            for _, l in ipairs(haloGlowLines) do l.Visible = false end
            return
        end

        local haloCenter = head.Position + Vector3.new(0, 1.8, 0)
        local radius3D = worldSettings.haloSize * 0.8
        local rotation = tick() * 0.5
        local pulse = 1 + math.sin(tick() * 2.5) * 0.08

        for i = 1, HALO_SEGMENTS do
            local angle1 = ((i - 1) / HALO_SEGMENTS) * math.pi * 2 + rotation
            local angle2 = (i / HALO_SEGMENTS) * math.pi * 2 + rotation

            -- Круг в плоскости XZ (повёрнут на 90° — горизонтальный)
            local r = radius3D * pulse
            local p1 = haloCenter + Vector3.new(math.cos(angle1) * r, 0, math.sin(angle1) * r)
            local p2 = haloCenter + Vector3.new(math.cos(angle2) * r, 0, math.sin(angle2) * r)

            local sp1, onScreen1 = Camera:WorldToViewportPoint(p1)
            local sp2, onScreen2 = Camera:WorldToViewportPoint(p2)

            if onScreen1 and onScreen2 and sp1.Z > 0 and sp2.Z > 0 then
                local v1 = Vector2.new(sp1.X, sp1.Y)
                local v2 = Vector2.new(sp2.X, sp2.Y)

                -- Глубина для 3D эффекта
                local depth = (sp1.Z + sp2.Z) / 2
                local thickMul = math.clamp(50 / depth, 0.5, 3)

                haloGlowLines[i].From = v1
                haloGlowLines[i].To = v2
                haloGlowLines[i].Color = worldSettings.haloColor
                haloGlowLines[i].Thickness = math.max(4 * thickMul, 2)
                haloGlowLines[i].Transparency = 0.2
                haloGlowLines[i].Visible = true

                haloLines[i].From = v1
                haloLines[i].To = v2
                haloLines[i].Color = worldSettings.haloColor
                haloLines[i].Thickness = math.max(2 * thickMul, 1)
                haloLines[i].Transparency = 1
                haloLines[i].Visible = true
            else
                haloLines[i].Visible = false
                haloGlowLines[i].Visible = false
            end
        end
    end)

    table.insert(activeConnections, haloConnection)
end

local function updateHaloColor()
    for _, l in ipairs(haloLines) do l.Color = worldSettings.haloColor end
    for _, l in ipairs(haloGlowLines) do l.Color = worldSettings.haloColor end
end

--// ===== JUMP CIRCLE (ОДИН КРУГ НА ПОЛУ, 1.5 СЕК) =====
local wasJumping = false

local function createJumpCircleEffect(position)
    if not worldSettings.jumpCircleEnabled then return end

    -- Один плоский круг прямо на полу
    local ring = Instance.new("Part")
    ring.Name = "JumpCircleFloor"
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanQuery = false
    ring.CanTouch = false
    ring.CastShadow = false
    ring.Material = Enum.Material.Neon
    ring.Color = worldSettings.jumpCircleColor
    ring.Size = Vector3.new(0.5, 0.05, 0.5)
    ring.Shape = Enum.PartType.Cylinder
    -- Цилиндр лежит горизонтально: повернуть по Z на 90°
    ring.CFrame = CFrame.new(position + Vector3.new(0, 0.03, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ring.Transparency = 0.1
    ring.Parent = workspace.CurrentCamera

    -- Анимация: расширяется 1.5 сек, потом плавно пропадает
    task.spawn(function()
        local startTime = tick()
        local expandDuration = 1.5
        local maxSize = worldSettings.jumpCircleSize

        while ring and ring.Parent do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / expandDuration, 0, 1)

            -- Квадратичное расширение
            local easedProgress = progress * progress
            local currentSize = 0.5 + (maxSize * easedProgress)

            -- Привязка к полу: только размер меняется, позиция та же
            ring.Size = Vector3.new(0.05, currentSize, currentSize)

            -- Плавное исчезновение: начинает пропадать с 0.5 прогресса
            if progress < 0.5 then
                ring.Transparency = 0.1
            else
                local fadeProgress = (progress - 0.5) / 0.5
                ring.Transparency = 0.1 + 0.9 * fadeProgress
            end

            if progress >= 1 then
                break
            end

            task.wait()
        end

        if ring and ring.Parent then ring:Destroy() end
    end)
end

--// ===== FAST KNIFE SYSTEM (МАКСИМАЛЬНАЯ СКОРОСТЬ) =====
local fastKnifeConnection = nil
local fastKnifeClickConn = nil

local function startFastKnife()
    if fastKnifeConnection then return end

    -- Метод 1: Каждый фрейм обнуляем все кулдауны
    fastKnifeConnection = RunService.Heartbeat:Connect(function()
        if not combatSettings.fastKnifeEnabled or isUnloaded then return end

        local char = LocalPlayer.Character
        if not char then return end

        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                -- Обнуляем ВСЕ значения кулдауна в инструменте
                pcall(function()
                    for _, child in ipairs(tool:GetDescendants()) do
                        if child:IsA("NumberValue") or child:IsA("IntValue") then
                            local n = child.Name:lower()
                            if n:find("cool") or n:find("debounce") or n:find("delay") or n:find("cd") or n:find("timer") or n:find("wait") or n:find("rate") then
                                child.Value = 0
                            end
                            if n:find("speed") or n:find("rate") then
                                child.Value = 999
                            end
                        elseif child:IsA("BoolValue") then
                            local n = child.Name:lower()
                            if n:find("debounce") or n:find("cooling") or n:find("busy") then
                                child.Value = false
                            elseif n:find("can") or n:find("ready") or n:find("enabled") then
                                child.Value = true
                            end
                        end
                    end
                end)

                -- Обнуляем Attributes
                pcall(function()
                    for _, attrName in ipairs(tool:GetAttributes()) do
                        -- GetAttributes возвращает dict, перебираем по-другому
                    end
                    local attrs = tool:GetAttributes()
                    for attrName, attrValue in pairs(attrs) do
                        local n = string.lower(attrName)
                        if typeof(attrValue) == "number" then
                            if n:find("cool") or n:find("debounce") or n:find("cd") or n:find("delay") or n:find("timer") then
                                tool:SetAttribute(attrName, 0)
                            end
                        elseif typeof(attrValue) == "boolean" then
                            if n:find("debounce") or n:find("busy") then
                                tool:SetAttribute(attrName, false)
                            elseif n:find("can") or n:find("ready") then
                                tool:SetAttribute(attrName, true)
                            end
                        end
                    end
                end)

                -- Ускоряем ВСЕ анимации атаки до максимума
                pcall(function()
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                            local tn = track.Name:lower()
                            if tn:find("slash") or tn:find("attack") or tn:find("swing") or tn:find("stab") or tn:find("hit") or tn:find("lunge") or tn:find("melee") then
                                track:AdjustSpeed(10)
                            end
                        end
                    end
                end)

                -- Также проверяем Humanoid аттрибуты
                pcall(function()
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local attrs = humanoid:GetAttributes()
                        for attrName, attrValue in pairs(attrs) do
                            local n = string.lower(attrName)
                            if typeof(attrValue) == "number" and (n:find("cool") or n:find("debounce") or n:find("cd")) then
                                humanoid:SetAttribute(attrName, 0)
                            elseif typeof(attrValue) == "boolean" and n:find("debounce") then
                                humanoid:SetAttribute(attrName, false)
                            end
                        end
                    end
                end)

                -- Также обнуляем на самом персонаже
                pcall(function()
                    local attrs = char:GetAttributes()
                    for attrName, attrValue in pairs(attrs) do
                        local n = string.lower(attrName)
                        if typeof(attrValue) == "number" and (n:find("cool") or n:find("debounce") or n:find("cd") or n:find("attack")) then
                            char:SetAttribute(attrName, 0)
                        elseif typeof(attrValue) == "boolean" and (n:find("debounce") or n:find("attacking")) then
                            char:SetAttribute(attrName, false)
                        end
                    end
                end)
            end
        end
    end)

    -- Метод 2: Автоклик tool:Activate() максимально быстро
    task.spawn(function()
        while combatSettings.fastKnifeEnabled and not isUnloaded do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool:Activate()
                        end
                    end
                end
            end)
            task.wait(0.05) -- 20 атак в секунду
        end
    end)

    table.insert(activeConnections, fastKnifeConnection)
end

local function stopFastKnife()
    if fastKnifeConnection then
        pcall(function() fastKnifeConnection:Disconnect() end)
        fastKnifeConnection = nil
    end
end

--// VISIBILITY
local function isPlayerVisible(targetCharacter)
    if not LocalCharacter or not LocalCharacter.Parent then return true end
    if not targetCharacter or not targetCharacter.Parent then return true end
    local myHead = LocalCharacter:FindFirstChild("Head")
    local theirHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local theirHead = targetCharacter:FindFirstChild("Head")
    if not myHead or not theirHRP then return true end
    local targetPos = theirHead and theirHead.Position or theirHRP.Position
    local origin = myHead.Position
    local direction = targetPos - origin
    if direction.Magnitude < 1 then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {LocalCharacter, targetCharacter}
    for _, char in ipairs({LocalCharacter, targetCharacter}) do
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Tool") then table.insert(filterList, child) end
        end
    end
    rayParams.FilterDescendantsInstances = filterList
    rayParams.IgnoreWater = true
    return workspace:Raycast(origin, direction, rayParams) == nil
end

local function getPlayerVisibility(player)
    if not espSettings.visibilityCheck then return true end
    local now = tick()
    if visibilityCache[player] ~= nil and (now - (visibilityCacheTime[player] or 0)) < VISIBILITY_CACHE_DURATION then
        return visibilityCache[player]
    end
    local char = player.Character
    if not char then return true end
    local visible = isPlayerVisible(char)
    visibilityCache[player] = visible
    visibilityCacheTime[player] = now
    return visible
end

--// ESP MODULE
local ESP = {}
ESP.__index = ESP

function ESP.new()
    local self = setmetatable({}, ESP)
    self.espCache = {}; self.plotDrawings = {}; self.plotHighlights = {}
    return self
end

function ESP:createDrawing(type, props)
    local d = Drawing.new(type)
    for p, v in pairs(props) do d[p] = v end
    return d
end

function ESP:getTracerStart()
    local sw, sh = Camera.ViewportSize.X, Camera.ViewportSize.Y
    if espSettings.tracerType == "Top" then return Vector2.new(sw / 2, 0)
    elseif espSettings.tracerType == "Bottom" then return Vector2.new(sw / 2, sh)
    elseif espSettings.tracerType == "Center" then return Vector2.new(sw / 2, sh / 2)
    elseif espSettings.tracerType == "Mouse" then local mp = UserInputService:GetMouseLocation(); return Vector2.new(mp.X, mp.Y) end
    return Vector2.new(sw / 2, 0)
end

local function getHealthColor(hp) return Color3.fromRGB(255 * (1 - hp), 255 * hp, 0) end

local function rotatePoint(px, py, cx, cy, angleDeg)
    local rad = math.rad(angleDeg)
    local cos, sin = math.cos(rad), math.sin(rad)
    local dx, dy = px - cx, py - cy
    return cx + dx * cos - dy * sin, cy + dx * sin + dy * cos
end

local function getVisColor(visible, normalColor, visibleColor, hiddenColor)
    if not espSettings.visibilityCheck then return normalColor end
    return visible and visibleColor or hiddenColor
end

local function getPlayerTool(player)
    local ct = tick()
    local char = player.Character
    if not char then toolCache[player] = nil return nil end
    if toolCache[player] and lastUpdateTime[player] and (ct - lastUpdateTime[player]) < 0.5 then return toolCache[player] end
    local tool = nil
    for _, c in ipairs(char:GetChildren()) do if c:IsA("Tool") then tool = c break end end
    if not tool then
        local bp = player:FindFirstChild("Backpack")
        if bp then for _, c in ipairs(bp:GetChildren()) do if c:IsA("Tool") then tool = c break end end end
    end
    toolCache[player] = tool; lastUpdateTime[player] = ct
    return tool
end

local function getPlotCenter(plot)
    local base = plot:FindFirstChild("Base")
    if base then return base.Position + Vector3.new(0, base.Size.Y / 2 + 2, 0) end
    local ok, cf, sz = pcall(plot.GetBoundingBox, plot)
    if ok and cf then return cf.Position + Vector3.new(0, sz.Y / 2, 0) end
    return nil
end

local function highlightPlot(plot)
    local h = plot:FindFirstChild("PlotHighlight")
    if not h then h = Instance.new("Highlight"); h.Name = "PlotHighlight"; h.Parent = plot end
    h.FillColor = plotSettings.highlightFillColor; h.FillTransparency = plotSettings.highlightFillTransparency
    h.OutlineColor = plotSettings.highlightOutlineColor; h.OutlineTransparency = plotSettings.highlightOutlineTransparency
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function removePlotHighlight(plot)
    local h = plot:FindFirstChild("PlotHighlight")
    if h then h:Destroy() end
end

--// ===== AIMBOT SYSTEM =====
local aimbotTarget = nil
local isAiming = false

-- Keybind маппинг
local keybindMap = {
    ["RMB"] = {type = "UserInputType", value = Enum.UserInputType.MouseButton2},
    ["MB4"] = {type = "UserInputType", value = Enum.UserInputType.MouseButton1},
    ["MB5"] = {type = "UserInputType", value = Enum.UserInputType.MouseButton3},
    ["Q"] = {type = "KeyCode", value = Enum.KeyCode.Q},
    ["E"] = {type = "KeyCode", value = Enum.KeyCode.E},
    ["R"] = {type = "KeyCode", value = Enum.KeyCode.R},
    ["F"] = {type = "KeyCode", value = Enum.KeyCode.F},
    ["X"] = {type = "KeyCode", value = Enum.KeyCode.X},
    ["C"] = {type = "KeyCode", value = Enum.KeyCode.C},
    ["V"] = {type = "KeyCode", value = Enum.KeyCode.V},
    ["CapsLock"] = {type = "KeyCode", value = Enum.KeyCode.CapsLock},
    ["LeftAlt"] = {type = "KeyCode", value = Enum.KeyCode.LeftAlt},
    ["LeftShift"] = {type = "KeyCode", value = Enum.KeyCode.LeftShift},
}

local function checkAimbotInput(input)
    local bind = keybindMap[combatSettings.aimbotKeyName]
    if not bind then return false end
    if bind.type == "UserInputType" then
        return input.UserInputType == bind.value
    else
        return input.KeyCode == bind.value
    end
end

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local closestDistance = combatSettings.aimbotFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local targetPart = character:FindFirstChild(combatSettings.aimbotTargetPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")

                if targetPart and humanoid and humanoid.Health > 0 then
                    if combatSettings.aimbotTeamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end

                    if combatSettings.aimbotVisibilityCheck and not isPlayerVisible(character) then
                        continue
                    end

                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)

                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function aimAt(player)
    if not player then return end

    local character = player.Character
    if not character then return end

    local targetPart = character:FindFirstChild(combatSettings.aimbotTargetPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end

    local targetPos = targetPart.Position

    if combatSettings.aimbotPrediction then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local velocity = hrp.AssemblyLinearVelocity or hrp.Velocity
            targetPos = targetPos + (velocity * combatSettings.aimbotPredictionAmount)
        end
    end

    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)

    Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 - combatSettings.aimbotSmoothing)
end

-- Input handling
table.insert(activeConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isUnloaded then return end

    if combatSettings.aimbotEnabled and checkAimbotInput(input) then
        isAiming = true
    end
end))

table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if isUnloaded then return end

    if checkAimbotInput(input) then
        isAiming = false
        aimbotTarget = nil
    end
end))

--// Player ESP Components
function ESP:createComponents()
    return {
        Box = self:createDrawing("Square", {Thickness = espSettings.boxThickness, Transparency = 1, Color = espSettings.boxColor, Filled = false}),
        Tracer = self:createDrawing("Line", {Thickness = espSettings.tracerThickness, Transparency = 1, Color = espSettings.tracerColor}),
        DistanceLabel = self:createDrawing("Text", {Size = 16, Center = true, Outline = true, Color = espSettings.distanceColor, OutlineColor = Color3.fromRGB(0, 0, 0)}),
        NameLabel = self:createDrawing("Text", {Size = 18, Center = true, Outline = true, Color = espSettings.nameColor, OutlineColor = Color3.fromRGB(0, 0, 0)}),
        HealthBar = {
            Outline = self:createDrawing("Square", {Thickness = 1, Transparency = 1, Color = Color3.fromRGB(0, 0, 0), Filled = false}),
            Health = self:createDrawing("Square", {Thickness = 1, Transparency = 1, Color = Color3.fromRGB(0, 255, 0), Filled = true}),
            HealthText = self:createDrawing("Text", {Size = 12, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(0, 0, 0)})
        },
        ItemLabel = self:createDrawing("Text", {Size = 14, Center = true, Outline = true, Color = espSettings.itemColor, OutlineColor = Color3.fromRGB(0, 0, 0)}),
        VisLabel = self:createDrawing("Text", {Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(0, 255, 0), OutlineColor = Color3.fromRGB(0, 0, 0), Visible = false}),
        ArrowShadow1 = self:createDrawing("Triangle", {Thickness = 1, Color = arrowSettings.shadowColor, Filled = true, Visible = false, Transparency = 0.4, ZIndex = 1}),
        ArrowShadow2 = self:createDrawing("Triangle", {Thickness = 1, Color = arrowSettings.shadowColor, Filled = true, Visible = false, Transparency = 0.4, ZIndex = 1}),
        ArrowGlow1 = self:createDrawing("Triangle", {Thickness = 5, Color = arrowSettings.glowColor, Filled = false, Visible = false, Transparency = 0.2, ZIndex = 2}),
        ArrowGlow2 = self:createDrawing("Triangle", {Thickness = 5, Color = arrowSettings.glowColor, Filled = false, Visible = false, Transparency = 0.2, ZIndex = 2}),
        ArrowFill1 = self:createDrawing("Triangle", {Thickness = 1, Color = arrowSettings.color, Filled = true, Visible = false, ZIndex = 3}),
        ArrowFill2 = self:createDrawing("Triangle", {Thickness = 1, Color = arrowSettings.colorTip, Filled = true, Visible = false, ZIndex = 3}),
        ArrowOutline1 = self:createDrawing("Triangle", {Thickness = 2, Color = arrowSettings.outlineColor, Filled = false, Visible = false, ZIndex = 4}),
        ArrowOutline2 = self:createDrawing("Triangle", {Thickness = 2, Color = arrowSettings.outlineColor, Filled = false, Visible = false, ZIndex = 4}),
        ArrowHighlight = self:createDrawing("Triangle", {Thickness = 1, Color = arrowSettings.highlightColor, Filled = true, Visible = false, Transparency = 0.25, ZIndex = 5}),
        ArrowDistance = self:createDrawing("Text", {Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(0, 0, 0), Visible = false, ZIndex = 6}),
        SkeletonLines = {}, ChamsParts = {}, active = true
    }
end

local bodyConnections = {
    R15 = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}},
    R6 = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
}

function ESP:drawArrow(components, hrp, distance)
    local camPos = Camera.CFrame.Position; local lookVec = Camera.CFrame.LookVector
    local toPlayer = (hrp.Position - camPos).Unit; local dot = lookVec:Dot(toPlayer); local isBehind = dot < 0
    local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    local dx, dy
    if onScreen and not isBehind then dx, dy = sp.X - sc.X, sp.Y - sc.Y
    else local pp = Camera:WorldToViewportPoint(camPos + toPlayer * 100); local pf = Camera:WorldToViewportPoint(camPos + lookVec * 100); dx, dy = pp.X - pf.X, pp.Y - pf.Y end
    local dl = math.sqrt(dx * dx + dy * dy)
    if dl < 0.001 then dx, dy = sp.X - sc.X, sp.Y - sc.Y; dl = math.sqrt(dx * dx + dy * dy); if dl < 0.001 then return end end
    dx, dy = dx / dl, dy / dl; if isBehind then dx, dy = -dx, -dy end
    local dir = Vector2.new(dx, dy); local t = tick()
    local pulse = arrowSettings.showGlow and (arrowSettings.pulseMin + (arrowSettings.pulseMax - arrowSettings.pulseMin) * 0.5 * (1 + math.sin(t * arrowSettings.pulseSpeed))) or 1
    local bobOffset = Vector2.new(0, 0)
    if arrowSettings.bobbingEnabled then local bob = math.sin(t * arrowSettings.bobbingSpeed) * arrowSettings.bobbingAmount; bobOffset = Vector2.new(-dir.Y * bob, dir.X * bob) end
    local ac = sc + dir * arrowSettings.radius + bobOffset; local aSize = arrowSettings.size * pulse; local iSize = aSize * 0.4
    local rotOff = arrowSettings.rotationOffset; local pd = Vector2.new(-dir.Y, dir.X); local tip, bl, br
    local style = arrowSettings.style
    if style == "Classic" then tip = ac + dir * aSize; bl = ac - dir * iSize + pd * (aSize * 0.45); br = ac - dir * iSize - pd * (aSize * 0.45)
    elseif style == "Modern" then tip = ac + dir * (aSize * 0.9); bl = ac - dir * (iSize * 0.6) + pd * (aSize * 0.55); br = ac - dir * (iSize * 0.6) - pd * (aSize * 0.55)
    elseif style == "Minimal" then tip = ac + dir * (aSize * 0.7); bl = ac - dir * (iSize * 0.3) + pd * (aSize * 0.25); br = ac - dir * (iSize * 0.3) - pd * (aSize * 0.25)
    elseif style == "Neon" then tip = ac + dir * aSize; bl = ac - dir * (iSize * 1.5) + pd * (aSize * 0.5); br = ac - dir * (iSize * 1.5) - pd * (aSize * 0.5)
    end
    if rotOff ~= 0 then
        tip = Vector2.new(rotatePoint(tip.X, tip.Y, ac.X, ac.Y, rotOff)); bl = Vector2.new(rotatePoint(bl.X, bl.Y, ac.X, ac.Y, rotOff)); br = Vector2.new(rotatePoint(br.X, br.Y, ac.X, ac.Y, rotOff))
    end
    if arrowSettings.shadowEnabled then
        local so = Vector2.new(2, 2)
        components.ArrowShadow1.PointA, components.ArrowShadow1.PointB, components.ArrowShadow1.PointC = tip + so, bl + so, br + so
        components.ArrowShadow1.Transparency = arrowSettings.shadowTransparency; components.ArrowShadow1.Visible = true
        components.ArrowShadow2.Visible = false
    else components.ArrowShadow1.Visible = false; components.ArrowShadow2.Visible = false end
    if arrowSettings.showGlow then
        local gs = aSize * 1.3; local gTip = ac + dir * gs; local gBL = ac - dir * iSize * 1.2 + pd * (gs * 0.45); local gBR = ac - dir * iSize * 1.2 - pd * (gs * 0.45)
        components.ArrowGlow1.PointA, components.ArrowGlow1.PointB, components.ArrowGlow1.PointC = gTip, gBL, gBR
        components.ArrowGlow1.Color = arrowSettings.glowColor; components.ArrowGlow1.Transparency = arrowSettings.glowTransparency + 0.1 * math.sin(t * 6)
        components.ArrowGlow1.Thickness = arrowSettings.glowThickness; components.ArrowGlow1.Visible = true; components.ArrowGlow2.Visible = false
    else components.ArrowGlow1.Visible = false; components.ArrowGlow2.Visible = false end
    local fillType = arrowSettings.fillType
    if fillType == "Filled" then
        components.ArrowFill1.PointA, components.ArrowFill1.PointB, components.ArrowFill1.PointC = tip, bl, br; components.ArrowFill1.Color = arrowSettings.color; components.ArrowFill1.Transparency = arrowSettings.transparency; components.ArrowFill1.Visible = true
        components.ArrowOutline1.PointA, components.ArrowOutline1.PointB, components.ArrowOutline1.PointC = tip, bl, br; components.ArrowOutline1.Color = arrowSettings.outlineColor; components.ArrowOutline1.Thickness = arrowSettings.outlineThickness; components.ArrowOutline1.Visible = true
        components.ArrowFill2.Visible = false; components.ArrowOutline2.Visible = false
    elseif fillType == "Outline" then
        components.ArrowFill1.Visible = false; components.ArrowFill2.Visible = false
        components.ArrowOutline1.PointA, components.ArrowOutline1.PointB, components.ArrowOutline1.PointC = tip, bl, br; components.ArrowOutline1.Color = arrowSettings.color; components.ArrowOutline1.Thickness = arrowSettings.outlineThickness; components.ArrowOutline1.Visible = true; components.ArrowOutline2.Visible = false
    elseif fillType == "Gradient" then
        local mid = (bl + br) / 2
        components.ArrowFill1.PointA, components.ArrowFill1.PointB, components.ArrowFill1.PointC = tip, bl, mid; components.ArrowFill1.Color = arrowSettings.color; components.ArrowFill1.Transparency = arrowSettings.transparency; components.ArrowFill1.Visible = true
        components.ArrowFill2.PointA, components.ArrowFill2.PointB, components.ArrowFill2.PointC = tip, br, mid; components.ArrowFill2.Color = arrowSettings.colorTip; components.ArrowFill2.Transparency = arrowSettings.transparency; components.ArrowFill2.Visible = true
        components.ArrowOutline1.PointA, components.ArrowOutline1.PointB, components.ArrowOutline1.PointC = tip, bl, br; components.ArrowOutline1.Color = arrowSettings.outlineColor; components.ArrowOutline1.Thickness = arrowSettings.outlineThickness; components.ArrowOutline1.Visible = true; components.ArrowOutline2.Visible = false
    end
    if arrowSettings.highlightEnabled then
        local hs = aSize * 0.6; local hTip = ac + dir * hs; local hBL = ac - dir * (iSize * 0.5) + pd * (aSize * 0.2); local hBR = ac - dir * (iSize * 0.5) - pd * (aSize * 0.2)
        components.ArrowHighlight.PointA, components.ArrowHighlight.PointB, components.ArrowHighlight.PointC = hTip, hBL, hBR
        components.ArrowHighlight.Color = arrowSettings.highlightColor; components.ArrowHighlight.Transparency = arrowSettings.highlightTransparency; components.ArrowHighlight.Visible = true
    else components.ArrowHighlight.Visible = false end
    if arrowSettings.showDistance then components.ArrowDistance.Text = string.format("%dm", distance); components.ArrowDistance.Position = ac - dir * (aSize + 10) + bobOffset; components.ArrowDistance.Color = arrowSettings.color; components.ArrowDistance.Visible = true
    else components.ArrowDistance.Visible = false end
end

function ESP:hideArrow(components)
    components.ArrowShadow1.Visible = false; components.ArrowShadow2.Visible = false
    components.ArrowGlow1.Visible = false; components.ArrowGlow2.Visible = false
    components.ArrowFill1.Visible = false; components.ArrowFill2.Visible = false
    components.ArrowOutline1.Visible = false; components.ArrowOutline2.Visible = false
    components.ArrowHighlight.Visible = false; components.ArrowDistance.Visible = false
end

function ESP:updateComponents(components, character, player)
    if not components.active then self:hideComponents(components) return end
    local hrp = character:FindFirstChild("HumanoidRootPart"); local humanoid = character:FindFirstChild("Humanoid")
    if hrp and humanoid and hrp.Parent then
        local hp, onScreen = Camera:WorldToViewportPoint(hrp.Position); local dist = math.floor((LocalHumanoidRootPart.Position - hrp.Position).Magnitude)
        local visible = getPlayerVisibility(player)
        if espSettings.enabled and onScreen and hp.Z > 0 then
            local head = character:FindFirstChild("Head")
            local tp = head and (head.Position + Vector3.new(0, 0.5, 0)) or (hrp.Position + Vector3.new(0, 3, 0))
            local bp = hrp.Position - Vector3.new(0, 3, 0)
            local lf = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg"); local rf = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg")
            if lf then bp = lf.Position - Vector3.new(0, 0.5, 0) elseif rf then bp = rf.Position - Vector3.new(0, 0.5, 0) end
            local ts = Camera:WorldToViewportPoint(tp); local bs = Camera:WorldToViewportPoint(bp)
            local bh = math.clamp(math.abs(bs.Y - ts.Y), 15, 800); local bw = bh * 0.55; local bt = math.min(ts.Y, bs.Y); local bl = hp.X - bw / 2
            local boxC = getVisColor(visible, espSettings.boxColor, espSettings.visibleBoxColor, espSettings.hiddenBoxColor)
            local tracerC = getVisColor(visible, espSettings.tracerColor, espSettings.visibleTracerColor, espSettings.hiddenTracerColor)
            local nameC = getVisColor(visible, espSettings.nameColor, espSettings.visibleNameColor, espSettings.hiddenNameColor)
            local distC = getVisColor(visible, espSettings.distanceColor, espSettings.visibleDistanceColor, espSettings.hiddenDistanceColor)
            local itemC = getVisColor(visible, espSettings.itemColor, espSettings.visibleItemColor, espSettings.hiddenItemColor)
            local chamsC = getVisColor(visible, espSettings.chamsColor, espSettings.visibleChamsColor, espSettings.hiddenChamsColor)
            if espSettings.showBoxes then components.Box.Size = Vector2.new(bw, bh); components.Box.Position = Vector2.new(bl, bt); components.Box.Color = boxC; components.Box.Thickness = espSettings.boxThickness; components.Box.Visible = true else components.Box.Visible = false end
            if espSettings.showTracers then components.Tracer.From = self:getTracerStart(); components.Tracer.To = Vector2.new(hp.X, hp.Y); components.Tracer.Color = tracerC; components.Tracer.Thickness = espSettings.tracerThickness; components.Tracer.Visible = true else components.Tracer.Visible = false end
            if espSettings.showDistance then components.DistanceLabel.Text = string.format("%dm", dist); components.DistanceLabel.Position = Vector2.new(hp.X, bt + bh + 5); components.DistanceLabel.Color = distC; components.DistanceLabel.Visible = true else components.DistanceLabel.Visible = false end
            if espSettings.showNames then components.NameLabel.Text = player.Name; components.NameLabel.Position = Vector2.new(hp.X, bt - 18); components.NameLabel.Color = nameC; components.NameLabel.Visible = true else components.NameLabel.Visible = false end
            if espSettings.visibilityCheck and espSettings.showVisLabel then components.VisLabel.Text = visible and "[VISIBLE]" or "[HIDDEN]"; components.VisLabel.Position = Vector2.new(hp.X, bt + bh + (espSettings.showDistance and 20 or 5)); components.VisLabel.Color = visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0); components.VisLabel.Visible = true else components.VisLabel.Visible = false end
            if espSettings.showBoxes and espSettings.showHP then
                local hbw = 4; local hf = humanoid.Health / humanoid.MaxHealth; local hpp = math.floor(hf * 100)
                components.HealthBar.Outline.Size = Vector2.new(hbw, bh); components.HealthBar.Outline.Position = Vector2.new(bl - hbw - 3, bt); components.HealthBar.Outline.Visible = true
                local hc = getHealthColor(hf)
                components.HealthBar.Health.Size = Vector2.new(hbw - 1, bh * hf); components.HealthBar.Health.Position = Vector2.new(bl - hbw - 2.5, bt + bh * (1 - hf)); components.HealthBar.Health.Color = hc; components.HealthBar.Health.Visible = true
                components.HealthBar.HealthText.Text = string.format("%d%%", hpp); components.HealthBar.HealthText.Position = Vector2.new(bl - hbw - 29, bt + (bh / 2) - 8); components.HealthBar.HealthText.Color = hc; components.HealthBar.HealthText.Visible = true
            else components.HealthBar.Outline.Visible = false; components.HealthBar.Health.Visible = false; components.HealthBar.HealthText.Visible = false end
            if espSettings.showItems then
                local tool = getPlayerTool(player)
                if tool then local tn = tool.Name; if tn == "Tool" or tn == "HopperBin" then tn = "Weapon" end; components.ItemLabel.Text = string.format("[%s]", tn); components.ItemLabel.Position = Vector2.new(hp.X, bt + bh + (espSettings.visibilityCheck and 35 or 22)); components.ItemLabel.Color = itemC; components.ItemLabel.Visible = true else components.ItemLabel.Visible = false end
            else components.ItemLabel.Visible = false end
            if espSettings.showSkeleton then
                local conns = bodyConnections[humanoid.RigType.Name] or {}
                for _, c in ipairs(conns) do
                    local pA = character:FindFirstChild(c[1]); local pB = character:FindFirstChild(c[2])
                    if pA and pB then local lk = c[1] .. "-" .. c[2]; local line = components.SkeletonLines[lk]; if not line then line = self:createDrawing("Line", {Thickness = 1, Color = espSettings.skeletonColor}); components.SkeletonLines[lk] = line end
                    local ra, oa = Camera:WorldToViewportPoint(pA.Position); local rb, ob = Camera:WorldToViewportPoint(pB.Position); if oa and ob then line.From = Vector2.new(ra.X, ra.Y); line.To = Vector2.new(rb.X, rb.Y); line.Color = getVisColor(visible, espSettings.skeletonColor, espSettings.visibleBoxColor, espSettings.hiddenBoxColor); line.Visible = true else line.Visible = false end end
                end
            else for _, line in pairs(components.SkeletonLines) do if line then line.Visible = false end end end
            if espSettings.showChams then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        local cp = components.ChamsParts[part]; if not cp then cp = Instance.new("BoxHandleAdornment"); cp.AlwaysOnTop = true; cp.ZIndex = 0; cp.Parent = part; components.ChamsParts[part] = cp end
                        cp.Adornee = part; cp.Size = part.Size; cp.Color3 = chamsC; cp.Transparency = espSettings.chamsTransparency; cp.Visible = true end
                end
            else for _, cp in pairs(components.ChamsParts) do if cp then cp.Visible = false end end end
            self:hideArrow(components)
        else
            self:hideComponents(components, true)
            if arrowSettings.enabled and hrp then
                local savedColor = arrowSettings.color; if espSettings.visibilityCheck then arrowSettings.color = visible and espSettings.visibleArrowColor or espSettings.hiddenArrowColor end
                self:drawArrow(components, hrp, dist); arrowSettings.color = savedColor
            else self:hideArrow(components) end
        end
    else self:hideComponents(components) end
end

function ESP:hideComponents(components, keepArrows)
    if not components then return end
    pcall(function()
        if components.Box then components.Box.Visible = false end; if components.Tracer then components.Tracer.Visible = false end
        if components.DistanceLabel then components.DistanceLabel.Visible = false end; if components.NameLabel then components.NameLabel.Visible = false end
        if components.HealthBar then components.HealthBar.Outline.Visible = false; components.HealthBar.Health.Visible = false; components.HealthBar.HealthText.Visible = false end
        if components.ItemLabel then components.ItemLabel.Visible = false end; if components.VisLabel then components.VisLabel.Visible = false end
        if components.SkeletonLines then for _, line in pairs(components.SkeletonLines) do if line then line.Visible = false end end end
        if not keepArrows then self:hideArrow(components) end
    end)
end

function ESP:removeEsp(player)
    local components = self.espCache[player]
    if components then components.active = false
        pcall(function()
            if components.Box then components.Box:Remove() end; if components.Tracer then components.Tracer:Remove() end
            if components.DistanceLabel then components.DistanceLabel:Remove() end; if components.NameLabel then components.NameLabel:Remove() end
            if components.HealthBar then components.HealthBar.Outline:Remove(); components.HealthBar.Health:Remove(); components.HealthBar.HealthText:Remove() end
            if components.ItemLabel then components.ItemLabel:Remove() end; if components.VisLabel then components.VisLabel:Remove() end
            if components.ArrowShadow1 then components.ArrowShadow1:Remove() end; if components.ArrowShadow2 then components.ArrowShadow2:Remove() end
            if components.ArrowGlow1 then components.ArrowGlow1:Remove() end; if components.ArrowGlow2 then components.ArrowGlow2:Remove() end
            if components.ArrowFill1 then components.ArrowFill1:Remove() end; if components.ArrowFill2 then components.ArrowFill2:Remove() end
            if components.ArrowOutline1 then components.ArrowOutline1:Remove() end; if components.ArrowOutline2 then components.ArrowOutline2:Remove() end
            if components.ArrowHighlight then components.ArrowHighlight:Remove() end; if components.ArrowDistance then components.ArrowDistance:Remove() end
            for _, line in pairs(components.SkeletonLines) do if line then line:Remove() end end
            for _, cp in pairs(components.ChamsParts) do if cp then cp:Destroy() end end
        end)
        self.espCache[player] = nil
    end
    toolCache[player] = nil; lastUpdateTime[player] = nil; visibilityCache[player] = nil; visibilityCacheTime[player] = nil
end

function ESP:getOrCreatePlotDrawings(plot)
    if self.plotDrawings[plot] then return self.plotDrawings[plot] end
    local d = {
        Tracer = self:createDrawing("Line", {Thickness = plotSettings.tracerThickness, Transparency = 1, Color = plotSettings.tracerColor, Visible = false}),
        NameLabel = self:createDrawing("Text", {Size = 16, Center = true, Outline = true, Color = plotSettings.nameColor, OutlineColor = Color3.fromRGB(0, 0, 0), Visible = false}),
        DistanceLabel = self:createDrawing("Text", {Size = 14, Center = true, Outline = true, Color = plotSettings.distanceColor, OutlineColor = Color3.fromRGB(0, 0, 0), Visible = false}),
    }
    self.plotDrawings[plot] = d; return d
end

function ESP:updatePlotDrawings()
    local pf = workspace:FindFirstChild("Plots"); if not pf then self:hideAllPlotDrawings() return end
    local used = {}
    for _, plot in ipairs(pf:GetChildren()) do
        if not plot:IsA("Folder") and not plot:IsA("Model") then continue end; used[plot] = true
        local d = self:getOrCreatePlotDrawings(plot)
        if not plotSettings.enabled or not LocalHumanoidRootPart then self:hidePlotDrawings(d); if not plotSettings.enabled then removePlotHighlight(plot) end; continue end
        local pc = getPlotCenter(plot); if not pc then self:hidePlotDrawings(d); continue end
        local dist = math.floor((LocalHumanoidRootPart.Position - pc).Magnitude); local sp, onScreen = Camera:WorldToViewportPoint(pc)
        if plotSettings.showHighlight then highlightPlot(plot); self.plotHighlights[plot] = true else removePlotHighlight(plot); self.plotHighlights[plot] = nil end
        if onScreen and sp.Z > 0 then
            if plotSettings.showTracers then d.Tracer.From = self:getTracerStart(); d.Tracer.To = Vector2.new(sp.X, sp.Y); d.Tracer.Color = plotSettings.tracerColor; d.Tracer.Thickness = plotSettings.tracerThickness; d.Tracer.Visible = true else d.Tracer.Visible = false end
            if plotSettings.showNames then d.NameLabel.Text = plot.Name; d.NameLabel.Position = Vector2.new(sp.X, sp.Y - 25); d.NameLabel.Color = plotSettings.nameColor; d.NameLabel.Visible = true else d.NameLabel.Visible = false end
            if plotSettings.showDistance then d.DistanceLabel.Text = string.format("%dm", dist); d.DistanceLabel.Position = Vector2.new(sp.X, sp.Y + 8); d.DistanceLabel.Color = plotSettings.distanceColor; d.DistanceLabel.Visible = true else d.DistanceLabel.Visible = false end
        else self:hidePlotDrawings(d) end
    end
    for plot, d in pairs(self.plotDrawings) do
        if not used[plot] then self:hidePlotDrawings(d); d.Tracer:Remove(); d.NameLabel:Remove(); d.DistanceLabel:Remove(); self.plotDrawings[plot] = nil; removePlotHighlight(plot); self.plotHighlights[plot] = nil end
    end
end

function ESP:hidePlotDrawings(d) if d.Tracer then d.Tracer.Visible = false end; if d.NameLabel then d.NameLabel.Visible = false end; if d.DistanceLabel then d.DistanceLabel.Visible = false end end
function ESP:hideAllPlotDrawings() for _, d in pairs(self.plotDrawings) do self:hidePlotDrawings(d) end end
function ESP:removeAllPlotDrawings() for plot, d in pairs(self.plotDrawings) do if d.Tracer then d.Tracer:Remove() end; if d.NameLabel then d.NameLabel:Remove() end; if d.DistanceLabel then d.DistanceLabel:Remove() end; removePlotHighlight(plot); self.plotDrawings[plot] = nil; self.plotHighlights[plot] = nil end end

local espInstance = ESP.new()

--// LIGHTING / FOG / SKYBOX
local function applyLighting()
    if worldSettings.fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = worldSettings.originalBrightness
        Lighting.ClockTime = worldSettings.originalClockTime
        Lighting.Ambient = worldSettings.originalAmbient
        Lighting.OutdoorAmbient = worldSettings.originalOutdoorAmbient
        Lighting.GlobalShadows = worldSettings.originalGlobalShadows
    end
end

local function setNoFog(enabled)
    if enabled then
        if noFogConnection then noFogConnection:Disconnect() end
        noFogConnection = RunService.RenderStepped:Connect(function()
            if worldSettings.nofog and not isUnloaded then
                Lighting.FogStart = 0
                Lighting.FogEnd = 1e9
            end
        end)
        table.insert(activeConnections, noFogConnection)
    else
        if noFogConnection then noFogConnection:Disconnect(); noFogConnection = nil end
        Lighting.FogStart = worldSettings.originalFogStart
        Lighting.FogEnd = worldSettings.originalFogEnd
    end
end

local function updateSkybox()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then child:Destroy() end
    end

    if worldSettings.skyboxEnabled and worldSettings.currentSkyColor then
        local sky = Instance.new("Sky")
        sky.Name = "CustomSkybox"

        local colors = {
            ["Sunset Orange"] = {Color3.fromRGB(255, 100, 50), Color3.fromRGB(255, 150, 100)},
            ["Night Purple"] = {Color3.fromRGB(50, 0, 100), Color3.fromRGB(100, 50, 150)},
            ["Blood Red"] = {Color3.fromRGB(150, 0, 0), Color3.fromRGB(100, 0, 0)},
            ["Ocean Blue"] = {Color3.fromRGB(0, 50, 150), Color3.fromRGB(50, 100, 200)},
            ["Forest Green"] = {Color3.fromRGB(0, 100, 50), Color3.fromRGB(50, 150, 100)},
            ["Space Black"] = {Color3.fromRGB(5, 5, 15), Color3.fromRGB(10, 10, 30)},
            ["Pink Dream"] = {Color3.fromRGB(255, 100, 200), Color3.fromRGB(255, 150, 220)},
            ["Golden Hour"] = {Color3.fromRGB(255, 200, 100), Color3.fromRGB(255, 220, 150)},
        }

        local selectedColors = colors[worldSettings.currentSkyColor]
        if selectedColors then
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            if not atmosphere then
                atmosphere = Instance.new("Atmosphere")
                atmosphere.Parent = Lighting
            end
            atmosphere.Color = selectedColors[1]
            atmosphere.Decay = selectedColors[2]
            atmosphere.Density = 0.3
            atmosphere.Glare = 0
            atmosphere.Haze = 1

            Lighting.Ambient = selectedColors[1]
            Lighting.OutdoorAmbient = selectedColors[2]

            sky.SkyboxBk = ""
            sky.SkyboxDn = ""
            sky.SkyboxFt = ""
            sky.SkyboxLf = ""
            sky.SkyboxRt = ""
            sky.SkyboxUp = ""
            sky.CelestialBodiesShown = worldSettings.currentSkyColor ~= "Space Black"
            sky.StarCount = worldSettings.currentSkyColor == "Space Black" and 5000 or 3000
            sky.Parent = Lighting
        end
    else
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then atmosphere:Destroy() end
        applyLighting()
    end
end

--// COLORS
local colorOptions = {
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Red"] = Color3.fromRGB(255, 50, 50),
    ["Green"] = Color3.fromRGB(50, 255, 50),
    ["Blue"] = Color3.fromRGB(50, 100, 255),
    ["Yellow"] = Color3.fromRGB(255, 255, 50),
    ["Purple"] = Color3.fromRGB(200, 50, 255),
    ["Orange"] = Color3.fromRGB(255, 150, 50),
    ["Cyan"] = Color3.fromRGB(50, 255, 255),
    ["Pink"] = Color3.fromRGB(255, 100, 200),
    ["Gold"] = Color3.fromRGB(255, 215, 0),
}
local colorDropdown = {
    ["White"] = "White", ["Red"] = "Red", ["Green"] = "Green", ["Blue"] = "Blue",
    ["Yellow"] = "Yellow", ["Purple"] = "Purple", ["Orange"] = "Orange",
    ["Cyan"] = "Cyan", ["Pink"] = "Pink", ["Gold"] = "Gold"
}

--// ========== GUI ==========
local espTab = Window:AddTab({Title = "ESP", Section = "ESP Settings", Icon = "rbxassetid://11963373994"})
Window:AddSection({Name = "Main ESP Toggles", Tab = espTab})
Window:AddToggle({Title = "ESP Enabled", Tab = espTab, Default = false, Callback = function(b) espSettings.enabled = b end})
Window:AddToggle({Title = "Box ESP", Tab = espTab, Default = false, Callback = function(b) espSettings.showBoxes = b end})
Window:AddToggle({Title = "Tracers", Tab = espTab, Default = false, Callback = function(b) espSettings.showTracers = b end})
Window:AddToggle({Title = "Player Names", Tab = espTab, Default = false, Callback = function(b) espSettings.showNames = b end})
Window:AddToggle({Title = "Distance Display", Tab = espTab, Default = false, Callback = function(b) espSettings.showDistance = b end})
Window:AddToggle({Title = "HP Bar", Tab = espTab, Default = false, Callback = function(b) espSettings.showHP = b end})
Window:AddToggle({Title = "Item/Weapon Display", Tab = espTab, Default = false, Callback = function(b) espSettings.showItems = b end})
Window:AddToggle({Title = "Skeleton ESP", Tab = espTab, Default = false, Callback = function(b) espSettings.showSkeleton = b end})
Window:AddToggle({Title = "Chams (Glow)", Tab = espTab, Default = false, Callback = function(b) espSettings.showChams = b end})

Window:AddSection({Name = "Visibility Check", Tab = espTab})
Window:AddToggle({Title = "Visibility ESP", Tab = espTab, Default = false, Callback = function(b) espSettings.visibilityCheck = b; if not b then visibilityCache = {}; visibilityCacheTime = {} end end})
Window:AddToggle({Title = "Visibility Text", Tab = espTab, Default = true, Callback = function(b) espSettings.showVisLabel = b end})

Window:AddSection({Name = "Arrow Settings", Tab = espTab})
Window:AddToggle({Title = "Off-Screen Arrows", Tab = espTab, Default = false, Callback = function(b) arrowSettings.enabled = b end})
Window:AddDropdown({Title = "Arrow Style", Tab = espTab, Options = {["Classic"] = "Classic", ["Modern"] = "Modern", ["Minimal"] = "Minimal", ["Neon"] = "Neon"}, Callback = function(o) arrowSettings.style = o end})
Window:AddToggle({Title = "Arrow Distance", Tab = espTab, Default = false, Callback = function(b) arrowSettings.showDistance = b end})
Window:AddToggle({Title = "Arrow Glow", Tab = espTab, Default = true, Callback = function(b) arrowSettings.showGlow = b end})

Window:AddSection({Name = "Tracer Settings", Tab = espTab})
Window:AddDropdown({Title = "Tracer Origin", Tab = espTab, Options = {["Top Center"] = "Top", ["Bottom Center"] = "Bottom", ["Screen Center"] = "Center", ["Mouse Position"] = "Mouse"}, Callback = function(o) espSettings.tracerType = o end})
AddSlider({Title = "Box Thickness", Tab = espTab, MinValue = 1, MaxValue = 5, Default = 2, Callback = function(v) espSettings.boxThickness = v end})
AddSlider({Title = "Tracer Thickness", Tab = espTab, MinValue = 1, MaxValue = 5, Default = 1, Callback = function(v) espSettings.tracerThickness = v end})

Window:AddSection({Name = "Plot ESP", Tab = espTab})
Window:AddToggle({Title = "Plot ESP Enabled", Tab = espTab, Default = false, Callback = function(b) plotSettings.enabled = b end})
Window:AddToggle({Title = "Plot Highlight", Tab = espTab, Default = false, Callback = function(b) plotSettings.showHighlight = b end})
Window:AddToggle({Title = "Plot Tracers", Tab = espTab, Default = false, Callback = function(b) plotSettings.showTracers = b end})
Window:AddToggle({Title = "Plot Names", Tab = espTab, Default = false, Callback = function(b) plotSettings.showNames = b end})

--// ===== COMBAT TAB =====
local combatTab = Window:AddTab({Title = "Combat", Section = "Combat Settings", Icon = "rbxassetid://6034287594"})

Window:AddSection({Name = "Aimbot", Tab = combatTab})
Window:AddToggle({Title = "Aimbot Enabled", Tab = combatTab, Default = false, Callback = function(b) combatSettings.aimbotEnabled = b end})
Window:AddDropdown({Title = "Aimbot Keybind", Tab = combatTab, Options = {
    ["RMB"] = "RMB", ["Q"] = "Q", ["E"] = "E", ["R"] = "R", ["F"] = "F",
    ["X"] = "X", ["C"] = "C", ["V"] = "V",
    ["CapsLock"] = "CapsLock", ["LeftAlt"] = "LeftAlt", ["LeftShift"] = "LeftShift",
}, Callback = function(k) combatSettings.aimbotKeyName = k end})
Window:AddToggle({Title = "Show FOV Circle", Tab = combatTab, Default = false, Callback = function(b) combatSettings.aimbotShowFOV = b; aimbotFOVCircle.Visible = b end})
Window:AddToggle({Title = "Team Check", Tab = combatTab, Default = false, Callback = function(b) combatSettings.aimbotTeamCheck = b end})
Window:AddToggle({Title = "Visibility Check", Tab = combatTab, Default = true, Callback = function(b) combatSettings.aimbotVisibilityCheck = b end})
Window:AddToggle({Title = "Prediction", Tab = combatTab, Default = true, Callback = function(b) combatSettings.aimbotPrediction = b end})

Window:AddDropdown({Title = "Target Part", Tab = combatTab, Options = {["Head"] = "Head", ["UpperTorso"] = "UpperTorso", ["HumanoidRootPart"] = "HumanoidRootPart"}, Callback = function(o) combatSettings.aimbotTargetPart = o end})

Window:AddSection({Name = "Aimbot Sliders", Tab = combatTab})
AddSlider({Title = "FOV Size", Tab = combatTab, MinValue = 50, MaxValue = 500, Default = 150, Callback = function(v) combatSettings.aimbotFOV = v; aimbotFOVCircle.Radius = v end})
AddSlider({Title = "Smoothing", Tab = combatTab, MinValue = 0, MaxValue = 1, AllowDecimals = true, Default = 0.5, Callback = function(v) combatSettings.aimbotSmoothing = v end})
AddSlider({Title = "Prediction Amount", Tab = combatTab, MinValue = 0, MaxValue = 0.5, AllowDecimals = true, Default = 0.12, Callback = function(v) combatSettings.aimbotPredictionAmount = v end})

Window:AddSection({Name = "Fast Knife", Tab = combatTab})
Window:AddToggle({Title = "Fast Knife", Tab = combatTab, Default = false, Callback = function(b)
    combatSettings.fastKnifeEnabled = b
    if b then
        startFastKnife()
    else
        stopFastKnife()
    end
end})

Window:AddSection({Name = "FOV Circle Colors", Tab = combatTab})
Window:AddDropdown({Title = "FOV Circle Color", Tab = combatTab, Options = colorDropdown, Callback = function(c) aimbotFOVCircle.Color = colorOptions[c] end})

--// VISUAL TAB
local visualTab = Window:AddTab({Title = "Colors", Section = "Visual Settings", Icon = "rbxassetid://15876752170"})
Window:AddSection({Name = "ESP Colors", Tab = visualTab})
Window:AddDropdown({Title = "Box Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.boxColor = colorOptions[c] end})
Window:AddDropdown({Title = "Name Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.nameColor = colorOptions[c] end})
Window:AddDropdown({Title = "Distance Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.distanceColor = colorOptions[c] end})
Window:AddDropdown({Title = "Tracer Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.tracerColor = colorOptions[c] end})
Window:AddDropdown({Title = "Skeleton Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.skeletonColor = colorOptions[c] end})
Window:AddDropdown({Title = "Chams Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.chamsColor = colorOptions[c] end})

Window:AddSection({Name = "Visibility Colors (Visible)", Tab = visualTab})
Window:AddDropdown({Title = "Visible Box Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.visibleBoxColor = colorOptions[c] end})
Window:AddDropdown({Title = "Visible Tracer Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.visibleTracerColor = colorOptions[c] end})

Window:AddSection({Name = "Visibility Colors (Hidden)", Tab = visualTab})
Window:AddDropdown({Title = "Hidden Box Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.hiddenBoxColor = colorOptions[c] end})
Window:AddDropdown({Title = "Hidden Tracer Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) espSettings.hiddenTracerColor = colorOptions[c] end})

Window:AddSection({Name = "Arrow Colors", Tab = visualTab})
Window:AddDropdown({Title = "Arrow Fill Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) arrowSettings.color = colorOptions[c] end})
Window:AddDropdown({Title = "Arrow Glow Color", Tab = visualTab, Options = colorDropdown, Callback = function(c) arrowSettings.glowColor = colorOptions[c] end})

--// WORLD TAB
local worldTab = Window:AddTab({Title = "World", Section = "World Settings", Icon = "rbxassetid://11293977610"})
Window:AddSection({Name = "Visual Modifiers", Tab = worldTab})
Window:AddToggle({Title = "FullBright", Tab = worldTab, Default = false, Callback = function(b) worldSettings.fullbright = b applyLighting() end})
Window:AddToggle({Title = "No Fog", Tab = worldTab, Default = false, Callback = function(b) worldSettings.nofog = b setNoFog(b) end})

Window:AddSection({Name = "Skybox Settings", Tab = worldTab})
Window:AddToggle({Title = "Custom Skybox", Tab = worldTab, Default = false, Callback = function(b) worldSettings.skyboxEnabled = b updateSkybox() end})
Window:AddDropdown({Title = "Skybox Color", Tab = worldTab, Options = {
    ["Sunset Orange"] = "Sunset Orange",
    ["Night Purple"] = "Night Purple",
    ["Blood Red"] = "Blood Red",
    ["Ocean Blue"] = "Ocean Blue",
    ["Forest Green"] = "Forest Green",
    ["Space Black"] = "Space Black",
    ["Pink Dream"] = "Pink Dream",
    ["Golden Hour"] = "Golden Hour",
}, Callback = function(c) worldSettings.currentSkyColor = c if worldSettings.skyboxEnabled then updateSkybox() end end})

Window:AddSection({Name = "Angel Halo", Tab = worldTab})
Window:AddToggle({Title = "Angel Halo", Tab = worldTab, Default = false, Callback = function(b)
    worldSettings.angelHalo = b
    if b then
        createHalo()
    else
        removeHalo()
    end
end})
Window:AddDropdown({Title = "Halo Color", Tab = worldTab, Options = colorDropdown, Callback = function(c) worldSettings.haloColor = colorOptions[c]; updateHaloColor() end})
AddSlider({Title = "Halo Size", Tab = worldTab, MinValue = 1, MaxValue = 5, AllowDecimals = true, Default = 2, Callback = function(v) worldSettings.haloSize = v end})

Window:AddSection({Name = "Jump Circle", Tab = worldTab})
Window:AddToggle({Title = "Jump Circle", Tab = worldTab, Default = false, Callback = function(b) worldSettings.jumpCircleEnabled = b end})
Window:AddDropdown({Title = "Jump Circle Color", Tab = worldTab, Options = colorDropdown, Callback = function(c) worldSettings.jumpCircleColor = colorOptions[c] end})
AddSlider({Title = "Circle Max Size", Tab = worldTab, MinValue = 5, MaxValue = 40, Default = 15, Callback = function(v) worldSettings.jumpCircleSize = v end})

--// UI TAB
local uiTab = Window:AddTab({Title = "UI", Section = "UI Settings", Icon = "rbxassetid://11293977610"})
Window:AddDropdown({Title = "UI Theme", Tab = uiTab, Options = {["Light Mode"] = "Light", ["Dark Mode"] = "Dark", ["Extra Dark"] = "Void"}, Callback = function(t) Window:SetTheme(Themes[t]) end})
Window:AddToggle({Title = "UI Blur", Default = true, Tab = uiTab, Callback = function(b) Window:SetSetting("Blur", b) end})
AddSlider({Title = "UI Transparency", Tab = uiTab, MinValue = 0, MaxValue = 1, AllowDecimals = true, Default = 0.2, Callback = function(v) Window:SetSetting("Transparency", v) end})

--// UNLOAD
local function unloadAll()
    if isUnloaded then return end
    isUnloaded = true

    combatSettings.aimbotEnabled = false
    combatSettings.fastKnifeEnabled = false
    stopFastKnife()
    aimbotFOVCircle.Visible = false
    pcall(function() aimbotFOVCircle:Remove() end)

    espSettings.enabled = false
    arrowSettings.enabled = false
    plotSettings.enabled = false
    worldSettings.fullbright = false
    worldSettings.nofog = false
    worldSettings.skyboxEnabled = false
    worldSettings.angelHalo = false
    worldSettings.jumpCircleEnabled = false

    removeHalo()

    Lighting.Brightness = worldSettings.originalBrightness
    Lighting.ClockTime = worldSettings.originalClockTime
    Lighting.Ambient = worldSettings.originalAmbient
    Lighting.OutdoorAmbient = worldSettings.originalOutdoorAmbient
    Lighting.GlobalShadows = worldSettings.originalGlobalShadows
    Lighting.FogStart = worldSettings.originalFogStart
    Lighting.FogEnd = worldSettings.originalFogEnd

    if noFogConnection then noFogConnection:Disconnect(); noFogConnection = nil end
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then child:Destroy() end
    end
    for player, _ in pairs(espInstance.espCache) do espInstance:removeEsp(player) end
    espInstance:removeAllPlotDrawings()
    visibilityCache = {}
    visibilityCacheTime = {}

    for i, conn in pairs(activeConnections) do pcall(function() conn:Disconnect() end); activeConnections[i] = nil end
    if mainLoopConnection then pcall(function() mainLoopConnection:Disconnect() end); mainLoopConnection = nil end

    local toDestroy = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then for _, gui in ipairs(pg:GetChildren()) do if gui:IsA("ScreenGui") then table.insert(toDestroy, gui) end end end
    for _, gui in ipairs(toDestroy) do pcall(function() gui:Destroy() end) end
end

Window:AddSection({Name = "Script Control", Tab = uiTab})
Window:AddButton({Title = "UNLOAD ALL", Description = "Disable everything and destroy GUI", Tab = uiTab, Callback = function() unloadAll() end})

--// CONNECTIONS
table.insert(activeConnections, LocalPlayer.CharacterAdded:Connect(function(char)
    LocalCharacter = char
    LocalHumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    wasJumping = false
    if worldSettings.angelHalo and not isUnloaded then
        task.wait(1)
        createHalo()
    end
end))

local plotsFolder = workspace:FindFirstChild("Plots")
if plotsFolder then
    table.insert(activeConnections, plotsFolder.ChildAdded:Connect(function(child) task.wait(0.5); if plotSettings.showHighlight and not isUnloaded then highlightPlot(child); espInstance.plotHighlights[child] = true end end))
    table.insert(activeConnections, plotsFolder.ChildRemoved:Connect(function(child) removePlotHighlight(child); espInstance.plotHighlights[child] = nil end))
end
table.insert(activeConnections, Players.PlayerRemoving:Connect(function(player) espInstance:removeEsp(player) end))

--// MAIN LOOP
local fc = 0
mainLoopConnection = RunService.RenderStepped:Connect(function()
    if isUnloaded then return end
    fc = fc + 1

    if not LocalHumanoidRootPart or not LocalHumanoidRootPart.Parent then
        local char = LocalPlayer.Character
        if char then LocalHumanoidRootPart = char:FindFirstChild("HumanoidRootPart") end
        if not LocalHumanoidRootPart then return end
    end

    -- Jump Circle Detection
    if worldSettings.jumpCircleEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local state = humanoid:GetState()
                local isJumping = state == Enum.HumanoidStateType.Jumping

                if isJumping and not wasJumping then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {char}
                        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rayParams)
                        local floorPos = rayResult and rayResult.Position or (hrp.Position - Vector3.new(0, 3, 0))
                        createJumpCircleEffect(floorPos)
                    end
                end
                wasJumping = isJumping
            end
        end
    end

    -- Aimbot FOV Circle
    if combatSettings.aimbotShowFOV then
        local mousePos = UserInputService:GetMouseLocation()
        aimbotFOVCircle.Position = mousePos
        aimbotFOVCircle.Radius = combatSettings.aimbotFOV
        aimbotFOVCircle.Visible = true
    else
        aimbotFOVCircle.Visible = false
    end

    -- Aimbot Logic
    if combatSettings.aimbotEnabled and isAiming then
        aimbotTarget = getClosestPlayerToMouse()
        if aimbotTarget then
            aimAt(aimbotTarget)
        end
    end

    -- ESP Update
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character.Parent then
                if not espInstance.espCache[player] then espInstance.espCache[player] = espInstance:createComponents() end
                espInstance:updateComponents(espInstance.espCache[player], character, player)
            else if espInstance.espCache[player] then espInstance:hideComponents(espInstance.espCache[player]) end end
        end
    end

    espInstance:updatePlotDrawings()

    if fc >= 300 then
        fc = 0
        for player, _ in pairs(toolCache) do
            if not player or not player.Parent then
                toolCache[player] = nil
                lastUpdateTime[player] = nil
                visibilityCache[player] = nil
                visibilityCacheTime[player] = nil
            end
        end
    end
end)

Window:Notify({Title = "Jade.xyz v17.0", Description = "by niokaqwe & cursed.child.", Duration = 5})

end)
