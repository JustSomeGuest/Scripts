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
GuiService:SetGameplayPausedNotificationEnabled(false)

local TPService = Services.TeleportService
local QueueOnTP = expect("function", queue_on_teleport, warn("[Sanity.exe]: Executor doesn't support queue_on_teleport"))

HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/UI.luau")

if QueueOnTP then
    QueueOnTP('HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau")')
end
