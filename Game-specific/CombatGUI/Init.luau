local function Load(Url)
    local Success, Result = pcall(game.HttpGetAsync, game, Url)
    return loadstring(Success and Result or game:HttpGet(Url))()
end

if game.GameId ~= 3808081382 then
    local UI = Load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")

    UI:Notify({
        Title = "CombatGUI+",
        Content = "This only works in The Strongest Battlegrounds",
        Duration = 4
    })

    return
end

local Success = pcall(function()
    local Disclaimer = Load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.lua")
    Disclaimer.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/CombatGUI/Script.luau"
    Disclaimer:Start()
end)

if not Success then
    Load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/CombatGUI/Script.luau")
end
