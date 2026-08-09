if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

Shared.Init = Shared.Init or {}
local Init = Shared.Init

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function Load(URL)
    local Success, Source = pcall(game.HttpGetAsync, game, URL)

    if not Success then
        Success, Source = pcall(game.HttpGet, game, URL)
    end

    if not Success then
        error("[Init] Failed to fetch: " .. tostring(Source), 0)
    end

    local Script, Error = loadstring(Source)

    if not Script then
        error("[Init] Failed to load: " .. tostring(Error), 0)
    end

    local Success, Result = pcall(Script)

    if not Success then
        error("[Init] Script error: " .. tostring(Result), 0)
    end

    return Result
end

local Blacklist = Load(Repo .. "Blacklist/Init.luau")

if Blacklist.IsBlacklisted() then return end

pcall(Load, Repo .. "Tags.luau")

local Scripts = {
    Lucid = "Universal/Lucid/Init.luau",
    PolariaRM = "Universal/PolariaRM/Init.luau",
    GelatekHubRM = "Universal/GelatekHubRM/Init.luau",
    WallyWest = "Universal/WallyWest/Init.luau",
    Shiftlock = "Universal/Shiftlock/Init.luau",
    SoundDock = "Universal/SoundDock.luau",
    DeltaKD = "Universal/DeltaKD.luau",
    CoreGuiPlus = "Universal/CoreGuiPlus/Init.luau",
    Backpack = "Universal/Backpack.luau",
    TouchGui = "Universal/TouchGui.luau",

    SanityExe = "Games/SanityExe/Init.luau"
}

for Name, Path in pairs(Scripts) do
    Init[Name] = function(...)
        return Load(Repo .. Path, ...)
    end
end

return Init