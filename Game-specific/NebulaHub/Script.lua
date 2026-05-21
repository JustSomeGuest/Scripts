if not game:IsLoaded() then game.Loaded:Wait() end

local function GetService(Service)
	repeat task.wait() until pcall(game.GetService, game, Service) 
	return game:GetService(Service)
end

local Players = GetService("Players")
local RunService = GetService("RunService")

local function Load(url)
    local s,r = pcall(game.HttpGetAsync, game, url)
    return loadstring(s and r or game:HttpGet(url))()
end

local WindUI = Load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
local Player = Players.LocalPlayer
local Wait = task.wait

local function Notify(txt)
    WindUI:Notify({
        Title = "Nebula Hub",
        Content = txt,
        Duration = 3
    })
end

WindUI:AddTheme({
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

local win = WindUI:CreateWindow({
    Title = "Nebula Hub",
    Author = "JustAGuest",
    Folder = "NebulaHub",
    Transparent = true,
    Theme = "Nebula",
    KeySystem = false,
    ToggleKey = Enum.KeyCode.P
})

win:EditOpenButton({
    Title = "Nebula",
    Icon = "star",
    CornerRadius = UDim.new(1,0),
    StrokeThickness = 2,
    Draggable = true,
    OnlyMobile = true
})

Notify('Press "P" to Open/Close')

local SaitamaTab = win:Tab({
    Title = "Saitama",
    Icon = "sword"
})

local GarouTab = win:Tab({
    Title = "Garou",
    Icon = "flame"
})

local SonicTab = win:Tab({
    Title = "Sonic",
    Icon = "zap"
})

local GenosTab = win:Tab({
    Title = "Genos",
    Icon = "cpu"
})

local AnyTab = win:Tab({
    Title = "Any",
    Icon = "star"
})

local OtherTab = win:Tab({
    Title = "Other",
    Icon = "settings"
})

local antifling = {
    Enabled = false,
    Cons = {},
    Parts = {}
}

local function ClearCons()
    for _,v in pairs(antifling.Cons) do
        v:Disconnect()
    end

    table.clear(antifling.Cons)
end

local function ClearParts()
    for v in pairs(antifling.Parts) do
        if v and v.Parent then
            v.CanCollide = true
        end
    end

    table.clear(antifling.Parts)
end

local function SetupPart(v)
    if not v:IsA("BasePart") then
        return
    end

    if Player.Character and v:IsDescendantOf(Player.Character) then
        return
    end

    antifling.Parts[v] = true
    v.CanCollide = false

    table.insert(antifling.Cons, v:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if antifling.Enabled and v.Parent then
            v.CanCollide = false
        end
    end))
end

local function SetupChar(char)
    for _,v in ipairs(char:GetDescendants()) do
        SetupPart(v)
    end

    table.insert(antifling.Cons, char.DescendantAdded:Connect(SetupPart))
end

local function SetupPlayer(plr)
    if plr == Player then
        return
    end

    if plr.Character then
        SetupChar(plr.Character)
    end

    table.insert(antifling.Cons, plr.CharacterAdded:Connect(SetupChar))
end

local function EnableAF()
    if antifling.Enabled then
        return
    end

    antifling.Enabled = true

    for _,p in ipairs(Players:GetPlayers()) do
        SetupPlayer(p)
    end

    table.insert(antifling.Cons, Players.PlayerAdded:Connect(SetupPlayer))

    table.insert(antifling.Cons, RunService.PreSimulation:Connect(function()
        for v in pairs(antifling.Parts) do
            if v and v.Parent then
                v.CanCollide = false
            else
                antifling.Parts[v] = nil
            end
        end
    end))

    Notify("AntiFling: On")
end

local function DisableAF()
    antifling.Enabled = false

    ClearCons()
    ClearParts()

    Notify("AntiFling: Off")
end

OtherTab:Toggle({
    Title = "AntiFling",
    Default = false,
    Callback = function(v)
        if v then
            EnableAF()
        else
            DisableAF()
        end
    end
})

local cameraFixConnection = nil

local function FixCamera()
    local cam = workspace.CurrentCamera
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    cam.CameraType = Enum.CameraType.Custom
    cam.CameraSubject = hum

    Player.CameraMode = Enum.CameraMode.Classic
    hum.AutoRotate = true
end

OtherTab:Toggle({
    Title = "Fix Camera",
    Default = false,
    Callback = function(v)
        if v then

            cameraFixConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
                if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
                    pcall(FixCamera)
                end
            end)
            
            cameraFixConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraMode"):Connect(function()
                pcall(FixCamera)
            end)
            
            pcall(FixCamera)
            Notify("Camera Fix: Auto mode enabled")
        else

            if cameraFixConnection then
                cameraFixConnection:Disconnect()
                cameraFixConnection = nil
            end
            Notify("Camera Fix: Auto mode disabled")
        end
    end
})

OtherTab:Button({
    Title = "Fix Camera (Once)",
    Callback = function()
        local ok = pcall(FixCamera)

        if ok then
            Notify("Camera: Fixed")
        end
    end
})

SaitamaTab:Button({
    Title = "Omni Man Moveset",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/UnVdDWcf"))()
    end
})

SaitamaTab:Button({
    Title = "Invincible Moveset",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/BtDQqi2c/raw"))()
    end
})

SaitamaTab:Button({
    Title = "Naruto Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/LolnotaKid/NarutoBeatUpSasukeAss/main/NarutoCums")
    end
})

SaitamaTab:Button({
    Title = "Kratos Moveset",
    Callback = function()
        Load("https://rawscripts.net/raw/KJ-The-Strongest-Battlegrounds-Kratos-By-Me-saitama-btw-29150")
    end
})

SaitamaTab:Button({
	Title = "Anti-Spiral Moveset",
	Callback = function()
		Load("https://raw.githubusercontent.com/sparksnaps/Anti-Spiral./main/Lua")
	end
})

SaitamaTab:Button({
    Title = "Vexor Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/VEXOR.lua")
    end
})

SaitamaTab:Button({
    Title = "Gojo V2 (Morph: On)",
    Callback = function()
        getgenv().morph = true 
        Load("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua")
    end
})

SaitamaTab:Button({
    Title = "Gojo V2 (Morph: Off)",
    Callback = function()
        getgenv().morph = false
        Load("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua")
    end
})

SaitamaTab:Button({
    Title = "Yuji X Sukuna Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Sigma%20v2%20vessel%20tp")
    end
})

SaitamaTab:Button({
    Title = "Jun Moveset",
    Callback = function()
        Load("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt")
    end
})

SaitamaTab:Button({
    Title = "Shinji Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Shinji%20tp%20exploit")
    end
})

SaitamaTab:Button({
    Title = "GoldenHead Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Saitama%20to%20golden%20sigma")
    end
})

SaitamaTab:Button({
    Title = "Trashcan Man Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man")
    end
})

GarouTab:Button({
    Title = "Garou X Suiryu Moveset",
    Callback = function()
        Load("https://gist.githubusercontent.com/kjremaker/b092496fc11a57e2c50477154176fa3e/raw/2148f00a036a1799118541765675f3f6a0f8adae/GAROU%20TO%20SURIYU%20BETTER%20THAN%20THE%20OTHERS%20FR")
    end
})

GarouTab:Button({
    Title = "Void Garou Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/yes1nt/yes/main/Void%20Reaper%20Obfuscated.txt")
    end
})

GarouTab:Button({
    Title = "Mastery Deku Moveset",
    Callback = function()
        Load("https://pastebin.com/raw/xKextYP5")
    end
})

GarouTab:Button({
    Title = "Chainsaw-Man Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/yes1nt/yes/main/CHAINSAW%20MAN/Chainsaw%20Man%20(Obfuscated).txt")
    end
})

GarouTab:Button({
    Title = "Dio Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/ThanakritScript/StandUserCilent/main/DioBeta.lua")
    end
})

GarouTab:Button({
    Title = "A-Train Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/main/ATrain.lua")
    end
})

GarouTab:Button({
    Title = "Teleport Guy Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/yes1nt/yes/main/Teleport%20Guy.txt")
    end
})

GarouTab:Button({
    Title = "Akaza Moveset",
    Callback = function()
        Load("https://paste.ee/r/zzvAH")
    end
})

GarouTab:Button({
    Title = "Angel V1.0 Moveset",
    Callback = function()
        Load("https://gist.githubusercontent.com/GoldenHeads2/93ddb1b1e2935bc76fbc37aae8985ad2/raw/47dfa45e1e8f1933a1c031b198d40c3cd1499fa2/gistfile1.txt")
    end
})

GarouTab:Button({
    Title = "Light Yagami Moveset",
    Callback = function()
        Load("https://gist.githubusercontent.com/GoldenHeads2/35ca43410a2e96102f73dca904137973/raw/c4cb113194c35e0439151b06ea82dcc8053ff2c3/gistfile1.txt")
    end
})

SonicTab:Button({
    Title = "1x1x1x1 Moveset (Buns)",
    Callback = function()
        Load("https://gist.githubusercontent.com/GoldenHeads2/900e87ffc32f3c740930ccb106dd6abf/raw/358c5bf0f0a6aa25946718288dab006e3ae7e1d4/gistfile1.txt")
	end
})

GenosTab:Button({
    Title = "Genos Mastery",
    Callback = function()
        Load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-mastery-32213")
		Wait()
        Load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-Mastery-ULT-32214")
    end
})

AnyTab:Button({
    Title = "Star Glitcher Moveset",
    Callback = function()
        Load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/SG_DEMO.lua")
    end
})
