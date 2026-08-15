if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

Shared.Init = Shared.Init or {}
local Init = Shared.Init

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function HttpGet(url)
    return loadstring((game.HttpGetAsync or game.HttpGet)(game, url))()
end

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
        return HttpGet(Repo .. Path, ...)
    end
end

return Init