if not game:IsLoaded() then
    game.Loaded:Wait()
end

local env = (type(getgenv) == "function" and getgenv()) or shared or _G

local versions = {
    "Classic",
    "Legacy",
    "Modern"
}

local version = env.__Lucid_Version or "Modern"
local valid

for _, allowed in versions do
    if string.lower(version) == string.lower(allowed) then
        version = allowed
        valid = true
        break
    end
end

if not valid then
    error(("Invalid Lucid version: %s"):format(tostring(env.__Lucid_Version)))
end

local startergui = game.StarterGui
local httpget = game.HttpGetAsync or game.HttpGet

local success, err = pcall(function()
    local source = httpget(game, "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/" .. version .. ".luau")
    loadstring(source)()
end)

if not success then
    startergui:SetCore("SendNotification", {
        Title = "Lucid",
        Text = ("Failed to load %s version."):format(version),
        Duration = 5
    })

    warn(("[Lucid]: Failed to load %s version.\nError: \n%s"):format(version, tostring(err)))
end