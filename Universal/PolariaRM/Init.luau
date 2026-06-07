local function Load(Url)
    local Success, Result = pcall(game.HttpGetAsync, game, Url)
    return loadstring(Success and Result or game:HttpGet(Url))()
end

local Success = pcall(function()
    local Disclaimer = Load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.luau")
    Disclaimer.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PolariaRM/Script.luau"
    Disclaimer:Start()
end)

if not Success then
    Load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PolariaRM/Script.luau")
end
