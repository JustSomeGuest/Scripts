if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function get(url)
    local ok, res = pcall(game.HttpGetAsync, game, url)
    if not ok then
        ok, res = pcall(game.HttpGet, game, url)
    end
    
    if ok and res then
        local fn, err = loadstring(res)
        if fn then
            return fn()
        else
            warn("[Sanity.exe]: Failed to parse response from " .. url .. ": " .. tostring(err))
        end
    else
        warn("[Sanity.exe]: Failed to fetch " .. url)
    end
end

Shared.VoidUI = get("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Init.luau")

local ui = Shared.VoidUI

if not ui then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

ui:SetTheme({
    Accent = "255, 255, 255"
})

ui:SetLogo("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Assets/sanity_logo.png")

local LIST = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
local PID = game.PlaceId

local function loadGame(path)
    local url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. path
    local scr = get(url)
    
    if scr then
        local tab = ui:New("Tab", {
            Text = "Main"
        })
        ui:New("Label", {
            Text = "Error loading game!",
            Parent = tab
        })
    end
end

local function loadList()
    local list = get(LIST)

    if not list then
        warn("[Sanity.exe]: Failed to load supported games list.")
        ui:SetTitle("Sanity.exe")
        local tab = ui:New("Tab", {
            Text = "Main"
        })
        ui:New("Label", {
            Text = "Failed to load supported games list.",
            Parent = tab
        })
        return
    end

    local found = false

    for _, g in ipairs(list) do
        if tostring(g.PlaceId) == tostring(PID) then
            found = true
            ui:SetTitle("Sanity.exe • " .. g.GameName)
            local path = g.FilePath
            if path then
                loadGame(path)
            end
            break
        end
    end

    if not found then
        ui:SetTitle("Sanity.exe")
        local tab = ui:New("Tab", {
            Text = "Main"
        })
        ui:New("Label", {
            Text = "Game not supported.",
            Parent = tab
        })
        ui:New("Divider", {
            Parent = tab
        })
        ui:New("Label", {
            Text = "Supported Games:",
            Parent = tab
        })

        for _, g in ipairs(list) do
            ui:New("Button", {
                Text = g.GameName .. " (" .. tostring(g.PlaceId) .. ")",
                Parent = tab,
                Callback = function()
                    setclipboard(tostring(g.PlaceId))
                    warn("[Sanity.exe]: Place ID copied: " .. tostring(g.PlaceId))
                end
            })
        end
    end
end

loadList()