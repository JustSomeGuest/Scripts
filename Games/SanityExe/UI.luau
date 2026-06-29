if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function Get(Url)
    local ok, res = pcall(game.HttpGetAsync, game, Url)
    if ok then
        return res
    end
    return game:HttpGet(Url)
end

Shared.VoidUI = loadstring(Get("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Init.luau"))()

local UI = Shared.VoidUI

if not UI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

UI:SetTheme({
    Accent = "255, 255, 255"
})

UI:SetLogo("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Assets/sanity_logo.png")

local ListUrl = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
local PlaceId = game.PlaceId

local function LoadGame(Path)
    local Url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. Path
    local ok, Scr = pcall(function()
        return Get(Url)
    end)

    if ok and Scr then
        local Fn, Err = loadstring(Scr)
        if Fn then
            pcall(Fn)
        else
            warn("[Sanity.exe]: Error loading game script: " .. tostring(Err))
        end
    else
        warn("[Sanity.exe]: Failed to download game script: " .. Path)
        local Tab = UI:New("Tab", {
            Text = "Main"
        })
        UI:New("Label", {
            Text = "Error loading game!",
            Parent = Tab
        })
    end
end

local function LoadList()
    local ok, Data = pcall(function()
        return Get(ListUrl)
    end)

    if not ok or not Data then
        warn("[Sanity.exe]: Failed to load supported games list.")
        UI:SetTitle("Sanity.exe")
        local Tab = UI:New("Tab", {
            Text = "Main"
        })
        UI:New("Label", {
            Text = "Failed to load supported games list.",
            Parent = Tab
        })
        return
    end

    local Fn, Err = loadstring(Data)
    if not Fn then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(Err))
        UI:SetTitle("Sanity.exe")
        local Tab = UI:New("Tab", {
            Text = "Main"
        })
        UI:New("Label", {
            Text = "Error parsing supported games list.",
            Parent = Tab
        })
        return
    end

    local List = Fn()
    local Found = false

    for _, Game in ipairs(List) do
        if tostring(Game.PlaceId) == tostring(PlaceId) then
            Found = true
            UI:SetTitle("Sanity.exe • " .. Game.GameName)
            local Path = Game.FilePath
            if Path then
                LoadGame(Path)
            end
            break
        end
    end

    if not Found then
        UI:SetTitle("Sanity.exe")
        local Tab = UI:New("Tab", {
            Text = "Main"
        })
        UI:New("Label", {
            Text = "Game not supported.",
            Parent = Tab
        })
        UI:New("Divider", {
            Parent = Tab
        })
        UI:New("Label", {
            Text = "Supported Games:",
            Parent = Tab
        })

        for _, Game in ipairs(List) do
            UI:New("Button", {
                Text = Game.GameName .. " (" .. tostring(Game.PlaceId) .. ")",
                Parent = Tab,
                Callback = function()
                    setclipboard(tostring(Game.PlaceId))
                    warn("[Sanity.exe]: Place ID copied: " .. tostring(Game.PlaceId))
                end
            })
        end
    end
end

LoadList()