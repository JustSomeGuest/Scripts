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

local function HttpGet(url)
    local success, result = pcall(game.HttpGetAsync, game, url)
    if success then
        return result
    end
    return game:HttpGet(url)
end

local GuiService = Services.GuiService
local TeleportService = Services.TeleportService

GuiService:SetGameplayPausedNotificationEnabled(false)

local QueueOnTP
local queueSuccess, queueResult = pcall(function()
    return queue_on_teleport
end)

if queueSuccess then
    QueueOnTP = queueResult
else
    QueueOnTP = nil
end

Shared["Sanity.exe"] = Shared["Sanity.exe"] or {}

if Shared["Sanity.exe"].IsLoaded then
    return
end

Shared["Sanity.exe"].IsLoaded = true

local SUPPORTED_GAMES_URL = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau"
local CURRENT_PLACE_ID = game.PlaceId

local function LoadUI()
    local uiScript = HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/UI.luau")
    if uiScript then
        local loadFunc, loadError = loadstring(uiScript)
        if loadFunc then
            pcall(loadFunc)
        else
            warn("[Sanity.exe]: Error loading UI: " .. tostring(loadError))
        end
    else
        warn("[Sanity.exe]: Failed to download UI script")
    end
end

local success, gameListData = pcall(function()
    return HttpGet(SUPPORTED_GAMES_URL)
end)

if success and gameListData then
    local loadFunction, loadError = loadstring(gameListData)
    if loadFunction then
        local SupportedGames = loadFunction()
        local foundGame = false

        for _, gameInfo in ipairs(SupportedGames) do
            if tostring(gameInfo.PlaceId) == tostring(CURRENT_PLACE_ID) then
                foundGame = true
                break
            end
        end

        if foundGame then
            if QueueOnTP then
                pcall(function()
                    QueueOnTP('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau"))()')
                end)
            end
        else
            if QueueOnTP then
                pcall(function()
                    QueueOnTP('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau"))()')
                end)
            end
        end
    else
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(loadError))
    end
else
    warn("[Sanity.exe]: Failed to load supported games list")
end

LoadUI()