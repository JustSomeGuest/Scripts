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
env.Lucid.Version = env.Lucid.Version or "Modern"

local version = env.Lucid.Version
local valid

for _, allowed in versions do
    if version == allowed then
        valid = true
        break
    end
end

if not valid then
    error(("Invalid Lucid version: %s"):format(tostring(version)))
end

local CoreGui = game.StarterGui
local httpget = game.HttpGetAsync or game.HttpGet

local success, err = pcall(function()
    local source = httpget(game, "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/" .. version .. ".luau")
    loadstring(source)()
end)

if not success then
    CoreGui:SetCore("SendNotification", {
        Title = "Lucid",
        Text = "Failed to load " .. version .. " version.",
        Duration = 5
    })
end