local function load(URL)
    return loadstring(game:HttpGet(URL))()
end

local ok = pcall(function()
    local Disclaimer = load("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Disclaimer.lua")
    Disclaimer.Script = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PolariaRM/Script.lua"
    Disclaimer:Start()
end)

if not ok then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/PolariaRM/Script.lua"))()
end
