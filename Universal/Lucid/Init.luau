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

Shared.Lucid = Shared.Lucid or {}

local WriteFile = expect("function", writefile, function() return end)
local ReadFile = expect("function", readfile, function() return end)
local DelFile = expect("function", delfile, function() return end)
local IsFile = expect("function", isfile, function() return end)
local IsFolder = expect("function", isfolder, function() return end)
local MakeFolder = expect("function", makefolder, function() return end)
local ListFiles = expect("function", listfiles, function() return end)
local LoadAsset = expect("function", getcustomasset, expect("function", getsynasset, function() return end))
local SetClipboard = expect("function", setclipboard, function() return end)

local GothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local GothamMedium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local BuilderSans = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local Inconsolata = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local Assets = {
    ["Lucid/Assets/lucid_logo.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/logo.png",
    ["Lucid/Assets/lucid_executor.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/executor.png",
    ["Lucid/Assets/lucid_search.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/search.png",
    ["Lucid/Assets/lucid_scripts.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/scripts.png",
    ["Lucid/Assets/lucid_close.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/Lucid/Assets/close.png",
}

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
			if Obj:IsA("ScreenGui") and not Safe[Obj.Name] and IsSus(Obj.Name) then
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

HideExec()

local function HttpGet(url)
    local RequestFunc = expect("function", syn and syn.request,
        expect("function", request,
            expect("function", http_request, function() return end)))
    if not RequestFunc then return nil end
    local success, result = pcall(function()
        return RequestFunc({ Url = url, Method = "GET" })
    end)
    return success and result or nil
end

local function GetImage(url)
    if not LoadAsset or not url or url == "" then
        return nil
    end

    if not url:match("^https?://") then
        url = "https://scriptblox.com" .. (url:sub(1, 1) ~= "/" and "/" or "") .. url
    end

    if not IsFolder("Lucid") then
        MakeFolder("Lucid")
    end

    if not IsFolder("Lucid/Cache") then
        MakeFolder("Lucid/Cache")
    end

    local safeName = url:gsub("[^%w]", "_")
    local cachePath = "Lucid/Cache/" .. safeName .. ".png"

    if IsFile(cachePath) then
        return LoadAsset(cachePath)
    end

    local response = HttpGet(url)
    if not response or not response.Body then
        return nil
    end

    local success, err = pcall(function()
        WriteFile(cachePath, response.Body)
    end)

    if not success then
        return nil
    end

    return LoadAsset(cachePath)
end

local function GetAsset(Path)
    if not LoadAsset then return nil end
    local Asset = Assets[Path]
    if not Asset then return nil end
    if not IsFolder("Lucid") then MakeFolder("Lucid") end
    if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
    if Asset:match("^rbxassetid://") then return Asset end
    if not IsFile(Path) then
        local Success, Response = pcall(function() return HttpGet(Asset) end)
        if not Success or not Response or not Response.Success or not Response.Body then return nil end
        WriteFile(Path, Response.Body)
    end
    return LoadAsset(Path)
end

local function NewCorner(cornerValue, name, parent)
    cornerValue = (cornerValue and cornerValue ~= "") and cornerValue or "0,6"
    local c = Instance.new("UICorner")
    c.Name = name or "UICorner"
    local parts = {}
    for part in cornerValue:gmatch("[^,]+") do
        table.insert(parts, tonumber(part) or 0)
    end
    if #parts == 2 then
        c.CornerRadius = UDim.new(parts[1], parts[2])
    end
    c.Parent = parent
    return c
end

local function SanitizeName(name)
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

local function ClearCache()
    if IsFolder("Lucid/Cache") then
        local files = ListFiles("Lucid/Cache")
        for _, file in ipairs(files) do
            pcall(function()
                DelFile(file)
            end)
        end
    end
end

if Shared.Lucid.isLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "Lucid Executor",
        Text = "Lucid is already running!",
        Icon = GetAsset("Lucid/Assets/lucid_logo.png"),
        Duration = 4
    })
    return
end

Shared.Lucid.isLoaded = true

local Lucid = Instance.new("ScreenGui")
Lucid.IgnoreGuiInset = true
Lucid.Name = "Lucid"
Lucid.ResetOnSpawn = false
Lucid.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Lucid.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Lucid.Parent = CoreGui

local function LoadSavedScripts()
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

local function SaveScript(scriptData)
    if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts") end
    local fileName = "Lucid/Scripts/" .. scriptData.Name:gsub("[^%w]", "_") .. ".json"
    WriteFile(fileName, HttpService:JSONEncode(scriptData))
end

local function DeleteScript(scriptName)
    local fileName = "Lucid/Scripts/" .. scriptName:gsub("[^%w]", "_") .. ".json"
    if IsFile(fileName) then
        DelFile(fileName)
    end
end

local NewScriptFrame = Instance.new("Frame")
NewScriptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
NewScriptFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NewScriptFrame.BackgroundTransparency = 0.1
NewScriptFrame.BorderSizePixel = 0
NewScriptFrame.Name = "NewScriptFrame"
NewScriptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
NewScriptFrame.Size = UDim2.new(0, 408, 0, 214)
NewScriptFrame.Visible = false
NewScriptFrame.ZIndex = 2
NewScriptFrame.Parent = Lucid

local NewScriptFramePadding = Instance.new("UIPadding")
NewScriptFramePadding.Name = "NewScriptFramePadding"
NewScriptFramePadding.PaddingBottom = UDim.new(0, 6)
NewScriptFramePadding.PaddingLeft = UDim.new(0, 6)
NewScriptFramePadding.PaddingRight = UDim.new(0, 6)
NewScriptFramePadding.PaddingTop = UDim.new(0, 6)
NewScriptFramePadding.Parent = NewScriptFrame

local NewScriptFrameStroke = Instance.new("UIStroke")
NewScriptFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NewScriptFrameStroke.Color = Color3.fromRGB(255, 255, 255)
NewScriptFrameStroke.Name = "NewScriptFrameStroke"
NewScriptFrameStroke.Transparency = 0.8
NewScriptFrameStroke.Parent = NewScriptFrame

NewCorner("", "NewScriptFrameCorner", NewScriptFrame)

local NewScriptFrameLayout = Instance.new("UIListLayout")
NewScriptFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
NewScriptFrameLayout.Name = "NewScriptFrameLayout"
NewScriptFrameLayout.Padding = UDim.new(0, 8)
NewScriptFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
NewScriptFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
NewScriptFrameLayout.Parent = NewScriptFrame

local NameBox = Instance.new("TextBox")
NameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox.BackgroundTransparency = 1
NameBox.BorderSizePixel = 0
NameBox.FontFace = GothamMedium
NameBox.LayoutOrder = 1
NameBox.Name = "NameBox"
NameBox.PlaceholderText = "Enter script name..."
NameBox.Size = UDim2.new(0, 76, 0, 30)
NameBox.Text = ""
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.TextScaled = true
NameBox.TextWrapped = true
NameBox.TextXAlignment = Enum.TextXAlignment.Left
NameBox.Parent = NewScriptFrame

local NameBoxPadding = Instance.new("UIPadding")
NameBoxPadding.Name = "NameBoxPadding"
NameBoxPadding.PaddingBottom = UDim.new(0, 4)
NameBoxPadding.PaddingLeft = UDim.new(0, 4)
NameBoxPadding.PaddingRight = UDim.new(0, 4)
NameBoxPadding.PaddingTop = UDim.new(0, 4)
NameBoxPadding.Parent = NameBox

local NameBoxStroke = Instance.new("UIStroke")
NameBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NameBoxStroke.Color = Color3.fromRGB(255, 255, 255)
NameBoxStroke.Name = "NameBoxStroke"
NameBoxStroke.Transparency = 0.8
NameBoxStroke.Parent = NameBox

NewCorner("", "NameBoxCorner", NameBox)

local DescBox = Instance.new("TextBox")
DescBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DescBox.BackgroundTransparency = 1
DescBox.BorderSizePixel = 0
DescBox.FontFace = GothamMedium
DescBox.LayoutOrder = 2
DescBox.Name = "DescBox"
DescBox.PlaceholderText = "Enter script description..."
DescBox.Size = UDim2.new(0, 76, 0, 30)
DescBox.Text = ""
DescBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DescBox.TextScaled = true
DescBox.TextWrapped = true
DescBox.TextXAlignment = Enum.TextXAlignment.Left
DescBox.Parent = NewScriptFrame

local DescBoxPadding = Instance.new("UIPadding")
DescBoxPadding.Name = "DescBoxPadding"
DescBoxPadding.PaddingBottom = UDim.new(0, 4)
DescBoxPadding.PaddingLeft = UDim.new(0, 4)
DescBoxPadding.PaddingRight = UDim.new(0, 4)
DescBoxPadding.PaddingTop = UDim.new(0, 4)
DescBoxPadding.Parent = DescBox

local DescBoxStroke = Instance.new("UIStroke")
DescBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DescBoxStroke.Color = Color3.fromRGB(255, 255, 255)
DescBoxStroke.Name = "DescBoxStroke"
DescBoxStroke.Transparency = 0.8
DescBoxStroke.Parent = DescBox

NewCorner("", "DescBoxCorner", DescBox)

local ScriptBox = Instance.new("TextBox")
ScriptBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.BackgroundTransparency = 1
ScriptBox.BorderSizePixel = 0
ScriptBox.FontFace = Inconsolata
ScriptBox.LayoutOrder = 3
ScriptBox.Name = "ScriptBox"
ScriptBox.PlaceholderText = "Enter script code..."
ScriptBox.Size = UDim2.new(0, 76, 0, 80)
ScriptBox.Text = ""
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.TextSize = 20
ScriptBox.TextWrapped = true
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.Parent = NewScriptFrame

local ScriptBoxPadding = Instance.new("UIPadding")
ScriptBoxPadding.Name = "ScriptBoxPadding"
ScriptBoxPadding.PaddingBottom = UDim.new(0, 4)
ScriptBoxPadding.PaddingLeft = UDim.new(0, 4)
ScriptBoxPadding.PaddingRight = UDim.new(0, 4)
ScriptBoxPadding.PaddingTop = UDim.new(0, 4)
ScriptBoxPadding.Parent = ScriptBox

local ScriptBoxStroke = Instance.new("UIStroke")
ScriptBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScriptBoxStroke.Color = Color3.fromRGB(255, 255, 255)
ScriptBoxStroke.Name = "ScriptBoxStroke"
ScriptBoxStroke.Transparency = 0.8
ScriptBoxStroke.Parent = ScriptBox

NewCorner("", "ScriptBoxCorner", ScriptBox)

local Options = Instance.new("Frame")
Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Options.BackgroundTransparency = 1
Options.BorderSizePixel = 0
Options.LayoutOrder = 4
Options.Name = "Options"
Options.Position = UDim2.new(0, 50, 0, -8)
Options.Size = UDim2.new(0, 76, 0, 34)
Options.Parent = NewScriptFrame

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.FillDirection = Enum.FillDirection.Horizontal
OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
OptionsLayout.Name = "OptionsLayout"
OptionsLayout.Padding = UDim.new(0, 8)
OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
OptionsLayout.Parent = Options

NewCorner("", "OptionsCorner", Options)

local Save = Instance.new("TextButton")
Save.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Save.BackgroundTransparency = 1
Save.BorderSizePixel = 0
Save.FontFace = GothamMedium
Save.LayoutOrder = 1
Save.Name = "Save"
Save.Size = UDim2.new(0.2, 0, 0.3, 0)
Save.Text = "Save"
Save.TextColor3 = Color3.fromRGB(255, 255, 255)
Save.TextScaled = true
Save.TextWrapped = true
Save.Parent = Options

local SaveStroke = Instance.new("UIStroke")
SaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SaveStroke.Color = Color3.fromRGB(255, 255, 255)
SaveStroke.Name = "SaveStroke"
SaveStroke.Transparency = 0.8
SaveStroke.Parent = Save

NewCorner("", "SaveCorner", Save)

local Cancel = Instance.new("TextButton")
Cancel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cancel.BackgroundTransparency = 1
Cancel.BorderSizePixel = 0
Cancel.FontFace = GothamMedium
Cancel.LayoutOrder = 2
Cancel.Name = "Cancel"
Cancel.Size = UDim2.new(0.2, 0, 0.3, 0)
Cancel.Text = "Cancel"
Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
Cancel.TextScaled = true
Cancel.TextWrapped = true
Cancel.Parent = Options

local CancelStroke = Instance.new("UIStroke")
CancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CancelStroke.Color = Color3.fromRGB(255, 255, 255)
CancelStroke.Name = "CancelStroke"
CancelStroke.Transparency = 0.8
CancelStroke.Parent = Cancel

NewCorner("", "CancelCorner", Cancel)

local MainFrame = Instance.new("Frame")
MainFrame.AutoLocalize = false
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.Visible = false
MainFrame.ZIndex = 1
MainFrame.Parent = Lucid

local MainFrameLayout = Instance.new("UIListLayout")
MainFrameLayout.FillDirection = Enum.FillDirection.Horizontal
MainFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.Name = "MainFrameLayout"
MainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.Parent = MainFrame

local Pages = Instance.new("Frame")
Pages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pages.BackgroundTransparency = 1
Pages.BorderSizePixel = 0
Pages.LayoutOrder = 1
Pages.Name = "Pages"
Pages.Position = UDim2.new(0, 18, 0, 62)
Pages.Size = UDim2.new(0, 576, 0, 116)
Pages.Parent = MainFrame

local PagesPadding = Instance.new("UIPadding")
PagesPadding.Name = "PagesPadding"
PagesPadding.PaddingBottom = UDim.new(0, 8)
PagesPadding.PaddingLeft = UDim.new(0, 8)
PagesPadding.PaddingTop = UDim.new(0, 60)
PagesPadding.Parent = Pages

local ExeContent = Instance.new("CanvasGroup")
ExeContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExeContent.BackgroundTransparency = 0.3
ExeContent.BorderSizePixel = 0
ExeContent.LayoutOrder = 1
ExeContent.Name = "ExeContent"
ExeContent.Size = UDim2.new(1, 0, 1, 0)
ExeContent.Parent = Pages

NewCorner("", "ExeContentCorner", ExeContent)

local ExeContentLayout = Instance.new("UIListLayout")
ExeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeContentLayout.Name = "ExeContentLayout"
ExeContentLayout.Padding = UDim.new(0, 4)
ExeContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeContentLayout.Parent = ExeContent

local ExeContentStroke = Instance.new("UIStroke")
ExeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeContentStroke.Name = "ExeContentStroke"
ExeContentStroke.Transparency = 0.8
ExeContentStroke.Parent = ExeContent

local InputFrame = Instance.new("ScrollingFrame")
InputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InputFrame.BackgroundTransparency = 1
InputFrame.BorderSizePixel = 0
InputFrame.CanvasSize = UDim2.new(0,0,0,0)
InputFrame.LayoutOrder = 2
InputFrame.Name = "InputFrame"
InputFrame.Position = UDim2.new(0, 70, 0, -30)
InputFrame.ScrollBarThickness = 0
InputFrame.ScrollingDirection = Enum.ScrollingDirection.Y
InputFrame.Size = UDim2.new(0, 222, 0, 248)
InputFrame.Parent = ExeContent

local InputFramePadding = Instance.new("UIPadding")
InputFramePadding.Name = "InputFramePadding"
InputFramePadding.PaddingLeft = UDim.new(0, 6)
InputFramePadding.PaddingRight = UDim.new(0, 6)
InputFramePadding.PaddingTop = UDim.new(0, 6)
InputFramePadding.Parent = InputFrame

local InputFrameLayout = Instance.new("UIListLayout")
InputFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
InputFrameLayout.Name = "InputFrameLayout"
InputFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
InputFrameLayout.VerticalFlex = Enum.UIFlexAlignment.None
InputFrameLayout.Parent = InputFrame

local InputBox = Instance.new("TextBox")
InputBox.AutomaticSize = Enum.AutomaticSize.Y
InputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InputBox.BackgroundTransparency = 0.5
InputBox.BorderSizePixel = 0
InputBox.ClearTextOnFocus = false
InputBox.FontFace = Inconsolata
InputBox.MultiLine = true
InputBox.Name = "InputBox"
InputBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderText = "Enter code here..."
InputBox.Position = UDim2.new(0, -14, 0, -76)
InputBox.Size = UDim2.new(0, 250, 0, 266)
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 18
InputBox.TextWrapped = true
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.Parent = InputFrame

local InputBoxPadding = Instance.new("UIPadding")
InputBoxPadding.Name = "InputBoxPadding"
InputBoxPadding.PaddingBottom = UDim.new(0, 6)
InputBoxPadding.PaddingLeft = UDim.new(0, 6)
InputBoxPadding.PaddingRight = UDim.new(0, 6)
InputBoxPadding.PaddingTop = UDim.new(0, 6)
InputBoxPadding.Parent = InputBox

local InputBoxStroke = Instance.new("UIStroke")
InputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputBoxStroke.Color = Color3.fromRGB(255, 255, 255)
InputBoxStroke.Name = "InputBoxStroke"
InputBoxStroke.Transparency = 0.8
InputBoxStroke.Parent = InputBox

local InputBoxSizeCons = Instance.new("UISizeConstraint")
InputBoxSizeCons.MaxSize = Vector2.new(10000, 10000)
InputBoxSizeCons.MinSize = Vector2.new(0, 200)
InputBoxSizeCons.Name = "InputBoxSizeCons"
InputBoxSizeCons.Parent = InputBox

NewCorner("", "InputBoxCorner", InputBox)

local Buttons = Instance.new("Frame")
Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Buttons.BackgroundTransparency = 1
Buttons.BorderSizePixel = 0
Buttons.LayoutOrder = 3
Buttons.Name = "Buttons"
Buttons.Position = UDim2.new(0, 28, 0, 20)
Buttons.Size = UDim2.new(0, 116, 0, 38)
Buttons.Parent = ExeContent

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ButtonsLayout.Name = "ButtonsLayout"
ButtonsLayout.Padding = UDim.new(0, 6)
ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ButtonsLayout.Parent = Buttons

local ButtonsSizeCons = Instance.new("UISizeConstraint")
ButtonsSizeCons.MaxSize = Vector2.new(10000, 38)
ButtonsSizeCons.Name = "ButtonsSizeCons"
ButtonsSizeCons.Parent = Buttons

local ButtonsPadding = Instance.new("UIPadding")
ButtonsPadding.Name = "ButtonsPadding"
ButtonsPadding.PaddingBottom = UDim.new(0, 5)
ButtonsPadding.PaddingLeft = UDim.new(0, 5)
ButtonsPadding.PaddingRight = UDim.new(0, 5)
ButtonsPadding.Parent = Buttons

local ExeBtn = Instance.new("TextButton")
ExeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExeBtn.BackgroundTransparency = 0.5
ExeBtn.BorderSizePixel = 0
ExeBtn.FontFace = BuilderSans
ExeBtn.LayoutOrder = 1
ExeBtn.Name = "ExeBtn"
ExeBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
ExeBtn.Text = "Execute"
ExeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExeBtn.TextScaled = true
ExeBtn.TextWrapped = true
ExeBtn.Parent = Buttons

NewCorner("", "ExeBtnCorner", ExeBtn)

local ExeBtnStroke = Instance.new("UIStroke")
ExeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeBtnStroke.Color = Color3.fromRGB(255, 255, 255)
ExeBtnStroke.Name = "ExeBtnStroke"
ExeBtnStroke.Transparency = 0.8
ExeBtnStroke.Parent = ExeBtn

local ExeBtnPadding = Instance.new("UIPadding")
ExeBtnPadding.Name = "ExeBtnPadding"
ExeBtnPadding.PaddingBottom = UDim.new(0, 4)
ExeBtnPadding.PaddingLeft = UDim.new(0, 4)
ExeBtnPadding.PaddingRight = UDim.new(0, 4)
ExeBtnPadding.PaddingTop = UDim.new(0, 4)
ExeBtnPadding.Parent = ExeBtn

local ClrBtn = Instance.new("TextButton")
ClrBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ClrBtn.BackgroundTransparency = 0.5
ClrBtn.BorderSizePixel = 0
ClrBtn.FontFace = BuilderSans
ClrBtn.LayoutOrder = 2
ClrBtn.Name = "ClrBtn"
ClrBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
ClrBtn.Text = "Clear"
ClrBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClrBtn.TextScaled = true
ClrBtn.TextWrapped = true
ClrBtn.Parent = Buttons

NewCorner("", "ClrBtnCorner", ClrBtn)

local ClrBtnStroke = Instance.new("UIStroke")
ClrBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ClrBtnStroke.Color = Color3.fromRGB(255, 255, 255)
ClrBtnStroke.Name = "ClrBtnStroke"
ClrBtnStroke.Transparency = 0.8
ClrBtnStroke.Parent = ClrBtn

local ClrBtnPadding = Instance.new("UIPadding")
ClrBtnPadding.Name = "ClrBtnPadding"
ClrBtnPadding.PaddingBottom = UDim.new(0, 4)
ClrBtnPadding.PaddingLeft = UDim.new(0, 4)
ClrBtnPadding.PaddingRight = UDim.new(0, 4)
ClrBtnPadding.PaddingTop = UDim.new(0, 4)
ClrBtnPadding.Parent = ClrBtn

local CopyBtn = Instance.new("TextButton")
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CopyBtn.BackgroundTransparency = 0.5
CopyBtn.BorderSizePixel = 0
CopyBtn.FontFace = BuilderSans
CopyBtn.LayoutOrder = 3
CopyBtn.Name = "CopyBtn"
CopyBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
CopyBtn.Text = "Copy Code"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextScaled = true
CopyBtn.TextWrapped = true
CopyBtn.Parent = Buttons

NewCorner("", "CopyBtnCorner", CopyBtn)

local CopyBtnStroke = Instance.new("UIStroke")
CopyBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CopyBtnStroke.Color = Color3.fromRGB(255, 255, 255)
CopyBtnStroke.Name = "CopyBtnStroke"
CopyBtnStroke.Transparency = 0.8
CopyBtnStroke.Parent = CopyBtn

local CopyBtnPadding = Instance.new("UIPadding")
CopyBtnPadding.Name = "CopyBtnPadding"
CopyBtnPadding.PaddingBottom = UDim.new(0, 4)
CopyBtnPadding.PaddingLeft = UDim.new(0, 4)
CopyBtnPadding.PaddingRight = UDim.new(0, 4)
CopyBtnPadding.PaddingTop = UDim.new(0, 4)
CopyBtnPadding.Parent = CopyBtn

local SearchContent = Instance.new("CanvasGroup")
SearchContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchContent.BackgroundTransparency = 0.3
SearchContent.BorderSizePixel = 0
SearchContent.LayoutOrder = 2
SearchContent.Name = "SearchContent"
SearchContent.Size = UDim2.new(1, 0, 1, 0)
SearchContent.Visible = false
SearchContent.Parent = Pages

local SearchContentPadding = Instance.new("UIPadding")
SearchContentPadding.Name = "SearchContentPadding"
SearchContentPadding.PaddingBottom = UDim.new(0, 6)
SearchContentPadding.PaddingLeft = UDim.new(0, 6)
SearchContentPadding.PaddingRight = UDim.new(0, 6)
SearchContentPadding.PaddingTop = UDim.new(0, 6)
SearchContentPadding.Parent = SearchContent

local SearchContentLayout = Instance.new("UIListLayout")
SearchContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchContentLayout.Name = "SearchContentLayout"
SearchContentLayout.Padding = UDim.new(0, 6)
SearchContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SearchContentLayout.Parent = SearchContent

NewCorner("", "SearchContentCorner", SearchContent)

local SearchBox = Instance.new("TextBox")
SearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchBox.BackgroundTransparency = 0.5
SearchBox.BorderSizePixel = 0
SearchBox.FontFace = GothamMedium
SearchBox.LayoutOrder = 1
SearchBox.Name = "SearchBox"
SearchBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Search scripts..."
SearchBox.Position = UDim2.new(0, 90, 0, 52)
SearchBox.Size = UDim2.new(0, 250, 0, 18)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextScaled = true
SearchBox.TextSize = 12
SearchBox.TextWrapped = true
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.TextYAlignment = Enum.TextYAlignment.Top
SearchBox.Parent = SearchContent

local SearchBoxPadding = Instance.new("UIPadding")
SearchBoxPadding.Name = "SearchBoxPadding"
SearchBoxPadding.PaddingBottom = UDim.new(0, 6)
SearchBoxPadding.PaddingLeft = UDim.new(0, 6)
SearchBoxPadding.PaddingRight = UDim.new(0, 6)
SearchBoxPadding.PaddingTop = UDim.new(0, 6)
SearchBoxPadding.Parent = SearchBox

local SearchBoxStroke = Instance.new("UIStroke")
SearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
SearchBoxStroke.Name = "SearchBoxStroke"
SearchBoxStroke.Transparency = 0.8
SearchBoxStroke.Parent = SearchBox

local WebsiteLabel = Instance.new("TextLabel")
WebsiteLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WebsiteLabel.BackgroundTransparency = 1
WebsiteLabel.BorderSizePixel = 0
WebsiteLabel.FontFace = GothamMedium
WebsiteLabel.Name = "WebsiteLabel"
WebsiteLabel.Size = UDim2.new(1, 0, 1, 0)
WebsiteLabel.Text = "Powered by ScriptBlox.com"
WebsiteLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WebsiteLabel.TextScaled = true
WebsiteLabel.TextTransparency = 0.5
WebsiteLabel.TextWrapped = true
WebsiteLabel.TextXAlignment = Enum.TextXAlignment.Right
WebsiteLabel.Parent = SearchBox

NewCorner("", "SearchBoxCorner", SearchBox)

local SearchBoxSizeCons = Instance.new("UISizeConstraint")
SearchBoxSizeCons.MaxSize = Vector2.new(10000, 30)
SearchBoxSizeCons.MinSize = Vector2.new(0, 30)
SearchBoxSizeCons.Name = "SearchBoxSizeCons"
SearchBoxSizeCons.Parent = SearchBox

local SearchResults = Instance.new("ScrollingFrame")
SearchResults.AutomaticCanvasSize = Enum.AutomaticSize.Y
SearchResults.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchResults.BackgroundTransparency = 1
SearchResults.BorderSizePixel = 0
SearchResults.LayoutOrder = 2
SearchResults.Name = "SearchResults"
SearchResults.ScrollBarThickness = 0
SearchResults.ScrollingDirection = Enum.ScrollingDirection.Y
SearchResults.Size = UDim2.new(1, 0, 1, 0)
SearchResults.Parent = SearchContent

local SearchResultsPadding = Instance.new("UIPadding")
SearchResultsPadding.Name = "SearchResultsPadding"
SearchResultsPadding.PaddingBottom = UDim.new(0, 2)
SearchResultsPadding.PaddingLeft = UDim.new(0, 2)
SearchResultsPadding.PaddingRight = UDim.new(0, 2)
SearchResultsPadding.PaddingTop = UDim.new(0, 2)
SearchResultsPadding.Parent = SearchResults

local SearchResultsListLayout = Instance.new("UIListLayout")
SearchResultsListLayout.FillDirection = Enum.FillDirection.Vertical
SearchResultsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SearchResultsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchResultsListLayout.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
SearchResultsListLayout.Name = "SearchResultsListLayout"
SearchResultsListLayout.Padding = UDim.new(0, 8)
SearchResultsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchResultsListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SearchResultsListLayout.VerticalFlex = Enum.UIFlexAlignment.None
SearchResultsListLayout.Wraps = false
SearchResultsListLayout.Parent = SearchResults

local SearchResultTemplate = Instance.new("CanvasGroup")
SearchResultTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchResultTemplate.BackgroundTransparency = 0.5
SearchResultTemplate.BorderSizePixel = 0
SearchResultTemplate.Name = "SearchResultTemplate"
SearchResultTemplate.Size = UDim2.new(0, 358, 0, 132)
SearchResultTemplate.Visible = false
SearchResultTemplate.Parent = SearchResults

NewCorner("", "SearchResultTemplateCorner", SearchResultTemplate)

local SearchResultTemplateStroke = Instance.new("UIStroke")
SearchResultTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchResultTemplateStroke.Color = Color3.fromRGB(255, 255, 255)
SearchResultTemplateStroke.Name = "SearchResultTemplateStroke"
SearchResultTemplateStroke.Transparency = 0.8
SearchResultTemplateStroke.Parent = SearchResultTemplate

local ScriptImage = Instance.new("ImageLabel")
ScriptImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptImage.BackgroundTransparency = 1
ScriptImage.BorderSizePixel = 0
ScriptImage.Image = ""
ScriptImage.LayoutOrder = 1
ScriptImage.Name = "ScriptImage"
ScriptImage.ScaleType = Enum.ScaleType.Crop
ScriptImage.Size = UDim2.new(1, 0, 0.7, -2)
ScriptImage.Parent = SearchResultTemplate

local Container = Instance.new("Frame")
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.LayoutOrder = 2
Container.Name = "Container"
Container.Size = UDim2.new(1, 0, 1, 0)
Container.Parent = SearchResultTemplate

local ScriptName = Instance.new("TextLabel")
ScriptName.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScriptName.BackgroundTransparency = 1
ScriptName.BorderSizePixel = 0
ScriptName.FontFace = GothamMedium
ScriptName.Name = "ScriptName"
ScriptName.Position = UDim2.new(0, 4, 0, 0)
ScriptName.Size = UDim2.new(0, 350, 0, 30)
ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptName.TextScaled = true
ScriptName.TextWrapped = true
ScriptName.TextXAlignment = Enum.TextXAlignment.Left
ScriptName.Parent = Container

NewCorner("", "ScriptNameCorner", ScriptName)

local ScriptNameStroke = Instance.new("UIStroke")
ScriptNameStroke.Name = "ScriptNameStroke"
ScriptNameStroke.Transparency = 0.5
ScriptNameStroke.Parent = ScriptName

local ScriptActions = Instance.new("Frame")
ScriptActions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptActions.BackgroundTransparency = 1
ScriptActions.BorderSizePixel = 0
ScriptActions.Name = "ScriptActions"
ScriptActions.Position = UDim2.new(0, 0, 0, 92)
ScriptActions.Size = UDim2.new(1, 0, 0.3, 0)
ScriptActions.Parent = Container

local ScriptActionsLayout = Instance.new("UIListLayout")
ScriptActionsLayout.FillDirection = Enum.FillDirection.Horizontal
ScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ScriptActionsLayout.Name = "ScriptActionsLayout"
ScriptActionsLayout.Padding = UDim.new(0, 6)
ScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ScriptActionsLayout.Parent = ScriptActions

local ScriptActionsPadding = Instance.new("UIPadding")
ScriptActionsPadding.Name = "ScriptActionsPadding"
ScriptActionsPadding.PaddingBottom = UDim.new(0, 6)
ScriptActionsPadding.PaddingLeft = UDim.new(0, 6)
ScriptActionsPadding.PaddingRight = UDim.new(0, 6)
ScriptActionsPadding.PaddingTop = UDim.new(0, 4)
ScriptActionsPadding.Parent = ScriptActions

local RunScript = Instance.new("TextButton")
RunScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RunScript.BackgroundTransparency = 0.5
RunScript.BorderSizePixel = 0
RunScript.FontFace = GothamMedium
RunScript.LayoutOrder = 1
RunScript.Name = "RunScript"
RunScript.Size = UDim2.new(0.2, 0, 0.3, 0)
RunScript.Text = "Run"
RunScript.TextColor3 = Color3.fromRGB(255, 255, 255)
RunScript.TextScaled = true
RunScript.TextWrapped = true
RunScript.Parent = ScriptActions

local RunScriptStroke = Instance.new("UIStroke")
RunScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RunScriptStroke.Color = Color3.fromRGB(255, 255, 255)
RunScriptStroke.Name = "RunScriptStroke"
RunScriptStroke.Transparency = 0.8
RunScriptStroke.Parent = RunScript

NewCorner("", "RunScriptCorner", RunScript)

local RunScriptPadding = Instance.new("UIPadding")
RunScriptPadding.Name = "RunScriptPadding"
RunScriptPadding.PaddingBottom = UDim.new(0, 2)
RunScriptPadding.PaddingLeft = UDim.new(0, 2)
RunScriptPadding.PaddingRight = UDim.new(0, 2)
RunScriptPadding.PaddingTop = UDim.new(0, 2)
RunScriptPadding.Parent = RunScript

local CopyScriptBtn = Instance.new("TextButton")
CopyScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CopyScriptBtn.BackgroundTransparency = 0.5
CopyScriptBtn.BorderSizePixel = 0
CopyScriptBtn.FontFace = GothamMedium
CopyScriptBtn.LayoutOrder = 2
CopyScriptBtn.Name = "CopyScriptBtn"
CopyScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
CopyScriptBtn.Text = "Copy"
CopyScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyScriptBtn.TextScaled = true
CopyScriptBtn.TextWrapped = true
CopyScriptBtn.Parent = ScriptActions

local CopyScriptBtnStroke = Instance.new("UIStroke")
CopyScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CopyScriptBtnStroke.Color = Color3.fromRGB(255, 255, 255)
CopyScriptBtnStroke.Name = "CopyScriptBtnStroke"
CopyScriptBtnStroke.Transparency = 0.8
CopyScriptBtnStroke.Parent = CopyScriptBtn

NewCorner("", "CopyScriptBtnCorner", CopyScriptBtn)

local CopyScriptBtnPadding = Instance.new("UIPadding")
CopyScriptBtnPadding.Name = "CopyScriptBtnPadding"
CopyScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
CopyScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
CopyScriptBtnPadding.PaddingRight = UDim.new(0, 2)
CopyScriptBtnPadding.PaddingTop = UDim.new(0, 2)
CopyScriptBtnPadding.Parent = CopyScriptBtn

local SaveScriptBtn = Instance.new("TextButton")
SaveScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SaveScriptBtn.BackgroundTransparency = 0.5
SaveScriptBtn.BorderSizePixel = 0
SaveScriptBtn.FontFace = GothamMedium
SaveScriptBtn.LayoutOrder = 3
SaveScriptBtn.Name = "SaveScriptBtn"
SaveScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
SaveScriptBtn.Text = "Save"
SaveScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveScriptBtn.TextScaled = true
SaveScriptBtn.TextWrapped = true
SaveScriptBtn.Parent = ScriptActions

local SaveScriptBtnStroke = Instance.new("UIStroke")
SaveScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SaveScriptBtnStroke.Color = Color3.fromRGB(255, 255, 255)
SaveScriptBtnStroke.Name = "SaveScriptBtnStroke"
SaveScriptBtnStroke.Transparency = 0.8
SaveScriptBtnStroke.Parent = SaveScriptBtn

NewCorner("", "SaveScriptBtnCorner", SaveScriptBtn)

local SaveScriptBtnPadding = Instance.new("UIPadding")
SaveScriptBtnPadding.Name = "SaveScriptBtnPadding"
SaveScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
SaveScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
SaveScriptBtnPadding.PaddingRight = UDim.new(0, 2)
SaveScriptBtnPadding.PaddingTop = UDim.new(0, 2)
SaveScriptBtnPadding.Parent = SaveScriptBtn

local NoResultsLabel = Instance.new("TextLabel")
NoResultsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoResultsLabel.BackgroundTransparency = 1
NoResultsLabel.BorderSizePixel = 0
NoResultsLabel.FontFace = GothamMedium
NoResultsLabel.Name = "NoResultsLabel"
NoResultsLabel.Size = UDim2.new(1, 0, 0, 30)
NoResultsLabel.Text = "No scripts found matching your query."
NoResultsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoResultsLabel.TextScaled = true
NoResultsLabel.TextWrapped = true
NoResultsLabel.TextXAlignment = Enum.TextXAlignment.Center
NoResultsLabel.Visible = false
NoResultsLabel.Parent = SearchResults

local SavedScriptsContent = Instance.new("CanvasGroup")
SavedScriptsContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsContent.BackgroundTransparency = 0.3
SavedScriptsContent.BorderSizePixel = 0
SavedScriptsContent.LayoutOrder = 3
SavedScriptsContent.Name = "SavedScriptsContent"
SavedScriptsContent.Size = UDim2.new(1, 0, 1, 0)
SavedScriptsContent.Visible = false
SavedScriptsContent.Parent = Pages

local SavedScriptsPadding = Instance.new("UIPadding")
SavedScriptsPadding.Name = "SavedScriptsPadding"
SavedScriptsPadding.PaddingBottom = UDim.new(0, 6)
SavedScriptsPadding.PaddingLeft = UDim.new(0, 6)
SavedScriptsPadding.PaddingRight = UDim.new(0, 6)
SavedScriptsPadding.PaddingTop = UDim.new(0, 6)
SavedScriptsPadding.Parent = SavedScriptsContent

local SavedScriptsLayout = Instance.new("UIListLayout")
SavedScriptsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsLayout.Name = "SavedScriptsLayout"
SavedScriptsLayout.Padding = UDim.new(0, 6)
SavedScriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsLayout.Parent = SavedScriptsContent

NewCorner("", "SavedScriptsContentCorner", SavedScriptsContent)

local SavedScriptsStroke = Instance.new("UIStroke")
SavedScriptsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptsStroke.Name = "SavedScriptsStroke"
SavedScriptsStroke.Transparency = 0.8
SavedScriptsStroke.Parent = SavedScriptsContent

local SavedScriptsSearchBox = Instance.new("TextBox")
SavedScriptsSearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsSearchBox.BackgroundTransparency = 0.5
SavedScriptsSearchBox.BorderSizePixel = 0
SavedScriptsSearchBox.FontFace = GothamMedium
SavedScriptsSearchBox.Name = "SavedScriptsSearchBox"
SavedScriptsSearchBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBox.PlaceholderText = "Search saved scripts..."
SavedScriptsSearchBox.Position = UDim2.new(0, 6, 0, 6)
SavedScriptsSearchBox.Size = UDim2.new(1, -42, 0, 24)
SavedScriptsSearchBox.Text = ""
SavedScriptsSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBox.TextScaled = true
SavedScriptsSearchBox.TextSize = 12
SavedScriptsSearchBox.TextWrapped = true
SavedScriptsSearchBox.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptsSearchBox.TextYAlignment = Enum.TextYAlignment.Top
SavedScriptsSearchBox.ZIndex = 2
SavedScriptsSearchBox.Parent = SavedScriptsContent

local SavedScriptsSearchBoxPadding = Instance.new("UIPadding")
SavedScriptsSearchBoxPadding.Name = "SavedScriptsSearchBoxPadding"
SavedScriptsSearchBoxPadding.PaddingBottom = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.PaddingLeft = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.PaddingRight = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.PaddingTop = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.Parent = SavedScriptsSearchBox

local SavedScriptsSearchBoxStroke = Instance.new("UIStroke")
SavedScriptsSearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptsSearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBoxStroke.Name = "SavedScriptsSearchBoxStroke"
SavedScriptsSearchBoxStroke.Transparency = 0.8
SavedScriptsSearchBoxStroke.Parent = SavedScriptsSearchBox

NewCorner("", "SavedScriptsSearchBoxCorner", SavedScriptsSearchBox)

local SavedScriptsSearchBoxSizeCons = Instance.new("UISizeConstraint")
SavedScriptsSearchBoxSizeCons.MaxSize = Vector2.new(10000, 30)
SavedScriptsSearchBoxSizeCons.MinSize = Vector2.new(0, 30)
SavedScriptsSearchBoxSizeCons.Name = "SavedScriptsSearchBoxSizeCons"
SavedScriptsSearchBoxSizeCons.Parent = SavedScriptsSearchBox

local NewScriptBtn = Instance.new("TextButton")
NewScriptBtn.AnchorPoint = Vector2.new(1, 0.5)
NewScriptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewScriptBtn.BackgroundTransparency = 1
NewScriptBtn.BorderSizePixel = 0
NewScriptBtn.FontFace = GothamBold
NewScriptBtn.Name = "NewScriptBtn"
NewScriptBtn.Position = UDim2.new(1, 0, 0.5, 0)
NewScriptBtn.Size = UDim2.new(1, 0, 1, 0)
NewScriptBtn.Text = "+"
NewScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NewScriptBtn.TextScaled = true
NewScriptBtn.TextWrapped = true
NewScriptBtn.Parent = SavedScriptsSearchBox

Instance.new("UIAspectRatioConstraint", NewScriptBtn).Name = "NewScriptRatio"

local SavedScriptsScroll = Instance.new("ScrollingFrame")
SavedScriptsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SavedScriptsScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsScroll.BackgroundTransparency = 1
SavedScriptsScroll.BorderSizePixel = 0
SavedScriptsScroll.Name = "SavedScriptsScroll"
SavedScriptsScroll.Position = UDim2.new(0, 0, 0, 36)
SavedScriptsScroll.ScrollBarThickness = 0
SavedScriptsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
SavedScriptsScroll.Size = UDim2.new(1, 0, 1, -36)
SavedScriptsScroll.Parent = SavedScriptsContent

local SavedScriptsScrollPadding = Instance.new("UIPadding")
SavedScriptsScrollPadding.Name = "SavedScriptsScrollPadding"
SavedScriptsScrollPadding.PaddingBottom = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingLeft = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingRight = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingTop = UDim.new(0, 2)
SavedScriptsScrollPadding.Parent = SavedScriptsScroll

local SavedScriptsScrollListLayout = Instance.new("UIListLayout")
SavedScriptsScrollListLayout.FillDirection = Enum.FillDirection.Vertical
SavedScriptsScrollListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SavedScriptsScrollListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsScrollListLayout.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
SavedScriptsScrollListLayout.Name = "SavedScriptsScrollListLayout"
SavedScriptsScrollListLayout.Padding = UDim.new(0, 8)
SavedScriptsScrollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptsScrollListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SavedScriptsScrollListLayout.VerticalFlex = Enum.UIFlexAlignment.None
SavedScriptsScrollListLayout.Wraps = false
SavedScriptsScrollListLayout.Parent = SavedScriptsScroll

local SavedScriptTemplate = Instance.new("Frame")
SavedScriptTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptTemplate.BackgroundTransparency = 0.5
SavedScriptTemplate.BorderSizePixel = 0
SavedScriptTemplate.Name = "SavedScriptTemplate"
SavedScriptTemplate.Size = UDim2.new(0, 166, 0, 64)
SavedScriptTemplate.Visible = false
SavedScriptTemplate.Parent = SavedScriptsScroll

local SavedScriptTemplateLayout = Instance.new("UIListLayout")
SavedScriptTemplateLayout.FillDirection = Enum.FillDirection.Horizontal
SavedScriptTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptTemplateLayout.Name = "SavedScriptTemplateLayout"
SavedScriptTemplateLayout.Padding = UDim.new(0, 2)
SavedScriptTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptTemplateLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptTemplateLayout.Parent = SavedScriptTemplate

NewCorner("", "SavedScriptTemplateCorner", SavedScriptTemplate)

local SavedScriptTemplateStroke = Instance.new("UIStroke")
SavedScriptTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptTemplateStroke.Color = Color3.fromRGB(255, 255, 255)
SavedScriptTemplateStroke.Name = "SavedScriptTemplateStroke"
SavedScriptTemplateStroke.Transparency = 0.8
SavedScriptTemplateStroke.Parent = SavedScriptTemplate

local SavedScriptInfo = Instance.new("Frame")
SavedScriptInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptInfo.BackgroundTransparency = 1
SavedScriptInfo.BorderSizePixel = 0
SavedScriptInfo.LayoutOrder = 1
SavedScriptInfo.Name = "SavedScriptInfo"
SavedScriptInfo.Size = UDim2.new(0, 380, 0, 12)
SavedScriptInfo.Parent = SavedScriptTemplate

local SavedScriptInfoLayout = Instance.new("UIListLayout")
SavedScriptInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptInfoLayout.Name = "SavedScriptInfoLayout"
SavedScriptInfoLayout.Padding = UDim.new(0, 2)
SavedScriptInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptInfoLayout.Parent = SavedScriptInfo

local SavedScriptInfoPadding = Instance.new("UIPadding")
SavedScriptInfoPadding.Name = "SavedScriptInfoPadding"
SavedScriptInfoPadding.PaddingBottom = UDim.new(0, 4)
SavedScriptInfoPadding.PaddingLeft = UDim.new(0, 4)
SavedScriptInfoPadding.PaddingRight = UDim.new(0, 4)
SavedScriptInfoPadding.PaddingTop = UDim.new(0, 4)
SavedScriptInfoPadding.Parent = SavedScriptInfo

local SavedScriptTitle = Instance.new("TextLabel")
SavedScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptTitle.BackgroundTransparency = 1
SavedScriptTitle.BorderSizePixel = 0
SavedScriptTitle.FontFace = GothamBold
SavedScriptTitle.LayoutOrder = 1
SavedScriptTitle.Name = "SavedScriptTitle"
SavedScriptTitle.Size = UDim2.new(0.2, 0, 0.3, 0)
SavedScriptTitle.Text = "Script name"
SavedScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptTitle.TextScaled = true
SavedScriptTitle.TextWrapped = true
SavedScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptTitle.Parent = SavedScriptInfo

local SavedScriptTitlePadding = Instance.new("UIPadding")
SavedScriptTitlePadding.Name = "SavedScriptTitlePadding"
SavedScriptTitlePadding.PaddingBottom = UDim.new(0, 4)
SavedScriptTitlePadding.PaddingLeft = UDim.new(0, 4)
SavedScriptTitlePadding.PaddingRight = UDim.new(0, 4)
SavedScriptTitlePadding.PaddingTop = UDim.new(0, 4)
SavedScriptTitlePadding.Parent = SavedScriptTitle

local SavedScriptDesc = Instance.new("TextLabel")
SavedScriptDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptDesc.BackgroundTransparency = 1
SavedScriptDesc.BorderSizePixel = 0
SavedScriptDesc.FontFace = GothamMedium
SavedScriptDesc.LayoutOrder = 2
SavedScriptDesc.Name = "SavedScriptDesc"
SavedScriptDesc.Size = UDim2.new(0, 76, 0, 0)
SavedScriptDesc.Text = "Script description"
SavedScriptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptDesc.TextScaled = true
SavedScriptDesc.TextWrapped = true
SavedScriptDesc.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptDesc.Parent = SavedScriptInfo

local SavedScriptActions = Instance.new("Frame")
SavedScriptActions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptActions.BackgroundTransparency = 1
SavedScriptActions.BorderSizePixel = 0
SavedScriptActions.LayoutOrder = 2
SavedScriptActions.Name = "SavedScriptActions"
SavedScriptActions.Position = UDim2.new(0, 34, 0, 0)
SavedScriptActions.Size = UDim2.new(0, 0, 0, 12)
SavedScriptActions.Parent = SavedScriptTemplate

local SavedScriptActionsLayout = Instance.new("UIListLayout")
SavedScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptActionsLayout.Name = "SavedScriptActionsLayout"
SavedScriptActionsLayout.Padding = UDim.new(0, 6)
SavedScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptActionsLayout.Parent = SavedScriptActions

local SavedScriptActionsPadding = Instance.new("UIPadding")
SavedScriptActionsPadding.Name = "SavedScriptActionsPadding"
SavedScriptActionsPadding.PaddingBottom = UDim.new(0, 4)
SavedScriptActionsPadding.PaddingLeft = UDim.new(0, 4)
SavedScriptActionsPadding.PaddingRight = UDim.new(0, 4)
SavedScriptActionsPadding.PaddingTop = UDim.new(0, 4)
SavedScriptActionsPadding.Parent = SavedScriptActions

local RunSavedScript = Instance.new("TextButton")
RunSavedScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RunSavedScript.BackgroundTransparency = 0.5
RunSavedScript.BorderSizePixel = 0
RunSavedScript.FontFace = GothamMedium
RunSavedScript.LayoutOrder = 1
RunSavedScript.Name = "RunSavedScript"
RunSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
RunSavedScript.Text = "Run"
RunSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
RunSavedScript.TextScaled = true
RunSavedScript.TextWrapped = true
RunSavedScript.Parent = SavedScriptActions

local RunSavedScriptStroke = Instance.new("UIStroke")
RunSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RunSavedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
RunSavedScriptStroke.Name = "RunSavedScriptStroke"
RunSavedScriptStroke.Transparency = 0.8
RunSavedScriptStroke.Parent = RunSavedScript

NewCorner("", "RunSavedScriptCorner", RunSavedScript)

local RunSavedScriptPadding = Instance.new("UIPadding")
RunSavedScriptPadding.Name = "RunSavedScriptPadding"
RunSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
RunSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
RunSavedScriptPadding.PaddingRight = UDim.new(0, 2)
RunSavedScriptPadding.PaddingTop = UDim.new(0, 2)
RunSavedScriptPadding.Parent = RunSavedScript

local DeleteSavedScript = Instance.new("TextButton")
DeleteSavedScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DeleteSavedScript.BackgroundTransparency = 0.5
DeleteSavedScript.BorderSizePixel = 0
DeleteSavedScript.FontFace = GothamMedium
DeleteSavedScript.LayoutOrder = 2
DeleteSavedScript.Name = "DeleteSavedScript"
DeleteSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
DeleteSavedScript.Text = "Delete"
DeleteSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteSavedScript.TextScaled = true
DeleteSavedScript.TextWrapped = true
DeleteSavedScript.Parent = SavedScriptActions

local DeleteSavedScriptStroke = Instance.new("UIStroke")
DeleteSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DeleteSavedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
DeleteSavedScriptStroke.Name = "DeleteSavedScriptStroke"
DeleteSavedScriptStroke.Transparency = 0.8
DeleteSavedScriptStroke.Parent = DeleteSavedScript

NewCorner("", "DeleteSavedScriptCorner", DeleteSavedScript)

local DeleteSavedScriptPadding = Instance.new("UIPadding")
DeleteSavedScriptPadding.Name = "DeleteSavedScriptPadding"
DeleteSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
DeleteSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
DeleteSavedScriptPadding.PaddingRight = UDim.new(0, 2)
DeleteSavedScriptPadding.PaddingTop = UDim.new(0, 2)
DeleteSavedScriptPadding.Parent = DeleteSavedScript

local NoSavedScriptsLabel = Instance.new("TextLabel")
NoSavedScriptsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoSavedScriptsLabel.BackgroundTransparency = 1
NoSavedScriptsLabel.BorderSizePixel = 0
NoSavedScriptsLabel.FontFace = GothamMedium
NoSavedScriptsLabel.Name = "NoSavedScriptsLabel"
NoSavedScriptsLabel.Size = UDim2.new(1, 0, 0, 30)
NoSavedScriptsLabel.Text = "No Saved Scripts! Save Some Scripts to use this tab."
NoSavedScriptsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSavedScriptsLabel.TextScaled = true
NoSavedScriptsLabel.TextWrapped = true
NoSavedScriptsLabel.TextXAlignment = Enum.TextXAlignment.Center
NoSavedScriptsLabel.Visible = true
NoSavedScriptsLabel.Parent = SavedScriptsScroll

local SidebarContainer = Instance.new("Frame")
SidebarContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SidebarContainer.BackgroundTransparency = 1
SidebarContainer.BorderSizePixel = 0
SidebarContainer.LayoutOrder = 2
SidebarContainer.Name = "SidebarContainer"
SidebarContainer.Position = UDim2.new(0, 250, 0, 30)
SidebarContainer.Size = UDim2.new(0.2, 0, 0.3, 0)
SidebarContainer.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.AnchorPoint = Vector2.new(1, 0.5)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
Sidebar.Size = UDim2.new(1, 0, 1, -8)
Sidebar.Parent = SidebarContainer

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SidebarLayout.Name = "SidebarLayout"
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Name = "SidebarPadding"
SidebarPadding.PaddingBottom = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 16)
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

NewCorner("", "SidebarCorner", Sidebar)

local SidebarSizeCons = Instance.new("UISizeConstraint")
SidebarSizeCons.MaxSize = Vector2.new(5000, 5000)
SidebarSizeCons.Name = "SidebarSizeCons"
SidebarSizeCons.Parent = Sidebar

local Topbar = Instance.new("Frame")
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.BackgroundTransparency = 1
Topbar.BorderSizePixel = 0
Topbar.LayoutOrder = -1
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(0.2, 0, 0.3, 0)
Topbar.Parent = Sidebar

local TopbarLayout = Instance.new("UIListLayout")
TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.Name = "TopbarLayout"
TopbarLayout.Padding = UDim.new(0, 4)
TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.Parent = Topbar

local TopbarSizeCons = Instance.new("UISizeConstraint")
TopbarSizeCons.MaxSize = Vector2.new(10000, 30)
TopbarSizeCons.MinSize = Vector2.new(0, 28)
TopbarSizeCons.Name = "TopbarSizeCons"
TopbarSizeCons.Parent = Topbar

local Logo = Instance.new("ImageLabel")
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1
Logo.BorderSizePixel = 0
Logo.Image = GetAsset("Lucid/Assets/lucid_logo.png")
Logo.ImageColor3 = Color3.fromRGB(241, 241, 241)
Logo.LayoutOrder = 1
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Parent = Topbar

Instance.new("UIAspectRatioConstraint", Logo).Name = "LogoRatio"

local Title = Instance.new("TextLabel")
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.FontFace = BuilderSans
Title.LayoutOrder = 2
Title.Name = "Title"
Title.Size = UDim2.new(0, 60, 0, 30)
Title.Text = "Lucid"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local TitlePadding = Instance.new("UIPadding")
TitlePadding.Name = "TitlePadding"
TitlePadding.PaddingBottom = UDim.new(0, 2)
TitlePadding.PaddingTop = UDim.new(0, 2)
TitlePadding.Parent = Title

local ExeTab = Instance.new("TextButton")
ExeTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeTab.BackgroundTransparency = 1
ExeTab.BorderSizePixel = 0
ExeTab.LayoutOrder = 1
ExeTab.Name = "ExeTab"
ExeTab.Size = UDim2.new(0.2, 0, 0.3, 0)
ExeTab.Text = ""
ExeTab.Parent = Sidebar

local ExeTabLayout = Instance.new("UIListLayout")
ExeTabLayout.FillDirection = Enum.FillDirection.Horizontal
ExeTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeTabLayout.Name = "ExeTabLayout"
ExeTabLayout.Padding = UDim.new(0, 4)
ExeTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExeTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeTabLayout.Parent = ExeTab

local ExeTabPadding = Instance.new("UIPadding")
ExeTabPadding.Name = "ExeTabPadding"
ExeTabPadding.PaddingBottom = UDim.new(0, 3)
ExeTabPadding.PaddingTop = UDim.new(0, 3)
ExeTabPadding.Parent = ExeTab

local ExeTabSizeCons = Instance.new("UISizeConstraint")
ExeTabSizeCons.MaxSize = Vector2.new(10000, 30)
ExeTabSizeCons.MinSize = Vector2.new(0, 28)
ExeTabSizeCons.Name = "ExeTabSizeCons"
ExeTabSizeCons.Parent = ExeTab

local TabIconExe = Instance.new("ImageLabel")
TabIconExe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconExe.BackgroundTransparency = 1
TabIconExe.BorderSizePixel = 0
TabIconExe.Image = GetAsset("Lucid/Assets/lucid_executor.png")
TabIconExe.LayoutOrder = 1
TabIconExe.Name = "TabIcon"
TabIconExe.Size = UDim2.new(0, 30, 0, 30)
TabIconExe.Parent = ExeTab

Instance.new("UIAspectRatioConstraint", TabIconExe).Name = "TabIconRatio"

local TabLabelExe = Instance.new("TextLabel")
TabLabelExe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelExe.BackgroundTransparency = 1
TabLabelExe.BorderSizePixel = 0
TabLabelExe.FontFace = BuilderSans
TabLabelExe.LayoutOrder = 2
TabLabelExe.Name = "TabLabel"
TabLabelExe.Size = UDim2.new(0, 60, 0, 30)
TabLabelExe.Text = "Executor"
TabLabelExe.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelExe.TextScaled = true
TabLabelExe.TextWrapped = true
TabLabelExe.TextXAlignment = Enum.TextXAlignment.Left
TabLabelExe.Parent = ExeTab

local SearchTab = Instance.new("TextButton")
SearchTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchTab.BackgroundTransparency = 1
SearchTab.BorderSizePixel = 0
SearchTab.LayoutOrder = 2
SearchTab.Name = "SearchTab"
SearchTab.Size = UDim2.new(0.2, 0, 0.3, 0)
SearchTab.Text = ""
SearchTab.Parent = Sidebar

local SearchTabLayout = Instance.new("UIListLayout")
SearchTabLayout.FillDirection = Enum.FillDirection.Horizontal
SearchTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchTabLayout.Name = "SearchTabLayout"
SearchTabLayout.Padding = UDim.new(0, 4)
SearchTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SearchTabLayout.Parent = SearchTab

local SearchTabPadding = Instance.new("UIPadding")
SearchTabPadding.Name = "SearchTabPadding"
SearchTabPadding.PaddingBottom = UDim.new(0, 3)
SearchTabPadding.PaddingTop = UDim.new(0, 3)
SearchTabPadding.Parent = SearchTab

local SearchTabSizeCons = Instance.new("UISizeConstraint")
SearchTabSizeCons.MaxSize = Vector2.new(10000, 30)
SearchTabSizeCons.MinSize = Vector2.new(0, 28)
SearchTabSizeCons.Name = "SearchTabSizeCons"
SearchTabSizeCons.Parent = SearchTab

local TabIconSearch = Instance.new("ImageLabel")
TabIconSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconSearch.BackgroundTransparency = 1
TabIconSearch.BorderSizePixel = 0
TabIconSearch.Image = GetAsset("Lucid/Assets/lucid_search.png")
TabIconSearch.LayoutOrder = 1
TabIconSearch.Name = "TabIcon"
TabIconSearch.Size = UDim2.new(0, 30, 0, 30)
TabIconSearch.Parent = SearchTab

Instance.new("UIAspectRatioConstraint", TabIconSearch).Name = "TabIconRatio"

local TabLabelSearch = Instance.new("TextLabel")
TabLabelSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelSearch.BackgroundTransparency = 1
TabLabelSearch.BorderSizePixel = 0
TabLabelSearch.FontFace = BuilderSans
TabLabelSearch.LayoutOrder = 2
TabLabelSearch.Name = "TabLabel"
TabLabelSearch.Size = UDim2.new(0, 60, 0, 30)
TabLabelSearch.Text = "Search"
TabLabelSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelSearch.TextScaled = true
TabLabelSearch.TextWrapped = true
TabLabelSearch.TextXAlignment = Enum.TextXAlignment.Left
TabLabelSearch.Parent = SearchTab

local ScriptsTab = Instance.new("TextButton")
ScriptsTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptsTab.BackgroundTransparency = 1
ScriptsTab.BorderSizePixel = 0
ScriptsTab.LayoutOrder = 3
ScriptsTab.Name = "ScriptsTab"
ScriptsTab.Size = UDim2.new(0.2, 0, 0.3, 0)
ScriptsTab.Text = ""
ScriptsTab.Parent = Sidebar

local ScriptsTabLayout = Instance.new("UIListLayout")
ScriptsTabLayout.FillDirection = Enum.FillDirection.Horizontal
ScriptsTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ScriptsTabLayout.Name = "ScriptsTabLayout"
ScriptsTabLayout.Padding = UDim.new(0, 4)
ScriptsTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScriptsTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ScriptsTabLayout.Parent = ScriptsTab

local ScriptsTabPadding = Instance.new("UIPadding")
ScriptsTabPadding.Name = "ScriptsTabPadding"
ScriptsTabPadding.PaddingBottom = UDim.new(0, 3)
ScriptsTabPadding.PaddingTop = UDim.new(0, 3)
ScriptsTabPadding.Parent = ScriptsTab

local ScriptsTabSizeCons = Instance.new("UISizeConstraint")
ScriptsTabSizeCons.MaxSize = Vector2.new(10000, 30)
ScriptsTabSizeCons.MinSize = Vector2.new(0, 28)
ScriptsTabSizeCons.Name = "ScriptsTabSizeCons"
ScriptsTabSizeCons.Parent = ScriptsTab

local TabIconScripts = Instance.new("ImageLabel")
TabIconScripts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconScripts.BackgroundTransparency = 1
TabIconScripts.BorderSizePixel = 0
TabIconScripts.Image = GetAsset("Lucid/Assets/lucid_scripts.png")
TabIconScripts.LayoutOrder = 1
TabIconScripts.Name = "TabIcon"
TabIconScripts.Size = UDim2.new(0, 30, 0, 30)
TabIconScripts.Parent = ScriptsTab

Instance.new("UIAspectRatioConstraint", TabIconScripts).Name = "TabIconRatio"

local TabLabelScripts = Instance.new("TextLabel")
TabLabelScripts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelScripts.BackgroundTransparency = 1
TabLabelScripts.BorderSizePixel = 0
TabLabelScripts.FontFace = BuilderSans
TabLabelScripts.LayoutOrder = 2
TabLabelScripts.Name = "TabLabel"
TabLabelScripts.Size = UDim2.new(0, 60, 0, 30)
TabLabelScripts.Text = "Scripts"
TabLabelScripts.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelScripts.TextScaled = true
TabLabelScripts.TextWrapped = true
TabLabelScripts.TextXAlignment = Enum.TextXAlignment.Left
TabLabelScripts.Parent = ScriptsTab

local CloseTab = Instance.new("TextButton")
CloseTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseTab.BackgroundTransparency = 1
CloseTab.BorderSizePixel = 0
CloseTab.LayoutOrder = 5
CloseTab.Name = "CloseTab"
CloseTab.Size = UDim2.new(0.2, 0, 0.3, 0)
CloseTab.Text = ""
CloseTab.Parent = Sidebar

local CloseTabLayout = Instance.new("UIListLayout")
CloseTabLayout.FillDirection = Enum.FillDirection.Horizontal
CloseTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
CloseTabLayout.Name = "CloseTabLayout"
CloseTabLayout.Padding = UDim.new(0, 4)
CloseTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
CloseTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
CloseTabLayout.Parent = CloseTab

local CloseTabPadding = Instance.new("UIPadding")
CloseTabPadding.Name = "CloseTabPadding"
CloseTabPadding.PaddingBottom = UDim.new(0, 3)
CloseTabPadding.PaddingTop = UDim.new(0, 3)
CloseTabPadding.Parent = CloseTab

local CloseTabSizeCons = Instance.new("UISizeConstraint")
CloseTabSizeCons.MaxSize = Vector2.new(10000, 30)
CloseTabSizeCons.MinSize = Vector2.new(0, 28)
CloseTabSizeCons.Name = "CloseTabSizeCons"
CloseTabSizeCons.Parent = CloseTab

local TabIconClose = Instance.new("ImageLabel")
TabIconClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconClose.BackgroundTransparency = 1
TabIconClose.BorderSizePixel = 0
TabIconClose.Image = GetAsset("Lucid/Assets/lucid_close.png")
TabIconClose.LayoutOrder = 1
TabIconClose.Name = "TabIcon"
TabIconClose.Size = UDim2.new(0, 30, 0, 30)
TabIconClose.Parent = CloseTab

Instance.new("UIAspectRatioConstraint", TabIconClose).Name = "TabIconRatio"

local TabLabelClose = Instance.new("TextLabel")
TabLabelClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelClose.BackgroundTransparency = 1
TabLabelClose.BorderSizePixel = 0
TabLabelClose.FontFace = BuilderSans
TabLabelClose.LayoutOrder = 2
TabLabelClose.Name = "TabLabel"
TabLabelClose.Size = UDim2.new(0, 60, 0, 30)
TabLabelClose.Text = "Close"
TabLabelClose.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelClose.TextScaled = true
TabLabelClose.TextWrapped = true
TabLabelClose.TextXAlignment = Enum.TextXAlignment.Left
TabLabelClose.Parent = CloseTab

local Show = Instance.new("ImageButton")
Show.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
Show.BackgroundTransparency = 0.08
Show.BorderSizePixel = 0
Show.Image = ""
Show.Name = "Show"
Show.Position = UDim2.new(0, 16, 0, 60)
Show.Size = UDim2.new(0, 44, 0, 44)
Show.ZIndex = 3
Show.Parent = Lucid

Instance.new("UIAspectRatioConstraint", Show).Name = "ShowRatio"

NewCorner("1, 0", "ShowCorner", Show)

local ShowIcon = Instance.new("ImageLabel")
ShowIcon.AnchorPoint = Vector2.new(0.5, 0.5)
ShowIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShowIcon.BackgroundTransparency = 1
ShowIcon.BorderSizePixel = 0
ShowIcon.Image = GetAsset("Lucid/Assets/lucid_logo.png")
ShowIcon.Name = "ShowIcon"
ShowIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
ShowIcon.Size = UDim2.new(0, 28, 0, 28)
ShowIcon.Parent = Show

local function RefreshSavedScripts(searchQuery)
    for _, child in ipairs(SavedScriptsScroll:GetChildren()) do
        if child ~= SavedScriptTemplate
            and child ~= NoSavedScriptsLabel
            and child ~= SavedScriptsScrollPadding
            and child ~= SavedScriptsScrollListLayout then
            child:Destroy()
        end
    end
    local scripts = LoadSavedScripts()
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
        NoSavedScriptsLabel.Visible = true
        NoSavedScriptsLabel.Text = (searchQuery and searchQuery ~= "") and "No saved scripts match your search." or "No Saved Scripts! Save Some Scripts to use this tab."
        return
    end
    NoSavedScriptsLabel.Visible = false
    for _, scriptData in ipairs(scripts) do
        local clone = SavedScriptTemplate:Clone()
        clone.Name = SanitizeName(scriptData.Name)
        clone.Visible = true
        clone.Parent = SavedScriptsScroll
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
            if runBtn then
                runBtn.MouseButton1Click:Connect(function()
                    local success, err = loadstring(scriptData.Code or "")()
                    if not success then warn("Failed to execute saved script: ", err) end
                end)
            end
            if deleteBtn then
                deleteBtn.MouseButton1Click:Connect(function()
                    DeleteScript(scriptData.Name)
                    RefreshSavedScripts(SavedScriptsSearchBox.Text)
                end)
            end
        end
    end
end

local function PerformSearch(query)
    for _, child in ipairs(SearchResults:GetChildren()) do
        if child ~= SearchResultTemplate
            and child ~= NoResultsLabel
            and child ~= SearchResultsPadding
            and child ~= SearchResultsListLayout then
            child:Destroy()
        end
    end
    if query == "" then NoResultsLabel.Visible = false; return end
    local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&max=20&strict=true"
    local success, response = pcall(function() return HttpGet(url) end)
    if not success or not response or not response.Body then
        NoResultsLabel.Visible = true
        NoResultsLabel.Text = "Failed to fetch scripts. Check your connection and try again."
        return
    end
    local decoded = HttpService:JSONDecode(response.Body)
    if not decoded or not decoded.result or not decoded.result.scripts then
        NoResultsLabel.Visible = true
        NoResultsLabel.Text = "No scripts found matching your query."
        return
    end
    local scripts = decoded.result.scripts
    if #scripts == 0 then
        NoResultsLabel.Visible = true
        NoResultsLabel.Text = "No scripts found matching your query."
        return
    end
    NoResultsLabel.Visible = false
    for _, script in ipairs(scripts) do
        local clone = SearchResultTemplate:Clone()
        clone.Name = SanitizeName(script.title or "Script")
        clone.Visible = true
        clone.Parent = SearchResults
        local scriptImage = clone:FindFirstChild("ScriptImage")
        if scriptImage and script._id then
            scriptImage.Image = ""
            task.spawn(function()
                local detailUrl = "https://scriptblox.com/api/script/" .. script._id
                local detailResponse = HttpGet(detailUrl)
                if detailResponse and detailResponse.Body then
                    local detailData = HttpService:JSONDecode(detailResponse.Body)
                    if detailData and detailData.script and detailData.script.image then
                        scriptImage.Image = GetImage(detailData.script.image) or ""
                    end
                end
            end)
        end
        local container = clone:FindFirstChild("Container")
        if container then
            local scriptName = container:FindFirstChild("ScriptName")
            if scriptName then
                scriptName.Text = script.title or "Unknown"
            end
        end
        local scriptId = script._id
        local actionsFrame = container and container:FindFirstChild("ScriptActions")
        if actionsFrame then
            local runBtn = actionsFrame:FindFirstChild("RunScript")
            local copyBtn = actionsFrame:FindFirstChild("CopyScriptBtn")
            local saveBtn = actionsFrame:FindFirstChild("SaveScriptBtn")
            if runBtn then
                runBtn.MouseButton1Click:Connect(function()
                    local detailUrl = "https://scriptblox.com/api/script/" .. scriptId
                    local detailResponse = HttpGet(detailUrl)
                    if detailResponse and detailResponse.Body then
                        local detailData = HttpService:JSONDecode(detailResponse.Body)
                        if detailData and detailData.script and detailData.script.script then
                            local success, err = loadstring(detailData.script.script)()
                            if not success then warn("Failed to execute script: ", err) end
                        end
                    end
                end)
            end
            if copyBtn then
                copyBtn.MouseButton1Click:Connect(function()
                    local detailUrl = "https://scriptblox.com/api/script/" .. scriptId
                    local detailResponse = HttpGet(detailUrl)
                    if detailResponse and detailResponse.Body then
                        local detailData = HttpService:JSONDecode(detailResponse.Body)
                        if detailData and detailData.script and detailData.script.script then
                            SetClipboard(detailData.script.script)
                        end
                    end
                end)
            end
            if saveBtn then
                saveBtn.MouseButton1Click:Connect(function()
                    local detailUrl = "https://scriptblox.com/api/script/" .. scriptId
                    local detailResponse = HttpGet(detailUrl)
                    if detailResponse and detailResponse.Body then
                        local detailData = HttpService:JSONDecode(detailResponse.Body)
                        if detailData and detailData.script then
                            local scriptData = {
                                Name = detailData.script.title or "Unknown",
                                Description = detailData.script.description or "",
                                Code = detailData.script.script or ""
                            }
                            SaveScript(scriptData)
                            RefreshSavedScripts(SavedScriptsSearchBox.Text)
                        end
                    end
                end)
            end
        end
    end
end

local function SwitchTab(NewPage)
    ExeContent.Visible = false
    SearchContent.Visible = false
    SavedScriptsContent.Visible = false
    
    local oldPage = nil
    for _, child in ipairs(Pages:GetChildren()) do
        if child:IsA("CanvasGroup") and child.Visible and child ~= NewPage then
            oldPage = child
            break
        end
    end
    
    if NewPage == oldPage then return end
    
    NewPage.Position = UDim2.new(1, 0, 0, 0)
    NewPage.Visible = true
    
    if oldPage then
        oldPage.Visible = false
        local oldClone = oldPage:Clone()
        oldClone.Parent = Pages
        oldClone.Position = UDim2.new(0, 0, 0, 0)
        oldClone.Size = UDim2.new(1, 0, 1, 0)
        
        local oldTween = TweenService:Create(oldClone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(-0.5, 0, 0, 0),
            Rotation = -15,
            BackgroundTransparency = 1
        })
        oldTween:Play()
        oldTween.Completed:Connect(function()
            oldClone:Destroy()
        end)
    end
    
    local newTween = TweenService:Create(NewPage, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    newTween:Play()
end

local function OpenUI()
    MainFrame.Visible = true
    MainFrame.BackgroundTransparency = 1

    local activeContent = ExeContent.Visible and ExeContent
        or SearchContent.Visible and SearchContent
        or SavedScriptsContent.Visible and SavedScriptsContent
        or ExeContent

    activeContent.Position = UDim2.new(-1, 0, 0, 0)
    Sidebar.Position = UDim2.new(1, 300, 0.5, 0)
    
    Show.ImageTransparency = 0
    Show.BackgroundTransparency = 0.08

    local bgTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5
    })
    
    local contentTween = TweenService:Create(activeContent, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    local sidebarTween = TweenService:Create(Sidebar, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 8, 0.5, 0)
    })
    
    local showBgTween = TweenService:Create(Show, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1,
        BackgroundTransparency = 1
    })

    bgTween:Play()
    contentTween:Play()
    sidebarTween:Play()
    showBgTween:Play()
end

local function CloseUI()
    local activeContent = ExeContent.Visible and ExeContent
        or SearchContent.Visible and SearchContent
        or SavedScriptsContent.Visible and SavedScriptsContent
        or ExeContent

    local vpWidth = workspace.CurrentCamera.ViewportSize.X

    local bgTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    
    local contentTween = TweenService:Create(activeContent, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(-1.2, 0, 0, 0),
        Rotation = 10
    })
    
    local sidebarTween = TweenService:Create(Sidebar, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, vpWidth + 50, 0.5, 0)
    })
    
    local showTween = TweenService:Create(Show, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 0.08
    })

    bgTween:Play()
    contentTween:Play()
    sidebarTween:Play()
    showTween:Play()

    contentTween.Completed:Connect(function()
        MainFrame.Visible = false
        Show.Visible = true
        activeContent.Rotation = 0
    end)
end

NewScriptBtn.MouseButton1Click:Connect(function()
    NewScriptFrame.Visible = true
    NameBox.Text = ""
    DescBox.Text = ""
    ScriptBox.Text = ""
end)

SavedScriptsSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    RefreshSavedScripts(SavedScriptsSearchBox.Text)
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    PerformSearch(SearchBox.Text)
end)

ExeTab.MouseButton1Click:Connect(function() SwitchTab(ExeContent) end)
SearchTab.MouseButton1Click:Connect(function() SwitchTab(SearchContent) end)
ScriptsTab.MouseButton1Click:Connect(function()
    SwitchTab(SavedScriptsContent)
    RefreshSavedScripts(SavedScriptsSearchBox.Text)
end)

local function Dragify(Object)
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

Dragify(Show)

CloseTab.MouseButton1Click:Connect(function()
    CloseUI()
end)

Show.MouseButton1Click:Connect(function()
    Show.Visible = false
    OpenUI()
end)

Cancel.MouseButton1Click:Connect(function()
    NewScriptFrame.Visible = false
    NameBox.Text = ""
    DescBox.Text = ""
    ScriptBox.Text = ""
end)

Save.MouseButton1Click:Connect(function()
    local scriptName = NameBox.Text
    local scriptDesc = DescBox.Text
    local scriptCode = ScriptBox.Text
    if scriptName == "" then return end
    local scriptData = { Name = scriptName, Description = scriptDesc, Code = scriptCode }
    SaveScript(scriptData)
    NewScriptFrame.Visible = false
    NameBox.Text = ""
    DescBox.Text = ""
    ScriptBox.Text = ""
    RefreshSavedScripts(SavedScriptsSearchBox.Text)
end)

ExeBtn.MouseButton1Click:Connect(function()
    local code = InputBox.Text
    if code and code ~= "" then
        local success, err = loadstring(code)()
        if not success then warn("Execution error: ", err) end
    end
end)

ClrBtn.MouseButton1Click:Connect(function()
    InputBox.Text = ""
end)

CopyBtn.MouseButton1Click:Connect(function()
    SetClipboard(InputBox.Text)
end)

SwitchTab(ExeContent)
Show.Visible = true
MainFrame.Visible = false

Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        ClearCache()
    end
end)