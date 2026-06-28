if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function get(url)
    local ok, res = pcall(game.HttpGetAsync, game, url)
    if ok then
        return res
    end
    return game:HttpGet(url)
end

Shared.VoidUI = loadstring(get("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Init.luau"))()

local ui = Shared.VoidUI

if not ui then
  warn("[Sanity.exe]: Failed to load VoidUI")
  return
end

local LIST = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
local PID = game.PlaceId

local function loadGame(path)
    local url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. path
    local ok, scr = pcall(function()
        return get(url)
    end)

    if ok and scr then
        local fn, err = loadstring(scr)
        if fn then
            pcall(fn)
        else
            warn("[Sanity.exe]: Error loading game script: " .. tostring(err))
        end
    else
        warn("[Sanity.exe]: Failed to download game script: " .. path)
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
    local ok, data = pcall(function()
        return get(LIST)
    end)

    if not ok or not data then
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

    local fn, err = loadstring(data)
    if not fn then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(err))
        ui:SetTitle("Sanity.exe")
        local tab = ui:New("Tab", {
            Text = "Main"
        })
        ui:New("Label", {
            Text = "Error parsing supported games list.",
            Parent = tab
        })
        return
    end

    local list = fn()
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