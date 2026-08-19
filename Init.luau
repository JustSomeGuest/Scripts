if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

Shared.Init = Shared.Init or {}
local Init = Shared.Init

local Repo = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/"

local function HttpGet(url)
    local success, source = pcall(function()
        return (game.HttpGetAsync or game.HttpGet)(game, url)
    end)

    if not success then
        return nil
    end

    local success, func = pcall(loadstring, source)

    if not success then
        return nil
    end

    local success, result = pcall(func)

    if not success then
        return nil
    end

    return result
end

local Scripts = {
    Lucid = "Universal/Lucid/Init.luau",
    PolariaRM = "Universal/PolariaRM/Init.luau",
    Shiftlock = "Universal/Shiftlock/Init.luau",
    SoundDock = "Universal/SoundDock.luau",
    DeltaKD = "Universal/DeltaKD.luau",
    Backpack = "Universal/Backpack.luau",
    TouchGui = "Universal/TouchGui.luau",

    GelatekHubRM = "Games/GelatekHubRM/Init.luau",
    SanityExe = "Games/SanityExe/Init.luau" --lowk forgot this existed
}

for Name, Path in pairs(Scripts) do
    Init[Name] = function(...)
        return HttpGet(Repo .. Path, ...)
    end
end

return Init