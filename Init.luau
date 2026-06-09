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

    local Loaded, Result = pcall(function()
        local Chunk = loadstring(Response)

        if not Chunk then
            error("loadstring returned nil")
        end

        return Chunk()
    end)

    if not Loaded then
        error(("[Init Error]: %s"):format(tostring(Result)), 0)
    end

    return Result
end

local Success, Err = pcall(function()
    GetScript(Repo .. "Universal/PlayerCTRL.luau")
end)

if not Success then
    error(("[Init Error]: %s"):format(tostring(Err)), 0)
end

local Scripts = {
    Lucid = "Universal/Lucid/Init.luau",
    PolariaRM = "Universal/PolariaRM/Init.luau",
    WallyWest = "Universal/WallyWest/Init.luau",
    Shiftlock = "Universal/Shiftlock/Init.luau",
    DeltaKD = "Universal/DeltaKD.luau",
    SoundDock = "Universal/SoundDock.luau",

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
