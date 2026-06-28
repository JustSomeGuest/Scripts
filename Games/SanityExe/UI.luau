if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function expect(expected, value, fallback)
    if type(value) == expected then
        return value
    end

    if fallback ~= nil then
        if type(fallback) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fallback(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return fallback
end

local cloneref = expect("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local StarterGui = Services.StarterGui
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Players = Services.Players
local Player = Players.LocalPlayer
local Workspace = Services.Workspace
local HttpService = Services.HttpService
local RunService = Services.RunService

local function HttpGet(url)
    local success, result = pcall(game.HttpGetAsync, game, url)
    if success then
        return result
    end
    return game:HttpGet(url)
end

GuiService:SetGameplayPausedNotificationEnabled(false)

local QueueOnTP = expect("function", queue_on_teleport, warn("[Sanity.exe]: Executor doesn't support queue_on_teleport"))

Shared["Sanity.exe"] = Shared["Sanity.exe"] or {}

if Shared["Sanity.exe"].IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Sanity.exe",
        Text = "Sanity.exe is already running!",
        Duration = 4
    })
    return
end

Shared["Sanity.exe"].IsLoaded = true

local VoidUI = loadstring(HttpGet("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Stable/Source/Init.luau"))()
VoidUI:SetTitle("Sanity.exe")

local SUPPORTED_GAMES_URL = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
local CURRENT_PLACE_ID = game.PlaceId

local Tab = VoidUI:New("Tab", {
    Text = "Main"
})

local function LoadGameScript(filePath)
    local url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. filePath
    local success, gameScript = pcall(function()
        return HttpGet(url)
    end)

    if success and gameScript then
        local loadFunction, loadError = loadstring(gameScript)
        if loadFunction then
            pcall(loadFunction)
        else
            warn("[Sanity.exe]: Error loading game script: " .. tostring(loadError))
        end
    else
        warn("[Sanity.exe]: Failed to download game script: " .. filePath)
        VoidUI:New("Label", {
            Text = "Error loading game!",
            Parent = Tab
        })
    end
end

local function LoadSupportedGames()
    local success, gameListData = pcall(function()
        return HttpGet(SUPPORTED_GAMES_URL)
    end)

    if not success or not gameListData then
        warn("[Sanity.exe]: Failed to load supported games list.")
        VoidUI:New("Label", {
            Text = "Failed to load supported games list.",
            Parent = Tab
        })
        return
    end

    local loadFunction, loadError = loadstring(gameListData)
    if not loadFunction then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(loadError))
        VoidUI:New("Label", {
            Text = "Error parsing supported games list.",
            Parent = Tab
        })
        return
    end

    local SupportedGames = loadFunction()
    local foundGame = false

    for _, gameInfo in ipairs(SupportedGames) do
        if tostring(gameInfo.PlaceId) == tostring(CURRENT_PLACE_ID) then
            foundGame = true
            local gameFilePath = gameInfo.FilePath
            if gameFilePath then
                LoadGameScript(gameFilePath)
            end
            break
        end
    end

    if not foundGame then
        VoidUI:New("Label", {
            Text = "Game not supported.",
            Parent = Tab
        })
        VoidUI:New("Divider", {
            Parent = Tab
        })
        VoidUI:New("Label", {
            Text = "Supported Games:",
            Parent = Tab
        })

        for _, gameInfo in ipairs(SupportedGames) do
            VoidUI:New("Button", {
                Text = gameInfo.GameName .. " (" .. tostring(gameInfo.PlaceId) .. ")",
                Parent = Tab,
                Callback = function()
                    setclipboard(tostring(gameInfo.PlaceId))
                    warn("[Sanity.exe]: Place ID copied: " .. tostring(gameInfo.PlaceId))
                end
            })
        end
    end
end

if QueueOnTP then
    QueueOnTP('HttpService:GetAsync("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau")')
end

LoadSupportedGames()
