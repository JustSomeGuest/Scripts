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
        error(("[Init Error]: Failed to fetch script: %s"):format(tostring(Response)), 0)
    end

    local Chunk, Err = loadstring(Response)

    if not Chunk then
        error(("[Init Error]: %s"):format(tostring(Err)), 0)
    end

    local Loaded, Result = pcall(Chunk)

    if not Loaded then
        error(("[Init Error]: %s"):format(tostring(Result)), 0)
    end

    return Result
end

local Scripts = {
    Lucid = "Universal/Lucid/Init.luau",
    PolariaRM = "Universal/PolariaRM/Init.luau",
    GelatekHubRM = "Universal/GelatekHubRM.luau",
    WallyWest = "Universal/WallyWest/Init.luau",
    Shiftlock = "Universal/Shiftlock/Init.luau",
    SoundDock = "Universal/SoundDock.luau",
    DeltaKD = "Universal/DeltaKD.luau",

    CombatGUI = "Game-specific/CombatGUI/Init.luau",
    NebulaHub = "Game-specific/NebulaHub/Init.luau"
}

for Name, Path in pairs(Scripts) do
    Init[Name] = function()
        local Success, Result = pcall(function()
            return GetScript(Repo .. Path)
        end)

        if not Success then
            error(("[Init Error]: %s"):format(tostring(Result)), 0)
        end

        return Result
    end
end

return Init
