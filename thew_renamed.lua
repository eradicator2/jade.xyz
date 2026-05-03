local base64Decode = function(data)
    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", "")
    return (data:gsub(".", function(char)
        if char == "=" then return "" end
        local decoded, idx = "", b64chars:find(char) - 1
        for i = 6, 1, -1 do
            decoded = decoded .. (idx % 2 ^ i - idx % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return decoded
    end)):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(byte)
        if #byte ~= 8 then return "" end
        local value = 0
        for i = 1, 8 do
            value = value + (byte:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(value)
    end)
end

local watermarkData = base64Decode("eyJ1IjoiZjdjNjYzMTktMTViZC00YTdmLWFhOTAtYWNjMzc2MGQ2NGRjIiwidCI6IjI4Y2U4OWIxLTRlYjMtNDg0MS05NThlLWM1NzUwNWU5MGRkNCIsInMiOiJlYjY5YTlhMC03ZDYzLTRlN2UtYjJjNy1iMTA0NzYwMjgyYWYiLCJrIjoiOGI3ZWQ1YjktYTBkNi00YTQ4LWI5ZTQtODgxOTk4ODEyMDFhIiwidiI6IjEuMC4wIn0=")
if not watermarkData or watermarkData == "" then
    error("Watermark validation failed")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StatsService = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local WorldToViewport = Camera.WorldToViewportPoint

local floor = math.floor
local clamp = math.clamp
local sin = math.sin
local sqrt = math.sqrt
local Color3FromRGB = Color3.fromRGB
local Color3FromHSV = Color3.fromHSV
local Vector3New = Vector3.new
local Vector2New = Vector2.new
local CFrameNew = CFrame.new
local InstanceNew = Instance.new

local function makeDraggable(guiObject)
    local dragging, startInputPos, startGuiPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInputPos = input.Position
            startGuiPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - startInputPos
                guiObject.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X, startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
            end
        end
    end)
    guiObject.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local splashScreen = InstanceNew("ScreenGui")
splashScreen.Name = "JadeInj"
splashScreen.Parent = CoreGui
splashScreen.IgnoreGuiInset = true
splashScreen.DisplayOrder = 999999999

local blurEffect = InstanceNew("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = Lighting
TweenService:Create(blurEffect, TweenInfo.new(1), { Size = 25 }):Play()

local splashBackground = InstanceNew("Frame")
splashBackground.Size = UDim2.new(1, 0, 1, 0)
splashBackground.BackgroundColor3 = Color3FromRGB(8, 8, 10)
splashBackground.BackgroundTransparency = 1
splashBackground.BorderSizePixel = 0
splashBackground.Parent = splashScreen

local splashPattern = InstanceNew("ImageLabel")
splashPattern.Size = UDim2.new(1, 0, 1, 0)
splashPattern.BackgroundTransparency = 1
splashPattern.Image = "rbxassetid://12521191590"
splashPattern.ImageTransparency = 1
splashPattern.ImageColor3 = Color3FromRGB(50, 50, 55)
splashPattern.ScaleType = Enum.ScaleType.Tile
splashPattern.TileSize = UDim2.new(0, 40, 0, 40)
splashPattern.Parent = splashBackground

local splashContent = InstanceNew("Frame")
splashContent.Size = UDim2.new(0, 400, 0, 150)
splashContent.Position = UDim2.new(0.5, -200, 0.5, -75)
splashContent.BackgroundTransparency = 1
splashContent.Parent = splashBackground

local splashTitle = InstanceNew("TextLabel")
splashTitle.Text = "Jade.xyz Stable"
splashTitle.Font = Enum.Font.GothamBold
splashTitle.TextSize = 36
splashTitle.TextColor3 = Color3FromRGB(255, 255, 255)
splashTitle.Size = UDim2.new(1, 0, 0, 40)
splashTitle.Position = UDim2.new(0, 0, 0.2, 0)
splashTitle.BackgroundTransparency = 1
splashTitle.TextTransparency = 1
splashTitle.Parent = splashContent

local splashProgressBar = InstanceNew("Frame")
splashProgressBar.Size = UDim2.new(0, 0, 0, 2)
splashProgressBar.Position = UDim2.new(0.5, 0, 0.6, 0)
splashProgressBar.BackgroundColor3 = Color3FromRGB(50, 255, 100)
splashProgressBar.BorderSizePixel = 0
splashProgressBar.Parent = splashContent

local splashStatus = InstanceNew("TextLabel")
splashStatus.Text = ""
splashStatus.Font = Enum.Font.Code
splashStatus.TextSize = 13
splashStatus.TextColor3 = Color3FromRGB(120, 120, 130)
splashStatus.Size = UDim2.new(1, 0, 0, 20)
splashStatus.Position = UDim2.new(0, 0, 0.7, 0)
splashStatus.BackgroundTransparency = 1
splashStatus.TextTransparency = 1
splashStatus.Parent = splashContent

TweenService:Create(splashBackground, TweenInfo.new(1), { BackgroundTransparency = 0.1 }):Play()
TweenService:Create(splashPattern, TweenInfo.new(1), { ImageTransparency = 0.9 }):Play()
task.wait(0.5)
TweenService:Create(splashTitle, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
TweenService:Create(splashStatus, TweenInfo.new(1), { TextTransparency = 0 }):Play()
TweenService:Create(splashProgressBar, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 250, 0, 2), Position = UDim2.new(0.5, -125, 0.6, 0) }):Play()

local Fluent, SaveManager, InterfaceManager

task.spawn(function()
    Fluent = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
    SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
    InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
end)

local function typewriteText(text)
    splashStatus.Text = ""
    for i = 1, #text do
        splashStatus.Text = string.sub(text, 1, i)
        task.wait(0.02)
    end
end

task.wait(1)
typewriteText("> establishing connection...")
task.wait(0.5)
typewriteText("> fetching required modules...")
task.wait(0.8)
repeat task.wait(0.1) until Fluent and SaveManager and InterfaceManager
typewriteText("> successfully initialized.")
TweenService:Create(splashProgressBar, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundColor3 = Color3FromRGB(20, 255, 150) }):Play()
task.wait(0.8)
TweenService:Create(blurEffect, TweenInfo.new(1), { Size = 0 }):Play()
TweenService:Create(splashBackground, TweenInfo.new(1), { BackgroundTransparency = 1 }):Play()
TweenService:Create(splashPattern, TweenInfo.new(1), { ImageTransparency = 1 }):Play()
TweenService:Create(splashTitle, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
TweenService:Create(splashStatus, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
TweenService:Create(splashProgressBar, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
task.wait(1)
blurEffect:Destroy()
splashScreen:Destroy()

local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

local WatermarkSettings = {
    enabled = true,
    showName = true,
    showFps = true,
    showPing = true,
    showPlayerCount = true
}

local HitTracerSettings = {
    tracerEnabled = false,
    tracerColor = Color3FromRGB(255, 255, 255),
    tracerThickness = 0.05,
    tracerDuration = 0.5,
    tracerPulse = false,
    tracerPulseSpeed = 10,
    hitMarkerEnabled = true,
    armsChamsEnabled = false,
    armsChamsMaterial = "ForceField",
    armsChamsColor = Color3FromRGB(255, 255, 255),
    armsChamsTransparency = 0
}

local watermarkGui = InstanceNew("ScreenGui")
watermarkGui.Name = "JadeWM"
watermarkGui.ResetOnSpawn = false
watermarkGui.IgnoreGuiInset = true
watermarkGui.DisplayOrder = 9999999
pcall(function() watermarkGui.Parent = CoreGui end)
if not watermarkGui.Parent then watermarkGui.Parent = PlayerGui end

local watermarkFrame = InstanceNew("Frame")
watermarkFrame.Size = UDim2.new(0, 240, 0, 25)
watermarkFrame.Position = UDim2.new(1, -380, 0, 20)
watermarkFrame.BackgroundColor3 = Color3FromRGB(15, 15, 15)
watermarkFrame.BackgroundTransparency = 0.1
watermarkFrame.BorderSizePixel = 1
watermarkFrame.BorderColor3 = Color3FromRGB(40, 40, 40)
watermarkFrame.Active = true
watermarkFrame.Parent = watermarkGui
makeDraggable(watermarkFrame)

local watermarkBar = InstanceNew("Frame")
watermarkBar.Size = UDim2.new(1, 0, 0, 2)
watermarkBar.Position = UDim2.new(0, 0, 0, 0)
watermarkBar.BackgroundColor3 = Color3FromRGB(50, 255, 100)
watermarkBar.BorderSizePixel = 0
watermarkBar.Parent = watermarkFrame

local watermarkText = InstanceNew("TextLabel")
watermarkText.Size = UDim2.new(1, 0, 1, 0)
watermarkText.Position = UDim2.new(0, 0, 0, 0)
watermarkText.BackgroundTransparency = 1
watermarkText.RichText = true
watermarkText.TextXAlignment = Enum.TextXAlignment.Center
watermarkText.Font = Enum.Font.Code
watermarkText.TextSize = 13
watermarkText.Parent = watermarkFrame

local fpsCounter = 0
local fpsTime = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fpsCounter += 1
    fpsTime += deltaTime
    if fpsTime >= 1 then
        if WatermarkSettings.enabled then
            local fps = floor(fpsCounter / fpsTime)
            local ping = tostring(floor(tonumber(string.split(StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1]) or 0))
            local displayText = "<font color='#32ff64'>Jade.xyz Stable</font>"
            local width = 110
            if WatermarkSettings.showName then
                displayText ..= string.format(" <font color='#ffffff'>| %s</font>", LocalPlayer.Name)
                width += #LocalPlayer.Name * 7 + 15
            end
            if WatermarkSettings.showFps then
                displayText ..= string.format(" <font color='#ffffff'>| fps: </font><font color='%s'>%d</font>", fps >= 60 and "#32ff64" or "#ff3232", fps)
                width += 65
            end
            if WatermarkSettings.showPing then
                displayText ..= string.format(" <font color='#ffffff'>| ping: %s</font>", ping)
                width += 75
            end
            if WatermarkSettings.showPlayerCount then
                displayText ..= string.format(" <font color='#ffffff'>| plrs: %d</font>", #Players:GetPlayers())
                width += 90
            end
            watermarkText.Text = displayText
            TweenService:Create(watermarkFrame, TweenInfo.new(0.2), { Size = UDim2.new(0, width, 0, 25) }):Play()
        end
        fpsCounter = 0
        fpsTime = 0
    end
end)

local keybindsFrame = InstanceNew("Frame")
keybindsFrame.Size = UDim2.new(0, 200, 0, 25)
keybindsFrame.Position = UDim2.new(1, -230, 0, 55)
keybindsFrame.BackgroundColor3 = Color3FromRGB(15, 15, 15)
keybindsFrame.BackgroundTransparency = 0.1
keybindsFrame.BorderSizePixel = 1
keybindsFrame.BorderColor3 = Color3FromRGB(40, 40, 40)
keybindsFrame.Active = true
keybindsFrame.ClipsDescendants = true
keybindsFrame.Parent = watermarkGui
makeDraggable(keybindsFrame)

local keybindsBar = InstanceNew("Frame")
keybindsBar.Size = UDim2.new(1, 0, 0, 2)
keybindsBar.Position = UDim2.new(0, 0, 0, 0)
keybindsBar.BackgroundColor3 = Color3FromRGB(50, 255, 100)
keybindsBar.BorderSizePixel = 0
keybindsBar.Parent = keybindsFrame

local keybindsTitle = InstanceNew("TextLabel")
keybindsTitle.Size = UDim2.new(1, 0, 0, 20)
keybindsTitle.Position = UDim2.new(0, 0, 0, 5)
keybindsTitle.BackgroundTransparency = 1
keybindsTitle.Text = "<font color='#32ff64'>Keybinds</font>"
keybindsTitle.RichText = true
keybindsTitle.TextXAlignment = Enum.TextXAlignment.Center
keybindsTitle.Font = Enum.Font.Code
keybindsTitle.TextSize = 13
keybindsTitle.Parent = keybindsFrame

local keybindsList = InstanceNew("Frame")
keybindsList.Size = UDim2.new(1, 0, 1, -25)
keybindsList.Position = UDim2.new(0, 0, 0, 25)
keybindsList.BackgroundTransparency = 1
keybindsList.Parent = keybindsFrame

local keybindsLayout = InstanceNew("UIListLayout", keybindsList)
keybindsLayout.SortOrder = Enum.SortOrder.LayoutOrder
keybindsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
keybindsLayout.Padding = UDim.new(0, 2)

local function createHitMarker(position)
    local part = InstanceNew("Part")
    part.Size = Vector3New(0.1, 0.1, 0.1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Parent = Camera
    local billboard = InstanceNew("BillboardGui")
    billboard.Size = UDim2.new(0, 30, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.Parent = part
    local line1 = InstanceNew("Frame", billboard)
    line1.Size = UDim2.new(1, 0, 0, 2)
    line1.Position = UDim2.new(0, 0, 0.5, -1)
    line1.BackgroundColor3 = Color3FromRGB(255, 255, 255)
    line1.Rotation = 45
    local line2 = InstanceNew("Frame", billboard)
    line2.Size = UDim2.new(1, 0, 0, 2)
    line2.Position = UDim2.new(0, 0, 0.5, -1)
    line2.BackgroundColor3 = Color3FromRGB(255, 255, 255)
    line2.Rotation = -45
    task.spawn(function()
        local tween1 = TweenService:Create(line1, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
        TweenService:Create(line2, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
        tween1:Play()
        tween1.Completed:Wait()
        part:Destroy()
    end)
end

local function createTracer(startPos, endPos, color)
    local distance = (startPos - endPos).Magnitude
    local tracerPart = InstanceNew("Part")
    tracerPart.Name = "JdTr"
    tracerPart.Anchored = true
    tracerPart.CanCollide = false
    tracerPart.Material = Enum.Material.Neon
    tracerPart.Color = color
    tracerPart.Transparency = 0.1
    tracerPart.Size = Vector3New(HitTracerSettings.tracerThickness, HitTracerSettings.tracerThickness, distance)
    tracerPart.CFrame = CFrame.lookAt(startPos, endPos) * CFrameNew(0, 0, -distance / 2)
    tracerPart.Parent = Camera
    if HitTracerSettings.tracerPulse then
        local startTick = tick()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not tracerPart.Parent then
                connection:Disconnect()
                return
            end
            tracerPart.Transparency = 0.1 + math.abs(sin((tick() - startTick) * HitTracerSettings.tracerPulseSpeed)) * 0.7
        end)
    end
    TweenService:Create(tracerPart, TweenInfo.new(HitTracerSettings.tracerDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = 1, Size = Vector3New(0, 0, distance) }):Play()
    game.Debris:AddItem(tracerPart, HitTracerSettings.tracerDuration + 0.1)
end

local function applyLowGraphics()
    Lighting.GlobalShadows = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end

local HitSoundSettings = {
    enabled = false,
    type = "Default",
    customId = "",
    currentSoundId = "rbxassetid://7269900245"
}

local function updateHitSound()
    if HitSoundSettings.type == "Default" then
        HitSoundSettings.currentSoundId = "rbxassetid://7269900245"
    elseif HitSoundSettings.type == "Neverlose" then
        HitSoundSettings.currentSoundId = "rbxassetid://6534948092"
    elseif HitSoundSettings.type == "Fatality" then
        HitSoundSettings.currentSoundId = "rbxassetid://6534947869"
    elseif HitSoundSettings.type == "Skeet" then
        HitSoundSettings.currentSoundId = "rbxassetid://5633695679"
    elseif HitSoundSettings.type == "UwU" then
        HitSoundSettings.currentSoundId = "rbxassetid://120904325097533"
    elseif HitSoundSettings.type == "Custom" then
        HitSoundSettings.currentSoundId = HitSoundSettings.customId:match("^%d+$") and "rbxassetid://" .. HitSoundSettings.customId or HitSoundSettings.customId
    end
end

local lastHitSoundTime = 0
local function playHitSound()
    if HitSoundSettings.enabled and HitSoundSettings.currentSoundId ~= "" and tick() - lastHitSoundTime > 0.05 then
        lastHitSoundTime = tick()
        local sound = InstanceNew("Sound")
        sound.SoundId = HitSoundSettings.currentSoundId
        sound.Volume = 4
        sound.Parent = SoundService
        sound.PlayOnRemove = true
        sound:Destroy()
    end
end

local Events = {}
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if not checkcaller() and typeof(self) == "Instance" then
        task.spawn(function()
            pcall(function()
                local lowerMethod = type(method) == "string" and string.lower(method) or ""
                if lowerMethod == "fireserver" then
                    local remoteName = tostring(self.Name)
                    if remoteName == "Hit" and type(args[1]) == "table" then
                        local hitPosition = args[1].Position or args[1].pos or args[1].p or args[1].d
                        local hitInstance = args[1].inst or args[1].Part or args[1].part or args[1].Hit
                        if hitInstance and typeof(hitInstance) == "Instance" then
                            local model = hitInstance:FindFirstAncestorOfClass("Model")
                            if model then
                                local player = Players:GetPlayerFromCharacter(model)
                                if player and player ~= LocalPlayer then
                                    table.insert(Events, { type = "Hit", isHit = true, pos = hitPosition })
                                end
                            end
                        end
                    elseif remoteName == "Fire" and type(args[1]) == "table" and HitTracerSettings.tracerEnabled then
                        for _, v in pairs(args[1]) do
                            if type(v) == "table" and typeof(v[1]) == "Vector3" and typeof(v[2]) == "Vector3" then
                                table.insert(Events, { type = "Tracer", start = v[1], finish = v[1] + v[2].Unit * 500 })
                            end
                        end
                    end
                end
            end)
        end)
    end
    return oldNamecall(self, ...)
end)

local WorldVisualSettings = {
    customSky = false,
    skyTheme = nil,
    trailEnabled = false,
    trailColor = Color3FromRGB(20, 255, 150)
}

local originalLighting = { Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient }

local function applySkySettings()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
            v:Destroy()
        end
    end
    local terrain = workspace:FindFirstChild("Terrain")
    if terrain then
        for _, v in ipairs(terrain:GetChildren()) do
            if v:IsA("Clouds") or v:IsA("Atmosphere") or v:IsA("Sky") then
                v:Destroy()
            end
        end
    end
    if WorldVisualSettings.customSky and WorldVisualSettings.skyTheme and WorldVisualSettings.skyTheme ~= "None" then
        local sky = InstanceNew("Sky")
        sky.Name = "CustSky"
        local skyboxes = {
            Sunset = { Bk = "141750058", Dn = "141750106", Ft = "141750069", Lf = "141750080", Rt = "141750091", Up = "141750117" },
            ["Purple Night"] = { Bk = "159454286", Dn = "159454296", Ft = "159454273", Lf = "159454281", Rt = "159454300", Up = "159454288" },
            ["Clear Day"] = { Bk = "148825633", Dn = "148825656", Ft = "148825642", Lf = "148825652", Rt = "148825659", Up = "148825661" },
            Galaxy = { Bk = "153624898", Dn = "153624915", Ft = "153624908", Lf = "153624921", Rt = "153624929", Up = "153624933" }
        }
        local chosen = skyboxes[WorldVisualSettings.skyTheme]
        if chosen then
            sky.SkyboxBk = "rbxassetid://" .. chosen.Bk
            sky.SkyboxDn = "rbxassetid://" .. chosen.Dn
            sky.SkyboxFt = "rbxassetid://" .. chosen.Ft
            sky.SkyboxLf = "rbxassetid://" .. chosen.Lf
            sky.SkyboxRt = "rbxassetid://" .. chosen.Rt
            sky.SkyboxUp = "rbxassetid://" .. chosen.Up
            sky.CelestialBodiesShown = false
            sky.Parent = Lighting
        end
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
    end
end

local armesChamsCache = {}
local function getFirstPersonParts()
    local parts = {}
    local playersFolder = workspace:FindFirstChild("Players")
    if playersFolder and LocalPlayer then
        local localPlayerModel = playersFolder:FindFirstChild(LocalPlayer.Name)
        if localPlayerModel then
            local lookAt = localPlayerModel:FindFirstChild("LookAt")
            if lookAt then
                for _, v in pairs(lookAt:GetDescendants()) do
                    if (v:IsA("BasePart") or v:IsA("MeshPart")) and v.Name ~= "HumanoidRootPart" then
                        table.insert(parts, v)
                    end
                end
            end
        end
    end
    for _, v in pairs(Camera:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("MeshPart")) and v.Name ~= "HumanoidRootPart" then
            table.insert(parts, v)
        end
    end
    if PlayerGui then
        for _, v in pairs(PlayerGui:GetDescendants()) do
            if v:IsA("ViewportFrame") then
                for _, child in pairs(v:GetDescendants()) do
                    if child:IsA("BasePart") or child:IsA("MeshPart") then
                        table.insert(parts, child)
                    end
                end
            end
        end
    end
    return parts
end

local Window = Fluent:CreateWindow({
    Title = "Jade.xyz Stable",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2New(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

local Tabs = {
    WatermarkTab = Window:CreateTab({ Title = "Watermark", Icon = "monitor" }),
    CombatTab = Window:CreateTab({ Title = "Combat", Icon = "crosshair" }),
    ESPTab = Window:CreateTab({ Title = "ESP", Icon = "eye" }),
    VisualsTab = Window:CreateTab({ Title = "Visuals", Icon = "eye" }),
    ColorsTab = Window:CreateTab({ Title = "Colors", Icon = "palette" }),
    WorldTab = Window:CreateTab({ Title = "World", Icon = "globe" }),
    FPSBoostTab = Window:CreateTab({ Title = "FPS Boost", Icon = "gauge" }),
    SettingsTab = Window:CreateTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local connections = {}
local unloading = false

local visibleCache = {}
local visibleCacheTime = {}

local EspSettings = {
    enabled = false,
    box = false,
    tracers = false,
    name = false,
    distance = false,
    items = false,
    hpBar = false,
    skeleton = false,
    chams = false,
    chamsStyle = "Solid",
    rainbowChams = false,
    rainbowSpeed = 3,
    visibilityCheck = false,
    visibilityLabel = true,
    teamCheck = false,
    hpPercentageText = true,
    hpBasedColor = true,
    hpStaticColor = Color3FromRGB(0, 255, 0),
    maxDistance = 2000,
    skeletonMaxDistance = 500,
    nameSize = 14,
    distanceSize = 12,
    boxThickness = 2,
    tracerThickness = 1,
    chamsTransparency = 0.5,
    tracerOrigin = "Top",
    visibleBoxColor = Color3FromRGB(0, 255, 0),
    hiddenBoxColor = Color3FromRGB(255, 0, 0),
    visibleNameColor = Color3FromRGB(0, 255, 0),
    hiddenNameColor = Color3FromRGB(255, 0, 0),
    visibleTracerColor = Color3FromRGB(0, 255, 0),
    hiddenTracerColor = Color3FromRGB(255, 0, 0),
    visibleDistanceColor = Color3FromRGB(0, 255, 0),
    hiddenDistanceColor = Color3FromRGB(255, 0, 0),
    visibleItemColor = Color3FromRGB(0, 255, 0),
    hiddenItemColor = Color3FromRGB(255, 0, 0),
    visibleArrowColor = Color3FromRGB(0, 255, 0),
    hiddenArrowColor = Color3FromRGB(255, 0, 0),
    visibleChamsColor = Color3FromRGB(0, 255, 100),
    hiddenChamsColor = Color3FromRGB(255, 50, 50),
    boxColor = Color3FromRGB(255, 255, 255),
    nameColor = Color3FromRGB(255, 255, 255),
    distanceColor = Color3FromRGB(255, 255, 255),
    itemColor = Color3FromRGB(255, 255, 255),
    tracerColor = Color3FromRGB(255, 255, 255),
    skeletonColor = Color3FromRGB(255, 255, 255),
    chamsColor = Color3FromRGB(255, 100, 100)
}

local ArrowSettings = {
    enabled = false,
    distance = false,
    glow = true,
    style = "Classic",
    textSize = 13,
    color = Color3FromRGB(255, 0, 0),
    outlineColor = Color3FromRGB(0, 0, 0),
    shadowEnabled = true,
    shadowColor = Color3FromRGB(0, 0, 0),
    shadowTransparency = 0.5,
    glowColor = Color3FromRGB(255, 0, 0),
    glowTransparency = 0.3,
    glowThickness = 5,
    highlightEnabled = true,
    highlightColor = Color3FromRGB(255, 255, 255),
    highlightTransparency = 0.3,
    size = 15,
    radius = 150,
    outlineThickness = 2,
    transparency = 1,
    pulseSpeed = 4,
    pulseMin = 0.85,
    pulseMax = 1.15
}

local PlotEspSettings = {
    enabled = false,
    teamCheck = false,
    highlight = false,
    tracers = false,
    name = false,
    distance = false,
    highlightFillColor = Color3FromRGB(255, 255, 255),
    highlightOutlineColor = Color3FromRGB(0, 0, 0),
    highlightFillTransparency = 0.5,
    highlightOutlineTransparency = 0.3,
    tracerColor = Color3FromRGB(255, 255, 0),
    nameColor = Color3FromRGB(255, 255, 0),
    distanceColor = Color3FromRGB(255, 255, 0),
    tracerThickness = 1
}

local AirdropEspSettings = {
    enabled = false,
    highlight = false,
    tracers = false,
    name = false,
    distance = false,
    highlightFillColor = Color3FromRGB(0, 150, 255),
    highlightOutlineColor = Color3FromRGB(0, 0, 0),
    highlightFillTransparency = 0.5,
    highlightOutlineTransparency = 0.3,
    tracerColor = Color3FromRGB(0, 200, 255),
    nameColor = Color3FromRGB(0, 200, 255),
    distanceColor = Color3FromRGB(0, 200, 255),
    tracerThickness = 1
}

local LandmineEspSettings = {
    enabled = false,
    highlight = false,
    tracers = false,
    name = false,
    distance = false,
    highlightFillColor = Color3FromRGB(255, 0, 0),
    highlightOutlineColor = Color3FromRGB(0, 0, 0),
    highlightFillTransparency = 0.5,
    highlightOutlineTransparency = 0.3,
    tracerColor = Color3FromRGB(255, 50, 50),
    nameColor = Color3FromRGB(255, 50, 50),
    distanceColor = Color3FromRGB(255, 50, 50),
    tracerThickness = 1
}

local AimbotSettings = {
    aimbotEnabled = false,
    aimbotKey = "Right Click",
    aimbotSmoothing = 1,
    aimbotFov = 150,
    showFovCircle = false,
    targetPart = "Head",
    teamCheck = false,
    wallCheck = true,
    predictionEnabled = true,
    predictionType = "Velocity",
    velocityFactor = 0.12,
    staticFactor = 5,
    maxDistance = 1500,
    maxDistanceEnabled = false,
    priority = "Closest to Crosshair",
    stickyAim = false,
    triggerEnabled = false,
    triggerKey = "Use Keybind",
    triggerWallCheck = true,
    triggerTeamCheck = false,
    ignoreHp = 20,
    aimbotIgnoreHp = false,
    triggerIgnoreHp = false
}

local aimbotCircle = Drawing.new("Circle")
aimbotCircle.Color = Color3FromRGB(255, 255, 255)
aimbotCircle.Thickness = 1
aimbotCircle.Filled = false
aimbotCircle.Transparency = 0.5
aimbotCircle.Visible = false

local function isAimbotKeyDown()
    if AimbotSettings.aimbotKey == "Right Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif AimbotSettings.aimbotKey == "Left Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        local success, state = pcall(function() return Options.aimbotKeybind:GetState() end)
        return success and state or false
    end
end

local function isTriggerKeyDown()
    if AimbotSettings.triggerKey == "Right Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif AimbotSettings.triggerKey == "Left Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        local success, state = pcall(function() return Options.triggerKeybind:GetState() end)
        return success and state or false
    end
end

local currentTargetPart, currentTargetPlayer, aimbotDeltaX, aimbotDeltaY, triggerBotConnection, trailAttachment0, trailAttachment1, trailObject

local function getClosestTarget()
    local mouseLocation = UserInputService:GetMouseLocation()
    local mx, my = mouseLocation.X, mouseLocation.Y
    local potentialTargets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if character and humanoid and humanoid.Health > 0 then
                if AimbotSettings.aimbotIgnoreHp and humanoid.Health < AimbotSettings.ignoreHp then
                    continue
                end
                local targetPart = character:FindFirstChild(AimbotSettings.targetPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                if targetPart and targetPart.Position then
                    if AimbotSettings.teamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    local screenPos = WorldToViewport(Camera, targetPart.Position)
                    if screenPos.Z > 0 then
                        local visible = true
                        if AimbotSettings.wallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            rayParams.IgnoreWater = true
                            local filterList = { Character, character, Camera }
                            for _, model in ipairs({ Character, character }) do
                                for _, child in ipairs(model:GetChildren()) do
                                    if child:IsA("Accessory") or child:IsA("Tool") then
                                        table.insert(filterList, child)
                                    end
                                end
                            end
                            rayParams.FilterDescendantsInstances = filterList
                            visible = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams) ~= nil
                        end
                        if not visible then
                            local distToCrosshair = sqrt((screenPos.X - mx) ^ 2 + (screenPos.Y - my) ^ 2)
                            local distance3d = (targetPart.Position - Camera.CFrame.Position).Magnitude
                            if distToCrosshair <= AimbotSettings.aimbotFov and (not AimbotSettings.maxDistanceEnabled or distance3d <= AimbotSettings.maxDistance) then
                                table.insert(potentialTargets, {
                                    part = targetPart,
                                    player = player,
                                    distToCrosshair = distToCrosshair,
                                    distance3d = distance3d,
                                    hp = humanoid.Health
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    if #potentialTargets == 0 then return nil, nil end
    table.sort(potentialTargets, function(a, b)
        if AimbotSettings.priority == "Closest to Crosshair" then return a.distToCrosshair < b.distToCrosshair
        elseif AimbotSettings.priority == "Furthest to Crosshair" then return a.distToCrosshair > b.distToCrosshair
        elseif AimbotSettings.priority == "Lowest HP" then return a.hp < b.hp
        elseif AimbotSettings.priority == "Highest HP" then return a.hp > b.hp
        elseif AimbotSettings.priority == "Closest Distance" then return a.distance3d < b.distance3d
        elseif AimbotSettings.priority == "Furthest Distance" then return a.distance3d > b.distance3d
        else return a.distToCrosshair < b.distToCrosshair end
    end)
    return potentialTargets[1].part, potentialTargets[1].player
end

local function stopAimbot()
    if triggerBotConnection then
        triggerBotConnection:Disconnect()
        triggerBotConnection = nil
    end
    aimbotDeltaX = 0
    aimbotDeltaY = 0
end

local function startAimbot()
    if triggerBotConnection then return end
    aimbotDeltaX = 0
    aimbotDeltaY = 0
    triggerBotConnection = RunService.RenderStepped:Connect(function()
        if not AimbotSettings.aimbotEnabled or unloading then return end
        if isAimbotKeyDown() then
            local targetPart, targetPlayer = nil, nil
            if AimbotSettings.stickyAim and currentTargetPlayer then
                local character = currentTargetPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if character and humanoid and humanoid.Health > 0 and not (AimbotSettings.aimbotIgnoreHp and humanoid.Health < AimbotSettings.ignoreHp) then
                    targetPart = character:FindFirstChild(AimbotSettings.targetPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local screenPos = WorldToViewport(Camera, targetPart.Position)
                        local mousePos = UserInputService:GetMouseLocation()
                        if screenPos.Z <= 0 or sqrt((screenPos.X - mousePos.X) ^ 2 + (screenPos.Y - mousePos.Y) ^ 2) > AimbotSettings.aimbotFov * 1.5 then
                            targetPart = nil
                        end
                    end
                end
            end
            if not targetPart then
                targetPart, currentTargetPlayer = getClosestTarget()
            end
            if targetPart then
                local targetPos = targetPart.Position
                if AimbotSettings.predictionEnabled then
                    local rootPart = targetPart.Parent:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        if AimbotSettings.predictionType == "Velocity" then
                            local ping = tonumber(string.split(StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1]) or 50
                            targetPos = targetPos + (rootPart.AssemblyLinearVelocity or Vector3New()) * (AimbotSettings.velocityFactor + 0.025)
                        else
                            local velocity = rootPart.AssemblyLinearVelocity or Vector3New()
                        end
                    end
                end
                local success, screenPos = pcall(WorldToViewport, Camera, targetPos)
                if success and screenPos.Z > 0 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dx, dy = screenPos.X - mousePos.X, screenPos.Y - mousePos.Y
                    local smoothing = math.max(AimbotSettings.aimbotSmoothing, 0.01)
                    if smoothing < 1 then
                        mousemoverel(dx * smoothing, dy * smoothing)
                    else
                        if sqrt(dx * dx + dy * dy) > 0.5 then
                            aimbotDeltaX = aimbotDeltaX + dx / smoothing
                            aimbotDeltaY = aimbotDeltaY + dy / smoothing
                            local moveX = aimbotDeltaX >= 1 and floor(aimbotDeltaX) or aimbotDeltaX <= -1 and math.ceil(aimbotDeltaX) or 0
                            local moveY = aimbotDeltaY >= 1 and floor(aimbotDeltaY) or aimbotDeltaY <= -1 and math.ceil(aimbotDeltaY) or 0
                            aimbotDeltaX = aimbotDeltaX - moveX
                            aimbotDeltaY = aimbotDeltaY - moveY
                            if moveX ~= 0 or moveY ~= 0 then
                                mousemoverel(clamp(moveX, -150, 150), clamp(moveY, -150, 150))
                            end
                        end
                    end
                end
            end
        else
            aimbotDeltaX = 0
            aimbotDeltaY = 0
        end
    end)
end

local function toggleTriggerBot()
    if AimbotSettings.triggerEnabled then
        if not triggerBotConnection then
            triggerBotConnection = RunService.RenderStepped:Connect(function()
                if not AimbotSettings.triggerEnabled or unloading or not isTriggerKeyDown() then return end
                local targetCharacter = nil
                if AimbotSettings.triggerWallCheck then
                    local target = Mouse.Target
                    if target then
                        targetCharacter = target:FindFirstAncestorOfClass("Model")
                    end
                else
                    local characters = {}
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            table.insert(characters, player.Character)
                        end
                    end
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Include
                    rayParams.FilterDescendantsInstances = characters
                    local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
                    local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, rayParams)
                    if hit and hit.Instance then
                        targetCharacter = hit.Instance:FindFirstAncestorOfClass("Model")
                    end
                end
                if targetCharacter then
                    local humanoid = targetCharacter:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 and not (AimbotSettings.triggerIgnoreHp and humanoid.Health < AimbotSettings.ignoreHp) then
                        local player = Players:GetPlayerFromCharacter(targetCharacter)
                        if player and player ~= LocalPlayer and not (AimbotSettings.triggerTeamCheck and player.Team == LocalPlayer.Team) then
                            if mouse1click then mouse1click() end
                        end
                    end
                end
            end)
        end
    else
        if triggerBotConnection then
            triggerBotConnection:Disconnect()
            triggerBotConnection = nil
        end
    end
end

local function updateTrail()
    if WorldVisualSettings.trailEnabled then
        local root = Character and Character:FindFirstChild("HumanoidRootPart")
        if root then
            if not trailObject then
                trailAttachment0 = InstanceNew("Attachment", root)
                trailAttachment1 = InstanceNew("Attachment", root)
                trailAttachment0.Position = Vector3New(0, 1, 0)
                trailAttachment1.Position = Vector3New(0, -1, 0)
                trailObject = InstanceNew("Trail", root)
                trailObject.Attachment0 = trailAttachment0
                trailObject.Attachment1 = trailAttachment1
                trailObject.Lifetime = 0.5
                trailObject.MinLength = 0.1
                trailObject.Color = ColorSequence.new(WorldVisualSettings.trailColor)
                trailObject.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) })
                trailObject.LightEmission = 1
            else
                trailObject.Color = ColorSequence.new(WorldVisualSettings.trailColor)
            end
        end
    else
        if trailObject then trailObject:Destroy() trailObject = nil end
        if trailAttachment0 then trailAttachment0:Destroy() trailAttachment0 = nil end
        if trailAttachment1 then trailAttachment1:Destroy() trailAttachment1 = nil end
    end
end

local EspManager = {}
EspManager.__index = EspManager

function EspManager.new()
    return setmetatable({
        playerDrawings = {},
        plotDrawings = {},
        plotHighlights = {},
        airdropDrawings = {},
        airdropHighlights = {},
        landmineDrawings = {},
        landmineHighlights = {}
    }, EspManager)
end

function EspManager:createDrawing(drawingType, properties)
    local drawing = Drawing.new(drawingType)
    for key, value in pairs(properties) do
        drawing[key] = value
    end
    return drawing
end

function EspManager:getTracerStart()
    local viewSize = Camera.ViewportSize
    if EspSettings.tracerOrigin == "Top" then
        return Vector2New(viewSize.X / 2, 0)
    elseif EspSettings.tracerOrigin == "Bottom" then
        return Vector2New(viewSize.X / 2, viewSize.Y)
    elseif EspSettings.tracerOrigin == "Center" then
        return Vector2New(viewSize.X / 2, viewSize.Y / 2)
    elseif EspSettings.tracerOrigin == "Mouse" then
        local mousePos = UserInputService:GetMouseLocation()
        return Vector2New(mousePos.X, mousePos.Y)
    end
    return Vector2New(viewSize.X / 2, 0)
end

local function getVisibilityBasedColor(visible, visibleColor, hiddenColor)
    if not EspSettings.visibilityCheck then return visibleColor end
    return visible and visibleColor or hiddenColor
end

local function getPlayerTool(player)
    local now = tick()
    if playerToolsCache[player] and now - (playerToolTimes[player] or 0) < 0.5 then
        return playerToolsCache[player]
    end
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    playerToolsCache[player] = tool
    playerToolTimes[player] = now
    return tool
end

local function getObjectPosition(obj)
    if obj:IsA("Model") then
        local primary = obj.PrimaryPart or obj:FindFirstChild("Root") or obj:FindFirstChild("Base") or obj:FindFirstChild("Main")
        if primary and primary:IsA("BasePart") then return primary.Position end
        local success, bbox = pcall(function() return obj:GetBoundingBox() end)
        if success and bbox then return bbox.Position end
    elseif obj:IsA("BasePart") then
        return obj.Position
    end
    return nil
end

local function setHighlight(model, settings, espConfig)
    local highlight = model:FindFirstChild("EH")
    if not highlight then
        highlight = InstanceNew("Highlight")
        highlight.Name = "EH"
        highlight.Parent = model
    end
    highlight.FillColor = espConfig.highlightFillColor
    highlight.FillTransparency = espConfig.highlightFillTransparency
    highlight.OutlineColor = espConfig.highlightOutlineColor
    highlight.OutlineTransparency = espConfig.highlightOutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function removeHighlight(model)
    local highlight = model:FindFirstChild("EH")
    if highlight then highlight:Destroy() end
end

local function isSameTeamPlot(plot)
    if not PlotEspSettings.teamCheck then return true end
    local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player")
    if owner and owner.Value then
        local ownerName = type(owner.Value) == "string" and owner.Value or owner.Value.Name
        local ownerPlayer = Players:FindFirstChild(ownerName)
        if ownerPlayer and ownerPlayer.Team == LocalPlayer.Team then return false end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(plot.Name:lower(), player.Name:lower()) and player.Team == LocalPlayer.Team then
            return false
        end
    end
    return true
end

function EspManager:createPlayerDrawings()
    local highlight = InstanceNew("Highlight")
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    pcall(function() highlight.Parent = CoreGui end)
    if not highlight.Parent then highlight.Parent = workspace end
    return {
        box = self:createDrawing("Square", { Thickness = EspSettings.boxThickness, Transparency = 1, Color = EspSettings.boxColor, Filled = false }),
        tracer = self:createDrawing("Line", { Thickness = EspSettings.tracerThickness, Transparency = 1, Color = EspSettings.tracerColor }),
        distanceText = self:createDrawing("Text", { Size = 16, Center = true, Outline = true, Color = EspSettings.distanceColor, OutlineColor = Color3FromRGB(0, 0, 0) }),
        nameText = self:createDrawing("Text", { Size = 18, Center = true, Outline = true, Color = EspSettings.nameColor, OutlineColor = Color3FromRGB(0, 0, 0) }),
        hpBar = {
            background = self:createDrawing("Square", { Thickness = 1, Transparency = 1, Color = Color3FromRGB(0, 0, 0), Filled = false }),
            fill = self:createDrawing("Square", { Thickness = 1, Transparency = 1, Color = Color3FromRGB(0, 255, 0), Filled = true }),
            text = self:createDrawing("Text", { Size = 12, Center = true, Outline = true, Color = Color3FromRGB(255, 255, 255), OutlineColor = Color3FromRGB(0, 0, 0) })
        },
        itemText = self:createDrawing("Text", { Size = 14, Center = true, Outline = true, Color = EspSettings.itemColor, OutlineColor = Color3FromRGB(0, 0, 0) }),
        visibilityText = self:createDrawing("Text", { Size = 13, Center = true, Outline = true, Color = Color3FromRGB(0, 255, 0), OutlineColor = Color3FromRGB(0, 0, 0), Visible = false }),
        arrowShadow = self:createDrawing("Triangle", { Thickness = 1, Color = ArrowSettings.shadowColor, Filled = true, Visible = false, Transparency = 0.4 }),
        arrowGlow = self:createDrawing("Triangle", { Thickness = 5, Color = ArrowSettings.glowColor, Filled = false, Visible = false, Transparency = 0.2 }),
        arrowFill = self:createDrawing("Triangle", { Thickness = 1, Color = ArrowSettings.color, Filled = true, Visible = false }),
        arrowOutline = self:createDrawing("Triangle", { Thickness = 2, Color = ArrowSettings.outlineColor, Filled = false, Visible = false }),
        arrowHighlight = self:createDrawing("Triangle", { Thickness = 1, Color = ArrowSettings.highlightColor, Filled = true, Visible = false, Transparency = 0.25 }),
        arrowDistance = self:createDrawing("Text", { Size = ArrowSettings.textSize, Center = true, Outline = true, Color = Color3FromRGB(255, 255, 255), OutlineColor = Color3FromRGB(0, 0, 0), Visible = false }),
        skeletonLines = {},
        highlight = highlight,
        active = true,
        lastDistance = 0,
        lastHpPercent = -1,
        lastToolName = ""
    }
end

local skeletonConnections = {
    R15 = {
        { "Head", "UpperTorso" },
        { "UpperTorso", "LowerTorso" },
        { "LowerTorso", "LeftUpperLeg" },
        { "LowerTorso", "RightUpperLeg" },
        { "LeftUpperLeg", "LeftLowerLeg" },
        { "LeftLowerLeg", "LeftFoot" },
        { "RightUpperLeg", "RightLowerLeg" },
        { "RightLowerLeg", "RightFoot" },
        { "UpperTorso", "LeftUpperArm" },
        { "UpperTorso", "RightUpperArm" },
        { "LeftUpperArm", "LeftLowerArm" },
        { "LeftLowerArm", "LeftHand" },
        { "RightUpperArm", "RightLowerArm" },
        { "RightLowerArm", "RightHand" }
    },
    R6 = {
        { "Head", "Torso" },
        { "Torso", "Left Arm" },
        { "Torso", "Right Arm" },
        { "Torso", "Left Leg" },
        { "Torso", "Right Leg" }
    }
}

function EspManager:drawArrows(drawing, rootPart, distance)
    local camPos = Camera.CFrame.Position
    local lookVector = Camera.CFrame.LookVector
    local directionToTarget = (rootPart.Position - camPos).Unit
    local behindCamera = lookVector:Dot(directionToTarget) < 0
    local screenCenter = Vector2New(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local targetScreenPos = WorldToViewport(Camera, rootPart.Position)
    local dx, dy
    if not behindCamera then
        dx, dy = targetScreenPos.X - screenCenter.X, targetScreenPos.Y - screenCenter.Y
    else
        local forwardPos = WorldToViewport(Camera, camPos + lookVector * 100)
        local targetForwardPos = WorldToViewport(Camera, camPos + directionToTarget * 100)
        dx, dy = targetForwardPos.X - forwardPos.X, targetForwardPos.Y - forwardPos.Y
    end
    local magnitude = sqrt(dx * dx + dy * dy)
    if magnitude < 0.001 then
        dx, dy = targetScreenPos.X - screenCenter.X, targetScreenPos.Y - screenCenter.Y
        magnitude = sqrt(dx * dx + dy * dy)
        if magnitude < 0.001 then return end
    end
    dx, dy = dx / magnitude, dy / magnitude
    if behindCamera then dx, dy = -dx, -dy end
    local direction = Vector2New(dx, dy)
    local time = tick()
    local pulseScale = ArrowSettings.glow and ArrowSettings.pulseMin + (ArrowSettings.pulseMax - ArrowSettings.pulseMin) * 0.5 * (1 + sin(time * ArrowSettings.pulseSpeed)) or 1
    local arrowTip = screenCenter + direction * ArrowSettings.radius
    local arrowSize = ArrowSettings.size * pulseScale
    local arrowBaseInset = arrowSize * 0.4
    local perp = Vector2New(-direction.Y, direction.X)
    local tip = (screenCenter + direction * ArrowSettings.radius) + direction * arrowSize
    local leftBase = (screenCenter + direction * ArrowSettings.radius) - direction * arrowBaseInset + perp * (arrowSize * 0.45)
    local rightBase = (screenCenter + direction * ArrowSettings.radius) - direction * arrowBaseInset - perp * (arrowSize * 0.45)
    if ArrowSettings.style == "Outline Only" then
        drawing.arrowFill.Visible = false
        drawing.arrowGlow.Visible = false
        drawing.arrowShadow.Visible = false
        drawing.arrowHighlight.Visible = false
        drawing.arrowOutline.PointA = tip
        drawing.arrowOutline.PointB = leftBase
        drawing.arrowOutline.PointC = rightBase
        drawing.arrowOutline.Color = ArrowSettings.outlineColor
        drawing.arrowOutline.Thickness = ArrowSettings.outlineThickness
        drawing.arrowOutline.Visible = true
    else
        if ArrowSettings.shadowEnabled then
            local shadowOffset = Vector2New(2, 2)
            drawing.arrowShadow.PointA = tip + shadowOffset
            drawing.arrowShadow.PointB = leftBase + shadowOffset
            drawing.arrowShadow.PointC = rightBase + shadowOffset
            drawing.arrowShadow.Transparency = ArrowSettings.shadowTransparency
            drawing.arrowShadow.Visible = true
        else
            drawing.arrowShadow.Visible = false
        end
        if ArrowSettings.glow then
            local glowTip = arrowTip + direction * (arrowSize * 1.3)
            local glowLeft = (arrowTip - direction * (arrowBaseInset * 1.2)) + perp * (arrowSize * 1.3 * 0.45)
            local glowRight = (arrowTip - direction * (arrowBaseInset * 1.2)) - perp * (arrowSize * 1.3 * 0.45)
            drawing.arrowGlow.PointA = glowTip
            drawing.arrowGlow.PointB = glowLeft
            drawing.arrowGlow.PointC = glowRight
            drawing.arrowGlow.Color = ArrowSettings.glowColor
            drawing.arrowGlow.Transparency = ArrowSettings.glowTransparency + 0.1 * sin(time * 6)
            drawing.arrowGlow.Thickness = ArrowSettings.glowThickness
            drawing.arrowGlow.Visible = true
        else
            drawing.arrowGlow.Visible = false
        end
        drawing.arrowFill.PointA = tip
        drawing.arrowFill.PointB = leftBase
        drawing.arrowFill.PointC = rightBase
        drawing.arrowFill.Color = ArrowSettings.color
        drawing.arrowFill.Transparency = ArrowSettings.transparency
        drawing.arrowFill.Visible = true
        drawing.arrowOutline.PointA = tip
        drawing.arrowOutline.PointB = leftBase
        drawing.arrowOutline.PointC = rightBase
        drawing.arrowOutline.Color = ArrowSettings.outlineColor
        drawing.arrowOutline.Thickness = ArrowSettings.outlineThickness
        drawing.arrowOutline.Visible = true
        if ArrowSettings.highlightEnabled then
            local highlightTip = arrowTip + direction * (arrowSize * 0.6)
            local highlightLeft = (arrowTip - direction * (arrowBaseInset * 0.5)) + perp * (arrowSize * 0.2)
            local highlightRight = (arrowTip - direction * (arrowBaseInset * 0.5)) - perp * (arrowSize * 0.2)
            drawing.arrowHighlight.PointA = highlightTip
            drawing.arrowHighlight.PointB = highlightLeft
            drawing.arrowHighlight.PointC = highlightRight
            drawing.arrowHighlight.Color = ArrowSettings.highlightColor
            drawing.arrowHighlight.Transparency = ArrowSettings.highlightTransparency
            drawing.arrowHighlight.Visible = true
        else
            drawing.arrowHighlight.Visible = false
        end
    end
    if ArrowSettings.distance then
        if drawing.lastDistance ~= distance then
            drawing.arrowDistance.Text = distance .. "m"
            drawing.lastDistance = distance
        end
        drawing.arrowDistance.Size = ArrowSettings.textSize
        drawing.arrowDistance.Position = arrowTip - direction * (arrowSize + 10)
        drawing.arrowDistance.Color = ArrowSettings.color
        drawing.arrowDistance.Visible = true
    else
        drawing.arrowDistance.Visible = false
    end
end

function EspManager:hideArrows(drawing)
    drawing.arrowShadow.Visible = false
    drawing.arrowGlow.Visible = false
    drawing.arrowFill.Visible = false
    drawing.arrowOutline.Visible = false
    drawing.arrowHighlight.Visible = false
    drawing.arrowDistance.Visible = false
end

function EspManager:updatePlayerEsp(drawing, character, player)
    if not drawing.active or (EspSettings.teamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
        self:hidePlayerEsp(drawing)
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid or not rootPart.Parent then
        self:hidePlayerEsp(drawing)
        return
    end
    local distance = 0
    if HumanoidRootPart and HumanoidRootPart.Parent then
        distance = floor((HumanoidRootPart.Position - rootPart.Position).Magnitude)
    end
    if distance > EspSettings.maxDistance then
        self:hidePlayerEsp(drawing)
        return
    end
    local screenPos, onScreen = WorldToViewport(Camera, rootPart.Position)
    local visible = (not EspSettings.visibilityCheck) or (visibleCache[player] ~= nil and (tick() - (visibleCacheTime[player] or 0) < 0.2 and visibleCache[player]) or (function()
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = { Character, character, Camera }
        rp.IgnoreWater = true
        local isVisible = workspace:Raycast(Camera.CFrame.Position, (character:FindFirstChild("Head") or rootPart).Position - Camera.CFrame.Position, rp) == nil
        visibleCache[player] = isVisible
        visibleCacheTime[player] = tick()
        return isVisible
    end)())
    local boxColor = getVisibilityBasedColor(visible, EspSettings.visibleBoxColor, EspSettings.hiddenBoxColor)
    local tracerColor = getVisibilityBasedColor(visible, EspSettings.visibleTracerColor, EspSettings.hiddenTracerColor)
    local nameColor = getVisibilityBasedColor(visible, EspSettings.visibleNameColor, EspSettings.hiddenNameColor)
    local distanceColor = getVisibilityBasedColor(visible, EspSettings.visibleDistanceColor, EspSettings.hiddenDistanceColor)
    local itemColor = getVisibilityBasedColor(visible, EspSettings.visibleItemColor, EspSettings.hiddenItemColor)
    local chamsColor = getVisibilityBasedColor(visible, EspSettings.visibleChamsColor, EspSettings.hiddenChamsColor)
    local skeletonColor = getVisibilityBasedColor(visible, EspSettings.visibleBoxColor, EspSettings.hiddenBoxColor)
    local isOnScreen = screenPos.Z > 0
    if EspSettings.enabled and isOnScreen then
        local head = character:FindFirstChild("Head")
        local topY, bottomY, leftX, rightX
        if head then
            local headScreenPos = WorldToViewport(Camera, head.Position + Vector3New(0, 0.5, 0))
            local bottomScreenPos = WorldToViewport(Camera, rootPart.Position - Vector3New(0, 3, 0))
            local height = math.abs(headScreenPos.Y - bottomScreenPos.Y)
            leftX = headScreenPos.X - height * 0.6 / 2
            rightX = headScreenPos.X + height * 0.6 / 2
            topY = math.min(headScreenPos.Y, bottomScreenPos.Y)
            bottomY = math.max(headScreenPos.Y, bottomScreenPos.Y)
        else
            leftX = screenPos.X - 15
            rightX = screenPos.X + 15
            topY = screenPos.Y - 25
            bottomY = screenPos.Y + 25
        end
        local boxWidth = math.max(rightX - leftX, 3)
        local boxHeight = math.max(bottomY - topY, 4)
        local boxPosX = leftX
        local boxPosY = topY
        local centerX = leftX + boxWidth / 2
        if EspSettings.box then
            drawing.box.Size = Vector2New(boxWidth, boxHeight)
            drawing.box.Position = Vector2New(boxPosX, boxPosY)
            drawing.box.Color = boxColor
            drawing.box.Thickness = EspSettings.boxThickness
            drawing.box.Visible = true
        else
            drawing.box.Visible = false
        end
        if EspSettings.tracers then
            drawing.tracer.From = self:getTracerStart()
            drawing.tracer.To = Vector2New(centerX, boxPosY + boxHeight)
            drawing.tracer.Color = tracerColor
            drawing.tracer.Thickness = EspSettings.tracerThickness
            drawing.tracer.Visible = true
        else
            drawing.tracer.Visible = false
        end
        if EspSettings.name then
            drawing.nameText.Text = player.Name
            drawing.nameText.Size = EspSettings.nameSize
            drawing.nameText.Position = Vector2New(centerX, boxPosY - 18)
            drawing.nameText.Color = nameColor
            drawing.nameText.Visible = true
        else
            drawing.nameText.Visible = false
        end
        local offsetY = 5
        if EspSettings.distance then
            if drawing.lastDistance ~= distance then
                drawing.distanceText.Text = distance .. "m"
                drawing.lastDistance = distance
            end
            drawing.distanceText.Size = EspSettings.distanceSize
            drawing.distanceText.Position = Vector2New(centerX, boxPosY + boxHeight + offsetY)
            drawing.distanceText.Color = distanceColor
            drawing.distanceText.Visible = true
            offsetY += 15
        else
            drawing.distanceText.Visible = false
        end
        if EspSettings.visibilityCheck and EspSettings.visibilityLabel then
            drawing.visibilityText.Text = visible and "[V]" or "[H]"
            drawing.visibilityText.Position = Vector2New(centerX, boxPosY + boxHeight + offsetY)
            drawing.visibilityText.Color = visible and Color3FromRGB(0, 255, 0) or Color3FromRGB(255, 0, 0)
            drawing.visibilityText.Visible = true
            offsetY += 15
        else
            drawing.visibilityText.Visible = false
        end
        local tool = getPlayerTool(player)
        if EspSettings.items and tool then
            local toolName = tool.Name == "Tool" and "Weapon" or tool.Name
            if drawing.lastToolName ~= toolName then
                drawing.itemText.Text = "[" .. toolName .. "]"
                drawing.lastToolName = toolName
            end
            drawing.itemText.Position = Vector2New(centerX, boxPosY + boxHeight + offsetY)
            drawing.itemText.Color = itemColor
            drawing.itemText.Visible = true
        else
            drawing.itemText.Visible = false
        end
        if EspSettings.box and EspSettings.hpBar then
            local hpPercent = humanoid.Health / humanoid.MaxHealth
            local hpColor = EspSettings.hpBasedColor and Color3FromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0) or EspSettings.hpStaticColor
            drawing.hpBar.background.Size = Vector2New(4, boxHeight)
            drawing.hpBar.background.Position = Vector2New(boxPosX - 7, boxPosY)
            drawing.hpBar.background.Visible = true
            drawing.hpBar.fill.Size = Vector2New(3, boxHeight * hpPercent)
            drawing.hpBar.fill.Position = Vector2New(boxPosX - 6.5, boxPosY + boxHeight * (1 - hpPercent))
            drawing.hpBar.fill.Color = hpColor
            drawing.hpBar.fill.Visible = true
            if EspSettings.hpPercentageText then
                local hpText = floor(hpPercent * 100)
                if drawing.lastHpPercent ~= hpText then
                    drawing.hpBar.text.Text = hpText .. "%"
                    drawing.lastHpPercent = hpText
                end
                drawing.hpBar.text.Position = Vector2New(boxPosX - 29, boxPosY + boxHeight / 2 - 8)
                drawing.hpBar.text.Color = hpColor
                drawing.hpBar.text.Visible = true
            else
                drawing.hpBar.text.Visible = false
            end
        else
            drawing.hpBar.background.Visible = false
            drawing.hpBar.fill.Visible = false
            drawing.hpBar.text.Visible = false
        end
        if EspSettings.skeleton and distance < EspSettings.skeletonMaxDistance then
            local rigType = humanoid.RigType.Name
            local bones = skeletonConnections[rigType] or {}
            for _, bonePair in ipairs(bones) do
                local partA = character:FindFirstChild(bonePair[1])
                local partB = character:FindFirstChild(bonePair[2])
                if partA and partB then
                    local key = bonePair[1] .. "-" .. bonePair[2]
                    local line = drawing.skeletonLines[key]
                    if not line then
                        line = self:createDrawing("Line", { Thickness = 1, Color = skeletonColor })
                        drawing.skeletonLines[key] = line
                    end
                    local screenA = WorldToViewport(Camera, partA.Position)
                    local screenB = WorldToViewport(Camera, partB.Position)
                    if screenA and screenB then
                        line.From = Vector2New(screenA.X, screenA.Y)
                        line.To = Vector2New(screenB.X, screenB.Y)
                        line.Color = skeletonColor
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                end
            end
        else
            for _, line in pairs(drawing.skeletonLines) do
                line.Visible = false
            end
        end
        if EspSettings.chams then
            local hue = (tick() % EspSettings.rainbowSpeed) / EspSettings.rainbowSpeed
            local chamsColorFinal = EspSettings.rainbowChams and Color3FromHSV(hue, 1, 1) or chamsColor
            if drawing.highlight.Adornee ~= character then
                drawing.highlight.Adornee = character
            end
            if drawing.highlight.FillColor ~= chamsColorFinal then
                drawing.highlight.FillColor = chamsColorFinal
            end
            if EspSettings.chamsStyle == "Solid" then
                drawing.highlight.FillTransparency = 0.6
                drawing.highlight.OutlineColor = chamsColorFinal
                drawing.highlight.OutlineTransparency = 1
            elseif EspSettings.chamsStyle == "Ghost" then
                drawing.highlight.FillTransparency = 0.1
                drawing.highlight.OutlineColor = Color3FromRGB(255, 255, 255)
                drawing.highlight.OutlineTransparency = 0.8
            elseif EspSettings.chamsStyle == "Outline Only" then
                drawing.highlight.FillTransparency = 1
                drawing.highlight.OutlineColor = chamsColorFinal
                drawing.highlight.OutlineTransparency = 0
            elseif EspSettings.chamsStyle == "Glow" then
                drawing.highlight.FillTransparency = 0.4 + 0.3 * sin(tick() * 5)
                drawing.highlight.OutlineColor = chamsColorFinal
                drawing.highlight.OutlineTransparency = 0.2
            elseif EspSettings.chamsStyle == "Pulsing Outline" then
                drawing.highlight.FillTransparency = 1
                drawing.highlight.OutlineColor = chamsColorFinal
                drawing.highlight.OutlineTransparency = 0.2 + 0.5 * math.abs(sin(tick() * 4))
            elseif EspSettings.chamsStyle == "Flashlight" then
                drawing.highlight.FillTransparency = 0.1
                drawing.highlight.OutlineColor = Color3FromRGB(255, 255, 255)
                drawing.highlight.OutlineTransparency = 0.1
            else
                drawing.highlight.FillTransparency = EspSettings.chamsTransparency
                drawing.highlight.OutlineColor = chamsColorFinal
                drawing.highlight.OutlineTransparency = EspSettings.chamsTransparency
            end
            if not drawing.highlight.Enabled then drawing.highlight.Enabled = true end
        else
            if drawing.highlight.Enabled then drawing.highlight.Enabled = false end
        end
        self:hideArrows(drawing)
    else
        self:hidePlayerEsp(drawing, true)
        if ArrowSettings.enabled and rootPart then
            local arrowColorBackup = ArrowSettings.color
            if EspSettings.visibilityCheck then
                ArrowSettings.color = visible and EspSettings.visibleArrowColor or EspSettings.hiddenArrowColor
            end
            self:drawArrows(drawing, rootPart, distance)
            ArrowSettings.color = arrowColorBackup
        else
            self:hideArrows(drawing)
        end
    end
end

function EspManager:hidePlayerEsp(drawing, hideHighlightsOnly)
    if not drawing then return end
    pcall(function()
        drawing.box.Visible = false
        drawing.tracer.Visible = false
        drawing.distanceText.Visible = false
        drawing.nameText.Visible = false
        drawing.hpBar.background.Visible = false
        drawing.hpBar.fill.Visible = false
        drawing.hpBar.text.Visible = false
        drawing.itemText.Visible = false
        drawing.visibilityText.Visible = false
        if drawing.highlight then
            drawing.highlight.Enabled = false
        end
        for _, line in pairs(drawing.skeletonLines) do
            line.Visible = false
        end
        if not hideHighlightsOnly then
            self:hideArrows(drawing)
        end
    end)
end

function EspManager:removePlayerEsp(player)
    local drawing = self.playerDrawings[player]
    if not drawing then return end
    drawing.active = false
    pcall(function()
        drawing.box:Remove()
        drawing.tracer:Remove()
        drawing.distanceText:Remove()
        drawing.nameText:Remove()
        drawing.hpBar.background:Remove()
        drawing.hpBar.fill:Remove()
        drawing.hpBar.text:Remove()
        drawing.itemText:Remove()
        drawing.visibilityText:Remove()
        drawing.arrowShadow:Remove()
        drawing.arrowGlow:Remove()
        drawing.arrowFill:Remove()
        drawing.arrowOutline:Remove()
        drawing.arrowHighlight:Remove()
        drawing.arrowDistance:Remove()
        if drawing.highlight then drawing.highlight:Destroy() end
        for _, line in pairs(drawing.skeletonLines) do
            line:Remove()
        end
    end)
    self.playerDrawings[player] = nil
end

function EspManager:getOrCreateObjectDrawing(storage, key, config)
    if storage[key] then return storage[key] end
    local drawing = {
        tracer = self:createDrawing("Line", { Thickness = config.tracerThickness, Transparency = 1, Color = config.tracerColor, Visible = false }),
        nameText = self:createDrawing("Text", { Size = 16, Center = true, Outline = true, Color = config.nameColor, OutlineColor = Color3FromRGB(0, 0, 0), Visible = false }),
        distanceText = self:createDrawing("Text", { Size = 14, Center = true, Outline = true, Color = config.distanceColor, OutlineColor = Color3FromRGB(0, 0, 0), Visible = false }),
        lastDistance = 0
    }
    storage[key] = drawing
    return drawing
end

function EspManager:updateObjectEsp(objects, drawings, highlights, config, getNameFunc, filterFunc)
    local visibleObjects = {}
    if not HumanoidRootPart then
        for _, drawing in pairs(drawings) do
            drawing.tracer.Visible = false
            drawing.nameText.Visible = false
            drawing.distanceText.Visible = false
        end
        return
    end
    for _, obj in ipairs(objects) do
        if filterFunc and not filterFunc(obj) then continue end
        visibleObjects[obj] = true
        local drawing = self:getOrCreateObjectDrawing(drawings, obj, config)
        if not config.enabled then
            drawing.tracer.Visible = false
            drawing.nameText.Visible = false
            drawing.distanceText.Visible = false
            removeHighlight(obj)
            highlights[obj] = nil
            continue
        end
        local position = getObjectPosition(obj)
        if not position then
            drawing.tracer.Visible = false
            drawing.nameText.Visible = false
            drawing.distanceText.Visible = false
            continue
        end
        local distance = floor((HumanoidRootPart.Position - position).Magnitude)
        if distance > EspSettings.maxDistance then
            drawing.tracer.Visible = false
            drawing.nameText.Visible = false
            drawing.distanceText.Visible = false
            removeHighlight(obj)
            highlights[obj] = nil
            continue
        end
        local screenPos, onScreen = WorldToViewport(Camera, position)
        if config.highlight then
            setHighlight(obj, highlights, config)
            highlights[obj] = true
        else
            removeHighlight(obj)
            highlights[obj] = nil
        end
        if onScreen and screenPos.Z > 0 then
            if config.tracers then
                drawing.tracer.From = self:getTracerStart()
                drawing.tracer.To = Vector2New(screenPos.X, screenPos.Y)
                drawing.tracer.Color = config.tracerColor
                drawing.tracer.Thickness = config.tracerThickness
                drawing.tracer.Visible = true
            else
                drawing.tracer.Visible = false
            end
            if config.name then
                drawing.nameText.Text = getNameFunc(obj)
                drawing.nameText.Position = Vector2New(screenPos.X, screenPos.Y - 25)
                drawing.nameText.Color = config.nameColor
                drawing.nameText.Visible = true
            else
                drawing.nameText.Visible = false
            end
            if config.distance then
                if drawing.lastDistance ~= distance then
                    drawing.distanceText.Text = distance .. "m"
                    drawing.lastDistance = distance
                end
                drawing.distanceText.Position = Vector2New(screenPos.X, screenPos.Y + 8)
                drawing.distanceText.Color = config.distanceColor
                drawing.distanceText.Visible = true
            else
                drawing.distanceText.Visible = false
            end
        else
            drawing.tracer.Visible = false
            drawing.nameText.Visible = false
            drawing.distanceText.Visible = false
        end
    end
    for obj, drawing in pairs(drawings) do
        if not visibleObjects[obj] then
            drawing.tracer:Remove()
            drawing.nameText:Remove()
            drawing.distanceText:Remove()
            drawings[obj] = nil
            removeHighlight(obj)
            highlights[obj] = nil
        end
    end
end

function EspManager:updatePlots()
    if not self.lastPlotUpdate or tick() - self.lastPlotUpdate > 1 then
        self.lastPlotUpdate = tick()
        self.currentPlots = {}
        local plotsFolder = workspace:FindFirstChild("Plots")
        if plotsFolder then
            for _, v in ipairs(plotsFolder:GetChildren()) do
                if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then
                    table.insert(self.currentPlots, v)
                end
            end
        end
    end
    self:updateObjectEsp(self.currentPlots or {}, self.plotDrawings, self.plotHighlights, PlotEspSettings, function(obj) return obj.Name end, function(obj) return isSameTeamPlot(obj) end)
end

function EspManager:updateAirdrops()
    local airdrops = {}
    for _, v in ipairs(workspace:GetChildren()) do
        local name = v.Name:lower()
        if string.find(name, "airdrop") and not string.find(name, "spawnarea") then
            if v:IsA("Model") or v:IsA("BasePart") then
                table.insert(airdrops, v)
            end
        end
    end
    self:updateObjectEsp(airdrops, self.airdropDrawings, self.airdropHighlights, AirdropEspSettings, function(obj) return obj.Name:lower() == "airdrop_2" and "Car Airdrop" or "Airdrop" end, nil)
end

function EspManager:updateLandmines()
    local mines = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Landmine" then
            table.insert(mines, v)
        end
    end
    self:updateObjectEsp(mines, self.landmineDrawings, self.landmineHighlights, LandmineEspSettings, function() return "Mine" end, nil)
end

function EspManager:removeAllObjectEsp()
    for obj, drawing in pairs(self.plotDrawings) do
        drawing.tracer:Remove()
        drawing.nameText:Remove()
        drawing.distanceText:Remove()
        removeHighlight(obj)
        self.plotDrawings[obj] = nil
        self.plotHighlights[obj] = nil
    end
    for obj, drawing in pairs(self.airdropDrawings) do
        drawing.tracer:Remove()
        drawing.nameText:Remove()
        drawing.distanceText:Remove()
        removeHighlight(obj)
        self.airdropDrawings[obj] = nil
        self.airdropHighlights[obj] = nil
    end
    for obj, drawing in pairs(self.landmineDrawings) do
        drawing.tracer:Remove()
        drawing.nameText:Remove()
        drawing.distanceText:Remove()
        removeHighlight(obj)
        self.landmineDrawings[obj] = nil
        self.landmineHighlights[obj] = nil
    end
end

local espManager = EspManager.new()
local playerToolsCache = {}
local playerToolTimes = {}

local renderConnection

local function fullCleanup()
    AimbotSettings.aimbotEnabled = false
    AimbotSettings.triggerEnabled = false
    stopAimbot()
    toggleTriggerBot()
    aimbotCircle.Visible = false
    pcall(function() aimbotCircle:Remove() end)
    EspSettings.enabled = false
    ArrowSettings.enabled = false
    PlotEspSettings.enabled = false
    AirdropEspSettings.enabled = false
    LandmineEspSettings.enabled = false
    WorldVisualSettings.customSky = false
    Lighting.Ambient = originalLighting.Ambient
    Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
    WorldVisualSettings.trailEnabled = false
    updateTrail()
    HitTracerSettings.armsChamsEnabled = false
    for part, data in pairs(armesChamsCache) do
        pcall(function()
            part.Material = data.originalMaterial
            part.Color = data.originalColor
            part.Transparency = data.originalTransparency
            if part:IsA("MeshPart") and data.originalTextureId then
                part.TextureID = data.originalTextureId
            end
            for _, texData in ipairs(data.textureData) do
                if texData.object:IsA("Texture") or texData.object:IsA("Decal") then
                    texData.object.Transparency = texData.originalTransparency
                elseif texData.object:IsA("SpecialMesh") then
                    texData.object.TextureId = texData.originalTextureId
                end
            end
        end)
    end
    applySkySettings()
    for player, drawing in pairs(espManager.playerDrawings) do
        espManager:removePlayerEsp(player)
    end
    espManager:removeAllObjectEsp()
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    if renderConnection then renderConnection:Disconnect() end
    pcall(function() watermarkGui:Destroy() end)
    Fluent:Destroy()
end

Tabs.WatermarkTab:CreateParagraph("WMInfo", { Title = "Watermark Settings", Content = "Customize the on-screen display." })
Tabs.WatermarkTab:CreateToggle("WMEn", { Title = "Enable Watermark", Default = true, Callback = function(val) WatermarkSettings.enabled = val; watermarkFrame.Visible = val end })
Tabs.WatermarkTab:CreateToggle("WMNm", { Title = "Show Username", Default = true, Callback = function(val) WatermarkSettings.showName = val end })
Tabs.WatermarkTab:CreateToggle("WMFps", { Title = "Show FPS", Default = true, Callback = function(val) WatermarkSettings.showFps = val end })
Tabs.WatermarkTab:CreateToggle("WMPing", { Title = "Show Ping", Default = true, Callback = function(val) WatermarkSettings.showPing = val end })
Tabs.WatermarkTab:CreateToggle("WMPlrs", { Title = "Show Player Count", Default = true, Callback = function(val) WatermarkSettings.showPlayerCount = val end })

Tabs.ESPTab:CreateParagraph("EInfo", { Title = "ESP Modules", Content = "Toggle multiple features." })
Tabs.ESPTab:CreateSlider("EMD", { Title = "Max ESP Distance", Default = 2000, Min = 100, Max = 5000, Rounding = 0, Callback = function(val) EspSettings.maxDistance = val end })
Tabs.ESPTab:CreateSlider("ESD", { Title = "Skeleton Max Distance", Default = 500, Min = 50, Max = 1500, Rounding = 0, Callback = function(val) EspSettings.skeletonMaxDistance = val end })
Tabs.ESPTab:CreateDropdown("PESP", {
    Title = "Player ESP", Values = { "Enabled", "Box", "Names", "Distance", "HP Bar", "HP Text", "Items", "Skeleton", "Chams", "Visibility Check", "Visibility Text", "Team Check" },
    Multi = true, Default = {},
    Callback = function(vals)
        EspSettings.enabled = vals.Enabled or false
        EspSettings.box = vals.Box or false
        EspSettings.name = vals.Names or false
        EspSettings.distance = vals.Distance or false
        EspSettings.hpBar = vals["HP Bar"] or false
        EspSettings.hpPercentageText = vals["HP Text"] or false
        EspSettings.items = vals.Items or false
        EspSettings.skeleton = vals.Skeleton or false
        EspSettings.chams = vals.Chams or false
        EspSettings.visibilityCheck = vals["Visibility Check"] or false
        EspSettings.visibilityLabel = vals["Visibility Text"] or false
        EspSettings.teamCheck = vals["Team Check"] or false
    end
})
Tabs.ESPTab:CreateToggle("HPHB", { Title = "Health Based HP Bar Color", Default = true, Callback = function(val) EspSettings.hpBasedColor = val end })
Tabs.ESPTab:CreateDropdown("CSty", {
    Title = "ESP Chams Style", Values = { "Default", "Solid", "Ghost", "Outline Only", "Glow", "Pulsing Outline", "Flashlight" },
    Default = 2, Callback = function(val) EspSettings.chamsStyle = val end
})
Tabs.ESPTab:CreateDropdown("AESP", {
    Title = "Off-Screen Arrows", Values = { "Enabled", "Distance", "Glow", "Shadow", "Highlight" },
    Multi = true, Default = { "Glow", "Shadow", "Highlight" },
    Callback = function(vals)
        ArrowSettings.enabled = vals.Enabled or false
        ArrowSettings.distance = vals.Distance or false
        ArrowSettings.glow = vals.Glow or false
        ArrowSettings.shadowEnabled = vals.Shadow or false
        ArrowSettings.highlightEnabled = vals.Highlight or false
    end
})
Tabs.ESPTab:CreateDropdown("TESP", { Title = "Tracers", Values = { "Enabled" }, Multi = true, Default = {}, Callback = function(vals) EspSettings.tracers = vals.Enabled or false end })
Tabs.ESPTab:CreateDropdown("PlESP", {
    Title = "Plot/Items ESP", Values = { "Enabled", "Highlight", "Tracers", "Names", "Distance", "Team Check" },
    Multi = true, Default = {},
    Callback = function(vals)
        PlotEspSettings.enabled = vals.Enabled or false
        PlotEspSettings.highlight = vals.Highlight or false
        PlotEspSettings.tracers = vals.Tracers or false
        PlotEspSettings.name = vals.Names or false
        PlotEspSettings.distance = vals.Distance or false
        PlotEspSettings.teamCheck = vals["Team Check"] or false
    end
})
Tabs.ESPTab:CreateDropdown("AdESP", {
    Title = "Airdrop ESP", Values = { "Enabled", "Highlight", "Tracers", "Names", "Distance" },
    Multi = true, Default = {},
    Callback = function(vals)
        AirdropEspSettings.enabled = vals.Enabled or false
        AirdropEspSettings.highlight = vals.Highlight or false
        AirdropEspSettings.tracers = vals.Tracers or false
        AirdropEspSettings.name = vals.Names or false
        AirdropEspSettings.distance = vals.Distance or false
    end
})
Tabs.ESPTab:CreateDropdown("MnESP", {
    Title = "Landmine ESP", Values = { "Enabled", "Highlight", "Tracers", "Names", "Distance" },
    Multi = true, Default = {},
    Callback = function(vals)
        LandmineEspSettings.enabled = vals.Enabled or false
        LandmineEspSettings.highlight = vals.Highlight or false
        LandmineEspSettings.tracers = vals.Tracers or false
        LandmineEspSettings.name = vals.Names or false
        LandmineEspSettings.distance = vals.Distance or false
    end
})
Tabs.ESPTab:CreateParagraph("ESet", { Title = "ESP Settings", Content = "Customize thickness, sizes." })
Tabs.ESPTab:CreateDropdown("ASty", { Title = "Arrow Style", Values = { "Classic", "Modern", "Minimal", "Neon", "Outline Only" }, Default = 1, Callback = function(val) ArrowSettings.style = val end })
Tabs.ESPTab:CreateDropdown("TOrg", { Title = "Tracer Origin", Values = { "Top", "Bottom", "Center", "Mouse" }, Default = 1, Callback = function(val) EspSettings.tracerOrigin = val end })
Tabs.ESPTab:CreateSlider("BThk", { Title = "Box Thickness", Default = 2, Min = 1, Max = 5, Rounding = 0, Callback = function(val) EspSettings.boxThickness = val end })
Tabs.ESPTab:CreateSlider("TThk", { Title = "Tracer Thickness", Default = 1, Min = 1, Max = 5, Rounding = 0, Callback = function(val) EspSettings.tracerThickness = val end })
Tabs.ESPTab:CreateSlider("CTrn", { Title = "Chams Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(val) EspSettings.chamsTransparency = val end })

Tabs.CombatTab:CreateParagraph("CInfo", { Title = "Aimbot Settings", Content = "Aimbot config." })
Tabs.CombatTab:CreateToggle("AEn", { Title = "Aimbot Enabled", Default = false, Callback = function(val) AimbotSettings.aimbotEnabled = val; if val then startAimbot() else stopAimbot() end end })
Tabs.CombatTab:CreateDropdown("AKy", { Title = "Aimbot Key", Values = { "Right Click", "Left Click", "Use Keybind" }, Default = 1, Callback = function(val) AimbotSettings.aimbotKey = val end })
Options.aimbotKeybind = Tabs.CombatTab:CreateKeybind("AKbd", { Title = "Aimbot Keybind (If selected)", Mode = "Hold", Default = "C" })
Tabs.CombatTab:CreateDropdown("APr", { Title = "Target Priority", Values = { "Closest to Crosshair", "Closest Distance", "Furthest Distance", "Lowest HP", "Highest HP" }, Default = 1, Callback = function(val) AimbotSettings.priority = val end })
Tabs.CombatTab:CreateToggle("ASt", { Title = "Sticky Aim (Lock-On)", Default = false, Callback = function(val) AimbotSettings.stickyAim = val end })
Tabs.CombatTab:CreateToggle("SFv", { Title = "Show FOV Circle", Default = false, Callback = function(val) AimbotSettings.showFovCircle = val; aimbotCircle.Visible = val end })
Tabs.CombatTab:CreateToggle("ATc", { Title = "Team Check", Default = false, Callback = function(val) AimbotSettings.teamCheck = val end })
Tabs.CombatTab:CreateToggle("AWc", { Title = "Wall Check", Default = true, Callback = function(val) AimbotSettings.wallCheck = val end })
Tabs.CombatTab:CreateDropdown("TPt", { Title = "Target Part", Values = { "Head", "UpperTorso", "HumanoidRootPart" }, Default = 1, Callback = function(val) AimbotSettings.targetPart = val end })
Tabs.CombatTab:CreateSlider("FSz", { Title = "FOV Size", Default = 150, Min = 50, Max = 700, Rounding = 0, Callback = function(val) AimbotSettings.aimbotFov = val; aimbotCircle.Radius = val end })
Tabs.CombatTab:CreateParagraph("PInf", { Title = "Prediction Logic", Content = "How target movement is predicted." })
Tabs.CombatTab:CreateDropdown("APt", { Title = "Prediction Type", Values = { "Velocity", "Static" }, Default = 1, Callback = function(val) AimbotSettings.predictionType = val end })
Tabs.CombatTab:CreateSlider("APv", { Title = "Velocity Prediction Factor", Default = 0.12, Min = 0, Max = 1, Rounding = 2, Callback = function(val) AimbotSettings.velocityFactor = val end })
Tabs.CombatTab:CreateSlider("APs", { Title = "Static Prediction (Studs)", Default = 5, Min = 0, Max = 20, Rounding = 1, Callback = function(val) AimbotSettings.staticFactor = val end })
Tabs.CombatTab:CreateParagraph("TInf", { Title = "TriggerBot Settings", Content = "Auto shoot." })
Tabs.CombatTab:CreateToggle("TEn", { Title = "Trigger Bot Enabled", Default = false, Callback = function(val) AimbotSettings.triggerEnabled = val; toggleTriggerBot() end })
Tabs.CombatTab:CreateDropdown("TKy", { Title = "TriggerBot Key", Values = { "Right Click", "Left Click", "Use Keybind" }, Default = 3, Callback = function(val) AimbotSettings.triggerKey = val end })
Options.triggerKeybind = Tabs.CombatTab:CreateKeybind("TKbd", { Title = "TriggerBot Keybind (If selected)", Mode = "Hold", Default = "V" })
Tabs.CombatTab:CreateToggle("TWc", { Title = "TriggerBot Visibility Check", Default = true, Callback = function(val) AimbotSettings.triggerWallCheck = val end })
Tabs.CombatTab:CreateToggle("TTc", { Title = "TriggerBot Team Check", Default = false, Callback = function(val) AimbotSettings.triggerTeamCheck = val end })
Tabs.CombatTab:CreateParagraph("HInf", { Title = "Low HP Ignore", Content = "Don't aim/shoot if target is almost dead." })
Tabs.CombatTab:CreateSlider("IHp", { Title = "Ignore if HP is below", Default = 20, Min = 1, Max = 100, Rounding = 0, Callback = function(val) AimbotSettings.ignoreHp = val end })
Tabs.CombatTab:CreateToggle("AIh", { Title = "Aimbot Ignore Low HP", Default = false, Callback = function(val) AimbotSettings.aimbotIgnoreHp = val end })
Tabs.CombatTab:CreateToggle("TIh", { Title = "TriggerBot Ignore Low HP", Default = false, Callback = function(val) AimbotSettings.triggerIgnoreHp = val end })

Tabs.FPSBoostTab:CreateParagraph("FInf", { Title = "FPS Booster", Content = "Drastically reduces game graphics for better performance.\n\nNote: Cannot be fully reverted without rejoining the game." })
Tabs.FPSBoostTab:CreateToggle("FEn", { Title = "Enable Low Graphics Mode", Default = false, Callback = function(val) if val then applyLowGraphics() end end })

Tabs.VisualsTab:CreateParagraph("VGn", { Title = "Bullet & Hit Effects", Content = "Hitmarkers, Tracers" })
Tabs.VisualsTab:CreateToggle("Hmk", { Title = "Enable 3D Hitmarker", Default = true, Callback = function(val) HitTracerSettings.hitMarkerEnabled = val end })
Tabs.VisualsTab:CreateParagraph("TTgI", { Title = "Bullet Tracers Settings", Content = "Customize how bullet tracers look." })
Tabs.VisualsTab:CreateToggle("TTg", { Title = "Enable Bullet Tracers", Default = false, Callback = function(val) HitTracerSettings.tracerEnabled = val end })
Tabs.VisualsTab:CreateToggle("TPls", { Title = "Pulsing Effect", Default = false, Callback = function(val) HitTracerSettings.tracerPulse = val end })
Tabs.VisualsTab:CreateSlider("TThk", { Title = "Tracer Thickness", Default = 0.05, Min = 0.01, Max = 0.5, Rounding = 2, Callback = function(val) HitTracerSettings.tracerThickness = val end })
Tabs.VisualsTab:CreateSlider("TDur", { Title = "Tracer Duration (s)", Default = 0.5, Min = 0.1, Max = 5, Rounding = 1, Callback = function(val) HitTracerSettings.tracerDuration = val end })
Tabs.VisualsTab:CreateSlider("TSpd", { Title = "Pulse Speed", Default = 10, Min = 1, Max = 30, Rounding = 0, Callback = function(val) HitTracerSettings.tracerPulseSpeed = val end })
Tabs.VisualsTab:CreateColorpicker("Btc", { Title = "Bullet Tracer Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) HitTracerSettings.tracerColor = val end })
Tabs.VisualsTab:CreateParagraph("AInf", { Title = "Arms Chams", Content = "Modify first-person arms and weapon textures." })
Tabs.VisualsTab:CreateToggle("ATg", { Title = "Enable Arms Chams", Default = false, Callback = function(val) HitTracerSettings.armsChamsEnabled = val end })
Tabs.VisualsTab:CreateDropdown("AMt", { Title = "Material Type", Values = { "ForceField", "Neon", "Glass", "Plastic" }, Default = 1, Callback = function(val) HitTracerSettings.armsChamsMaterial = val end })
Tabs.VisualsTab:CreateColorpicker("ACl", { Title = "Chams Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) HitTracerSettings.armsChamsColor = val end })

Tabs.ColorsTab:CreateParagraph("ClInf", { Title = "ESP Colors", Content = "Customize all colors." })
Tabs.ColorsTab:CreateToggle("RCg", { Title = "Rainbow Chams", Default = false, Callback = function(val) EspSettings.rainbowChams = val end })
Tabs.ColorsTab:CreateSlider("RSpd", { Title = "Rainbow Speed", Default = 3, Min = 1, Max = 10, Rounding = 1, Callback = function(val) EspSettings.rainbowSpeed = val end })
Tabs.ColorsTab:CreateColorpicker("BxC", { Title = "Box Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) EspSettings.boxColor = val end })
Tabs.ColorsTab:CreateColorpicker("NmC", { Title = "Name Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) EspSettings.nameColor = val end })
Tabs.ColorsTab:CreateColorpicker("DtC", { Title = "Distance Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) EspSettings.distanceColor = val end })
Tabs.ColorsTab:CreateColorpicker("TrC", { Title = "ESP Tracer Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) EspSettings.tracerColor = val end })
Tabs.ColorsTab:CreateColorpicker("SkC", { Title = "Skeleton Color", Default = Color3FromRGB(255, 255, 255), Callback = function(val) EspSettings.skeletonColor = val end })
Tabs.ColorsTab:CreateColorpicker("CmC", { Title = "Chams Color", Default = Color3FromRGB(255, 100, 100), Callback = function(val) EspSettings.chamsColor = val end })
Tabs.ColorsTab:CreateColorpicker("HpC", { Title = "Static HP Bar Color", Default = Color3FromRGB(0, 255, 0), Callback = function(val) EspSettings.hpStaticColor = val end })

Tabs.WorldTab:CreateParagraph("HSInf", { Title = "Hit Sounds", Content = "Plays a sound when you hit a player." })
Tabs.WorldTab:CreateToggle("HSEn", { Title = "Enable Hit Sound", Default = false, Callback = function(val) HitSoundSettings.enabled = val end })
Tabs.WorldTab:CreateDropdown("HSSel", { Title = "Hit Sound Type", Values = { "Default", "Neverlose", "Fatality", "Skeet", "UwU", "Custom" }, Default = 1, Multi = false, Callback = function(val) HitSoundSettings.type = val; updateHitSound(); if HitSoundSettings.enabled then playHitSound() end end })
Tabs.WorldTab:CreateInput("CHs", { Title = "Custom Hit Sound ID", Default = "", Placeholder = "Type Sound ID", Numeric = true, Finished = true, Callback = function(val) HitSoundSettings.customId = val; updateHitSound(); if HitSoundSettings.enabled and HitSoundSettings.type == "Custom" then playHitSound() end end })
Tabs.WorldTab:CreateParagraph("EInf", { Title = "Environment Visuals", Content = "Modify the map atmosphere." })
Tabs.WorldTab:CreateToggle("CSb", { Title = "Custom Skybox", Default = false, Callback = function(val) WorldVisualSettings.customSky = val; applySkySettings() end })
Tabs.WorldTab:CreateDropdown("SbC", { Title = "Skybox Theme", Values = { "None", "Sunset", "Purple Night", "Clear Day", "Galaxy" }, Default = 1, Multi = false, Callback = function(val) WorldVisualSettings.skyTheme = val; if WorldVisualSettings.customSky then applySkySettings() end end })
Tabs.WorldTab:CreateParagraph("LvInf", { Title = "Local Player Visuals", Content = "Effects attached to your character." })
Tabs.WorldTab:CreateToggle("TrlTg", { Title = "Movement Trail", Default = false, Callback = function(val) WorldVisualSettings.trailEnabled = val; updateTrail() end })
Tabs.WorldTab:CreateColorpicker("TrlCl", { Title = "Trail Color", Default = Color3FromRGB(20, 255, 150), Callback = function(val) WorldVisualSettings.trailColor = val; updateTrail() end })

Tabs.SettingsTab:CreateButton({ Title = "UNLOAD ALL", Description = "Disable everything", Callback = fullCleanup })

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("JadeXYZ")
SaveManager:SetFolder("JadeXYZ/configs")
InterfaceManager:BuildInterfaceSection(Tabs.SettingsTab)
SaveManager:BuildConfigSection(Tabs.SettingsTab)

table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    if WorldVisualSettings.trailEnabled and not unloading then
        task.wait(1)
        updateTrail()
    end
end))

table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    espManager:removePlayerEsp(player)
end))

local temporaryGui = {}

renderConnection = RunService.RenderStepped:Connect(function()
    if unloading then return end
    if WorldVisualSettings.customSky then
        local terrain = workspace:FindFirstChild("Terrain")
        if terrain then
            for _, v in pairs(terrain:GetChildren()) do
                if v:IsA("Clouds") then v:Destroy() end
            end
        end
    end
    local firstPersonParts = getFirstPersonParts()
    local changedParts = {}
    if HitTracerSettings.armsChamsEnabled then
        for _, part in ipairs(firstPersonParts) do
            if not armesChamsCache[part] then
                local data = {
                    originalMaterial = part.Material,
                    originalColor = part.Color,
                    originalTransparency = part.Transparency,
                    textureData = {}
                }
                if part:IsA("MeshPart") then data.originalTextureId = part.TextureID end
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        table.insert(data.textureData, { object = child, originalTransparency = child.Transparency })
                    elseif child:IsA("SpecialMesh") then
                        table.insert(data.textureData, { object = child, originalTextureId = child.TextureId })
                    end
                end
                armesChamsCache[part] = data
            end
            local partName = part.Name:lower()
            if armesChamsCache[part].originalTransparency > 0.85 or partName:match("root") or partName:match("camera") or partName:match("main") or partName:match("hitbox") or partName:match("aim") then
                continue
            end
            changedParts[part] = true
            part.Material = Enum.Material[HitTracerSettings.armsChamsMaterial]
            part.Color = HitTracerSettings.armsChamsColor
            part.Transparency = HitTracerSettings.armsChamsTransparency
            if part:IsA("MeshPart") then part.TextureID = "" end
            if armesChamsCache[part] and armesChamsCache[part].textureData then
                for _, texData in ipairs(armesChamsCache[part].textureData) do
                    if texData.object:IsA("Texture") or texData.object:IsA("Decal") then
                        texData.object.Transparency = 1
                    elseif texData.object:IsA("SpecialMesh") then
                        texData.object.TextureId = ""
                    end
                end
            end
        end
    end
    for part, data in pairs(armesChamsCache) do
        if not HitTracerSettings.armsChamsEnabled or not changedParts[part] then
            pcall(function()
                part.Material = data.originalMaterial
                part.Color = data.originalColor
                part.Transparency = data.originalTransparency
                if part:IsA("MeshPart") and data.originalTextureId then part.TextureID = data.originalTextureId end
                for _, texData in ipairs(data.textureData) do
                    if texData.object:IsA("Texture") or texData.object:IsA("Decal") then
                        texData.object.Transparency = texData.originalTransparency
                    elseif texData.object:IsA("SpecialMesh") then
                        texData.object.TextureId = texData.originalTextureId
                    end
                end
            end)
            armesChamsCache[part] = nil
        end
    end
    for i = 1, #Events do
        local event = table.remove(Events, 1)
        if event then
            if event.type == "Hit" then
                if HitTracerSettings.hitMarkerEnabled and event.pos then
                    createHitMarker(event.pos)
                end
                if event.isHit then playHitSound() end
            elseif event.type == "Tracer" then
                createTracer(event.start, event.finish, HitTracerSettings.tracerColor)
            end
        end
    end
    for _, label in ipairs(temporaryGui) do label:Destroy() end
    temporaryGui = {}
    local activeCount = 0
    if AimbotSettings.aimbotEnabled and isAimbotKeyDown() then
        activeCount += 1
        local label = InstanceNew("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 15)
        label.BackgroundTransparency = 1
        label.Text = "Aimbot"
        label.TextColor3 = Color3FromRGB(200, 200, 200)
        label.Font = Enum.Font.Code
        label.TextSize = 12
        label.Parent = keybindsList
        table.insert(temporaryGui, label)
    end
    if AimbotSettings.triggerEnabled and isTriggerKeyDown() then
        activeCount += 1
        local label = InstanceNew("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 15)
        label.BackgroundTransparency = 1
        label.Text = "TriggerBot"
        label.TextColor3 = Color3FromRGB(200, 200, 200)
        label.Font = Enum.Font.Code
        label.TextSize = 12
        label.Parent = keybindsList
        table.insert(temporaryGui, label)
    end
    keybindsFrame.Size = UDim2.new(0, 200, 0, 25 + activeCount * 17)
    if not HumanoidRootPart or not HumanoidRootPart.Parent then
        Character = LocalPlayer.Character
        if Character then HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") end
    end
    if AimbotSettings.showFovCircle then
        aimbotCircle.Position = UserInputService:GetMouseLocation()
        aimbotCircle.Radius = AimbotSettings.aimbotFov
        aimbotCircle.Visible = true
    else
        aimbotCircle.Visible = false
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character.Parent then
                if not espManager.playerDrawings[player] then
                    espManager.playerDrawings[player] = espManager:createPlayerDrawings()
                end
                espManager:updatePlayerEsp(espManager.playerDrawings[player], character, player)
            else
                if espManager.playerDrawings[player] then
                    espManager:hidePlayerEsp(espManager.playerDrawings[player])
                end
            end
        end
    end
    if not espManager.lastWorldUpdate or tick() - espManager.lastWorldUpdate > 0.1 then
        espManager.lastWorldUpdate = tick()
        espManager:updatePlots()
        espManager:updateAirdrops()
        espManager:updateLandmines()
    end
end)
table.insert(connections, renderConnection)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Jade.xyz Stable",
    Content = "Loaded safely!",
    SubContent = "Arms Chams Fixed & Code Refactored",
    Duration = 5
})
SaveManager:LoadAutoloadConfig()
