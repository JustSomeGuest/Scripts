if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Shared = (function()
    local Success, Env = pcall(getgenv)
    return (Success and Env) or _G or (warn("[Shared]: Failed to access a usable global environment.") or {})
end)()

local function expect(expected, value, valueName, fallback)
    if type(value) == expected then
        return value
    end

    valueName = valueName or "value"

    if fallback ~= nil then
        if type(fallback) == "function" then
            warn(string.format("[Expect]: Missing %s. Using fallback function.", valueName))

            return function(...)
                return fallback(...)
            end
        end

        warn(string.format("[Expect]: Missing %s. Using fallback value.", valueName))
    else
        warn(string.format("[Expect]: Missing %s.", valueName))
    end

    return fallback
end

local CloneRef = expect("function", cloneref, "cloneref", function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return CloneRef(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Success, Hui = pcall(function()
    return gethui and gethui()
end)

local CoreGui = Success and typeof(Hui) == "Instance" and Hui or Services.CoreGui

local Workspace = Services.Workspace
local HttpService = Services.HttpService
local Players = Services.Players
local Player = Players.LocalPlayer
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService
local StarterGui = Services.StarterGui
local RunService = Services.RunService

local WriteFile = expect("function", writefile, "writefile", function() return end)
local ReadFile = expect("function", readfile, "readfile", function() return end)
local DelFile = expect("function", delfile, "delfile", function() return end)
local IsFile = expect("function", isfile, "isfile", function() return end)
local IsFolder = expect("function", isfolder, "isfolder", function() return end)
local MakeFolder = expect("function", makefolder, "makefolder", function() return end)
local ListFiles = expect("function", listfiles, "listfiles", function() return end)
local LoadAsset = expect("function", getcustomasset, "getcustomasset", expect("function", getsynasset, "getsynasset", function() return end))
local SetClipboard = expect("function", setclipboard, "setclipboard", function() return end)

local GothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local GothamMedium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local BuilderSans = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local Inconsolata = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local Wait = task.wait

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

Shared.Lucid = {
    UI = {},
    Funcs = {},
    Assets = {
        ["Lucid/Assets/lucid_logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/logo.png",
        ["Lucid/Assets/lucid_home.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/home.png",
        ["Lucid/Assets/lucid_executor.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/executor.png",
        ["Lucid/Assets/lucid_search.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/search.png",
        ["Lucid/Assets/lucid_scripts.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/scripts.png",
        ["Lucid/Assets/lucid_settings.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/settings.png",
        ["Lucid/Assets/lucid_close.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/close.png",
    },
    Settings = {
        Animations = true,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10),
        AccentColor = Color3.fromRGB(0, 99, 255),
        SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
    },
    IsLoaded = false
}

local UI = Shared.Lucid.UI
local Funcs = Shared.Lucid.Funcs
local Assets = Shared.Lucid.Assets
local Settings = Shared.Lucid.Settings
local currentPage = 1
local totalPages = 1
local currentQuery = ""

Funcs.Sources = {"RScripts", "ScriptBlox"}
Funcs.CurrentSource = "RScripts"
Funcs.Filters = {"All", "Key", "Keyless"}
Funcs.CurrentFilter = "All"
Funcs.CurrentScripts = {}

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
    "Color3", "Vector2", "Vector3", "CFrame", "UDim", "UDim2", "Rect", "Region3",
    "BrickColor", "NumberSequence", "ColorSequence", "NumberRange", "Random",
    "Enum", "EnumItem", "Instance", "Terrain", "Workspace", "TweenService",
    "RunService", "Players", "ReplicatedStorage", "ServerScriptService",
    "ServerStorage", "Lighting", "SoundService", "StarterGui", "StarterPack",
    "StarterPlayer", "TeleportService", "DataStoreService", "HttpService",
    "MarketplaceService", "UserInputService", "ContextActionService",
    "CollectionService", "Debris", "FriendsService", "GroupService", "GuidesService",
    "InsertService", "NetworkClient", "NetworkServer", "PackageService",
    "PhysicsService", "PointService", "AnalyticsService", "AvatarService",
    "Backpack", "BanService", "BulkImportService", "ChatService", "ContentProvider",
    "CookieService", "CoreGui", "CreatorStore", "DeveloperFramework", "Dialog",
    "EditorService", "FaceControls", "GamePassService", "GeometryService",
    "GlobalSettings", "GltfService", "HttpRbxApiService", "JointService"
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
            local str = code:sub(start, i - 1)
            str = str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.String .. "\">" .. str .. "</font>")
        elseif char == "[" and code:sub(i, i + 1) == "[[" then
            local start = i
            local depth = 0
            while i <= len do
                if code:sub(i, i + 1) == "[[" then
                    depth = depth + 1
                    i = i + 2
                elseif code:sub(i, i + 1) == "]]" then
                    depth = depth - 1
                    i = i + 2
                    if depth == 0 then break end
                else
                    i = i + 1
                end
            end
            local str = code:sub(start, i - 1)
            str = str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.String .. "\">" .. str .. "</font>")
        elseif char == "-" and code:sub(i, i + 1) == "--" then
            if code:sub(i, i + 2) == "--[" and code:sub(i, i + 3) == "--[[" then
                local start = i
                i = i + 4
                local depth = 0
                while i <= len do
                    if code:sub(i, i + 1) == "[[" then
                        depth = depth + 1
                        i = i + 2
                    elseif code:sub(i, i + 1) == "]]" then
                        depth = depth - 1
                        i = i + 2
                        if depth == 0 then break end
                    else
                        i = i + 1
                    end
                end
                local str = code:sub(start, i - 1)
                str = str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Comment .. "\">" .. str .. "</font>")
            else
                local start = i
                while i <= len do
                    local ch = code:sub(i, i)
                    if ch == "\n" or ch == "\r" then break end
                    i = i + 1
                end
                local str = code:sub(start, i - 1)
                str = str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Comment .. "\">" .. str .. "</font>")
            end
        elseif char:match("%d") then
            local start = i
            while i <= len do
                local ch = code:sub(i, i)
                if not ch:match("%d") and ch ~= "." then break end
                i = i + 1
            end
            local str = code:sub(start, i - 1)
            str = str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            table.insert(result, "<font color=\"" .. HighlightColors.Number .. "\">" .. str .. "</font>")
        elseif char:match("%a") or char == "_" then
            local start = i
            while i <= len do
                local ch = code:sub(i, i)
                if not ch:match("%w") and ch ~= "_" then break end
                i = i + 1
            end
            local word = code:sub(start, i - 1)
            
            if word == "nil" then
                word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Nil .. "\">" .. word .. "</font>")
            elseif word == "true" or word == "false" then
                word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Boolean .. "\">" .. word .. "</font>")
            elseif KeywordSet[word] then
                word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Keyword .. "\">" .. word .. "</font>")
            elseif GlobalSet[word] then
                word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                table.insert(result, "<font color=\"" .. HighlightColors.Global .. "\">" .. word .. "</font>")
            else
                local nextChar = code:sub(i, i)
                if nextChar == "(" then
                    word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    table.insert(result, "<font color=\"" .. HighlightColors.Function .. "\">" .. word .. "</font>")
                else
                    word = word:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    table.insert(result, "<font color=\"" .. HighlightColors.Identifier .. "\">" .. word .. "</font>")
                end
            end
        else
            if char == "&" then
                table.insert(result, "&amp;")
            elseif char == "<" then
                table.insert(result, "&lt;")
            elseif char == ">" then
                table.insert(result, "&gt;")
            else
                table.insert(result, char)
            end
            i = i + 1
        end
    end
    
    return table.concat(result)
end

local function HideExec()
    local Safe = {
        RobloxGui = true,
        PlayerList = true,
        ExperienceChat = true,
        BubbleChat = true,
        DevConsole = true,
        SocialService = true,
        PerformanceStats = true,
        ScreenShotTool = true,
        EmotesMenu = true,
        CallDialogScreen = true,
        CaptureManager = true,
        CaptureOverlay = true,
        Composer = true,
        ContactList = true,
        Chat = true,
        HeadsetDisconnectedDialog = true,
        InExperienceInterventionApp = true,
        PlayerMenuScreen = true,
        PurchasePromptApp = true,
        RobloxPromptGui = true,
        ScreenshotsCarousel = true,
        TeleportEffectGui = true,
        TopBarApp = true,
        ControlGui = true,
        VehicleGui = true,
        NotificationGui = true,
        DescendantProtector = true,
        AppUpdaterGui = true,
        FaceTrackingGui = true,
        ExperienceNotificationGui = true,
        VoiceChatGui = true,
        SafetyCheckGui = true,
        ToastGui = true,
        InGameMenuV2 = true,
        RightClickMenu = true,
        VoiceChatPromptGui = true,
        BottomBarGui = true,
        GuiService = true,
        FullscreenTitleBar = true,
        TextureView = true,
        ChromeGui = true,
        BlockingApp = true,
        HealthGui = true,
        StutterDetector = true,
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

        if Caps >= 5 then
            return true
        end

        return false
    end

    local function Scan(Parent)
        if not Parent then
            return
        end

        for _, Obj in ipairs(Parent:GetDescendants()) do
            if Obj:IsA("ScreenGui")
                and Obj.Name ~= "__Inventory"
                and Obj.Name ~= "SimpleCMDS"
                and not Safe[Obj.Name]
                and IsSus(Obj.Name) then

                pcall(function()
                    Obj.Enabled = false
                end)
            end
        end
    end

    Scan(Services.CoreGui)

    if Hui and Hui ~= Services.CoreGui then
        Scan(Hui)
    end
end

function Funcs.HttpGet(url)
    local RequestFunc = expect("function", syn and syn.request, "syn.request",
        expect("function", request, "request",
            expect("function", http_request, "http_request", function() return end)))

    if not RequestFunc then
        return nil
    end

    local success, result = pcall(function()
        return RequestFunc({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Lucid-Executor/1.0",
                ["Accept"] = "application/json"
            }
        })
    end)

    return success and result or nil
end

function Funcs.GetAsset(Path)
    if not LoadAsset then return nil end
    if not IsFolder("Lucid") then MakeFolder("Lucid") end
    if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
    if Path:match("^rbxassetid://") then return Path end
    if IsFile(Path) then
        return LoadAsset(Path)
    end
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
    if cleaned == "" then
        cleaned = "Script_" .. HttpService:GenerateGUID(false):sub(1, 8)
    end
    return cleaned
end

function Funcs.ClearCache()
    if IsFolder("Lucid/Cache") then
        local files = ListFiles("Lucid/Cache")
        for _, file in ipairs(files) do
            pcall(function()
                DelFile(file)
            end)
        end
    end
end

function Funcs.LoadSavedScripts()
    if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts"); return {} end
    local files = ListFiles("Lucid/Scripts")
    local scripts = {}
    for _, file in ipairs(files) do
        local content = ReadFile(file)
        local success, data = pcall(function() return HttpService:JSONDecode(content) end)
        if success and data then table.insert(scripts, data) end
    end
    return scripts
end

function Funcs.SaveScript(scriptData)
    if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts") end
    local fileName = "Lucid/Scripts/" .. scriptData.Name:gsub("[^%w]", "_") .. ".json"
    WriteFile(fileName, HttpService:JSONEncode(scriptData))
end

function Funcs.DeleteScript(scriptName)
    local fileName = "Lucid/Scripts/" .. scriptName:gsub("[^%w]", "_") .. ".json"
    if IsFile(fileName) then
        DelFile(fileName)
    end
end

function Funcs.ParseColor(input)
    if type(input) ~= "string" then return nil end
    local r, g, b = input:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r and g and b then
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
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
    WriteFile("Lucid/Settings.json", HttpService:JSONEncode(data))
end

function Funcs.LoadSettings()
    if not IsFile("Lucid/Settings.json") then return end
    local content = ReadFile("Lucid/Settings.json")
    if not content or content == "" then return end
    local success, data = pcall(function() return HttpService:JSONDecode(content) end)
    if success and data then
        if data.Animations ~= nil then Settings.Animations = data.Animations end
        if data.BackgroundColor then Settings.BackgroundColor = Color3.fromRGB(data.BackgroundColor.R or 10, data.BackgroundColor.G or 10, data.BackgroundColor.B or 10) end
        if data.SecondaryBackgroundColor then Settings.SecondaryBackgroundColor = Color3.fromRGB(data.SecondaryBackgroundColor.R or 18, data.SecondaryBackgroundColor.G or 18, data.SecondaryBackgroundColor.B or 18) end
        if data.AccentColor then Settings.AccentColor = Color3.fromRGB(data.AccentColor.R or 0, data.AccentColor.G or 99, data.AccentColor.B or 255) end
        if data.SecondaryAccentColor then Settings.SecondaryAccentColor = Color3.fromRGB(data.SecondaryAccentColor.R or 0, data.SecondaryAccentColor.G or 64, data.SecondaryAccentColor.B or 180) end
    end
end

function Funcs.ScriptRequiresKey(data)
    local value = Funcs.CurrentSource == "ScriptBlox" and data.key or data.keySystem
    if type(value) == "boolean" then
        return value
    end
    if type(value) == "number" then
        return value ~= 0
    end
    if type(value) == "string" then
        local normalized = value:lower()
        if normalized == "" or normalized == "false" or normalized == "0" or normalized == "none" or normalized == "n/a" then
            return false
        end
        if normalized:find("no key", 1, true) or normalized:find("keyless", 1, true) then
            return false
        end
        return true
    end
    return value ~= nil and value ~= false
end

function Funcs.PassesFilter(data)
    local requiresKey = Funcs.ScriptRequiresKey(data)
    if Funcs.CurrentFilter == "Key" then
        return requiresKey
    elseif Funcs.CurrentFilter == "Keyless" then
        return not requiresKey
    end
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
        if query ~= "" then
            url = url .. "&q=" .. HttpService:UrlEncode(query)
        end
    else
        if query ~= "" then
            url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&page=" .. page
        else
            url = "https://scriptblox.com/api/script/fetch?page=" .. page
        end
    end

    local Response = Funcs.HttpGet(url)
    if not Response or not Response.Body then
        return nil, nil
    end

    local success, decoded = pcall(function() return HttpService:JSONDecode(Response.Body) end)
    if not success or not decoded then
        return nil, nil
    end

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

    local clone = UI["SearchResultTemplate"]:Clone()
    clone["Name"] = Funcs.SanitizeName(title)
    clone["Visible"] = true
    clone["Parent"] = parent

    local cloneStroke = clone:FindFirstChildOfClass("UIStroke")
    if cloneStroke then
        cloneStroke["Color"] = Settings.SecondaryAccentColor
    end

    local scriptImage = clone:FindFirstChild("ScriptImage")
    if scriptImage then
        scriptImage["Image"] = Funcs.ResolveImage(data)
    end

    local container = clone:FindFirstChild("Container")
    if container then
        local scriptName = container:FindFirstChild("ScriptName")
        if scriptName then
            scriptName["Text"] = title
            local nameStroke = scriptName:FindFirstChildOfClass("UIStroke")
            if nameStroke then nameStroke["Color"] = Settings.AccentColor end
        end
    end

    local actionsFrame = container and container:FindFirstChild("ScriptActions")
    if actionsFrame then
        local runBtn = actionsFrame:FindFirstChild("RunScript")
        local copyBtn = actionsFrame:FindFirstChild("CopyScriptBtn")
        local saveBtn = actionsFrame:FindFirstChild("SaveScriptBtn")

        for _, btn in ipairs({runBtn, copyBtn, saveBtn}) do
            if btn then
                btn["BackgroundColor3"] = Settings.AccentColor
                local btnStroke = btn:FindFirstChildOfClass("UIStroke")
                if btnStroke then btnStroke["Color"] = Settings.SecondaryAccentColor end
            end
        end

        local function ResolveCode()
            if rawScript == "" then return nil end
            if isScriptBlox then
                return rawScript
            end
            local success, content = pcall(function() return game:HttpGet(rawScript) end)
            return success and content or nil
        end

        if runBtn then
            runBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    local success, err = loadstring(code)()
                    if not success then warn("Failed to execute script: ", err) end
                end
            end)
        end

        if copyBtn then
            copyBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    SetClipboard(code)
                    copyBtn["Text"] = "Copied!"
                    task.delay(1, function()
                        copyBtn["Text"] = "Copy"
                    end)
                end
            end)
        end

        if saveBtn then
            saveBtn.MouseButton1Click:Connect(function()
                local code = ResolveCode()
                if code then
                    local scriptData = {
                        Name = title,
                        Description = data.description or "",
                        Code = code
                    }
                    Funcs.SaveScript(scriptData)
                    saveBtn["Text"] = "Saved!"
                    task.delay(1, function()
                        saveBtn["Text"] = "Save"
                    end)
                    Funcs.RefreshSavedScripts(UI["SearchBox2"]["Text"])
                end
            end)
        end
    end
end

function Funcs.RenderSearchResults()
    local results = UI["SearchResults"]
    if not results then return end

    for _, child in ipairs(results:GetChildren()) do
        if child ~= UI["NoResultsLabel"] and child ~= UI["SearchResultsPadding"] and child ~= UI["SearchResultsLayout"] and child ~= UI["SearchResultTemplate"] then
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
        if UI["NoResultsLabel"] then
            UI["NoResultsLabel"]["Visible"] = true
            if #Funcs.CurrentScripts == 0 then
                UI["NoResultsLabel"]["Text"] = (currentQuery ~= "") and "No scripts found matching your query." or "No scripts found."
            else
                UI["NoResultsLabel"]["Text"] = "No scripts match the current filter."
            end
        end
    elseif UI["NoResultsLabel"] then
        UI["NoResultsLabel"]["Visible"] = false
    end
end

function Funcs.PerformSearch(query, page)
    page = page or 1
    currentQuery = query
    currentPage = page

    if UI["NoResultsLabel"] then UI["NoResultsLabel"]["Visible"] = false end
    UI["PrevBtn"]["Visible"] = false
    UI["NextBtn"]["Visible"] = false

    local scripts, pages = Funcs.FetchScripts(query, page)

    if not scripts then
        Funcs.CurrentScripts = {}
        Funcs.RenderSearchResults()
        if UI["NoResultsLabel"] then
            UI["NoResultsLabel"]["Visible"] = true
            UI["NoResultsLabel"]["Text"] = "Failed to fetch scripts. Check your connection and try again."
        end
        return
    end

    totalPages = pages or 1
    Funcs.CurrentScripts = scripts

    UI["PrevBtn"]["Visible"] = page > 1
    UI["NextBtn"]["Visible"] = page < totalPages

    Funcs.RenderSearchResults()
end

function Funcs.CycleSource()
    local index = table.find(Funcs.Sources, Funcs.CurrentSource) or 1
    Funcs.CurrentSource = Funcs.Sources[index % #Funcs.Sources + 1]

    if Funcs.CurrentSource == "RScripts" then
        UI["SourceBtn"]["Text"] = "🟢 Source: RScripts"
    else
        UI["SourceBtn"]["Text"] = "⚠️ Source: ScriptBlox"
    end

    Funcs.PerformSearch(currentQuery, 1)
end

function Funcs.CycleFilter()
    local index = table.find(Funcs.Filters, Funcs.CurrentFilter) or 1
    Funcs.CurrentFilter = Funcs.Filters[index % #Funcs.Filters + 1]
    UI["FilterBtn"]["Text"] = "Filter: " .. Funcs.CurrentFilter
    Funcs.RenderSearchResults()
end

function Funcs.ApplyTheme()
    UI["MainFrame"]["BackgroundColor3"] = Settings.BackgroundColor
    UI["HomeContent"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    UI["ExeContent"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    UI["SearchContent"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    UI["ScriptsContent"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    UI["SettingsContent"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    UI["Sidebar"]["BackgroundColor3"] = Settings.SecondaryBackgroundColor
    
    UI["HomeContentStroke"]["Color"] = Settings.AccentColor
    UI["ExeContentStroke"]["Color"] = Settings.AccentColor
    UI["SearchContentStroke"]["Color"] = Settings.AccentColor
    UI["ScriptsContentStroke"]["Color"] = Settings.AccentColor
    UI["SettingsContentStroke"]["Color"] = Settings.AccentColor
    UI["SidebarStroke"]["Color"] = Settings.AccentColor
    UI["NewScriptFrameStroke"]["Color"] = Settings.AccentColor
    
    UI["Title"]["TextColor3"] = Settings.AccentColor
    UI["TitleStroke"]["Color"] = Settings.AccentColor
    UI["Icon"]["ImageColor3"] = Settings.AccentColor
    UI["Logo"]["ImageColor3"] = Settings.SecondaryAccentColor
    
    UI["TabUnderline"]["BackgroundColor3"] = Settings.AccentColor
    UI["TabUnderline2"]["BackgroundColor3"] = Settings.AccentColor
    UI["TabUnderline3"]["BackgroundColor3"] = Settings.AccentColor
    UI["TabUnderline4"]["BackgroundColor3"] = Settings.AccentColor
    UI["TabUnderline5"]["BackgroundColor3"] = Settings.AccentColor
    
    UI["NoResultsLabelStroke"]["Color"] = Settings.AccentColor
    UI["NoSavedScriptsLabelStroke"]["Color"] = Settings.AccentColor
    UI["SearchResultTemplateStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["ScriptNameStroke"]["Color"] = Settings.AccentColor
    UI["SavedScriptTemplateStroke"]["Color"] = Settings.SecondaryAccentColor
    
    UI["ExeBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["ClrBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["CopyBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["RunScript"]["BackgroundColor3"] = Settings.AccentColor
    UI["CopyScriptBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["SaveScriptBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["PrevBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["NextBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["Cancel"]["BackgroundColor3"] = Settings.AccentColor
    UI["Save"]["BackgroundColor3"] = Settings.AccentColor
    UI["RunSavedScript"]["BackgroundColor3"] = Settings.AccentColor
    UI["DeleteSavedScript"]["BackgroundColor3"] = Settings.AccentColor
    UI["SourceBtn"]["BackgroundColor3"] = Settings.AccentColor
    UI["FilterBtn"]["BackgroundColor3"] = Settings.AccentColor
    
    UI["ExeBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["ClrBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["CopyBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["RunScriptStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["CopyScriptBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["SaveScriptBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["PrevBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["NextBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["CancelStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["SaveStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["RunSavedScriptStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["DeleteSavedScriptStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["SourceBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["FilterBtnStroke"]["Color"] = Settings.SecondaryAccentColor
    
    UI["WelcomeLabelStroke"]["Color"] = Settings.AccentColor
    UI["InfoLabelStroke"]["Color"] = Settings.SecondaryAccentColor
    UI["InfoLabel2Stroke"]["Color"] = Settings.SecondaryAccentColor
    UI["PlayerHeadshotStroke"]["Color"] = Settings.SecondaryAccentColor
    
    if not Settings.Animations then
        UI["ToggleState"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0)
        local stroke = UI["ToggleState"]:FindFirstChildOfClass("UIStroke")
        if stroke then stroke["Color"] = Color3.fromRGB(255, 0, 0) end
    else
        UI["ToggleState"]["BackgroundColor3"] = Color3.fromRGB(0, 255, 0)
        local stroke = UI["ToggleState"]:FindFirstChildOfClass("UIStroke")
        if stroke then stroke["Color"] = Color3.fromRGB(0, 255, 0) end
    end

    if UI["SearchResults"] then
        Funcs.RenderSearchResults()
    end

    if UI["SavedScriptsScroll"] then
        Funcs.RefreshSavedScripts(UI["SearchBox2"] and UI["SearchBox2"]["Text"] or "")
    end
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
    local executor = syn and "Synapse X" or krnl and "Krnl" or script and "Unknown"
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

    if UI["InfoLabel"] then
        UI["InfoLabel"]["Text"] = infoText
    end

    if UI["WelcomeLabel"] then
        UI["WelcomeLabel"]["Text"] = "Welcome to Lucid, " .. displayName .. "!"
    end

    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    if UI["PlayerHeadshot"] then
        UI["PlayerHeadshot"]["Image"] = avatarUrl
    end
end

function Funcs.RefreshSavedScripts(searchQuery)
    local scroll = UI["SavedScriptsScroll"]
    if not scroll then return end
    
    for _, child in ipairs(scroll:GetChildren()) do
        if child ~= UI["NoSavedScriptsLabel"] and child ~= UI["SavedScriptsScrollPadding"] and child ~= UI["SavedScriptsScrollLayout"] and child ~= UI["SavedScriptTemplate"] then
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
        if UI["NoSavedScriptsLabel"] then
            UI["NoSavedScriptsLabel"]["Visible"] = true
            UI["NoSavedScriptsLabel"]["Text"] = (searchQuery and searchQuery ~= "") and [[No saved scripts match your search.]] or [[No Saved Scripts

Save some scripts to see them here.]]
        end
        return
    end
    
    if UI["NoSavedScriptsLabel"] then
        UI["NoSavedScriptsLabel"]["Visible"] = false
    end
    
    for _, scriptData in ipairs(scripts) do
        local clone = UI["SavedScriptTemplate"]:Clone()
        clone["Name"] = Funcs.SanitizeName(scriptData.Name)
        clone["Visible"] = true
        clone["Parent"] = scroll

        local cloneStroke = clone:FindFirstChildOfClass("UIStroke")
        if cloneStroke then cloneStroke["Color"] = Settings.SecondaryAccentColor end
        
        local infoFrame = clone:FindFirstChild("SavedScriptInfo")
        if infoFrame then
            local titleLabel = infoFrame:FindFirstChild("SavedScriptTitle")
            local descLabel = infoFrame:FindFirstChild("SavedScriptDesc")
            if titleLabel then titleLabel["Text"] = scriptData.Name or "Unknown" end
            if descLabel then descLabel["Text"] = scriptData.Description or "No description" end
        end
        
        local actionsFrame = clone:FindFirstChild("SavedScriptActions")
        if actionsFrame then
            local runBtn = actionsFrame:FindFirstChild("RunSavedScript")
            local deleteBtn = actionsFrame:FindFirstChild("DeleteSavedScript")

            for _, btn in ipairs({runBtn, deleteBtn}) do
                if btn then
                    btn["BackgroundColor3"] = Settings.AccentColor
                    local btnStroke = btn:FindFirstChildOfClass("UIStroke")
                    if btnStroke then btnStroke["Color"] = Settings.SecondaryAccentColor end
                end
            end

            if runBtn then
                runBtn.MouseButton1Click:Connect(function()
                    local success, err = loadstring(scriptData.Code or "")()
                    if not success then warn("Failed to execute saved script: ", err) end
                end)
            end
            if deleteBtn then
                deleteBtn.MouseButton1Click:Connect(function()
                    Funcs.DeleteScript(scriptData.Name)
                    Funcs.RefreshSavedScripts(UI["SearchBox2"]["Text"])
                end)
            end
        end
    end
end

function Funcs.SwitchTab(tabButton)
    local contentMap = {
        [UI["HomeTab"]] = UI["HomeContent"],
        [UI["ExeTab"]] = UI["ExeContent"],
        [UI["SearchTab"]] = UI["SearchContent"],
        [UI["ScriptsTab"]] = UI["ScriptsContent"],
        [UI["SettingsTab"]] = UI["SettingsContent"]
    }
    
    local newContent = contentMap[tabButton]
    if not newContent then return end
    
    local oldContent = nil
    for tab, content in pairs(contentMap) do
        if content and content ~= newContent and content["Visible"] then
            oldContent = content
            break
        end
    end
    
    if oldContent == newContent then return end
    
    if oldContent then
        oldContent["Visible"] = false
    end
    
    newContent["Visible"] = true
    
    if Settings.Animations then
        newContent["Position"] = UDim2.new(-1, 0, 0, 0)
        TweenService:Create(newContent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    else
        newContent["Position"] = UDim2.new(0, 0, 0, 0)
    end
    
    if newContent == UI["HomeContent"] then
        Funcs.UpdateStats()
    end
    
    if newContent == UI["ScriptsContent"] then
        Funcs.RefreshSavedScripts(UI["SearchBox2"]["Text"])
    end
end

function Funcs.UpdateUnderline(tabButton, active)
    local underline = tabButton:FindFirstChild("TabUnderline") or tabButton:FindFirstChild("TabUnderline2") or tabButton:FindFirstChild("TabUnderline3") or tabButton:FindFirstChild("TabUnderline4") or tabButton:FindFirstChild("TabUnderline5")
    if not underline then return end
    
    if active then
        if Settings.Animations then
            TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 1)
            }):Play()
        else
            underline["Size"] = UDim2.new(1, 0, 0, 1)
        end
    else
        if Settings.Animations then
            TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 0, 0, 1)
            }):Play()
        else
            underline["Size"] = UDim2.new(0, 0, 0, 1)
        end
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

        local maxX = viewport.X - size.X - paddingX
        local maxY = viewport.Y - size.Y - paddingY
        local minX = paddingX
        local minY = paddingY

        newX = math.clamp(newX, minX, maxX)
        newY = math.clamp(newY, minY, maxY)

        return newX, newY
    end

    Object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
    local contents = {UI["HomeContent"], UI["ExeContent"], UI["SearchContent"], UI["ScriptsContent"], UI["SettingsContent"]}
    for _, content in ipairs(contents) do
        if content and content["Visible"] then
            return content
        end
    end
    return UI["HomeContent"]
end

function Funcs.OpenUI()
    UI["MainFrame"]["Visible"] = true
    UI["MainFrame"]["BackgroundTransparency"] = 1

    local activeContent = Funcs.GetActiveContent()

    activeContent["Position"] = UDim2.new(-1, 0, 0, 0)
    UI["Sidebar"]["Position"] = UDim2.new(1.2, 8, 0.5, 0)

    if Settings.Animations then
        local bgTween = TweenService:Create(UI["MainFrame"], TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.35
        })

        local contentTween = TweenService:Create(activeContent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        })

        local sidebarTween = TweenService:Create(UI["Sidebar"], TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 8, 0.5, 0)
        })

        local showTween = TweenService:Create(UI["Show"], TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        })

        bgTween:Play()
        contentTween:Play()
        sidebarTween:Play()
        showTween:Play()
    else
        UI["MainFrame"]["BackgroundTransparency"] = 0.35
        activeContent["Position"] = UDim2.new(0, 0, 0, 0)
        UI["Sidebar"]["Position"] = UDim2.new(1, 8, 0.5, 0)
        UI["Show"]["ImageTransparency"] = 1
        UI["Show"]["BackgroundTransparency"] = 1
    end

    UI["Show"]["Visible"] = false
    Funcs.UpdateStats()
end

function Funcs.CloseUI()
    local activeContent = Funcs.GetActiveContent()

    if Settings.Animations then
        local bgTween = TweenService:Create(UI["MainFrame"], TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })

        local contentTween = TweenService:Create(activeContent, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(-1, 0, 0, 0)
        })

        local sidebarTween = TweenService:Create(UI["Sidebar"], TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1.2, 8, 0.5, 0)
        })

        local showTween = TweenService:Create(UI["Show"], TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            ImageTransparency = 0,
            BackgroundTransparency = 0.08
        })

        bgTween:Play()
        contentTween:Play()
        sidebarTween:Play()
        showTween:Play()

        contentTween.Completed:Wait()

        UI["MainFrame"]["Visible"] = false
        UI["Show"]["Visible"] = true
    else
        UI["MainFrame"]["BackgroundTransparency"] = 1
        UI["MainFrame"]["Visible"] = false
        UI["Show"]["Visible"] = true
        UI["Show"]["ImageTransparency"] = 0
        UI["Show"]["BackgroundTransparency"] = 0.08
        activeContent["Position"] = UDim2.new(0, 0, 0, 0)
        UI["Sidebar"]["Position"] = UDim2.new(1, 8, 0.5, 0)
    end
end

function Funcs.CreateTab(iconPath, labelText, content, layoutOrder)
    local tab = Instance.new("TextButton")
    tab["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    tab["BackgroundTransparency"] = 1
    tab["BorderSizePixel"] = 0
    tab["LayoutOrder"] = layoutOrder or 1
    tab["Name"] = labelText .. "Tab"
    tab["Size"] = UDim2.new(0, 30, 0, 58)
    tab["Text"] = ""
    tab["Parent"] = UI["Sidebar"]

    local tabLayout = Instance.new("UIListLayout")
    tabLayout["Name"] = labelText .. "TabLayout"
    tabLayout["Padding"] = UDim.new(0, 4)
    tabLayout["SortOrder"] = Enum.SortOrder.LayoutOrder
    tabLayout["VerticalFlex"] = Enum.UIFlexAlignment.Fill
    tabLayout["Parent"] = tab

    local tabSizeCons = Instance.new("UISizeConstraint")
    tabSizeCons["MaxSize"] = Vector2.new(2147483647, 34)
    tabSizeCons["MinSize"] = Vector2.new(0, 28)
    tabSizeCons["Name"] = labelText .. "TabSizeCons"
    tabSizeCons["Parent"] = tab

    local tabPadding = Instance.new("UIPadding")
    tabPadding["Name"] = labelText .. "TabPadding"
    tabPadding["PaddingBottom"] = UDim.new(0, 3)
    tabPadding["PaddingTop"] = UDim.new(0, 3)
    tabPadding["Parent"] = tab

    local container = Instance.new("Frame")
    container["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    container["BackgroundTransparency"] = 1
    container["BorderSizePixel"] = 0
    container["LayoutOrder"] = 1
    container["Name"] = "TabContainer"
    container["Size"] = UDim2.new(1, 0, 0, 22)
    container["Parent"] = tab

    local containerLayout = Instance.new("UIListLayout")
    containerLayout["FillDirection"] = Enum.FillDirection.Horizontal
    containerLayout["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
    containerLayout["Name"] = labelText .. "ContainerLayout"
    containerLayout["Padding"] = UDim.new(0, 4)
    containerLayout["SortOrder"] = Enum.SortOrder.LayoutOrder
    containerLayout["VerticalFlex"] = Enum.UIFlexAlignment.Fill
    containerLayout["Parent"] = container

    local icon = Instance.new("ImageLabel")
    icon["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    icon["BackgroundTransparency"] = 1
    icon["BorderSizePixel"] = 0
    icon["Image"] = Funcs.GetAsset(iconPath)
    icon["LayoutOrder"] = 1
    icon["Name"] = "TabIcon"
    icon["Size"] = UDim2.new(0, 30, 0, 30)
    icon["Parent"] = container

    local iconRatio = Instance.new("UIAspectRatioConstraint")
    iconRatio["Name"] = "TabIconRatio"
    iconRatio["Parent"] = icon

    local label = Instance.new("TextLabel")
    label["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    label["BackgroundTransparency"] = 1
    label["BorderSizePixel"] = 0
    label["FontFace"] = BuilderSans
    label["LayoutOrder"] = 2
    label["Name"] = "TabLabel"
    label["Size"] = UDim2.new(0, 60, 0, 30)
    label["Text"] = labelText
    label["TextColor3"] = Color3.fromRGB(255, 255, 255)
    label["TextScaled"] = true
    label["TextWrapped"] = true
    label["TextXAlignment"] = Enum.TextXAlignment.Left
    label["Parent"] = container

    local underline = Instance.new("Frame")
    underline["BackgroundColor3"] = Settings.AccentColor
    underline["BorderSizePixel"] = 0
    underline["LayoutOrder"] = 2
    underline["Name"] = "TabUnderline"
    underline["Size"] = UDim2.new(0, 0, 0, 1)
    underline["Parent"] = tab

    local underlineCorner = Instance.new("UICorner")
    underlineCorner["CornerRadius"] = UDim.new(0, 6)
    underlineCorner["Name"] = "TabUnderlineCorner"
    underlineCorner["Parent"] = underline
      
    UI[labelText .. "Tab"] = tab
    local underlineKey = (layoutOrder == 1) and "TabUnderline" or ("TabUnderline" .. tostring(layoutOrder))
    UI[underlineKey] = underline

    if content then
        content["Parent"] = UI["Pages"]
    end

    tab.MouseButton1Click:Connect(function()
        if content then
            Funcs.SwitchTab(tab)
            for _, child in ipairs(UI["Sidebar"]:GetChildren()) do
                if child:IsA("TextButton") and child ~= UI["CloseTab"] then
                    local childUnderline = child:FindFirstChild("TabUnderline")
                    if childUnderline then
                        if child == tab then
                            Funcs.UpdateUnderline(child, true)
                        else
                            Funcs.UpdateUnderline(child, false)
                        end
                    end
                end
            end
        end
    end)

    return tab
end

function Funcs.CreateSettingsInputbox(labelText, placeholderText, settingKey, layoutOrder)
    local frame = Instance.new("Frame")
    frame["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
    frame["BorderSizePixel"] = 0
    frame["LayoutOrder"] = layoutOrder or 2
    frame["Name"] = labelText:gsub(" ", "")
    frame["Size"] = UDim2.new(1, 0, 0, 38)
    frame["Parent"] = UI["SettingsFrame"]

    local corner = Instance.new("UICorner")
    corner["CornerRadius"] = UDim.new(0, 6)
    corner["Name"] = frame["Name"] .. "Corner"
    corner["Parent"] = frame

    local stroke = Instance.new("UIStroke")
    stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    stroke["Color"] = Color3.fromRGB(36, 36, 36)
    stroke["Name"] = frame["Name"] .. "Stroke"
    stroke["Parent"] = frame

    local layout = Instance.new("UIListLayout")
    layout["FillDirection"] = Enum.FillDirection.Horizontal
    layout["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
    layout["Name"] = frame["Name"] .. "Layout"
    layout["Padding"] = UDim.new(0, 6)
    layout["SortOrder"] = Enum.SortOrder.LayoutOrder
    layout["VerticalFlex"] = Enum.UIFlexAlignment.Fill
    layout["Parent"] = frame

    local padding = Instance.new("UIPadding")
    padding["Name"] = frame["Name"] .. "Padding"
    padding["PaddingBottom"] = UDim.new(0, 8)
    padding["PaddingLeft"] = UDim.new(0, 8)
    padding["PaddingRight"] = UDim.new(0, 8)
    padding["PaddingTop"] = UDim.new(0, 8)
    padding["Parent"] = frame

    local label = Instance.new("TextLabel")
    label["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    label["BackgroundTransparency"] = 1
    label["BorderSizePixel"] = 0
    label["FontFace"] = GothamMedium
    label["LayoutOrder"] = 1
    label["Name"] = frame["Name"] .. "Label"
    label["Size"] = UDim2.new(0.8, 0, 1, 0)
    label["Text"] = labelText
    label["TextColor3"] = Color3.fromRGB(255, 255, 255)
    label["TextScaled"] = true
    label["TextWrapped"] = true
    label["TextXAlignment"] = Enum.TextXAlignment.Left
    label["Parent"] = frame

    local input = Instance.new("TextBox")
    input["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    input["BackgroundTransparency"] = 1
    input["BorderSizePixel"] = 0
    input["FontFace"] = GothamMedium
    input["LayoutOrder"] = 2
    input["Name"] = frame["Name"] .. "Input"
    input["PlaceholderColor3"] = Color3.fromRGB(221, 221, 221)
    input["PlaceholderText"] = placeholderText
    input["Size"] = UDim2.new(0.2, 0, 1, 0)
    input["Text"] = ""
    input["TextColor3"] = Color3.fromRGB(255, 255, 255)
    input["TextScaled"] = true
    input["TextWrapped"] = true
    input["Parent"] = frame

    local inputCorner = Instance.new("UICorner")
    inputCorner["CornerRadius"] = UDim.new(0, 6)
    inputCorner["Name"] = frame["Name"] .. "InputCorner"
    inputCorner["Parent"] = input

    local inputStroke = Instance.new("UIStroke")
    inputStroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
    inputStroke["Color"] = Color3.fromRGB(36, 36, 36)
    inputStroke["Name"] = frame["Name"] .. "InputStroke"
    inputStroke["Parent"] = input

    local inputPadding = Instance.new("UIPadding")
    inputPadding["Name"] = frame["Name"] .. "InputPadding"
    inputPadding["PaddingBottom"] = UDim.new(0, 4)
    inputPadding["PaddingLeft"] = UDim.new(0, 4)
    inputPadding["PaddingRight"] = UDim.new(0, 4)
    inputPadding["PaddingTop"] = UDim.new(0, 4)
    inputPadding["Parent"] = input

    if settingKey then
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local color = Funcs.ParseColor(input["Text"])
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

Funcs.PreloadAssets()
HideExec()

if Shared.Lucid.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Lucid Executor",
        Text = "Lucid is already running!",
        Icon = Funcs.GetAsset("Lucid/Assets/lucid_logo.png"),
        Duration = 4
    })
    return
end

Shared.Lucid.IsLoaded = true

UI["ScreenGui"] = Instance.new("ScreenGui")
UI["ScreenGui"]["DisplayOrder"] = 2147483647
UI["ScreenGui"]["IgnoreGuiInset"] = true
UI["ScreenGui"]["Name"] = "Lucid"
UI["ScreenGui"]["ResetOnSpawn"] = false
UI["ScreenGui"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets
UI["ScreenGui"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
UI["ScreenGui"]["Parent"] = CoreGui

UI["Show"] = Instance.new("ImageButton")
UI["Show"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 22)
UI["Show"]["BackgroundTransparency"] = 0.08
UI["Show"]["BorderSizePixel"] = 0
UI["Show"]["Name"] = "Show"
UI["Show"]["Position"] = UDim2.new(0, 16, 0, 60)
UI["Show"]["Size"] = UDim2.new(0, 44, 0, 44)
UI["Show"]["Visible"] = true
UI["Show"]["ZIndex"] = 3
UI["Show"]["Parent"] = UI["ScreenGui"]

UI["ShowRatio"] = Instance.new("UIAspectRatioConstraint")
UI["ShowRatio"]["Name"] = "ShowRatio"
UI["ShowRatio"]["Parent"] = UI["Show"]

UI["ShowCorner"] = Instance.new("UICorner")
UI["ShowCorner"]["CornerRadius"] = UDim.new(1, 0)
UI["ShowCorner"]["Name"] = "ShowCorner"
UI["ShowCorner"]["Parent"] = UI["Show"]

UI["ShowIcon"] = Instance.new("ImageLabel")
UI["ShowIcon"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["ShowIcon"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ShowIcon"]["BackgroundTransparency"] = 1
UI["ShowIcon"]["BorderSizePixel"] = 0
UI["ShowIcon"]["Image"] = Funcs.GetAsset("Lucid/Assets/lucid_logo.png")
UI["ShowIcon"]["Name"] = "ShowIcon"
UI["ShowIcon"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["ShowIcon"]["Size"] = UDim2.new(0, 28, 0, 28)
UI["ShowIcon"]["Parent"] = UI["Show"]

UI["MainFrame"] = Instance.new("Frame")
UI["MainFrame"]["AutoLocalize"] = false
UI["MainFrame"]["BackgroundColor3"] = Color3.fromRGB(10, 10, 10)
UI["MainFrame"]["BackgroundTransparency"] = 0.35
UI["MainFrame"]["BorderSizePixel"] = 0
UI["MainFrame"]["Name"] = "MainFrame"
UI["MainFrame"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["MainFrame"]["Visible"] = false
UI["MainFrame"]["Parent"] = UI["ScreenGui"]

UI["MainFrameLayout"] = Instance.new("UIListLayout")
UI["MainFrameLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["MainFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["MainFrameLayout"]["Name"] = "MainFrameLayout"
UI["MainFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["MainFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["MainFrameLayout"]["Parent"] = UI["MainFrame"]

UI["Pages"] = Instance.new("Frame")
UI["Pages"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Pages"]["BackgroundTransparency"] = 1
UI["Pages"]["BorderSizePixel"] = 0
UI["Pages"]["LayoutOrder"] = 1
UI["Pages"]["Name"] = "Pages"
UI["Pages"]["Position"] = UDim2.new(0, 18, 0, 62)
UI["Pages"]["Size"] = UDim2.new(0, 576, 0, 116)
UI["Pages"]["Parent"] = UI["MainFrame"]

UI["PagesPadding"] = Instance.new("UIPadding")
UI["PagesPadding"]["Name"] = "PagesPadding"
UI["PagesPadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["PagesPadding"]["PaddingLeft"] = UDim.new(0, 8)
UI["PagesPadding"]["PaddingTop"] = UDim.new(0, 60)
UI["PagesPadding"]["Parent"] = UI["Pages"]

UI["HomeContent"] = Instance.new("CanvasGroup")
UI["HomeContent"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["HomeContent"]["BorderSizePixel"] = 0
UI["HomeContent"]["LayoutOrder"] = 1
UI["HomeContent"]["Name"] = "HomeContent"
UI["HomeContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["HomeContent"]["Visible"] = false
UI["HomeContent"]["Parent"] = UI["Pages"]

UI["HomeContentCorner"] = Instance.new("UICorner")
UI["HomeContentCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["HomeContentCorner"]["Name"] = "HomeContentCorner"
UI["HomeContentCorner"]["Parent"] = UI["HomeContent"]

UI["HomeContentStroke"] = Instance.new("UIStroke")
UI["HomeContentStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["HomeContentStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["HomeContentStroke"]["Name"] = "HomeContentStroke"
UI["HomeContentStroke"]["Parent"] = UI["HomeContent"]

UI["HomeContentLayout"] = Instance.new("UIListLayout")
UI["HomeContentLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["HomeContentLayout"]["Name"] = "HomeContentLayout"
UI["HomeContentLayout"]["Padding"] = UDim.new(0, 6)
UI["HomeContentLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["HomeContentLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["HomeContentLayout"]["Parent"] = UI["HomeContent"]

UI["HomeInfo"] = Instance.new("ScrollingFrame")
UI["HomeInfo"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["HomeInfo"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["HomeInfo"]["BackgroundTransparency"] = 1
UI["HomeInfo"]["BorderSizePixel"] = 0
UI["HomeInfo"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["HomeInfo"]["Name"] = "HomeInfo"
UI["HomeInfo"]["ScrollBarThickness"] = 0
UI["HomeInfo"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["HomeInfo"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["HomeInfo"]["Parent"] = UI["HomeContent"]

UI["HomeInfoPadding"] = Instance.new("UIPadding")
UI["HomeInfoPadding"]["Name"] = "HomeInfoPadding"
UI["HomeInfoPadding"]["PaddingBottom"] = UDim.new(0, 5)
UI["HomeInfoPadding"]["PaddingLeft"] = UDim.new(0, 5)
UI["HomeInfoPadding"]["PaddingRight"] = UDim.new(0, 5)
UI["HomeInfoPadding"]["PaddingTop"] = UDim.new(0, 5)
UI["HomeInfoPadding"]["Parent"] = UI["HomeInfo"]

UI["PlayerStats"] = Instance.new("Frame")
UI["PlayerStats"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["PlayerStats"]["BackgroundTransparency"] = 1
UI["PlayerStats"]["BorderSizePixel"] = 0
UI["PlayerStats"]["LayoutOrder"] = 1
UI["PlayerStats"]["Name"] = "PlayerStats"
UI["PlayerStats"]["Size"] = UDim2.new(1, 0, 0, 400)
UI["PlayerStats"]["Parent"] = UI["HomeInfo"]

UI["PlayerStatsLayout"] = Instance.new("UIListLayout")
UI["PlayerStatsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["PlayerStatsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerStatsLayout"]["Name"] = "PlayerStatsLayout"
UI["PlayerStatsLayout"]["Padding"] = UDim.new(0, 6)
UI["PlayerStatsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["PlayerStatsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerStatsLayout"]["Parent"] = UI["PlayerStats"]

UI["Avatar"] = Instance.new("Frame")
UI["Avatar"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Avatar"]["BackgroundTransparency"] = 1
UI["Avatar"]["BorderSizePixel"] = 0
UI["Avatar"]["LayoutOrder"] = 1
UI["Avatar"]["Name"] = "Avatar"
UI["Avatar"]["Size"] = UDim2.new(0, 0, 1, 0)
UI["Avatar"]["Parent"] = UI["PlayerStats"]

UI["PlayerHeadshot"] = Instance.new("ImageLabel")
UI["PlayerHeadshot"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["PlayerHeadshot"]["BorderSizePixel"] = 0
UI["PlayerHeadshot"]["Interactable"] = false
UI["PlayerHeadshot"]["Name"] = "PlayerHeadshot"
UI["PlayerHeadshot"]["ScaleType"] = Enum.ScaleType.Fit
UI["PlayerHeadshot"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["PlayerHeadshot"]["Parent"] = UI["Avatar"]

UI["PlayerHeadshotRatio"] = Instance.new("UIAspectRatioConstraint")
UI["PlayerHeadshotRatio"]["Name"] = "PlayerHeadshotRatio"
UI["PlayerHeadshotRatio"]["Parent"] = UI["PlayerHeadshot"]

UI["PlayerHeadshotCorner"] = Instance.new("UICorner")
UI["PlayerHeadshotCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["PlayerHeadshotCorner"]["Name"] = "PlayerHeadshotCorner"
UI["PlayerHeadshotCorner"]["Parent"] = UI["PlayerHeadshot"]

UI["PlayerHeadshotStroke"] = Instance.new("UIStroke")
UI["PlayerHeadshotStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["PlayerHeadshotStroke"]["Name"] = "PlayerHeadshotStroke"
UI["PlayerHeadshotStroke"]["Parent"] = UI["PlayerHeadshot"]

UI["PlayerInfo"] = Instance.new("Frame")
UI["PlayerInfo"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["PlayerInfo"]["BackgroundTransparency"] = 1
UI["PlayerInfo"]["BorderSizePixel"] = 0
UI["PlayerInfo"]["LayoutOrder"] = 2
UI["PlayerInfo"]["Name"] = "PlayerInfo"
UI["PlayerInfo"]["Size"] = UDim2.new(0.75, 0, 1, 0)
UI["PlayerInfo"]["Parent"] = UI["PlayerStats"]

UI["WelcomeLabel"] = Instance.new("TextLabel")
UI["WelcomeLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["WelcomeLabel"]["BackgroundTransparency"] = 1
UI["WelcomeLabel"]["BorderSizePixel"] = 0
UI["WelcomeLabel"]["FontFace"] = GothamMedium
UI["WelcomeLabel"]["Name"] = "WelcomeLabel"
UI["WelcomeLabel"]["Size"] = UDim2.new(0, 432, 0, 0)
UI["WelcomeLabel"]["Text"] = "Welcome to Lucid, DisplayName!"
UI["WelcomeLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["WelcomeLabel"]["TextScaled"] = true
UI["WelcomeLabel"]["TextSize"] = 20
UI["WelcomeLabel"]["TextWrapped"] = true
UI["WelcomeLabel"]["Parent"] = UI["PlayerInfo"]

UI["WelcomeLabelStroke"] = Instance.new("UIStroke")
UI["WelcomeLabelStroke"]["Color"] = Color3.fromRGB(0, 94, 255)
UI["WelcomeLabelStroke"]["Name"] = "WelcomeLabelStroke"
UI["WelcomeLabelStroke"]["Parent"] = UI["WelcomeLabel"]

UI["PlayerInfoLayout"] = Instance.new("UIListLayout")
UI["PlayerInfoLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"]["Name"] = "PlayerInfoLayout"
UI["PlayerInfoLayout"]["Padding"] = UDim.new(0, 6)
UI["PlayerInfoLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["PlayerInfoLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"]["Parent"] = UI["PlayerInfo"]

UI["InfoLabel"] = Instance.new("TextLabel")
UI["InfoLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["InfoLabel"]["BackgroundTransparency"] = 1
UI["InfoLabel"]["BorderSizePixel"] = 0
UI["InfoLabel"]["FontFace"] = GothamMedium
UI["InfoLabel"]["Name"] = "InfoLabel"
UI["InfoLabel"]["RichText"] = true
UI["InfoLabel"]["Size"] = UDim2.new(1, 0, 0.75, 0)
UI["InfoLabel"]["Text"] = [[Username: Unknown
Display Name: Unknown
User ID: 0

FPS: 0
Ping: 0 ms
Memory: 0 MB

Players: 0/0
Server Age: 0 mins
Job ID: Unknown

Place ID: 0
Game ID: Unknown]]
UI["InfoLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["InfoLabel"]["TextScaled"] = true
UI["InfoLabel"]["TextWrapped"] = true
UI["InfoLabel"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["InfoLabel"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["InfoLabel"]["Parent"] = UI["PlayerInfo"]

UI["InfoLabelStroke"] = Instance.new("UIStroke")
UI["InfoLabelStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["InfoLabelStroke"]["Name"] = "InfoLabelStroke"
UI["InfoLabelStroke"]["Parent"] = UI["InfoLabel"]

UI["InfoLabel2"] = Instance.new("TextLabel")
UI["InfoLabel2"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["InfoLabel2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["InfoLabel2"]["BackgroundTransparency"] = 1
UI["InfoLabel2"]["BorderSizePixel"] = 0
UI["InfoLabel2"]["LayoutOrder"] = 2
UI["InfoLabel2"]["Name"] = "InfoLabel2"
UI["InfoLabel2"]["RichText"] = true
UI["InfoLabel2"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["InfoLabel2"]["Text"] = [[<p align="center"><font size="22"><b>About Lucid</b></font></p>

<p align="left">
Lucid is a modern interface that replaces your executor's UI while keeping its original functionality. It provides a cleaner design, smoother animations, and a more consistent experience.
</p>

<p align="center"><font size="22"><b>Features</b></font></p>

<p align="left">
- Search scripts directly from <b>RScripts.net</b> or <b>ScriptBlox.com</b>, switchable from the Search tab.<br/>
- Save your favorite scripts for quick access in the <b>Scripts</b> tab.<br/>
- Customize Lucid's appearance with your own colors.<br/>
- Automatically save your settings and preferences.<br/>
- Works with multiple supported executors through one consistent UI.
</p>

<p align="center"><font size="22"><b>Script Sources</b></font></p>

<p align="left">
🟢 RScripts — Better moderation, generally safer to use.<br/>
⚠️ ScriptBlox — Less moderated, use with caution.<br/>
Tap the source button in the Search tab to switch between them.
</p>

<p align="center"><font size="22"><b>Credits</b></font></p>

<p align="left">
Created and maintained by <b>JustAGuest</b>.
</p>

<p align="center"><i>Thank you for using Lucid!</i></p>]]
UI["InfoLabel2"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["InfoLabel2"]["TextSize"] = 14
UI["InfoLabel2"]["TextWrapped"] = true
UI["InfoLabel2"]["Parent"] = UI["HomeInfo"]

UI["InfoLabel2Stroke"] = Instance.new("UIStroke")
UI["InfoLabel2Stroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["InfoLabel2Stroke"]["Name"] = "InfoLabel2Stroke"
UI["InfoLabel2Stroke"]["Parent"] = UI["InfoLabel2"]

UI["HomeInfoLayout"] = Instance.new("UIListLayout")
UI["HomeInfoLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["HomeInfoLayout"]["Name"] = "HomeInfoLayout"
UI["HomeInfoLayout"]["Padding"] = UDim.new(0, 6)
UI["HomeInfoLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["HomeInfoLayout"]["Parent"] = UI["HomeInfo"]

UI["ExeContent"] = Instance.new("CanvasGroup")
UI["ExeContent"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["ExeContent"]["BorderSizePixel"] = 0
UI["ExeContent"]["LayoutOrder"] = 1
UI["ExeContent"]["Name"] = "ExeContent"
UI["ExeContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ExeContent"]["Visible"] = false
UI["ExeContent"]["Parent"] = UI["Pages"]

UI["ExeContentCorner"] = Instance.new("UICorner")
UI["ExeContentCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ExeContentCorner"]["Name"] = "ExeContentCorner"
UI["ExeContentCorner"]["Parent"] = UI["ExeContent"]

UI["ExeContentStroke"] = Instance.new("UIStroke")
UI["ExeContentStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ExeContentStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["ExeContentStroke"]["Name"] = "ExeContentStroke"
UI["ExeContentStroke"]["Parent"] = UI["ExeContent"]

UI["ExeContentLayout"] = Instance.new("UIListLayout")
UI["ExeContentLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentLayout"]["Name"] = "ExeContentLayout"
UI["ExeContentLayout"]["Padding"] = UDim.new(0, 6)
UI["ExeContentLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ExeContentLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ExeContentLayout"]["Parent"] = UI["ExeContent"]

UI["ExeContentPadding"] = Instance.new("UIPadding")
UI["ExeContentPadding"]["Name"] = "ExeContentPadding"
UI["ExeContentPadding"]["PaddingBottom"] = UDim.new(0, 5)
UI["ExeContentPadding"]["PaddingLeft"] = UDim.new(0, 5)
UI["ExeContentPadding"]["PaddingRight"] = UDim.new(0, 5)
UI["ExeContentPadding"]["PaddingTop"] = UDim.new(0, 5)
UI["ExeContentPadding"]["Parent"] = UI["ExeContent"]

UI["InputFrame"] = Instance.new("ScrollingFrame")
UI["InputFrame"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["InputFrame"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["InputFrame"]["BorderSizePixel"] = 0
UI["InputFrame"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["InputFrame"]["Name"] = "InputFrame"
UI["InputFrame"]["Position"] = UDim2.new(0, -14, 0, -76)
UI["InputFrame"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["InputFrame"]["ScrollBarThickness"] = 6
UI["InputFrame"]["Size"] = UDim2.new(0, 250, 0, 266)
UI["InputFrame"]["Parent"] = UI["ExeContent"]

UI["InputFramePadding"] = Instance.new("UIPadding")
UI["InputFramePadding"]["Name"] = "InputFramePadding"
UI["InputFramePadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["InputFramePadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["InputFramePadding"]["PaddingRight"] = UDim.new(0, 6)
UI["InputFramePadding"]["PaddingTop"] = UDim.new(0, 6)
UI["InputFramePadding"]["Parent"] = UI["InputFrame"]

UI["InputFrameStroke"] = Instance.new("UIStroke")
UI["InputFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["InputFrameStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["InputFrameStroke"]["Name"] = "InputFrameStroke"
UI["InputFrameStroke"]["Parent"] = UI["InputFrame"]

UI["InputFrameCorner"] = Instance.new("UICorner")
UI["InputFrameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["InputFrameCorner"]["Name"] = "InputFrameCorner"
UI["InputFrameCorner"]["Parent"] = UI["InputFrame"]

UI["Highlight"] = Instance.new("TextLabel")
UI["Highlight"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Highlight"]["BackgroundTransparency"] = 1
UI["Highlight"]["FontFace"] = Inconsolata
UI["Highlight"]["Name"] = "Highlight"
UI["Highlight"]["RichText"] = true
UI["Highlight"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["Highlight"]["Text"] = ""
UI["Highlight"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Highlight"]["TextSize"] = 18
UI["Highlight"]["TextWrapped"] = true
UI["Highlight"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Highlight"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["Highlight"]["Parent"] = UI["InputFrame"]

UI["InputBox"] = Instance.new("TextBox")
UI["InputBox"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["InputBox"]["BackgroundTransparency"] = 1
UI["InputBox"]["BorderSizePixel"] = 0
UI["InputBox"]["ClearTextOnFocus"] = false
UI["InputBox"]["FontFace"] = Inconsolata
UI["InputBox"]["MultiLine"] = true
UI["InputBox"]["Name"] = "InputBox"
UI["InputBox"]["PlaceholderColor3"] = Color3.fromRGB(255, 255, 255)
UI["InputBox"]["PlaceholderText"] = "Enter code here..."
UI["InputBox"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["InputBox"]["Text"] = ""
UI["InputBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["InputBox"]["TextSize"] = 18
UI["InputBox"]["TextTransparency"] = 1
UI["InputBox"]["TextWrapped"] = true
UI["InputBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["InputBox"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["InputBox"]["Parent"] = UI["InputFrame"]

UI["InputBoxSizeCons"] = Instance.new("UISizeConstraint")
UI["InputBoxSizeCons"]["MaxSize"] = Vector2.new(2147483647, 2147483647)
UI["InputBoxSizeCons"]["MinSize"] = Vector2.new(0, 200)
UI["InputBoxSizeCons"]["Name"] = "InputBoxSizeCons"
UI["InputBoxSizeCons"]["Parent"] = UI["InputBox"]

UI["Buttons"] = Instance.new("Frame")
UI["Buttons"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Buttons"]["BackgroundTransparency"] = 1
UI["Buttons"]["BorderSizePixel"] = 0
UI["Buttons"]["LayoutOrder"] = 3
UI["Buttons"]["Name"] = "Buttons"
UI["Buttons"]["Position"] = UDim2.new(0, 28, 0, 20)
UI["Buttons"]["Size"] = UDim2.new(0, 116, 0, 38)
UI["Buttons"]["Parent"] = UI["ExeContent"]

UI["ButtonsLayout"] = Instance.new("UIListLayout")
UI["ButtonsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["ButtonsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ButtonsLayout"]["Name"] = "ButtonsLayout"
UI["ButtonsLayout"]["Padding"] = UDim.new(0, 6)
UI["ButtonsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ButtonsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ButtonsLayout"]["Parent"] = UI["Buttons"]

UI["ButtonsSizeCons"] = Instance.new("UISizeConstraint")
UI["ButtonsSizeCons"]["MaxSize"] = Vector2.new(2147483647, 38)
UI["ButtonsSizeCons"]["Name"] = "ButtonsSizeCons"
UI["ButtonsSizeCons"]["Parent"] = UI["Buttons"]

UI["ExeBtn"] = Instance.new("TextButton")
UI["ExeBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["ExeBtn"]["BorderSizePixel"] = 0
UI["ExeBtn"]["FontFace"] = BuilderSans
UI["ExeBtn"]["LayoutOrder"] = 1
UI["ExeBtn"]["Name"] = "ExeBtn"
UI["ExeBtn"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["ExeBtn"]["Text"] = "Execute"
UI["ExeBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ExeBtn"]["TextScaled"] = true
UI["ExeBtn"]["TextWrapped"] = true
UI["ExeBtn"]["Parent"] = UI["Buttons"]

UI["ExeBtnCorner"] = Instance.new("UICorner")
UI["ExeBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ExeBtnCorner"]["Name"] = "ExeBtnCorner"
UI["ExeBtnCorner"]["Parent"] = UI["ExeBtn"]

UI["ExeBtnStroke"] = Instance.new("UIStroke")
UI["ExeBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ExeBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["ExeBtnStroke"]["Name"] = "ExeBtnStroke"
UI["ExeBtnStroke"]["Parent"] = UI["ExeBtn"]

UI["ExeBtnPadding"] = Instance.new("UIPadding")
UI["ExeBtnPadding"]["Name"] = "ExeBtnPadding"
UI["ExeBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ExeBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ExeBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ExeBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ExeBtnPadding"]["Parent"] = UI["ExeBtn"]

UI["ClrBtn"] = Instance.new("TextButton")
UI["ClrBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["ClrBtn"]["BorderSizePixel"] = 0
UI["ClrBtn"]["FontFace"] = BuilderSans
UI["ClrBtn"]["LayoutOrder"] = 2
UI["ClrBtn"]["Name"] = "ClrBtn"
UI["ClrBtn"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["ClrBtn"]["Text"] = "Clear"
UI["ClrBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ClrBtn"]["TextScaled"] = true
UI["ClrBtn"]["TextWrapped"] = true
UI["ClrBtn"]["Parent"] = UI["Buttons"]

UI["ClrBtnPadding"] = Instance.new("UIPadding")
UI["ClrBtnPadding"]["Name"] = "ClrBtnPadding"
UI["ClrBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ClrBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ClrBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ClrBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ClrBtnPadding"]["Parent"] = UI["ClrBtn"]

UI["ClrBtnStroke"] = Instance.new("UIStroke")
UI["ClrBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ClrBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["ClrBtnStroke"]["Name"] = "ClrBtnStroke"
UI["ClrBtnStroke"]["Parent"] = UI["ClrBtn"]

UI["ClrBtnCorner"] = Instance.new("UICorner")
UI["ClrBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ClrBtnCorner"]["Name"] = "ClrBtnCorner"
UI["ClrBtnCorner"]["Parent"] = UI["ClrBtn"]

UI["CopyBtn"] = Instance.new("TextButton")
UI["CopyBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["CopyBtn"]["BorderSizePixel"] = 0
UI["CopyBtn"]["FontFace"] = BuilderSans
UI["CopyBtn"]["LayoutOrder"] = 3
UI["CopyBtn"]["Name"] = "CopyBtn"
UI["CopyBtn"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["CopyBtn"]["Text"] = "Copy"
UI["CopyBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["CopyBtn"]["TextScaled"] = true
UI["CopyBtn"]["TextWrapped"] = true
UI["CopyBtn"]["Parent"] = UI["Buttons"]

UI["CopyBtnPadding"] = Instance.new("UIPadding")
UI["CopyBtnPadding"]["Name"] = "CopyBtnPadding"
UI["CopyBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["CopyBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["CopyBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["CopyBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["CopyBtnPadding"]["Parent"] = UI["CopyBtn"]

UI["CopyBtnStroke"] = Instance.new("UIStroke")
UI["CopyBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["CopyBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["CopyBtnStroke"]["Name"] = "CopyBtnStroke"
UI["CopyBtnStroke"]["Parent"] = UI["CopyBtn"]

UI["CopyBtnCorner"] = Instance.new("UICorner")
UI["CopyBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["CopyBtnCorner"]["Name"] = "CopyBtnCorner"
UI["CopyBtnCorner"]["Parent"] = UI["CopyBtn"]

UI["SearchContent"] = Instance.new("CanvasGroup")
UI["SearchContent"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["SearchContent"]["BorderSizePixel"] = 0
UI["SearchContent"]["LayoutOrder"] = 2
UI["SearchContent"]["Name"] = "SearchContent"
UI["SearchContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["SearchContent"]["Visible"] = false
UI["SearchContent"]["Parent"] = UI["Pages"]

UI["SearchContentPadding"] = Instance.new("UIPadding")
UI["SearchContentPadding"]["Name"] = "SearchContentPadding"
UI["SearchContentPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["SearchContentPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["SearchContentPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["SearchContentPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["SearchContentPadding"]["Parent"] = UI["SearchContent"]

UI["SearchContentLayout"] = Instance.new("UIListLayout")
UI["SearchContentLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SearchContentLayout"]["Name"] = "SearchContentLayout"
UI["SearchContentLayout"]["Padding"] = UDim.new(0, 6)
UI["SearchContentLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SearchContentLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SearchContentLayout"]["Parent"] = UI["SearchContent"]

UI["SearchContentCorner"] = Instance.new("UICorner")
UI["SearchContentCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SearchContentCorner"]["Name"] = "SearchContentCorner"
UI["SearchContentCorner"]["Parent"] = UI["SearchContent"]

UI["SearchContentStroke"] = Instance.new("UIStroke")
UI["SearchContentStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SearchContentStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["SearchContentStroke"]["Name"] = "SearchContentStroke"
UI["SearchContentStroke"]["Parent"] = UI["SearchContent"]

UI["SearchFrame"] = Instance.new("Frame")
UI["SearchFrame"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["SearchFrame"]["BorderSizePixel"] = 0
UI["SearchFrame"]["LayoutOrder"] = 1
UI["SearchFrame"]["Name"] = "SearchFrame"
UI["SearchFrame"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["SearchFrame"]["Parent"] = UI["SearchContent"]

UI["SearchFramePadding"] = Instance.new("UIPadding")
UI["SearchFramePadding"]["Name"] = "SearchFramePadding"
UI["SearchFramePadding"]["Parent"] = UI["SearchFrame"]

UI["SearchFrameLayout"] = Instance.new("UIListLayout")
UI["SearchFrameLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["SearchFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SearchFrameLayout"]["Name"] = "SearchFrameLayout"
UI["SearchFrameLayout"]["Padding"] = UDim.new(0, 2)
UI["SearchFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SearchFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SearchFrameLayout"]["Parent"] = UI["SearchFrame"]

UI["SearchFrameSizeCons"] = Instance.new("UISizeConstraint")
UI["SearchFrameSizeCons"]["MaxSize"] = Vector2.new(2147483647, 30)
UI["SearchFrameSizeCons"]["MinSize"] = Vector2.new(0, 30)
UI["SearchFrameSizeCons"]["Name"] = "SearchFrameSizeCons"
UI["SearchFrameSizeCons"]["Parent"] = UI["SearchFrame"]

UI["SearchFrameCorner"] = Instance.new("UICorner")
UI["SearchFrameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SearchFrameCorner"]["Name"] = "SearchFrameCorner"
UI["SearchFrameCorner"]["Parent"] = UI["SearchFrame"]

UI["SearchFrameStroke"] = Instance.new("UIStroke")
UI["SearchFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SearchFrameStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["SearchFrameStroke"]["Name"] = "SearchFrameStroke"
UI["SearchFrameStroke"]["Parent"] = UI["SearchFrame"]

UI["SourceBtn"] = Instance.new("TextButton")
UI["SourceBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["SourceBtn"]["BorderSizePixel"] = 0
UI["SourceBtn"]["FontFace"] = BuilderSans
UI["SourceBtn"]["LayoutOrder"] = 1
UI["SourceBtn"]["Name"] = "SourceBtn"
UI["SourceBtn"]["Size"] = UDim2.new(0.24, 0, 1, 0)
UI["SourceBtn"]["Text"] = "🟢 Source: RScripts"
UI["SourceBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SourceBtn"]["TextScaled"] = true
UI["SourceBtn"]["TextWrapped"] = true
UI["SourceBtn"]["Parent"] = UI["SearchFrame"]

UI["SourceBtnCorner"] = Instance.new("UICorner")
UI["SourceBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SourceBtnCorner"]["Name"] = "SourceBtnCorner"
UI["SourceBtnCorner"]["Parent"] = UI["SourceBtn"]

UI["SourceBtnStroke"] = Instance.new("UIStroke")
UI["SourceBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SourceBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["SourceBtnStroke"]["Name"] = "SourceBtnStroke"
UI["SourceBtnStroke"]["Parent"] = UI["SourceBtn"]

UI["SourceBtnPadding"] = Instance.new("UIPadding")
UI["SourceBtnPadding"]["Name"] = "SourceBtnPadding"
UI["SourceBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["SourceBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["SourceBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["SourceBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["SourceBtnPadding"]["Parent"] = UI["SourceBtn"]

UI["SearchBox"] = Instance.new("TextBox")
UI["SearchBox"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox"]["BackgroundTransparency"] = 1
UI["SearchBox"]["BorderSizePixel"] = 0
UI["SearchBox"]["FontFace"] = GothamMedium
UI["SearchBox"]["LayoutOrder"] = 2
UI["SearchBox"]["Name"] = "SearchBox"
UI["SearchBox"]["PlaceholderColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox"]["PlaceholderText"] = "Search for scripts..."
UI["SearchBox"]["Size"] = UDim2.new(0.52, 0, 1, 0)
UI["SearchBox"]["Text"] = ""
UI["SearchBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox"]["TextScaled"] = true
UI["SearchBox"]["TextSize"] = 12
UI["SearchBox"]["TextWrapped"] = true
UI["SearchBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["SearchBox"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["SearchBox"]["Parent"] = UI["SearchFrame"]

UI["SearchBoxPadding"] = Instance.new("UIPadding")
UI["SearchBoxPadding"]["Name"] = "SearchBoxPadding"
UI["SearchBoxPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["SearchBoxPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["SearchBoxPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["SearchBoxPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["SearchBoxPadding"]["Parent"] = UI["SearchBox"]

UI["FilterBtn"] = Instance.new("TextButton")
UI["FilterBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["FilterBtn"]["BorderSizePixel"] = 0
UI["FilterBtn"]["FontFace"] = BuilderSans
UI["FilterBtn"]["LayoutOrder"] = 3
UI["FilterBtn"]["Name"] = "FilterBtn"
UI["FilterBtn"]["Size"] = UDim2.new(0.24, 0, 1, 0)
UI["FilterBtn"]["Text"] = "Filter: All"
UI["FilterBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["FilterBtn"]["TextScaled"] = true
UI["FilterBtn"]["TextWrapped"] = true
UI["FilterBtn"]["Parent"] = UI["SearchFrame"]

UI["FilterBtnCorner"] = Instance.new("UICorner")
UI["FilterBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["FilterBtnCorner"]["Name"] = "FilterBtnCorner"
UI["FilterBtnCorner"]["Parent"] = UI["FilterBtn"]

UI["FilterBtnStroke"] = Instance.new("UIStroke")
UI["FilterBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["FilterBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["FilterBtnStroke"]["Name"] = "FilterBtnStroke"
UI["FilterBtnStroke"]["Parent"] = UI["FilterBtn"]

UI["FilterBtnPadding"] = Instance.new("UIPadding")
UI["FilterBtnPadding"]["Name"] = "FilterBtnPadding"
UI["FilterBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["FilterBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["FilterBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["FilterBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["FilterBtnPadding"]["Parent"] = UI["FilterBtn"]

UI["SearchResults"] = Instance.new("ScrollingFrame")
UI["SearchResults"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["SearchResults"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["SearchResults"]["BackgroundTransparency"] = 1
UI["SearchResults"]["BorderSizePixel"] = 0
UI["SearchResults"]["LayoutOrder"] = 2
UI["SearchResults"]["Name"] = "SearchResults"
UI["SearchResults"]["ScrollBarThickness"] = 0
UI["SearchResults"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["SearchResults"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["SearchResults"]["Parent"] = UI["SearchContent"]

UI["SearchResultsPadding"] = Instance.new("UIPadding")
UI["SearchResultsPadding"]["Name"] = "SearchResultsPadding"
UI["SearchResultsPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["SearchResultsPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["SearchResultsPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["SearchResultsPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["SearchResultsPadding"]["Parent"] = UI["SearchResults"]

UI["SearchResultsLayout"] = Instance.new("UIListLayout")
UI["SearchResultsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SearchResultsLayout"]["Name"] = "SearchResultsLayout"
UI["SearchResultsLayout"]["Padding"] = UDim.new(0, 8)
UI["SearchResultsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SearchResultsLayout"]["Parent"] = UI["SearchResults"]

UI["NoResultsLabel"] = Instance.new("TextLabel")
UI["NoResultsLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["NoResultsLabel"]["BackgroundTransparency"] = 1
UI["NoResultsLabel"]["BorderSizePixel"] = 0
UI["NoResultsLabel"]["FontFace"] = GothamMedium
UI["NoResultsLabel"]["Name"] = "NoResultsLabel"
UI["NoResultsLabel"]["Size"] = UDim2.new(1, 0, 0, 30)
UI["NoResultsLabel"]["Text"] = "No scripts found matching your query."
UI["NoResultsLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["NoResultsLabel"]["TextScaled"] = true
UI["NoResultsLabel"]["TextWrapped"] = true
UI["NoResultsLabel"]["Visible"] = false
UI["NoResultsLabel"]["Parent"] = UI["SearchResults"]

UI["NoResultsLabelStroke"] = Instance.new("UIStroke")
UI["NoResultsLabelStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["NoResultsLabelStroke"]["Name"] = "NoResultsLabelStroke"
UI["NoResultsLabelStroke"]["Parent"] = UI["NoResultsLabel"]

UI["SearchResultTemplate"] = Instance.new("CanvasGroup")
UI["SearchResultTemplate"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["SearchResultTemplate"]["BorderSizePixel"] = 0
UI["SearchResultTemplate"]["Name"] = "SearchResultTemplate"
UI["SearchResultTemplate"]["Size"] = UDim2.new(0, 358, 0, 132)
UI["SearchResultTemplate"]["Visible"] = false
UI["SearchResultTemplate"]["Parent"] = UI["SearchResults"]

UI["SearchResultTemplateCorner"] = Instance.new("UICorner")
UI["SearchResultTemplateCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SearchResultTemplateCorner"]["Name"] = "SearchResultTemplateCorner"
UI["SearchResultTemplateCorner"]["Parent"] = UI["SearchResultTemplate"]

UI["SearchResultTemplateStroke"] = Instance.new("UIStroke")
UI["SearchResultTemplateStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SearchResultTemplateStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["SearchResultTemplateStroke"]["Name"] = "SearchResultTemplateStroke"
UI["SearchResultTemplateStroke"]["Parent"] = UI["SearchResultTemplate"]

UI["ScriptImage"] = Instance.new("ImageLabel")
UI["ScriptImage"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptImage"]["BackgroundTransparency"] = 1
UI["ScriptImage"]["BorderSizePixel"] = 0
UI["ScriptImage"]["LayoutOrder"] = 1
UI["ScriptImage"]["Name"] = "ScriptImage"
UI["ScriptImage"]["ScaleType"] = Enum.ScaleType.Crop
UI["ScriptImage"]["Size"] = UDim2.new(1, 0, 0.7, -2)
UI["ScriptImage"]["Parent"] = UI["SearchResultTemplate"]

UI["Container"] = Instance.new("Frame")
UI["Container"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Container"]["BackgroundTransparency"] = 1
UI["Container"]["BorderSizePixel"] = 0
UI["Container"]["LayoutOrder"] = 2
UI["Container"]["Name"] = "Container"
UI["Container"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["Container"]["Parent"] = UI["SearchResultTemplate"]

UI["ScriptName"] = Instance.new("TextLabel")
UI["ScriptName"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["ScriptName"]["BackgroundTransparency"] = 1
UI["ScriptName"]["BorderSizePixel"] = 0
UI["ScriptName"]["FontFace"] = GothamMedium
UI["ScriptName"]["Name"] = "ScriptName"
UI["ScriptName"]["Position"] = UDim2.new(0, 4, 0, 0)
UI["ScriptName"]["Size"] = UDim2.new(0, 350, 0, 30)
UI["ScriptName"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptName"]["TextScaled"] = true
UI["ScriptName"]["TextWrapped"] = true
UI["ScriptName"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["ScriptName"]["Parent"] = UI["Container"]

UI["ScriptNameStroke"] = Instance.new("UIStroke")
UI["ScriptNameStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["ScriptNameStroke"]["Name"] = "ScriptNameStroke"
UI["ScriptNameStroke"]["Parent"] = UI["ScriptName"]

UI["ScriptNameCorner"] = Instance.new("UICorner")
UI["ScriptNameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ScriptNameCorner"]["Name"] = "ScriptNameCorner"
UI["ScriptNameCorner"]["Parent"] = UI["ScriptName"]

UI["ScriptActions"] = Instance.new("Frame")
UI["ScriptActions"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptActions"]["BackgroundTransparency"] = 1
UI["ScriptActions"]["BorderSizePixel"] = 0
UI["ScriptActions"]["Name"] = "ScriptActions"
UI["ScriptActions"]["Position"] = UDim2.new(0, 0, 0, 92)
UI["ScriptActions"]["Size"] = UDim2.new(1, 0, 0.3, 0)
UI["ScriptActions"]["Parent"] = UI["Container"]

UI["ScriptActionsPadding"] = Instance.new("UIPadding")
UI["ScriptActionsPadding"]["Name"] = "ScriptActionsPadding"
UI["ScriptActionsPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["ScriptActionsPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["ScriptActionsPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["ScriptActionsPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ScriptActionsPadding"]["Parent"] = UI["ScriptActions"]

UI["ScriptActionsLayout"] = Instance.new("UIListLayout")
UI["ScriptActionsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["ScriptActionsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScriptActionsLayout"]["Name"] = "ScriptActionsLayout"
UI["ScriptActionsLayout"]["Padding"] = UDim.new(0, 6)
UI["ScriptActionsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ScriptActionsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScriptActionsLayout"]["Parent"] = UI["ScriptActions"]

UI["RunScript"] = Instance.new("TextButton")
UI["RunScript"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["RunScript"]["BorderSizePixel"] = 0
UI["RunScript"]["FontFace"] = GothamMedium
UI["RunScript"]["LayoutOrder"] = 1
UI["RunScript"]["Name"] = "RunScript"
UI["RunScript"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["RunScript"]["Text"] = "Run"
UI["RunScript"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["RunScript"]["TextScaled"] = true
UI["RunScript"]["TextWrapped"] = true
UI["RunScript"]["Parent"] = UI["ScriptActions"]

UI["RunScriptStroke"] = Instance.new("UIStroke")
UI["RunScriptStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["RunScriptStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["RunScriptStroke"]["Name"] = "RunScriptStroke"
UI["RunScriptStroke"]["Parent"] = UI["RunScript"]

UI["RunScriptCorner"] = Instance.new("UICorner")
UI["RunScriptCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["RunScriptCorner"]["Name"] = "RunScriptCorner"
UI["RunScriptCorner"]["Parent"] = UI["RunScript"]

UI["RunScriptPadding"] = Instance.new("UIPadding")
UI["RunScriptPadding"]["Name"] = "RunScriptPadding"
UI["RunScriptPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["RunScriptPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["RunScriptPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["RunScriptPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["RunScriptPadding"]["Parent"] = UI["RunScript"]

UI["CopyScriptBtn"] = Instance.new("TextButton")
UI["CopyScriptBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["CopyScriptBtn"]["BorderSizePixel"] = 0
UI["CopyScriptBtn"]["FontFace"] = GothamMedium
UI["CopyScriptBtn"]["LayoutOrder"] = 2
UI["CopyScriptBtn"]["Name"] = "CopyScriptBtn"
UI["CopyScriptBtn"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["CopyScriptBtn"]["Text"] = "Copy"
UI["CopyScriptBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["CopyScriptBtn"]["TextScaled"] = true
UI["CopyScriptBtn"]["TextWrapped"] = true
UI["CopyScriptBtn"]["Parent"] = UI["ScriptActions"]

UI["CopyScriptBtnCorner"] = Instance.new("UICorner")
UI["CopyScriptBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["CopyScriptBtnCorner"]["Name"] = "CopyScriptBtnCorner"
UI["CopyScriptBtnCorner"]["Parent"] = UI["CopyScriptBtn"]

UI["CopyScriptBtnStroke"] = Instance.new("UIStroke")
UI["CopyScriptBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["CopyScriptBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["CopyScriptBtnStroke"]["Name"] = "CopyScriptBtnStroke"
UI["CopyScriptBtnStroke"]["Parent"] = UI["CopyScriptBtn"]

UI["CopyScriptBtnPadding"] = Instance.new("UIPadding")
UI["CopyScriptBtnPadding"]["Name"] = "CopyScriptBtnPadding"
UI["CopyScriptBtnPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["CopyScriptBtnPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["CopyScriptBtnPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["CopyScriptBtnPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["CopyScriptBtnPadding"]["Parent"] = UI["CopyScriptBtn"]

UI["SaveScriptBtn"] = Instance.new("TextButton")
UI["SaveScriptBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["SaveScriptBtn"]["BorderSizePixel"] = 0
UI["SaveScriptBtn"]["FontFace"] = GothamMedium
UI["SaveScriptBtn"]["LayoutOrder"] = 3
UI["SaveScriptBtn"]["Name"] = "SaveScriptBtn"
UI["SaveScriptBtn"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["SaveScriptBtn"]["Text"] = "Save"
UI["SaveScriptBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SaveScriptBtn"]["TextScaled"] = true
UI["SaveScriptBtn"]["TextWrapped"] = true
UI["SaveScriptBtn"]["Parent"] = UI["ScriptActions"]

UI["SaveScriptBtnCorner"] = Instance.new("UICorner")
UI["SaveScriptBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SaveScriptBtnCorner"]["Name"] = "SaveScriptBtnCorner"
UI["SaveScriptBtnCorner"]["Parent"] = UI["SaveScriptBtn"]

UI["SaveScriptBtnPadding"] = Instance.new("UIPadding")
UI["SaveScriptBtnPadding"]["Name"] = "SaveScriptBtnPadding"
UI["SaveScriptBtnPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["SaveScriptBtnPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["SaveScriptBtnPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["SaveScriptBtnPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["SaveScriptBtnPadding"]["Parent"] = UI["SaveScriptBtn"]

UI["SaveScriptBtnStroke"] = Instance.new("UIStroke")
UI["SaveScriptBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SaveScriptBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["SaveScriptBtnStroke"]["Name"] = "SaveScriptBtnStroke"
UI["SaveScriptBtnStroke"]["Parent"] = UI["SaveScriptBtn"]

UI["PageButtons"] = Instance.new("Frame")
UI["PageButtons"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["PageButtons"]["BackgroundTransparency"] = 1
UI["PageButtons"]["BorderSizePixel"] = 0
UI["PageButtons"]["LayoutOrder"] = 3
UI["PageButtons"]["Name"] = "PageButtons"
UI["PageButtons"]["Position"] = UDim2.new(0, 28, 0, 20)
UI["PageButtons"]["Size"] = UDim2.new(0, 116, 0, 38)
UI["PageButtons"]["Parent"] = UI["SearchContent"]

UI["Filler"] = Instance.new("Frame")
UI["Filler"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Filler"]["BackgroundTransparency"] = 1
UI["Filler"]["BorderSizePixel"] = 0
UI["Filler"]["LayoutOrder"] = 2
UI["Filler"]["Name"] = "Filler"
UI["Filler"]["Size"] = UDim2.new(0.5, 0, 1, 0)
UI["Filler"]["Parent"] = UI["PageButtons"]

UI["PageButtonsLayout"] = Instance.new("UIListLayout")
UI["PageButtonsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["PageButtonsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["PageButtonsLayout"]["Name"] = "PageButtonsLayout"
UI["PageButtonsLayout"]["Padding"] = UDim.new(0, 6)
UI["PageButtonsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["PageButtonsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["PageButtonsLayout"]["Parent"] = UI["PageButtons"]

UI["PageButtonsSizeCons"] = Instance.new("UISizeConstraint")
UI["PageButtonsSizeCons"]["MaxSize"] = Vector2.new(2147483647, 38)
UI["PageButtonsSizeCons"]["Name"] = "PageButtonsSizeCons"
UI["PageButtonsSizeCons"]["Parent"] = UI["PageButtons"]

UI["PrevBtn"] = Instance.new("TextButton")
UI["PrevBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["PrevBtn"]["BorderSizePixel"] = 0
UI["PrevBtn"]["FontFace"] = BuilderSans
UI["PrevBtn"]["LayoutOrder"] = 1
UI["PrevBtn"]["Name"] = "PrevBtn"
UI["PrevBtn"]["Size"] = UDim2.new(0.25, 0, 1, 0)
UI["PrevBtn"]["Text"] = "Previous"
UI["PrevBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["PrevBtn"]["TextScaled"] = true
UI["PrevBtn"]["TextWrapped"] = true
UI["PrevBtn"]["Parent"] = UI["PageButtons"]

UI["PrevBtnCorner"] = Instance.new("UICorner")
UI["PrevBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["PrevBtnCorner"]["Name"] = "PrevBtnCorner"
UI["PrevBtnCorner"]["Parent"] = UI["PrevBtn"]

UI["PrevBtnStroke"] = Instance.new("UIStroke")
UI["PrevBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["PrevBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["PrevBtnStroke"]["Name"] = "PrevBtnStroke"
UI["PrevBtnStroke"]["Parent"] = UI["PrevBtn"]

UI["PrevBtnPadding"] = Instance.new("UIPadding")
UI["PrevBtnPadding"]["Name"] = "PrevBtnPadding"
UI["PrevBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["PrevBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["PrevBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["PrevBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["PrevBtnPadding"]["Parent"] = UI["PrevBtn"]

UI["NextBtn"] = Instance.new("TextButton")
UI["NextBtn"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["NextBtn"]["BorderSizePixel"] = 0
UI["NextBtn"]["FontFace"] = BuilderSans
UI["NextBtn"]["LayoutOrder"] = 3
UI["NextBtn"]["Name"] = "NextBtn"
UI["NextBtn"]["Size"] = UDim2.new(0.25, 0, 1, 0)
UI["NextBtn"]["Text"] = "Next"
UI["NextBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["NextBtn"]["TextScaled"] = true
UI["NextBtn"]["TextWrapped"] = true
UI["NextBtn"]["Parent"] = UI["PageButtons"]

UI["NextBtnCorner"] = Instance.new("UICorner")
UI["NextBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["NextBtnCorner"]["Name"] = "NextBtnCorner"
UI["NextBtnCorner"]["Parent"] = UI["NextBtn"]

UI["NextBtnStroke"] = Instance.new("UIStroke")
UI["NextBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["NextBtnStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["NextBtnStroke"]["Name"] = "NextBtnStroke"
UI["NextBtnStroke"]["Parent"] = UI["NextBtn"]

UI["NextBtnPadding"] = Instance.new("UIPadding")
UI["NextBtnPadding"]["Name"] = "NextBtnPadding"
UI["NextBtnPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["NextBtnPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["NextBtnPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["NextBtnPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["NextBtnPadding"]["Parent"] = UI["NextBtn"]

UI["ScriptsContent"] = Instance.new("CanvasGroup")
UI["ScriptsContent"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["ScriptsContent"]["BorderSizePixel"] = 0
UI["ScriptsContent"]["LayoutOrder"] = 3
UI["ScriptsContent"]["Name"] = "ScriptsContent"
UI["ScriptsContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["ScriptsContent"]["Visible"] = false
UI["ScriptsContent"]["Parent"] = UI["Pages"]

UI["ScriptsContentCorner"] = Instance.new("UICorner")
UI["ScriptsContentCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ScriptsContentCorner"]["Name"] = "ScriptsContentCorner"
UI["ScriptsContentCorner"]["Parent"] = UI["ScriptsContent"]

UI["ScriptsContentStroke"] = Instance.new("UIStroke")
UI["ScriptsContentStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ScriptsContentStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["ScriptsContentStroke"]["Name"] = "ScriptsContentStroke"
UI["ScriptsContentStroke"]["Parent"] = UI["ScriptsContent"]

UI["ScriptsContentLayout"] = Instance.new("UIListLayout")
UI["ScriptsContentLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScriptsContentLayout"]["Name"] = "ScriptsContentLayout"
UI["ScriptsContentLayout"]["Padding"] = UDim.new(0, 6)
UI["ScriptsContentLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ScriptsContentLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ScriptsContentLayout"]["Parent"] = UI["ScriptsContent"]

UI["ScriptsContentPadding"] = Instance.new("UIPadding")
UI["ScriptsContentPadding"]["Name"] = "ScriptsContentPadding"
UI["ScriptsContentPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["ScriptsContentPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["ScriptsContentPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["ScriptsContentPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["ScriptsContentPadding"]["Parent"] = UI["ScriptsContent"]

UI["SavedScriptsSearchFrame"] = Instance.new("Frame")
UI["SavedScriptsSearchFrame"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["SavedScriptsSearchFrame"]["BorderSizePixel"] = 0
UI["SavedScriptsSearchFrame"]["LayoutOrder"] = 1
UI["SavedScriptsSearchFrame"]["Name"] = "SavedScriptsSearchFrame"
UI["SavedScriptsSearchFrame"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["SavedScriptsSearchFrame"]["Parent"] = UI["ScriptsContent"]

UI["SavedScriptsSearchFramePadding"] = Instance.new("UIPadding")
UI["SavedScriptsSearchFramePadding"]["Name"] = "SavedScriptsSearchFramePadding"
UI["SavedScriptsSearchFramePadding"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SavedScriptsSearchFrameLayout"] = Instance.new("UIListLayout")
UI["SavedScriptsSearchFrameLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["SavedScriptsSearchFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptsSearchFrameLayout"]["Name"] = "SavedScriptsSearchFrameLayout"
UI["SavedScriptsSearchFrameLayout"]["Padding"] = UDim.new(0, 2)
UI["SavedScriptsSearchFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SavedScriptsSearchFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptsSearchFrameLayout"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SavedScriptsSearchFrameSizeCons"] = Instance.new("UISizeConstraint")
UI["SavedScriptsSearchFrameSizeCons"]["MaxSize"] = Vector2.new(2147483647, 30)
UI["SavedScriptsSearchFrameSizeCons"]["MinSize"] = Vector2.new(0, 30)
UI["SavedScriptsSearchFrameSizeCons"]["Name"] = "SavedScriptsSearchFrameSizeCons"
UI["SavedScriptsSearchFrameSizeCons"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SavedScriptsSearchFrameCorner"] = Instance.new("UICorner")
UI["SavedScriptsSearchFrameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SavedScriptsSearchFrameCorner"]["Name"] = "SavedScriptsSearchFrameCorner"
UI["SavedScriptsSearchFrameCorner"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SavedScriptsSearchFrameStroke"] = Instance.new("UIStroke")
UI["SavedScriptsSearchFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SavedScriptsSearchFrameStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["SavedScriptsSearchFrameStroke"]["Name"] = "SavedScriptsSearchFrameStroke"
UI["SavedScriptsSearchFrameStroke"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SearchBox2"] = Instance.new("TextBox")
UI["SearchBox2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox2"]["BackgroundTransparency"] = 1
UI["SearchBox2"]["BorderSizePixel"] = 0
UI["SearchBox2"]["FontFace"] = GothamMedium
UI["SearchBox2"]["LayoutOrder"] = 1
UI["SearchBox2"]["Name"] = "SearchBox2"
UI["SearchBox2"]["PlaceholderColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox2"]["PlaceholderText"] = "Search saved scripts..."
UI["SearchBox2"]["Size"] = UDim2.new(0.95, 0, 1, 0)
UI["SearchBox2"]["Text"] = ""
UI["SearchBox2"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SearchBox2"]["TextScaled"] = true
UI["SearchBox2"]["TextSize"] = 12
UI["SearchBox2"]["TextWrapped"] = true
UI["SearchBox2"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["SearchBox2"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["SearchBox2"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["SearchBox2Padding"] = Instance.new("UIPadding")
UI["SearchBox2Padding"]["Name"] = "SearchBox2Padding"
UI["SearchBox2Padding"]["PaddingBottom"] = UDim.new(0, 6)
UI["SearchBox2Padding"]["PaddingLeft"] = UDim.new(0, 6)
UI["SearchBox2Padding"]["PaddingRight"] = UDim.new(0, 6)
UI["SearchBox2Padding"]["PaddingTop"] = UDim.new(0, 6)
UI["SearchBox2Padding"]["Parent"] = UI["SearchBox2"]

UI["NewScriptBtn"] = Instance.new("TextButton")
UI["NewScriptBtn"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["NewScriptBtn"]["BackgroundTransparency"] = 1
UI["NewScriptBtn"]["BorderSizePixel"] = 0
UI["NewScriptBtn"]["FontFace"] = GothamMedium
UI["NewScriptBtn"]["LayoutOrder"] = 2
UI["NewScriptBtn"]["Name"] = "NewScriptBtn"
UI["NewScriptBtn"]["Size"] = UDim2.new(0.05, 0, 1, 0)
UI["NewScriptBtn"]["Text"] = "+"
UI["NewScriptBtn"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["NewScriptBtn"]["TextScaled"] = true
UI["NewScriptBtn"]["TextWrapped"] = true
UI["NewScriptBtn"]["Parent"] = UI["SavedScriptsSearchFrame"]

UI["NewScriptBtnStroke"] = Instance.new("UIStroke")
UI["NewScriptBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["NewScriptBtnStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["NewScriptBtnStroke"]["Name"] = "NewScriptBtnStroke"
UI["NewScriptBtnStroke"]["Parent"] = UI["NewScriptBtn"]

UI["NewScriptBtnRatio"] = Instance.new("UIAspectRatioConstraint")
UI["NewScriptBtnRatio"]["Name"] = "NewScriptBtnRatio"
UI["NewScriptBtnRatio"]["Parent"] = UI["NewScriptBtn"]

UI["NewScriptBtnPadding"] = Instance.new("UIPadding")
UI["NewScriptBtnPadding"]["Name"] = "NewScriptBtnPadding"
UI["NewScriptBtnPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["NewScriptBtnPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["NewScriptBtnPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["NewScriptBtnPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["NewScriptBtnPadding"]["Parent"] = UI["NewScriptBtn"]

UI["NewScriptBtnCorner"] = Instance.new("UICorner")
UI["NewScriptBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["NewScriptBtnCorner"]["Name"] = "NewScriptBtnCorner"
UI["NewScriptBtnCorner"]["Parent"] = UI["NewScriptBtn"]

UI["SavedScriptsScroll"] = Instance.new("ScrollingFrame")
UI["SavedScriptsScroll"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["SavedScriptsScroll"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["SavedScriptsScroll"]["BackgroundTransparency"] = 1
UI["SavedScriptsScroll"]["BorderSizePixel"] = 0
UI["SavedScriptsScroll"]["LayoutOrder"] = 2
UI["SavedScriptsScroll"]["Name"] = "SavedScriptsScroll"
UI["SavedScriptsScroll"]["ScrollBarThickness"] = 0
UI["SavedScriptsScroll"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["SavedScriptsScroll"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["SavedScriptsScroll"]["Parent"] = UI["ScriptsContent"]

UI["SavedScriptsScrollPadding"] = Instance.new("UIPadding")
UI["SavedScriptsScrollPadding"]["Name"] = "SavedScriptsScrollPadding"
UI["SavedScriptsScrollPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["SavedScriptsScrollPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["SavedScriptsScrollPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["SavedScriptsScrollPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["SavedScriptsScrollPadding"]["Parent"] = UI["SavedScriptsScroll"]

UI["SavedScriptsScrollLayout"] = Instance.new("UIListLayout")
UI["SavedScriptsScrollLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptsScrollLayout"]["Name"] = "SavedScriptsScrollLayout"
UI["SavedScriptsScrollLayout"]["Padding"] = UDim.new(0, 8)
UI["SavedScriptsScrollLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SavedScriptsScrollLayout"]["Parent"] = UI["SavedScriptsScroll"]

UI["NoSavedScriptsLabel"] = Instance.new("TextLabel")
UI["NoSavedScriptsLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["NoSavedScriptsLabel"]["BackgroundTransparency"] = 1
UI["NoSavedScriptsLabel"]["BorderSizePixel"] = 0
UI["NoSavedScriptsLabel"]["FontFace"] = GothamMedium
UI["NoSavedScriptsLabel"]["Name"] = "NoSavedScriptsLabel"
UI["NoSavedScriptsLabel"]["Size"] = UDim2.new(1, 0, 0, 60)
UI["NoSavedScriptsLabel"]["Text"] = [[
No Saved Scripts

Save some scripts to see them here.
]]
UI["NoSavedScriptsLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["NoSavedScriptsLabel"]["TextScaled"] = true
UI["NoSavedScriptsLabel"]["TextWrapped"] = true
UI["NoSavedScriptsLabel"]["Visible"] = false
UI["NoSavedScriptsLabel"]["Parent"] = UI["SavedScriptsScroll"]

UI["NoSavedScriptsLabelStroke"] = Instance.new("UIStroke")
UI["NoSavedScriptsLabelStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["NoSavedScriptsLabelStroke"]["Name"] = "NoSavedScriptsLabelStroke"
UI["NoSavedScriptsLabelStroke"]["Parent"] = UI["NoSavedScriptsLabel"]

UI["SavedScriptTemplate"] = Instance.new("Frame")
UI["SavedScriptTemplate"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["SavedScriptTemplate"]["BorderSizePixel"] = 0
UI["SavedScriptTemplate"]["Name"] = "SavedScriptTemplate"
UI["SavedScriptTemplate"]["Size"] = UDim2.new(0, 166, 0, 64)
UI["SavedScriptTemplate"]["Visible"] = false
UI["SavedScriptTemplate"]["Parent"] = UI["SavedScriptsScroll"]

UI["SavedScriptTemplateCorner"] = Instance.new("UICorner")
UI["SavedScriptTemplateCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SavedScriptTemplateCorner"]["Name"] = "SavedScriptTemplateCorner"
UI["SavedScriptTemplateCorner"]["Parent"] = UI["SavedScriptTemplate"]

UI["SavedScriptTemplateStroke"] = Instance.new("UIStroke")
UI["SavedScriptTemplateStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SavedScriptTemplateStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["SavedScriptTemplateStroke"]["Name"] = "SavedScriptTemplateStroke"
UI["SavedScriptTemplateStroke"]["Parent"] = UI["SavedScriptTemplate"]

UI["SavedScriptTemplateLayout"] = Instance.new("UIListLayout")
UI["SavedScriptTemplateLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["SavedScriptTemplateLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptTemplateLayout"]["Name"] = "SavedScriptTemplateLayout"
UI["SavedScriptTemplateLayout"]["Padding"] = UDim.new(0, 2)
UI["SavedScriptTemplateLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SavedScriptTemplateLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptTemplateLayout"]["Parent"] = UI["SavedScriptTemplate"]

UI["SavedScriptInfo"] = Instance.new("Frame")
UI["SavedScriptInfo"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptInfo"]["BackgroundTransparency"] = 1
UI["SavedScriptInfo"]["BorderSizePixel"] = 0
UI["SavedScriptInfo"]["LayoutOrder"] = 1
UI["SavedScriptInfo"]["Name"] = "SavedScriptInfo"
UI["SavedScriptInfo"]["Size"] = UDim2.new(0, 380, 0, 12)
UI["SavedScriptInfo"]["Parent"] = UI["SavedScriptTemplate"]

UI["SavedScriptInfoPadding"] = Instance.new("UIPadding")
UI["SavedScriptInfoPadding"]["Name"] = "SavedScriptInfoPadding"
UI["SavedScriptInfoPadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["SavedScriptInfoPadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["SavedScriptInfoPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["SavedScriptInfoPadding"]["PaddingTop"] = UDim.new(0, 6)
UI["SavedScriptInfoPadding"]["Parent"] = UI["SavedScriptInfo"]

UI["SavedScriptInfoLayout"] = Instance.new("UIListLayout")
UI["SavedScriptInfoLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptInfoLayout"]["Name"] = "SavedScriptInfoLayout"
UI["SavedScriptInfoLayout"]["Padding"] = UDim.new(0, 2)
UI["SavedScriptInfoLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SavedScriptInfoLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptInfoLayout"]["Parent"] = UI["SavedScriptInfo"]

UI["SavedScriptTitle"] = Instance.new("TextLabel")
UI["SavedScriptTitle"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptTitle"]["BackgroundTransparency"] = 1
UI["SavedScriptTitle"]["BorderSizePixel"] = 0
UI["SavedScriptTitle"]["FontFace"] = GothamBold
UI["SavedScriptTitle"]["LayoutOrder"] = 1
UI["SavedScriptTitle"]["Name"] = "SavedScriptTitle"
UI["SavedScriptTitle"]["Size"] = UDim2.new(1, 0, 0.6, 0)
UI["SavedScriptTitle"]["Text"] = "Script name"
UI["SavedScriptTitle"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptTitle"]["TextScaled"] = true
UI["SavedScriptTitle"]["TextWrapped"] = true
UI["SavedScriptTitle"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["SavedScriptTitle"]["Parent"] = UI["SavedScriptInfo"]

UI["SavedScriptDesc"] = Instance.new("TextLabel")
UI["SavedScriptDesc"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptDesc"]["BackgroundTransparency"] = 1
UI["SavedScriptDesc"]["BorderSizePixel"] = 0
UI["SavedScriptDesc"]["FontFace"] = GothamMedium
UI["SavedScriptDesc"]["LayoutOrder"] = 2
UI["SavedScriptDesc"]["Name"] = "SavedScriptDesc"
UI["SavedScriptDesc"]["Size"] = UDim2.new(1, 0, 0.4, 0)
UI["SavedScriptDesc"]["Text"] = "Script description"
UI["SavedScriptDesc"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptDesc"]["TextScaled"] = true
UI["SavedScriptDesc"]["TextWrapped"] = true
UI["SavedScriptDesc"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["SavedScriptDesc"]["Parent"] = UI["SavedScriptInfo"]

UI["SavedScriptActions"] = Instance.new("Frame")
UI["SavedScriptActions"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SavedScriptActions"]["BackgroundTransparency"] = 1
UI["SavedScriptActions"]["BorderSizePixel"] = 0
UI["SavedScriptActions"]["LayoutOrder"] = 2
UI["SavedScriptActions"]["Name"] = "SavedScriptActions"
UI["SavedScriptActions"]["Position"] = UDim2.new(0, 34, 0, 0)
UI["SavedScriptActions"]["Size"] = UDim2.new(0, 0, 0, 12)
UI["SavedScriptActions"]["Parent"] = UI["SavedScriptTemplate"]

UI["SavedScriptActionsPadding"] = Instance.new("UIPadding")
UI["SavedScriptActionsPadding"]["Name"] = "SavedScriptActionsPadding"
UI["SavedScriptActionsPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["SavedScriptActionsPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["SavedScriptActionsPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["SavedScriptActionsPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["SavedScriptActionsPadding"]["Parent"] = UI["SavedScriptActions"]

UI["SavedScriptActionsLayout"] = Instance.new("UIListLayout")
UI["SavedScriptActionsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptActionsLayout"]["Name"] = "SavedScriptActionsLayout"
UI["SavedScriptActionsLayout"]["Padding"] = UDim.new(0, 6)
UI["SavedScriptActionsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SavedScriptActionsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SavedScriptActionsLayout"]["Parent"] = UI["SavedScriptActions"]

UI["RunSavedScript"] = Instance.new("TextButton")
UI["RunSavedScript"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["RunSavedScript"]["BorderSizePixel"] = 0
UI["RunSavedScript"]["FontFace"] = GothamMedium
UI["RunSavedScript"]["LayoutOrder"] = 1
UI["RunSavedScript"]["Name"] = "RunSavedScript"
UI["RunSavedScript"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["RunSavedScript"]["Text"] = "Run"
UI["RunSavedScript"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["RunSavedScript"]["TextScaled"] = true
UI["RunSavedScript"]["TextWrapped"] = true
UI["RunSavedScript"]["Parent"] = UI["SavedScriptActions"]

UI["RunSavedScriptStroke"] = Instance.new("UIStroke")
UI["RunSavedScriptStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["RunSavedScriptStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["RunSavedScriptStroke"]["Name"] = "RunSavedScriptStroke"
UI["RunSavedScriptStroke"]["Parent"] = UI["RunSavedScript"]

UI["RunSavedScriptCorner"] = Instance.new("UICorner")
UI["RunSavedScriptCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["RunSavedScriptCorner"]["Name"] = "RunSavedScriptCorner"
UI["RunSavedScriptCorner"]["Parent"] = UI["RunSavedScript"]

UI["RunSavedScriptPadding"] = Instance.new("UIPadding")
UI["RunSavedScriptPadding"]["Name"] = "RunSavedScriptPadding"
UI["RunSavedScriptPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["RunSavedScriptPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["RunSavedScriptPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["RunSavedScriptPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["RunSavedScriptPadding"]["Parent"] = UI["RunSavedScript"]

UI["DeleteSavedScript"] = Instance.new("TextButton")
UI["DeleteSavedScript"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["DeleteSavedScript"]["BorderSizePixel"] = 0
UI["DeleteSavedScript"]["FontFace"] = GothamMedium
UI["DeleteSavedScript"]["LayoutOrder"] = 2
UI["DeleteSavedScript"]["Name"] = "DeleteSavedScript"
UI["DeleteSavedScript"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["DeleteSavedScript"]["Text"] = "Delete"
UI["DeleteSavedScript"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["DeleteSavedScript"]["TextScaled"] = true
UI["DeleteSavedScript"]["TextWrapped"] = true
UI["DeleteSavedScript"]["Parent"] = UI["SavedScriptActions"]

UI["DeleteSavedScriptCorner"] = Instance.new("UICorner")
UI["DeleteSavedScriptCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["DeleteSavedScriptCorner"]["Name"] = "DeleteSavedScriptCorner"
UI["DeleteSavedScriptCorner"]["Parent"] = UI["DeleteSavedScript"]

UI["DeleteSavedScriptStroke"] = Instance.new("UIStroke")
UI["DeleteSavedScriptStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["DeleteSavedScriptStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["DeleteSavedScriptStroke"]["Name"] = "DeleteSavedScriptStroke"
UI["DeleteSavedScriptStroke"]["Parent"] = UI["DeleteSavedScript"]

UI["DeleteSavedScriptPadding"] = Instance.new("UIPadding")
UI["DeleteSavedScriptPadding"]["Name"] = "DeleteSavedScriptPadding"
UI["DeleteSavedScriptPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["DeleteSavedScriptPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["DeleteSavedScriptPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["DeleteSavedScriptPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["DeleteSavedScriptPadding"]["Parent"] = UI["DeleteSavedScript"]

UI["NewScriptFrame"] = Instance.new("Frame")
UI["NewScriptFrame"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["NewScriptFrame"]["BackgroundColor3"] = Color3.fromRGB(11, 11, 11)
UI["NewScriptFrame"]["BorderSizePixel"] = 0
UI["NewScriptFrame"]["Name"] = "NewScriptFrame"
UI["NewScriptFrame"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["NewScriptFrame"]["Size"] = UDim2.new(0, 408, 0, 214)
UI["NewScriptFrame"]["Visible"] = false
UI["NewScriptFrame"]["ZIndex"] = 2
UI["NewScriptFrame"]["Parent"] = UI["ScreenGui"]

UI["NewScriptFrameStroke"] = Instance.new("UIStroke")
UI["NewScriptFrameStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["NewScriptFrameStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["NewScriptFrameStroke"]["Name"] = "NewScriptFrameStroke"
UI["NewScriptFrameStroke"]["Parent"] = UI["NewScriptFrame"]

UI["NewScriptFramePadding"] = Instance.new("UIPadding")
UI["NewScriptFramePadding"]["Name"] = "NewScriptFramePadding"
UI["NewScriptFramePadding"]["PaddingBottom"] = UDim.new(0, 6)
UI["NewScriptFramePadding"]["PaddingLeft"] = UDim.new(0, 6)
UI["NewScriptFramePadding"]["PaddingRight"] = UDim.new(0, 6)
UI["NewScriptFramePadding"]["PaddingTop"] = UDim.new(0, 6)
UI["NewScriptFramePadding"]["Parent"] = UI["NewScriptFrame"]

UI["NewScriptFrameLayout"] = Instance.new("UIListLayout")
UI["NewScriptFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["NewScriptFrameLayout"]["Name"] = "NewScriptFrameLayout"
UI["NewScriptFrameLayout"]["Padding"] = UDim.new(0, 8)
UI["NewScriptFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["NewScriptFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["NewScriptFrameLayout"]["Parent"] = UI["NewScriptFrame"]

UI["NewScriptFrameCorner"] = Instance.new("UICorner")
UI["NewScriptFrameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["NewScriptFrameCorner"]["Name"] = "NewScriptFrameCorner"
UI["NewScriptFrameCorner"]["Parent"] = UI["NewScriptFrame"]

UI["NameBox"] = Instance.new("TextBox")
UI["NameBox"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["NameBox"]["BorderSizePixel"] = 0
UI["NameBox"]["FontFace"] = GothamMedium
UI["NameBox"]["LayoutOrder"] = 1
UI["NameBox"]["Name"] = "NameBox"
UI["NameBox"]["PlaceholderText"] = "Enter script name..."
UI["NameBox"]["Size"] = UDim2.new(0, 76, 0, 30)
UI["NameBox"]["Text"] = ""
UI["NameBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["NameBox"]["TextScaled"] = true
UI["NameBox"]["TextWrapped"] = true
UI["NameBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["NameBox"]["Parent"] = UI["NewScriptFrame"]

UI["NameBoxPadding"] = Instance.new("UIPadding")
UI["NameBoxPadding"]["Name"] = "NameBoxPadding"
UI["NameBoxPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["NameBoxPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["NameBoxPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["NameBoxPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["NameBoxPadding"]["Parent"] = UI["NameBox"]

UI["NameBoxStroke"] = Instance.new("UIStroke")
UI["NameBoxStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["NameBoxStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["NameBoxStroke"]["Name"] = "NameBoxStroke"
UI["NameBoxStroke"]["Parent"] = UI["NameBox"]

UI["NameBoxCorner"] = Instance.new("UICorner")
UI["NameBoxCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["NameBoxCorner"]["Name"] = "NameBoxCorner"
UI["NameBoxCorner"]["Parent"] = UI["NameBox"]

UI["DescBox"] = Instance.new("TextBox")
UI["DescBox"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["DescBox"]["BorderSizePixel"] = 0
UI["DescBox"]["FontFace"] = GothamMedium
UI["DescBox"]["LayoutOrder"] = 2
UI["DescBox"]["Name"] = "DescBox"
UI["DescBox"]["PlaceholderText"] = "Enter script description..."
UI["DescBox"]["Size"] = UDim2.new(0, 76, 0, 30)
UI["DescBox"]["Text"] = ""
UI["DescBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["DescBox"]["TextScaled"] = true
UI["DescBox"]["TextWrapped"] = true
UI["DescBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["DescBox"]["Parent"] = UI["NewScriptFrame"]

UI["DescBoxCorner"] = Instance.new("UICorner")
UI["DescBoxCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["DescBoxCorner"]["Name"] = "DescBoxCorner"
UI["DescBoxCorner"]["Parent"] = UI["DescBox"]

UI["DescBoxPadding"] = Instance.new("UIPadding")
UI["DescBoxPadding"]["Name"] = "DescBoxPadding"
UI["DescBoxPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["DescBoxPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["DescBoxPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["DescBoxPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["DescBoxPadding"]["Parent"] = UI["DescBox"]

UI["DescBoxStroke"] = Instance.new("UIStroke")
UI["DescBoxStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["DescBoxStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["DescBoxStroke"]["Name"] = "DescBoxStroke"
UI["DescBoxStroke"]["Parent"] = UI["DescBox"]

UI["ScriptBox"] = Instance.new("TextBox")
UI["ScriptBox"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["ScriptBox"]["BorderSizePixel"] = 0
UI["ScriptBox"]["FontFace"] = Inconsolata
UI["ScriptBox"]["LayoutOrder"] = 3
UI["ScriptBox"]["Name"] = "ScriptBox"
UI["ScriptBox"]["PlaceholderText"] = "Enter script..."
UI["ScriptBox"]["Size"] = UDim2.new(0, 76, 0, 80)
UI["ScriptBox"]["Text"] = ""
UI["ScriptBox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["ScriptBox"]["TextSize"] = 20
UI["ScriptBox"]["TextWrapped"] = true
UI["ScriptBox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["ScriptBox"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["ScriptBox"]["Parent"] = UI["NewScriptFrame"]

UI["ScriptBoxPadding"] = Instance.new("UIPadding")
UI["ScriptBoxPadding"]["Name"] = "ScriptBoxPadding"
UI["ScriptBoxPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ScriptBoxPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ScriptBoxPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ScriptBoxPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ScriptBoxPadding"]["Parent"] = UI["ScriptBox"]

UI["ScriptBoxCorner"] = Instance.new("UICorner")
UI["ScriptBoxCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ScriptBoxCorner"]["Name"] = "ScriptBoxCorner"
UI["ScriptBoxCorner"]["Parent"] = UI["ScriptBox"]

UI["ScriptBoxStroke"] = Instance.new("UIStroke")
UI["ScriptBoxStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ScriptBoxStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["ScriptBoxStroke"]["Name"] = "ScriptBoxStroke"
UI["ScriptBoxStroke"]["Parent"] = UI["ScriptBox"]

UI["Options"] = Instance.new("Frame")
UI["Options"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Options"]["BackgroundTransparency"] = 1
UI["Options"]["BorderSizePixel"] = 0
UI["Options"]["LayoutOrder"] = 4
UI["Options"]["Name"] = "Options"
UI["Options"]["Position"] = UDim2.new(0, 50, 0, -8)
UI["Options"]["Size"] = UDim2.new(0, 76, 0, 34)
UI["Options"]["Parent"] = UI["NewScriptFrame"]

UI["OptionsCorner"] = Instance.new("UICorner")
UI["OptionsCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["OptionsCorner"]["Name"] = "OptionsCorner"
UI["OptionsCorner"]["Parent"] = UI["Options"]

UI["OptionsLayout"] = Instance.new("UIListLayout")
UI["OptionsLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["OptionsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["OptionsLayout"]["Name"] = "OptionsLayout"
UI["OptionsLayout"]["Padding"] = UDim.new(0, 8)
UI["OptionsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["OptionsLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["OptionsLayout"]["Parent"] = UI["Options"]

UI["Cancel"] = Instance.new("TextButton")
UI["Cancel"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["Cancel"]["BorderSizePixel"] = 0
UI["Cancel"]["FontFace"] = GothamMedium
UI["Cancel"]["LayoutOrder"] = 2
UI["Cancel"]["Name"] = "Cancel"
UI["Cancel"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Cancel"]["Text"] = "Cancel"
UI["Cancel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Cancel"]["TextScaled"] = true
UI["Cancel"]["TextWrapped"] = true
UI["Cancel"]["Parent"] = UI["Options"]

UI["CancelCorner"] = Instance.new("UICorner")
UI["CancelCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["CancelCorner"]["Name"] = "CancelCorner"
UI["CancelCorner"]["Parent"] = UI["Cancel"]

UI["CancelStroke"] = Instance.new("UIStroke")
UI["CancelStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["CancelStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["CancelStroke"]["Name"] = "CancelStroke"
UI["CancelStroke"]["Parent"] = UI["Cancel"]

UI["Save"] = Instance.new("TextButton")
UI["Save"]["BackgroundColor3"] = Color3.fromRGB(0, 99, 255)
UI["Save"]["BorderSizePixel"] = 0
UI["Save"]["FontFace"] = GothamMedium
UI["Save"]["LayoutOrder"] = 1
UI["Save"]["Name"] = "Save"
UI["Save"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Save"]["Text"] = "Save"
UI["Save"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Save"]["TextScaled"] = true
UI["Save"]["TextWrapped"] = true
UI["Save"]["Parent"] = UI["Options"]

UI["SaveStroke"] = Instance.new("UIStroke")
UI["SaveStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SaveStroke"]["Color"] = Color3.fromRGB(0, 64, 180)
UI["SaveStroke"]["Name"] = "SaveStroke"
UI["SaveStroke"]["Parent"] = UI["Save"]

UI["SaveCorner"] = Instance.new("UICorner")
UI["SaveCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SaveCorner"]["Name"] = "SaveCorner"
UI["SaveCorner"]["Parent"] = UI["Save"]

UI["SettingsContent"] = Instance.new("CanvasGroup")
UI["SettingsContent"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["SettingsContent"]["BorderSizePixel"] = 0
UI["SettingsContent"]["LayoutOrder"] = 1
UI["SettingsContent"]["Name"] = "SettingsContent"
UI["SettingsContent"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["SettingsContent"]["Visible"] = false
UI["SettingsContent"]["Parent"] = UI["Pages"]

UI["SettingsContentCorner"] = Instance.new("UICorner")
UI["SettingsContentCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SettingsContentCorner"]["Name"] = "SettingsContentCorner"
UI["SettingsContentCorner"]["Parent"] = UI["SettingsContent"]

UI["SettingsContentStroke"] = Instance.new("UIStroke")
UI["SettingsContentStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["SettingsContentStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["SettingsContentStroke"]["Name"] = "SettingsContentStroke"
UI["SettingsContentStroke"]["Parent"] = UI["SettingsContent"]

UI["SettingsFrame"] = Instance.new("ScrollingFrame")
UI["SettingsFrame"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["SettingsFrame"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SettingsFrame"]["BackgroundTransparency"] = 1
UI["SettingsFrame"]["BorderSizePixel"] = 0
UI["SettingsFrame"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["SettingsFrame"]["Name"] = "SettingsFrame"
UI["SettingsFrame"]["Size"] = UDim2.new(1, 0, 1, 0)
UI["SettingsFrame"]["Parent"] = UI["SettingsContent"]

UI["SettingsFramePadding"] = Instance.new("UIPadding")
UI["SettingsFramePadding"]["Name"] = "SettingsFramePadding"
UI["SettingsFramePadding"]["PaddingBottom"] = UDim.new(0, 5)
UI["SettingsFramePadding"]["PaddingLeft"] = UDim.new(0, 5)
UI["SettingsFramePadding"]["PaddingRight"] = UDim.new(0, 5)
UI["SettingsFramePadding"]["PaddingTop"] = UDim.new(0, 5)
UI["SettingsFramePadding"]["Parent"] = UI["SettingsFrame"]

UI["SettingsFrameLayout"] = Instance.new("UIListLayout")
UI["SettingsFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SettingsFrameLayout"]["Name"] = "SettingsFrameLayout"
UI["SettingsFrameLayout"]["Padding"] = UDim.new(0, 6)
UI["SettingsFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SettingsFrameLayout"]["Parent"] = UI["SettingsFrame"]

UI["AnimsToggle"] = Instance.new("TextButton")
UI["AnimsToggle"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["AnimsToggle"]["BorderSizePixel"] = 0
UI["AnimsToggle"]["LayoutOrder"] = 1
UI["AnimsToggle"]["Name"] = "AnimsToggle"
UI["AnimsToggle"]["Size"] = UDim2.new(1, 0, 0, 38)
UI["AnimsToggle"]["Text"] = ""
UI["AnimsToggle"]["Parent"] = UI["SettingsFrame"]

UI["AnimsToggleCorner"] = Instance.new("UICorner")
UI["AnimsToggleCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["AnimsToggleCorner"]["Name"] = "AnimsToggleCorner"
UI["AnimsToggleCorner"]["Parent"] = UI["AnimsToggle"]

UI["AnimsToggleStroke"] = Instance.new("UIStroke")
UI["AnimsToggleStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["AnimsToggleStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["AnimsToggleStroke"]["Name"] = "AnimsToggleStroke"
UI["AnimsToggleStroke"]["Parent"] = UI["AnimsToggle"]

UI["AnimsTogglePadding"] = Instance.new("UIPadding")
UI["AnimsTogglePadding"]["Name"] = "AnimsTogglePadding"
UI["AnimsTogglePadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["AnimsTogglePadding"]["PaddingLeft"] = UDim.new(0, 8)
UI["AnimsTogglePadding"]["PaddingRight"] = UDim.new(0, 8)
UI["AnimsTogglePadding"]["PaddingTop"] = UDim.new(0, 8)
UI["AnimsTogglePadding"]["Parent"] = UI["AnimsToggle"]

UI["AnimsToggleLayout"] = Instance.new("UIListLayout")
UI["AnimsToggleLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["AnimsToggleLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["AnimsToggleLayout"]["Name"] = "AnimsToggleLayout"
UI["AnimsToggleLayout"]["Padding"] = UDim.new(0, 6)
UI["AnimsToggleLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["AnimsToggleLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["AnimsToggleLayout"]["Parent"] = UI["AnimsToggle"]

UI["AnimsToggleLabel"] = Instance.new("TextLabel")
UI["AnimsToggleLabel"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["AnimsToggleLabel"]["BackgroundTransparency"] = 1
UI["AnimsToggleLabel"]["BorderSizePixel"] = 0
UI["AnimsToggleLabel"]["FontFace"] = GothamMedium
UI["AnimsToggleLabel"]["LayoutOrder"] = 1
UI["AnimsToggleLabel"]["Name"] = "AnimsToggleLabel"
UI["AnimsToggleLabel"]["Size"] = UDim2.new(0.8, 0, 1, 0)
UI["AnimsToggleLabel"]["Text"] = "Animations"
UI["AnimsToggleLabel"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["AnimsToggleLabel"]["TextScaled"] = true
UI["AnimsToggleLabel"]["TextWrapped"] = true
UI["AnimsToggleLabel"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["AnimsToggleLabel"]["Parent"] = UI["AnimsToggle"]

UI["ToggleState"] = Instance.new("Frame")
UI["ToggleState"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0)
UI["ToggleState"]["BorderSizePixel"] = 0
UI["ToggleState"]["LayoutOrder"] = 2
UI["ToggleState"]["Name"] = "ToggleState"
UI["ToggleState"]["Size"] = UDim2.new(0.2, 0, 0.6, 0)
UI["ToggleState"]["Parent"] = UI["AnimsToggle"]

UI["ToggleStateCorner"] = Instance.new("UICorner")
UI["ToggleStateCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ToggleStateCorner"]["Name"] = "ToggleStateCorner"
UI["ToggleStateCorner"]["Parent"] = UI["ToggleState"]

UI["ToggleStateRatio"] = Instance.new("UIAspectRatioConstraint")
UI["ToggleStateRatio"]["Name"] = "ToggleStateRatio"
UI["ToggleStateRatio"]["Parent"] = UI["ToggleState"]

UI["ToggleStateStroke"] = Instance.new("UIStroke")
UI["ToggleStateStroke"]["Color"] = Color3.fromRGB(255, 0, 0)
UI["ToggleStateStroke"]["Name"] = "ToggleStateStroke"
UI["ToggleStateStroke"]["Transparency"] = 0.5
UI["ToggleStateStroke"]["Parent"] = UI["ToggleState"]

UI["SidebarContainer"] = Instance.new("Frame")
UI["SidebarContainer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["SidebarContainer"]["BackgroundTransparency"] = 1
UI["SidebarContainer"]["BorderSizePixel"] = 0
UI["SidebarContainer"]["LayoutOrder"] = 2
UI["SidebarContainer"]["Name"] = "SidebarContainer"
UI["SidebarContainer"]["Position"] = UDim2.new(0, 250, 0, 30)
UI["SidebarContainer"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["SidebarContainer"]["Parent"] = UI["MainFrame"]

UI["Sidebar"] = Instance.new("Frame")
UI["Sidebar"]["AnchorPoint"] = Vector2.new(1, 0.5)
UI["Sidebar"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
UI["Sidebar"]["BorderSizePixel"] = 0
UI["Sidebar"]["Name"] = "Sidebar"
UI["Sidebar"]["Position"] = UDim2.new(1, 8, 0.5, 0)
UI["Sidebar"]["Size"] = UDim2.new(1, 0, 1, -10)
UI["Sidebar"]["Parent"] = UI["SidebarContainer"]

UI["SidebarCorner"] = Instance.new("UICorner")
UI["SidebarCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["SidebarCorner"]["Name"] = "SidebarCorner"
UI["SidebarCorner"]["Parent"] = UI["Sidebar"]

UI["SidebarStroke"] = Instance.new("UIStroke")
UI["SidebarStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["SidebarStroke"]["Name"] = "SidebarStroke"
UI["SidebarStroke"]["Parent"] = UI["Sidebar"]

UI["SidebarPadding"] = Instance.new("UIPadding")
UI["SidebarPadding"]["Name"] = "SidebarPadding"
UI["SidebarPadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["SidebarPadding"]["PaddingLeft"] = UDim.new(0, 8)
UI["SidebarPadding"]["PaddingRight"] = UDim.new(0, 18)
UI["SidebarPadding"]["PaddingTop"] = UDim.new(0, 8)
UI["SidebarPadding"]["Parent"] = UI["Sidebar"]

UI["SidebarLayout"] = Instance.new("UIListLayout")
UI["SidebarLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["SidebarLayout"]["Name"] = "SidebarLayout"
UI["SidebarLayout"]["Padding"] = UDim.new(0, 3)
UI["SidebarLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["SidebarLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["SidebarLayout"]["Parent"] = UI["Sidebar"]

UI["SidebarSizeCons"] = Instance.new("UISizeConstraint")
UI["SidebarSizeCons"]["MaxSize"] = Vector2.new(2147483647, 2147483647)
UI["SidebarSizeCons"]["Name"] = "SidebarSizeCons"
UI["SidebarSizeCons"]["Parent"] = UI["Sidebar"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Topbar"]["BackgroundTransparency"] = 1
UI["Topbar"]["BorderSizePixel"] = 0
UI["Topbar"]["Name"] = "Topbar"
UI["Topbar"]["Size"] = UDim2.new(0.2, 0, 0.3, 0)
UI["Topbar"]["Parent"] = UI["Sidebar"]

UI["TopbarSizeCons"] = Instance.new("UISizeConstraint")
UI["TopbarSizeCons"]["MaxSize"] = Vector2.new(2147483647, 30)
UI["TopbarSizeCons"]["MinSize"] = Vector2.new(0, 28)
UI["TopbarSizeCons"]["Name"] = "TopbarSizeCons"
UI["TopbarSizeCons"]["Parent"] = UI["Topbar"]

UI["TopbarLayout"] = Instance.new("UIListLayout")
UI["TopbarLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TopbarLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["Name"] = "TopbarLayout"
UI["TopbarLayout"]["Padding"] = UDim.new(0, 4)
UI["TopbarLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["Parent"] = UI["Topbar"]

UI["Logo"] = Instance.new("ImageLabel")
UI["Logo"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Logo"]["BackgroundTransparency"] = 1
UI["Logo"]["BorderSizePixel"] = 0
UI["Logo"]["Image"] = Funcs.GetAsset("Lucid/Assets/lucid_logo.png")
UI["Logo"]["ImageColor3"] = Color3.fromRGB(0, 64, 180)
UI["Logo"]["LayoutOrder"] = 1
UI["Logo"]["Name"] = "Logo"
UI["Logo"]["Size"] = UDim2.new(0, 30, 0, 30)
UI["Logo"]["Parent"] = UI["Topbar"]

UI["LogoRatio"] = Instance.new("UIAspectRatioConstraint")
UI["LogoRatio"]["Name"] = "LogoRatio"
UI["LogoRatio"]["Parent"] = UI["Logo"]

UI["Icon"] = Instance.new("ImageLabel")
UI["Icon"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["Icon"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Icon"]["BackgroundTransparency"] = 1
UI["Icon"]["BorderSizePixel"] = 0
UI["Icon"]["Image"] = Funcs.GetAsset("Lucid/Assets/lucid_logo.png")
UI["Icon"]["ImageColor3"] = Color3.fromRGB(0, 99, 255)
UI["Icon"]["LayoutOrder"] = 1
UI["Icon"]["Name"] = "Icon"
UI["Icon"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["Icon"]["Size"] = UDim2.new(1, -2, 1, -2)
UI["Icon"]["Parent"] = UI["Logo"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title"]["BackgroundTransparency"] = 1
UI["Title"]["BorderSizePixel"] = 0
UI["Title"]["FontFace"] = BuilderSans
UI["Title"]["LayoutOrder"] = 2
UI["Title"]["Name"] = "Title"
UI["Title"]["Size"] = UDim2.new(0, 60, 0, 30)
UI["Title"]["Text"] = "Lucid"
UI["Title"]["TextColor3"] = Color3.fromRGB(0, 99, 255)
UI["Title"]["TextScaled"] = true
UI["Title"]["TextWrapped"] = true
UI["Title"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title"]["Parent"] = UI["Topbar"]

UI["TitleStroke"] = Instance.new("UIStroke")
UI["TitleStroke"]["Color"] = Color3.fromRGB(0, 99, 255)
UI["TitleStroke"]["Name"] = "TitleStroke"
UI["TitleStroke"]["Transparency"] = 0.6
UI["TitleStroke"]["Parent"] = UI["Title"]

UI["TitlePadding"] = Instance.new("UIPadding")
UI["TitlePadding"]["Name"] = "TitlePadding"
UI["TitlePadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["TitlePadding"]["PaddingTop"] = UDim.new(0, 2)
UI["TitlePadding"]["Parent"] = UI["Title"]

UI["CloseTab"] = Instance.new("TextButton")
UI["CloseTab"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["CloseTab"]["BackgroundTransparency"] = 1
UI["CloseTab"]["BorderSizePixel"] = 0
UI["CloseTab"]["LayoutOrder"] = 100
UI["CloseTab"]["Name"] = "CloseTab"
UI["CloseTab"]["Size"] = UDim2.new(0, 30, 0, 58)
UI["CloseTab"]["Text"] = ""
UI["CloseTab"]["Parent"] = UI["Sidebar"]

UI["CloseTabLayout"] = Instance.new("UIListLayout")
UI["CloseTabLayout"]["Name"] = "CloseTabLayout"
UI["CloseTabLayout"]["Padding"] = UDim.new(0, 4)
UI["CloseTabLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["CloseTabLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["CloseTabLayout"]["Parent"] = UI["CloseTab"]

UI["CloseTabSizeCons"] = Instance.new("UISizeConstraint")
UI["CloseTabSizeCons"]["MaxSize"] = Vector2.new(2147483647, 34)
UI["CloseTabSizeCons"]["MinSize"] = Vector2.new(0, 28)
UI["CloseTabSizeCons"]["Name"] = "CloseTabSizeCons"
UI["CloseTabSizeCons"]["Parent"] = UI["CloseTab"]

UI["CloseTabPadding"] = Instance.new("UIPadding")
UI["CloseTabPadding"]["Name"] = "CloseTabPadding"
UI["CloseTabPadding"]["PaddingBottom"] = UDim.new(0, 3)
UI["CloseTabPadding"]["PaddingTop"] = UDim.new(0, 3)
UI["CloseTabPadding"]["Parent"] = UI["CloseTab"]

UI["TabContainer6"] = Instance.new("Frame")
UI["TabContainer6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["TabContainer6"]["BackgroundTransparency"] = 1
UI["TabContainer6"]["BorderSizePixel"] = 0
UI["TabContainer6"]["LayoutOrder"] = 1
UI["TabContainer6"]["Name"] = "TabContainer6"
UI["TabContainer6"]["Size"] = UDim2.new(1, 0, 0, 22)
UI["TabContainer6"]["Parent"] = UI["CloseTab"]

UI["TabContainer6Layout"] = Instance.new("UIListLayout")
UI["TabContainer6Layout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TabContainer6Layout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TabContainer6Layout"]["Name"] = "TabContainer6Layout"
UI["TabContainer6Layout"]["Padding"] = UDim.new(0, 4)
UI["TabContainer6Layout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TabContainer6Layout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TabContainer6Layout"]["Parent"] = UI["TabContainer6"]

UI["TabIcon6"] = Instance.new("ImageLabel")
UI["TabIcon6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["TabIcon6"]["BackgroundTransparency"] = 1
UI["TabIcon6"]["BorderSizePixel"] = 0
UI["TabIcon6"]["Image"] = Funcs.GetAsset("Lucid/Assets/lucid_close.png")
UI["TabIcon6"]["LayoutOrder"] = 1
UI["TabIcon6"]["Name"] = "TabIcon6"
UI["TabIcon6"]["Size"] = UDim2.new(0, 30, 0, 30)
UI["TabIcon6"]["Parent"] = UI["TabContainer6"]

UI["TabIcon6Ratio"] = Instance.new("UIAspectRatioConstraint")
UI["TabIcon6Ratio"]["Name"] = "TabIcon6Ratio"
UI["TabIcon6Ratio"]["Parent"] = UI["TabIcon6"]

UI["TabLabel6"] = Instance.new("TextLabel")
UI["TabLabel6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["TabLabel6"]["BackgroundTransparency"] = 1
UI["TabLabel6"]["BorderSizePixel"] = 0
UI["TabLabel6"]["FontFace"] = BuilderSans
UI["TabLabel6"]["LayoutOrder"] = 2
UI["TabLabel6"]["Name"] = "TabLabel6"
UI["TabLabel6"]["Size"] = UDim2.new(0, 60, 0, 30)
UI["TabLabel6"]["Text"] = "Close"
UI["TabLabel6"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["TabLabel6"]["TextScaled"] = true
UI["TabLabel6"]["TextWrapped"] = true
UI["TabLabel6"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["TabLabel6"]["Parent"] = UI["TabContainer6"]

UI["TabUnderline6"] = Instance.new("Frame")
UI["TabUnderline6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["TabUnderline6"]["BackgroundTransparency"] = 1
UI["TabUnderline6"]["BorderSizePixel"] = 0
UI["TabUnderline6"]["LayoutOrder"] = 2
UI["TabUnderline6"]["Name"] = "TabUnderline6"
UI["TabUnderline6"]["Size"] = UDim2.new(0, 0, 0, 1)
UI["TabUnderline6"]["Parent"] = UI["CloseTab"]

UI["HomeTab"] = Funcs.CreateTab("Lucid/Assets/lucid_home.png", "Home", UI["HomeContent"], 1)
UI["ExeTab"] = Funcs.CreateTab("Lucid/Assets/lucid_executor.png", "Executor", UI["ExeContent"], 2)
UI["SearchTab"] = Funcs.CreateTab("Lucid/Assets/lucid_search.png", "Search", UI["SearchContent"], 3)
UI["ScriptsTab"] = Funcs.CreateTab("Lucid/Assets/lucid_scripts.png", "Scripts", UI["ScriptsContent"], 4)
UI["SettingsTab"] = Funcs.CreateTab("Lucid/Assets/lucid_settings.png", "Settings", UI["SettingsContent"], 5)

Funcs.CreateSettingsInputbox("Background Color (RGB/Hex)", "10, 10, 10", "BackgroundColor", 2)
Funcs.CreateSettingsInputbox("Secondary Background Color (RGB/Hex)", "18, 18, 18", "SecondaryBackgroundColor", 3)
Funcs.CreateSettingsInputbox("Accent Color (RGB/Hex)", "0, 98, 255", "AccentColor", 4)
Funcs.CreateSettingsInputbox("Secondary Accent Color (RGB/Hex)", "0, 63, 179", "SecondaryAccentColor", 5)

UI["ResetThemeBtn"] = Instance.new("TextButton")
UI["ResetThemeBtn"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
UI["ResetThemeBtn"]["BorderSizePixel"] = 0
UI["ResetThemeBtn"]["LayoutOrder"] = 6
UI["ResetThemeBtn"]["Name"] = "ResetThemeBtn"
UI["ResetThemeBtn"]["Size"] = UDim2.new(1, 0, 0, 38)
UI["ResetThemeBtn"]["Text"] = ""
UI["ResetThemeBtn"]["Parent"] = UI["SettingsFrame"]

UI["ResetThemeBtnCorner"] = Instance.new("UICorner")
UI["ResetThemeBtnCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ResetThemeBtnCorner"]["Name"] = "ResetThemeBtnCorner"
UI["ResetThemeBtnCorner"]["Parent"] = UI["ResetThemeBtn"]

UI["ResetThemeBtnStroke"] = Instance.new("UIStroke")
UI["ResetThemeBtnStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
UI["ResetThemeBtnStroke"]["Color"] = Color3.fromRGB(36, 36, 36)
UI["ResetThemeBtnStroke"]["Name"] = "ResetThemeBtnStroke"
UI["ResetThemeBtnStroke"]["Parent"] = UI["ResetThemeBtn"]

UI["ResetThemeBtnLayout"] = Instance.new("UIListLayout")
UI["ResetThemeBtnLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["ResetThemeBtnLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ResetThemeBtnLayout"]["Name"] = "ResetThemeBtnLayout"
UI["ResetThemeBtnLayout"]["Padding"] = UDim.new(0, 6)
UI["ResetThemeBtnLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ResetThemeBtnLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ResetThemeBtnLayout"]["Parent"] = UI["ResetThemeBtn"]

UI["ResetThemeBtnPadding"] = Instance.new("UIPadding")
UI["ResetThemeBtnPadding"]["Name"] = "ResetThemeBtnPadding"
UI["ResetThemeBtnPadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["ResetThemeBtnPadding"]["PaddingLeft"] = UDim.new(0, 8)
UI["ResetThemeBtnPadding"]["PaddingRight"] = UDim.new(0, 8)
UI["ResetThemeBtnPadding"]["PaddingTop"] = UDim.new(0, 8)
UI["ResetThemeBtnPadding"]["Parent"] = UI["ResetThemeBtn"]

UI["AnimsToggleLabel7"] = Instance.new("TextLabel")
UI["AnimsToggleLabel7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["AnimsToggleLabel7"]["BackgroundTransparency"] = 1
UI["AnimsToggleLabel7"]["BorderSizePixel"] = 0
UI["AnimsToggleLabel7"]["FontFace"] = GothamMedium
UI["AnimsToggleLabel7"]["LayoutOrder"] = 1
UI["AnimsToggleLabel7"]["Name"] = "AnimsToggleLabel7"
UI["AnimsToggleLabel7"]["Size"] = UDim2.new(0.8, 0, 1, 0)
UI["AnimsToggleLabel7"]["Text"] = "Reset Theme"
UI["AnimsToggleLabel7"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["AnimsToggleLabel7"]["TextScaled"] = true
UI["AnimsToggleLabel7"]["TextWrapped"] = true
UI["AnimsToggleLabel7"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["AnimsToggleLabel7"]["Parent"] = UI["ResetThemeBtn"]

Funcs.LoadSettings()
Funcs.ApplyTheme()

Funcs.Dragify(UI["Show"])

UI["InputBox"]:GetPropertyChangedSignal("Text"):Connect(function()
    UI["Highlight"]["Text"] = Funcs.Highlight(UI["InputBox"]["Text"])
end)

UI["Show"].MouseButton1Click:Connect(function()
    Funcs.OpenUI()
end)

UI["CloseTab"].MouseButton1Click:Connect(function()
    Funcs.CloseUI()
end)

UI["HomeTab"].MouseButton1Click:Connect(function()
    Funcs.SwitchTab(UI["HomeTab"])
    Funcs.UpdateUnderline(UI["HomeTab"], true)
    Funcs.UpdateUnderline(UI["ExeTab"], false)
    Funcs.UpdateUnderline(UI["SearchTab"], false)
    Funcs.UpdateUnderline(UI["ScriptsTab"], false)
    Funcs.UpdateUnderline(UI["SettingsTab"], false)
end)

UI["ExeTab"].MouseButton1Click:Connect(function()
    Funcs.SwitchTab(UI["ExeTab"])
    Funcs.UpdateUnderline(UI["HomeTab"], false)
    Funcs.UpdateUnderline(UI["ExeTab"], true)
    Funcs.UpdateUnderline(UI["SearchTab"], false)
    Funcs.UpdateUnderline(UI["ScriptsTab"], false)
    Funcs.UpdateUnderline(UI["SettingsTab"], false)
end)

UI["SearchTab"].MouseButton1Click:Connect(function()
    Funcs.SwitchTab(UI["SearchTab"])
    Funcs.UpdateUnderline(UI["HomeTab"], false)
    Funcs.UpdateUnderline(UI["ExeTab"], false)
    Funcs.UpdateUnderline(UI["SearchTab"], true)
    Funcs.UpdateUnderline(UI["ScriptsTab"], false)
    Funcs.UpdateUnderline(UI["SettingsTab"], false)
end)

UI["ScriptsTab"].MouseButton1Click:Connect(function()
    Funcs.SwitchTab(UI["ScriptsTab"])
    Funcs.UpdateUnderline(UI["HomeTab"], false)
    Funcs.UpdateUnderline(UI["ExeTab"], false)
    Funcs.UpdateUnderline(UI["SearchTab"], false)
    Funcs.UpdateUnderline(UI["ScriptsTab"], true)
    Funcs.UpdateUnderline(UI["SettingsTab"], false)
end)

UI["SettingsTab"].MouseButton1Click:Connect(function()
    Funcs.SwitchTab(UI["SettingsTab"])
    Funcs.UpdateUnderline(UI["HomeTab"], false)
    Funcs.UpdateUnderline(UI["ExeTab"], false)
    Funcs.UpdateUnderline(UI["SearchTab"], false)
    Funcs.UpdateUnderline(UI["ScriptsTab"], false)
    Funcs.UpdateUnderline(UI["SettingsTab"], true)
end)

UI["Save"].MouseButton1Click:Connect(function()
    local scriptName = UI["NameBox"]["Text"]
    local scriptDesc = UI["DescBox"]["Text"]
    local scriptCode = UI["ScriptBox"]["Text"]
    if scriptName == "" then return end
    local scriptData = { Name = scriptName, Description = scriptDesc, Code = scriptCode }
    Funcs.SaveScript(scriptData)
    UI["NewScriptFrame"]["Visible"] = false
    UI["NameBox"]["Text"] = ""
    UI["DescBox"]["Text"] = ""
    UI["ScriptBox"]["Text"] = ""
    Funcs.RefreshSavedScripts(UI["SearchBox2"]["Text"])
end)

UI["Cancel"].MouseButton1Click:Connect(function()
    UI["NewScriptFrame"]["Visible"] = false
    UI["NameBox"]["Text"] = ""
    UI["DescBox"]["Text"] = ""
    UI["ScriptBox"]["Text"] = ""
end)

UI["NewScriptBtn"].MouseButton1Click:Connect(function()
    UI["NewScriptFrame"]["Visible"] = true
    UI["NameBox"]["Text"] = ""
    UI["DescBox"]["Text"] = ""
    UI["ScriptBox"]["Text"] = ""
end)

UI["SearchBox"]:GetPropertyChangedSignal("Text"):Connect(function()
    local query = UI["SearchBox"]["Text"]
    UI["PrevBtn"]["Visible"] = false
    UI["NextBtn"]["Visible"] = false
    if query ~= "" then
        Funcs.PerformSearch(query, 1)
    elseif Funcs.CurrentSource == "ScriptBlox" then
        Funcs.PerformSearch("", 1)
    else
        if UI["NoResultsLabel"] then UI["NoResultsLabel"]["Visible"] = false end
        Funcs.CurrentScripts = {}
        Funcs.RenderSearchResults()
    end
end)

UI["PrevBtn"].MouseButton1Click:Connect(function()
    if currentPage > 1 then
        Funcs.PerformSearch(currentQuery, currentPage - 1)
    end
end)

UI["NextBtn"].MouseButton1Click:Connect(function()
    if currentPage < totalPages then
        Funcs.PerformSearch(currentQuery, currentPage + 1)
    end
end)

UI["SourceBtn"].MouseButton1Click:Connect(function()
    Funcs.CycleSource()
end)

UI["FilterBtn"].MouseButton1Click:Connect(function()
    Funcs.CycleFilter()
end)

UI["SearchBox2"]:GetPropertyChangedSignal("Text"):Connect(function()
    Funcs.RefreshSavedScripts(UI["SearchBox2"]["Text"])
end)

UI["ExeBtn"].MouseButton1Click:Connect(function()
    local code = UI["InputBox"]["Text"]
    if code and code ~= "" then
        local success, err = loadstring(code)()
        if not success then warn("Execution error: ", err) end
    end
end)

UI["ClrBtn"].MouseButton1Click:Connect(function()
    UI["InputBox"]["Text"] = ""
end)

UI["CopyBtn"].MouseButton1Click:Connect(function()
    SetClipboard(UI["InputBox"]["Text"])
end)

UI["AnimsToggle"].MouseButton1Click:Connect(function()
    Settings.Animations = not Settings.Animations
    if UI["ToggleState"] then
        if Settings.Animations then
            TweenService:Create(UI["ToggleState"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            }):Play()
            local stroke = UI["ToggleState"]:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = Color3.fromRGB(0, 255, 0)
                }):Play()
            end
        else
            TweenService:Create(UI["ToggleState"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            }):Play()
            local stroke = UI["ToggleState"]:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = Color3.fromRGB(255, 0, 0)
                }):Play()
            end
        end
    end
    Funcs.SaveSettings()
end)

UI["ResetThemeBtn"].MouseButton1Click:Connect(function()
    Settings.BackgroundColor = Color3.fromRGB(0, 0, 0)
    Settings.SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10)
    Settings.AccentColor = Color3.fromRGB(0, 99, 255)
    Settings.SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
    Funcs.ApplyTheme()
    Funcs.SaveSettings()
end)

Funcs.SwitchTab(UI["HomeTab"])
Funcs.UpdateUnderline(UI["HomeTab"], true)

UI["Show"]["Visible"] = true
UI["MainFrame"]["Visible"] = false

coroutine.wrap(function()
    while UI["ScreenGui"] and UI["ScreenGui"]["Parent"] do
        Funcs.UpdateStats()
        Wait(1)
    end
end)()

Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        Funcs.ClearCache()
    end
end)