local function load(URL)
    local ok, res = pcall(game.HttpGetAsync, game, URL)
    return loadstring(ok and res or game:HttpGet(URL))()
end

if game.GameId ~= 3808081382 then
    local WindUI = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")

    WindUI:Notify({
        Title = "CombatGUI+",
        Content = "CombatGUI+ only supports The Strongest Battlegrounds",
        Duration = 3
    })

    return
end

local ok = pcall(function()
    local Disclaimer = load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.lua")
    Disclaimer.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/CombatGUI/Script.lua"
    Disclaimer:Start()
end)

if not ok then
    load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/CombatGUI/Script.lua")
end
