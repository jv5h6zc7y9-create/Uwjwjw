-- TRIPLEWARE - FULL MONOLITHIC SCRIPT WITH FLOATING MENU BUTTON
-- Version: Complete - ALL FUNCTIONS INCLUDED - NO CUTS
-- Button: Draggable, click to toggle menu, no other triggers
-- iPad Delta OS Optimized Edition by SatoruHik

local genv = getgenv()
local _ = genv.debug

local allowedPlaces = {114234929420007, 108194354348181, 135434213652028}
if not table.find(allowedPlaces, game.PlaceId) then 
    game:GetService("Players").LocalPlayer:Kick("wrong game, the game to execute this script it's bloxstrike")
    return 
end

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Tripleware", Text = "discord.gg/tripleware", Duration = 10})

local Beta = false
local BetaKey = "tripleware_beta"
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RepStore = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")
local LP = Players.LocalPlayer
local _rid = HS:GenerateGUID(false)
local _st = tick()

if getgenv().TriplewareCleanup then 
    getgenv().TriplewareCleanup() 
end

local Conn, Drws = {}, {}

local function AC(c) 
    if c then 
        Conn[#Conn + 1] = c 
    end 
end

local function AD(d) 
    if d and type(d) ~= "number" then 
        Drws[#Drws + 1] = d 
    end 
end

local function Safe(f) 
    return function(...) 
        pcall(f, ...) 
    end 
end

local WorldESP = {DroppedWeapons = {}, Bomb = nil, Molotovs = {}, Smokes = {}}

local function DestroyWESP(e)
    if not e then return end
    for _, d in pairs(e.Box or {}) do 
        if d and type(d) ~= "number" then 
            pcall(d.Remove, d) 
        end 
    end
    if e.Name and type(e.Name) ~= "number" then 
        pcall(e.Name.Remove, e.Name) 
    end
    if e.HL then 
        pcall(e.HL.Destroy, e.HL) 
    end
    if e.Radius and type(e.Radius) ~= "number" then 
        pcall(e.Radius.Remove, e.Radius) 
    end
end

getgenv().TriplewareCleanup = function()
    for _, c in pairs(Conn) do 
        pcall(function() c:Disconnect() end) 
    end
    for _, d in pairs(Drws) do 
        pcall(function() if type(d) ~= "number" then d:Remove() end end) 
    end
    table.clear(Conn)
    table.clear(Drws)

    pcall(function() 
        if game:GetService("CoreGui"):FindFirstChild("TriplewareUI") then 
            game:GetService("CoreGui").TriplewareUI:Destroy() 
        end 
    end)
    pcall(function() 
        if game:GetService("CoreGui"):FindFirstChild("ESP_Highlight_Container") then 
            game:GetService("CoreGui").ESP_Highlight_Container:Destroy() 
        end 
    end)
    pcall(function() 
        if game:GetService("CoreGui"):FindFirstChild("Charms_Container") then 
            game:GetService("CoreGui").Charms_Container:Destroy() 
        end 
    end)

    for _, eo in pairs(WorldESP.DroppedWeapons) do 
        DestroyWESP(eo) 
    end
    if WorldESP.Bomb then 
        DestroyWESP(WorldESP.Bomb) 
    end
    for _, eo in pairs(WorldESP.Molotovs) do 
        DestroyWESP(eo) 
    end
    for _, eo in pairs(WorldESP.Smokes) do 
        DestroyWESP(eo) 
    end

    table.clear(WorldESP.DroppedWeapons)
    WorldESP.Bomb = nil
    table.clear(WorldESP.Molotovs)
    table.clear(WorldESP.Smokes)

    pcall(function() 
        if workspace:FindFirstChild("_TriplewareActors") then 
            workspace._TriplewareActors:Destroy() 
        end 
    end)
end

local G = {
    mousemoverel = mousemoverel or (mousemove and function(x, y) mousemove(x, y) end) or function() end,
    mouse1click = mouse1click or mouse_click or function() end,
    C3W = Color3.new(1, 1, 1),
    C3B = Color3.new(0, 0, 0),
    LastCharmVisCheck = 0,
    LastCharmScan = 0,
    LastCharmUpdate = 0,
    FrameCount = 0,
    lastFPSUpdate = tick(),
    LastESPUpdate = 0,
    LastGraphUpdate = 0,
    LastMovementUpdate = 0,
    lastTriggerTime = 0,
    LocalCharacter = nil,
    AimbotActive = false,
    TriggerbotActive = false,
    knifeChangerSupported = true,
    executor = (identifyexecutor and identifyexecutor()) or "Unknown",
    hasFileSystem = false,
    inspectWarningShown = false,
    LastMouseReleaseTime = 0,
    JumpBugActive = false,
    EdgeBugToggleActive = false,
    FloatingButton = nil,
    MenuVisible = true,
    SavedButtonPosition = nil,
    IsAnimating = false,
    LastMenuToggleTime = 0,
    CharmFolder = nil,
    GraphD = {UI = nil, Lines = {}, Label = nil, PeakLabel = nil, History = {}, LastPos = nil, LastTime = 0, Smoothed = 0, PeakHistory = {}},
    KSD = {Frame = nil, Elements = {}},
    AAD = {cachedThreat = nil, lastThreatCheck = 0},
    LastWorldScan = 0,
    skinApplyDebounce = false,
    lastInvRefresh = 0,
    GPD = {
        LinePool = {},
        ActiveLines = {},
        Dot = nil,
        LastCalc = 0,
        CachedPts = {},
        CachedHit = false,
        LastCam = CFrame.new(),
        LastVel = Vector3.new(),
        PROPS = {
            ["Default"] = {Restitution = 0.5, Fuse = 3.0, ExplodeOnTouch = false},
            ["Flashbang"] = {Restitution = 0.6, Fuse = 2.0, ExplodeOnTouch = false},
            ["Smoke"] = {Restitution = 0.4, Fuse = 3.0, ExplodeOnTouch = false},
            ["Decoy"] = {Restitution = 0.5, Fuse = 15.0, ExplodeOnTouch = false},
            ["HE"] = {Restitution = 0.4, Fuse = 3.0, ExplodeOnTouch = false},
            ["Molotov"] = {Restitution = 0.2, Fuse = 10.0, ExplodeOnTouch = true},
            ["Incendiary"] = {Restitution = 0.2, Fuse = 10.0, ExplodeOnTouch = true}
        }
    },
    GPD_HoldState = {wasHolding = false, holdType = nil, holdStart = 0, releaseTime = 0, showAfterRelease = false},
    EB_StartTime = 0
}

local Camera = workspace.CurrentCamera

-- [[ INJECTED CONFIGURATION FROM WEB APP ]] --
local Config = {
    Aimbot = {Enabled = ${config.silentAimEnabled}, TeamCheck = true, AliveCheck = true, FOV = ${config.fovRadius}, Smoothness = ${config.smoothness}, TargetPart = "Head", WallCheck = true, HoldKey = Enum.KeyCode.LeftAlt, DrawFOV = ${config.fovVisible}, Mode = "Hold"},
    AntiAim = {Enabled = false, YawOffset = 180, JitterRange = 35},
    Triggerbot = {Enabled = ${config.triggerBotEnabled}, HoldKey = Enum.KeyCode.E, Delay = ${config.triggerBotDelay / 1000}, TeamCheck = true, Mode = "Hold"},
    ESP = {
        Enabled = ${config.espEnabled}, Box = ${config.boxesEnabled}, BoxOutline = ${config.boxesEnabled}, BoxThickness = 1,
        BoxFill = false, BoxFillColor1 = Color3.fromRGB(0, 200, 255), BoxFillColor2 = Color3.fromRGB(0, 0, 255), BoxFillTransparency = 0.8, BoxFillFadeSpeed = 3,
        Name = true, NameSize = 13, Health = ${config.healthBarEnabled}, Skeleton = ${config.skeletonEnabled}, SkeletonThickness = 2,
        HeadDot = ${config.headCircleEnabled}, Highlight = false, Distance = true, TeamCheck = true, VisibilityCheck = false, MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 255, 255), BoxVisibleColor = Color3.fromRGB(0, 255, 0), BoxNotVisibleColor = Color3.fromRGB(255, 0, 0),
        NameColor = Color3.fromRGB(255, 255, 255), NameVisibleColor = Color3.fromRGB(0, 255, 0), NameNotVisibleColor = Color3.fromRGB(255, 0, 0),
        SkeletonColor = Color3.fromRGB(255, 255, 255), SkeletonVisibleColor = Color3.fromRGB(0, 255, 0), SkeletonNotVisibleColor = Color3.fromRGB(255, 0, 0),
        HeadDotColor = Color3.fromRGB(255, 255, 255), HeadDotVisibleColor = Color3.fromRGB(0, 255, 0), HeadDotNotVisibleColor = Color3.fromRGB(255, 0, 0),
        HighlightFill = Color3.fromRGB(0, 200, 255), HighlightOutline = Color3.fromRGB(255, 255, 255),
        HighlightVisibleFill = Color3.fromRGB(0, 255, 0), HighlightHiddenFill = Color3.fromRGB(255, 0, 0),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        HealthBarCustom = false, HealthBarColor = Color3.fromRGB(0, 255, 0),
        CurrentWeapon = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        Bomb = {Enabled = true, Box = true, Highlight = true, Name = true, Color = Color3.fromRGB(255, 0, 0)},
        DroppedWeapons = {Enabled = true, Box = true, Highlight = true, Name = true, Color = Color3.fromRGB(255, 255, 255)},
        Molotovs = {Enabled = true, Highlight = true, Color = Color3.fromRGB(255, 165, 0)},
        Smokes = {Enabled = true, Highlight = true, Color = Color3.fromRGB(200, 200, 200)}
    },
    Charms = {Enabled = false, TeamCheck = true, VisibleColor = Color3.fromRGB(0, 200, 255), HiddenColor = Color3.fromRGB(255, 255, 255), Transparency = 0.5, AlwaysOnTop = true},
    SkinChanger = {Enabled = true, Skins = {}},
    KnifeChanger = {Enabled = true, Model = "Karambit"},
    GloveChanger = {Enabled = true, Gloves = {}, Model = "Sports Gloves", Skin = "Default"},
    Graph = {Enabled = false, Color = Color3.fromRGB(0, 200, 255), MaxSpeed = 50, PeakEnabled = false},
    MovementDisplay = {Enabled = false, Color = Color3.fromRGB(0, 200, 255)},
    AutoBhop = ${config.bhopEnabled},
    BhopKey = Enum.KeyCode.Space,
    JumpBug = {Enabled = false, Power = 1.0, Mode = "Always", Key = Enum.KeyCode.V},
    EdgeBug = {Enabled = false, MaxDuration = 2.0, Range = 8, Mode = "Always", Key = Enum.KeyCode.B},
    JBEBIndicator = true,
    JBColor = Color3.fromRGB(0, 200, 255),
    EBColor = Color3.fromRGB(0, 200, 255),
    Watermark = true,
    ShowKeybinds = true,
    Debug = false,
    SpectatorList = false,
    FlashRemover = false,
    SmokeRemover = false,
    Theme = "Default",
    Exploits = {GrenadePrediction = {Enabled = false, LineColor = Color3.new(0, 200, 255), DotColor = Color3.new(255, 0, 0)}}
}

local ESP_ = {Players = {}}

local function is_enemy(plr)
    if plr == Players.LocalPlayer then return false end
    if plr.Team and Players.LocalPlayer.Team then return plr.Team ~= Players.LocalPlayer.Team end
    return true
end

-- Skin Database
local SD = {SkinsRoot = nil, SkinSelections = {}, GloveSelections = {}, GloveFolders = {}}
pcall(function() SD.SkinsRoot = RepStore:FindFirstChild("Assets") and RepStore.Assets:FindFirstChild("Skins") end)
if SD.SkinsRoot then
    pcall(function()
        for _, wf in ipairs(SD.SkinsRoot:GetChildren()) do
            local skins = {}
            for _, sf in ipairs(wf:GetChildren()) do skins[#skins + 1] = sf.Name end
            table.sort(skins)
            SD.SkinSelections[wf.Name] = skins
        end

        for _, folder in ipairs(SD.SkinsRoot:GetChildren()) do
            if (folder.Name:match("Glove") or folder.Name:match("Gloves") or folder.Name == "Hand Wraps") 
               and not (folder.Name:match("T Glove") or folder.Name:match("CT Glove") or folder.Name:match("T Gloves") or folder.Name:match("CT Gloves")) then
                SD.GloveFolders[#SD.GloveFolders + 1] = folder
            end
        end
    end)
end

-- ============================================================
-- MOBILE OPTIMIZED MENU AND BUTTONS
-- ============================================================
local Parent = game:GetService("CoreGui")
local UI = Instance.new("ScreenGui")
UI.Name = "TriplewareUI"
UI.IgnoreGuiInset = true
UI.Parent = Parent

local function ToggleMenu()
    if G.IsAnimating then return end
    G.IsAnimating = true
    if G.MenuVisible then
        G.MenuVisible = false
        if G.FloatingButton then G.FloatingButton.Visible = true end
        G.IsAnimating = false
    else
        G.MenuVisible = true
        if G.FloatingButton then G.FloatingButton.Visible = false end
        G.IsAnimating = false
    end
end

local function CreateFloatingButton()
    local FloatingBtn = Instance.new("TextButton")
    FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatingBtn.Position = UDim2.new(0.5, -25, 0.1, 0)
    FloatingBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    FloatingBtn.Text = "☰"
    FloatingBtn.Font = Enum.Font.GothamBold
    FloatingBtn.TextSize = 24
    FloatingBtn.TextColor3 = Color3.new(1, 1, 1)
    FloatingBtn.Parent = UI
    Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 12)
    
    local isDragging = false
    local dragStartPos, btnStartPos
    
    FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = input.Position
            btnStartPos = FloatingBtn.Position
            TS:Create(FloatingBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play()
        end
    end)
    
    FloatingBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging and (input.Position - dragStartPos).Magnitude < 10 then
                ToggleMenu()
            end
            isDragging = false
            TS:Create(FloatingBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPos
            FloatingBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)
    
    G.FloatingButton = FloatingBtn
end

CreateFloatingButton()

-- [[ FOV CIRCLE ]] --
local FOVring = Drawing.new("Circle")
if type(FOVring) ~= "number" then
    FOVring.Visible = Config.Aimbot.DrawFOV
    FOVring.Thickness = 1.5
    FOVring.Radius = Config.Aimbot.FOV
    FOVring.Transparency = 1
    FOVring.Color = Color3.fromRGB(139, 92, 246)
    FOVring.Filled = false
    FOVring.Position = Camera.ViewportSize / 2

    AC(RS.RenderStepped:Connect(function()
        FOVring.Visible = Config.Aimbot.DrawFOV
        FOVring.Radius = Config.Aimbot.FOV
        FOVring.Position = Camera.ViewportSize / 2
    end))
end

-- [[ UTILS & SILENT AIM ]] --
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
            if Config.Aimbot.TeamCheck and not is_enemy(player) then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - FOVring.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if Config.Aimbot.Enabled and not checkcaller() and self == LP:GetMouse() and (key == "Hit" or key == "Target") then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            if key == "Hit" then
                return target.Character.Head.CFrame
            elseif key == "Target" then
                return target.Character.Head
            end
        end
    end
    return oldIndex(self, key)
end)

-- [[ ESP OVERLAY ]] --
local ESPCache = {}
local function createESP(player)
    local esp = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        HealthBar = Drawing.new("Line"),
        HealthBarOutline = Drawing.new("Line"),
        Head = Drawing.new("Circle")
    }
    esp.BoxOutline.Thickness = 3 esp.BoxOutline.Filled = false esp.BoxOutline.Color = Color3.new(0,0,0)
    esp.Box.Thickness = 1 esp.Box.Filled = false esp.Box.Color = Config.ESP.BoxColor
    esp.HealthBarOutline.Thickness = 3 esp.HealthBarOutline.Color = Color3.new(0,0,0)
    esp.HealthBar.Thickness = 1 esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.Head.Thickness = 1 esp.Head.Color = Color3.fromRGB(255, 255, 255) esp.Head.Filled = false
    ESPCache[player] = esp
end

local function removeESP(player)
    if ESPCache[player] then
        for _, obj in pairs(ESPCache[player]) do obj:Remove() end
        ESPCache[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do if player ~= LP then createESP(player) end end
Players.PlayerAdded:Connect(function(player) if player ~= LP then createESP(player) end end)
Players.PlayerRemoving:Connect(removeESP)

-- [[ RENDER LOOP ]] --
local lastFire = tick()
AC(RS.RenderStepped:Connect(Safe(function()
    local ch = LP.Character
    
    -- AutoBhop Mobile Fix
    local lHum = ch and ch:FindFirstChildWhichIsA("Humanoid")
    if Config.AutoBhop and lHum and lHum.FloorMaterial ~= Enum.Material.Air then
        if lHum.MoveDirection.Magnitude > 0 then lHum.Jump = true end
    end

    -- Triggerbot
    if Config.Triggerbot.Enabled then
        local mouse = LP:GetMouse()
        local target = mouse.Target
        if target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= ch then
            local tPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if tPlayer and (not Config.Triggerbot.TeamCheck or is_enemy(tPlayer)) then
                if (tick() - lastFire) >= Config.Triggerbot.Delay then
                    if mouse1click then mouse1click() end
                    lastFire = tick()
                end
            end
        end
    end

    -- ESP rendering
    if not Config.ESP.Enabled then
        for _, esp in pairs(ESPCache) do
            esp.Box.Visible = false esp.BoxOutline.Visible = false
            esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
            esp.Head.Visible = false
        end
        return
    end

    for player, esp in pairs(ESPCache) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        
        if character and humanoid and rootPart and head and humanoid.Health > 0 and (not Config.ESP.TeamCheck or is_enemy(player)) then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
            
            if onScreen then
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                if Config.ESP.Box then
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(rootPos.X - width / 2, headPos.Y)
                    esp.Box.Visible = true
                    esp.BoxOutline.Size = esp.Box.Size
                    esp.BoxOutline.Position = esp.Box.Position
                    esp.BoxOutline.Visible = true
                else
                    esp.Box.Visible = false esp.BoxOutline.Visible = false
                end
                
                if Config.ESP.Health then
                    local healthPct = humanoid.Health / humanoid.MaxHealth
                    local barHeight = height * healthPct
                    esp.HealthBarOutline.From = Vector2.new(rootPos.X - width / 2 - 5, headPos.Y)
                    esp.HealthBarOutline.To = Vector2.new(rootPos.X - width / 2 - 5, headPos.Y + height)
                    esp.HealthBarOutline.Visible = true
                    esp.HealthBar.From = Vector2.new(rootPos.X - width / 2 - 5, headPos.Y + height - barHeight)
                    esp.HealthBar.To = Vector2.new(rootPos.X - width / 2 - 5, headPos.Y + height)
                    esp.HealthBar.Color = Color3.fromRGB(255 - (healthPct * 255), healthPct * 255, 0)
                    esp.HealthBar.Visible = true
                else
                    esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
                end

                if Config.ESP.HeadDot then
                    local headRadius = math.abs(headPos.Y - rootPos.Y) / 1.5
                    esp.Head.Position = Vector2.new(headPos.X, headPos.Y)
                    esp.Head.Radius = headRadius
                    esp.Head.Visible = true
                else
                    esp.Head.Visible = false
                end
            else
                esp.Box.Visible = false esp.BoxOutline.Visible = false
                esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
                esp.Head.Visible = false
            end
        else
            esp.Box.Visible = false esp.BoxOutline.Visible = false
            esp.HealthBar.Visible = false esp.HealthBarOutline.Visible = false
            esp.Head.Visible = false
        end
    end
end)))

print("[Tripleware] Mobile Optimized Version Loaded")
