if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Hui = gethui and gethui() or GetService("CoreGui")
local Workspace = GetService("Workspace")
local HttpService = GetService("HttpService")
local Players = GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = GetService("UserInputService")
local TweenService = GetService("TweenService")
local StarterGui = GetService("StarterGui")
local RunService = GetService("RunService")

local WriteFile = writefile or function() end
local ReadFile = readfile or function() end
local DelFile = delfile or function() end
local IsFile = isfile or function() end
local IsFolder = isfolder or function() end
local MakeFolder = makefolder or function() end
local ListFiles = listfiles or function() end
local LoadAsset = getcustomasset or getsynasset or function() end
local SetClipboard = setclipboard or function() end
local Wait = task.wait

local GothamBold = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local GothamMedium = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local BuilderSans = Font.new([[rbxasset://fonts/families/BuilderSans.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local Inconsolata = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local HighlightColors = {
    Keyword = "#F86D7C",
    Number = "#FFC66D",
    String = "#A5E075",
    Comment = "#7F8C98",
    Global = "#84D6F7",
    Function = "#F8D66D",
    Property = "#D7BA7D",
    Class = "#4EC9B0",
    Enum = "#C586C0",
    EnumItem = "#B8D7FF",
    Operator = "#D4D4D4",
    Identifier = "#E6E6E6",
    Nil = "#569CD6",
    Boolean = "#569CD6"
}

local function MkCorner(r, p) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 0) c.Parent = p return c end
local function MkStroke(col, p) local s = Instance.new("UIStroke") s.Color = col s.Parent = p return s end
local function MkPad(l, r, t, b, p) local pad = Instance.new("UIPadding") pad.PaddingLeft = UDim.new(0, l or 0) pad.PaddingRight = UDim.new(0, r or 0) pad.PaddingTop = UDim.new(0, t or 0) pad.PaddingBottom = UDim.new(0, b or 0) pad.Parent = p return pad end
local function MkList(dir, pad, p) local l = Instance.new("UIListLayout") l.FillDirection = dir or Enum.FillDirection.Vertical l.Padding = UDim.new(0, pad or 0) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p return l end
local function MkSize(minV, maxV, p) local s = Instance.new("UISizeConstraint") if minV then s.MinSize = minV end if maxV then s.MaxSize = maxV end s.Parent = p return s end
local function MkAspect(ratio, p) local a = Instance.new("UIAspectRatioConstraint") a.AspectRatio = ratio or 1 a.Parent = p return a end
local function MkEl(class, props, parent) local o = Instance.new(class) for k, v in pairs(props) do o[k] = v end o.Parent = parent return o end

local UI = {}
local Funcs = {}
local Assets = {
    ["Lucid/Assets/Lucid_Logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Logo.png",
    ["Lucid/Assets/Lucid_Home.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Home.png",
    ["Lucid/Assets/Lucid_Executor.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Controller.png",
    ["Lucid/Assets/Lucid_Search.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Search.png",
    ["Lucid/Assets/Lucid_Scripts.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/LocalFile.png",
    ["Lucid/Assets/Lucid_Music.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Music.png",
    ["Lucid/Assets/Lucid_Settings.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Settings.png",
    ["Lucid/Assets/Lucid_Close.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Close.png",
    ["Lucid/Assets/Lucid_Execute.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Execute.png",
    ["Lucid/Assets/Lucid_Clear.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Clear.png",
    ["Lucid/Assets/Lucid_Clipboard.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Clipboard.png",
    ["Lucid/Assets/Lucid_Star.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Star.png",
    ["Lucid/Assets/Lucid_Discord.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Discord.png",
}
local Settings = {
    Animations = true,
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10),
    AccentColor = Color3.fromRGB(0, 99, 255),
    SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
}

local LucidLoaded = false
do
    local prev = Env.__Lucid or Env.Lucid
    if prev ~= nil then
        local ok, wasLoaded = pcall(function() return prev.IsLoaded end)
        if ok and wasLoaded == true then LucidLoaded = true end
    end
    Env.Lucid = nil
    local proxy
    if type(newproxy) == "function" then
        local ok, pr = pcall(newproxy, true)
        if ok and type(pr) == "userdata" then
            local mt = getmetatable(pr)
            mt.__index = function(_, k) if k == "IsLoaded" then return LucidLoaded end return nil end
            mt.__newindex = function() end
            proxy = pr
        end
    end
    Env.__Lucid = proxy or setmetatable({}, {
        __index = function(_, k) if k == "IsLoaded" then return LucidLoaded end return nil end,
        __newindex = function() end
    })
end
local currentPage = 1
local totalPages = 1
local currentQuery = ""

Funcs.Sources = {"RScripts", "ScriptBlox"}
Funcs.CurrentSource = "RScripts"
Funcs.Filters = {"All", "Key", "Keyless"}
Funcs.CurrentFilter = "All"
Funcs.CurrentScripts = {}

local ExeTabs = {}
local ExeTabCounter = 0
local ExeActiveTab = nil

local MusicSound = nil
local MusicFiles = {}
local MusicIndex = 1
local MusicPlaying = false
local MusicSliderDragging = false

local Keywords = {
    "local", "function", "if", "then", "else", "elseif", "end", "for", "while",
    "repeat", "until", "do", "return", "break", "continue", "in", "not", "and",
    "or", "nil", "true", "false", "type", "typeof", "export"
}

local Globals = {
    "game", "workspace", "script", "Instance", "Enum", "Color3", "Vector2",
    "Vector3", "UDim", "UDim2", "CFrame", "math", "string", "table", "task",
    "coroutine", "os", "utf8", "ipairs", "pairs", "next", "pcall", "xpcall",
    "tonumber", "tostring", "warn", "print", "require", "select", "rawequal",
    "rawget", "rawset", "type", "unpack", "assert", "error", "getfenv",
    "setfenv", "getmetatable", "setmetatable", "loadstring", "load", "collectgarbage",
    "gcinfo", "newproxy", "delay", "spawn", "tick", "time", "date", "clock",
    "BrickColor", "NumberSequence", "ColorSequence", "NumberRange", "Random",
    "Rect", "Region3", "TweenService", "RunService", "Players", "ReplicatedStorage",
    "ServerScriptService", "ServerStorage", "Lighting", "SoundService", "StarterGui",
    "StarterPack", "StarterPlayer", "TeleportService", "DataStoreService",
    "HttpService", "MarketplaceService", "UserInputService", "ContextActionService",
    "CollectionService", "Debris", "PhysicsService"
}

local KeywordSet = {}
for _, v in ipairs(Keywords) do KeywordSet[v] = true end
local GlobalSet = {}
for _, v in ipairs(Globals) do GlobalSet[v] = true end

function Funcs.Highlight(code)
    if type(code) ~= "string" then return "" end
    local result = {}
    local i = 1
    local len = #code
    while i <= len do
        local char = code:sub(i, i)
        if char == "\"" or char == "'" then
            local start = i
            local quote = char
            i = i + 1
            while i <= len do
                if code:sub(i, i) == "\\" then
                    i = i + 2
                elseif code:sub(i, i) == quote then
                    i = i + 1
                    break
                else
                    i = i + 1
                end
            end
            local str = code:sub(start, i - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.String .. "\">" .. str .. "</font>")
        elseif char == "[" and code:sub(i, i + 1) == "[[" then
            local start = i
            local depth = 0
            while i <= len do
                if code:sub(i, i + 1) == "[[" then depth = depth + 1; i = i + 2
                elseif code:sub(i, i + 1) == "]]" then depth = depth - 1; i = i + 2; if depth == 0 then break end
                else i = i + 1 end
            end
            local str = code:sub(start, i - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.String .. "\">" .. str .. "</font>")
        elseif char == "-" and code:sub(i, i + 1) == "--" then
            if code:sub(i, i + 3) == "--[[" then
                local start = i
                i = i + 4
                local depth = 0
                while i <= len do
                    if code:sub(i, i + 1) == "[[" then depth = depth + 1; i = i + 2
                    elseif code:sub(i, i + 1) == "]]" then depth = depth - 1; i = i + 2; if depth == 0 then break end
                    else i = i + 1 end
                end
                local str = code:sub(start, i - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Comment .. "\">" .. str .. "</font>")
            else
                local start = i
                while i <= len do
                    local ch = code:sub(i, i)
                    if ch == "\n" or ch == "\r" then break end
                    i = i + 1
                end
                local str = code:sub(start, i - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Comment .. "\">" .. str .. "</font>")
            end
        elseif char:match("%d") then
            local start = i
            while i <= len do
                local ch = code:sub(i, i)
                if not ch:match("%d") and ch ~= "." then break end
                i = i + 1
            end
            local str = code:sub(start, i - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.Number .. "\">" .. str .. "</font>")
        elseif char:match("%a") or char == "_" then
            local start = i
            while i <= len do
                local ch = code:sub(i, i)
                if not ch:match("%w") and ch ~= "_" then break end
                i = i + 1
            end
            local word = code:sub(start, i - 1)
            local safe = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            if word == "nil" then
                table.insert(result, "<font color=\"" .. HighlightColors.Nil .. "\">" .. safe .. "</font>")
            elseif word == "true" or word == "false" then
                table.insert(result, "<font color=\"" .. HighlightColors.Boolean .. "\">" .. safe .. "</font>")
            elseif KeywordSet[word] then
                table.insert(result, "<font color=\"" .. HighlightColors.Keyword .. "\">" .. safe .. "</font>")
            elseif GlobalSet[word] then
                table.insert(result, "<font color=\"" .. HighlightColors.Global .. "\">" .. safe .. "</font>")
            else
                local nextChar = code:sub(i, i)
                if nextChar == "(" then
                    table.insert(result, "<font color=\"" .. HighlightColors.Function .. "\">" .. safe .. "</font>")
                else
                    table.insert(result, "<font color=\"" .. HighlightColors.Identifier .. "\">" .. safe .. "</font>")
                end
            end
        else
            if char == "&" then table.insert(result, "&amp;")
            elseif char == "<" then table.insert(result, "&lt;")
            elseif char == ">" then table.insert(result, "&gt;")
            else table.insert(result, char) end
            i = i + 1
        end
    end
    return table.concat(result)
end

function Funcs.HideExec()
    local Safe = {
        RobloxGui = true, PlayerList = true, ExperienceChat = true,
        BubbleChat = true, DevConsole = true, SocialService = true,
        PerformanceStats = true, ScreenShotTool = true, EmotesMenu = true,
        CallDialogScreen = true, CaptureManager = true, CaptureOverlay = true,
        Composer = true, ContactList = true, Chat = true,
        HeadsetDisconnectedDialog = true, InExperienceInterventionApp = true,
        PlayerMenuScreen = true, PurchasePromptApp = true, RobloxPromptGui = true,
        ScreenshotsCarousel = true, TeleportEffectGui = true, TopBarApp = true,
        ControlGui = true, VehicleGui = true, NotificationGui = true,
        DescendantProtector = true, AppUpdaterGui = true, FaceTrackingGui = true,
        ExperienceNotificationGui = true, VoiceChatGui = true, SafetyCheckGui = true,
        ToastGui = true, InGameMenuV2 = true, RightClickMenu = true,
        VoiceChatPromptGui = true, BottomBarGui = true, GuiService = true,
        FullscreenTitleBar = true, TextureView = true, ChromeGui = true,
        BlockingApp = true, HealthGui = true, StutterDetector = true,
        AvatarContextMenuItem = true
    }

    local function IsSus(Name)
        if #Name > 30 then
            return true
        end

        if Name:match("[^%w%s%-%.]") then
            return true
        end

        local Caps = select(2, Name:gsub("[A-Z]", ""))

        return Caps >= 5
    end

    local function Scan(Parent)
        if not Parent then
            return
        end

        for _, Obj in ipairs(Parent:GetDescendants()) do
            if Obj:IsA("ScreenGui")
                and Obj ~= UI.ScreenGui
                and not Safe[Obj.Name]
                and IsSus(Obj.Name) then
                pcall(function()
                    Obj.Enabled = false
                end)
            end
        end
    end

    Scan(gethui())
end

Funcs.HideExec()

function Funcs.UID(Length)
    Length = Length or 64

    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = table.create(Length)

    for i = 1, Length do
        local Rand = math.random(1, #Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end

    return table.concat(Id)
end

function Funcs.HttpGet(url)
    local RequestFunc = (syn and syn.request) or request or http_request
    if not RequestFunc then return nil end

    local Success, Result = pcall(function()
        return RequestFunc({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Lucid-Executor/1.0",
                ["Accept"] = "application/json"
            }
        })
    end)

    return Success and Result or nil
end

function Funcs.GetAsset(Path)
    if not LoadAsset then return nil end
    if not IsFolder("Lucid") then MakeFolder("Lucid") end
    if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
    if Path:match("^rbxassetid://") then return Path end
    if IsFile(Path) then return LoadAsset(Path) end
    local url = Assets[Path]
    if not url then return nil end
    local Response = Funcs.HttpGet(url)
    if not Response or not Response.Body then return nil end
    WriteFile(Path, Response.Body)
    return LoadAsset(Path)
end

function Funcs.PreloadAssets()
    if not IsFolder("Lucid") then MakeFolder("Lucid") end
    if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
    for path, url in pairs(Assets) do
        if not IsFile(path) then
            local Response = Funcs.HttpGet(url)
            if Response and Response.Body then
                WriteFile(path, Response.Body)
            end
        end
    end
end

function Funcs.SanitizeName(name)
    if not name then return "Script_" .. HttpService:GenerateGUID(false):sub(1, 8) end
    local cleaned = ""
    for char in name:gmatch(".") do
        local byte = string.byte(char)
        if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) or (byte >= 48 and byte <= 57) then
            cleaned = cleaned .. char
        end
    end
    if cleaned == "" then cleaned = "Script_" .. HttpService:GenerateGUID(false):sub(1, 8) end
    return cleaned
end

function Funcs.ClearCache()
    if IsFolder("Lucid/Cache") then
        local files = ListFiles("Lucid/Cache")
        for _, file in ipairs(files) do
            pcall(function() DelFile(file) end)
        end
    end
end

local ScriptsFolder = "Lucid/Scripts"
local BuiltInFolder = ScriptsFolder .. "/BuiltIn"

local BuiltInScripts = {
    {
        Name        = "Dexium (Built-In)",
        File        = "Dexium.json",
        Description = "A fast instance viewer that lets you browse, inspect and search every object in the game in real time.",
        Source      = 'loadstring(game:HttpGet("https://rbxscriptz.pages.dev/scripts/dexium"))()'
    },
    {
        Name        = "Mobile Keyboard (Built-In)",
        File        = "Keyboard.json",
        Description = "An on-screen keyboard that lets mobile users send keyboard inputs by clicking the corresponding keys on the UI.",
        Source      = 'loadstring(game:HttpGet("https://rbxscriptz.pages.dev/scripts/deltakd"))()'
    },
    {
        Name        = "Cobalt (Built-In)",
        File        = "Cobalt.json",
        Description = "A remote spy that shows every remote you fire and every remote you receive.",
        Source      = 'loadstring(game:HttpGet("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))()'
    },
    {
        Name        = "IY Reborn (Built-In)",
        File        = "IYReborn.json",
        Description = "Infinite Yield Reborn, an admin script packed with 500+ admin commands.",
        Source      = 'loadstring(game:HttpGet("https://rbxscriptz.pages.dev/scripts/infinite-yield-reborn"))()'
    },
    {
        Name        = "PShade Ultimate (Built-In)",
        File        = "PShadeUltimate.json",
        Description = "One of the best shader scripts you could find.",
        Source      = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/pshade-ultimate/main/src/cd.lua"))()'
    }
}
for _, scriptData in ipairs(BuiltInScripts) do
    scriptData.File = scriptData.File or scriptData.Name:gsub("[^%w]", "_") .. ".json"
end

local function EncodeScriptJSON(scriptData)
    return "{\n"
        .. '    "Name": ' .. HttpService:JSONEncode(tostring(scriptData.Name or "")) .. ",\n"
        .. '    "Description": ' .. HttpService:JSONEncode(tostring(scriptData.Description or "")) .. ",\n"
        .. '    "Source": ' .. HttpService:JSONEncode(tostring(scriptData.Source or "")) .. "\n"
        .. "}"
end

local function NormalizeScript(data)
    return {
        Name = tostring(data.Name or ""),
        Description = tostring(data.Description or ""),
        Source = tostring(data.Source or data.Code or data.Script or "")
    }
end

function Funcs.LoadSavedScripts()
    Funcs.InitDefaultScripts()
    local scripts = {}
    local function ReadFolder(folder, builtIn)
        if not IsFolder(folder) then return end
        for _, file in ipairs(ListFiles(folder) or {}) do
            local readOk, content = pcall(ReadFile, file)
            if readOk then
                local success, data = pcall(function() return HttpService:JSONDecode(content) end)
                if success and type(data) == "table" and data.Name then
                    local scriptData = NormalizeScript(data)
                    if builtIn then scriptData.BuiltIn = true end
                    local encoded = EncodeScriptJSON(scriptData)
                    if content ~= encoded then pcall(WriteFile, file, encoded) end
                    table.insert(scripts, scriptData)
                end
            end
        end
    end
    ReadFolder(ScriptsFolder, false)
    ReadFolder(BuiltInFolder, true)
    return scripts
end

local function StripBuiltIn(name)
    name = tostring(name or "")
    name = name:gsub("%f[%a][Bb]uilt[%s%-_]*[Ii]n%f[%A]", "")
    name = name:gsub("%(%s*%)", "")
    name = name:gsub("%s+", " ")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    return name ~= "" and name or "Untitled Script"
end

function Funcs.SaveScript(scriptData)
    if not IsFolder(ScriptsFolder) then MakeFolder(ScriptsFolder) end
    local sd = NormalizeScript(scriptData)
    sd.Name = StripBuiltIn(sd.Name)
    WriteFile(ScriptsFolder .. "/" .. sd.Name:gsub("[^%w]", "_") .. ".json", EncodeScriptJSON(sd))
end

function Funcs.DeleteScript(scriptName)
    local fileName = ScriptsFolder .. "/" .. scriptName:gsub("[^%w]", "_") .. ".json"
    if IsFile(fileName) then DelFile(fileName) end
    for _, scriptData in ipairs(BuiltInScripts) do
        if scriptData.Name == scriptName then
            local path = BuiltInFolder .. "/" .. scriptData.File
            if IsFile(path) then DelFile(path) end
        end
    end
end

function Funcs.InitDefaultScripts()
    if not IsFolder(ScriptsFolder) then MakeFolder(ScriptsFolder) end
    if not IsFolder(BuiltInFolder) then MakeFolder(BuiltInFolder) end
    for _, file in ipairs(ListFiles(ScriptsFolder) or {}) do
        local base = file:match("([^/\\]+)$") or file
        if base:find("_Built_In_%.json$") or base:find("Built%-In") then pcall(DelFile, file) end
    end
    for _, scriptData in ipairs(BuiltInScripts) do
        local path = BuiltInFolder .. "/" .. scriptData.File
        local expected = EncodeScriptJSON(scriptData)
        local readOk, content = pcall(ReadFile, path)
        if not readOk or content ~= expected then
            pcall(DelFile, path)
            WriteFile(path, expected)
        end
    end
end

function Funcs.ParseColor(input)
    if type(input) ~= "string" then return nil end
    local r, g, b = input:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r and g and b then return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
    return nil
end

function Funcs.SaveSettings()
    if not IsFolder("Lucid") then MakeFolder("Lucid") end
    local data = {
        Animations = Settings.Animations,
        BackgroundColor = {R = math.floor(Settings.BackgroundColor.R * 255), G = math.floor(Settings.BackgroundColor.G * 255), B = math.floor(Settings.BackgroundColor.B * 255)},
        SecondaryBackgroundColor = {R = math.floor(Settings.SecondaryBackgroundColor.R * 255), G = math.floor(Settings.SecondaryBackgroundColor.G * 255), B = math.floor(Settings.SecondaryBackgroundColor.B * 255)},
        AccentColor = {R = math.floor(Settings.AccentColor.R * 255), G = math.floor(Settings.AccentColor.G * 255), B = math.floor(Settings.AccentColor.B * 255)},
        SecondaryAccentColor = {R = math.floor(Settings.SecondaryAccentColor.R * 255), G = math.floor(Settings.SecondaryAccentColor.G * 255), B = math.floor(Settings.SecondaryAccentColor.B * 255)}
    }
    local ok, existing = pcall(function()
        if not IsFile("Lucid/Settings.json") then return nil end
        return HttpService:JSONDecode(ReadFile("Lucid/Settings.json"))
    end)
    if ok and type(existing) == "table" then
        for k, v in pairs(existing) do
            if data[k] == nil then data[k] = v end
        end
    end
    WriteFile("Lucid/Settings.json", HttpService:JSONEncode(data))
end

local function DeriveSecondaryAccent(accent)
    local k = 0.65
    return Color3.fromRGB(accent.R * 255 * k, accent.G * 255 * k, accent.B * 255 * k)
end

function Funcs.LoadSettings()
    if not IsFile("Lucid/Settings.json") then return end
    local content = ReadFile("Lucid/Settings.json")
    if not content or content == "" then return end
    local success, data = pcall(function() return HttpService:JSONDecode(content) end)
    if success and data then
        if data.Animations ~= nil then Settings.Animations = data.Animations end
        local bg = data.BackgroundColor or data.BGColor
        if bg then Settings.BackgroundColor = Color3.fromRGB(bg.R or 10, bg.G or 10, bg.B or 10) end
        local bg2 = data.SecondaryBackgroundColor or data.BG2Color
        if bg2 then Settings.SecondaryBackgroundColor = Color3.fromRGB(bg2.R or 18, bg2.G or 18, bg2.B or 18) end
        if data.AccentColor then Settings.AccentColor = Color3.fromRGB(data.AccentColor.R or 0, data.AccentColor.G or 99, data.AccentColor.B or 255) end
        if data.SecondaryAccentColor then
            Settings.SecondaryAccentColor = Color3.fromRGB(data.SecondaryAccentColor.R or 0, data.SecondaryAccentColor.G or 64, data.SecondaryAccentColor.B or 180)
        elseif data.AccentColor then
            Settings.SecondaryAccentColor = DeriveSecondaryAccent(Settings.AccentColor)
        end
    end
end

function Funcs.ScriptRequiresKey(data)
    local value = Funcs.CurrentSource == "ScriptBlox" and data.key or data.keySystem
    if type(value) == "boolean" then return value end
    if type(value) == "number" then return value ~= 0 end
    if type(value) == "string" then
        local normalized = value:lower()
        if normalized == "" or normalized == "false" or normalized == "0" or normalized == "none" or normalized == "n/a" then return false end
        if normalized:find("no key", 1, true) or normalized:find("keyless", 1, true) then return false end
        return true
    end
    return value ~= nil and value ~= false
end

function Funcs.PassesFilter(data)
    local requiresKey = Funcs.ScriptRequiresKey(data)
    if Funcs.CurrentFilter == "Key" then return requiresKey
    elseif Funcs.CurrentFilter == "Keyless" then return not requiresKey end
    return true
end

function Funcs.ResolveImage(data)
    local raw = data.image or data.imageUrl or data.thumbnail or (data.game and (data.game.imageUrl or data.game.image)) or ""
    if raw == "" then return "" end
    if raw:match("^https?://") then return raw end
    if raw:sub(1, 2) == "//" then return "https:" .. raw end
    local base = Funcs.CurrentSource == "ScriptBlox" and "https://scriptblox.com" or "https://rscripts.net"
    if raw:sub(1, 1) == "/" then return base .. raw end
    return base .. "/" .. raw
end

function Funcs.FetchScripts(query, page)
    page = page or 1
    local url
    if Funcs.CurrentSource == "RScripts" then
        url = "https://rscripts.net/api/v2/scripts?page=" .. page .. "&orderBy=date&sort=desc"
        if query ~= "" then url = url .. "&q=" .. HttpService:UrlEncode(query) end
    else
        if query ~= "" then
            url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&page=" .. page
        else
            url = "https://scriptblox.com/api/script/fetch?page=" .. page
        end
    end
    local Response = Funcs.HttpGet(url)
    if not Response or not Response.Body then return nil, nil end
    local success, decoded = pcall(function() return HttpService:JSONDecode(Response.Body) end)
    if not success or not decoded then return nil, nil end
    local scripts, pages
    if Funcs.CurrentSource == "RScripts" then
        scripts = decoded.scripts or {}
        pages = decoded.info and decoded.info.maxPages or 1
    else
        local result = decoded.result or {}
        scripts = result.scripts or {}
        pages = result.totalPages or 1
    end
    return scripts, pages
end

function Funcs.CreateResultCard(data, parent)
    local title = data.title or data.name or "Untitled Script"
    local isScriptBlox = Funcs.CurrentSource == "ScriptBlox"
    local rawScript = isScriptBlox and (data.script or "") or (data.rawScript or data.raw or "")

    local clone = UI.SearchResultTemplate:Clone()
    clone.Name = Funcs.SanitizeName(title)
    clone.Visible = true
    clone.Parent = parent

    local cloneStroke = clone:FindFirstChildOfClass("UIStroke")
    if cloneStroke then cloneStroke.Color = Settings.SecondaryAccentColor end

    local scriptImage = clone:FindFirstChild("ScriptImage")
    if scriptImage then scriptImage.Image = Funcs.ResolveImage(data) end

    local container = clone:FindFirstChild("Container")
    if container then
        local scriptName = container:FindFirstChild("ScriptName")
        if scriptName then
            scriptName.Text = title
            local nameStroke = scriptName:FindFirstChildOfClass("UIStroke")
            if nameStroke then nameStroke.Color = Settings.AccentColor end
        end
    end

    local actionsFrame = container and container:FindFirstChild("ScriptActions")
    if actionsFrame then
        local runBtn = actionsFrame:FindFirstChild("RunScript")
        local copyBtn = actionsFrame:FindFirstChild("CopyScriptBtn")
        local saveBtn = actionsFrame:FindFirstChild("SaveScriptBtn")

        for _, btn in ipairs({runBtn, copyBtn, saveBtn}) do
            if btn then
                btn.BackgroundColor3 = Settings.AccentColor
                local btnStroke = btn:FindFirstChildOfClass("UIStroke")
                if btnStroke then btnStroke.Color = Settings.SecondaryAccentColor end
            end
        end

        local function ResolveCode()
            if rawScript == "" then return nil end
            if isScriptBlox then return rawScript end
            local success, content = pcall(function() return game:HttpGet(rawScript) end)
            return success and content or nil
        end

        if runBtn then
            runBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    local fn, loadErr = loadstring(code)
                    if not fn then error(loadErr) end
                    local success, runErr = pcall(fn)
                    if not success then error(runErr) end
                end
            end)
        end
        if copyBtn then
            copyBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    SetClipboard(code)
                    copyBtn.Text = "Copied!"
                    task.delay(1, function() copyBtn.Text = "Copy" end)
                end
            end)
        end
        if saveBtn then
            saveBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    local scriptData = { Name = title, Description = data.description or "", Source = code }
                    Funcs.SaveScript(scriptData)
                    saveBtn.Text = "Saved!"
                    task.delay(1, function() saveBtn.Text = "Save" end)
                    Funcs.RefreshSavedScripts(UI.SearchBox2.Text)
                end
            end)
        end
    end
end

function Funcs.RenderSearchResults()
    local results = UI.SearchResults
    if not results then return end
    for _, child in ipairs(results:GetChildren()) do
        if child ~= UI.NoResultsLabel and child ~= UI.SearchResultsPadding and child ~= UI.SearchResultsLayout and child ~= UI.SearchResultTemplate then
            child:Destroy()
        end
    end
    local shown = 0
    for _, data in ipairs(Funcs.CurrentScripts) do
        if Funcs.PassesFilter(data) then
            shown = shown + 1
            Funcs.CreateResultCard(data, results)
        end
    end
    if shown == 0 then
        if UI.NoResultsLabel then
            UI.NoResultsLabel.Visible = true
            if #Funcs.CurrentScripts == 0 then
                UI.NoResultsLabel.Text = (currentQuery ~= "") and "No scripts found matching your query." or "No scripts found."
            else
                UI.NoResultsLabel.Text = "No scripts match the current filter."
            end
        end
    elseif UI.NoResultsLabel then
        UI.NoResultsLabel.Visible = false
    end
end

function Funcs.PerformSearch(query, page)
    page = page or 1
    currentQuery = query
    currentPage = page
    if UI.NoResultsLabel then UI.NoResultsLabel.Visible = false end
    UI.PrevBtn.Visible = false
    UI.NextBtn.Visible = false
    local scripts, pages = Funcs.FetchScripts(query, page)
    if not scripts then
        Funcs.CurrentScripts = {}
        Funcs.RenderSearchResults()
        if UI.NoResultsLabel then
            UI.NoResultsLabel.Visible = true
            UI.NoResultsLabel.Text = "Failed to fetch scripts. Check your connection and try again."
        end
        return
    end
    totalPages = pages or 1
    Funcs.CurrentScripts = scripts
    UI.PrevBtn.Visible = page > 1
    UI.NextBtn.Visible = page < totalPages
    Funcs.RenderSearchResults()
end

function Funcs.CycleSource()
    local index = table.find(Funcs.Sources, Funcs.CurrentSource) or 1
    Funcs.CurrentSource = Funcs.Sources[index % #Funcs.Sources + 1]
    if Funcs.CurrentSource == "RScripts" then
        UI.SourceBtn.Text = "🟢 Source: RScripts"
    else
        UI.SourceBtn.Text = "⚠️ Source: ScriptBlox"
    end
    Funcs.PerformSearch(currentQuery, 1)
end

function Funcs.CycleFilter()
    local index = table.find(Funcs.Filters, Funcs.CurrentFilter) or 1
    Funcs.CurrentFilter = Funcs.Filters[index % #Funcs.Filters + 1]
    UI.FilterBtn.Text = "Filter: " .. Funcs.CurrentFilter
    Funcs.RenderSearchResults()
end

function Funcs.ApplyTheme()
    UI.MainFrame.BackgroundColor3 = Settings.BackgroundColor
    UI.HomeContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.ExeContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.SearchContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.ScriptsContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.SettingsContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.MusicContent.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.Sidebar.BackgroundColor3 = Settings.SecondaryBackgroundColor

    UI.HomeContentStroke.Color = Settings.AccentColor
    UI.ExeContentStroke.Color = Settings.AccentColor
    UI.SearchContentStroke.Color = Settings.AccentColor
    UI.ScriptsContentStroke.Color = Settings.AccentColor
    UI.SettingsContentStroke.Color = Settings.AccentColor
    UI.MusicContentStroke.Color = Settings.AccentColor
    UI.SidebarStroke.Color = Settings.AccentColor
    UI.NewScriptFrameStroke.Color = Settings.AccentColor

    UI.Title.TextColor3 = Settings.AccentColor
    UI.TitleStroke.Color = Settings.AccentColor
    UI.Icon.ImageColor3 = Settings.AccentColor
    UI.Logo.ImageColor3 = Settings.SecondaryAccentColor

    UI.TabUnderline.BackgroundColor3 = Settings.AccentColor
    UI.TabUnderline2.BackgroundColor3 = Settings.AccentColor
    UI.TabUnderline3.BackgroundColor3 = Settings.AccentColor
    UI.TabUnderline4.BackgroundColor3 = Settings.AccentColor
    UI.TabUnderline5.BackgroundColor3 = Settings.AccentColor
    UI.TabUnderline6Music.BackgroundColor3 = Settings.AccentColor

    UI.NoResultsLabelStroke.Color = Settings.AccentColor
    UI.NoSavedScriptsLabelStroke.Color = Settings.AccentColor
    UI.SearchResultTemplateStroke.Color = Settings.SecondaryAccentColor
    UI.ScriptNameStroke.Color = Settings.AccentColor
    UI.SavedScriptTemplateStroke.Color = Settings.SecondaryAccentColor

    UI.ExeBtn.BackgroundColor3 = Settings.AccentColor
    UI.ClrBtn.BackgroundColor3 = Settings.AccentColor
    UI.CopyBtn.BackgroundColor3 = Settings.AccentColor
    UI.RunScript.BackgroundColor3 = Settings.AccentColor
    UI.CopyScriptBtn.BackgroundColor3 = Settings.AccentColor
    UI.SaveScriptBtn.BackgroundColor3 = Settings.AccentColor
    UI.PrevBtn.BackgroundColor3 = Settings.AccentColor
    UI.NextBtn.BackgroundColor3 = Settings.AccentColor
    UI.Cancel.BackgroundColor3 = Settings.AccentColor
    UI.Save.BackgroundColor3 = Settings.AccentColor
    UI.RunSavedScript.BackgroundColor3 = Settings.AccentColor
    UI.DeleteSavedScript.BackgroundColor3 = Settings.AccentColor
    UI.SourceBtn.BackgroundColor3 = Settings.AccentColor
    UI.FilterBtn.BackgroundColor3 = Settings.AccentColor
    UI.AddExeTabBtn.BackgroundColor3 = Settings.AccentColor

    UI.ExeBtnStroke.Color = Settings.SecondaryAccentColor
    UI.ClrBtnStroke.Color = Settings.SecondaryAccentColor
    UI.CopyBtnStroke.Color = Settings.SecondaryAccentColor
    UI.RunScriptStroke.Color = Settings.SecondaryAccentColor
    UI.CopyScriptBtnStroke.Color = Settings.SecondaryAccentColor
    UI.SaveScriptBtnStroke.Color = Settings.SecondaryAccentColor
    UI.PrevBtnStroke.Color = Settings.SecondaryAccentColor
    UI.NextBtnStroke.Color = Settings.SecondaryAccentColor
    UI.CancelStroke.Color = Settings.SecondaryAccentColor
    UI.SaveStroke.Color = Settings.SecondaryAccentColor
    UI.RunSavedScriptStroke.Color = Settings.SecondaryAccentColor
    UI.DeleteSavedScriptStroke.Color = Settings.SecondaryAccentColor
    UI.SourceBtnStroke.Color = Settings.SecondaryAccentColor
    UI.FilterBtnStroke.Color = Settings.SecondaryAccentColor
    UI.AddExeTabBtnStroke.Color = Settings.SecondaryAccentColor

    UI.WelcomeLabelStroke.Color = Settings.AccentColor
    UI.InfoLabelStroke.Color = Settings.SecondaryAccentColor
    UI.InfoLabel2Stroke.Color = Settings.SecondaryAccentColor
    UI.PlayerHeadshotStroke.Color = Settings.SecondaryAccentColor

    UI.MusicPlayBtn.BackgroundColor3 = Settings.AccentColor
    UI.MusicPrevBtn.BackgroundColor3 = Settings.AccentColor
    UI.MusicNextBtn.BackgroundColor3 = Settings.AccentColor
    UI.MusicPlayBtnStroke.Color = Settings.SecondaryAccentColor
    UI.MusicPrevBtnStroke.Color = Settings.SecondaryAccentColor
    UI.MusicNextBtnStroke.Color = Settings.SecondaryAccentColor
    UI.MusicNowPlayingStroke.Color = Settings.SecondaryAccentColor
    UI.MusicSliderBar.BackgroundColor3 = Settings.SecondaryBackgroundColor
    UI.MusicSliderFill.BackgroundColor3 = Settings.AccentColor
    UI.MusicSliderKnob.BackgroundColor3 = Settings.AccentColor

    if not Settings.Animations then
        UI.ToggleState.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        local stroke = UI.ToggleState:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(255, 0, 0) end
    else
        UI.ToggleState.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        local stroke = UI.ToggleState:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(0, 255, 0) end
    end

    for _, tabData in ipairs(ExeTabs) do
        if tabData.tabBtn then
            local activeStroke = tabData.tabBtn:FindFirstChild("ActiveLine")
            if activeStroke then
                activeStroke.BackgroundColor3 = Settings.AccentColor
            end
        end
    end

    if UI.SearchResults then Funcs.RenderSearchResults() end
    if UI.SavedScriptsScroll then Funcs.RefreshSavedScripts(UI.SearchBox2 and UI.SearchBox2.Text or "") end
end

function Funcs.UpdateStats()
    local username = Player.Name or "Unknown"
    local displayName = Player.DisplayName or "Unknown"
    local userId = Player.UserId or 0
    local fps = math.floor(workspace:GetRealPhysicsFPS() or 0)
    local ping = Player:GetNetworkPing() and math.floor(Player:GetNetworkPing() * 1000) or 0
    local memory = math.floor(collectgarbage("count") / 1024) or 0
    local playerCount = #Players:GetPlayers() or 0
    local maxPlayers = Players.MaxPlayers or 0
    local serverAge = math.floor((os.time() - workspace.DistributedGameTime) / 60) or 0
    local placeId = game.PlaceId or 0
    local gameId = game.GameId or "Unknown"
    local jobId = game.JobId or "Unknown"

    local infoText = string.format([[Username: %s
Display Name: %s
User ID: %s

FPS: %s
Ping: %s ms
Memory: %s MB

Players: %s/%s
Server Age: %s mins
Job ID: %s

Place ID: %s
Game ID: %s]], username, displayName, userId, fps, ping, memory, playerCount, maxPlayers, serverAge, jobId, placeId, gameId)

    if UI.InfoLabel then UI.InfoLabel.Text = infoText end
    if UI.WelcomeLabel then UI.WelcomeLabel.Text = "Welcome to Lucid, " .. displayName .. "!" end
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    if UI.PlayerHeadshot then UI.PlayerHeadshot.Image = avatarUrl end
end

function Funcs.RefreshSavedScripts(searchQuery)
    local scroll = UI.SavedScriptsScroll
    if not scroll then return end
    for _, child in ipairs(scroll:GetChildren()) do
        if child ~= UI.NoSavedScriptsLabel and child ~= UI.SavedScriptsScrollPadding and child ~= UI.SavedScriptsScrollLayout and child ~= UI.SavedScriptTemplate then
            child:Destroy()
        end
    end
    local scripts = Funcs.LoadSavedScripts()
    if searchQuery and searchQuery ~= "" then
        local filtered = {}
        local query = searchQuery:lower()
        for _, scriptData in ipairs(scripts) do
            local name = (scriptData.Name or ""):lower()
            local desc = (scriptData.Description or ""):lower()
            if name:find(query) or desc:find(query) then table.insert(filtered, scriptData) end
        end
        scripts = filtered
    end
    if #scripts == 0 then
        if UI.NoSavedScriptsLabel then
            UI.NoSavedScriptsLabel.Visible = true
            UI.NoSavedScriptsLabel.Text = (searchQuery and searchQuery ~= "") and "No saved scripts match your search." or "No Saved Scripts\n\nSave some scripts to see them here."
        end
        return
    end
    if UI.NoSavedScriptsLabel then UI.NoSavedScriptsLabel.Visible = false end
    local builtInScripts = {}
    local normalScripts = {}
    for _, scriptData in ipairs(scripts) do
        if scriptData.BuiltIn then
            table.insert(builtInScripts, scriptData)
        else
            table.insert(normalScripts, scriptData)
        end
    end
    table.sort(builtInScripts, function(a, b) return (a.Name or ""):lower() < (b.Name or ""):lower() end)
    table.sort(normalScripts, function(a, b) return (a.Name or ""):lower() < (b.Name or ""):lower() end)
    local function MakeCard(scriptData)
        local clone = UI.SavedScriptTemplate:Clone()
        clone.Name = Funcs.SanitizeName(scriptData.Name)
        clone.Visible = true
        clone.Parent = scroll
        local cloneStroke = clone:FindFirstChildOfClass("UIStroke")
        if cloneStroke then cloneStroke.Color = Settings.SecondaryAccentColor end
        local infoFrame = clone:FindFirstChild("SavedScriptInfo")
        if infoFrame then
            local titleLabel = infoFrame:FindFirstChild("SavedScriptTitle")
            local descLabel = infoFrame:FindFirstChild("SavedScriptDesc")
            if titleLabel then titleLabel.Text = scriptData.Name or "Unknown" end
            if descLabel then descLabel.Text = scriptData.Description or "No description" end
        end
        local actionsFrame = clone:FindFirstChild("SavedScriptActions")
        if actionsFrame then
            local runBtn = actionsFrame:FindFirstChild("RunSavedScript")
            local deleteBtn = actionsFrame:FindFirstChild("DeleteSavedScript")
            for _, btn in ipairs({runBtn, deleteBtn}) do
                if btn then
                    btn.BackgroundColor3 = Settings.AccentColor
                    local btnStroke = btn:FindFirstChildOfClass("UIStroke")
                    if btnStroke then btnStroke.Color = Settings.SecondaryAccentColor end
                end
            end
            if runBtn then
                runBtn.MouseButton1Click:Connect(function()
                    local fn, loadErr = loadstring(scriptData.Source or "")
                    if not fn then error(loadErr) end
                    local success, runErr = pcall(fn)
                    if not success then error(runErr) end
                end)
            end
            if deleteBtn then
                deleteBtn.MouseButton1Click:Connect(function()
                    Funcs.DeleteScript(scriptData.Name)
                    Funcs.RefreshSavedScripts(UI.SearchBox2.Text)
                end)
            end
        end
    end
    for _, scriptData in ipairs(builtInScripts) do MakeCard(scriptData) end
    for _, scriptData in ipairs(normalScripts) do MakeCard(scriptData) end
end

function Funcs.SwitchTab(tabButton)
    local contentMap = {
        [UI.HomeTab] = UI.HomeContent,
        [UI.ExeTab] = UI.ExeContent,
        [UI.SearchTab] = UI.SearchContent,
        [UI.ScriptsTab] = UI.ScriptsContent,
        [UI.SettingsTab] = UI.SettingsContent,
        [UI.MusicTab] = UI.MusicContent,
    }
    local newContent = contentMap[tabButton]
    if not newContent then return end
    local oldContent = nil
    for tab, content in pairs(contentMap) do
        if content and content ~= newContent and content.Visible then
            oldContent = content
            break
        end
    end
    if oldContent == newContent then return end
    if oldContent then oldContent.Visible = false end
    newContent.Visible = true
    if Settings.Animations then
        newContent.Position = UDim2.new(-1, 0, 0, 0)
        TweenService:Create(newContent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    else
        newContent.Position = UDim2.new(0, 0, 0, 0)
    end
    if newContent == UI.HomeContent then Funcs.UpdateStats() end
    if newContent == UI.ScriptsContent then Funcs.RefreshSavedScripts(UI.SearchBox2.Text) end
    if newContent == UI.MusicContent then Funcs.RefreshMusicList() end
end

function Funcs.UpdateUnderline(tabButton, active)
    local underline = tabButton:FindFirstChild("TabUnderline") or tabButton:FindFirstChild("TabUnderline2") or tabButton:FindFirstChild("TabUnderline3") or tabButton:FindFirstChild("TabUnderline4") or tabButton:FindFirstChild("TabUnderline5") or tabButton:FindFirstChild("TabUnderline6Music")
    if not underline then return end
    if active then
        if Settings.Animations then
            TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 1) }):Play()
        else
            underline.Size = UDim2.new(1, 0, 0, 1)
        end
    else
        if Settings.Animations then
            TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 1) }):Play()
        else
            underline.Size = UDim2.new(0, 0, 0, 1)
        end
    end
end

function Funcs.SetAllUnderlines(activeTab)
    local tabs = {UI.HomeTab, UI.ExeTab, UI.SearchTab, UI.ScriptsTab, UI.SettingsTab, UI.MusicTab}
    for _, tab in ipairs(tabs) do
        Funcs.UpdateUnderline(tab, tab == activeTab)
    end
end

function Funcs.Dragify(Object)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = Object.AbsoluteSize
        local paddingX = 16
        local paddingY = 12
        newX = math.clamp(newX, paddingX, viewport.X - size.X - paddingX)
        newY = math.clamp(newY, paddingY, viewport.Y - size.Y - paddingY)
        return newX, newY
    end
    Object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Object.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            newX, newY = ClampPosition(newX, newY)
            Object.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

function Funcs.GetActiveContent()
    local contents = {UI.HomeContent, UI.ExeContent, UI.SearchContent, UI.ScriptsContent, UI.SettingsContent, UI.MusicContent}
    for _, content in ipairs(contents) do
        if content and content.Visible then return content end
    end
    return UI.HomeContent
end

function Funcs.OpenUI()
    UI.MainFrame.Visible = true
    UI.MainFrame.BackgroundTransparency = 1
    local activeContent = Funcs.GetActiveContent()
    activeContent.Position = UDim2.new(-1, 0, 0, 0)
    UI.Sidebar.Position = UDim2.new(1.2, 8, 0.5, 0)
    if Settings.Animations then
        TweenService:Create(UI.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 }):Play()
        TweenService:Create(activeContent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
        TweenService:Create(UI.Sidebar, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(1, 8, 0.5, 0) }):Play()
        TweenService:Create(UI.Show, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 1, BackgroundTransparency = 1 }):Play()
    else
        UI.MainFrame.BackgroundTransparency = 0.35
        activeContent.Position = UDim2.new(0, 0, 0, 0)
        UI.Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
        UI.Show.ImageTransparency = 1
        UI.Show.BackgroundTransparency = 1
    end
    UI.Show.Visible = false
    Funcs.UpdateStats()
end

function Funcs.CloseUI()
    local activeContent = Funcs.GetActiveContent()
    if Settings.Animations then
        local bgTween = TweenService:Create(UI.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
        local contentTween = TweenService:Create(activeContent, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(-1, 0, 0, 0) })
        local sidebarTween = TweenService:Create(UI.Sidebar, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Position = UDim2.new(1.2, 8, 0.5, 0) })
        local showTween = TweenService:Create(UI.Show, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { ImageTransparency = 0, BackgroundTransparency = 0.08 })
        bgTween:Play(); contentTween:Play(); sidebarTween:Play(); showTween:Play()
        contentTween.Completed:Wait()
        UI.MainFrame.Visible = false
        UI.Show.Visible = true
    else
        UI.MainFrame.BackgroundTransparency = 1
        UI.MainFrame.Visible = false
        UI.Show.Visible = true
        UI.Show.ImageTransparency = 0
        UI.Show.BackgroundTransparency = 0.08
        activeContent.Position = UDim2.new(0, 0, 0, 0)
        UI.Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
    end
end

function Funcs.CreateTab(iconPath, labelText, content, layoutOrder, underlineKey)
    local tab = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        LayoutOrder = layoutOrder or 1, Name = labelText .. "Tab",
        Size = UDim2.new(0, 30, 0, 58), Text = ""}, UI.Sidebar)

    local tabLayout = MkList(Enum.FillDirection.Vertical, 4, tab)
    tabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

    MkSize(Vector2.new(0, 28), Vector2.new(2147483647, 34), tab)

    MkPad(0, 0, 3, 3, tab)

    local container = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1,
        Name = "TabContainer", Size = UDim2.new(1, 0, 0, 22)}, tab)

    local containerLayout = MkList(Enum.FillDirection.Horizontal, 4, container)
    containerLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    containerLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

    local icon = MkEl("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
        Image = Funcs.GetAsset(iconPath), LayoutOrder = 1, Name = "TabIcon",
        Size = UDim2.new(0, 30, 0, 30)}, container)

    MkAspect(1, icon)

    MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = BuilderSans,
        LayoutOrder = 2, Name = "TabLabel", Size = UDim2.new(0, 60, 0, 30), Text = labelText,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left}, container)

    local underline = MkEl("Frame", {BackgroundColor3 = Settings.AccentColor, BorderSizePixel = 0,
        LayoutOrder = 2, Name = underlineKey or "TabUnderline",
        Size = UDim2.new(0, 0, 0, 1)}, tab)

    MkCorner(6, underline)

    UI[labelText .. "Tab"] = tab
    UI[underlineKey or "TabUnderline"] = underline

    if content then content.Parent = UI.Pages end

    tab.MouseButton1Click:Connect(function()
        if content then
            Funcs.SwitchTab(tab)
            Funcs.SetAllUnderlines(tab)
        end
    end)

    return tab
end

function Funcs.CreateSettingsInputbox(labelText, placeholderText, settingKey, layoutOrder)
    local frame = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
        LayoutOrder = layoutOrder or 2, Name = labelText:gsub(" ", ""),
        Size = UDim2.new(1, 0, 0, 38)}, UI.SettingsFrame)

    MkCorner(6, frame)

    local stroke = MkStroke(Color3.fromRGB(36, 36, 36), frame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local layout = MkList(Enum.FillDirection.Horizontal, 6, frame)
    layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    layout.VerticalFlex = Enum.UIFlexAlignment.Fill

    MkPad(8, 8, 8, 8, frame)

    local lbl = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
        LayoutOrder = 1, Size = UDim2.new(0.8, 0, 1, 0), Text = labelText,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, frame)

    local input = MkEl("TextBox", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
        LayoutOrder = 2, PlaceholderColor3 = Color3.fromRGB(221, 221, 221),
        PlaceholderText = placeholderText, Size = UDim2.new(0.2, 0, 1, 0),
        Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
        TextWrapped = true}, frame)

    MkCorner(6, input)

    local inputStroke = MkStroke(Color3.fromRGB(36, 36, 36), input)
    inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    MkPad(4, 4, 4, 4, input)

    if settingKey then
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local color = Funcs.ParseColor(input.Text)
                if color then
                    Settings[settingKey] = color
                    Funcs.ApplyTheme()
                    Funcs.SaveSettings()
                end
            end
        end)
    end

    return input
end

function Funcs.GetNextTabName()
    local existing = {}
    for _, t in ipairs(ExeTabs) do
        local num = tonumber(t.name:match("^Tab (%d+)$"))
        if num then existing[num] = true end
    end
    local n = 1
    while existing[n] do n = n + 1 end
    return "Tab " .. n
end

function Funcs.SwitchExeTab(tabData)
    if ExeActiveTab and ExeActiveTab ~= tabData then
        ExeActiveTab.inputFrame.Visible = false
        local activeBtn = ExeActiveTab.tabBtn
        if activeBtn then
            local activeLine = activeBtn:FindFirstChild("ActiveLine")
            if activeLine then activeLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
        end
    end
    ExeActiveTab = tabData
    tabData.inputFrame.Visible = true
    local tabBtn = tabData.tabBtn
    if tabBtn then
        local activeLine = tabBtn:FindFirstChild("ActiveLine")
        if activeLine then activeLine.BackgroundColor3 = Settings.AccentColor end
    end
    UI.ExeBottomButtons.Visible = true
end

function Funcs.CreateExeTab(name)
    local tabData = {}
    tabData.name = name or Funcs.GetNextTabName()
    tabData.code = ""

    local tabBtn = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(22, 22, 22), BorderSizePixel = 0,
        Name = "ExeTabBtn_" .. tabData.name, Size = UDim2.new(0, 90, 1, 0)}, UI.ExeTabBarScroll)

    MkCorner(5, tabBtn)

    local tabBtnStroke = MkStroke(Color3.fromRGB(36, 36, 36), tabBtn)
    tabBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local activeLine = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0,
        Name = "ActiveLine", Size = UDim2.new(1, 0, 0, 2),
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0)}, tabBtn)

    MkCorner(2, activeLine)

    local tabInnerLayout = MkList(Enum.FillDirection.Horizontal, 2, tabBtn)
    tabInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabInnerLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

    MkPad(6, 4, 2, 4, tabBtn)

    local tabNameBtn = MkEl("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0,
        FontFace = GothamMedium, LayoutOrder = 1, Name = "TabNameBtn",
        Size = UDim2.new(1, -20, 1, 0), Text = tabData.name,
        TextColor3 = Color3.fromRGB(200, 200, 200), TextScaled = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left}, tabBtn)

    local tabNameBox = MkEl("TextBox", {BackgroundTransparency = 1, BorderSizePixel = 0,
        FontFace = GothamMedium, LayoutOrder = 1, Name = "TabNameBox",
        Size = UDim2.new(1, -20, 1, 0), Text = tabData.name,
        TextColor3 = Color3.fromRGB(200, 200, 200), TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left, Visible = false,
        ClearTextOnFocus = false}, tabBtn)

    local closeBtn = MkEl("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0,
        FontFace = GothamBold, LayoutOrder = 2, Name = "CloseExeTab",
        Size = UDim2.new(0, 16, 0, 16), Text = "X",
        TextColor3 = Color3.fromRGB(160, 160, 160), TextScaled = true}, tabBtn)

    local inputFrame = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(19, 19, 19),
        BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        Name = "ExeInputFrame_" .. tabData.name,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 6, Size = UDim2.new(1, 0, 1, 0),
        Visible = false}, UI.ExeEditorArea)

    MkPad(6, 6, 6, 6, inputFrame)

    local inputFrameStroke = MkStroke(Color3.fromRGB(36, 36, 36), inputFrame)
    inputFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    MkCorner(6, inputFrame)

    local highlight = MkEl("TextLabel", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        FontFace = Inconsolata, Name = "Highlight", RichText = true,
        Size = UDim2.new(1, 0, 0, 0), Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, Active = false,
        Selectable = false}, inputFrame)

    local inputBox = MkEl("TextBox", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        BorderSizePixel = 0, ClearTextOnFocus = false, FontFace = Inconsolata,
        MultiLine = true, Name = "InputBox",
        PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderText = "Enter code here...", Size = UDim2.new(1, 0, 0, 0),
        Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18,
        TextTransparency = 1, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top}, inputFrame)

    MkSize(Vector2.new(0, 200), Vector2.new(2147483647, 2147483647), inputBox)

    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        tabData.code = inputBox.Text
        highlight.Text = Funcs.Highlight(inputBox.Text)
    end)

    tabData.tabBtn = tabBtn
    tabData.inputFrame = inputFrame
    tabData.inputBox = inputBox
    tabData.highlight = highlight

    tabNameBtn.MouseButton1Click:Connect(function()
        Funcs.SwitchExeTab(tabData)
    end)

    tabNameBtn.MouseButton2Click:Connect(function()
        tabNameBtn.Visible = false
        tabNameBox.Visible = true
        tabNameBox:CaptureFocus()
    end)

    tabNameBox.FocusLost:Connect(function()
        local newName = tabNameBox.Text
        if newName and newName ~= "" then
            tabData.name = newName
            tabNameBtn.Text = newName
        end
        tabNameBox.Visible = false
        tabNameBtn.Visible = true
    end)

    closeBtn.MouseButton1Click:Connect(function()
        if #ExeTabs <= 1 then return end
        local idx = table.find(ExeTabs, tabData)
        table.remove(ExeTabs, idx)
        tabBtn:Destroy()
        inputFrame:Destroy()
        if ExeActiveTab == tabData then
            local newIdx = math.min(idx, #ExeTabs)
            if ExeTabs[newIdx] then
                ExeActiveTab = nil
                Funcs.SwitchExeTab(ExeTabs[newIdx])
            end
        end
    end)

    table.insert(ExeTabs, tabData)
    Funcs.SwitchExeTab(tabData)
    return tabData
end

function Funcs.GetMusicFiles()
    if not IsFolder("Lucid/Music") then MakeFolder("Lucid/Music") end
    local files = ListFiles("Lucid/Music") or {}
    local musicFiles = {}
    local supported = {mp3 = true, m4a = true, ogg = true, wav = true, flac = true, aiff = true}
    for _, file in ipairs(files) do
        local ext = file:match("%.([^%.]+)$")
        if ext and supported[ext:lower()] then
            table.insert(musicFiles, file)
        end
    end
    return musicFiles
end

function Funcs.GetMusicDisplayName(path)
    local name = path:match("([^/\\]+)$") or path
    name = name:gsub("%.[^%.]+$", "")
    return name
end

function Funcs.FormatTime(seconds)
    if not seconds or seconds ~= seconds then return "0:00" end
    seconds = math.floor(seconds)
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%d:%02d", m, s)
end

function Funcs.UpdateMusicSlider()
    if not MusicSound or not MusicSound.Parent then return end
    local duration = MusicSound.TimeLength
    local position = MusicSound.TimePosition
    if duration and duration > 0 and not MusicSliderDragging then
        local frac = math.clamp(position / duration, 0, 1)
        UI.MusicSliderFill.Size = UDim2.new(frac, 0, 1, 0)
        UI.MusicSliderKnob.Position = UDim2.new(frac, -6, 0.5, -6)
        UI.MusicTimeLabel.Text = Funcs.FormatTime(position) .. " / " .. Funcs.FormatTime(duration)
    end
end

function Funcs.LoadAndPlayMusic(index)
    if not MusicFiles or #MusicFiles == 0 then return end
    index = ((index - 1) % #MusicFiles) + 1
    MusicIndex = index
    local filePath = MusicFiles[index]

    if MusicSound then
        MusicSound:Stop()
        MusicSound:Destroy()
        MusicSound = nil
    end

    local assetId = pcall(LoadAsset, filePath) and LoadAsset(filePath)
    if not assetId then
        UI.MusicNowPlaying.Text = "Failed to load: " .. Funcs.GetMusicDisplayName(filePath)
        return
    end

    MusicSound = MkEl("Sound", {SoundId = assetId, Volume = tonumber(UI.MusicVolumeBox.Text) or 1,
        PlaybackSpeed = tonumber(UI.MusicSpeedBox.Text) or 1,
        Looped = UI.MusicLoopToggle:FindFirstChild("LoopState") and UI.MusicLoopToggle.LoopState.BackgroundColor3 == Color3.fromRGB(0, 255, 0) or false}, Workspace)

    MusicSound:Play()
    MusicPlaying = true
    UI.MusicPlayBtn.Text = "I I"
    UI.MusicNowPlaying.Text = Funcs.GetMusicDisplayName(filePath)

    MusicSound.Ended:Connect(function()
        if not MusicSound.Looped then
            Funcs.LoadAndPlayMusic(MusicIndex + 1)
        end
    end)

    Funcs.RefreshMusicList()
end

function Funcs.RefreshMusicList()
    MusicFiles = Funcs.GetMusicFiles()
    local scroll = UI.MusicListScroll
    if not scroll then return end

    for _, child in ipairs(scroll:GetChildren()) do
        if child.Name ~= "MusicListLayout" and child.Name ~= "MusicListPadding" and child.Name ~= "NoMusicLabel" then
            child:Destroy()
        end
    end

    if #MusicFiles == 0 then
        if UI.NoMusicLabel then
            UI.NoMusicLabel.Visible = true
        end
        return
    end

    if UI.NoMusicLabel then UI.NoMusicLabel.Visible = false end

    for i, filePath in ipairs(MusicFiles) do
        local displayName = Funcs.GetMusicDisplayName(filePath)
        local isActive = (i == MusicIndex and MusicPlaying)

        local row = MkEl("TextButton", {BackgroundColor3 = isActive and Settings.AccentColor or Color3.fromRGB(22, 22, 22),
            BackgroundTransparency = isActive and 0.5 or 0, BorderSizePixel = 0,
            Name = "MusicRow_" .. i, Size = UDim2.new(1, 0, 0, 32), Text = ""}, scroll)

        MkCorner(5, row)

        local rowStroke = MkStroke(isActive and Settings.AccentColor or Color3.fromRGB(36, 36, 36), row)
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local rowLayout = MkList(Enum.FillDirection.Horizontal, 6, row)
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        MkPad(10, 10, 0, 0, row)

        MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
            LayoutOrder = 1, Size = UDim2.new(0, 20, 1, 0), Text = tostring(i),
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120),
            TextScaled = true}, row)

        MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
            LayoutOrder = 2, Size = UDim2.new(1, -30, 1, 0), Text = displayName,
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200),
            TextScaled = true, TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left}, row)

        local capturedIndex = i
        row.MouseButton1Click:Connect(function()
            Funcs.LoadAndPlayMusic(capturedIndex)
        end)
    end
end

Funcs.PreloadAssets()

if Env.__Lucid.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Lucid Executor",
        Text = "Lucid is already running!",
        Icon = Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png"),
        Duration = 4
    })
    return
end

LucidLoaded = true

UI.ScreenGui = MkEl("ScreenGui", {DisplayOrder = 2147483647, IgnoreGuiInset = true, Name = Funcs.UID(),
    ResetOnSpawn = false, ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, Hui)

UI.Show = MkEl("ImageButton", {BackgroundColor3 = Color3.fromRGB(19, 19, 22), BackgroundTransparency = 0.08,
    BorderSizePixel = 0, Name = "Show", Position = UDim2.new(0, 16, 0, 60),
    Size = UDim2.new(0, 44, 0, 44), Visible = true, ZIndex = 3}, UI.ScreenGui)

UI.ShowRatio = MkAspect(1, UI.Show)
UI.ShowRatio.Name = "ShowRatio"

UI.ShowCorner = MkCorner(0, UI.Show)
UI.ShowCorner.CornerRadius = UDim.new(1, 0)

MkEl("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png"), Name = "ShowIcon",
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 28, 0, 28)}, UI.Show)

UI.MainFrame = MkEl("Frame", {AutoLocalize = false, BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.35, BorderSizePixel = 0, Name = "MainFrame",
    Size = UDim2.new(1, 0, 1, 0), Visible = false}, UI.ScreenGui)

UI.MainFrameLayout = MkList(Enum.FillDirection.Horizontal, 0, UI.MainFrame)
UI.MainFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MainFrameLayout.Name = "MainFrameLayout"
UI.MainFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.Pages = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1, Name = "Pages",
    Size = UDim2.new(0, 576, 0, 116)}, UI.MainFrame)

UI.PagesPadding = MkPad(8, 0, 60, 8, UI.Pages)
UI.PagesPadding.Name = "PagesPadding"

UI.HomeContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 1, Name = "HomeContent", Size = UDim2.new(1, 0, 1, 0),
    Visible = false}, UI.Pages)

MkCorner(6, UI.HomeContent)

UI.HomeContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.HomeContent)
UI.HomeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.HomeContentStroke.Name = "HomeContentStroke"

UI.HomeContentLayout = MkList(Enum.FillDirection.Vertical, 6, UI.HomeContent)
UI.HomeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.HomeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.HomeInfo = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
    Name = "HomeInfo", ScrollBarThickness = 0,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.new(1, 0, 1, 0)}, UI.HomeContent)

MkPad(5, 5, 5, 5, UI.HomeInfo)

UI.HomeInfoLayout = MkList(Enum.FillDirection.Vertical, 6, UI.HomeInfo)
UI.HomeInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

UI.PlayerStats = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1,
    Name = "PlayerStats", Size = UDim2.new(1, 0, 0, 400)}, UI.HomeInfo)

UI.PlayerStatsLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.PlayerStats)
UI.PlayerStatsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.PlayerStatsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.Avatar = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1, Name = "Avatar",
    Size = UDim2.new(0, 0, 1, 0)}, UI.PlayerStats)

UI.PlayerHeadshot = MkEl("ImageLabel", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    Interactable = false, Name = "PlayerHeadshot",
    ScaleType = Enum.ScaleType.Fit, Size = UDim2.new(1, 0, 1, 0)}, UI.Avatar)

MkAspect(1, UI.PlayerHeadshot)

MkCorner(6, UI.PlayerHeadshot)

UI.PlayerHeadshotStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.PlayerHeadshot)
UI.PlayerHeadshotStroke.Name = "PlayerHeadshotStroke"

UI.PlayerInfo = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "PlayerInfo", Size = UDim2.new(0.75, 0, 1, 0)}, UI.PlayerStats)

UI.PlayerInfoLayout = MkList(Enum.FillDirection.Vertical, 6, UI.PlayerInfo)
UI.PlayerInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.PlayerInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.WelcomeLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, Name = "WelcomeLabel",
    Size = UDim2.new(0, 432, 0, 0), Text = "Welcome to Lucid, DisplayName!",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextSize = 20, TextWrapped = true}, UI.PlayerInfo)

UI.WelcomeLabelStroke = MkStroke(Color3.fromRGB(0, 94, 255), UI.WelcomeLabel)
UI.WelcomeLabelStroke.Name = "WelcomeLabelStroke"

UI.InfoLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
    Name = "InfoLabel", RichText = true, Size = UDim2.new(1, 0, 0.75, 0),
    Text = "Loading...", TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top}, UI.PlayerInfo)

UI.InfoLabelStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.InfoLabel)
UI.InfoLabelStroke.Name = "InfoLabelStroke"

UI.InfoLabel2 = Instance.new("TextLabel")
UI.InfoLabel2.AutomaticSize = Enum.AutomaticSize.Y
UI.InfoLabel2.BackgroundTransparency = 1
UI.InfoLabel2.BorderSizePixel = 0
UI.InfoLabel2.LayoutOrder = 2
UI.InfoLabel2.Name = "InfoLabel2"
UI.InfoLabel2.RichText = true
UI.InfoLabel2.Size = UDim2.new(1, 0, 0, 0)
UI.InfoLabel2.Text = [[<b>Lucid</b>

<i>A better UI for your executor.</i>

Lucid is a custom executor UI designed to replace the default interface of your executor with a cleaner, more feature-rich experience.

Some executors offer powerful execution capabilities but have a UI that feels outdated, cluttered, or simply isn't enjoyable to use. <b>Lucid</b> was created to solve that.

<b>Version</b>

<font color="#9B7CFF">Legacy [V1]</font>

<i>The original Lucid experience.</i>

<b>Executor</b>

Your main workspace for writing and executing scripts.

• <b>Multi-Tab Editor</b> — Work with multiple scripts at once.
• <b>Syntax Highlighting</b> — Easier-to-read Lua code.
• <b>Execute</b> — Run your current script.
• <b>Clear</b> — Quickly clear the editor.
• <b>Copy</b> — Copy your code with one click.

<b>Search</b>

Find scripts without leaving Lucid.

Search supported script sources such as <b>rscripts.net</b> and <b>ScriptBlox</b>, then filter results by:

• <b>All</b>
• <b>Key</b>
• <b>Keyless</b>

Found something useful? You can <b>execute</b> the script, <b>copy</b> its code, or <b>save</b> it directly to your Scripts library.

<b>Scripts</b>

Keep your scripts organized in one place.

Use the search bar to quickly find saved scripts, or create a new one with:

• <b>Title</b>
• <b>Description</b>
• <b>Source</b>

Saved scripts can be <b>executed</b> or <b>deleted</b> whenever you want.

<b>Music</b>

A built-in music player for your own audio collection.

Place your audio files in <b>Lucid/Music/</b> and play them directly through Lucid.

• <b>Song List</b>
• <b>Volume</b>
• <b>Playback Speed</b>
• <b>Loop</b>

<b>Settings</b>

Customize Lucid to your liking.

• <b>Animations</b> — Toggle UI animations.
• <b>Theme Customization</b> — Create your own theme using RGB values.
• <b>Preset Themes</b> — Quickly switch between built-in themes.

<b>Credits</b>

<i>Designed and developed by JustSomeGuest</i>]]
UI.InfoLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.InfoLabel2.TextSize = 14
UI.InfoLabel2.TextWrapped = true
UI.InfoLabel2.Parent = UI.HomeInfo

UI.InfoLabel2Stroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.InfoLabel2)
UI.InfoLabel2Stroke.Name = "InfoLabel2Stroke"

UI.ExeContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 1, Name = "ExeContent", Size = UDim2.new(1, 0, 1, 0),
    Visible = false}, UI.Pages)

MkCorner(6, UI.ExeContent)

UI.ExeContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.ExeContent)
UI.ExeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ExeContentStroke.Name = "ExeContentStroke"

UI.ExeContentLayout = MkList(Enum.FillDirection.Vertical, 4, UI.ExeContent)
UI.ExeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ExeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkPad(5, 5, 5, 5, UI.ExeContent)

UI.ExeTabBarWrapper = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1,
    Name = "ExeTabBarWrapper", Size = UDim2.new(1, 0, 0, 30)}, UI.ExeContent)

UI.ExeTabBarWrapperLayout = MkList(Enum.FillDirection.Horizontal, 4, UI.ExeTabBarWrapper)
UI.ExeTabBarWrapperLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ExeTabBarWrapperLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkSize(Vector2.new(0, 30), Vector2.new(2147483647, 30), UI.ExeTabBarWrapper)

UI.ExeTabBarScroll = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1, BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0), LayoutOrder = 1,
    Name = "ExeTabBarScroll", ScrollBarThickness = 3,
    ScrollingDirection = Enum.ScrollingDirection.X,
    Size = UDim2.new(1, -38, 1, 0)}, UI.ExeTabBarWrapper)

UI.ExeTabBarScrollLayout = MkList(Enum.FillDirection.Horizontal, 4, UI.ExeTabBarScroll)
UI.ExeTabBarScrollLayout.VerticalAlignment = Enum.VerticalAlignment.Center

MkPad(2, 0, 0, 0, UI.ExeTabBarScroll)

UI.AddExeTabBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamBold, LayoutOrder = 2, Name = "AddExeTabBtn",
    Size = UDim2.new(0, 30, 1, 0), Text = "+",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true}, UI.ExeTabBarWrapper)

MkCorner(5, UI.AddExeTabBtn)

UI.AddExeTabBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.AddExeTabBtn)
UI.AddExeTabBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.AddExeTabBtnStroke.Name = "AddExeTabBtnStroke"

MkAspect(1, UI.AddExeTabBtn)
  
UI.ExeEditorArea = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "ExeEditorArea", Size = UDim2.new(1, 0, 1, 0)}, UI.ExeContent)

UI.ExeBottomButtons = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 3,
    Name = "ExeBottomButtons", Size = UDim2.new(1, 0, 0, 38),
    Visible = false}, UI.ExeContent)

MkSize(nil, Vector2.new(2147483647, 38), UI.ExeBottomButtons)

UI.ExeBottomButtonsLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.ExeBottomButtons)
UI.ExeBottomButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ExeBottomButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.ExeBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 1, Name = "ExeBtn",
    Size = UDim2.new(0.2, 0, 1, 0), Text = "Execute",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ExeBottomButtons)

MkCorner(6, UI.ExeBtn)

UI.ExeBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.ExeBtn)
UI.ExeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ExeBtnStroke.Name = "ExeBtnStroke"

MkPad(4, 4, 4, 4, UI.ExeBtn)

UI.ClrBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 2, Name = "ClrBtn",
    Size = UDim2.new(0.2, 0, 1, 0), Text = "Clear",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ExeBottomButtons)

MkCorner(6, UI.ClrBtn)

UI.ClrBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.ClrBtn)
UI.ClrBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ClrBtnStroke.Name = "ClrBtnStroke"

MkPad(4, 4, 4, 4, UI.ClrBtn)

UI.CopyBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 3, Name = "CopyBtn",
    Size = UDim2.new(0.2, 0, 1, 0), Text = "Copy",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ExeBottomButtons)

MkCorner(6, UI.CopyBtn)

UI.CopyBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.CopyBtn)
UI.CopyBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.CopyBtnStroke.Name = "CopyBtnStroke"

MkPad(4, 4, 4, 4, UI.CopyBtn)

UI.SearchContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 2, Name = "SearchContent",
    Size = UDim2.new(1, 0, 1, 0), Visible = false}, UI.Pages)

MkPad(6, 6, 6, 6, UI.SearchContent)

UI.SearchContentLayout = MkList(Enum.FillDirection.Vertical, 6, UI.SearchContent)
UI.SearchContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SearchContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkCorner(6, UI.SearchContent)

UI.SearchContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.SearchContent)
UI.SearchContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SearchContentStroke.Name = "SearchContentStroke"

UI.SearchFrame = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    LayoutOrder = 1, Name = "SearchFrame", Size = UDim2.new(1, 0, 0, 30)}, UI.SearchContent)

UI.SearchFrameLayout = MkList(Enum.FillDirection.Horizontal, 2, UI.SearchFrame)
UI.SearchFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SearchFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkSize(Vector2.new(0, 30), Vector2.new(2147483647, 30), UI.SearchFrame)

MkCorner(6, UI.SearchFrame)

UI.SearchFrameStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.SearchFrame)
UI.SearchFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.SourceBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 1, Name = "SourceBtn",
    Size = UDim2.new(0.24, 0, 1, 0), Text = "🟢 Source: RScripts",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.SearchFrame)

MkCorner(6, UI.SourceBtn)

UI.SourceBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.SourceBtn)
UI.SourceBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SourceBtnStroke.Name = "SourceBtnStroke"

MkPad(4, 4, 4, 4, UI.SourceBtn)

UI.SearchBox = MkEl("TextBox", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
    LayoutOrder = 2, Name = "SearchBox",
    PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
    PlaceholderText = "Search for scripts...", Size = UDim2.new(0.52, 0, 1, 0),
    Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.SearchFrame)

MkPad(6, 6, 6, 6, UI.SearchBox)

UI.FilterBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 3, Name = "FilterBtn",
    Size = UDim2.new(0.24, 0, 1, 0), Text = "Filter: All",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.SearchFrame)

MkCorner(6, UI.FilterBtn)

UI.FilterBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.FilterBtn)
UI.FilterBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.FilterBtnStroke.Name = "FilterBtnStroke"

MkPad(4, 4, 4, 4, UI.FilterBtn)

UI.SearchResults = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "SearchResults", ScrollBarThickness = 0,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.new(1, 0, 1, 0)}, UI.SearchContent)

UI.SearchResultsPadding = MkPad(2, 2, 2, 2, UI.SearchResults)

UI.SearchResultsLayout = MkList(Enum.FillDirection.Vertical, 8, UI.SearchResults)
UI.SearchResultsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

UI.NoResultsLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, Name = "NoResultsLabel",
    Size = UDim2.new(1, 0, 0, 30),
    Text = "No scripts found matching your query.",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, Visible = false}, UI.SearchResults)

UI.NoResultsLabelStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.NoResultsLabel)
UI.NoResultsLabelStroke.Name = "NoResultsLabelStroke"

UI.SearchResultTemplate = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(19, 19, 19),
    BorderSizePixel = 0, Name = "SearchResultTemplate",
    Size = UDim2.new(0, 358, 0, 132), Visible = false}, UI.SearchResults)

MkCorner(6, UI.SearchResultTemplate)

UI.SearchResultTemplateStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.SearchResultTemplate)
UI.SearchResultTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SearchResultTemplateStroke.Name = "SearchResultTemplateStroke"

MkEl("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1, Name = "ScriptImage",
    ScaleType = Enum.ScaleType.Crop, Size = UDim2.new(1, 0, 0.7, -2)}, UI.SearchResultTemplate)

UI.Container = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "Container", Size = UDim2.new(1, 0, 1, 0)}, UI.SearchResultTemplate)

UI.ScriptName = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
    Name = "ScriptName", Position = UDim2.new(0, 4, 0, 0),
    Size = UDim2.new(0, 350, 0, 30),
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.Container)

UI.ScriptNameStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.ScriptName)
UI.ScriptNameStroke.Name = "ScriptNameStroke"

MkCorner(6, UI.ScriptName)

UI.ScriptActions = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Name = "ScriptActions",
    Position = UDim2.new(0, 0, 0, 92), Size = UDim2.new(1, 0, 0.3, 0)}, UI.Container)

MkPad(6, 6, 4, 6, UI.ScriptActions)

UI.ScriptActionsLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.ScriptActions)
UI.ScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.RunScript = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 1, Name = "RunScript",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Run",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ScriptActions)

UI.RunScriptStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.RunScript)
UI.RunScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.RunScriptStroke.Name = "RunScriptStroke"

MkCorner(6, UI.RunScript)

MkPad(2, 2, 2, 2, UI.RunScript)

UI.CopyScriptBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 2, Name = "CopyScriptBtn",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Copy",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ScriptActions)

MkCorner(6, UI.CopyScriptBtn)

UI.CopyScriptBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.CopyScriptBtn)
UI.CopyScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.CopyScriptBtnStroke.Name = "CopyScriptBtnStroke"

MkPad(2, 2, 2, 2, UI.CopyScriptBtn)

UI.SaveScriptBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 3, Name = "SaveScriptBtn",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Save",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.ScriptActions)

MkCorner(6, UI.SaveScriptBtn)

MkPad(2, 2, 2, 2, UI.SaveScriptBtn)

UI.SaveScriptBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.SaveScriptBtn)
UI.SaveScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SaveScriptBtnStroke.Name = "SaveScriptBtnStroke"

UI.PageButtons = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 3,
    Name = "PageButtons", Size = UDim2.new(1, 0, 0, 38)}, UI.SearchContent)

UI.PageButtonsLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.PageButtons)
UI.PageButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.PageButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkSize(nil, Vector2.new(2147483647, 38), UI.PageButtons)

UI.PrevBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 1, Name = "PrevBtn",
    Size = UDim2.new(0.25, 0, 1, 0), Text = "Previous",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.PageButtons)

MkCorner(6, UI.PrevBtn)

UI.PrevBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.PrevBtn)
UI.PrevBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.PrevBtnStroke.Name = "PrevBtnStroke"

MkPad(4, 4, 4, 4, UI.PrevBtn)

MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2, Name = "PageFiller",
    Size = UDim2.new(0.5, 0, 1, 0)}, UI.PageButtons)

UI.NextBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = BuilderSans, LayoutOrder = 3, Name = "NextBtn",
    Size = UDim2.new(0.25, 0, 1, 0), Text = "Next",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.PageButtons)

MkCorner(6, UI.NextBtn)

UI.NextBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.NextBtn)
UI.NextBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.NextBtnStroke.Name = "NextBtnStroke"

MkPad(4, 4, 4, 4, UI.NextBtn)

UI.ScriptsContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 3, Name = "ScriptsContent",
    Size = UDim2.new(1, 0, 1, 0), Visible = false}, UI.Pages)

MkCorner(6, UI.ScriptsContent)

UI.ScriptsContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.ScriptsContent)
UI.ScriptsContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.ScriptsContentStroke.Name = "ScriptsContentStroke"

UI.ScriptsContentLayout = MkList(Enum.FillDirection.Vertical, 6, UI.ScriptsContent)
UI.ScriptsContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ScriptsContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkPad(6, 6, 6, 6, UI.ScriptsContent)

UI.SavedScriptsSearchFrame = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(19, 19, 19),
    BorderSizePixel = 0, LayoutOrder = 1,
    Name = "SavedScriptsSearchFrame", Size = UDim2.new(1, 0, 0, 30)}, UI.ScriptsContent)

UI.SavedScriptsSearchFrameLayout = MkList(Enum.FillDirection.Horizontal, 2, UI.SavedScriptsSearchFrame)
UI.SavedScriptsSearchFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SavedScriptsSearchFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkSize(Vector2.new(0, 30), Vector2.new(2147483647, 30), UI.SavedScriptsSearchFrame)

MkCorner(6, UI.SavedScriptsSearchFrame)

UI.SavedScriptsSearchFrameStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.SavedScriptsSearchFrame)
UI.SavedScriptsSearchFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.SearchBox2 = MkEl("TextBox", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
    LayoutOrder = 1, Name = "SearchBox2",
    PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
    PlaceholderText = "Search saved scripts...",
    Size = UDim2.new(0.95, 0, 1, 0), Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.SavedScriptsSearchFrame)

MkPad(6, 6, 6, 6, UI.SearchBox2)

UI.NewScriptBtn = MkEl("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 2, Name = "NewScriptBtn",
    Size = UDim2.new(0.05, 0, 1, 0), Text = "+",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.SavedScriptsSearchFrame)

UI.NewScriptBtnStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.NewScriptBtn)
UI.NewScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MkAspect(1, UI.NewScriptBtn)

MkCorner(6, UI.NewScriptBtn)

UI.SavedScriptsScroll = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0,
    LayoutOrder = 2, Name = "SavedScriptsScroll",
    ScrollBarThickness = 0,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.new(1, 0, 1, 0)}, UI.ScriptsContent)

UI.SavedScriptsScrollPadding = MkPad(2, 2, 2, 2, UI.SavedScriptsScroll)

UI.SavedScriptsScrollLayout = MkList(Enum.FillDirection.Vertical, 8, UI.SavedScriptsScroll)
UI.SavedScriptsScrollLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

UI.NoSavedScriptsLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, Name = "NoSavedScriptsLabel",
    Size = UDim2.new(1, 0, 0, 60),
    Text = "No Saved Scripts\n\nSave some scripts to see them here.",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, Visible = false}, UI.SavedScriptsScroll)

UI.NoSavedScriptsLabelStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.NoSavedScriptsLabel)
UI.NoSavedScriptsLabelStroke.Name = "NoSavedScriptsLabelStroke"

UI.SavedScriptTemplate = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    Name = "SavedScriptTemplate", Size = UDim2.new(0, 166, 0, 64),
    Visible = false}, UI.SavedScriptsScroll)

MkCorner(6, UI.SavedScriptTemplate)

UI.SavedScriptTemplateStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.SavedScriptTemplate)
UI.SavedScriptTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SavedScriptTemplateStroke.Name = "SavedScriptTemplateStroke"

UI.SavedScriptTemplateLayout = MkList(Enum.FillDirection.Horizontal, 2, UI.SavedScriptTemplate)
UI.SavedScriptTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SavedScriptTemplateLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.SavedScriptInfo = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1,
    Name = "SavedScriptInfo", Size = UDim2.new(0, 380, 0, 12)}, UI.SavedScriptTemplate)

MkPad(6, 6, 6, 6, UI.SavedScriptInfo)

UI.SavedScriptInfoLayout = MkList(Enum.FillDirection.Vertical, 2, UI.SavedScriptInfo)
UI.SavedScriptInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SavedScriptInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamBold, LayoutOrder = 1,
    Name = "SavedScriptTitle", Size = UDim2.new(1, 0, 0.6, 0), Text = "Script name",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left}, UI.SavedScriptInfo)

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium, LayoutOrder = 2,
    Name = "SavedScriptDesc", Size = UDim2.new(1, 0, 0.4, 0), Text = "Script description",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left}, UI.SavedScriptInfo)

UI.SavedScriptActions = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "SavedScriptActions", Size = UDim2.new(0, 0, 0, 12)}, UI.SavedScriptTemplate)

MkPad(4, 4, 4, 4, UI.SavedScriptActions)

UI.SavedScriptActionsLayout = MkList(Enum.FillDirection.Vertical, 6, UI.SavedScriptActions)
UI.SavedScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SavedScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.RunSavedScript = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 1, Name = "RunSavedScript",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Run",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.SavedScriptActions)

UI.RunSavedScriptStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.RunSavedScript)
UI.RunSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.RunSavedScriptStroke.Name = "RunSavedScriptStroke"

MkCorner(6, UI.RunSavedScript)

MkPad(2, 2, 2, 2, UI.RunSavedScript)

UI.DeleteSavedScript = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255),
    BorderSizePixel = 0, FontFace = GothamMedium, LayoutOrder = 2,
    Name = "DeleteSavedScript", Size = UDim2.new(0.2, 0, 0.3, 0),
    Text = "Delete", TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = true, TextWrapped = true}, UI.SavedScriptActions)

MkCorner(6, UI.DeleteSavedScript)

UI.DeleteSavedScriptStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.DeleteSavedScript)
UI.DeleteSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.DeleteSavedScriptStroke.Name = "DeleteSavedScriptStroke"

MkPad(2, 2, 2, 2, UI.DeleteSavedScript)

UI.MusicContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 5, Name = "MusicContent", Size = UDim2.new(1, 0, 1, 0),
    Visible = false}, UI.Pages)

MkCorner(6, UI.MusicContent)

UI.MusicContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.MusicContent)
UI.MusicContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.MusicContentStroke.Name = "MusicContentStroke"

UI.MusicContentLayout = MkList(Enum.FillDirection.Vertical, 6, UI.MusicContent)
UI.MusicContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MusicContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkPad(8, 8, 8, 8, UI.MusicContent)

UI.MusicNowPlaying = MkEl("TextLabel", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    BorderSizePixel = 0, FontFace = GothamBold, LayoutOrder = 1,
    Name = "MusicNowPlaying", Size = UDim2.new(1, 0, 0, 24),
    Text = "No song playing", TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = false, TextSize = 24, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center}, UI.MusicContent)

UI.MusicNowPlayingStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.MusicNowPlaying)

UI.MusicSliderArea = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "MusicSliderArea", Size = UDim2.new(1, 0, 0, 20)}, UI.MusicContent)

MkSize(nil, Vector2.new(2147483647, 20), UI.MusicSliderArea)

UI.MusicSliderBar = MkEl("Frame", {AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0,
    Name = "MusicSliderBar", Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.new(1, 0, 0, 6)}, UI.MusicSliderArea)

MkCorner(3, UI.MusicSliderBar)

UI.MusicSliderFill = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    Name = "MusicSliderFill", Size = UDim2.new(0, 0, 1, 0)}, UI.MusicSliderBar)

MkCorner(3, UI.MusicSliderFill)

UI.MusicSliderKnob = MkEl("Frame", {AnchorPoint = Vector2.new(0, 0),
    BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    Name = "MusicSliderKnob", Position = UDim2.new(0, -6, 0.5, -6),
    Size = UDim2.new(0, 12, 0, 12)}, UI.MusicSliderBar)

UI.MusicSliderKnobCorner = MkCorner(0, UI.MusicSliderKnob)
UI.MusicSliderKnobCorner.CornerRadius = UDim.new(1, 0)

UI.MusicTimeLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 3, Name = "MusicTimeLabel",
    Size = UDim2.new(1, 0, 0, 16), Text = "0:00 / 0:00",
    TextColor3 = Color3.fromRGB(160, 160, 160), TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Center}, UI.MusicContent)

MkSize(nil, Vector2.new(2147483647, 16), UI.MusicTimeLabel)

UI.MusicControls = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 4,
    Name = "MusicControls", Size = UDim2.new(1, 0, 0, 36)}, UI.MusicContent)

MkSize(nil, Vector2.new(2147483647, 36), UI.MusicControls)

UI.MusicControlsLayout = MkList(Enum.FillDirection.Horizontal, 8, UI.MusicControls)
UI.MusicControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.MusicControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

UI.MusicPrevBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamBold, LayoutOrder = 1, Name = "MusicPrevBtn",
    Size = UDim2.new(0, 60, 1, 0), Text = "I<<",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true}, UI.MusicControls)

MkCorner(6, UI.MusicPrevBtn)

UI.MusicPrevBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.MusicPrevBtn)
UI.MusicPrevBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.MusicPrevBtnStroke.Name = "MusicPrevBtnStroke"

UI.MusicPlayBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamBold, LayoutOrder = 2, Name = "MusicPlayBtn",
    Size = UDim2.new(0, 80, 1, 0), Text = "▶",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true}, UI.MusicControls)

MkCorner(6, UI.MusicPlayBtn)

UI.MusicPlayBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.MusicPlayBtn)
UI.MusicPlayBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.MusicPlayBtnStroke.Name = "MusicPlayBtnStroke"

UI.MusicNextBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamBold, LayoutOrder = 3, Name = "MusicNextBtn",
    Size = UDim2.new(0, 60, 1, 0), Text = ">>I",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true}, UI.MusicControls)

MkCorner(6, UI.MusicNextBtn)

UI.MusicNextBtnStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.MusicNextBtn)
UI.MusicNextBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.MusicNextBtnStroke.Name = "MusicNextBtnStroke"

UI.MusicSettingsFrame = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    LayoutOrder = 5, Name = "MusicSettingsFrame",
    Size = UDim2.new(1, 0, 0, 70)}, UI.MusicContent)

MkSize(nil, Vector2.new(2147483647, 70), UI.MusicSettingsFrame)

MkCorner(6, UI.MusicSettingsFrame)

UI.MusicSettingsFrameStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.MusicSettingsFrame)
UI.MusicSettingsFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.MusicSettingsFrameLayout = MkList(Enum.FillDirection.Horizontal, 8, UI.MusicSettingsFrame)
UI.MusicSettingsFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MusicSettingsFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkPad(10, 10, 6, 6, UI.MusicSettingsFrame)

local function MakeMusicSetting(labelText, defaultVal, layoutOrder, name)
    local col = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = layoutOrder,
        Name = name .. "Col", Size = UDim2.new(0.28, 0, 1, 0)}, UI.MusicSettingsFrame)

    local colLayout = MkList(Enum.FillDirection.Vertical, 2, col)
    colLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    colLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

    local lbl = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium,
        LayoutOrder = 1, Size = UDim2.new(1, 0, 0.5, 0), Text = labelText,
        TextColor3 = Color3.fromRGB(180, 180, 180), TextScaled = true}, col)

    local box = MkEl("TextBox", {BackgroundColor3 = Color3.fromRGB(26, 26, 26), BorderSizePixel = 0,
        FontFace = GothamMedium, LayoutOrder = 2, Name = name .. "Box",
        Size = UDim2.new(1, 0, 0.5, 0), Text = defaultVal,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true}, col)

    MkCorner(4, box)

    MkStroke(Color3.fromRGB(36, 36, 36), box)

    UI[name .. "Box"] = box
    return box
end

MakeMusicSetting("Volume", "1", 1, "MusicVolume")
MakeMusicSetting("Speed", "1", 2, "MusicSpeed")

UI.MusicLoopCol = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 3,
    Name = "MusicLoopCol", Size = UDim2.new(0.28, 0, 1, 0)}, UI.MusicSettingsFrame)

UI.MusicLoopColLayout = MkList(Enum.FillDirection.Vertical, 2, UI.MusicLoopCol)
UI.MusicLoopColLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MusicLoopColLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium, LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0.5, 0), Text = "Loop", TextColor3 = Color3.fromRGB(180, 180, 180),
    TextScaled = true}, UI.MusicLoopCol)

UI.MusicLoopToggle = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(26, 26, 26), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 2, Name = "MusicLoopToggle",
    Size = UDim2.new(1, 0, 0.5, 0), Text = ""}, UI.MusicLoopCol)

MkCorner(4, UI.MusicLoopToggle)

MkStroke(Color3.fromRGB(36, 36, 36), UI.MusicLoopToggle)

UI.MusicLoopState = MkEl("Frame", {AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0,
    Name = "LoopState", Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.7, 0, 0.6, 0)}, UI.MusicLoopToggle)

MkCorner(4, UI.MusicLoopState)

UI.MusicListScroll = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0,
    LayoutOrder = 6, Name = "MusicListScroll",
    ScrollBarThickness = 4,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.new(1, 0, 1, 0)}, UI.MusicContent)

UI.MusicListLayout = MkList(Enum.FillDirection.Vertical, 4, UI.MusicListScroll)
UI.MusicListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MusicListLayout.Name = "MusicListLayout"

UI.MusicListPadding = MkPad(0, 0, 4, 4, UI.MusicListScroll)
UI.MusicListPadding.Name = "MusicListPadding"

UI.NoMusicLabel = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    FontFace = GothamMedium, Name = "NoMusicLabel",
    Size = UDim2.new(1, 0, 0, 60),
    Text = "No music found.\n\nPlace audio files in Lucid/Music/",
    TextColor3 = Color3.fromRGB(160, 160, 160), TextScaled = true,
    TextWrapped = true, Visible = false}, UI.MusicListScroll)

UI.SettingsContent = MkEl("CanvasGroup", {BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0,
    LayoutOrder = 1, Name = "SettingsContent",
    Size = UDim2.new(1, 0, 1, 0), Visible = false}, UI.Pages)

MkCorner(6, UI.SettingsContent)

UI.SettingsContentStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.SettingsContent)
UI.SettingsContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SettingsContentStroke.Name = "SettingsContentStroke"

UI.SettingsFrame = MkEl("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0), Name = "SettingsFrame",
    Size = UDim2.new(1, 0, 1, 0)}, UI.SettingsContent)

MkPad(5, 5, 5, 5, UI.SettingsFrame)

UI.SettingsFrameLayout = MkList(Enum.FillDirection.Vertical, 6, UI.SettingsFrame)
UI.SettingsFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill

UI.AnimsToggle = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    LayoutOrder = 1, Name = "AnimsToggle", Size = UDim2.new(1, 0, 0, 38),
    Text = ""}, UI.SettingsFrame)

MkCorner(6, UI.AnimsToggle)

UI.AnimsToggleStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.AnimsToggle)
UI.AnimsToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MkPad(8, 8, 8, 8, UI.AnimsToggle)

UI.AnimsToggleLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.AnimsToggle)
UI.AnimsToggleLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.AnimsToggleLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium, LayoutOrder = 1,
    Name = "AnimsToggleLabel", Size = UDim2.new(0.8, 0, 1, 0), Text = "Animations",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left}, UI.AnimsToggle)

UI.ToggleState = MkEl("Frame", {BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0,
    LayoutOrder = 2, Name = "ToggleState", Size = UDim2.new(0.2, 0, 0.6, 0)}, UI.AnimsToggle)

MkCorner(6, UI.ToggleState)

MkAspect(1, UI.ToggleState)

UI.ToggleStateStroke = MkStroke(Color3.fromRGB(255, 0, 0), UI.ToggleState)
UI.ToggleStateStroke.Transparency = 0.5

UI.SidebarContainer = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
    Name = "SidebarContainer", Size = UDim2.new(0.2, 0, 0.3, 0)}, UI.MainFrame)

UI.Sidebar = MkEl("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(18, 18, 18),
    BorderSizePixel = 0, Name = "Sidebar", Position = UDim2.new(1, 8, 0.5, 0),
    Size = UDim2.new(1, 0, 1, -10)}, UI.SidebarContainer)

MkCorner(6, UI.Sidebar)

UI.SidebarStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.Sidebar)
UI.SidebarStroke.Name = "SidebarStroke"

MkPad(8, 18, 8, 8, UI.Sidebar)

UI.SidebarLayout = MkList(Enum.FillDirection.Vertical, 3, UI.Sidebar)
UI.SidebarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.SidebarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.Topbar = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Name = "Topbar",
    Size = UDim2.new(1, 0, 0, 30)}, UI.Sidebar)

MkSize(Vector2.new(0, 28), Vector2.new(2147483647, 30), UI.Topbar)

UI.TopbarLayout = MkList(Enum.FillDirection.Horizontal, 4, UI.Topbar)
UI.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.Logo = MkEl("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png"),
    ImageColor3 = Color3.fromRGB(0, 64, 180), LayoutOrder = 1, Name = "Logo",
    Size = UDim2.new(0, 30, 0, 30)}, UI.Topbar)

MkAspect(1, UI.Logo)

UI.Icon = MkEl("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
    BorderSizePixel = 0, Image = Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png"),
    ImageColor3 = Color3.fromRGB(0, 99, 255), LayoutOrder = 1, Name = "Icon",
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, -2, 1, -2)}, UI.Logo)

UI.Title = MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = BuilderSans,
    LayoutOrder = 2, Name = "Title", Size = UDim2.new(0, 60, 0, 30),
    Text = "Lucid", TextColor3 = Color3.fromRGB(0, 99, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.Topbar)

UI.TitleStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.Title)
UI.TitleStroke.Transparency = 0.6
UI.TitleStroke.Name = "TitleStroke"

MkPad(0, 0, 2, 2, UI.Title)

UI.CloseTab = MkEl("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 100,
    Name = "CloseTab", Size = UDim2.new(0, 30, 0, 58), Text = ""}, UI.Sidebar)

UI.CloseTabLayout = MkList(Enum.FillDirection.Vertical, 4, UI.CloseTab)
UI.CloseTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkSize(Vector2.new(0, 28), Vector2.new(2147483647, 34), UI.CloseTab)

MkPad(0, 0, 3, 3, UI.CloseTab)

UI.TabContainer6 = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 1,
    Name = "TabContainer6", Size = UDim2.new(1, 0, 0, 22)}, UI.CloseTab)

UI.TabContainer6Layout = MkList(Enum.FillDirection.Horizontal, 4, UI.TabContainer6)
UI.TabContainer6Layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TabContainer6Layout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.TabIcon6 = MkEl("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = Funcs.GetAsset("Lucid/Assets/Lucid_Close.png"), LayoutOrder = 1,
    Name = "TabIcon6", Size = UDim2.new(0, 30, 0, 30)}, UI.TabContainer6)

MkAspect(1, UI.TabIcon6)

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = BuilderSans, LayoutOrder = 2,
    Name = "TabLabel6", Size = UDim2.new(0, 60, 0, 30), Text = "Close",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left}, UI.TabContainer6)

MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2, Name = "TabUnderline6Close",
    Size = UDim2.new(0, 0, 0, 1)}, UI.CloseTab)

UI.NewScriptFrame = MkEl("Frame", {AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(11, 11, 11), BorderSizePixel = 0,
    Name = "NewScriptFrame", Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 408, 0, 214), Visible = false, ZIndex = 2}, UI.ScreenGui)

UI.NewScriptFrameStroke = MkStroke(Color3.fromRGB(0, 99, 255), UI.NewScriptFrame)
UI.NewScriptFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.NewScriptFrameStroke.Name = "NewScriptFrameStroke"

MkPad(6, 6, 6, 6, UI.NewScriptFrame)

UI.NewScriptFrameLayout = MkList(Enum.FillDirection.Vertical, 8, UI.NewScriptFrame)
UI.NewScriptFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.NewScriptFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkCorner(6, UI.NewScriptFrame)

UI.NameBox = MkEl("TextBox", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 1, Name = "NameBox",
    PlaceholderText = "Enter script name...", Size = UDim2.new(0, 76, 0, 30),
    Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.NewScriptFrame)

MkPad(4, 4, 4, 4, UI.NameBox)

UI.NameBoxStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.NameBox)
UI.NameBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MkCorner(6, UI.NameBox)

UI.DescBox = MkEl("TextBox", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 2, Name = "DescBox",
    PlaceholderText = "Enter script description...",
    Size = UDim2.new(0, 76, 0, 30), Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, UI.NewScriptFrame)

MkCorner(6, UI.DescBox)

MkPad(4, 4, 4, 4, UI.DescBox)

UI.DescBoxStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.DescBox)
UI.DescBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.ScriptBox = MkEl("TextBox", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    FontFace = Inconsolata, LayoutOrder = 3, Name = "ScriptBox",
    PlaceholderText = "Enter script...", Size = UDim2.new(0, 76, 0, 80),
    Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 20,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top}, UI.NewScriptFrame)

MkPad(4, 4, 4, 4, UI.ScriptBox)

MkCorner(6, UI.ScriptBox)

UI.ScriptBoxStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.ScriptBox)
UI.ScriptBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.Options = MkEl("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 4,
    Name = "Options", Size = UDim2.new(0, 76, 0, 34)}, UI.NewScriptFrame)

MkCorner(6, UI.Options)

UI.OptionsLayout = MkList(Enum.FillDirection.Horizontal, 8, UI.Options)
UI.OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

UI.Save = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 1, Name = "Save",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Save",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.Options)

UI.SaveStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.Save)
UI.SaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SaveStroke.Name = "SaveStroke"

MkCorner(6, UI.Save)

UI.Cancel = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(0, 99, 255), BorderSizePixel = 0,
    FontFace = GothamMedium, LayoutOrder = 2, Name = "Cancel",
    Size = UDim2.new(0.2, 0, 0.3, 0), Text = "Cancel",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true,
    TextWrapped = true}, UI.Options)

MkCorner(6, UI.Cancel)

UI.CancelStroke = MkStroke(Color3.fromRGB(0, 64, 180), UI.Cancel)
UI.CancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.CancelStroke.Name = "CancelStroke"

UI.ResetThemeBtn = MkEl("TextButton", {BackgroundColor3 = Color3.fromRGB(19, 19, 19), BorderSizePixel = 0,
    LayoutOrder = 6, Name = "ResetThemeBtn",
    Size = UDim2.new(1, 0, 0, 38), Text = ""}, UI.SettingsFrame)

MkCorner(6, UI.ResetThemeBtn)

UI.ResetThemeBtnStroke = MkStroke(Color3.fromRGB(36, 36, 36), UI.ResetThemeBtn)
UI.ResetThemeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UI.ResetThemeBtnLayout = MkList(Enum.FillDirection.Horizontal, 6, UI.ResetThemeBtn)
UI.ResetThemeBtnLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ResetThemeBtnLayout.VerticalFlex = Enum.UIFlexAlignment.Fill

MkPad(8, 8, 8, 8, UI.ResetThemeBtn)

MkEl("TextLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = GothamMedium, LayoutOrder = 1,
    Size = UDim2.new(0.8, 0, 1, 0), Text = "Reset Theme",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextScaled = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left}, UI.ResetThemeBtn)

UI.HomeTab = Funcs.CreateTab("Lucid/Assets/Lucid_Home.png", "Home", UI.HomeContent, 1, "TabUnderline")
UI.ExeTab = Funcs.CreateTab("Lucid/Assets/Lucid_Executor.png", "Executor", UI.ExeContent, 2, "TabUnderline2")
UI.SearchTab = Funcs.CreateTab("Lucid/Assets/Lucid_Search.png", "Search", UI.SearchContent, 3, "TabUnderline3")
UI.ScriptsTab = Funcs.CreateTab("Lucid/Assets/Lucid_Scripts.png", "Scripts", UI.ScriptsContent, 4, "TabUnderline4")
UI.MusicTab = Funcs.CreateTab("Lucid/Assets/Lucid_Music.png", "Music", UI.MusicContent, 5, "TabUnderline6Music")
UI.SettingsTab = Funcs.CreateTab("Lucid/Assets/Lucid_Settings.png", "Settings", UI.SettingsContent, 6, "TabUnderline5")

Funcs.CreateSettingsInputbox("Background Color (RGB)", "10, 10, 10", "BackgroundColor", 2)
Funcs.CreateSettingsInputbox("Secondary Background Color (RGB)", "18, 18, 18", "SecondaryBackgroundColor", 3)
Funcs.CreateSettingsInputbox("Accent Color (RGB)", "0, 98, 255", "AccentColor", 4)
Funcs.CreateSettingsInputbox("Secondary Accent Color (RGB)", "0, 63, 179", "SecondaryAccentColor", 5)

Funcs.LoadSettings()
Funcs.ApplyTheme()
Funcs.InitDefaultScripts()

Funcs.Dragify(UI.Show)

Funcs.CreateExeTab("Tab 1")

UI.AddExeTabBtn.MouseButton1Click:Connect(function()
    Funcs.CreateExeTab()
end)

UI.Show.MouseButton1Click:Connect(function()
    Funcs.OpenUI()
end)

UI.CloseTab.MouseButton1Click:Connect(function()
    Funcs.CloseUI()
end)

UI.Save.MouseButton1Click:Connect(function()
    local scriptName = UI.NameBox.Text
    local scriptDesc = UI.DescBox.Text
    local scriptCode = UI.ScriptBox.Text
    if scriptName == "" then return end
    Funcs.SaveScript({ Name = scriptName, Description = scriptDesc, Source = scriptCode })
    UI.NewScriptFrame.Visible = false
    UI.NameBox.Text = ""
    UI.DescBox.Text = ""
    UI.ScriptBox.Text = ""
    Funcs.RefreshSavedScripts(UI.SearchBox2.Text)
end)

UI.Cancel.MouseButton1Click:Connect(function()
    UI.NewScriptFrame.Visible = false
    UI.NameBox.Text = ""
    UI.DescBox.Text = ""
    UI.ScriptBox.Text = ""
end)

UI.NewScriptBtn.MouseButton1Click:Connect(function()
    UI.NewScriptFrame.Visible = true
    UI.NameBox.Text = ""
    UI.DescBox.Text = ""
    UI.ScriptBox.Text = ""
end)

UI.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = UI.SearchBox.Text
    UI.PrevBtn.Visible = false
    UI.NextBtn.Visible = false
    if query ~= "" then
        Funcs.PerformSearch(query, 1)
    elseif Funcs.CurrentSource == "ScriptBlox" then
        Funcs.PerformSearch("", 1)
    else
        if UI.NoResultsLabel then UI.NoResultsLabel.Visible = false end
        Funcs.CurrentScripts = {}
        Funcs.RenderSearchResults()
    end
end)

UI.PrevBtn.MouseButton1Click:Connect(function()
    if currentPage > 1 then Funcs.PerformSearch(currentQuery, currentPage - 1) end
end)

UI.NextBtn.MouseButton1Click:Connect(function()
    if currentPage < totalPages then Funcs.PerformSearch(currentQuery, currentPage + 1) end
end)

UI.SourceBtn.MouseButton1Click:Connect(function()
    Funcs.CycleSource()
end)

UI.FilterBtn.MouseButton1Click:Connect(function()
    Funcs.CycleFilter()
end)

UI.SearchBox2:GetPropertyChangedSignal("Text"):Connect(function()
    Funcs.RefreshSavedScripts(UI.SearchBox2.Text)
end)

UI.ExeBtn.MouseButton1Click:Connect(function()
    if ExeActiveTab then
        local code = ExeActiveTab.inputBox.Text
        if code and code ~= "" then
            loadstring(code)()
        end
    end
end)

UI.ClrBtn.MouseButton1Click:Connect(function()
    if ExeActiveTab then ExeActiveTab.inputBox.Text = "" end
end)

UI.CopyBtn.MouseButton1Click:Connect(function()
    if ExeActiveTab then SetClipboard(ExeActiveTab.inputBox.Text) end
end)

UI.AnimsToggle.MouseButton1Click:Connect(function()
    Settings.Animations = not Settings.Animations
    if UI.ToggleState then
        local col = Settings.Animations and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if Settings.Animations then
            TweenService:Create(UI.ToggleState, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = col }):Play()
            local stroke = UI.ToggleState:FindFirstChildOfClass("UIStroke")
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), { Color = col }):Play() end
        else
            TweenService:Create(UI.ToggleState, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = col }):Play()
            local stroke = UI.ToggleState:FindFirstChildOfClass("UIStroke")
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), { Color = col }):Play() end
        end
    end
    Funcs.SaveSettings()
end)

UI.ResetThemeBtn.MouseButton1Click:Connect(function()
    Settings.BackgroundColor = Color3.fromRGB(0, 0, 0)
    Settings.SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10)
    Settings.AccentColor = Color3.fromRGB(0, 99, 255)
    Settings.SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
    Funcs.ApplyTheme()
    Funcs.SaveSettings()
end)

UI.MusicPlayBtn.MouseButton1Click:Connect(function()
    if not MusicSound or not MusicSound.Parent then
        MusicFiles = Funcs.GetMusicFiles()
        if #MusicFiles > 0 then
            Funcs.LoadAndPlayMusic(MusicIndex)
        end
        return
    end
    if MusicPlaying then
        MusicSound:Pause()
        MusicPlaying = false
        UI.MusicPlayBtn.Text = "▶"
    else
        MusicSound:Resume()
        MusicPlaying = true
        UI.MusicPlayBtn.Text = "I I"
    end
end)

UI.MusicPrevBtn.MouseButton1Click:Connect(function()
    MusicFiles = Funcs.GetMusicFiles()
    if #MusicFiles > 0 then
        Funcs.LoadAndPlayMusic(MusicIndex - 1)
    end
end)

UI.MusicNextBtn.MouseButton1Click:Connect(function()
    MusicFiles = Funcs.GetMusicFiles()
    if #MusicFiles > 0 then
        Funcs.LoadAndPlayMusic(MusicIndex + 1)
    end
end)

UI.MusicLoopToggle.MouseButton1Click:Connect(function()
    local isLooped = UI.MusicLoopState.BackgroundColor3 == Color3.fromRGB(0, 255, 0)
    local newColor = isLooped and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    UI.MusicLoopState.BackgroundColor3 = newColor
    if MusicSound then MusicSound.Looped = not isLooped end
end)

UI.MusicVolumeBox:GetPropertyChangedSignal("Text"):Connect(function()
    local vol = tonumber(UI.MusicVolumeBox.Text)
    if vol and MusicSound then
        MusicSound.Volume = math.clamp(vol, 0, 10)
    end
end)

UI.MusicSpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local speed = tonumber(UI.MusicSpeedBox.Text)
    if speed and MusicSound then
        MusicSound.PlaybackSpeed = math.clamp(speed, 0.1, 10)
    end
end)

local sliderDragging = false
local sliderInputConn

UI.MusicSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        MusicSliderDragging = true
        local function UpdateFromInput(inp)
            local barPos = UI.MusicSliderBar.AbsolutePosition.X
            local barSize = UI.MusicSliderBar.AbsoluteSize.X
            local frac = math.clamp((inp.Position.X - barPos) / barSize, 0, 1)
            UI.MusicSliderFill.Size = UDim2.new(frac, 0, 1, 0)
            UI.MusicSliderKnob.Position = UDim2.new(frac, -6, 0.5, -6)
            if MusicSound and MusicSound.TimeLength and MusicSound.TimeLength > 0 then
                MusicSound.TimePosition = frac * MusicSound.TimeLength
                UI.MusicTimeLabel.Text = Funcs.FormatTime(MusicSound.TimePosition) .. " / " .. Funcs.FormatTime(MusicSound.TimeLength)
            end
        end
        UpdateFromInput(input)
        if sliderInputConn then sliderInputConn:Disconnect() end
        sliderInputConn = UserInputService.InputChanged:Connect(function(inp)
            if sliderDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                UpdateFromInput(inp)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                sliderDragging = false
                MusicSliderDragging = false
                if sliderInputConn then sliderInputConn:Disconnect() end
            end
        end)
    end
end)

Funcs.SwitchTab(UI.HomeTab)
Funcs.SetAllUnderlines(UI.HomeTab)

UI.Show.Visible = true
UI.MainFrame.Visible = false

coroutine.wrap(function()
    while UI.ScreenGui and UI.ScreenGui.Parent do
        Funcs.UpdateStats()
        Funcs.UpdateMusicSlider()
        Wait(0.5)
    end
end)()

Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        Funcs.ClearCache()
        if MusicSound then MusicSound:Stop(); MusicSound:Destroy() end
    end
end)