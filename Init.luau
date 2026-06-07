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
        error(("Failed to fetch script: %s"):format(URL))
    end

    return loadstring(Response)()
end

pcall(GetScript, Repo .. "Universal/PlayerCTRL.luau")

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
        return GetScript(Repo .. Path)
    end
end

return Init
