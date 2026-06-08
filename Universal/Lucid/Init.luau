if not game:IsLoaded() then
    game.Loaded:Wait()
end 

local function default(expected, value, fallback)
    if type(value) == expected then
        return value
    end
    return fallback
end

local cloneref = default("function", cloneref, function() return end)

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

getgenv().Lucid = getgenv().Lucid or {}

local WriteFile = default("function", writefile, function() return end)
local ReadFile = default("function", readfile, function() return end)
local DelFile = default("function", delfile, function() return end)
local IsFile = default("function", isfile, function() return end)
local IsFolder = default("function", isfolder, function() return end)
local MakeFolder = default("function", makefolder, function() return end)
local ListFiles = default("function", listfiles, function() return end)
local LoadAsset = default("function", getcustomasset, default("function", getsynasset, function() return end))
local SetClipboard = default("function", setclipboard, function() return end)

local Workspace = Services.Workspace
local HttpService = Services.HttpService
local Players = Services.Players
local Player = Players.LocalPlayer
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService

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

local function HttpGet(url)
    local RequestFunc = default("function", syn and syn.request,
        default("function", request,
            default("function", http_request, function() return end)))
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
    cornerValue = (cornerValue and cornerValue ~= "") and cornerValue or "0,4"
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

if getgenv().Lucid.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Lucid Executor",
        Text = "Lucid is already running!",
        Icon = GetAsset("Lucid/Assets/lucid_logo.png"),
        Duration = 4
    })
    return
end

getgenv().Lucid.isLoaded = true

local Hui = (gethui and gethui())
local CoreGui = Hui or Services.CoreGui

HideExec()

local Lucid = Instance.new("ScreenGui")
Lucid.IgnoreGuiInset = true
Lucid.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Lucid.Name = "Lucid"
Lucid.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Lucid.ResetOnSpawn = false
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
NewScriptFrame.Visible = false
NewScriptFrame.ZIndex = 2
NewScriptFrame.BorderSizePixel = 0
NewScriptFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NewScriptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
NewScriptFrame.Size = UDim2.new(0, 408, 0, 214)
NewScriptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
NewScriptFrame.Name = "NewScriptFrame"
NewScriptFrame.BackgroundTransparency = 0.1
NewScriptFrame.Parent = Lucid

local NewScriptFramePadding = Instance.new("UIPadding")
NewScriptFramePadding.PaddingTop = UDim.new(0, 6)
NewScriptFramePadding.PaddingRight = UDim.new(0, 6)
NewScriptFramePadding.Name = "NewScriptFramePadding"
NewScriptFramePadding.PaddingLeft = UDim.new(0, 6)
NewScriptFramePadding.PaddingBottom = UDim.new(0, 6)
NewScriptFramePadding.Parent = NewScriptFrame

local NewScriptFrameStroke = Instance.new("UIStroke")
NewScriptFrameStroke.Transparency = 0.8
NewScriptFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NewScriptFrameStroke.Name = "NewScriptFrameStroke"
NewScriptFrameStroke.Color = Color3.fromRGB(255, 255, 255)
NewScriptFrameStroke.Parent = NewScriptFrame

NewCorner("", "NewScriptFrameCorner", NewScriptFrame)

local NewScriptFrameLayout = Instance.new("UIListLayout")
NewScriptFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
NewScriptFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
NewScriptFrameLayout.Padding = UDim.new(0, 8)
NewScriptFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
NewScriptFrameLayout.Name = "NewScriptFrameLayout"
NewScriptFrameLayout.Parent = NewScriptFrame

local NameBox = Instance.new("TextBox")
NameBox.Name = "NameBox"
NameBox.TextXAlignment = Enum.TextXAlignment.Left
NameBox.BorderSizePixel = 0
NameBox.TextWrapped = true
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.TextScaled = true
NameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox.FontFace = GothamMedium
NameBox.PlaceholderText = "Enter script name..."
NameBox.Size = UDim2.new(0, 76, 0, 30)
NameBox.Text = ""
NameBox.LayoutOrder = 1
NameBox.BackgroundTransparency = 1
NameBox.Parent = NewScriptFrame

local NameBoxPadding = Instance.new("UIPadding")
NameBoxPadding.PaddingTop = UDim.new(0, 4)
NameBoxPadding.PaddingRight = UDim.new(0, 4)
NameBoxPadding.Name = "NameBoxPadding"
NameBoxPadding.PaddingLeft = UDim.new(0, 4)
NameBoxPadding.PaddingBottom = UDim.new(0, 4)
NameBoxPadding.Parent = NameBox

local NameBoxStroke = Instance.new("UIStroke")
NameBoxStroke.Transparency = 0.8
NameBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NameBoxStroke.Name = "NameBoxStroke"
NameBoxStroke.Color = Color3.fromRGB(255, 255, 255)
NameBoxStroke.Parent = NameBox

NewCorner("", "NameBoxCorner", NameBox)

local DescBox = Instance.new("TextBox")
DescBox.Name = "DescBox"
DescBox.TextXAlignment = Enum.TextXAlignment.Left
DescBox.BorderSizePixel = 0
DescBox.TextWrapped = true
DescBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DescBox.TextScaled = true
DescBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DescBox.FontFace = GothamMedium
DescBox.PlaceholderText = "Enter script description..."
DescBox.Size = UDim2.new(0, 76, 0, 30)
DescBox.Text = ""
DescBox.LayoutOrder = 2
DescBox.BackgroundTransparency = 1
DescBox.Parent = NewScriptFrame

local DescBoxPadding = Instance.new("UIPadding")
DescBoxPadding.PaddingTop = UDim.new(0, 4)
DescBoxPadding.PaddingRight = UDim.new(0, 4)
DescBoxPadding.Name = "DescBoxPadding"
DescBoxPadding.PaddingLeft = UDim.new(0, 4)
DescBoxPadding.PaddingBottom = UDim.new(0, 4)
DescBoxPadding.Parent = DescBox

local DescBoxStroke = Instance.new("UIStroke")
DescBoxStroke.Transparency = 0.8
DescBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DescBoxStroke.Name = "DescBoxStroke"
DescBoxStroke.Color = Color3.fromRGB(255, 255, 255)
DescBoxStroke.Parent = DescBox

NewCorner("", "DescBoxCorner", DescBox)

local ScriptBox = Instance.new("TextBox")
ScriptBox.Name = "ScriptBox"
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.BorderSizePixel = 0
ScriptBox.TextWrapped = true
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.FontFace = Inconsolata
ScriptBox.PlaceholderText = "Enter script code..."
ScriptBox.Size = UDim2.new(0, 76, 0, 80)
ScriptBox.Text = ""
ScriptBox.TextSize = 20
ScriptBox.LayoutOrder = 3
ScriptBox.BackgroundTransparency = 1
ScriptBox.Parent = NewScriptFrame

local ScriptBoxPadding = Instance.new("UIPadding")
ScriptBoxPadding.PaddingTop = UDim.new(0, 4)
ScriptBoxPadding.PaddingRight = UDim.new(0, 4)
ScriptBoxPadding.Name = "ScriptBoxPadding"
ScriptBoxPadding.PaddingLeft = UDim.new(0, 4)
ScriptBoxPadding.PaddingBottom = UDim.new(0, 4)
ScriptBoxPadding.Parent = ScriptBox

local ScriptBoxStroke = Instance.new("UIStroke")
ScriptBoxStroke.Transparency = 0.8
ScriptBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScriptBoxStroke.Name = "ScriptBoxStroke"
ScriptBoxStroke.Color = Color3.fromRGB(255, 255, 255)
ScriptBoxStroke.Parent = ScriptBox

NewCorner("", "ScriptBoxCorner", ScriptBox)

local Options = Instance.new("Frame")
Options.BorderSizePixel = 0
Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Options.Size = UDim2.new(0, 76, 0, 34)
Options.Position = UDim2.new(0, 50, 0, -8)
Options.Name = "Options"
Options.LayoutOrder = 4
Options.BackgroundTransparency = 1
Options.Parent = NewScriptFrame

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
OptionsLayout.Padding = UDim.new(0, 8)
OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionsLayout.Name = "OptionsLayout"
OptionsLayout.FillDirection = Enum.FillDirection.Horizontal
OptionsLayout.Parent = Options

NewCorner("", "OptionsCorner", Options)

local Save = Instance.new("TextButton")
Save.TextWrapped = true
Save.BorderSizePixel = 0
Save.TextScaled = true
Save.TextColor3 = Color3.fromRGB(255, 255, 255)
Save.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Save.FontFace = GothamMedium
Save.BackgroundTransparency = 1
Save.Size = UDim2.new(0.2, 0, 0.3, 0)
Save.LayoutOrder = 1
Save.Text = "Save"
Save.Name = "Save"
Save.Parent = Options

local SaveStroke = Instance.new("UIStroke")
SaveStroke.Transparency = 0.8
SaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SaveStroke.Name = "SaveStroke"
SaveStroke.Color = Color3.fromRGB(255, 255, 255)
SaveStroke.Parent = Save

NewCorner("", "SaveCorner", Save)

local Cancel = Instance.new("TextButton")
Cancel.TextWrapped = true
Cancel.BorderSizePixel = 0
Cancel.TextScaled = true
Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
Cancel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cancel.FontFace = GothamMedium
Cancel.BackgroundTransparency = 1
Cancel.Size = UDim2.new(0.2, 0, 0.3, 0)
Cancel.LayoutOrder = 2
Cancel.Text = "Cancel"
Cancel.Name = "Cancel"
Cancel.Parent = Options

local CancelStroke = Instance.new("UIStroke")
CancelStroke.Transparency = 0.8
CancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CancelStroke.Name = "CancelStroke"
CancelStroke.Color = Color3.fromRGB(255, 255, 255)
CancelStroke.Parent = Cancel

NewCorner("", "CancelCorner", Cancel)

local MainFrame = Instance.new("Frame")
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
MainFrame.AutoLocalize = false
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundTransparency = 0.5
MainFrame.ZIndex = 1
MainFrame.Parent = Lucid

local MainFrameLayout = Instance.new("UIListLayout")
MainFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainFrameLayout.Name = "MainFrameLayout"
MainFrameLayout.FillDirection = Enum.FillDirection.Horizontal
MainFrameLayout.Parent = MainFrame

local Pages = Instance.new("Frame")
Pages.BorderSizePixel = 0
Pages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pages.Size = UDim2.new(0, 576, 0, 116)
Pages.Position = UDim2.new(0, 18, 0, 62)
Pages.Name = "Pages"
Pages.LayoutOrder = 1
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local PagesPadding = Instance.new("UIPadding")
PagesPadding.PaddingTop = UDim.new(0, 60)
PagesPadding.Name = "PagesPadding"
PagesPadding.PaddingLeft = UDim.new(0, 8)
PagesPadding.PaddingBottom = UDim.new(0, 8)
PagesPadding.Parent = Pages

local ExeContent = Instance.new("CanvasGroup")
ExeContent.BorderSizePixel = 0
ExeContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExeContent.Size = UDim2.new(1, 0, 1, 0)
ExeContent.Name = "ExeContent"
ExeContent.LayoutOrder = 1
ExeContent.BackgroundTransparency = 0.3
ExeContent.Parent = Pages

NewCorner("", "ExeContentCorner", ExeContent)

local ExeContentLayout = Instance.new("UIListLayout")
ExeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeContentLayout.Padding = UDim.new(0, 4)
ExeContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExeContentLayout.Name = "ExeContentLayout"
ExeContentLayout.Parent = ExeContent

local ExeContentStroke = Instance.new("UIStroke")
ExeContentStroke.Transparency = 0.8
ExeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeContentStroke.Name = "ExeContentStroke"
ExeContentStroke.Parent = ExeContent

local InputFrame = Instance.new("ScrollingFrame")
InputFrame.ScrollingDirection = Enum.ScrollingDirection.Y
InputFrame.BorderSizePixel = 0
InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InputFrame.Name = "InputFrame"
InputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
InputFrame.Size = UDim2.new(0, 222, 0, 248)
InputFrame.Position = UDim2.new(0, 70, 0, -30)
InputFrame.ScrollBarThickness = 0
InputFrame.LayoutOrder = 2
InputFrame.BackgroundTransparency = 1
InputFrame.Parent = ExeContent

local InputFramePadding = Instance.new("UIPadding")
InputFramePadding.PaddingTop = UDim.new(0, 6)
InputFramePadding.PaddingRight = UDim.new(0, 6)
InputFramePadding.Name = "InputFramePadding"
InputFramePadding.PaddingLeft = UDim.new(0, 6)
InputFramePadding.Parent = InputFrame

local InputFrameLayout = Instance.new("UIListLayout")
InputFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
InputFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
InputFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
InputFrameLayout.Name = "InputFrameLayout"
InputFrameLayout.Parent = InputFrame

local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(0, 250, 0, 280)
InputBox.AutomaticSize = Enum.AutomaticSize.Y
InputBox.Position = UDim2.new(0, -14, 0, -76)
InputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InputBox.BackgroundTransparency = 0.5
InputBox.BorderSizePixel = 0
InputBox.FontFace = Inconsolata
InputBox.TextSize = 18
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.TextWrapped = true
InputBox.Text = ""
InputBox.PlaceholderText = "Enter code here..."
InputBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
InputBox.MultiLine = true
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputFrame

local InputBoxPadding = Instance.new("UIPadding")
InputBoxPadding.PaddingTop = UDim.new(0, 6)
InputBoxPadding.PaddingRight = UDim.new(0, 6)
InputBoxPadding.Name = "InputBoxPadding"
InputBoxPadding.PaddingLeft = UDim.new(0, 6)
InputBoxPadding.PaddingBottom = UDim.new(0, 6)
InputBoxPadding.Parent = InputBox

local InputBoxStroke = Instance.new("UIStroke")
InputBoxStroke.Transparency = 0.8
InputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputBoxStroke.Name = "InputBoxStroke"
InputBoxStroke.Color = Color3.fromRGB(255, 255, 255)
InputBoxStroke.Parent = InputBox

local InputBoxSizeCons = Instance.new("UISizeConstraint")
InputBoxSizeCons.MinSize = Vector2.new(0, 200)
InputBoxSizeCons.Name = "InputBoxSizeCons"
InputBoxSizeCons.MaxSize = Vector2.new(10000, 266)
InputBoxSizeCons.Parent = InputBox

NewCorner("", "InputBoxCorner", InputBox)

local Buttons = Instance.new("Frame")
Buttons.BorderSizePixel = 0
Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Buttons.Size = UDim2.new(0, 116, 0, 38)
Buttons.Position = UDim2.new(0, 28, 0, 20)
Buttons.Name = "Buttons"
Buttons.LayoutOrder = 3
Buttons.BackgroundTransparency = 1
Buttons.Parent = ExeContent

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ButtonsLayout.Padding = UDim.new(0, 6)
ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonsLayout.Name = "ButtonsLayout"
ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonsLayout.Parent = Buttons

local ButtonsSizeCons = Instance.new("UISizeConstraint")
ButtonsSizeCons.Name = "ButtonsSizeCons"
ButtonsSizeCons.MaxSize = Vector2.new(10000, 38)
ButtonsSizeCons.Parent = Buttons

local ButtonsPadding = Instance.new("UIPadding")
ButtonsPadding.PaddingRight = UDim.new(0, 5)
ButtonsPadding.Name = "ButtonsPadding"
ButtonsPadding.PaddingLeft = UDim.new(0, 5)
ButtonsPadding.PaddingBottom = UDim.new(0, 5)
ButtonsPadding.Parent = Buttons

local ExeBtn = Instance.new("TextButton")
ExeBtn.TextWrapped = true
ExeBtn.BorderSizePixel = 0
ExeBtn.TextScaled = true
ExeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExeBtn.FontFace = BuilderSans
ExeBtn.BackgroundTransparency = 0.5
ExeBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
ExeBtn.LayoutOrder = 1
ExeBtn.Text = "Execute"
ExeBtn.Name = "ExeBtn"
ExeBtn.Parent = Buttons

NewCorner("", "ExeBtnCorner", ExeBtn)

local ExeBtnStroke = Instance.new("UIStroke")
ExeBtnStroke.Transparency = 0.8
ExeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ExeBtnStroke.Name = "ExeBtnStroke"
ExeBtnStroke.Color = Color3.fromRGB(255, 255, 255)
ExeBtnStroke.Parent = ExeBtn

local ExeBtnPadding = Instance.new("UIPadding")
ExeBtnPadding.PaddingTop = UDim.new(0, 4)
ExeBtnPadding.PaddingRight = UDim.new(0, 4)
ExeBtnPadding.Name = "ExeBtnPadding"
ExeBtnPadding.PaddingLeft = UDim.new(0, 4)
ExeBtnPadding.PaddingBottom = UDim.new(0, 4)
ExeBtnPadding.Parent = ExeBtn

local ClrBtn = Instance.new("TextButton")
ClrBtn.TextWrapped = true
ClrBtn.BorderSizePixel = 0
ClrBtn.TextScaled = true
ClrBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClrBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ClrBtn.FontFace = BuilderSans
ClrBtn.BackgroundTransparency = 0.5
ClrBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
ClrBtn.LayoutOrder = 2
ClrBtn.Text = "Clear"
ClrBtn.Name = "ClrBtn"
ClrBtn.Parent = Buttons

NewCorner("", "ClrBtnCorner", ClrBtn)

local ClrBtnStroke = Instance.new("UIStroke")
ClrBtnStroke.Transparency = 0.8
ClrBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ClrBtnStroke.Name = "ClrBtnStroke"
ClrBtnStroke.Color = Color3.fromRGB(255, 255, 255)
ClrBtnStroke.Parent = ClrBtn

local ClrBtnPadding = Instance.new("UIPadding")
ClrBtnPadding.PaddingTop = UDim.new(0, 4)
ClrBtnPadding.PaddingRight = UDim.new(0, 4)
ClrBtnPadding.Name = "ClrBtnPadding"
ClrBtnPadding.PaddingLeft = UDim.new(0, 4)
ClrBtnPadding.PaddingBottom = UDim.new(0, 4)
ClrBtnPadding.Parent = ClrBtn

local CopyBtn = Instance.new("TextButton")
CopyBtn.TextWrapped = true
CopyBtn.BorderSizePixel = 0
CopyBtn.TextScaled = true
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CopyBtn.FontFace = BuilderSans
CopyBtn.BackgroundTransparency = 0.5
CopyBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
CopyBtn.LayoutOrder = 3
CopyBtn.Text = "Copy Code"
CopyBtn.Name = "CopyBtn"
CopyBtn.Parent = Buttons

NewCorner("", "CopyBtnCorner", CopyBtn)

local CopyBtnStroke = Instance.new("UIStroke")
CopyBtnStroke.Transparency = 0.8
CopyBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CopyBtnStroke.Name = "CopyBtnStroke"
CopyBtnStroke.Color = Color3.fromRGB(255, 255, 255)
CopyBtnStroke.Parent = CopyBtn

local CopyBtnPadding = Instance.new("UIPadding")
CopyBtnPadding.PaddingTop = UDim.new(0, 4)
CopyBtnPadding.PaddingRight = UDim.new(0, 4)
CopyBtnPadding.Name = "CopyBtnPadding"
CopyBtnPadding.PaddingLeft = UDim.new(0, 4)
CopyBtnPadding.PaddingBottom = UDim.new(0, 4)
CopyBtnPadding.Parent = CopyBtn

local SearchContent = Instance.new("CanvasGroup")
SearchContent.Visible = false
SearchContent.BorderSizePixel = 0
SearchContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchContent.Size = UDim2.new(1, 0, 1, 0)
SearchContent.Name = "SearchContent"
SearchContent.LayoutOrder = 2
SearchContent.BackgroundTransparency = 0.3
SearchContent.Parent = Pages

local SearchContentPadding = Instance.new("UIPadding")
SearchContentPadding.PaddingTop = UDim.new(0, 6)
SearchContentPadding.PaddingRight = UDim.new(0, 6)
SearchContentPadding.Name = "SearchContentPadding"
SearchContentPadding.PaddingLeft = UDim.new(0, 6)
SearchContentPadding.PaddingBottom = UDim.new(0, 6)
SearchContentPadding.Parent = SearchContent

local SearchContentLayout = Instance.new("UIListLayout")
SearchContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SearchContentLayout.Padding = UDim.new(0, 6)
SearchContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchContentLayout.Name = "SearchContentLayout"
SearchContentLayout.Parent = SearchContent

NewCorner("", "SearchContentCorner", SearchContent)

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BorderSizePixel = 0
SearchBox.TextWrapped = true
SearchBox.TextSize = 12
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextYAlignment = Enum.TextYAlignment.Top
SearchBox.TextScaled = true
SearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchBox.FontFace = GothamMedium
SearchBox.PlaceholderText = "Search scripts..."
SearchBox.Size = UDim2.new(0, 250, 0, 18)
SearchBox.Position = UDim2.new(0, 90, 0, 52)
SearchBox.Text = ""
SearchBox.LayoutOrder = 1
SearchBox.BackgroundTransparency = 0.5
SearchBox.Parent = SearchContent

local SearchBoxPadding = Instance.new("UIPadding")
SearchBoxPadding.PaddingTop = UDim.new(0, 6)
SearchBoxPadding.PaddingRight = UDim.new(0, 6)
SearchBoxPadding.Name = "SearchBoxPadding"
SearchBoxPadding.PaddingLeft = UDim.new(0, 6)
SearchBoxPadding.PaddingBottom = UDim.new(0, 6)
SearchBoxPadding.Parent = SearchBox

local SearchBoxStroke = Instance.new("UIStroke")
SearchBoxStroke.Transparency = 0.8
SearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchBoxStroke.Name = "SearchBoxStroke"
SearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
SearchBoxStroke.Parent = SearchBox

local WebsiteLabel = Instance.new("TextLabel")
WebsiteLabel.TextWrapped = true
WebsiteLabel.BorderSizePixel = 0
WebsiteLabel.TextXAlignment = Enum.TextXAlignment.Right
WebsiteLabel.TextTransparency = 0.5
WebsiteLabel.TextScaled = true
WebsiteLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WebsiteLabel.FontFace = GothamMedium
WebsiteLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WebsiteLabel.BackgroundTransparency = 1
WebsiteLabel.Size = UDim2.new(1, 0, 1, 0)
WebsiteLabel.Text = "Powered by ScriptBlox.com"
WebsiteLabel.Name = "WebsiteLabel"
WebsiteLabel.Parent = SearchBox

NewCorner("", "SearchBoxCorner", SearchBox)

local SearchBoxSizeCons = Instance.new("UISizeConstraint")
SearchBoxSizeCons.Name = "SearchBoxSizeCons"
SearchBoxSizeCons.MinSize = Vector2.new(0, 30)
SearchBoxSizeCons.MaxSize = Vector2.new(10000, 30)
SearchBoxSizeCons.Parent = SearchBox

local SearchResults = Instance.new("ScrollingFrame")
SearchResults.ScrollingDirection = Enum.ScrollingDirection.Y
SearchResults.BorderSizePixel = 0
SearchResults.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchResults.Name = "SearchResults"
SearchResults.AutomaticCanvasSize = Enum.AutomaticSize.Y
SearchResults.Size = UDim2.new(1, 0, 1, 0)
SearchResults.ScrollBarThickness = 0
SearchResults.LayoutOrder = 2
SearchResults.BackgroundTransparency = 1
SearchResults.Parent = SearchContent

local SearchResultsPadding = Instance.new("UIPadding")
SearchResultsPadding.Name = "SearchResultsPadding"
SearchResultsPadding.PaddingTop = UDim.new(0, 2)
SearchResultsPadding.PaddingBottom = UDim.new(0, 2)
SearchResultsPadding.PaddingLeft = UDim.new(0, 2)
SearchResultsPadding.PaddingRight = UDim.new(0, 2)
SearchResultsPadding.Parent = SearchResults

local SearchResultsListLayout = Instance.new("UIListLayout")
SearchResultsListLayout.Name = "SearchResultsListLayout"
SearchResultsListLayout.FillDirection = Enum.FillDirection.Vertical
SearchResultsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchResultsListLayout.Wraps = false
SearchResultsListLayout.Padding = UDim.new(0, 8)
SearchResultsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SearchResultsListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchResultsListLayout.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
SearchResultsListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SearchResultsListLayout.VerticalFlex = Enum.UIFlexAlignment.None
SearchResultsListLayout.Parent = SearchResults

local SearchResultTemplate = Instance.new("CanvasGroup")
SearchResultTemplate.BorderSizePixel = 0
SearchResultTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchResultTemplate.Size = UDim2.new(0, 358, 0, 132)
SearchResultTemplate.Name = "SearchResultTemplate"
SearchResultTemplate.BackgroundTransparency = 0.5
SearchResultTemplate.Visible = false
SearchResultTemplate.Parent = SearchResults

NewCorner("", "SearchResultTemplateCorner", SearchResultTemplate)

local SearchResultTemplateStroke = Instance.new("UIStroke")
SearchResultTemplateStroke.Transparency = 0.8
SearchResultTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchResultTemplateStroke.Name = "SearchResultTemplateStroke"
SearchResultTemplateStroke.Color = Color3.fromRGB(255, 255, 255)
SearchResultTemplateStroke.Parent = SearchResultTemplate

local ScriptImage = Instance.new("ImageLabel")
ScriptImage.BorderSizePixel = 0
ScriptImage.ScaleType = Enum.ScaleType.Crop
ScriptImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptImage.BackgroundTransparency = 1
ScriptImage.Image = ""
ScriptImage.Size = UDim2.new(1, 0, 0.7, -2)
ScriptImage.LayoutOrder = 1
ScriptImage.Name = "ScriptImage"
ScriptImage.Parent = SearchResultTemplate

local Container = Instance.new("Frame")
Container.BorderSizePixel = 0
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.Size = UDim2.new(1, 0, 1, 0)
Container.Name = "Container"
Container.LayoutOrder = 2
Container.BackgroundTransparency = 1
Container.Parent = SearchResultTemplate

local ScriptName = Instance.new("TextLabel")
ScriptName.TextWrapped = true
ScriptName.BorderSizePixel = 0
ScriptName.TextXAlignment = Enum.TextXAlignment.Left
ScriptName.TextScaled = true
ScriptName.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScriptName.FontFace = GothamMedium
ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptName.BackgroundTransparency = 1
ScriptName.Size = UDim2.new(0, 350, 0, 30)
ScriptName.Name = "ScriptName"
ScriptName.Position = UDim2.new(0, 4, 0, 0)
ScriptName.Parent = Container

NewCorner("", "ScriptNameCorner", ScriptName)

local ScriptNameStroke = Instance.new("UIStroke")
ScriptNameStroke.Transparency = 0.5
ScriptNameStroke.Name = "ScriptNameStroke"
ScriptNameStroke.Parent = ScriptName

local ScriptActions = Instance.new("Frame")
ScriptActions.BorderSizePixel = 0
ScriptActions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptActions.Size = UDim2.new(1, 0, 0.3, 0)
ScriptActions.Position = UDim2.new(0, 0, 0, 92)
ScriptActions.Name = "ScriptActions"
ScriptActions.BackgroundTransparency = 1
ScriptActions.Parent = Container

local ScriptActionsLayout = Instance.new("UIListLayout")
ScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ScriptActionsLayout.Padding = UDim.new(0, 6)
ScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScriptActionsLayout.Name = "ScriptActionsLayout"
ScriptActionsLayout.FillDirection = Enum.FillDirection.Horizontal
ScriptActionsLayout.Parent = ScriptActions

local ScriptActionsPadding = Instance.new("UIPadding")
ScriptActionsPadding.PaddingTop = UDim.new(0, 4)
ScriptActionsPadding.PaddingRight = UDim.new(0, 6)
ScriptActionsPadding.Name = "ScriptActionsPadding"
ScriptActionsPadding.PaddingLeft = UDim.new(0, 6)
ScriptActionsPadding.PaddingBottom = UDim.new(0, 6)
ScriptActionsPadding.Parent = ScriptActions

local RunScript = Instance.new("TextButton")
RunScript.TextWrapped = true
RunScript.BorderSizePixel = 0
RunScript.TextScaled = true
RunScript.TextColor3 = Color3.fromRGB(255, 255, 255)
RunScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RunScript.FontFace = GothamMedium
RunScript.BackgroundTransparency = 0.5
RunScript.Size = UDim2.new(0.2, 0, 0.3, 0)
RunScript.LayoutOrder = 1
RunScript.Text = "Run"
RunScript.Name = "RunScript"
RunScript.Parent = ScriptActions

local RunScriptStroke = Instance.new("UIStroke")
RunScriptStroke.Transparency = 0.8
RunScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RunScriptStroke.Name = "RunScriptStroke"
RunScriptStroke.Color = Color3.fromRGB(255, 255, 255)
RunScriptStroke.Parent = RunScript

NewCorner("", "RunScriptCorner", RunScript)

local RunScriptPadding = Instance.new("UIPadding")
RunScriptPadding.PaddingTop = UDim.new(0, 2)
RunScriptPadding.PaddingRight = UDim.new(0, 2)
RunScriptPadding.Name = "RunScriptPadding"
RunScriptPadding.PaddingLeft = UDim.new(0, 2)
RunScriptPadding.PaddingBottom = UDim.new(0, 2)
RunScriptPadding.Parent = RunScript

local CopyScriptBtn = Instance.new("TextButton")
CopyScriptBtn.TextWrapped = true
CopyScriptBtn.BorderSizePixel = 0
CopyScriptBtn.TextScaled = true
CopyScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CopyScriptBtn.FontFace = GothamMedium
CopyScriptBtn.BackgroundTransparency = 0.5
CopyScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
CopyScriptBtn.LayoutOrder = 2
CopyScriptBtn.Text = "Copy"
CopyScriptBtn.Name = "CopyScriptBtn"
CopyScriptBtn.Parent = ScriptActions

local CopyScriptBtnStroke = Instance.new("UIStroke")
CopyScriptBtnStroke.Transparency = 0.8
CopyScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CopyScriptBtnStroke.Name = "CopyScriptBtnStroke"
CopyScriptBtnStroke.Color = Color3.fromRGB(255, 255, 255)
CopyScriptBtnStroke.Parent = CopyScriptBtn

NewCorner("", "CopyScriptBtnCorner", CopyScriptBtn)

local CopyScriptBtnPadding = Instance.new("UIPadding")
CopyScriptBtnPadding.PaddingTop = UDim.new(0, 2)
CopyScriptBtnPadding.PaddingRight = UDim.new(0, 2)
CopyScriptBtnPadding.Name = "CopyScriptBtnPadding"
CopyScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
CopyScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
CopyScriptBtnPadding.Parent = CopyScriptBtn

local SaveScriptBtn = Instance.new("TextButton")
SaveScriptBtn.TextWrapped = true
SaveScriptBtn.BorderSizePixel = 0
SaveScriptBtn.TextScaled = true
SaveScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SaveScriptBtn.FontFace = GothamMedium
SaveScriptBtn.BackgroundTransparency = 0.5
SaveScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
SaveScriptBtn.LayoutOrder = 3
SaveScriptBtn.Text = "Save"
SaveScriptBtn.Name = "SaveScriptBtn"
SaveScriptBtn.Parent = ScriptActions

local SaveScriptBtnStroke = Instance.new("UIStroke")
SaveScriptBtnStroke.Transparency = 0.8
SaveScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SaveScriptBtnStroke.Name = "SaveScriptBtnStroke"
SaveScriptBtnStroke.Color = Color3.fromRGB(255, 255, 255)
SaveScriptBtnStroke.Parent = SaveScriptBtn

NewCorner("", "SaveScriptBtnCorner", SaveScriptBtn)

local SaveScriptBtnPadding = Instance.new("UIPadding")
SaveScriptBtnPadding.PaddingTop = UDim.new(0, 2)
SaveScriptBtnPadding.PaddingRight = UDim.new(0, 2)
SaveScriptBtnPadding.Name = "SaveScriptBtnPadding"
SaveScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
SaveScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
SaveScriptBtnPadding.Parent = SaveScriptBtn

local NoResultsLabel = Instance.new("TextLabel")
NoResultsLabel.TextWrapped = true
NoResultsLabel.BorderSizePixel = 0
NoResultsLabel.TextXAlignment = Enum.TextXAlignment.Center
NoResultsLabel.TextScaled = true
NoResultsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoResultsLabel.FontFace = GothamMedium
NoResultsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoResultsLabel.BackgroundTransparency = 1
NoResultsLabel.Size = UDim2.new(1, 0, 0, 30)
NoResultsLabel.Text = "No scripts found matching your query."
NoResultsLabel.Name = "NoResultsLabel"
NoResultsLabel.Visible = false
NoResultsLabel.Parent = SearchResults

local SavedScriptsContent = Instance.new("CanvasGroup")
SavedScriptsContent.Visible = false
SavedScriptsContent.BorderSizePixel = 0
SavedScriptsContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsContent.Size = UDim2.new(1, 0, 1, 0)
SavedScriptsContent.Name = "SavedScriptsContent"
SavedScriptsContent.LayoutOrder = 3
SavedScriptsContent.BackgroundTransparency = 0.3
SavedScriptsContent.Parent = Pages

local SavedScriptsPadding = Instance.new("UIPadding")
SavedScriptsPadding.PaddingTop = UDim.new(0, 6)
SavedScriptsPadding.PaddingRight = UDim.new(0, 6)
SavedScriptsPadding.Name = "SavedScriptsPadding"
SavedScriptsPadding.PaddingLeft = UDim.new(0, 6)
SavedScriptsPadding.PaddingBottom = UDim.new(0, 6)
SavedScriptsPadding.Parent = SavedScriptsContent

local SavedScriptsLayout = Instance.new("UIListLayout")
SavedScriptsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsLayout.Padding = UDim.new(0, 6)
SavedScriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptsLayout.Name = "SavedScriptsLayout"
SavedScriptsLayout.Parent = SavedScriptsContent

NewCorner("", "SavedScriptsContentCorner", SavedScriptsContent)

local SavedScriptsStroke = Instance.new("UIStroke")
SavedScriptsStroke.Transparency = 0.8
SavedScriptsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptsStroke.Name = "SavedScriptsStroke"
SavedScriptsStroke.Parent = SavedScriptsContent

local SavedScriptsSearchBox = Instance.new("TextBox")
SavedScriptsSearchBox.Name = "SavedScriptsSearchBox"
SavedScriptsSearchBox.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptsSearchBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBox.BorderSizePixel = 0
SavedScriptsSearchBox.TextWrapped = true
SavedScriptsSearchBox.TextSize = 12
SavedScriptsSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBox.TextYAlignment = Enum.TextYAlignment.Top
SavedScriptsSearchBox.TextScaled = true
SavedScriptsSearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsSearchBox.FontFace = GothamMedium
SavedScriptsSearchBox.PlaceholderText = "Search saved scripts..."
SavedScriptsSearchBox.Size = UDim2.new(1, -42, 0, 24)
SavedScriptsSearchBox.Position = UDim2.new(0, 6, 0, 6)
SavedScriptsSearchBox.Text = ""
SavedScriptsSearchBox.ZIndex = 2
SavedScriptsSearchBox.BackgroundTransparency = 0.5
SavedScriptsSearchBox.Parent = SavedScriptsContent

local SavedScriptsSearchBoxPadding = Instance.new("UIPadding")
SavedScriptsSearchBoxPadding.PaddingTop = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.PaddingRight = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.Name = "SavedScriptsSearchBoxPadding"
SavedScriptsSearchBoxPadding.PaddingLeft = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.PaddingBottom = UDim.new(0, 6)
SavedScriptsSearchBoxPadding.Parent = SavedScriptsSearchBox

local SavedScriptsSearchBoxStroke = Instance.new("UIStroke")
SavedScriptsSearchBoxStroke.Transparency = 0.8
SavedScriptsSearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptsSearchBoxStroke.Name = "SavedScriptsSearchBoxStroke"
SavedScriptsSearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
SavedScriptsSearchBoxStroke.Parent = SavedScriptsSearchBox

NewCorner("", "SavedScriptsSearchBoxCorner", SavedScriptsSearchBox)

local SavedScriptsSearchBoxSizeCons = Instance.new("UISizeConstraint")
SavedScriptsSearchBoxSizeCons.Name = "SavedScriptsSearchBoxSizeCons"
SavedScriptsSearchBoxSizeCons.MinSize = Vector2.new(0, 30)
SavedScriptsSearchBoxSizeCons.MaxSize = Vector2.new(10000, 30)
SavedScriptsSearchBoxSizeCons.Parent = SavedScriptsSearchBox

local NewScriptBtn = Instance.new("TextButton")
NewScriptBtn.TextWrapped = true
NewScriptBtn.BorderSizePixel = 0
NewScriptBtn.TextScaled = true
NewScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NewScriptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewScriptBtn.FontFace = GothamBold
NewScriptBtn.AnchorPoint = Vector2.new(1, 0.5)
NewScriptBtn.BackgroundTransparency = 1
NewScriptBtn.Size = UDim2.new(1, 0, 1, 0)
NewScriptBtn.Text = "+"
NewScriptBtn.Name = "NewScriptBtn"
NewScriptBtn.Position = UDim2.new(1, 0, 0.5, 0)
NewScriptBtn.Parent = SavedScriptsSearchBox

Instance.new("UIAspectRatioConstraint", NewScriptBtn).Name = "NewScriptRatio"

local SavedScriptsScroll = Instance.new("ScrollingFrame")
SavedScriptsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
SavedScriptsScroll.BorderSizePixel = 0
SavedScriptsScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptsScroll.Name = "SavedScriptsScroll"
SavedScriptsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SavedScriptsScroll.Size = UDim2.new(1, 0, 1, -36)
SavedScriptsScroll.Position = UDim2.new(0, 0, 0, 36)
SavedScriptsScroll.ScrollBarThickness = 0
SavedScriptsScroll.BackgroundTransparency = 1
SavedScriptsScroll.Parent = SavedScriptsContent

local SavedScriptsScrollPadding = Instance.new("UIPadding")
SavedScriptsScrollPadding.Name = "SavedScriptsScrollPadding"
SavedScriptsScrollPadding.PaddingTop = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingBottom = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingLeft = UDim.new(0, 2)
SavedScriptsScrollPadding.PaddingRight = UDim.new(0, 2)
SavedScriptsScrollPadding.Parent = SavedScriptsScroll

local SavedScriptsScrollListLayout = Instance.new("UIListLayout")
SavedScriptsScrollListLayout.Name = "SavedScriptsScrollListLayout"
SavedScriptsScrollListLayout.FillDirection = Enum.FillDirection.Vertical
SavedScriptsScrollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptsScrollListLayout.Wraps = false
SavedScriptsScrollListLayout.Padding = UDim.new(0, 8)
SavedScriptsScrollListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SavedScriptsScrollListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptsScrollListLayout.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
SavedScriptsScrollListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SavedScriptsScrollListLayout.VerticalFlex = Enum.UIFlexAlignment.None
SavedScriptsScrollListLayout.Parent = SavedScriptsScroll

local SavedScriptTemplate = Instance.new("Frame")
SavedScriptTemplate.BorderSizePixel = 0
SavedScriptTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SavedScriptTemplate.Size = UDim2.new(0, 166, 0, 64)
SavedScriptTemplate.Name = "SavedScriptTemplate"
SavedScriptTemplate.BackgroundTransparency = 0.5
SavedScriptTemplate.Visible = false
SavedScriptTemplate.Parent = SavedScriptsScroll

local SavedScriptTemplateLayout = Instance.new("UIListLayout")
SavedScriptTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptTemplateLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptTemplateLayout.Padding = UDim.new(0, 2)
SavedScriptTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptTemplateLayout.Name = "SavedScriptTemplateLayout"
SavedScriptTemplateLayout.FillDirection = Enum.FillDirection.Horizontal
SavedScriptTemplateLayout.Parent = SavedScriptTemplate

NewCorner("", "SavedScriptTemplateCorner", SavedScriptTemplate)

local SavedScriptTemplateStroke = Instance.new("UIStroke")
SavedScriptTemplateStroke.Transparency = 0.8
SavedScriptTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SavedScriptTemplateStroke.Name = "SavedScriptTemplateStroke"
SavedScriptTemplateStroke.Color = Color3.fromRGB(255, 255, 255)
SavedScriptTemplateStroke.Parent = SavedScriptTemplate

local SavedScriptInfo = Instance.new("Frame")
SavedScriptInfo.BorderSizePixel = 0
SavedScriptInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptInfo.Size = UDim2.new(0, 380, 0, 12)
SavedScriptInfo.Name = "SavedScriptInfo"
SavedScriptInfo.LayoutOrder = 1
SavedScriptInfo.BackgroundTransparency = 1
SavedScriptInfo.Parent = SavedScriptTemplate

local SavedScriptInfoLayout = Instance.new("UIListLayout")
SavedScriptInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptInfoLayout.Padding = UDim.new(0, 2)
SavedScriptInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptInfoLayout.Name = "SavedScriptInfoLayout"
SavedScriptInfoLayout.Parent = SavedScriptInfo

local SavedScriptInfoPadding = Instance.new("UIPadding")
SavedScriptInfoPadding.PaddingTop = UDim.new(0, 4)
SavedScriptInfoPadding.PaddingRight = UDim.new(0, 4)
SavedScriptInfoPadding.Name = "SavedScriptInfoPadding"
SavedScriptInfoPadding.PaddingLeft = UDim.new(0, 4)
SavedScriptInfoPadding.PaddingBottom = UDim.new(0, 4)
SavedScriptInfoPadding.Parent = SavedScriptInfo

local SavedScriptTitle = Instance.new("TextLabel")
SavedScriptTitle.TextWrapped = true
SavedScriptTitle.BorderSizePixel = 0
SavedScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptTitle.TextScaled = true
SavedScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptTitle.FontFace = GothamBold
SavedScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptTitle.BackgroundTransparency = 1
SavedScriptTitle.Size = UDim2.new(0.2, 0, 0.3, 0)
SavedScriptTitle.Text = "Script name"
SavedScriptTitle.LayoutOrder = 1
SavedScriptTitle.Name = "SavedScriptTitle"
SavedScriptTitle.Parent = SavedScriptInfo

local SavedScriptTitlePadding = Instance.new("UIPadding")
SavedScriptTitlePadding.PaddingTop = UDim.new(0, 4)
SavedScriptTitlePadding.PaddingRight = UDim.new(0, 4)
SavedScriptTitlePadding.Name = "SavedScriptTitlePadding"
SavedScriptTitlePadding.PaddingLeft = UDim.new(0, 4)
SavedScriptTitlePadding.PaddingBottom = UDim.new(0, 4)
SavedScriptTitlePadding.Parent = SavedScriptTitle

local SavedScriptDesc = Instance.new("TextLabel")
SavedScriptDesc.TextWrapped = true
SavedScriptDesc.BorderSizePixel = 0
SavedScriptDesc.TextXAlignment = Enum.TextXAlignment.Left
SavedScriptDesc.TextScaled = true
SavedScriptDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptDesc.FontFace = GothamMedium
SavedScriptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptDesc.BackgroundTransparency = 1
SavedScriptDesc.Size = UDim2.new(0, 76, 0, 0)
SavedScriptDesc.Text = "Script description"
SavedScriptDesc.LayoutOrder = 2
SavedScriptDesc.Name = "SavedScriptDesc"
SavedScriptDesc.Parent = SavedScriptInfo

local SavedScriptActions = Instance.new("Frame")
SavedScriptActions.BorderSizePixel = 0
SavedScriptActions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SavedScriptActions.Size = UDim2.new(0, 0, 0, 12)
SavedScriptActions.Position = UDim2.new(0, 34, 0, 0)
SavedScriptActions.Name = "SavedScriptActions"
SavedScriptActions.LayoutOrder = 2
SavedScriptActions.BackgroundTransparency = 1
SavedScriptActions.Parent = SavedScriptTemplate

local SavedScriptActionsLayout = Instance.new("UIListLayout")
SavedScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SavedScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SavedScriptActionsLayout.Padding = UDim.new(0, 6)
SavedScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedScriptActionsLayout.Name = "SavedScriptActionsLayout"
SavedScriptActionsLayout.Parent = SavedScriptActions

local SavedScriptActionsPadding = Instance.new("UIPadding")
SavedScriptActionsPadding.PaddingTop = UDim.new(0, 4)
SavedScriptActionsPadding.PaddingRight = UDim.new(0, 4)
SavedScriptActionsPadding.Name = "SavedScriptActionsPadding"
SavedScriptActionsPadding.PaddingLeft = UDim.new(0, 4)
SavedScriptActionsPadding.PaddingBottom = UDim.new(0, 4)
SavedScriptActionsPadding.Parent = SavedScriptActions

local RunSavedScript = Instance.new("TextButton")
RunSavedScript.TextWrapped = true
RunSavedScript.BorderSizePixel = 0
RunSavedScript.TextScaled = true
RunSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
RunSavedScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RunSavedScript.FontFace = GothamMedium
RunSavedScript.BackgroundTransparency = 0.5
RunSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
RunSavedScript.LayoutOrder = 1
RunSavedScript.Text = "Run"
RunSavedScript.Name = "RunSavedScript"
RunSavedScript.Parent = SavedScriptActions

local RunSavedScriptStroke = Instance.new("UIStroke")
RunSavedScriptStroke.Transparency = 0.8
RunSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RunSavedScriptStroke.Name = "RunSavedScriptStroke"
RunSavedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
RunSavedScriptStroke.Parent = RunSavedScript

NewCorner("", "RunSavedScriptCorner", RunSavedScript)

local RunSavedScriptPadding = Instance.new("UIPadding")
RunSavedScriptPadding.PaddingTop = UDim.new(0, 2)
RunSavedScriptPadding.PaddingRight = UDim.new(0, 2)
RunSavedScriptPadding.Name = "RunSavedScriptPadding"
RunSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
RunSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
RunSavedScriptPadding.Parent = RunSavedScript

local DeleteSavedScript = Instance.new("TextButton")
DeleteSavedScript.TextWrapped = true
DeleteSavedScript.BorderSizePixel = 0
DeleteSavedScript.TextScaled = true
DeleteSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteSavedScript.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DeleteSavedScript.FontFace = GothamMedium
DeleteSavedScript.BackgroundTransparency = 0.5
DeleteSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
DeleteSavedScript.LayoutOrder = 2
DeleteSavedScript.Text = "Delete"
DeleteSavedScript.Name = "DeleteSavedScript"
DeleteSavedScript.Parent = SavedScriptActions

local DeleteSavedScriptStroke = Instance.new("UIStroke")
DeleteSavedScriptStroke.Transparency = 0.8
DeleteSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DeleteSavedScriptStroke.Name = "DeleteSavedScriptStroke"
DeleteSavedScriptStroke.Color = Color3.fromRGB(255, 255, 255)
DeleteSavedScriptStroke.Parent = DeleteSavedScript

NewCorner("", "DeleteSavedScriptCorner", DeleteSavedScript)

local DeleteSavedScriptPadding = Instance.new("UIPadding")
DeleteSavedScriptPadding.PaddingTop = UDim.new(0, 2)
DeleteSavedScriptPadding.PaddingRight = UDim.new(0, 2)
DeleteSavedScriptPadding.Name = "DeleteSavedScriptPadding"
DeleteSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
DeleteSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
DeleteSavedScriptPadding.Parent = DeleteSavedScript

local NoSavedScriptsLabel = Instance.new("TextLabel")
NoSavedScriptsLabel.TextWrapped = true
NoSavedScriptsLabel.BorderSizePixel = 0
NoSavedScriptsLabel.TextXAlignment = Enum.TextXAlignment.Center
NoSavedScriptsLabel.TextScaled = true
NoSavedScriptsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoSavedScriptsLabel.FontFace = GothamMedium
NoSavedScriptsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoSavedScriptsLabel.BackgroundTransparency = 1
NoSavedScriptsLabel.Size = UDim2.new(1, 0, 0, 30)
NoSavedScriptsLabel.Text = "No Saved Scripts! Save Some Scripts to use this tab."
NoSavedScriptsLabel.Name = "NoSavedScriptsLabel"
NoSavedScriptsLabel.Visible = true
NoSavedScriptsLabel.Parent = SavedScriptsScroll

local SidebarContainer = Instance.new("Frame")
SidebarContainer.BorderSizePixel = 0
SidebarContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SidebarContainer.Size = UDim2.new(0.2, 0, 0.3, 0)
SidebarContainer.Position = UDim2.new(0, 250, 0, 30)
SidebarContainer.Name = "SidebarContainer"
SidebarContainer.LayoutOrder = 2
SidebarContainer.BackgroundTransparency = 1
SidebarContainer.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.AnchorPoint = Vector2.new(1, 0.5)
Sidebar.Size = UDim2.new(1, 0, 1, -8)
Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
Sidebar.Name = "Sidebar"
Sidebar.BackgroundTransparency = 0.3
Sidebar.Parent = SidebarContainer

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SidebarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Name = "SidebarLayout"
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 16)
SidebarPadding.Name = "SidebarPadding"
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingBottom = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

NewCorner("", "SidebarCorner", Sidebar)

local SidebarSizeCons = Instance.new("UISizeConstraint")
SidebarSizeCons.Name = "SidebarSizeCons"
SidebarSizeCons.MaxSize = Vector2.new(5000, 5000)
SidebarSizeCons.Parent = Sidebar

local Topbar = Instance.new("Frame")
Topbar.BorderSizePixel = 0
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.Size = UDim2.new(0.2, 0, 0.3, 0)
Topbar.Name = "Topbar"
Topbar.LayoutOrder = -1
Topbar.BackgroundTransparency = 1
Topbar.Parent = Sidebar

local TopbarLayout = Instance.new("UIListLayout")
TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.Padding = UDim.new(0, 4)
TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopbarLayout.Name = "TopbarLayout"
TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
TopbarLayout.Parent = Topbar

local TopbarSizeCons = Instance.new("UISizeConstraint")
TopbarSizeCons.MinSize = Vector2.new(0, 28)
TopbarSizeCons.Name = "TopbarSizeCons"
TopbarSizeCons.MaxSize = Vector2.new(10000, 30)
TopbarSizeCons.Parent = Topbar

local Logo = Instance.new("ImageLabel")
Logo.BorderSizePixel = 0
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.ImageColor3 = Color3.fromRGB(241, 241, 241)
Logo.Image = GetAsset("Lucid/Assets/lucid_logo.png")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.BackgroundTransparency = 1
Logo.LayoutOrder = 1
Logo.Name = "Logo"
Logo.Parent = Topbar

Instance.new("UIAspectRatioConstraint", Logo).Name = "LogoRatio"

local Title = Instance.new("TextLabel")
Title.TextWrapped = true
Title.BorderSizePixel = 0
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = BuilderSans
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 60, 0, 30)
Title.Text = "Lucid"
Title.LayoutOrder = 2
Title.Name = "Title"
Title.Parent = Topbar

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingTop = UDim.new(0, 2)
TitlePadding.Name = "TitlePadding"
TitlePadding.PaddingBottom = UDim.new(0, 2)
TitlePadding.Parent = Title

local ExeTab = Instance.new("TextButton")
ExeTab.BorderSizePixel = 0
ExeTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeTab.BackgroundTransparency = 1
ExeTab.Size = UDim2.new(0.2, 0, 0.3, 0)
ExeTab.LayoutOrder = 1
ExeTab.Text = ""
ExeTab.Name = "ExeTab"
ExeTab.Parent = Sidebar

local ExeTabLayout = Instance.new("UIListLayout")
ExeTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ExeTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ExeTabLayout.Padding = UDim.new(0, 4)
ExeTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExeTabLayout.Name = "ExeTabLayout"
ExeTabLayout.FillDirection = Enum.FillDirection.Horizontal
ExeTabLayout.Parent = ExeTab

local ExeTabPadding = Instance.new("UIPadding")
ExeTabPadding.PaddingTop = UDim.new(0, 3)
ExeTabPadding.Name = "ExeTabPadding"
ExeTabPadding.PaddingBottom = UDim.new(0, 3)
ExeTabPadding.Parent = ExeTab

local ExeTabSizeCons = Instance.new("UISizeConstraint")
ExeTabSizeCons.MinSize = Vector2.new(0, 28)
ExeTabSizeCons.Name = "ExeTabSizeCons"
ExeTabSizeCons.MaxSize = Vector2.new(10000, 30)
ExeTabSizeCons.Parent = ExeTab

local TabIconExe = Instance.new("ImageLabel")
TabIconExe.BorderSizePixel = 0
TabIconExe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconExe.Image = GetAsset("Lucid/Assets/lucid_executor.png")
TabIconExe.Size = UDim2.new(0, 30, 0, 30)
TabIconExe.BackgroundTransparency = 1
TabIconExe.LayoutOrder = 1
TabIconExe.Name = "TabIcon"
TabIconExe.Parent = ExeTab

Instance.new("UIAspectRatioConstraint", TabIconExe).Name = "TabIconRatio"

local TabLabelExe = Instance.new("TextLabel")
TabLabelExe.TextWrapped = true
TabLabelExe.BorderSizePixel = 0
TabLabelExe.TextXAlignment = Enum.TextXAlignment.Left
TabLabelExe.TextScaled = true
TabLabelExe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelExe.FontFace = BuilderSans
TabLabelExe.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelExe.BackgroundTransparency = 1
TabLabelExe.Size = UDim2.new(0, 60, 0, 30)
TabLabelExe.Text = "Executor"
TabLabelExe.LayoutOrder = 2
TabLabelExe.Name = "TabLabel"
TabLabelExe.Parent = ExeTab

local SearchTab = Instance.new("TextButton")
SearchTab.BorderSizePixel = 0
SearchTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchTab.BackgroundTransparency = 1
SearchTab.Size = UDim2.new(0.2, 0, 0.3, 0)
SearchTab.LayoutOrder = 2
SearchTab.Text = ""
SearchTab.Name = "SearchTab"
SearchTab.Parent = Sidebar

local SearchTabLayout = Instance.new("UIListLayout")
SearchTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
SearchTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
SearchTabLayout.Padding = UDim.new(0, 4)
SearchTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchTabLayout.Name = "SearchTabLayout"
SearchTabLayout.FillDirection = Enum.FillDirection.Horizontal
SearchTabLayout.Parent = SearchTab

local SearchTabPadding = Instance.new("UIPadding")
SearchTabPadding.PaddingTop = UDim.new(0, 3)
SearchTabPadding.Name = "SearchTabPadding"
SearchTabPadding.PaddingBottom = UDim.new(0, 3)
SearchTabPadding.Parent = SearchTab

local SearchTabSizeCons = Instance.new("UISizeConstraint")
SearchTabSizeCons.MinSize = Vector2.new(0, 28)
SearchTabSizeCons.Name = "SearchTabSizeCons"
SearchTabSizeCons.MaxSize = Vector2.new(10000, 30)
SearchTabSizeCons.Parent = SearchTab

local TabIconSearch = Instance.new("ImageLabel")
TabIconSearch.BorderSizePixel = 0
TabIconSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconSearch.Image = GetAsset("Lucid/Assets/lucid_search.png")
TabIconSearch.Size = UDim2.new(0, 30, 0, 30)
TabIconSearch.BackgroundTransparency = 1
TabIconSearch.LayoutOrder = 1
TabIconSearch.Name = "TabIcon"
TabIconSearch.Parent = SearchTab

Instance.new("UIAspectRatioConstraint", TabIconSearch).Name = "TabIconRatio"

local TabLabelSearch = Instance.new("TextLabel")
TabLabelSearch.TextWrapped = true
TabLabelSearch.BorderSizePixel = 0
TabLabelSearch.TextXAlignment = Enum.TextXAlignment.Left
TabLabelSearch.TextScaled = true
TabLabelSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelSearch.FontFace = BuilderSans
TabLabelSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelSearch.BackgroundTransparency = 1
TabLabelSearch.Size = UDim2.new(0, 60, 0, 30)
TabLabelSearch.Text = "Search"
TabLabelSearch.LayoutOrder = 2
TabLabelSearch.Name = "TabLabel"
TabLabelSearch.Parent = SearchTab

local ScriptsTab = Instance.new("TextButton")
ScriptsTab.BorderSizePixel = 0
ScriptsTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptsTab.BackgroundTransparency = 1
ScriptsTab.Size = UDim2.new(0.2, 0, 0.3, 0)
ScriptsTab.LayoutOrder = 3
ScriptsTab.Text = ""
ScriptsTab.Name = "ScriptsTab"
ScriptsTab.Parent = Sidebar

local ScriptsTabLayout = Instance.new("UIListLayout")
ScriptsTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ScriptsTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ScriptsTabLayout.Padding = UDim.new(0, 4)
ScriptsTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScriptsTabLayout.Name = "ScriptsTabLayout"
ScriptsTabLayout.FillDirection = Enum.FillDirection.Horizontal
ScriptsTabLayout.Parent = ScriptsTab

local ScriptsTabPadding = Instance.new("UIPadding")
ScriptsTabPadding.PaddingTop = UDim.new(0, 3)
ScriptsTabPadding.Name = "ScriptsTabPadding"
ScriptsTabPadding.PaddingBottom = UDim.new(0, 3)
ScriptsTabPadding.Parent = ScriptsTab

local ScriptsTabSizeCons = Instance.new("UISizeConstraint")
ScriptsTabSizeCons.MinSize = Vector2.new(0, 28)
ScriptsTabSizeCons.Name = "ScriptsTabSizeCons"
ScriptsTabSizeCons.MaxSize = Vector2.new(10000, 30)
ScriptsTabSizeCons.Parent = ScriptsTab

local TabIconScripts = Instance.new("ImageLabel")
TabIconScripts.BorderSizePixel = 0
TabIconScripts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconScripts.Image = GetAsset("Lucid/Assets/lucid_scripts.png")
TabIconScripts.Size = UDim2.new(0, 30, 0, 30)
TabIconScripts.BackgroundTransparency = 1
TabIconScripts.LayoutOrder = 1
TabIconScripts.Name = "TabIcon"
TabIconScripts.Parent = ScriptsTab

Instance.new("UIAspectRatioConstraint", TabIconScripts).Name = "TabIconRatio"

local TabLabelScripts = Instance.new("TextLabel")
TabLabelScripts.TextWrapped = true
TabLabelScripts.BorderSizePixel = 0
TabLabelScripts.TextXAlignment = Enum.TextXAlignment.Left
TabLabelScripts.TextScaled = true
TabLabelScripts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelScripts.FontFace = BuilderSans
TabLabelScripts.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelScripts.BackgroundTransparency = 1
TabLabelScripts.Size = UDim2.new(0, 60, 0, 30)
TabLabelScripts.Text = "Scripts"
TabLabelScripts.LayoutOrder = 2
TabLabelScripts.Name = "TabLabel"
TabLabelScripts.Parent = ScriptsTab

local CloseTab = Instance.new("TextButton")
CloseTab.BorderSizePixel = 0
CloseTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseTab.BackgroundTransparency = 1
CloseTab.Size = UDim2.new(0.2, 0, 0.3, 0)
CloseTab.LayoutOrder = 5
CloseTab.Text = ""
CloseTab.Name = "CloseTab"
CloseTab.Parent = Sidebar

local CloseTabLayout = Instance.new("UIListLayout")
CloseTabLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
CloseTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
CloseTabLayout.Padding = UDim.new(0, 4)
CloseTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
CloseTabLayout.Name = "CloseTabLayout"
CloseTabLayout.FillDirection = Enum.FillDirection.Horizontal
CloseTabLayout.Parent = CloseTab

local CloseTabPadding = Instance.new("UIPadding")
CloseTabPadding.PaddingTop = UDim.new(0, 3)
CloseTabPadding.Name = "CloseTabPadding"
CloseTabPadding.PaddingBottom = UDim.new(0, 3)
CloseTabPadding.Parent = CloseTab

local CloseTabSizeCons = Instance.new("UISizeConstraint")
CloseTabSizeCons.MinSize = Vector2.new(0, 28)
CloseTabSizeCons.Name = "CloseTabSizeCons"
CloseTabSizeCons.MaxSize = Vector2.new(10000, 30)
CloseTabSizeCons.Parent = CloseTab

local TabIconClose = Instance.new("ImageLabel")
TabIconClose.BorderSizePixel = 0
TabIconClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIconClose.Image = GetAsset("Lucid/Assets/lucid_close.png")
TabIconClose.Size = UDim2.new(0, 30, 0, 30)
TabIconClose.BackgroundTransparency = 1
TabIconClose.LayoutOrder = 1
TabIconClose.Name = "TabIcon"
TabIconClose.Parent = CloseTab

Instance.new("UIAspectRatioConstraint", TabIconClose).Name = "TabIconRatio"

local TabLabelClose = Instance.new("TextLabel")
TabLabelClose.TextWrapped = true
TabLabelClose.BorderSizePixel = 0
TabLabelClose.TextXAlignment = Enum.TextXAlignment.Left
TabLabelClose.TextScaled = true
TabLabelClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabLabelClose.FontFace = BuilderSans
TabLabelClose.TextColor3 = Color3.fromRGB(255, 255, 255)
TabLabelClose.BackgroundTransparency = 1
TabLabelClose.Size = UDim2.new(0, 60, 0, 30)
TabLabelClose.Text = "Close"
TabLabelClose.LayoutOrder = 2
TabLabelClose.Name = "TabLabel"
TabLabelClose.Parent = CloseTab

local Show = Instance.new("ImageButton")
Show.BorderSizePixel = 0
Show.BackgroundTransparency = 0.3
Show.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Show.Image = ""
Show.ZIndex = 3
Show.Size = UDim2.new(0, 44, 0, 44)
Show.Name = "Show"
Show.Position = UDim2.new(0, 16, 0, 60)
Show.Parent = Lucid

Instance.new("UIAspectRatioConstraint", Show).Name = "ShowRatio"

NewCorner("1, 0", "ShowCorner", Show)

local ShowStroke = Instance.new("UIStroke")
ShowStroke.Transparency = 0.8
ShowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ShowStroke.Name = "ShowStroke"
ShowStroke.Parent = Show

local ShowPadding = Instance.new("UIPadding")
ShowPadding.PaddingTop = UDim.new(0, 6)
ShowPadding.PaddingRight = UDim.new(0, 6)
ShowPadding.Name = "ShowPadding"
ShowPadding.PaddingLeft = UDim.new(0, 6)
ShowPadding.PaddingBottom = UDim.new(0, 6)
ShowPadding.Parent = Show

local ShowIcon = Instance.new("ImageLabel")
ShowIcon.BorderSizePixel = 0
ShowIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShowIcon.Image = GetAsset("Lucid/Assets/lucid_logo.png")
ShowIcon.Size = UDim2.new(1, 0, 1, 0)
ShowIcon.BackgroundTransparency = 1
ShowIcon.Name = "ShowIcon"
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

local function SetActivePage(page)
    ExeContent.Visible = false
    SearchContent.Visible = false
    SavedScriptsContent.Visible = false
    page.Visible = true
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

ExeTab.MouseButton1Click:Connect(function() SetActivePage(ExeContent) end)
SearchTab.MouseButton1Click:Connect(function() SetActivePage(SearchContent) end)
ScriptsTab.MouseButton1Click:Connect(function()
    SetActivePage(SavedScriptsContent)
    RefreshSavedScripts(SavedScriptsSearchBox.Text)
end)

local function Dragify(Frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function ClampPosition(newX, newY)
        local viewport = workspace.CurrentCamera.ViewportSize
        local size = Frame.AbsoluteSize
        local padding = 3

        local maxX = viewport.X - size.X - padding
        local maxY = viewport.Y - size.Y - padding
        local minX = padding
        local minY = padding

        newX = math.clamp(newX, minX, maxX)
        newY = math.clamp(newY, minY, maxY)

        return newX, newY
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
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
            Frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

Dragify(Show)

CloseTab.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Show.Visible = true
end)

Show.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Show.Visible = false
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

SetActivePage(ExeContent)
Show.Visible = true
MainFrame.Visible = false

Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        ClearCache()
    end
end)
