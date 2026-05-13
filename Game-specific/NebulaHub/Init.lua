local function load(URL)
    return loadstring(game:HttpGet(URL))()
end

if game.GameId == 3808081382 then
    local ok = pcall(function()
        local Disclaimer = load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.lua")
        Disclaimer.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/NebulaHub/Script.lua"
        Disclaimer:Start()
    end)

    if not ok then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Game-specific/NebulaHub/Script.lua"))()
    end
else
    local WindUI = load("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")

    WindUI:Notify({
        Title = "Nebula Hub",
        Content = "Nebula Hub only supports The Strongest Battlegrounds",
        Duration = 3
    })
end
