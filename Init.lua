if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().Init = getgenv().Init or {}
local Init = getgenv().Init

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function GetScript(URL)
    local Success, Response = pcall(game.HttpGetAsync, game, URL)

    if not Success then
        Success, Response = pcall(game.HttpGet, game, URL)
    end

    if not Success then
        error(string.format("Failed to fetch script: %s", URL))
    end

    return loadstring(Response)()
end

pcall(GetScript, Repo .. "Universal/PlayerController.luau")

--// Universal
function Init.Lucid()
    GetScript(Repo .. "Universal/Lucid/Init.luau")
end

function Init.PolariaRM()
    GetScript(Repo .. "Universal/PolariaRM/Init.luau")
end

function Init.WallyWest()
    GetScript(Repo .. "Universal/WallyWest/Init.luau")
end

function Init.Shiftlock()
    GetScript(Repo .. "Universal/Shiftlock/Init.luau")
end

function Init.DeltaKD()
    GetScript(Repo .. "Universal/DeltaKD.luau")
end

function Init.SoundDock()
    GetScript(Repo .. "Universal/SoundDock.luau")
end

--// Game-specific
function Init.CombatGUI()
    GetScript(Repo .. "Game-specific/CombatGUI/Init.luau")
end

function Init.NebulaHub()
    GetScript(Repo .. "Game-specific/NebulaHub/Init.luau")
end

return Init
