if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Base = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/GelatekHubRM/"
local Scripts = Base .. "Scripts"
local FreeScripts = Base .. "Scripts/Free"
local HatScripts = Base .. "Scripts/Hat"
local Modules = Base .. "Modules"

Env.GelatekHubRM = Env.GelatekHubRM or {}

if Env.GelatekHubRM.IsLoaded then
    GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Gelatek Hub Remastered",
        Text = "Gelatek Hub Remastered is already running!",
        Duration = 4
    })
    return
end

Env.GelatekHubRM.IsLoaded = true

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Main/Source/Init.luau"))()

VoidUI:SetTitle("Gelatek Hub Remastered")

VoidUI:SetTheme({
    Accent = "255, 88, 91",
    BackgroundColor = "31, 31, 31",
    Secondary = "43, 43, 43",
    TextColor = "255, 255, 255",
    NonSelectedTextColor = "141, 141, 141"
})

local function SafeCall(func, ...)
    local ok, result = pcall(func, ...)
    if not ok then warn("[Gelatek Hub]: " .. tostring(result)) end
    return ok, result
end

local function HttpGet(Url)
    local HttpGet = game.HttpGetAsync or game.HttpGet
    return loadstring(HttpGet(game, Url))()
end

local WriteFile = writefile or function() return end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() return end

local function CheckAudioPackage()
    if not WriteFile or not IsFile or not MakeFolder or not IsFolder then
        warn("[Gelatek Hub Remastered]: Skipping audio package check - required file functions not available")
        return
    end

    if IsFolder("GelatekHubRemastered") then
        return
    end

    local ok, err = pcall(function()
        HttpGet(Modules .. "/Audios.luau")
    end)

    if not ok then
        warn("[Gelatek Hub]: Failed to install audio package: " .. tostring(err))
    end
end

SafeCall(CheckAudioPackage)

HttpGet(Modules .. "/Functions.luau")

local Games = {
    ["JaB"] = 123974602339071,
}

local function IsGame(gameName)
    local placeId = Games[gameName]
    if not placeId then return false end
    return game.PlaceId == placeId
end

Env.GelatekHubConfig = {
    PermanentDeath = false,
    TorsoFling = false,
    BulletFling = false,
    EnableCollisions = false,
    KeepHatsAttached = false,
    HeadlessOnPerma = false,
    Antivoid = false,
    AntivoidOffset = 75,
    DisableAnims = false,
}

local Players = GetService("Players")
local ReplicatedStorage = GetService("ReplicatedStorage")
local MarketplaceService = GetService("MarketplaceService")
local UserInputService = GetService("UserInputService")

local Player = Players.LocalPlayer
local Wait = task.wait

local function WaitForDeath()
    local character = Player.Character
    if not character then
        character = Player.CharacterAdded:Wait()
    end
    local humanoid = character:WaitForChild("Humanoid")
    local connection
    connection = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            connection:Disconnect()
        end
    end)
end

local Tab = VoidUI:New("Tab", {
    Text = "Home"
})

VoidUI:New("Section", {
    Parent = Tab,
    Text = "Welcome"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "Hello! Thanks for using our hub. We hope you enjoy it!"
})

VoidUI:New("Divider", {
    Parent = Tab
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "Current Version: 1.2"
})

VoidUI:New("Section", {
    Parent = Tab,
    Text = "How To Use Hat Scripts"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "1. Go to the Hats tab and click the hat(s) for your desired script"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "2. Go to Reanimation tab and enable:"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Permanent Death (Required)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Torso Fling or Bullet Fling (Optional)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Keep Hats Attached (Required)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Disable Animations (Required)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "3. Click Reanimate and wait until you have 0 health"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "4. Go to Scripts tab and click your desired hat script"
})

VoidUI:New("Divider", {
    Parent = Tab
})

VoidUI:New("Section", {
    Parent = Tab,
    Text = "How To Use Free Scripts"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "1. Go to Reanimation tab and enable:"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Permanent Death (Required)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Torso Fling or Bullet Fling (Optional)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "    • Disable Animations (Required)"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "2. Click Reanimate and wait until you have 0 health"
})

VoidUI:New("Label", {
    Parent = Tab,
    Text = "3. Go to Scripts tab and click your desired free script"
})

local ReanimationTab = VoidUI:New("Tab", {
    Text = "Reanimation"
})

VoidUI:New("Button", {
    Parent = ReanimationTab,
    Text = "Reanimate",
    Callback = function()
        if IsGame("JaB") then
            local CmdEvent = ReplicatedStorage:WaitForChild("01_server")
            
            if Env.GelatekHubConfig.PermanentDeath then
                CmdEvent:FireServer("cmd", "-pd")
            end

            Wait(2)

            if Env.GelatekHubConfig.KeepHatsAttached then
                CmdEvent:FireServer("cmd", "-net")
            end

            Wait(2)

            HttpGet(Modules .. "/Reanimate.luau")

            WaitForDeath()
            Wait(0.1)

            if Env.GelatekHubConfig.KeepHatsAttached then
                CmdEvent:FireServer("cmd", "-net")
            end
        else
            HttpGet(Modules .. "/Reanimate.luau")
        end
    end
})

VoidUI:New("Button", {
    Parent = ReanimationTab,
    Text = "Deanimate",
    Callback = function()
        SafeCall(function()
            StopScript()
            Wait(0.25)
            StopScript()
        end)
    end
})

VoidUI:New("Divider", {
    Parent = ReanimationTab
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Permanent Death",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.PermanentDeath = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Torso Fling",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.TorsoFling = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Bullet Fling",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.BulletFling = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Collisions",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.EnableCollisions = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Keep Hats Attached",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.KeepHatsAttached = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Headless On Permadeath",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.HeadlessOnPerma = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Disable Animations",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.DisableAnims = state
    end
})

VoidUI:New("Toggle", {
    Parent = ReanimationTab,
    Text = "Antivoid",
    Default = false,
    Callback = function(state)
        Env.GelatekHubConfig.Antivoid = state
    end
})

local ScriptsTab = VoidUI:New("Tab", {
    Text = "Scripts"
})

VoidUI:New("Section", {
    Parent = ScriptsTab,
    Text = "Free Scripts"
})

local function MakeScriptButton(text, path)
    VoidUI:New("Button", {
        Parent = ScriptsTab,
        Text = text,
        Callback = function()
            HttpGet(path)
        end
    })
end

MakeScriptButton("Gale Fighter", FreeScripts .. "/GaleFighter.luau")
MakeScriptButton("Ender", FreeScripts .. "/Ender.luau")
MakeScriptButton("Caducus", FreeScripts .. "/Caducus.luau")

VoidUI:New("Section", {
    Parent = ScriptsTab,
    Text = "Hat Scripts"
})

MakeScriptButton("Dual Ultima", HatScripts .. "/DualUltima.luau")
MakeScriptButton("Carnage", HatScripts .. "/Carnage.luau")
MakeScriptButton("Neptunian V", HatScripts .. "/Neptunian.luau")
MakeScriptButton("Zenith Battle Rifle-70", HatScripts .. "/ZenithAttackRifle.luau")
MakeScriptButton("Chips", HatScripts .. "/Chips.luau")
MakeScriptButton("Void Scythe", HatScripts .. "/VoidScythe.luau")
MakeScriptButton("Voodoo Doll", HatScripts .. "/VoodooDoll.luau")
MakeScriptButton("Quenox", HatScripts .. "/Quenox.luau")
MakeScriptButton("Goner", HatScripts .. "/Goner.luau")

local HatsTab = VoidUI:New("Tab", {
    Text = "Hats"
})

local function Copy(text)
    if type(setclipboard) ~= "function" then
        warn("[Gelatek Hub Remastered]: Executor doesn't support setclipboard")
        GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Gelatek Hub Remastered",
            Text = "Your executor doesn't support clipboard access!",
            Duration = 4
        })
        return
    end

    SafeCall(function()
        setclipboard(text)
        GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Gelatek Hub Remastered",
            Text = "Copied Hat Id!",
            Duration = 2
        })
    end)
end

local function MakeHatButton(text, ids)
    VoidUI:New("Button", {
        Parent = HatsTab,
        Text = text:gsub("^Copy", "Get"):gsub("Hat Id%(s%)", "Hat(s)"),
        Callback = function()
            if IsGame("JaB") then
                local CmdEvent = ReplicatedStorage:WaitForChild("01_server")
                CmdEvent:FireServer("cmd", "-gh " .. ids)
                Wait(2)
                CmdEvent:FireServer("cmd", "-net")
            else
                Copy(ids)
            end
        end
    })
end

MakeHatButton("Copy Dual Ultima Hat Id(s)", "4524991457,4820152700")
MakeHatButton("Copy Carnage Hat Id(s)", "5134896593,5410674378")
MakeHatButton("Copy Neptunian V Hat Id(s)", "112934510372081")
MakeHatButton("Copy Zenith Battle Rifle-70 Hat Id(s)", "4962510729,4962455546")
MakeHatButton("Copy Chips Hat Id(s)", "4964938812")
MakeHatButton("Copy Void Scythe Hat Id(s)", "5414429551")
MakeHatButton("Copy Voodoo Doll Hat Id(s)", "7218265043,7170689370")
MakeHatButton("Copy Quenox Hat Id(s)", "4820152700,4794315940,4524991457,4315489767,4458601937,4506945409")
MakeHatButton("Copy Goner Hat Id(s)", "6869866014")

local ExtraTab = VoidUI:New("Tab", {
    Text = "Extra"
})

VoidUI:New("Button", {
    Parent = ExtraTab,
    Text = "Shiftlock",
    Callback = function()
        HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Shiftlock/Init.luau")
    end
})

VoidUI:New("Button", {
    Parent = ExtraTab,
    Text = "TouchGui (Uses Keyboard Keys)",
    Callback = function()
        HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/TouchGui.luau")
    end
})

VoidUI:New("Button", {
    Parent = ExtraTab,
    Text = "Mobile Keyboard",
    Callback = function()
        HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/DeltaKD.luau")
    end
})

local CreditsTab = VoidUI:New("Tab", {
    Text = "Credits"
})

VoidUI:New("Label", {
    Parent = CreditsTab,
    Text = "Original Creator: Gelatekussy"
})

VoidUI:New("Label", {
    Parent = CreditsTab,
    Text = "Remastered By: JustSomeGuest"
})

VoidUI:New("Divider", {
    Parent = CreditsTab
})

VoidUI:New("Label", {
    Parent = CreditsTab,
    Text = "Special Thanks: Everyone who supported Gelatek Hub."
})

VoidUI:New("Divider", {
    Parent = CreditsTab
})

VoidUI:New("Label", {
    Parent = CreditsTab,
    Text = "This remaster is based on the original Gelatek Hub."
})

VoidUI:New("Label", {
    Parent = CreditsTab,
    Text = "Full credit for the original project and its foundation belongs to Gelatekussy."
})
