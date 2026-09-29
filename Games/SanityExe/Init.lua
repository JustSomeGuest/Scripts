if not game:IsLoaded() then
    game.Loaded:Wait()
end

pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/Notifs.lua"))

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local function Get(url)
    local ok, res = pcall(game.HttpGetAsync, game, url)
    if ok then
        return res
    end
    return game:HttpGet(url)
end

local TpSvc = GetService("TeleportService")

local QueueOnTP
local qok, qres = pcall(function()
    return queue_on_teleport
end)

if qok then
    QueueOnTP = qres
else
    QueueOnTP = nil
end

Env.__Sanity = Env.__Sanity or {}

if Env.__Sanity.IsLoaded then
    warn("[Sanity.exe]: Already loaded, skipping init")
    return
end

Env.__Sanity.IsLoaded = true

local function LoadUI()
    local scr = Get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/SanityExe/UI.lua")

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

local function LoadGames()
    local ok, data = pcall(function()
        return Get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/SanityExe/Games/Supported.lua")
    end)

    if not ok or not data then
        warn("[Sanity.exe]: Failed to load supported games list.")
        LoadUI()
        return
    end

    local fn, err = loadstring(data)

    if not fn then
        warn("[Sanity.exe]: Error parsing supported games list: " .. tostring(err))
        LoadUI()
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
        if QueueOnTP then
            pcall(function()
                QueueOnTP('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/SanityExe/Init.lua"))()')
            end)
        end
    else
        if QueueOnTP then
            pcall(function()
                QueueOnTP('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/SanityExe/Init.lua"))()')
            end)
        end
    end

    LoadUI()
end

LoadGames()
