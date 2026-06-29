if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (function()
    local ok, env = pcall(getgenv)
    return (ok and env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function Check(t, val, fb)
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

local CloneRef = Check("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local ok, c = pcall(function()
            return CloneRef(game:GetService(name))
        end)
        if ok then
            rawset(self, name, c)
            return c
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local function Get(url)
    local ok, res = pcall(game.HttpGetAsync, game, url)
    if ok then
        return res
    end
    return game:HttpGet(url)
end

local GuiSvc = Services.GuiService
local TpSvc = Services.TeleportService

GuiSvc:SetGameplayPausedNotificationEnabled(false)

local QueueOnTP
local qok, qres = pcall(function()
    return queue_on_teleport
end)

if qok then
    QueueOnTP = qres
else
    QueueOnTP = nil
end

Shared["Sanity.exe"] = Shared["Sanity.exe"] or {}

if Shared["Sanity.exe"].IsLoaded then
    warn("[Sanity.exe]: Already loaded, skipping init")
    return
end

Shared["Sanity.exe"].IsLoaded = true

local Hui = select(2, pcall(gethui)) or warn("[Sanity.exe]: Failed to use gethui.")
local CoreGui = Services.CoreGui

local function FindTitle()
    local Title = nil
    if Hui then
        local VoidUI = Hui:FindFirstChild("VoidUI")
        if VoidUI then
            local Main = VoidUI:FindFirstChild("Main")
            if Main then
                local Topbar = Main:FindFirstChild("Topbar")
                if Topbar then
                    Title = Topbar:FindFirstChild("Title")
                end
            end
        end
    end
    
    if not Title and CoreGui then
        local VoidUI = CoreGui:FindFirstChild("VoidUI")
        if VoidUI then
            local Main = VoidUI:FindFirstChild("Main")
            if Main then
                local Topbar = Main:FindFirstChild("Topbar")
                if Topbar then
                    Title = Topbar:FindFirstChild("Title")
                end
            end
        end
    end
    
    return Title
end

local function OnDestroy(VoidUI)
    if VoidUI then
        VoidUI.AncestryChanged:Connect(function(_, Parent)
            if Parent == nil then
                Shared["Sanity.exe"].IsLoaded = false
            end
        end)
    end
end

local Title = FindTitle()
if Title and Title.Text and Title.Text:find("Sanity.exe") then
    OnDestroy(Title.Parent and Title.Parent.Parent and Title.Parent.Parent.Parent)
end

local function LoadUI()
    local scr = Get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/UI.luau")
    if scr then
        local fn, err = loadstring(scr)
        if fn then
            local ok, e = pcall(fn)
            if not ok then
                warn("[Sanity.exe]: UI execution error: " .. tostring(e))
            else
                task.wait(1)
                local Title = FindTitle()
                if Title and Title.Text and Title.Text:find("Sanity.exe") then
                    OnDestroy(Title.Parent and Title.Parent.Parent and Title.Parent.Parent.Parent)
                end
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
        return Get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.luau")
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

    LoadUI()
end

LoadGames()