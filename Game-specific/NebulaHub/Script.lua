local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function load(u)
    local s,r = pcall(game.HttpGetAsync, game, u)
    return loadstring(s and r or game:HttpGet(u))()
end

local ui = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
local lp = Players.LocalPlayer

local function Notify(txt)
    ui:Notify({
        Title = "Nebula Hub",
        Content = txt,
        Duration = 3
    })
end

ui:AddTheme({
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

local win = ui:CreateWindow({
    Title = "Nebula Hub",
    Author = "Just A Guest",
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

Notify('press "P" to open/close')

local saitama = win:Tab({
    Title = "Saitama",
    Icon = "sword"
})

local garou = win:Tab({
    Title = "Garou",
    Icon = "flame"
})

local sonic = win:Tab({
    Title = "Sonic",
    Icon = "zap"
})

local genos = win:Tab({
    Title = "Genos",
    Icon = "cpu"
})

local any = win:Tab({
    Title = "Any",
    Icon = "star"
})

local other = win:Tab({
    Title = "Other",
    Icon = "settings"
})

local antifling = {
    Enabled = false,
    Cons = {},
    Parts = {}
}

local function clearCons()
    for _,v in pairs(antifling.Cons) do
        v:Disconnect()
    end

    table.clear(antifling.Cons)
end

local function clearParts()
    for v in pairs(antifling.Parts) do
        if v and v.Parent then
            v.CanCollide = true
        end
    end

    table.clear(antifling.Parts)
end

local function setupPart(v)
    if not v:IsA("BasePart") then
        return
    end

    if lp.Character and v:IsDescendantOf(lp.Character) then
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

local function setupChar(char)
    for _,v in ipairs(char:GetDescendants()) do
        setupPart(v)
    end

    table.insert(antifling.Cons, char.DescendantAdded:Connect(setupPart))
end

local function setupPlayer(plr)
    if plr == lp then
        return
    end

    if plr.Character then
        setupChar(plr.Character)
    end

    table.insert(antifling.Cons, plr.CharacterAdded:Connect(setupChar))
end

local function enableAF()
    if antifling.Enabled then
        return
    end

    antifling.Enabled = true

    for _,p in ipairs(Players:GetPlayers()) do
        setupPlayer(p)
    end

    table.insert(antifling.Cons, Players.PlayerAdded:Connect(setupPlayer))

    table.insert(antifling.Cons, RunService.PreSimulation:Connect(function()
        for v in pairs(antifling.Parts) do
            if v and v.Parent then
                v.CanCollide = false
            else
                antifling.Parts[v] = nil
            end
        end
    end))

    Notify("antifling on")
end

local function disableAF()
    antifling.Enabled = false

    clearCons()
    clearParts()

    Notify("antifling off")
end

other:Toggle({
    Title = "AntiFling",
    Default = false,
    Callback = function(v)
        if v then
            enableAF()
        else
            disableAF()
        end
    end
})

other:Button({
    Title = "Fix Camera",
    Callback = function()
        local ok = pcall(function()
            local cam = workspace.CurrentCamera
            local char = lp.Character or lp.CharacterAdded:Wait()
            local hum = char:WaitForChild("Humanoid")

            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum

            lp.CameraMode = Enum.CameraMode.Classic
            hum.AutoRotate = true
        end)

        if ok then
            Notify("fixed")
        end
    end
})

saitama:Button({
    Title = "Naruto Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/LolnotaKid/NarutoBeatUpSasukeAss/main/NarutoCums")
    end
})

saitama:Button({
    Title = "Kratos Moveset",
    Callback = function()
        load("https://rawscripts.net/raw/KJ-The-Strongest-Battlegrounds-Kratos-By-Me-saitama-btw-29150")
    end
})

saitama:Button({
    Title = "Vexor Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/VEXOR.lua")
    end
})

saitama:Button({
    Title = "Yuji X Sukuna Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Sigma%20v2%20vessel%20tp")
    end
})

saitama:Button({
    Title = "Jun Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt")
    end
})

saitama:Button({
    Title = "Shinji Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Shinji%20tp%20exploit")
    end
})

saitama:Button({
    Title = "GoldenHead Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/main/Saitama%20to%20golden%20sigma")
    end
})

saitama:Button({
    Title = "Trashcan Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man")
    end
})

garou:Button({
    Title = "Garou X Suiryu Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/kjremaker/b092496fc11a57e2c50477154176fa3e/raw/2148f00a036a1799118541765675f3f6a0f8adae/GAROU%20TO%20SURIYU%20BETTER%20THAN%20THE%20OTHERS%20FR")
    end
})

garou:Button({
    Title = "Void Garou Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Void%20Reaper%20Obfuscated.txt")
    end
})

garou:Button({
    Title = "Mastery Deku Moveset",
    Callback = function()
        load("https://pastebin.com/raw/xKextYP5")
    end
})

garou:Button({
    Title = "Chainsaw-Man Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/CHAINSAW%20MAN/Chainsaw%20Man%20(Obfuscated).txt")
    end
})

garou:Button({
    Title = "Dio Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/ThanakritScript/StandUserCilent/main/DioBeta.lua")
    end
})

garou:Button({
    Title = "A-Train Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/main/ATrain.lua")
    end
})

garou:Button({
    Title = "Teleport Guy Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/yes1nt/yes/main/Teleport%20Guy.txt")
    end
})

garou:Button({
    Title = "Akaza Moveset",
    Callback = function()
        load("https://paste.ee/r/zzvAH")
    end
})

garou:Button({
    Title = "Angel V 1.0 Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/93ddb1b1e2935bc76fbc37aae8985ad2/raw/47dfa45e1e8f1933a1c031b198d40c3cd1499fa2/gistfile1.txt")
    end
})

garou:Button({
    Title = "Light Yagami Moveset",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/35ca43410a2e96102f73dca904137973/raw/c4cb113194c35e0439151b06ea82dcc8053ff2c3/gistfile1.txt")
    end
})

sonic:Button({
    Title = "1x1x1x1 Moveset (Low-key trash)",
    Callback = function()
        load("https://gist.githubusercontent.com/GoldenHeads2/900e87ffc32f3c740930ccb106dd6abf/raw/358c5bf0f0a6aa25946718288dab006e3ae7e1d4/gistfile1.txt")
    end
})

genos:Button({
    Title = "Genos Mastery",
    Callback = function()
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-mastery-32213")
        load("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Genos-Mastery-ULT-32214")
    end
})

any:Button({
    Title = "Star Glitcher Moveset",
    Callback = function()
        load("https://raw.githubusercontent.com/Reapvitalized/TSB/main/SG_DEMO.lua")
    end
})
