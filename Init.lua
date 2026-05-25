getgenv().Init = {}
local Init = getgenv().Init

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function GetScript(URL)
    return loadstring(game:HttpGet(URL))()
end

pcall(function()
    GetScript(Repo .. "Universal/PlayerController/Init.lua")
end)

--// Universal
function Init.BetterKD()
    GetScript(Repo .. "Universal/BetterKD.lua")
end

function Init.KilobyteKD()
    GetScript(Repo .. "Universal/KilobyteKD.lua")
end

function Init.DeltaKD()
    GetScript(Repo .. "Universal/DeltaKD.lua")
end

function Init.MusicPLR()
    GetScript(Repo .. "Universal/MusicPLR.lua")
end

function Init.PolariaRM()
    GetScript(Repo .. "Universal/PolariaRM/Init.lua")
end

--// Game-specific
function Init.CombatGUI()
    GetScript(Repo .. "Game-specific/CombatGUI/Init.lua")
end

function Init.NebulaHub()
    GetScript(Repo .. "Game-specific/NebulaHub/Init.lua")
end

return Init
