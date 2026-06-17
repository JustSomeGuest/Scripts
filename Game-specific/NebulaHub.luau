if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Shared = (function() local Success, Env = pcall(getgenv); return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {}) end)()

local function expect(expected, value, fallback)
    if type(value) == expected then
        return value
    end

    if fallback ~= nil then
        if type(fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fallback(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return fallback
end

local cloneref = expect("function", cloneref, function() return end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Players = Services.Players
local RunService = Services.RunService
local StarterGui = Services.StarterGui

Shared.NebulaHub = Shared.NebulaHub or {}

if Shared.NebulaHub.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Nebula Hub",
        Text = "Nebula Hub is already running!",
        Duration = 4
    })
    error("Nebula Hub is already running", 0)
end

Shared.NebulaHub.isLoaded = true

local function load(url)
    local Success, Response = pcall(game.HttpGet, game, url)
    return loadstring(Success and Response or game:HttpGet(url))()
end

local Interface = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
local Player = Players.LocalPlayer
local Wait = task.wait

local function Notify(Text)
    Interface:Notify({
        Title = "Nebula Hub",
        Content = Text,
        Duration = 3
    })
end

Interface:AddTheme({
    Name = "Nebula",
    Accent = Color3.fromRGB(170,85,255),
    Outline = Color3.fromRGB(40,20,60),
    Text = Color3.fromRGB(255,255,255),
    Placeholder = Color3.fromRGB(170,150,200),
    Background = Color3.fromRGB(7,5,15),
    Button = Color3.fromRGB(18,12,30),
    Icon = Color3.fromRGB(200,140,255),
    Slider = Color3.fromRGB(185,95,255),
    Toggle = Color3.fromRGB(170,85,255)
})

local Window = Interface:CreateWindow({
    Title = "Nebula Hub",
    Author = "JustAGuest",
    Folder = "NebulaHub",
    Transparent = true,
    Theme = "Nebula",
    KeySystem = false,
    ToggleKey = Enum.KeyCode.P
})

Window:EditOpenButton({
    Title = "Nebula",
    Icon = "star",
    CornerRadius = UDim.new(1,0),
    StrokeThickness = 2,
    Draggable = true,
    OnlyMobile = true
})

Notify('Press "P" to Open/Close')

local SaitamaTab = Window:Tab({
    Title = "Saitama",
    Icon = "sword"
})

local GarouTab = Window:Tab({
    Title = "Garou",
    Icon = "flame"
})

local SonicTab = Window:Tab({
    Title = "Sonic",
    Icon = "zap"
})

local GenosTab = Window:Tab({
    Title = "Genos",
    Icon = "cpu"
})

local AnyTab = Window:Tab({
    Title = "Any",
    Icon = "star"
})

local OtherTab = Window:Tab({
    Title = "Other",
    Icon = "settings"
})

local AntiFling = {
    Enabled = false,
    Connections = {},
    Parts = {}
}

local function ClearConnections()
    for _, Connection in pairs(AntiFling.Connections) do
        Connection:Disconnect()
    end
    table.clear(AntiFling.Connections)
end

local function ClearParts()
    for Part in pairs(AntiFling.Parts) do
        if Part and Part.Parent then
            Part.CanCollide = true
        end
    end
    table.clear(AntiFling.Parts)
end

local function SetupPart(Part)
    if not Part:IsA("BasePart") then
        return
    end

    if Player.Character and Part:IsDescendantOf(Player.Character) then
        return
    end

    AntiFling.Parts[Part] = true
    Part.CanCollide = false

    table.insert(AntiFling.Connections, Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if AntiFling.Enabled and Part.Parent then
            Part.CanCollide = false
        end
    end))
end

local function SetupCharacter(Character)
    for _, Part in ipairs(Character:GetDescendants()) do
        SetupPart(Part)
    end

    table.insert(AntiFling.Connections, Character.DescendantAdded:Connect(SetupPart))
end

local function SetupPlayer(PlayerToSetup)
    if PlayerToSetup == Player then
        return
    end

    if PlayerToSetup.Character then
        SetupCharacter(PlayerToSetup.Character)
    end

    table.insert(AntiFling.Connections, PlayerToSetup.CharacterAdded:Connect(SetupCharacter))
end

local function EnableAntiFling()
    if AntiFling.Enabled then
        return
    end

    AntiFling.Enabled = true

    for _, PlayerToSetup in ipairs(Players:GetPlayers()) do
        SetupPlayer(PlayerToSetup)
    end

    table.insert(AntiFling.Connections, Players.PlayerAdded:Connect(SetupPlayer))

    table.insert(AntiFling.Connections, RunService.PreSimulation:Connect(function()
        for Part in pairs(AntiFling.Parts) do
            if Part and Part.Parent then
                Part.CanCollide = false
            else
                AntiFling.Parts[Part] = nil
            end
        end
    end))

    Notify("AntiFling: On")
end

local function DisableAntiFling()
    AntiFling.Enabled = false

    ClearConnections()
    ClearParts()

    Notify("AntiFling: Off")
end

OtherTab:Toggle({
    Title = "AntiFling",
    Default = false,
    Callback = function(Value)
        if Value then
            EnableAntiFling()
        else
            DisableAntiFling()
        end
    end
})

local function FixCamera()
    local Camera = workspace.CurrentCamera
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")

    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = Humanoid

    Player.CameraMode = Enum.CameraMode.Classic
    Humanoid.AutoRotate = true
end

OtherTab:Button({
    Title = "Fix Camera (Once)",
    Callback = function()
        local Success = pcall(FixCamera)
        if Success then
            Notify("Camera: Fixed")
        end
    end
})

SaitamaTab:Button({
    Title = "Omni Man Moveset",
    Callback = function()
        load("https://pastebin.com/raw/UnVdDWcf")()
    end
})

SaitamaTab:Button({
    Title = "Invincible Moveset",
    Callback = function()
        load("https://pastefy.app/BtDQqi2c/raw")()
    end
})

SaitamaTab:Button({
    Title = "Naruto Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/LolnotaKid/NarutoBeatUpSasukeAss/main/NarutoCums")()
    end
})

SaitamaTab:Button({
    Title = "Kratos Moveset",
    Callback = function()
        load("https://rawscripts.net/raw/KJ-The-Strongest-Battlegrounds-Kratos-By-Me-saitama-btw-29150")()
    end
})

SaitamaTab:Button({
    Title = "Anti-Spiral Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/sparksnaps/Anti-Spiral./main/Lua")()
    end
})

SaitamaTab:Button({
    Title = "Vexor Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/VEXOR.lua")()
    end
})

SaitamaTab:Button({
    Title = "Gojo V2 (Morph: On)",
    Callback = function()
        getgenv().morph = true 
        load("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua")()
    end
})

SaitamaTab:Button({
    Title = "Gojo V2 (Morph: Off)",
    Callback = function()
        getgenv().morph = false
        load("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua")()
    end
})

SaitamaTab:Button({
    Title = "Yuji X Sukuna Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Sigma%20v2%20vessel%20tp")()
    end
})

SaitamaTab:Button({
    Title = "Jun Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt")()
    end
})

SaitamaTab:Button({
    Title = "Shinji Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Shinji%20tp%20exploit")()
    end
})

SaitamaTab:Button({
    Title = "GoldenHead Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Saitama%20to%20golden%20sigma")()
    end
})

SaitamaTab:Button({
    Title = "Trashcan Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man")()
    end
})

GarouTab:Button({
    Title = "Garou X Suiryu Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/kjremaker/b092496fc11a57e2c50477154176fa3e/raw/2148f00a036a1799118541765675f3f6a0f8adae/GAROU%20TO%20SURIYU%20BETTER%20THAN%20THE%20OTHERS%20FR")()
    end
})

GarouTab:Button({
    Title = "Void Garou Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Void%20Reaper%20Obfuscated.txt")()
    end
})

GarouTab:Button({
    Title = "Mastery Deku Moveset",
    Callback = function()
        load("https://pastebin.com/raw/xKextYP5")()
    end
})

GarouTab:Button({
    Title = "Chainsaw-Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/CHAINSAW%20MAN/Chainsaw%20Man%20(Obfuscated).txt")()
    end
})

GarouTab:Button({
    Title = "Dio Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/ThanakritScript/StandUserCilent/main/DioBeta.lua")()
    end
})

GarouTab:Button({
    Title = "A-Train Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/main/ATrain.lua")()
    end
})

GarouTab:Button({
    Title = "Teleport Guy Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Teleport%20Guy.txt")()
    end
})

GarouTab:Button({
    Title = "Akaza Moveset",
    Callback = function()
        load("https://paste.ee/r/zzvAH")()
    end
})

GarouTab:Button({
    Title = "Angel V1.0 Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/93ddb1b1e2935bc76fbc37aae8985ad2/raw/47dfa45e1e8f1933a1c031b198d40c3cd1499fa2/gistfile1.txt")()
    end
})

GarouTab:Button({
    Title = "Light Yagami Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/35ca43410a2e96102f73dca904137973/raw/c4cb113194c35e0439151b06ea82dcc8053ff2c3/gistfile1.txt")()
    end
})

SonicTab:Button({
    Title = "1x1x1x1 Moveset (Buns)",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/900e87ffc32f3c740930ccb106dd6abf/raw/358c5bf0f0a6aa25946718288dab006e3ae7e1d4/gistfile1.txt")()
    end
})

GenosTab:Button({
    Title = "Genos Mastery",
    Callback = function()
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-mastery-32213")()
        Wait()
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-Mastery-ULT-32214")()
    end
})

AnyTab:Button({
    Title = "Star Glitcher Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/SG_DEMO.lua")()
    end
})