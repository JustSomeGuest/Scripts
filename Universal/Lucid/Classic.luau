if not game:IsLoaded() then game.Loaded:Wait() end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(n) local s = game:GetService(n) return cloneref and cloneref(s) or s end

local Hui = gethui and gethui() or GetService("CoreGui")
local Workspace = GetService("Workspace")
local HttpService = GetService("HttpService")
local Players = GetService("Players")
local Player = Players.LocalPlayer
local UIS = GetService("UserInputService")
local StarterGui = GetService("StarterGui")
local RunService = GetService("RunService")

if not Env.__Lucid then Env.__Lucid = {} end
if Env.__Lucid.IsLoaded then
	StarterGui:SetCore("SendNotification", {
		Title = "Lucid",
		Text = "Lucid is already running!",
		Duration = 3
	})
	return
end
Env.__Lucid.IsLoaded = true

local WriteFile = writefile or function() end
local ReadFile = readfile or function() end
local DelFile = delfile or function() end
local IsFile = isfile or function() end
local IsFolder = isfolder or function() end
local MakeFolder = makefolder or function() end
local ListFiles = listfiles or function() end
local LoadAsset = getcustomasset or getsynasset or function() end
local SetClipboard = setclipboard or function() end

local GothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local GothamMed = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local Inconsolata = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local BG = Color3.fromRGB(28, 28, 28)
local BG2 = Color3.fromRGB(40, 40, 40)
local BG3 = Color3.fromRGB(52, 52, 52)
local ACCENT = Color3.fromRGB(0, 102, 204)
local TEXT = Color3.fromRGB(240, 240, 240)
local SUBTEXT = Color3.fromRGB(170, 170, 170)
local WHITE = Color3.fromRGB(255, 255, 255)
local BORDER = Color3.fromRGB(75, 75, 75)

local HL = {
	Keyword="#F86D7C", Number="#FFC66D", String="#A5E075",
	Comment="#7F8C98", Global="#84D6F7", Function="#F8D66D",
	Property="#D7BA7D", Nil="#569CD6", Boolean="#569CD6",
	Identifier="#E6E6E6", Operator="#D4D4D4"
}

Env.__Lucid = {
	UI = {}, Funcs = {},
	Assets = {
		["Lucid/Assets/Lucid_Logo.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Logo.png",
		["Lucid/Assets/Lucid_Home.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Home.png",
		["Lucid/Assets/Lucid_Controller.png"]    = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Controller.png",
		["Lucid/Assets/Lucid_Execute.png"]       = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Execute.png",
		["Lucid/Assets/Lucid_Search.png"]        = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Search.png",
		["Lucid/Assets/Lucid_LocalFile.png"]     = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/LocalFile.png",
		["Lucid/Assets/Lucid_Music.png"]         = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Music.png",
		["Lucid/Assets/Lucid_Settings.png"]      = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Settings.png",
		["Lucid/Assets/Lucid_Console.png"]       = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Console.png",
		["Lucid/Assets/Lucid_Close.png"]         = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Close.png",
		["Lucid/Assets/Lucid_Clear.png"]         = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Clear.png",
		["Lucid/Assets/Lucid_Clipboard.png"]     = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Clipboard.png",
		["Lucid/Assets/Lucid_AddFile.png"]       = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/AddFile.png",
		["Lucid/Assets/Lucid_Wifi.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Wifi.png",
		["Lucid/Assets/Lucid_Bolt.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Bolt.png",
		["Lucid/Assets/Lucid_Play.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Play.png",
		["Lucid/Assets/Lucid_Pause.png"]         = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Pause.png",
		["Lucid/Assets/Lucid_Next.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Next.png",
		["Lucid/Assets/Lucid_Previous.png"]      = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Previous.png",
		["Lucid/Assets/Lucid_Save.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Save.png",
		["Lucid/Assets/Lucid_Star.png"]          = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Star.png",
		["Lucid/Assets/Lucid_Filter.png"]        = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Filter.png",
		["Lucid/Assets/Lucid_Discord.png"]       = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Lucid/Assets/Discord.png",
	},
	Settings = {
		ThemePreset = "Default Classic",
		AccentColor = Color3.fromRGB(0, 102, 204),
		BGColor = Color3.fromRGB(28, 28, 28),
		BG2Color = Color3.fromRGB(40, 40, 40),
	},
	IsLoaded = false
}

local UI = Env.__Lucid.UI
local Funcs = Env.__Lucid.Funcs
local Assets = Env.__Lucid.Assets
local Settings = Env.__Lucid.Settings

local ExeTabs, ExeActiveTab = {}, nil
local currentPage, totalPages, currentQuery = 1, 1, ""
local MusicSound, MusicFiles, MusicIndex, MusicPlaying, MusicSliderDragging = nil, {}, 1, false, false

local Keywords = {"local","function","if","then","else","elseif","end","for","while","repeat","until","do","return","break","continue","in","not","and","or","nil","true","false","type","typeof","export"}
local Globals = {"game","workspace","script","Instance","Enum","Color3","Vector2","Vector3","UDim","UDim2","CFrame","math","string","table","task","coroutine","os","utf8","ipairs","pairs","next","pcall","xpcall","tonumber","tostring","warn","print","require","select","rawequal","rawget","rawset","type","unpack","assert","error","getfenv","setfenv","getmetatable","setmetatable","loadstring","load","BrickColor","NumberSequence","ColorSequence","NumberRange","Random","Rect","Region3","TweenService","RunService","Players","ReplicatedStorage","UserInputService","HttpService","StarterGui"}
local KW, GL = {}, {}
for _, v in ipairs(Keywords) do KW[v] = true end
for _, v in ipairs(Globals) do GL[v] = true end

local function MkFrame(bg, size, p) 
	local f = Instance.new("Frame") 
	f.BackgroundColor3 = bg 
	f.BackgroundTransparency = 0 
	f.BorderSizePixel = 1 
	f.BorderColor3 = BORDER
	f.Size = size 
	f.Parent = p 
	return f 
end

local function MkLabel(text, font, size, col, p) 
	local l = Instance.new("TextLabel") 
	l.BackgroundTransparency = 1 
	l.BorderSizePixel = 0 
	l.Text = text 
	l.FontFace = font 
	l.TextSize = size 
	l.TextColor3 = col 
	l.TextWrapped = true 
	l.Parent = p 
	return l 
end

local function MkBtn(text, font, size, col, bg, p)
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = bg
	b.BorderSizePixel = 1
	b.BorderColor3 = BORDER
	b.Text = text
	b.FontFace = font
	b.TextSize = size
	b.TextColor3 = col
	b.AutoButtonColor = true
	b.Parent = p
	return b
end

local function MkImg(img, col, p) 
	local i = Instance.new("ImageLabel") 
	i.BackgroundTransparency = 1 
	i.BorderSizePixel = 0 
	i.Image = img or "" 
	i.ImageColor3 = col 
	i.Parent = p 
	return i 
end

local function MkScroll(dir, p) 
	local s = Instance.new("ScrollingFrame") 
	s.BackgroundTransparency = 1 
	s.BorderSizePixel = 1 
	s.BorderColor3 = BORDER
	s.ScrollBarThickness = 0 
	s.ScrollingDirection = dir or Enum.ScrollingDirection.Y 
	s.CanvasSize = UDim2.new(0,0,0,0) 
	s.AutomaticCanvasSize = Enum.AutomaticSize.Y 
	s.Parent = p 
	return s 
end

local function MkList(dir, pad, p) 
	local l = Instance.new("UIListLayout") 
	l.FillDirection = dir or Enum.FillDirection.Vertical 
	l.Padding = UDim.new(0, pad or 4) 
	l.SortOrder = Enum.SortOrder.LayoutOrder 
	l.Parent = p 
	return l 
end

local function MkPad(l, r, t, b, p) 
	local pad = Instance.new("UIPadding") 
	pad.PaddingLeft = UDim.new(0,l) 
	pad.PaddingRight = UDim.new(0,r) 
	pad.PaddingTop = UDim.new(0,t) 
	pad.PaddingBottom = UDim.new(0,b) 
	pad.Parent = p 
	return pad 
end

function Funcs.GetAsset(path)
	if not LoadAsset then return nil end
	if not IsFolder("Lucid") then MakeFolder("Lucid") end
	if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
	if path and path:match("^rbxassetid://") then return path end
	if IsFile(path) then return LoadAsset(path) end
	local url = Assets[path]
	if not url then return nil end
	local ok, res = pcall(function()
		local f = (syn and syn.request) or request or http_request
		return f and f({Url=url, Method="GET"})
	end)
	if ok and res and res.Body then
		WriteFile(path, res.Body)
		return LoadAsset(path)
	end
	return nil
end

function Funcs.HttpGet(url)
	local f = (syn and syn.request) or request or http_request
	if not f then return nil end
	local ok, res = pcall(function() return f({Url=url, Method="GET", Headers={["User-Agent"]="Lucid/2.0",["Accept"]="application/json"}}) end)
	return ok and res or nil
end

function Funcs.PreloadAssets()
	if not IsFolder("Lucid") then MakeFolder("Lucid") end
	if not IsFolder("Lucid/Assets") then MakeFolder("Lucid/Assets") end
	for path, url in pairs(Assets) do
		if not IsFile(path) then
			local f = (syn and syn.request) or request or http_request
			local ok, res = pcall(function() return f and f({Url=url, Method="GET"}) end)
			if ok and res and res.Body then WriteFile(path, res.Body) end
		end
	end
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
        if #Name > 30 then return true end
        if Name:match("[^%w%s%-%.]") then return true end
        local Caps = select(2, Name:gsub("[A-Z]", ""))
        return Caps >= 5
    end

    local function Scan(Parent)
        if not Parent then return end
        for _, Obj in ipairs(Parent:GetDescendants()) do
            if Obj:IsA("ScreenGui") and Obj ~= UI.ScreenGui and not Safe[Obj.Name] and IsSus(Obj.Name) then
                pcall(function() Obj.Enabled = false end)
            end
        end
    end
    Scan(gethui())
end

Funcs.HideExec()

function Funcs.UID(n)
	n = n or 32
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local t = table.create(n)
	for i = 1, n do local r = math.random(1, #chars) t[i] = chars:sub(r,r) end
	return table.concat(t)
end

function Funcs.Highlight(code)
	if type(code) ~= "string" then return "" end
	local res, i, len = {}, 1, #code
	while i <= len do
		local c = code:sub(i,i)
		if c == '"' or c == "'" then
			local s, q = i, c
			i = i + 1
			while i <= len do
				if code:sub(i,i) == '\\' then i=i+2
				elseif code:sub(i,i) == q then i=i+1 break
				else i=i+1 end
			end
			local str = code:sub(s,i-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
			table.insert(res,'<font color="'..HL.String..'">'..str..'</font>')
		elseif c == '[' and code:sub(i,i+1) == '[[' then
			local s, depth = i, 0
			while i <= len do
				if code:sub(i,i+1)=='[[' then depth=depth+1;i=i+2
				elseif code:sub(i,i+1)==']]' then depth=depth-1;i=i+2; if depth==0 then break end
				else i=i+1 end
			end
			local str = code:sub(s,i-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
			table.insert(res,'<font color="'..HL.String..'">'..str..'</font>')
		elseif c == '-' and code:sub(i,i+1) == '--' then
			if code:sub(i,i+3) == '--[[' then
				local s, depth = i, 0; i=i+4
				while i <= len do
					if code:sub(i,i+1)=='[[' then depth=depth+1;i=i+2
					elseif code:sub(i,i+1)==']]' then depth=depth-1;i=i+2; if depth==0 then break end
					else i=i+1 end
				end
				local str = code:sub(s,i-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
				table.insert(res,'<font color="'..HL.Comment..'">'..str..'</font>')
			else
				local s = i
				while i <= len do local ch=code:sub(i,i) if ch=='\n' or ch=='\r' then break end i=i+1 end
				local str = code:sub(s,i-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
				table.insert(res,'<font color="'..HL.Comment..'">'..str..'</font>')
			end
		elseif c:match('%d') then
			local s = i
			while i <= len do local ch=code:sub(i,i) if not ch:match('%d') and ch~='.' then break end i=i+1 end
			local str = code:sub(s,i-1):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
			table.insert(res,'<font color="'..HL.Number..'">'..str..'</font>')
		elseif c:match('%a') or c == '_' then
			local s = i
			while i <= len do local ch=code:sub(i,i) if not ch:match('%w') and ch~='_' then break end i=i+1 end
			local word = code:sub(s,i-1)
			local safe = word:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
			if word=='nil' then table.insert(res,'<font color="'..HL.Nil..'">'..safe..'</font>')
			elseif word=='true' or word=='false' then table.insert(res,'<font color="'..HL.Boolean..'">'..safe..'</font>')
			elseif KW[word] then table.insert(res,'<font color="'..HL.Keyword..'">'..safe..'</font>')
			elseif GL[word] then table.insert(res,'<font color="'..HL.Global..'">'..safe..'</font>')
			elseif code:sub(i,i)=='(' then table.insert(res,'<font color="'..HL.Function..'">'..safe..'</font>')
			else table.insert(res,'<font color="'..HL.Identifier..'">'..safe..'</font>') end
		else
			if c=='&' then table.insert(res,'&amp;')
			elseif c=='<' then table.insert(res,'&lt;')
			elseif c=='>' then table.insert(res,'&gt;')
			else table.insert(res, c) end
			i=i+1
		end
	end
	return table.concat(res)
end

function Funcs.SanitizeName(name)
	if not name then return "Script_"..HttpService:GenerateGUID(false):sub(1,8) end
	local cleaned = ""
	for char in name:gmatch(".") do
		local byte = string.byte(char)
		if (byte>=65 and byte<=90) or (byte>=97 and byte<=122) or (byte>=48 and byte<=57) then cleaned=cleaned..char end
	end
	if cleaned=="" then cleaned="Script_"..HttpService:GenerateGUID(false):sub(1,8) end
	return cleaned
end

local Themes = {
	["Default Classic"] = {BG = Color3.fromRGB(28,28,28), BG2 = Color3.fromRGB(40,40,40), ACCENT = Color3.fromRGB(0,102,204)},
	["Midnight"]        = {BG = Color3.fromRGB(10,10,14), BG2 = Color3.fromRGB(18,18,24), ACCENT = Color3.fromRGB(140,80,255)},
	["Amethyst"]        = {BG = Color3.fromRGB(20,12,24), BG2 = Color3.fromRGB(32,20,38), ACCENT = Color3.fromRGB(170,80,255)},
	["Crimson"]         = {BG = Color3.fromRGB(22,12,14), BG2 = Color3.fromRGB(36,20,24), ACCENT = Color3.fromRGB(230,60,80)},
	["Emerald"]         = {BG = Color3.fromRGB(12,20,16), BG2 = Color3.fromRGB(20,34,26), ACCENT = Color3.fromRGB(46,204,113)},
	["Ocean"]           = {BG = Color3.fromRGB(12,18,26), BG2 = Color3.fromRGB(20,30,44), ACCENT = Color3.fromRGB(0,180,216)},
}

-- Live Theme Application updating main, sidebar, titlebar, content areas, and buttons
function Funcs.ApplyTheme(preset)
	local t = Themes[preset] or Themes["Default Classic"]
	Settings.ThemePreset = preset
	Settings.BGColor = t.BG
	Settings.BG2Color = t.BG2
	Settings.AccentColor = t.ACCENT
	BG = t.BG
	BG2 = t.BG2
	ACCENT = t.ACCENT

	if UI.Main then UI.Main.BackgroundColor3 = BG end
	if UI.Sidebar then UI.Sidebar.BackgroundColor3 = BG2 end
	if UI.TitleBar then UI.TitleBar.BackgroundColor3 = BG2 end
	if UI.ShowBtn then UI.ShowBtn.BackgroundColor3 = BG2 end
	if UI.ContentArea then UI.ContentArea.BackgroundColor3 = BG end
	if UI.NewScriptBtn then UI.NewScriptBtn.BackgroundColor3 = ACCENT end
	if UI.AddExeTabBtn then UI.AddExeTabBtn.BackgroundColor3 = ACCENT end
	
	if UI.PageContents then
		for _, frame in pairs(UI.PageContents) do
			if frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
				frame.BackgroundColor3 = BG
			end
		end
	end
	
	if UI.PageBtns then
		for pName, btn in pairs(UI.PageBtns) do
			if pName == UI.ActivePage then
				btn.BackgroundColor3 = ACCENT
			else
				btn.BackgroundColor3 = BG2
			end
		end
	end
	Funcs.SaveSettings()
end

function Funcs.LoadSettings()
	if not IsFile("Lucid/Settings.json") then return end
	local content = ReadFile("Lucid/Settings.json")
	if not content or content=="" then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
	if ok and data then
		if data.ThemePreset and Themes[data.ThemePreset] then
			Funcs.ApplyTheme(data.ThemePreset)
		else
			if data.AccentColor then Settings.AccentColor = Color3.fromRGB(data.AccentColor.R or 0, data.AccentColor.G or 102, data.AccentColor.B or 204) end
			if data.BGColor then Settings.BGColor = Color3.fromRGB(data.BGColor.R or 28, data.BGColor.G or 28, data.BGColor.B or 28) end
			if data.BG2Color then Settings.BG2Color = Color3.fromRGB(data.BG2Color.R or 40, data.BG2Color.G or 40, data.BG2Color.B or 40) end
			ACCENT = Settings.AccentColor
			BG = Settings.BGColor
			BG2 = Settings.BG2Color
		end
	end
end

function Funcs.SaveSettings()
	if not IsFolder("Lucid") then MakeFolder("Lucid") end
	local data = {
		ThemePreset = Settings.ThemePreset,
		AccentColor = {R=math.floor(Settings.AccentColor.R*255), G=math.floor(Settings.AccentColor.G*255), B=math.floor(Settings.AccentColor.B*255)},
		BGColor = {R=math.floor(Settings.BGColor.R*255), G=math.floor(Settings.BGColor.G*255), B=math.floor(Settings.BGColor.B*255)},
		BG2Color = {R=math.floor(Settings.BG2Color.R*255), G=math.floor(Settings.BG2Color.G*255), B=math.floor(Settings.BG2Color.B*255)},
	}
	WriteFile("Lucid/Settings.json", HttpService:JSONEncode(data))
end

local Srcs = {"RScripts","ScriptBlox"}
local SrcIdx = 1
local Filters = {"All","Key","Keyless"}
local FilterIdx = 1
local CurrentScripts = {}

function Funcs.ScriptNeedsKey(data)
	local v = SrcIdx==2 and data.key or data.keySystem
	if type(v)=="boolean" then return v end
	if type(v)=="number" then return v~=0 end
	if type(v)=="string" then
		local n = v:lower()
		if n=="" or n=="false" or n=="0" or n=="none" or n=="n/a" then return false end
		if n:find("no key",1,true) or n:find("keyless",1,true) then return false end
		return true
	end
	return v~=nil and v~=false
end

function Funcs.PassesFilter(data)
	local f = Filters[FilterIdx]
	if f=="Key" then return Funcs.ScriptNeedsKey(data)
	elseif f=="Keyless" then return not Funcs.ScriptNeedsKey(data) end
	return true
end

function Funcs.ResolveImage(data)
	local raw = data.image or data.imageUrl or data.thumbnail or (data.game and (data.game.imageUrl or data.game.image)) or ""
	if raw=="" then return "" end
	if raw:match("^https?://") then return raw end
	if raw:sub(1,2)=="//" then return "https:"..raw end
	local base = SrcIdx==2 and "https://scriptblox.com" or "https://rscripts.net"
	if raw:sub(1,1)=="/" then return base..raw end
	return base.."/"..raw
end

function Funcs.FetchScripts(query, page)
	page = page or 1
	local url
	if SrcIdx==1 then
		url = "https://rscripts.net/api/v2/scripts?page="..page.."&orderBy=date&sort=desc"
		if query~="" then url=url.."&q="..HttpService:UrlEncode(query) end
	else
		if query~="" then url="https://scriptblox.com/api/script/search?q="..HttpService:UrlEncode(query).."&page="..page
		else url="https://scriptblox.com/api/script/fetch?page="..page end
	end
	local res = Funcs.HttpGet(url)
	if not res or not res.Body then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(res.Body) end)
	if not ok or not decoded then return nil, nil end
	local scripts, pages
	if SrcIdx==1 then
		scripts = decoded.scripts or {}
		pages = decoded.info and decoded.info.maxPages or 1
	else
		local r = decoded.result or {}
		scripts = r.scripts or {}
		pages = r.totalPages or 1
	end
	return scripts, pages
end

function Funcs.LoadSavedScripts()
	if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts") return {} end
	local files = ListFiles("Lucid/Scripts")
	local scripts = {}
	for _, file in ipairs(files) do
		local content = ReadFile(file)
		local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
		if ok and data then
			if data.Script and not data.Code then data.Code = data.Script end
			table.insert(scripts, data)
		end
	end
	return scripts
end

function Funcs.SaveScript(scriptData)
	if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts") end
	local fileName = "Lucid/Scripts/"..scriptData.Name:gsub("[^%w]","_")..".json"
	WriteFile(fileName, HttpService:JSONEncode(scriptData))
end

function Funcs.DeleteScript(scriptName)
	local fileName = "Lucid/Scripts/"..scriptName:gsub("[^%w]","_")..".json"
	if IsFile(fileName) then DelFile(fileName) end
end

function Funcs.ClearCache()
	if IsFolder("Lucid/Cache") then
		local files = ListFiles("Lucid/Cache") or {}
		for _, f in ipairs(files) do pcall(function() DelFile(f) end) end
	end
end

local BuiltInScripts = {
	{Name="Dex++ (Built-In)", Description="Explore game instances.", Code='loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()'},
	{Name="Keyboard (Built-In)", Description="Virtual keyboard for mobile.", Code='loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/DeltaKD.luau"))()'}
}

function Funcs.InitDefaultScripts()
	if not IsFolder("Lucid/Scripts") then MakeFolder("Lucid/Scripts") end
	for _, sd in ipairs(BuiltInScripts) do
		local fn = "Lucid/Scripts/"..sd.Name:gsub("[^%w]","_")..".json"
		if not IsFile(fn) then Funcs.SaveScript(sd) end
	end
end

function Funcs.ParseColor(input)
	if type(input)~="string" then return nil end
	local r,g,b = input:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
	if r and g and b then return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
	return nil
end

function Funcs.GetMusicFiles()
	if not IsFolder("Lucid/Music") then MakeFolder("Lucid/Music") end
	local files = ListFiles("Lucid/Music") or {}
	local supported = {mp3=true,m4a=true,ogg=true,wav=true,flac=true,aiff=true}
	local result = {}
	for _, file in ipairs(files) do
		local ext = file:match("%.([^%.]+)$")
		if ext and supported[ext:lower()] then table.insert(result, file) end
	end
	return result
end

function Funcs.GetMusicDisplayName(path)
	local name = path:match("([^/\\]+)$") or path
	return name:gsub("%.[^%.]+$","")
end

function Funcs.FormatTime(seconds)
	if not seconds or seconds~=seconds then return "0:00" end
	seconds = math.floor(seconds)
	return string.format("%d:%02d", math.floor(seconds/60), seconds%60)
end

Funcs.PreloadAssets()
Funcs.LoadSettings()

ACCENT = Settings.AccentColor
BG = Settings.BGColor
BG2 = Settings.BG2Color

local Screen = Instance.new("ScreenGui")
Screen.DisplayOrder = 2147483647
Screen.IgnoreGuiInset = true
Screen.Name = Funcs.UID()
Screen.ResetOnSpawn = false
Screen.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.Parent = Hui
UI.Screen = Screen

local PAGES = {"Home","Executor","Console","Search","Scripts","Music","Settings"}
local PAGE_ICONS = {
	Home     = Funcs.GetAsset("Lucid/Assets/Lucid_Home.png"),
	Executor = Funcs.GetAsset("Lucid/Assets/Lucid_Controller.png"),
	Console  = Funcs.GetAsset("Lucid/Assets/Lucid_Console.png"),
	Search   = Funcs.GetAsset("Lucid/Assets/Lucid_Search.png"),
	Scripts  = Funcs.GetAsset("Lucid/Assets/Lucid_LocalFile.png"),
	Music    = Funcs.GetAsset("Lucid/Assets/Lucid_Music.png"),
	Settings = Funcs.GetAsset("Lucid/Assets/Lucid_Settings.png"),
}

-- Classic floating toggle button
local ShowBtn = Instance.new("ImageButton")
ShowBtn.BackgroundColor3 = BG2
ShowBtn.BackgroundTransparency = 0
ShowBtn.BorderSizePixel = 1
ShowBtn.BorderColor3 = BORDER
ShowBtn.Name = "ShowBtn"
ShowBtn.Position = UDim2.new(0, 16, 0, 60)
ShowBtn.Size = UDim2.new(0, 40, 0, 40)
ShowBtn.Visible = true
ShowBtn.ZIndex = 5
ShowBtn.Parent = Screen
UI.ShowBtn = ShowBtn
local ShowIcon = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png") or "", WHITE, ShowBtn)
ShowIcon.AnchorPoint = Vector2.new(0.5,0.5)
ShowIcon.Position = UDim2.new(0.5,0,0.5,0)
ShowIcon.Size = UDim2.new(0.7,0,0.7,0)

local Overlay = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), Screen)
Overlay.BackgroundTransparency = 0.5
Overlay.Name = "Overlay"
Overlay.Visible = false
Overlay.ZIndex = 1
UI.Overlay = Overlay

-- Classic Main Window (Compact 680x360, centered once using ViewportSize)
local Main = Instance.new("Frame")
Main.BackgroundColor3 = BG
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 1
Main.BorderColor3 = BORDER
Main.Name = "Main"
Main.Size = UDim2.new(0, 680, 0, 360)
local vp = workspace.CurrentCamera.ViewportSize
Main.AnchorPoint = Vector2.new(0, 0)
Main.Position = UDim2.new(0, math.floor((vp.X - 680)/2), 0, math.floor((vp.Y - 360)/2))
Main.Visible = false
Main.ZIndex = 2
Main.Parent = Screen
UI.Main = Main

-- Title Bar with "Lucid" title
local TitleBar = MkFrame(BG2, UDim2.new(1, 0, 0, 26), Main)
TitleBar.Name = "TitleBar"
TitleBar.ZIndex = 3
UI.TitleBar = TitleBar

local TitleLogo = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png") or "", WHITE, TitleBar)
TitleLogo.Size = UDim2.new(0, 18, 0, 18)
TitleLogo.Position = UDim2.new(0, 4, 0.5, -9)

local TitleLbl = MkLabel(" Lucid", GothamBold, 11, TEXT, TitleBar)
TitleLbl.Size = UDim2.new(1, -50, 1, 0)
TitleLbl.Position = UDim2.new(0, 26, 0, 0)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = MkBtn("X", GothamBold, 11, WHITE, Color3.fromRGB(180, 50, 50), TitleBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 24)
CloseBtn.Position = UDim2.new(1, -26, 0, 1)
UI.CloseBtn = CloseBtn

-- Sidebar on the left (width 130px)
local Sidebar = MkFrame(BG2, UDim2.new(0, 130, 1, -26), Main)
Sidebar.Position = UDim2.new(0, 0, 0, 26)
Sidebar.Name = "Sidebar"
Sidebar.ZIndex = 3
UI.Sidebar = Sidebar
local SidebarList = MkList(Enum.FillDirection.Vertical, 2, Sidebar)
MkPad(2, 2, 2, 2, Sidebar)

-- Content Area to the right of Sidebar
local ContentArea = MkFrame(BG, UDim2.new(1, -130, 1, -26), Main)
ContentArea.Position = UDim2.new(0, 130, 0, 26)
ContentArea.Name = "ContentArea"
ContentArea.ZIndex = 3
UI.ContentArea = ContentArea

local ActivePage = "Home"
UI.ActivePage = ActivePage
local PageContents = {}
UI.PageContents = PageContents
local PageBtns = {}
UI.PageBtns = PageBtns

local function MkPageContent(name)
	local frame = Instance.new("ScrollingFrame")
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.ScrollBarThickness = 0
	frame.ScrollingDirection = Enum.ScrollingDirection.Y
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.Visible = false
	frame.Name = name.."Content"
	frame.Parent = ContentArea
	PageContents[name] = frame
	return frame
end

for _, page in ipairs(PAGES) do
	MkPageContent(page)
end

local HomeContent = PageContents["Home"]
local ExeContent = PageContents["Executor"]
local ConsoleContent = PageContents["Console"]
local SearchContent = PageContents["Search"]
local ScriptsContent = PageContents["Scripts"]
local MusicContent = PageContents["Music"]
local SettingsContent = PageContents["Settings"]

local function SwitchPage(name)
	if ActivePage == name then return end
	local old = PageContents[ActivePage]
	local new = PageContents[name]
	if not new then return end
	if PageBtns[ActivePage] then
		PageBtns[ActivePage].BackgroundColor3 = BG2
	end
	if PageBtns[name] then
		PageBtns[name].BackgroundColor3 = ACCENT
	end
	if old then old.Visible = false end
	ActivePage = name
	UI.ActivePage = name
	new.Visible = true
	if name == "Home" then Funcs.UpdateStats() end
	if name == "Scripts" then Funcs.RefreshSavedScripts("") end
	if name == "Music" then Funcs.RefreshMusicList() end
	if name == "Console" then
		if UI.ConsoleScroll then
			task.defer(function()
				UI.ConsoleScroll.CanvasPosition = Vector2.new(0, math.max(0, UI.ConsoleScroll.AbsoluteCanvasSize.Y - UI.ConsoleScroll.AbsoluteSize.Y))
			end)
		end
	end
end
Funcs.SwitchPage = SwitchPage

for i, page in ipairs(PAGES) do
	local btn = MkBtn("", GothamMed, 11, TEXT, page=="Home" and ACCENT or BG2, Sidebar)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.LayoutOrder = i

	local hl = Instance.new("UIListLayout")
	hl.FillDirection = Enum.FillDirection.Horizontal
	hl.VerticalAlignment = Enum.VerticalAlignment.Center
	hl.Padding = UDim.new(0, 6)
	hl.Parent = btn

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 6)
	pad.Parent = btn

	local ico = MkImg(PAGE_ICONS[page], WHITE, btn)
	ico.Size = UDim2.new(0, 16, 0, 16)
	ico.LayoutOrder = 1

	local lbl = MkLabel(page, GothamMed, 11, TEXT, btn)
	lbl.Size = UDim2.new(1, -22, 1, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = 2

	PageBtns[page] = btn
	btn.MouseButton1Click:Connect(function()
		SwitchPage(page)
	end)
end

function Funcs.OpenUI()
	Overlay.Visible = true
	Main.Visible = true
	ShowBtn.Visible = false
end

function Funcs.CloseUI()
	Funcs.ClearCache()
	Main.Visible = false
	Overlay.Visible = false
	ShowBtn.Visible = true
end

function Funcs.Dragify(obj)
    local dragging, dragStart, startPos = false, nil, nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.AbsolutePosition
        end
    end)

    ShowBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ShowBtn.AbsolutePosition
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local vp = workspace.CurrentCamera.ViewportSize
            local sz = Main.AbsoluteSize
            if obj == ShowBtn then sz = ShowBtn.AbsoluteSize end

            local nx = math.clamp(startPos.X + delta.X, 0, vp.X - sz.X)
            local ny = math.clamp(startPos.Y + delta.Y, 0, vp.Y - sz.Y)

            if obj == ShowBtn then
                ShowBtn.AnchorPoint = Vector2.new(0, 0)
                ShowBtn.Position = UDim2.new(0, nx, 0, ny)
            else
                Main.AnchorPoint = Vector2.new(0, 0)
                Main.Position = UDim2.new(0, nx, 0, ny)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
Funcs.Dragify(Main)
Funcs.Dragify(ShowBtn)

-- Home Page Content
do
	MkPad(8, 8, 8, 8, HomeContent)
	local hl = MkList(Enum.FillDirection.Vertical, 6, HomeContent)

	local topRow = MkFrame(BG2, UDim2.new(1,0,0,76), HomeContent)
	topRow.LayoutOrder = 1
	MkPad(6,6,6,6,topRow)
	local rowL = MkList(Enum.FillDirection.Horizontal, 8, topRow)

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundColor3 = BG3
	avatar.BorderSizePixel = 1
	avatar.BorderColor3 = BORDER
	avatar.Size = UDim2.new(0,64,0,64)
	avatar.LayoutOrder = 1
	avatar.Parent = topRow
	UI.Avatar = avatar

	local infoCol = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,-72,1,0), topRow)
	infoCol.BackgroundTransparency = 1
	infoCol.LayoutOrder = 2
	local ic = MkList(Enum.FillDirection.Vertical, 2, infoCol)

	local welcomeL = MkLabel("Welcome!", GothamBold, 14, WHITE, infoCol)
	welcomeL.Size = UDim2.new(1,0,0,20)
	welcomeL.TextXAlignment = Enum.TextXAlignment.Left
	UI.WelcomeLabel = welcomeL

	local statsL = MkLabel("Loading...", GothamMed, 11, SUBTEXT, infoCol)
	statsL.Size = UDim2.new(1,0,0,38)
	statsL.TextXAlignment = Enum.TextXAlignment.Left
	statsL.TextYAlignment = Enum.TextYAlignment.Top
	UI.StatsLabel = statsL

	local infoBox = MkFrame(BG2, UDim2.new(1,0,0,0), HomeContent)
	infoBox.LayoutOrder = 2
	infoBox.AutomaticSize = Enum.AutomaticSize.Y
	MkPad(8,8,8,8,infoBox)

	local aboutL = Instance.new("TextLabel")
	aboutL.BackgroundTransparency = 1
	aboutL.BorderSizePixel = 0
	aboutL.FontFace = GothamMed
	aboutL.TextSize = 11
	aboutL.TextColor3 = SUBTEXT
	aboutL.Text = [[<b>Lucid</b>

<i>A better UI for your executor.</i>

Lucid is a custom executor UI designed to replace the default interface of your executor with a cleaner, more feature-rich experience.

Some executors offer powerful execution capabilities but have a UI that feels outdated, cluttered, or simply isn't enjoyable to use. <b>Lucid</b> was created to solve that.

<b>Version</b>

Classic

<i>The classic 2016 Roblox experience.</i>

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
• <b>Code</b>

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

• <b>Theme Customization</b> — Switch between built-in themes.

<b>Credits</b>

<i>Designed and developed by JustSomeGuest</i>]]
	aboutL.Size = UDim2.new(1,0,0,0)
	aboutL.AutomaticSize = Enum.AutomaticSize.Y
	aboutL.TextWrapped = true
	aboutL.TextXAlignment = Enum.TextXAlignment.Left
	aboutL.TextYAlignment = Enum.TextYAlignment.Top
	aboutL.RichText = true
	aboutL.Parent = infoBox

	function Funcs.UpdateStats()
		local ok = pcall(function()
			local uid = Player.UserId
			UI.Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..uid.."&width=420&height=420&format=png"
			UI.WelcomeLabel.Text = "Welcome, "..Player.DisplayName.."!"
			local fps = math.floor(workspace:GetRealPhysicsFPS() or 0)
			local ping = math.floor((Player:GetNetworkPing() or 0)*1000)
			local mem = math.floor(collectgarbage("count")/1024)
			local pc = #Players:GetPlayers()
			local mx = Players.MaxPlayers
			UI.StatsLabel.Text = string.format("FPS: %d  |  Ping: %d ms  |  Mem: %d MB\nPlayers: %d/%d  |  PlaceId: %d", fps, ping, mem, pc, mx, game.PlaceId)
		end)
	end
end

-- Executor Page
local ExeTabs2 = {}
local ExeActiveTab2 = nil

do
	MkPad(6,6,6,6,ExeContent)
	local el = MkList(Enum.FillDirection.Vertical, 4, ExeContent)

	local tabBar = MkFrame(BG2, UDim2.new(1,0,0,30), ExeContent)
	tabBar.LayoutOrder = 1
	local tbScroll = Instance.new("ScrollingFrame")
	tbScroll.BackgroundTransparency = 1
	tbScroll.BorderSizePixel = 0
	tbScroll.ScrollBarThickness = 0
	tbScroll.ScrollingDirection = Enum.ScrollingDirection.X
	tbScroll.CanvasSize = UDim2.new(0,0,0,0)
	tbScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	tbScroll.Size = UDim2.new(1,-32,1,0)
	tbScroll.Parent = tabBar
	local tbScrollL = MkList(Enum.FillDirection.Horizontal, 2, tbScroll)
	UI.ExeTabBarScroll = tbScroll

	local addTabBtn = MkBtn("", GothamBold, 14, WHITE, ACCENT, tabBar)
	addTabBtn.AnchorPoint = Vector2.new(1,0.5)
	addTabBtn.Position = UDim2.new(1,-2,0.5,0)
	addTabBtn.Size = UDim2.new(0,28,0,26)
	UI.AddExeTabBtn = addTabBtn
	local addTabIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png") or "", WHITE, addTabBtn)
	addTabIco.AnchorPoint = Vector2.new(0.5,0.5)
	addTabIco.Position = UDim2.new(0.5,0,0.5,0)
	addTabIco.Size = UDim2.new(0.6,0,0.6,0)

	local editorArea = MkFrame(BG2, UDim2.new(1,0,1,-64), ExeContent)
	editorArea.LayoutOrder = 2
	UI.ExeEditorArea = editorArea

	local bottomBar = MkFrame(BG2, UDim2.new(1,0,0,30), ExeContent)
	bottomBar.LayoutOrder = 3
	local bbL = MkList(Enum.FillDirection.Horizontal, 4, bottomBar)
	MkPad(4,4,3,3,bottomBar)
	UI.ExeBottomBar = bottomBar

	local function MkBottomBtn(labelText, iconPath, order)
		local btn = MkBtn("", GothamMed, 11, TEXT, BG3, bottomBar)
		btn.Size = UDim2.new(0,82,1,0)
		btn.LayoutOrder = order

		local hl = Instance.new("UIListLayout")
		hl.FillDirection = Enum.FillDirection.Horizontal
		hl.VerticalAlignment = Enum.VerticalAlignment.Center
		hl.HorizontalAlignment = Enum.HorizontalAlignment.Center
		hl.Padding = UDim.new(0, 4)
		hl.Parent = btn

		local ico = MkImg(Funcs.GetAsset(iconPath), TEXT, btn)
		ico.Size = UDim2.new(0, 14, 0, 14)
		ico.LayoutOrder = 1

		local lbl = MkLabel(labelText, GothamMed, 11, TEXT, btn)
		lbl.Size = UDim2.new(0, 0, 1, 0)
		lbl.AutomaticSize = Enum.AutomaticSize.X
		lbl.TextWrapped = false
		lbl.LayoutOrder = 2

		return btn
	end

	local ExeClick = MkBottomBtn("Execute", "Lucid/Assets/Lucid_Execute.png", 1) UI.ExeBtn = ExeClick
	local ClrClick = MkBottomBtn("Clear", "Lucid/Assets/Lucid_Clear.png", 2) UI.ClrBtn = ClrClick
	local CopyClick = MkBottomBtn("Copy", "Lucid/Assets/Lucid_Clipboard.png", 3) UI.CopyBtn = CopyClick

	local function GetNextTabName()
		local existing = {}
		for _, t in ipairs(ExeTabs2) do
			local n = tonumber(t.name:match("^Tab (%d+)$"))
			if n then existing[n]=true end
		end
		local n = 1
		while existing[n] do n=n+1 end
		return "Tab "..n
	end

	local function SwitchExeTab(tabData)
		if ExeActiveTab2 and ExeActiveTab2~=tabData then
			ExeActiveTab2.inputFrame.Visible = false
			if ExeActiveTab2.tabBtn then ExeActiveTab2.tabBtn.BackgroundColor3 = BG3 end
		end
		ExeActiveTab2 = tabData
		tabData.inputFrame.Visible = true
		if tabData.tabBtn then tabData.tabBtn.BackgroundColor3 = ACCENT end
	end
	UI.SwitchExeTab = SwitchExeTab

	local function CreateExeTab(name)
		local tabData = {}
		tabData.name = name or GetNextTabName()
		tabData.code = ""

		local tabBtn = MkBtn(tabData.name, GothamMed, 11, TEXT, BG3, tbScroll)
		tabBtn.AutomaticSize = Enum.AutomaticSize.X
		tabBtn.Size = UDim2.new(0,60,1,0)

		local inputFrame = Instance.new("ScrollingFrame")
		inputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		inputFrame.BackgroundTransparency = 1
		inputFrame.BorderSizePixel = 0
		inputFrame.ScrollBarThickness = 0
		inputFrame.Size = UDim2.new(1,0,1,0)
		inputFrame.Visible = false
		inputFrame.Parent = editorArea
		MkPad(6,6,6,6,inputFrame)

		local highlight = Instance.new("TextLabel")
		highlight.AutomaticSize = Enum.AutomaticSize.Y
		highlight.BackgroundTransparency = 1
		highlight.FontFace = Inconsolata
		highlight.RichText = true
		highlight.Size = UDim2.new(1,0,0,0)
		highlight.Text = ""
		highlight.TextColor3 = WHITE
		highlight.TextSize = 13
		highlight.TextWrapped = true
		highlight.TextXAlignment = Enum.TextXAlignment.Left
		highlight.TextYAlignment = Enum.TextYAlignment.Top
		highlight.Parent = inputFrame

		local inputBox = Instance.new("TextBox")
		inputBox.AutomaticSize = Enum.AutomaticSize.Y
		inputBox.BackgroundTransparency = 1
		inputBox.BorderSizePixel = 0
		inputBox.ClearTextOnFocus = false
		inputBox.FontFace = Inconsolata
		inputBox.MultiLine = true
		inputBox.PlaceholderColor3 = SUBTEXT
		inputBox.PlaceholderText = "-- Enter code here..."
		inputBox.Size = UDim2.new(1,0,0,0)
		inputBox.Text = ""
		inputBox.TextColor3 = Color3.fromRGB(0,0,0)
		inputBox.TextTransparency = 1
		inputBox.TextSize = 13
		inputBox.TextWrapped = true
		inputBox.TextXAlignment = Enum.TextXAlignment.Left
		inputBox.TextYAlignment = Enum.TextYAlignment.Top
		inputBox.Parent = inputFrame

		inputBox:GetPropertyChangedSignal("Text"):Connect(function()
			tabData.code = inputBox.Text
			highlight.Text = Funcs.Highlight(inputBox.Text)
		end)

		tabData.tabBtn = tabBtn
		tabData.inputFrame = inputFrame
		tabData.inputBox = inputBox
		tabData.highlight = highlight

		tabBtn.MouseButton1Click:Connect(function() SwitchExeTab(tabData) end)

		table.insert(ExeTabs2, tabData)
		SwitchExeTab(tabData)
		return tabData
	end
	Funcs.CreateExeTab = CreateExeTab

	addTabBtn.MouseButton1Click:Connect(function() CreateExeTab() end)

	UI.ExeBtn.MouseButton1Click:Connect(function()
		if ExeActiveTab2 and ExeActiveTab2.inputBox.Text~="" then
			pcall(loadstring(ExeActiveTab2.inputBox.Text))
		end
	end)
	UI.ClrBtn.MouseButton1Click:Connect(function()
		if ExeActiveTab2 then ExeActiveTab2.inputBox.Text="" end
	end)
	UI.CopyBtn.MouseButton1Click:Connect(function()
		if ExeActiveTab2 then SetClipboard(ExeActiveTab2.inputBox.Text) end
	end)

	CreateExeTab("Tab 1")
end

-- Console Page
do
	MkPad(6,6,6,6,ConsoleContent)
	local cl = MkList(Enum.FillDirection.Vertical, 4, ConsoleContent)

	local consoleTopBar = MkFrame(BG2, UDim2.new(1,0,0,28), ConsoleContent)
	consoleTopBar.LayoutOrder = 1
	
	local consoleTitleIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Console.png") or "", SUBTEXT, consoleTopBar)
	consoleTitleIco.Size = UDim2.new(0,16,0,16)
	consoleTitleIco.Position = UDim2.new(0,6,0.5,-8)

	local consoleTitleL = MkLabel("Console Output", GothamBold, 12, TEXT, consoleTopBar)
	consoleTitleL.Size = UDim2.new(1,-60,1,0)
	consoleTitleL.Position = UDim2.new(0,26,0,0)
	consoleTitleL.TextXAlignment = Enum.TextXAlignment.Left

	local consoleClearBtn = MkBtn("", GothamMed, 11, TEXT, BG3, consoleTopBar)
	consoleClearBtn.Size = UDim2.new(0,54,0,22)
	consoleClearBtn.Position = UDim2.new(1,-58,0,3)
	local clrIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Clear.png") or "", TEXT, consoleClearBtn)
	clrIco.Size = UDim2.new(0,12,0,12)
	clrIco.Position = UDim2.new(0,4,0.5,-6)
	local clrLbl = MkLabel("Clear", GothamMed, 11, TEXT, consoleClearBtn)
	clrLbl.Size = UDim2.new(1,-18,1,0)
	clrLbl.Position = UDim2.new(0,18,0,0)

	local consoleScroll = Instance.new("ScrollingFrame")
	consoleScroll.BackgroundColor3 = BG2
	consoleScroll.BorderSizePixel = 1
	consoleScroll.BorderColor3 = BORDER
	consoleScroll.ScrollBarThickness = 0
	consoleScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	consoleScroll.CanvasSize = UDim2.new(0,0,0,0)
	consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	consoleScroll.Size = UDim2.new(1,0,1,-32)
	consoleScroll.LayoutOrder = 2
	consoleScroll.Parent = ConsoleContent
	MkPad(4,4,4,4,consoleScroll)
	local consoleList = MkList(Enum.FillDirection.Vertical, 2, consoleScroll)
	UI.ConsoleScroll = consoleScroll
	UI.ConsoleList = consoleList

	local ConsoleEntries = {}

	local function AddConsoleEntry(kind, msg)
		local col = kind=="warn" and Color3.fromRGB(255,200,60)
			or kind=="error" and Color3.fromRGB(255,80,80)
			or Color3.fromRGB(220,220,220)
		local prefix = kind=="warn" and "[WARN] " or kind=="error" and "[ERROR] " or "[INFO] "
		local entry = Instance.new("TextLabel")
		entry.BackgroundTransparency = 1
		entry.BorderSizePixel = 0
		entry.FontFace = Inconsolata
		entry.TextSize = 11
		entry.TextColor3 = col
		entry.Text = prefix..tostring(msg)
		entry.Size = UDim2.new(1,0,0,0)
		entry.AutomaticSize = Enum.AutomaticSize.Y
		entry.TextWrapped = true
		entry.TextXAlignment = Enum.TextXAlignment.Left
		entry.TextYAlignment = Enum.TextYAlignment.Top
		entry.Parent = consoleScroll
		table.insert(ConsoleEntries, entry)
		task.defer(function()
			consoleScroll.CanvasPosition = Vector2.new(0, math.max(0, consoleScroll.AbsoluteCanvasSize.Y - consoleScroll.AbsoluteSize.Y))
		end)
		if #ConsoleEntries > 200 then
			local old = table.remove(ConsoleEntries, 1)
			if old and old.Parent then old:Destroy() end
		end
	end
	UI.AddConsoleEntry = AddConsoleEntry
	Funcs.AddConsoleEntry = AddConsoleEntry

	local _print = print
	local _warn = warn
	print = function(...)
		local args = {...}
		local parts = {}
		for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
		local msg = table.concat(parts, "\t")
		_print(...)
		pcall(function() if ConsoleContent and ConsoleContent.Parent then AddConsoleEntry("print", msg) end end)
	end
	warn = function(...)
		local args = {...}
		local parts = {}
		for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
		local msg = table.concat(parts, "\t")
		_warn(...)
		pcall(function() if ConsoleContent and ConsoleContent.Parent then AddConsoleEntry("warn", msg) end end)
	end

	consoleClearBtn.MouseButton1Click:Connect(function()
		for _, e in ipairs(ConsoleEntries) do if e and e.Parent then e:Destroy() end end
		ConsoleEntries = {}
	end)
	AddConsoleEntry("print", "Console ready.")
end

-- Search Page (Filter button moved 2 pixels to right: -64)
local SearchPrevBtn, SearchNextBtn
do
	MkPad(6,6,6,6,SearchContent)
	local sl = MkList(Enum.FillDirection.Vertical, 4, SearchContent)

	local searchBar = MkFrame(BG2, UDim2.new(1,0,0,32), SearchContent)
	searchBar.LayoutOrder = 1
	local sbl = MkList(Enum.FillDirection.Horizontal, 4, searchBar)
	MkPad(4,4,3,3,searchBar)

	local srcBtn = MkBtn("RScripts", GothamMed, 11, Color3.fromRGB(80,220,120), BG3, searchBar)
	srcBtn.Size = UDim2.new(0,80,1,0)
	UI.SourceBtn = srcBtn

	local sbox = Instance.new("TextBox")
	sbox.BackgroundTransparency = 1
	sbox.BorderSizePixel = 0
	sbox.FontFace = GothamMed
	sbox.TextSize = 11
	sbox.PlaceholderColor3 = SUBTEXT
	sbox.PlaceholderText = "Search scripts..."
	sbox.TextColor3 = TEXT
	sbox.Text = ""
	sbox.TextXAlignment = Enum.TextXAlignment.Left
	sbox.Size = UDim2.new(1,-154,1,0)
	sbox.Parent = searchBar
	UI.SearchBox = sbox

	local filterBtn = MkBtn("", GothamMed, 11, SUBTEXT, BG3, searchBar)
	filterBtn.Size = UDim2.new(0,64,1,0)
	filterBtn.Position = UDim2.new(1,-64,0,0) -- moved 2 pixels to the right
	UI.FilterBtn = filterBtn
	local filterIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Filter.png") or "", SUBTEXT, filterBtn)
	filterIco.Size = UDim2.new(0,12,0,12)
	filterIco.Position = UDim2.new(0,4,0.5,-6)
	local filterLbl = MkLabel("All", GothamMed, 11, SUBTEXT, filterBtn)
	filterLbl.Size = UDim2.new(1,-16,1,0)
	filterLbl.Position = UDim2.new(0,16,0,0)
	UI.FilterLabel = filterLbl

	local resultsScroll = MkScroll(Enum.ScrollingDirection.Y, SearchContent)
	resultsScroll.LayoutOrder = 2
	resultsScroll.Size = UDim2.new(1,0,1,-70)
	local rsl = MkList(Enum.FillDirection.Vertical, 4, resultsScroll)
	UI.SearchResults = resultsScroll
	UI.SearchResultsLayout = rsl

	local noResultsL = MkLabel("No scripts found.", GothamMed, 12, SUBTEXT, resultsScroll)
	noResultsL.Size = UDim2.new(1,0,0,30)
	noResultsL.Visible = false
	UI.NoResultsLabel = noResultsL

	local pageRow = MkFrame(BG2, UDim2.new(1,0,0,30), SearchContent)
	pageRow.LayoutOrder = 3
	local prevBtn = MkBtn("< Prev", GothamMed, 11, TEXT, BG3, pageRow)
	prevBtn.Size = UDim2.new(0,60,0,24)
	prevBtn.Position = UDim2.new(0,4,0,3)
	prevBtn.Visible = false
	SearchPrevBtn = prevBtn
	UI.PrevBtn = prevBtn

	local nextBtn = MkBtn("Next >", GothamMed, 11, TEXT, BG3, pageRow)
	nextBtn.Size = UDim2.new(0,60,0,24)
	nextBtn.Position = UDim2.new(1,-64,0,3)
	nextBtn.Visible = false
	SearchNextBtn = nextBtn
	UI.NextBtn = nextBtn

	local SRTemplate = Instance.new("Frame")
	SRTemplate.BackgroundColor3 = BG2
	SRTemplate.BorderSizePixel = 1
	SRTemplate.BorderColor3 = BORDER
	SRTemplate.Size = UDim2.new(1,0,0,58)
	SRTemplate.Visible = false
	SRTemplate.Parent = resultsScroll
	UI.SRTemplate = SRTemplate

	local srtImg = Instance.new("ImageLabel")
	srtImg.BackgroundColor3 = BG3
	srtImg.BorderSizePixel = 0
	srtImg.Name = "SRImg"
	srtImg.Size = UDim2.new(0,58,1,0)
	srtImg.ScaleType = Enum.ScaleType.Crop
	srtImg.Parent = SRTemplate

	local srtInfo = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,-58,1,0), SRTemplate)
	srtInfo.Position = UDim2.new(0,58,0,0)
	srtInfo.BackgroundTransparency = 1
	srtInfo.Name = "SRInfo"
	MkPad(6,6,4,4,srtInfo)

	local srtName = MkLabel("Script Name", GothamBold, 12, WHITE, srtInfo)
	srtName.Size = UDim2.new(1,0,0,16)
	srtName.TextXAlignment = Enum.TextXAlignment.Left
	srtName.Name = "SRName"

	local srtKey = MkLabel("Keyless", GothamMed, 10, Color3.fromRGB(80,200,120), srtInfo)
	srtKey.Position = UDim2.new(0,0,0,16)
	srtKey.Size = UDim2.new(1,0,0,12)
	srtKey.TextXAlignment = Enum.TextXAlignment.Left
	srtKey.Name = "SRKey"

	local srtActions = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,20), srtInfo)
	srtActions.Position = UDim2.new(0,0,0,30)
	srtActions.BackgroundTransparency = 1
	srtActions.Name = "SRActions"

	local function MkSRBtn(text, iconPath, order, parent)
		local b = MkBtn("", GothamMed, 10, TEXT, BG3, parent)
		b.Size = UDim2.new(0,58,1,0)
		b.Position = UDim2.new(0, (order-1)*62, 0, 0)

		local ico = MkImg(Funcs.GetAsset(iconPath), TEXT, b)
		ico.Size = UDim2.new(0,12,0,12)
		ico.Position = UDim2.new(0,4,0.5,-6)

		local lbl = MkLabel(text, GothamMed, 10, TEXT, b)
		lbl.Size = UDim2.new(1,-16,1,0)
		lbl.Position = UDim2.new(0,16,0,0)
		lbl.TextXAlignment = Enum.TextXAlignment.Center

		return b
	end
	local srtRun = MkSRBtn("Run", "Lucid/Assets/Lucid_Execute.png", 1, srtActions) srtRun.Name = "SRRun"
	local srtCopy = MkSRBtn("Copy", "Lucid/Assets/Lucid_Clipboard.png", 2, srtActions) srtCopy.Name = "SRCopy"
	local srtSave = MkSRBtn("Save", "Lucid/Assets/Lucid_Star.png", 3, srtActions) srtSave.Name = "SRSave"

	function Funcs.CreateResultCard(data, parent)
		local title = data.title or data.name or "Untitled Script"
		local isSB = SrcIdx==2
		local rawScript = isSB and (data.script or "") or (data.rawScript or data.raw or "")
		local clone = SRTemplate:Clone()
		clone.Name = Funcs.SanitizeName(title)
		clone.Visible = true
		clone.Parent = parent
		local img = clone:FindFirstChild("SRImg")
		if img then
			local rawUrl = Funcs.ResolveImage(data)
			if rawUrl ~= "" then
				coroutine.wrap(function()
					local safeName = "Lucid/Cache/"..HttpService:GenerateGUID(false):sub(1,12)..".png"
					if not IsFolder("Lucid/Cache") then MakeFolder("Lucid/Cache") end
					local ok, res = pcall(function()
						local f = (syn and syn.request) or request or http_request
						return f and f({Url=rawUrl, Method="GET"})
					end)
					if ok and res and res.Body and #res.Body > 0 then
						pcall(function() WriteFile(safeName, res.Body) end)
						local asset = pcall(LoadAsset, safeName) and LoadAsset(safeName)
						if asset and img and img.Parent then img.Image = asset end
					end
				end)()
			end
		end
		local info = clone:FindFirstChild("SRInfo")
		if info then
			local nm = info:FindFirstChild("SRName")
			if nm then nm.Text = title end
			local key = info:FindFirstChild("SRKey")
			if key then
				if Funcs.ScriptNeedsKey(data) then
					key.Text = "Key Required"
					key.TextColor3 = Color3.fromRGB(230,160,60)
				else
					key.Text = "Keyless"
					key.TextColor3 = Color3.fromRGB(80,200,120)
				end
			end
			local acts = info:FindFirstChild("SRActions")
			if acts then
				local function ResolveCode()
					if rawScript=="" then return nil end
					if isSB then return rawScript end
					local ok, content = pcall(function() return game:HttpGet(rawScript) end)
					return ok and content or nil
				end
				local runB = acts:FindFirstChild("SRRun")
				local copyB = acts:FindFirstChild("SRCopy")
				local saveB = acts:FindFirstChild("SRSave")
				if runB then runB.MouseButton1Click:Connect(function()
					local code = ResolveCode()
					if code then pcall(loadstring(code)) end
				end) end
				if copyB then copyB.MouseButton1Click:Connect(function()
					local code = ResolveCode()
					if code then
						SetClipboard(code)
						local lbl = copyB:FindFirstChildOfClass("TextLabel")
						if lbl then lbl.Text="Copied" task.delay(1.5,function() lbl.Text="Copy" end) end
					end
				end) end
				if saveB then saveB.MouseButton1Click:Connect(function()
					local code = ResolveCode()
					if code then
						Funcs.SaveScript({Name=title, Description=data.description or "", Code=code})
						local lbl = saveB:FindFirstChildOfClass("TextLabel")
						if lbl then lbl.Text="Saved" task.delay(1.5,function() lbl.Text="Save" end) end
					end
				end) end
			end
		end
	end

	function Funcs.RenderSearchResults()
		for _, child in ipairs(resultsScroll:GetChildren()) do
			if child~=UI.NoResultsLabel and child~=SRTemplate and not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end
		local shown = 0
		for _, data in ipairs(CurrentScripts) do
			if Funcs.PassesFilter(data) then
				shown = shown + 1
				Funcs.CreateResultCard(data, resultsScroll)
			end
		end
		UI.NoResultsLabel.Visible = shown==0
	end

	function Funcs.PerformSearch(query, page)
		page = page or 1
		currentQuery = query
		currentPage = page
		UI.NoResultsLabel.Visible = false
		prevBtn.Visible = false
		nextBtn.Visible = false
		local scripts, pages = Funcs.FetchScripts(query, page)
		if not scripts then
			CurrentScripts = {}
			Funcs.RenderSearchResults()
			UI.NoResultsLabel.Visible = true
			UI.NoResultsLabel.Text = "Failed to fetch. Check connection."
			return
		end
		totalPages = pages or 1
		CurrentScripts = scripts
		prevBtn.Visible = page>1
		nextBtn.Visible = page<totalPages
		Funcs.RenderSearchResults()
	end

	sbox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = sbox.Text
		if q~="" then Funcs.PerformSearch(q,1)
		elseif SrcIdx==2 then Funcs.PerformSearch("",1)
		else CurrentScripts={} Funcs.RenderSearchResults() UI.NoResultsLabel.Visible=false end
	end)
	prevBtn.MouseButton1Click:Connect(function() if currentPage>1 then Funcs.PerformSearch(currentQuery, currentPage-1) end end)
	nextBtn.MouseButton1Click:Connect(function() if currentPage<totalPages then Funcs.PerformSearch(currentQuery, currentPage+1) end end)
	srcBtn.MouseButton1Click:Connect(function()
		SrcIdx = SrcIdx%#Srcs+1
		if SrcIdx==1 then srcBtn.Text="RScripts" srcBtn.TextColor3=Color3.fromRGB(80,220,120)
		else srcBtn.Text="ScriptBlox" srcBtn.TextColor3=Color3.fromRGB(230,160,60) end
		Funcs.PerformSearch(sbox.Text,1)
	end)
	filterBtn.MouseButton1Click:Connect(function()
		FilterIdx = FilterIdx%#Filters+1
		filterLbl.Text = Filters[FilterIdx]
		Funcs.RenderSearchResults()
	end)
end

-- Scripts Library Page (right padding set equal to left padding: 6px)
do
	MkPad(6,6,6,6,ScriptsContent)
	local sl = MkList(Enum.FillDirection.Vertical, 4, ScriptsContent)

	local searchBar = MkFrame(BG2, UDim2.new(1,0,0,32), ScriptsContent)
	searchBar.LayoutOrder = 1
	local sbox2 = Instance.new("TextBox")
	sbox2.BackgroundTransparency = 1
	sbox2.BorderSizePixel = 0
	sbox2.FontFace = GothamMed
	sbox2.TextSize = 11
	sbox2.PlaceholderColor3 = SUBTEXT
	sbox2.PlaceholderText = "Search saved scripts..."
	sbox2.TextColor3 = TEXT
	sbox2.Text = ""
	sbox2.TextXAlignment = Enum.TextXAlignment.Left
	sbox2.Size = UDim2.new(1,-38,1,0)
	sbox2.Position = UDim2.new(0,6,0,0)
	sbox2.Parent = searchBar
	UI.SavedSearchBox = sbox2

	local newScriptBtn = MkBtn("", GothamBold, 14, WHITE, ACCENT, searchBar)
	newScriptBtn.Size = UDim2.new(0,28,0,26)
	newScriptBtn.Position = UDim2.new(1,-30,0,3)
	UI.NewScriptBtn = newScriptBtn
	local newScrIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png") or "", WHITE, newScriptBtn)
	newScrIco.AnchorPoint = Vector2.new(0.5,0.5)
	newScrIco.Position = UDim2.new(0.5,0,0.5,0)
	newScrIco.Size = UDim2.new(0.6,0,0.6,0)

	local savedScroll = MkScroll(Enum.ScrollingDirection.Y, ScriptsContent)
	savedScroll.LayoutOrder = 2
	savedScroll.Size = UDim2.new(1,0,1,-36)
	local ssl = MkList(Enum.FillDirection.Vertical, 4, savedScroll)
	UI.SavedScriptsScroll = savedScroll

	local noSavedL = MkLabel("No saved scripts.", GothamMed, 11, SUBTEXT, savedScroll)
	noSavedL.Size = UDim2.new(1,0,0,30)
	noSavedL.Visible = false
	UI.NoSavedLabel = noSavedL

	function Funcs.RefreshSavedScripts(query)
		for _, child in ipairs(savedScroll:GetChildren()) do
			if child~=UI.NoSavedLabel and not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end
		local scripts = Funcs.LoadSavedScripts()
		if query and query~="" then
			local q = query:lower()
			local filtered = {}
			for _, sd in ipairs(scripts) do
				if (sd.Name or ""):lower():find(q) or (sd.Description or ""):lower():find(q) then
					table.insert(filtered, sd)
				end
			end
			scripts = filtered
		end
		if #scripts==0 then
			UI.NoSavedLabel.Visible = true
			return
		end
		UI.NoSavedLabel.Visible = false

		for _, sd in ipairs(scripts) do
			local card = MkFrame(BG2, UDim2.new(1,0,0,46), savedScroll)
			MkPad(6,6,4,4,card) -- right padding = 6 (same as left padding)
			local nameLbl = MkLabel(sd.Name or "Unknown", GothamBold, 12, WHITE, card)
			nameLbl.Size = UDim2.new(1,-118,0,18)
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left

			local runBtn = MkBtn("", GothamMed, 10, TEXT, BG3, card)
			runBtn.Size = UDim2.new(0,54,0,22)
			runBtn.Position = UDim2.new(1,-110,0,12)
			local rIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Execute.png"), TEXT, runBtn)
			rIco.Size = UDim2.new(0,12,0,12) rIco.Position = UDim2.new(0,4,0.5,-6)
			local rLbl = MkLabel("Run", GothamMed, 10, TEXT, runBtn)
			rLbl.Size = UDim2.new(1,-16,1,0) rLbl.Position = UDim2.new(0,16,0,0) rLbl.TextXAlignment = Enum.TextXAlignment.Center

			local delBtn = MkBtn("", GothamMed, 10, Color3.fromRGB(220,80,80), BG3, card)
			delBtn.Size = UDim2.new(0,54,0,22)
			delBtn.Position = UDim2.new(1,-52,0,12)
			local dIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Clear.png"), Color3.fromRGB(220,80,80), delBtn)
			dIco.Size = UDim2.new(0,12,0,12) dIco.Position = UDim2.new(0,4,0.5,-6)
			local dLbl = MkLabel("Delete", GothamMed, 10, Color3.fromRGB(220,80,80), delBtn)
			dLbl.Size = UDim2.new(1,-16,1,0) dLbl.Position = UDim2.new(0,16,0,0) dLbl.TextXAlignment = Enum.TextXAlignment.Center

			runBtn.MouseButton1Click:Connect(function()
				local code = sd.Code or sd.Script
				if code and code ~= "" then pcall(loadstring(code)) end
			end)
			delBtn.MouseButton1Click:Connect(function()
				Funcs.DeleteScript(sd.Name)
				Funcs.RefreshSavedScripts(sbox2.Text)
			end)
		end
	end

	sbox2:GetPropertyChangedSignal("Text"):Connect(function() Funcs.RefreshSavedScripts(sbox2.Text) end)

	local NewScriptPopup = Instance.new("Frame")
	NewScriptPopup.AnchorPoint = Vector2.new(0.5,0.5)
	NewScriptPopup.BackgroundColor3 = BG2
	NewScriptPopup.BorderSizePixel = 1
	NewScriptPopup.BorderColor3 = BORDER
	NewScriptPopup.Position = UDim2.new(0.5,0,0.5,0)
	NewScriptPopup.Size = UDim2.new(0,320,0,200)
	NewScriptPopup.Visible = false
	NewScriptPopup.ZIndex = 10
	NewScriptPopup.Parent = Screen

	MkPad(8,8,8,8,NewScriptPopup)
	local nsl = MkList(Enum.FillDirection.Vertical, 4, NewScriptPopup)

	local function MkInputField(placeholder, multiline)
		local box = Instance.new("TextBox")
		box.BackgroundColor3 = BG3
		box.BorderSizePixel = 1
		box.BorderColor3 = BORDER
		box.FontFace = multiline and Inconsolata or GothamMed
		box.TextSize = 11
		box.PlaceholderColor3 = SUBTEXT
		box.PlaceholderText = placeholder
		box.TextColor3 = TEXT
		box.Text = ""
		box.TextXAlignment = Enum.TextXAlignment.Left
		if multiline then
			box.MultiLine = true
			box.TextYAlignment = Enum.TextYAlignment.Top
			box.Size = UDim2.new(1,0,0,80)
		else
			box.Size = UDim2.new(1,0,0,26)
		end
		box.Parent = NewScriptPopup
		return box
	end

	local nameBox3 = MkInputField("Script name...", false)
	local descBox3 = MkInputField("Description...", false)
	local codeBox3 = MkInputField("-- Code here...", true)

	local popupBtns = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,28), NewScriptPopup)
	popupBtns.BackgroundTransparency = 1
	local savePopupBtn = MkBtn("Save", GothamMed, 11, WHITE, ACCENT, popupBtns)
	savePopupBtn.Size = UDim2.new(0,60,1,0)
	savePopupBtn.Position = UDim2.new(1,-124,0,0)
	local cancelPopupBtn = MkBtn("Cancel", GothamMed, 11, TEXT, BG3, popupBtns)
	cancelPopupBtn.Size = UDim2.new(0,60,1,0)
	cancelPopupBtn.Position = UDim2.new(1,-60,0,0)

	newScriptBtn.MouseButton1Click:Connect(function()
		nameBox3.Text="" descBox3.Text="" codeBox3.Text=""
		NewScriptPopup.Visible = true
	end)
	cancelPopupBtn.MouseButton1Click:Connect(function() NewScriptPopup.Visible=false end)
	savePopupBtn.MouseButton1Click:Connect(function()
		if nameBox3.Text=="" then return end
		Funcs.SaveScript({Name=nameBox3.Text, Description=descBox3.Text, Code=codeBox3.Text})
		NewScriptPopup.Visible=false
		Funcs.RefreshSavedScripts(sbox2.Text)
	end)
end

-- Music Player Page
do
	MkPad(6,6,6,6,MusicContent)
	local ml = MkList(Enum.FillDirection.Vertical, 6, MusicContent)

	local controlsHolder = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,130), MusicContent)
	controlsHolder.BackgroundTransparency = 1
	local chl = MkList(Enum.FillDirection.Vertical, 4, controlsHolder)

	local nowPlayingBox = MkFrame(BG2, UDim2.new(1,0,0,44), controlsHolder)
	MkPad(6,6,4,4,nowPlayingBox)
	local npTitle = MkLabel("No song playing", GothamBold, 12, WHITE, nowPlayingBox)
	npTitle.Size = UDim2.new(1,0,0,16)
	npTitle.TextXAlignment = Enum.TextXAlignment.Center
	UI.NowPlayingLabel = npTitle

	local npSub = MkLabel("Place audio files in Lucid/Music/", GothamMed, 10, SUBTEXT, nowPlayingBox)
	npSub.Position = UDim2.new(0,0,0,16)
	npSub.Size = UDim2.new(1,0,0,14)
	npSub.TextXAlignment = Enum.TextXAlignment.Center
	UI.NowPlayingSubLabel = npSub

	local sliderBar = MkFrame(BG3, UDim2.new(1,0,0,6), controlsHolder)
	sliderBar.Name = "SliderBar"
	UI.MusicSliderBar = sliderBar
	local sliderFill = MkFrame(ACCENT, UDim2.new(0,0,1,0), sliderBar)
	sliderFill.Name = "SliderFill"
	UI.MusicSliderFill = sliderFill

	local controlsRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,30), controlsHolder)
	controlsRow.BackgroundTransparency = 1

	local function MkCtrlBtn(iconPath, order)
		local b = MkBtn("", GothamBold, 11, TEXT, BG2, controlsRow)
		b.Size = UDim2.new(0,36,1,0)
		b.Position = UDim2.new(0, (order-1)*40, 0, 0)
		local ico = MkImg(Funcs.GetAsset(iconPath), TEXT, b)
		ico.Size = UDim2.new(0,14,0,14) ico.AnchorPoint = Vector2.new(0.5,0.5) ico.Position = UDim2.new(0.5,0,0.5,0)
		return b
	end
	local prevMusicBtn = MkCtrlBtn("Lucid/Assets/Lucid_Previous.png", 1) UI.MusicPrevBtn = prevMusicBtn
	local playMusicBtn = MkCtrlBtn("Lucid/Assets/Lucid_Play.png", 2) UI.MusicPlayBtn = playMusicBtn UI.MusicPlayIcon = playMusicBtn:FindFirstChildOfClass("ImageLabel")
	local nextMusicBtn = MkCtrlBtn("Lucid/Assets/Lucid_Next.png", 3) UI.MusicNextBtn = nextMusicBtn

	local musicListScroll = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,-140), MusicContent)
	musicListScroll.BackgroundTransparency = 1
	local mll = MkList(Enum.FillDirection.Vertical, 3, musicListScroll)
	UI.MusicListScroll = musicListScroll

	local noMusicL = MkLabel("No music found.\nPlace files in Lucid/Music/", GothamMed, 11, SUBTEXT, musicListScroll)
	noMusicL.Size = UDim2.new(1,0,0,30)
	noMusicL.Visible = false
	UI.NoMusicLabel = noMusicL

	local volBox = Instance.new("TextBox") volBox.Text = "1" UI.MusicVolumeBox = volBox
	local spdBox = Instance.new("TextBox") spdBox.Text = "1" UI.MusicSpeedBox = spdBox
	local loopTog = Instance.new("TextButton") UI.MusicLoopToggle = loopTog
	local knob = Instance.new("Frame") UI.MusicSliderKnob = knob
	local curTime = MkLabel("0:00", GothamMed, 10, SUBTEXT, controlsHolder) UI.MusicTimeCurrent = curTime
	local durTime = MkLabel("0:00", GothamMed, 10, SUBTEXT, controlsHolder) UI.MusicTimeDuration = durTime

	function Funcs.UpdateMusicSlider()
		if not MusicSound or not MusicSound.Parent then return end
		local dur = MusicSound.TimeLength
		local pos = MusicSound.TimePosition
		if dur and dur>0 and not MusicSliderDragging then
			local frac = math.clamp(pos/dur, 0, 1)
			sliderFill.Size = UDim2.new(frac, 0, 1, 0)
		end
	end

	function Funcs.LoadAndPlayMusic(index)
		if not MusicFiles or #MusicFiles==0 then return end
		index = ((index-1)%#MusicFiles)+1
		MusicIndex = index
		local filePath = MusicFiles[index]
		if MusicSound then MusicSound:Stop() MusicSound:Destroy() MusicSound=nil end
		local assetId = pcall(LoadAsset, filePath) and LoadAsset(filePath)
		if not assetId then
			UI.NowPlayingLabel.Text = "Load failed"
			return
		end
		MusicSound = Instance.new("Sound")
		MusicSound.SoundId = assetId
		MusicSound.Volume = 1
		MusicSound.PlaybackSpeed = 1
		MusicSound.Parent = Workspace
		MusicSound:Play()
		MusicPlaying = true
		if UI.MusicPlayIcon then UI.MusicPlayIcon.Image = Funcs.GetAsset("Lucid/Assets/Lucid_Pause.png") or "" end
		UI.NowPlayingLabel.Text = Funcs.GetMusicDisplayName(filePath)
		MusicSound.Ended:Connect(function()
			Funcs.LoadAndPlayMusic(MusicIndex+1)
		end)
		Funcs.RefreshMusicList()
	end

	function Funcs.RefreshMusicList()
		MusicFiles = Funcs.GetMusicFiles()
		for _, child in ipairs(musicListScroll:GetChildren()) do
			if child~=UI.NoMusicLabel and not child:IsA("UIListLayout") then child:Destroy() end
		end
		if #MusicFiles==0 then
			UI.NoMusicLabel.Visible=true
			return
		end
		UI.NoMusicLabel.Visible = false
		for i, filePath in ipairs(MusicFiles) do
			local dn = Funcs.GetMusicDisplayName(filePath)
			local row = MkBtn("", GothamMed, 11, TEXT, BG2, musicListScroll)
			row.Size = UDim2.new(1,0,0,28)
			MkPad(6,0,0,0,row)
			local ico = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Music.png"), TEXT, row)
			ico.Size = UDim2.new(0,14,0,14) ico.Position = UDim2.new(0,4,0.5,-7)
			local lbl = MkLabel(dn, GothamMed, 11, TEXT, row)
			lbl.Size = UDim2.new(1,-24,1,0) lbl.Position = UDim2.new(0,22,0,0) lbl.TextXAlignment = Enum.TextXAlignment.Left

			local ci = i
			row.MouseButton1Click:Connect(function() Funcs.LoadAndPlayMusic(ci) end)
		end
	end

	playMusicBtn.MouseButton1Click:Connect(function()
		if not MusicSound or not MusicSound.Parent then
			MusicFiles = Funcs.GetMusicFiles()
			if #MusicFiles>0 then Funcs.LoadAndPlayMusic(MusicIndex) end
			return
		end
		if MusicPlaying then
			MusicSound:Pause()
			MusicPlaying = false
			if UI.MusicPlayIcon then UI.MusicPlayIcon.Image = Funcs.GetAsset("Lucid/Assets/Lucid_Play.png") or "" end
		else
			MusicSound:Resume()
			MusicPlaying = true
			if UI.MusicPlayIcon then UI.MusicPlayIcon.Image = Funcs.GetAsset("Lucid/Assets/Lucid_Pause.png") or "" end
		end
	end)
	prevMusicBtn.MouseButton1Click:Connect(function()
		MusicFiles=Funcs.GetMusicFiles()
		if #MusicFiles>0 then Funcs.LoadAndPlayMusic(MusicIndex-1) end
	end)
	nextMusicBtn.MouseButton1Click:Connect(function()
		MusicFiles=Funcs.GetMusicFiles()
		if #MusicFiles>0 then Funcs.LoadAndPlayMusic(MusicIndex+1) end
	end)
end

-- Settings Page
do
	MkPad(6,6,6,6,SettingsContent)
	local sl = MkList(Enum.FillDirection.Vertical, 4, SettingsContent)

	local discordRow = MkFrame(BG2, UDim2.new(1,0,0,32), SettingsContent)
	local dIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Discord.png"), WHITE, discordRow)
	dIco.Size = UDim2.new(0,16,0,16) dIco.Position = UDim2.new(0,8,0.5,-8)

	local dLbl = MkLabel("Discord Server", GothamMed, 11, TEXT, discordRow)
	dLbl.Size = UDim2.new(1,-120,1,0) dLbl.Position = UDim2.new(0,30,0,0) dLbl.TextXAlignment = Enum.TextXAlignment.Left

	local discordBtn = MkBtn("", GothamMed, 11, TEXT, BG3, discordRow)
	discordBtn.Size = UDim2.new(0,80,0,24)
	discordBtn.Position = UDim2.new(1,-84,0,4)
	local clipIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Clipboard.png"), TEXT, discordBtn)
	clipIco.Size = UDim2.new(0,12,0,12) clipIco.Position = UDim2.new(0,4,0.5,-6)
	local clipLbl = MkLabel("Copy", GothamMed, 11, TEXT, discordBtn)
	clipLbl.Size = UDim2.new(1,-16,1,0) clipLbl.Position = UDim2.new(0,16,0,0) clipLbl.TextXAlignment = Enum.TextXAlignment.Center
	discordBtn.MouseButton1Click:Connect(function()
		SetClipboard("https://discord.gg/KS8dBeQm9q")
		clipLbl.Text = "Copied"
		task.delay(1.5, function() clipLbl.Text = "Copy" end)
	end)

	local function MkSettingRow(label, callbackText, callback)
		local row = MkFrame(BG2, UDim2.new(1,0,0,32), SettingsContent)
		local lbl = MkLabel("  "..label, GothamMed, 11, TEXT, row)
		lbl.Size = UDim2.new(1,-90,1,0)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		local btn = MkBtn(callbackText, GothamMed, 11, TEXT, BG3, row)
		btn.Size = UDim2.new(0,80,0,24)
		btn.Position = UDim2.new(1,-84,0,4)
		btn.MouseButton1Click:Connect(callback)
		return row
	end

	local themes = {"Default Classic", "Midnight", "Amethyst", "Crimson", "Emerald", "Ocean"}
	local themeRow = MkFrame(BG2, UDim2.new(1,0,0,32), SettingsContent)
	local themeLbl = MkLabel("  Theme Preset", GothamMed, 11, TEXT, themeRow)
	themeLbl.Size = UDim2.new(1,-120,1,0)
	themeLbl.TextXAlignment = Enum.TextXAlignment.Left
	local themeBtn = MkBtn(Settings.ThemePreset or "Default Classic", GothamMed, 11, TEXT, BG3, themeRow)
	themeBtn.Size = UDim2.new(0,110,0,24)
	themeBtn.Position = UDim2.new(1,-114,0,4)
	local tIdx = 1
	themeBtn.MouseButton1Click:Connect(function()
		tIdx = tIdx % #themes + 1
		local preset = themes[tIdx]
		themeBtn.Text = preset
		Funcs.ApplyTheme(preset)
	end)

	MkSettingRow("Destroy UI", "Destroy", function()
		Env.__Lucid.IsLoaded = false
		if MusicSound then pcall(function() MusicSound:Stop() MusicSound:Destroy() end) end
		pcall(function() Screen:Destroy() end)
		pcall(function() ShowBtn:Destroy() end)
		pcall(function() Overlay:Destroy() end)
	end)
end

ShowBtn.MouseButton1Click:Connect(function() Funcs.OpenUI() end)
CloseBtn.MouseButton1Click:Connect(function() Funcs.CloseUI() end)

PageBtns["Home"].BackgroundColor3 = ACCENT
PageContents["Home"].Visible = true

Funcs.InitDefaultScripts()
Funcs.UpdateStats()

coroutine.wrap(function()
	while Screen and Screen.Parent do
		pcall(Funcs.UpdateStats)
		pcall(Funcs.UpdateMusicSlider)
		task.wait(1)
	end
end)()

Players.PlayerRemoving:Connect(function(player)
	if player==Player then
		if MusicSound then MusicSound:Stop() MusicSound:Destroy() end
		Funcs.ClearCache()
	end
end)
pcall(function()
	game:BindToClose(function()
		Funcs.ClearCache()
	end)
end)