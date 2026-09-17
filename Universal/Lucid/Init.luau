if not game:IsLoaded() then
    game.Loaded:Wait()
end

local env = (type(getgenv) == "function" and getgenv()) or shared or _G
env.Lucid = env.Lucid or {}

local versions = {
    "Classic",
    "Legacy",
    "Modern"
}

env.Lucid.Versions = versions
env.Lucid.Version = env.Lucid.Version or "Legacy"

local version = env.Lucid.Version

local valid = false
for _, allowed in versions do
    if version == allowed then
        valid = true
        break
    end
end

if not valid then
    error(("Invalid Lucid version: %s"):format(tostring(version)))
end

local httpget = game.HttpGetAsync or game.HttpGet
local src = httpget(game, "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/" .. version .. ".luau")

loadstring(src)()