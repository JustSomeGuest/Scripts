local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function load(URL)
    local ok, res = pcall(game.HttpGetAsync, game, URL)
    local src = ok and res or game:HttpGet(URL)
    local fn = loadstring(src)
    if fn then
        local ok2, val = pcall(fn)
        return ok2 and val or nil
    end
end

local WindUI = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")

local LocalPlayer = Players.LocalPlayer

local function Notify(text)
    WindUI:Notify({
        Title = "Nebula Hub",
        Content = text,
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

local Window = WindUI:CreateWindow({
    Title = "Nebula Hub",
    Author = "Just A Guest",
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

Notify('Press "P" to toggle the UI')

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
    Tracked = {}
}

local function disconnectAll()
    for _,v in pairs(AntiFling.Connections) do
        if v then
            v:Disconnect()
        end
    end
    table.clear(AntiFling.Connections)
end

local function clearTracked()
    for v in pairs(AntiFling.Tracked) do
        if v and v.Parent then
            v.CanCollide = true
        end
    end
    table.clear(AntiFling.Tracked)
end

local function applyPart(v)
    if not v:IsA("BasePart") then
        return
    end

    if LocalPlayer.Character and v:IsDescendantOf(LocalPlayer.Character) then
        return
    end

    AntiFling.Tracked[v] = true
    v.CanCollide = false

    table.insert(AntiFling.Connections,v:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if AntiFling.Enabled and v.Parent then
            v.CanCollide = false
        end
    end))
end

local function setupCharacter(char)
    for _,v in ipairs(char:GetDescendants()) do
        applyPart(v)
    end

    table.insert(AntiFling.Connections,char.DescendantAdded:Connect(applyPart))
end

local function setupPlayer(plr)
    if plr == LocalPlayer then
        return
    end

    if plr.Character then
        setupCharacter(plr.Character)
    end

    table.insert(AntiFling.Connections,plr.CharacterAdded:Connect(setupCharacter))
end

local function enableAntiFling()
    if AntiFling.Enabled then
        return
    end

    AntiFling.Enabled = true

    for _,v in ipairs(Players:GetPlayers()) do
        setupPlayer(v)
    end

    table.insert(AntiFling.Connections,Players.PlayerAdded:Connect(setupPlayer))

    table.insert(AntiFling.Connections,RunService.PreSimulation:Connect(function()
        for v in pairs(AntiFling.Tracked) do
            if v and v.Parent then
                v.CanCollide = false
            else
                AntiFling.Tracked[v] = nil
            end
        end
    end))

    Notify("AntiFling Enabled")
end

local function disableAntiFling()
    if not AntiFling.Enabled then
        return
    end

    AntiFling.Enabled = false
    disconnectAll()
    clearTracked()

    Notify("AntiFling Disabled")
end

OtherTab:Toggle({
    Title = "AntiFling",
    Default = false,
    Callback = function(v)
        if v then
            enableAntiFling()
        else
            disableAntiFling()
        end
    end
})

OtherTab:Button({
    Title = "Fix Camera",
    Callback = function()
        pcall(function()
            local c = workspace.CurrentCamera
            local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local h = ch:WaitForChild("Humanoid")

            c.CameraType = Enum.CameraType.Custom
            c.CameraSubject = h

            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            h.AutoRotate = true

            Notify("Camera Fixed")
        end)
    end
})

SaitamaTab:Button({
    Title = "Naruto Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/LolnotaKid/NarutoBeatUpSasukeAss/main/NarutoCums")
    end
})

SaitamaTab:Button({
    Title = "Kratos Moveset",
    Callback = function()
        load("https://rawscripts.net/raw/KJ-The-Strongest-Battlegrounds-Kratos-By-Me-saitama-btw-29150")
    end
})

SaitamaTab:Button({
    Title = "Vexor Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/VEXOR.lua")
    end
})

SaitamaTab:Button({
    Title = "Yuji X Sukuna Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Sigma%20v2%20vessel%20tp")
    end
})

SaitamaTab:Button({
    Title = "Jun Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt")
    end
})

SaitamaTab:Button({
    Title = "Shinji Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Shinji%20tp%20exploit")
    end
})

SaitamaTab:Button({
    Title = "GoldenHead Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Saitama%20to%20golden%20sigma")
    end
})

SaitamaTab:Button({
    Title = "Trashcan Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man")
    end
})

GarouTab:Button({
    Title = "Garou X Suiryu Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/kjremaker/b092496fc11a57e2c50477154176fa3e/raw/2148f00a036a1799118541765675f3f6a0f8adae/GAROU%20TO%20SURIYU%20BETTER%20THAN%20THE%20OTHERS%20FR")
    end
})

GarouTab:Button({
    Title = "Void Garou Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Void%20Reaper%20Obfuscated.txt")
    end
})

GarouTab:Button({
    Title = "Mastery Deku Moveset",
    Callback = function()
        load("https://pastebin.com/raw/xKextYP5")
    end
})

GarouTab:Button({
    Title = "Chainsaw-Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/CHAINSAW%20MAN/Chainsaw%20Man%20(Obfuscated).txt")
    end
})

GarouTab:Button({
    Title = "Dio Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/ThanakritScript/StandUserCilent/main/DioBeta.lua")
    end
})

GarouTab:Button({
    Title = "A-Train Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/main/ATrain.lua")
    end
})

GarouTab:Button({
    Title = "Teleport Guy Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Teleport%20Guy.txt")
    end
})

GarouTab:Button({
    Title = "Akaza Moveset",
    Callback = function()
        load("https://paste.ee/r/zzvAH")
    end
})

GarouTab:Button({
    Title = "Angel V 1.0 Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/93ddb1b1e2935bc76fbc37aae8985ad2/raw/47dfa45e1e8f1933a1c031b198d40c3cd1499fa2/gistfile1.txt")
    end
})

GarouTab:Button({
    Title = "Light Yagami Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/35ca43410a2e96102f73dca904137973/raw/c4cb113194c35e0439151b06ea82dcc8053ff2c3/gistfile1.txt")
    end
})

SonicTab:Button({
    Title = "1x1x1x1 Moveset (Low-key trash)",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/900e87ffc32f3c740930ccb106dd6abf/raw/358c5bf0f0a6aa25946718288dab006e3ae7e1d4/gistfile1.txt")
    end
})

GenosTab:Button({
    Title = "Genos Mastery",
    Callback = function()
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-mastery-32213")
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-Mastery-ULT-32214")
    end
})

AnyTab:Button({
    Title = "Star Glitcher Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/SG_DEMO.lua")
    end
})
