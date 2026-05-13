local function load(u)
    local s,r = pcall(game.HttpGetAsync, game, u)
    return loadstring(s and r or game:HttpGet(u))()
end

if game.GameId ~= 3808081382 then
    local ui = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")

    ui:Notify({
        Title = "Nebula Hub",
        Content = "This only works in The Strongest Battlegrounds",
        Duration = 3
    })

    return
end

local worked = pcall(function()
    local d = load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.lua")
    d.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/NebulaHub/Script.lua"
    d:Start()
end)

if not worked then
    load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/NebulaHub/Script.lua")
end
