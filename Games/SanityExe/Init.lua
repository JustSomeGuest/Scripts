if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local function Get(Url)
    local ok, res = pcall(game.HttpGetAsync, game, Url)
    if ok then
        return res
    end
    return game:HttpGet(Url)
end

pcall(loadstring, Get("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/Notifs.lua"))

Env.__Sanity = Env.__Sanity or {}

if Env.__Sanity.IsLoaded then
    warn("[Sanity.exe]: Already loaded, skipping init")
    return
end

Env.__Sanity.IsLoaded = true

local QueueOnTP
local qok, qres = pcall(function()
    return queue_on_teleport
end)

if qok then
    QueueOnTP = qres
end

local VoidUI = loadstring(Get("https://raw.githubusercontent.com/JustSomeGuest/VoidUI/Main/Source/Init.lua"))()

if not VoidUI then
    warn("[Sanity.exe]: Failed to load VoidUI")
    return
end

Env.VoidUI = VoidUI

local UI = Env.VoidUI

UI:SetTheme("Minimal")

local ListUrl = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/Supported.lua"
local PlaceId = game.PlaceId

local function LoadGame(Path)
    local Url = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/SanityExe/Games/" .. Path

    local ok, Scr = pcall(function()
        return Get(Url)
    end)

    if ok and Scr then
        local Fn, Err = loadstring(Scr)

        if Fn then
            local success, Error = pcall(Fn)

            if not success then
                warn("[Sanity.exe]: Game script execution error: " .. tostring(Error))
            end
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

    for _, Game in ipairs(List) do
        if tostring(Game.PlaceId) == tostring(PlaceId) then
            UI:SetTitle("Sanity.exe • " .. Game.GameName)

            if QueueOnTP then
                pcall(function()
                    QueueOnTP('loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Games/SanityExe/Init.lua"))()')
                end)
            end

            if Game.File then
                LoadGame(Game.File)
            end

            return
        end
    end

    UI:SetTitle("Sanity.exe")
    UI:SetTheme("Midnight")

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

LoadList()