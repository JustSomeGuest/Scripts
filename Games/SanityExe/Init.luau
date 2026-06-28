if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function check(t, val, fb)
    if type(val) == t then
        return val
    end

    if fb ~= nil then
        if type(fb) == "function" then
            return function(...)
                warn("[Expect]: Missing executor functionality. Using fallback function.")
                return fb(...)
            end
        end

        warn("[Expect]: Value has unexpected type. Using fallback value.")
    end

    return fb
end

local cref = check("function", cloneref, function(...) return ... end)

local svc = setmetatable({}, {
    __index = function(self, name)
        local ok, c = pcall(function()
            return cref(game:GetService(name))
        end)
        if ok then
            rawset(self, name, c)
            return c
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local function get(url)
    local ok, res = pcall(game.HttpGetAsync, game, url)
    if ok then
        return res
    end
    return game:HttpGet(url)
end

local gui = svc.GuiService
local tp = svc.TeleportService

gui:SetGameplayPausedNotificationEnabled(false)

local qtp
local qok, qres = pcall(function()
    return queue_on_teleport
end)

if qok then
    qtp = qres
else
    qtp = nil
end

Shared["Sanity.exe"] = Shared["Sanity.exe"] or {}

if Shared["Sanity.exe"].IsLoaded then
    warn("[Sanity.exe]: Already loaded, skipping init")
    return
end

Shared["Sanity.exe"].IsLoaded = true

local function loadUI()
    local scr = get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/UI.luau")
    if scr then
        local fn, err = loadstring(scr)
        if fn then
            local ok, e = pcall(fn)
            if not ok then
                warn("[Sanity.exe]: UI execution error: " .. tostring(e))
            end
        else
            warn("[Sanity.exe]: Error loading UI: " .. tostring(err))
        end
    else
        warn("[Sanity.exe]: Failed to download UI script")
    end
end

local function loadGames()
    local ok, data = pcall(function()
        return get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau")
    end)

    if not ok or not data then
        warn("[Sanity.exe]: Failed to load supported games list.")
        loadUI()
        return
    end

    local fn, err = loadstring(data)
    if not fn then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(err))
        loadUI()
        return
    end

    local list = fn()
    local found = false

    for _, g in ipairs(list) do
        if tostring(g.PlaceId) == tostring(game.PlaceId) then
            found = true
            break
        end
    end

    if found then
        if qtp then
            pcall(function()
                qtp('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau"))()')
            end)
        end
    else
        if qtp then
            pcall(function()
                qtp('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Init.luau"))()')
            end)
        end
    end

    loadUI()
end

loadGames()