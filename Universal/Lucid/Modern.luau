if not game:IsLoaded() then game.Loaded:Wait() end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(n) local s = game:GetService(n) return cloneref and cloneref(s) or s end

local Hui = gethui and gethui() or GetService("CoreGui")
local Workspace = GetService("Workspace")
local HttpService = GetService("HttpService")
local Players = GetService("Players")
local Player = Players.LocalPlayer
local UIS = GetService("UserInputService")
local TweenService = GetService("TweenService")
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
local GothamReg = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local Inconsolata = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local BG = Color3.fromRGB(15, 15, 18)
local BG2 = Color3.fromRGB(22, 22, 27)
local BG3 = Color3.fromRGB(30, 30, 36)
local ACCENT = Color3.fromRGB(60, 130, 255)
local ACCENT2 = Color3.fromRGB(40, 100, 220)
local TEXT = Color3.fromRGB(230, 230, 235)
local SUBTEXT = Color3.fromRGB(140, 140, 150)
local WHITE = Color3.fromRGB(255, 255, 255)

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
		Animations = true,
		ThemePreset = "Default Dark",
		AccentColor = Color3.fromRGB(60, 130, 255),
		BGColor = Color3.fromRGB(15, 15, 18),
		BG2Color = Color3.fromRGB(22, 22, 27),
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

local function MkCorner(r, p) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p return c end
local function MkStroke(col, t, p) local s = Instance.new("UIStroke") s.Color = col s.Thickness = t or 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = p return s end
local function MkPad(l, r, t, b, p) local pad = Instance.new("UIPadding") pad.PaddingLeft = UDim.new(0,l) pad.PaddingRight = UDim.new(0,r) pad.PaddingTop = UDim.new(0,t) pad.PaddingBottom = UDim.new(0,b) pad.Parent = p return pad end
local function MkList(dir, pad, p) local l = Instance.new("UIListLayout") l.FillDirection = dir or Enum.FillDirection.Vertical l.Padding = UDim.new(0, pad or 4) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p return l end
local function MkFrame(bg, size, p) local f = Instance.new("Frame") f.BackgroundColor3 = bg f.BackgroundTransparency = 0 f.BorderSizePixel = 0 f.Size = size f.Parent = p return f end
local function MkLabel(text, font, size, col, p) local l = Instance.new("TextLabel") l.BackgroundTransparency = 1 l.BorderSizePixel = 0 l.Text = text l.FontFace = font l.TextSize = size l.TextColor3 = col l.TextWrapped = true l.Parent = p return l end
local function MkBtn(text, font, size, col, bg, p)
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = bg
	b.BorderSizePixel = 0
	b.Text = text
	b.FontFace = font
	b.TextSize = size
	b.TextColor3 = col
	b.AutoButtonColor = false
	b.Parent = p

	local isHovering = false
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local bgHover = bg:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
	if bg == Color3.fromRGB(0,0,0) or (bg.R == 0 and bg.G == 0 and bg.B == 0) then
		bgHover = Color3.fromRGB(35, 35, 42)
	elseif bg == Color3.fromRGB(15, 15, 18) then
		bgHover = Color3.fromRGB(22, 22, 27)
	elseif bg == Color3.fromRGB(22, 22, 27) then
		bgHover = Color3.fromRGB(30, 30, 36)
	end
	local bgPress = bg:Lerp(Color3.fromRGB(0, 0, 0), 0.15)

	b.MouseEnter:Connect(function()
		isHovering = true
		TweenService:Create(b, tweenInfo, {BackgroundColor3 = bgHover}):Play()
	end)
	b.MouseLeave:Connect(function()
		isHovering = false
		TweenService:Create(b, tweenInfo, {BackgroundColor3 = bg}):Play()
	end)
	b.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(b, tweenInfo, {BackgroundColor3 = bgPress}):Play()
		end
	end)
	b.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			TweenService:Create(b, tweenInfo, {BackgroundColor3 = isHovering and bgHover or bg}):Play()
		end
	end)

	return b
end
local function MkImg(img, col, p) local i = Instance.new("ImageLabel") i.BackgroundTransparency = 1 i.BorderSizePixel = 0 i.Image = img or "" i.ImageColor3 = col i.Parent = p return i end
local function MkScroll(dir, p) local s = Instance.new("ScrollingFrame") s.BackgroundTransparency = 1 s.BorderSizePixel = 0 s.ScrollBarThickness = 4 s.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70) s.ScrollingDirection = dir or Enum.ScrollingDirection.Y s.CanvasSize = UDim2.new(0,0,0,0) s.AutomaticCanvasSize = Enum.AutomaticSize.Y s.Parent = p return s end

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
	["Default Dark"] = {BG = Color3.fromRGB(15,15,18), BG2 = Color3.fromRGB(22,22,27), ACCENT = Color3.fromRGB(60,130,255)},
	["Midnight"]     = {BG = Color3.fromRGB(10,10,14), BG2 = Color3.fromRGB(18,18,24), ACCENT = Color3.fromRGB(140,80,255)},
	["Amethyst"]     = {BG = Color3.fromRGB(20,12,24), BG2 = Color3.fromRGB(32,20,38), ACCENT = Color3.fromRGB(170,80,255)},
	["Crimson"]      = {BG = Color3.fromRGB(22,12,14), BG2 = Color3.fromRGB(36,20,24), ACCENT = Color3.fromRGB(230,60,80)},
	["Emerald"]      = {BG = Color3.fromRGB(12,20,16), BG2 = Color3.fromRGB(20,34,26), ACCENT = Color3.fromRGB(46,204,113)},
	["Ocean"]        = {BG = Color3.fromRGB(12,18,26), BG2 = Color3.fromRGB(20,30,44), ACCENT = Color3.fromRGB(0,180,216)},
}

function Funcs.ApplyTheme(preset)
	local t = Themes[preset] or Themes["Default Dark"]
	local oldBG, oldBG2, oldACCENT = BG, BG2, ACCENT
	Settings.ThemePreset = preset
	Settings.BGColor = t.BG
	Settings.BG2Color = t.BG2
	Settings.AccentColor = t.ACCENT
	BG = t.BG
	BG2 = t.BG2
	ACCENT = t.ACCENT

	if UI.Screen then
		for _, descendant in ipairs(UI.Screen:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				if descendant.BackgroundColor3 == oldBG then
					descendant.BackgroundColor3 = BG
				elseif descendant.BackgroundColor3 == oldBG2 then
					descendant.BackgroundColor3 = BG2
				elseif descendant.BackgroundColor3 == oldACCENT then
					descendant.BackgroundColor3 = ACCENT
				end
			end
			if descendant:IsA("UIStroke") then
				if descendant.Color == oldBG then
					descendant.Color = BG
				elseif descendant.Color == oldBG2 then
					descendant.Color = BG2
				elseif descendant.Color == oldACCENT then
					descendant.Color = ACCENT
				end
			end
		end
	end

	if PageBtns and PageBtns[ActivePage] and PageBtns[ActivePage].frame then
		PageBtns[ActivePage].frame.BackgroundColor3 = ACCENT
	end
	Funcs.SaveSettings()
end

function Funcs.LoadSettings()
	if not IsFile("Lucid/Settings.json") then return end
	local content = ReadFile("Lucid/Settings.json")
	if not content or content=="" then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
	if ok and data then
		if data.Animations ~= nil then Settings.Animations = data.Animations end
		if data.ThemePreset and Themes[data.ThemePreset] then
			Funcs.ApplyTheme(data.ThemePreset)
		else
			if data.AccentColor then Settings.AccentColor = Color3.fromRGB(data.AccentColor.R or 60, data.AccentColor.G or 130, data.AccentColor.B or 255) end
			if data.BGColor then Settings.BGColor = Color3.fromRGB(data.BGColor.R or 15, data.BGColor.G or 15, data.BGColor.B or 18) end
			if data.BG2Color then Settings.BG2Color = Color3.fromRGB(data.BG2Color.R or 22, data.BG2Color.G or 22, data.BG2Color.B or 27) end
			ACCENT = Settings.AccentColor
			BG = Settings.BGColor
			BG2 = Settings.BG2Color
		end
	end
end

function Funcs.SaveSettings()
	if not IsFolder("Lucid") then MakeFolder("Lucid") end
	local data = {
		Animations = Settings.Animations,
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

Env.__Lucid.IsLoaded = true

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

local ShowBtn = Instance.new("ImageButton")
ShowBtn.BackgroundColor3 = BG2
ShowBtn.BackgroundTransparency = 0.05
ShowBtn.BorderSizePixel = 0
ShowBtn.Name = "ShowBtn"
ShowBtn.Position = UDim2.new(0, 16, 0, 60)
ShowBtn.Size = UDim2.new(0, 44, 0, 44)
ShowBtn.Visible = true
ShowBtn.ZIndex = 5
ShowBtn.Parent = Screen
UI.ShowBtn = ShowBtn
MkCorner(22, ShowBtn)
Instance.new("UIAspectRatioConstraint").Parent = ShowBtn
local ShowIcon = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Logo.png") or "", Color3.fromRGB(255,255,255), ShowBtn)
ShowIcon.AnchorPoint = Vector2.new(0.5,0.5)
ShowIcon.Position = UDim2.new(0.5,0,0.5,0)
ShowIcon.Size = UDim2.new(0.6,0,0.6,0)

local Overlay = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), Screen)
Overlay.BackgroundTransparency = 1
Overlay.Name = "Overlay"
Overlay.Visible = false
Overlay.ZIndex = 1
UI.Overlay = Overlay

local Main = Instance.new("Frame")
Main.BackgroundColor3 = BG
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Name = "Main"
Main.Size = UDim2.new(0.92, 0, 0.88, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Visible = false
Main.ZIndex = 2
Main.Parent = Screen
MkCorner(16, Main)
UI.Main = Main

local TopbarHolder = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,44), Main)
TopbarHolder.BackgroundTransparency = 1
TopbarHolder.Position = UDim2.new(0,0,0,8)
TopbarHolder.Name = "TopbarHolder"
TopbarHolder.ZIndex = 3

local TopbarPill = MkFrame(BG2, UDim2.new(0,0,0,44), TopbarHolder)
TopbarPill.AnchorPoint = Vector2.new(0.5,0.5)
TopbarPill.Position = UDim2.new(0.5,0,0.5,0)
TopbarPill.AutomaticSize = Enum.AutomaticSize.X
TopbarPill.Name = "TopbarPill"
TopbarPill.ZIndex = 3
MkCorner(22, TopbarPill)
MkStroke(Color3.fromRGB(50,50,65), 1, TopbarPill)
UI.TopbarPill = TopbarPill

local PillLayout = MkList(Enum.FillDirection.Horizontal, 4, TopbarPill)
PillLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PillLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MkPad(6, 6, 4, 4, TopbarPill)

local ActivePage = "Home"
local PageContents = {}
local PageBtns = {}

local ContentArea = MkFrame(BG, UDim2.new(1,0,1,-52), Main)
ContentArea.Position = UDim2.new(0,0,0,52)
ContentArea.Name = "ContentArea"
ContentArea.BackgroundTransparency = 1
UI.ContentArea = ContentArea

local ClosePill = MkFrame(BG2, UDim2.new(0,44,0,44), TopbarHolder)
ClosePill.AnchorPoint = Vector2.new(1,0.5)
ClosePill.Position = UDim2.new(1,-10,0.5,0)
ClosePill.ZIndex = 3
MkCorner(22, ClosePill)
MkStroke(Color3.fromRGB(50,50,65),1,ClosePill)
local CloseBtn = MkBtn("", GothamBold, 16, WHITE, Color3.fromRGB(0,0,0), ClosePill)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(1,0,1,0)
CloseBtn.Name = "CloseBtn"
local CloseIcon = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Close.png") or "", TEXT, ClosePill)
CloseIcon.AnchorPoint = Vector2.new(0.5,0.5)
CloseIcon.Position = UDim2.new(0.5,0,0.5,0)
CloseIcon.Size = UDim2.new(0.68,0,0.68,0)
UI.CloseBtn = CloseBtn

local InfoPill = MkFrame(BG2, UDim2.new(0,0,0,44), TopbarHolder)
InfoPill.AnchorPoint = Vector2.new(0,0.5)
InfoPill.Position = UDim2.new(0,10,0.5,0)
InfoPill.AutomaticSize = Enum.AutomaticSize.X
InfoPill.ZIndex = 3
MkCorner(22, InfoPill)
MkStroke(Color3.fromRGB(50,50,65),1,InfoPill)
local InfoLayout = MkList(Enum.FillDirection.Horizontal, 8, InfoPill)
InfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
MkPad(12,12,0,0,InfoPill)

local WifiIcon = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Wifi.png") or "", SUBTEXT, InfoPill)
WifiIcon.Size = UDim2.new(0,18,0,18)
WifiIcon.LayoutOrder = 1

local PingLbl = MkLabel("0 ms", GothamMed, 12, SUBTEXT, InfoPill)
PingLbl.Size = UDim2.new(0,42,0,44)
PingLbl.LayoutOrder = 2
PingLbl.TextXAlignment = Enum.TextXAlignment.Left
UI.PingLbl = PingLbl

local BoltIcon = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Bolt.png") or "", SUBTEXT, InfoPill)
BoltIcon.Size = UDim2.new(0,18,0,18)
BoltIcon.LayoutOrder = 3

local FpsLbl = MkLabel("0 FPS", GothamMed, 12, SUBTEXT, InfoPill)
FpsLbl.Size = UDim2.new(0,48,0,44)
FpsLbl.LayoutOrder = 4
FpsLbl.TextXAlignment = Enum.TextXAlignment.Left
UI.FpsLbl = FpsLbl

local function MkPageContent(name)
	if name == "Settings" or name == "Music" or name == "Home" then
		local frame = Instance.new("ScrollingFrame")
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Size = UDim2.new(1,0,1,0)
		frame.ScrollBarThickness = 4
		frame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
		frame.ScrollingDirection = Enum.ScrollingDirection.Y
		frame.CanvasSize = UDim2.new(0,0,0,0)
		frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		frame.Visible = false
		frame.Name = name.."Content"
		frame.Parent = ContentArea
		PageContents[name] = frame
		return frame
	end
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = BG
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1,0,1,0)
	frame.Visible = false
	frame.Name = name.."Content"
	frame.Parent = ContentArea
	PageContents[name] = frame
	return frame
end

local function MkTabBtn(page, icon, order)
	local btn = MkFrame(page=="Home" and ACCENT or BG3, UDim2.new(0,36,0,36), TopbarPill)
	btn.BackgroundTransparency = 0
	btn.Name = page.."TabBtn"
	btn.LayoutOrder = order
	MkCorner(18, btn)
	local imgBtn = MkBtn("", GothamMed, 12, WHITE, Color3.fromRGB(0,0,0), btn)
	imgBtn.BackgroundTransparency = 1
	imgBtn.Size = UDim2.new(1,0,1,0)
	local img = MkImg(icon or "", page=="Home" and WHITE or SUBTEXT, btn)
	img.AnchorPoint = Vector2.new(0.5,0.5)
	img.Position = UDim2.new(0.5,0,0.5,0)
	img.Size = UDim2.new(0.65,0,0.65,0)
	img.Name = "Icon"
	PageBtns[page] = {frame=btn, imgBtn=imgBtn, icon=img}
	imgBtn.MouseButton1Click:Connect(function()
		Funcs.SwitchPage(page)
	end)
	return btn
end

function Funcs.SwitchPage(name)
	if ActivePage == name then return end
	local old = PageContents[ActivePage]
	local new = PageContents[name]
	if not new then return end
	if PageBtns[ActivePage] then
		TweenService:Create(PageBtns[ActivePage].frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = BG3}):Play()
		TweenService:Create(PageBtns[ActivePage].icon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = SUBTEXT}):Play()
	end
	if PageBtns[name] then
		TweenService:Create(PageBtns[name].frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = ACCENT}):Play()
		TweenService:Create(PageBtns[name].icon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = WHITE}):Play()
	end
	if old then old.Visible = false end
	ActivePage = name
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

function Funcs.OpenUI()
	Overlay.BackgroundTransparency = 1
	Overlay.Visible = true
	Main.Position = UDim2.new(0.5, 0, 0.42, 0)
	Main.Visible = true
	ShowBtn.Visible = false

	if Settings.Animations then
		TweenService:Create(Overlay, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency=0.55}):Play()
		TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position=UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	else
		Overlay.BackgroundTransparency = 0.55
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
end

function Funcs.CloseUI()
	Funcs.ClearCache()
	if Settings.Animations then
		TweenService:Create(Overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency=1}):Play()
		TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position=UDim2.new(0.5, 0, 0.42, 0)
		}):Play()
		task.delay(0.22, function()
			Main.Visible = false
			Overlay.Visible = false
			ShowBtn.Visible = true
			ShowBtn.BackgroundTransparency = 0.05
		end)
	else
		Main.Visible = false
		Overlay.Visible = false
		ShowBtn.Visible = true
		ShowBtn.BackgroundTransparency = 0.05
	end
end

function Funcs.Dragify(obj)
    local XPadding = 16
    local YPadding = 12
    local dragging, dragStart, startPos = false, nil, nil

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local vp = workspace.CurrentCamera.ViewportSize
            local sz = obj.AbsoluteSize

            local nx = math.clamp(startPos.X.Offset + delta.X, XPadding, vp.X - sz.X - XPadding)
            local ny = math.clamp(startPos.Y.Offset + delta.Y, YPadding, vp.Y - sz.Y - YPadding)

            obj.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
        end
    end)
end

for i, page in ipairs(PAGES) do
	MkTabBtn(page, PAGE_ICONS[page], i)
	MkPageContent(page)
end

local HomeContent = PageContents["Home"]
local ExeContent = PageContents["Executor"]
local ConsoleContent = PageContents["Console"]
local SearchContent = PageContents["Search"]
local ScriptsContent = PageContents["Scripts"]
local MusicContent = PageContents["Music"]
local SettingsContent = PageContents["Settings"]

do
	MkPad(14, 14, 12, 12, HomeContent)
	local hl = MkList(Enum.FillDirection.Vertical, 10, HomeContent)
	hl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local topRow = MkFrame(BG2, UDim2.new(1,0,0,100), HomeContent)
	topRow.LayoutOrder = 1
	MkCorner(10, topRow)
	MkStroke(Color3.fromRGB(40,40,50),1,topRow)
	local rowL = MkList(Enum.FillDirection.Horizontal, 12, topRow)
	rowL.HorizontalFlex = Enum.UIFlexAlignment.Fill
	rowL.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(12,12,12,12,topRow)

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundColor3 = BG3
	avatar.BorderSizePixel = 0
	avatar.Size = UDim2.new(0,76,0,76)
	avatar.LayoutOrder = 1
	avatar.Name = "Avatar"
	avatar.Parent = topRow
	MkCorner(8, avatar)
	MkStroke(ACCENT, 1.5, avatar)
	Instance.new("UIAspectRatioConstraint").Parent = avatar
	UI.Avatar = avatar

	local infoCol = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), topRow)
	infoCol.BackgroundTransparency = 1
	infoCol.LayoutOrder = 2
	local ic = MkList(Enum.FillDirection.Vertical, 4, infoCol)
	ic.VerticalFlex = Enum.UIFlexAlignment.Fill

	local welcomeL = MkLabel("Welcome!", GothamBold, 18, WHITE, infoCol)
	welcomeL.TextXAlignment = Enum.TextXAlignment.Left
	welcomeL.Size = UDim2.new(1,0,0,24)
	welcomeL.LayoutOrder = 1
	UI.WelcomeLabel = welcomeL

	local statsL = MkLabel("Loading...", GothamMed, 12, SUBTEXT, infoCol)
	statsL.TextXAlignment = Enum.TextXAlignment.Left
	statsL.Size = UDim2.new(1,0,1,0)
	statsL.LayoutOrder = 2
	statsL.TextYAlignment = Enum.TextYAlignment.Top
	UI.StatsLabel = statsL

	local infoBox = MkFrame(BG2, UDim2.new(1,0,0,0), HomeContent)
	infoBox.LayoutOrder = 2
	infoBox.AutomaticSize = Enum.AutomaticSize.Y
	MkCorner(10, infoBox)
	MkStroke(Color3.fromRGB(40,40,50),1,infoBox)
	MkPad(14,14,12,12,infoBox)

	local aboutL = Instance.new("TextLabel")
	aboutL.BackgroundTransparency = 1
	aboutL.BorderSizePixel = 0
	aboutL.FontFace = GothamMed
	aboutL.TextSize = 13
	aboutL.TextColor3 = SUBTEXT
	aboutL.Text = [[<b>Lucid</b>

<i>A better UI for your executor.</i>

Lucid is a custom executor UI designed to replace the default interface of your executor with a cleaner, more feature-rich experience.

Some executors offer powerful execution capabilities but have a UI that feels outdated, cluttered, or simply isn't enjoyable to use. <b>Lucid</b> was created to solve that.

<b>Version</b>

<font color="#9B7CFF">Modern [V2]</font>

<i>The modern Lucid experience.</i>

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

• <b>Animations</b> — Toggle UI animations.
• <b>Theme Customization</b> — Create your own theme using RGB values.
• <b>Preset Themes</b> — Quickly switch between built-in themes.

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
			UI.StatsLabel.Text = string.format("FPS: %d  •  Ping: %d ms  •  Mem: %d MB\nPlayers: %d/%d  •  PlaceId: %d", fps, ping, mem, pc, mx, game.PlaceId)
			UI.FpsLbl.Text = fps.." FPS"
			UI.PingLbl.Text = ping.." ms"
		end)
	end
end

local ExeTabs2 = {}
local ExeActiveTab2 = nil

do
	MkPad(10,10,10,10,ExeContent)
	local el = MkList(Enum.FillDirection.Vertical, 6, ExeContent)
	el.HorizontalFlex = Enum.UIFlexAlignment.Fill
	el.VerticalFlex = Enum.UIFlexAlignment.Fill

	local tabBar = MkFrame(BG2, UDim2.new(1,0,0,42), ExeContent)
	tabBar.LayoutOrder = 1
	tabBar.Name = "TabBar"
	MkCorner(8, tabBar)
	local tbScroll = Instance.new("ScrollingFrame")
	tbScroll.BackgroundTransparency = 1
	tbScroll.BorderSizePixel = 0
	tbScroll.ScrollBarThickness = 2
	tbScroll.ScrollBarImageColor3 = Color3.fromRGB(60,60,70)
	tbScroll.ScrollingDirection = Enum.ScrollingDirection.X
	tbScroll.CanvasSize = UDim2.new(0,0,0,0)
	tbScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	tbScroll.Size = UDim2.new(1,0,1,0)
	tbScroll.Parent = tabBar
	local tbScrollL = MkList(Enum.FillDirection.Horizontal, 4, tbScroll)
	tbScrollL.VerticalAlignment = Enum.VerticalAlignment.Center
	MkPad(6,0,4,4,tbScroll)
	UI.ExeTabBarScroll = tbScroll

	local addTabBtn = MkBtn("", GothamBold, 20, WHITE, ACCENT, tabBar)
	addTabBtn.AnchorPoint = Vector2.new(1,0.5)
	addTabBtn.Position = UDim2.new(1,-5,0.5,0)
	addTabBtn.Size = UDim2.new(0,32,0,32)
	addTabBtn.Name = "AddTab"
	MkCorner(8, addTabBtn)
	local atRatio = Instance.new("UIAspectRatioConstraint")
	atRatio.AspectType = Enum.AspectType.FitWithinMaxSize
	atRatio.DominantAxis = Enum.DominantAxis.Height
	atRatio.AspectRatio = 1
	atRatio.Parent = addTabBtn
	local addTabIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png") or "", WHITE, addTabBtn)
	addTabIco.AnchorPoint = Vector2.new(0.5,0.5)
	addTabIco.Position = UDim2.new(0.5,0,0.5,0)
	addTabIco.Size = UDim2.new(0.6,0,0.6,0)
	addTabIco.Active = false
	task.defer(function()
		local asset = Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png")
		if asset then addTabIco.Image = asset end
	end)
	UI.AddExeTabBtn = addTabBtn

	local editorArea = MkFrame(BG2, UDim2.new(1,0,1,0), ExeContent)
	editorArea.LayoutOrder = 2
	editorArea.Name = "EditorArea"
	MkCorner(8, editorArea)
	MkStroke(Color3.fromRGB(40,40,50),1,editorArea)
	UI.ExeEditorArea = editorArea

	local bottomBar = MkFrame(BG2, UDim2.new(1,0,0,50), ExeContent)
	bottomBar.LayoutOrder = 3
	bottomBar.Name = "BottomBar"
	MkCorner(8, bottomBar)
	local bbL = MkList(Enum.FillDirection.Horizontal, 8, bottomBar)
	bbL.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(10,10,8,8,bottomBar)
	UI.ExeBottomBar = bottomBar

	local function MkBottomBtn(labelText, iconPath, order)
		local btn = MkBtn("", GothamMed, 14, TEXT, BG3, bottomBar)
		btn.AutomaticSize = Enum.AutomaticSize.X
		btn.Size = UDim2.new(0,0,1,0)
		btn.LayoutOrder = order
		btn.ClipsDescendants = true
		MkCorner(8, btn)
		local layout = MkList(Enum.FillDirection.Horizontal, 6, btn)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		MkPad(8,8,0,0,btn)

		local iconImg = Instance.new("ImageLabel")
		iconImg.BackgroundTransparency = 1
		iconImg.BorderSizePixel = 0
		iconImg.Size = UDim2.new(0,16,0,16)
		iconImg.ImageColor3 = TEXT
		iconImg.LayoutOrder = 1
		iconImg.Active = false
		iconImg.Parent = btn
		task.defer(function()
			local asset = Funcs.GetAsset(iconPath)
			if asset then iconImg.Image = asset end
		end)

		local lbl = MkLabel(labelText, GothamMed, 14, TEXT, btn)
		lbl.Size = UDim2.new(0,0,1,0)
		lbl.AutomaticSize = Enum.AutomaticSize.X
		lbl.TextWrapped = false
		lbl.LayoutOrder = 2
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.TextTruncate = Enum.TextTruncate.None
		lbl.Active = false

		return btn
	end

	local ExeClick = MkBottomBtn("Execute", "Lucid/Assets/Lucid_Execute.png", 1)
	UI.ExeBtn = ExeClick
	local ClrClick = MkBottomBtn("Clear", "Lucid/Assets/Lucid_Clear.png", 2)
	UI.ClrBtn = ClrClick
	local CopyClick = MkBottomBtn("Copy", "Lucid/Assets/Lucid_Clipboard.png", 3)
	UI.CopyBtn = CopyClick

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
			if ExeActiveTab2.tabBtn then
				TweenService:Create(ExeActiveTab2.tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(35,35,42)}):Play()
				local lbl = ExeActiveTab2.tabBtn:FindFirstChild("NameBtn")
				if lbl then
					TweenService:Create(lbl, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = SUBTEXT}):Play()
				end
			end
		end
		ExeActiveTab2 = tabData
		tabData.inputFrame.Visible = true
		if tabData.tabBtn then
			TweenService:Create(tabData.tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = ACCENT}):Play()
			local lbl = tabData.tabBtn:FindFirstChild("NameBtn")
			if lbl then
				TweenService:Create(lbl, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = WHITE}):Play()
			end
		end
	end
	UI.SwitchExeTab = SwitchExeTab

	local function CreateExeTab(name)
		local tabData = {}
		tabData.name = name or GetNextTabName()
		tabData.code = ""

		local tabBtn = MkFrame(Color3.fromRGB(35,35,42), UDim2.new(0,0,1,0), tbScroll)
		tabBtn.AutomaticSize = Enum.AutomaticSize.X
		tabBtn.Name = "ExeTab_"..tabData.name
		MkCorner(7, tabBtn)
		local tbl = MkList(Enum.FillDirection.Horizontal, 4, tabBtn)
		tbl.VerticalAlignment = Enum.VerticalAlignment.Center
		MkPad(10,8,0,0,tabBtn)

		local nameBtn = MkBtn(tabData.name, GothamMed, 13, SUBTEXT, Color3.fromRGB(0,0,0), tabBtn)
		nameBtn.BackgroundTransparency = 1
		nameBtn.AutomaticSize = Enum.AutomaticSize.X
		nameBtn.Size = UDim2.new(0,0,1,0)
		nameBtn.TextTruncate = Enum.TextTruncate.None
		nameBtn.TextXAlignment = Enum.TextXAlignment.Left
		nameBtn.Name = "NameBtn"
		nameBtn.LayoutOrder = 1

		local nameBox = Instance.new("TextBox")
		nameBox.BackgroundTransparency = 1
		nameBox.BorderSizePixel = 0
		nameBox.FontFace = GothamMed
		nameBox.TextSize = 13
		nameBox.TextColor3 = WHITE
		nameBox.Text = tabData.name
		nameBox.AutomaticSize = Enum.AutomaticSize.X
		nameBox.Size = UDim2.new(0,0,1,0)
		nameBox.TextXAlignment = Enum.TextXAlignment.Left
		nameBox.ClearTextOnFocus = false
		nameBox.Visible = false
		nameBox.Name = "NameBox"
		nameBox.LayoutOrder = 1
		nameBox.Parent = tabBtn

		local closeX = MkBtn("", GothamBold, 12, WHITE, Color3.fromRGB(0,0,0), tabBtn)
		closeX.BackgroundTransparency = 1
		closeX.Size = UDim2.new(0,18,0,18)
		closeX.LayoutOrder = 2
		local closeIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Close.png") or "", WHITE, closeX)
		closeIco.AnchorPoint = Vector2.new(0.5,0.5)
		closeIco.Position = UDim2.new(0.5,0,0.5,0)
		closeIco.Size = UDim2.new(0.7,0,0.7,0)
		closeIco.Active = false
		task.defer(function()
			local asset = Funcs.GetAsset("Lucid/Assets/Lucid_Close.png")
			if asset then closeIco.Image = asset end
		end)

		local inputFrame = Instance.new("ScrollingFrame")
		inputFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		inputFrame.BackgroundTransparency = 1
		inputFrame.BorderSizePixel = 0
		inputFrame.CanvasSize = UDim2.new(0,0,0,0)
		inputFrame.ScrollBarThickness = 5
		inputFrame.ScrollBarImageColor3 = Color3.fromRGB(55,55,65)
		inputFrame.Size = UDim2.new(1,0,1,0)
		inputFrame.Visible = false
		inputFrame.Parent = editorArea
		MkPad(8,8,8,8,inputFrame)

		local highlight = Instance.new("TextLabel")
		highlight.AutomaticSize = Enum.AutomaticSize.Y
		highlight.BackgroundTransparency = 1
		highlight.FontFace = Inconsolata
		highlight.RichText = true
		highlight.Size = UDim2.new(1,0,0,0)
		highlight.Text = ""
		highlight.TextColor3 = WHITE
		highlight.TextSize = 17
		highlight.TextWrapped = true
		highlight.TextXAlignment = Enum.TextXAlignment.Left
		highlight.TextYAlignment = Enum.TextYAlignment.Top
		highlight.Active = false
		highlight.Selectable = false
		highlight.Parent = inputFrame

		local inputBox = Instance.new("TextBox")
		inputBox.AutomaticSize = Enum.AutomaticSize.Y
		inputBox.BackgroundTransparency = 1
		inputBox.BorderSizePixel = 0
		inputBox.ClearTextOnFocus = false
		inputBox.FontFace = Inconsolata
		inputBox.MultiLine = true
		inputBox.PlaceholderColor3 = Color3.fromRGB(80,80,90)
		inputBox.PlaceholderText = "-- Enter code here..."
		inputBox.Size = UDim2.new(1,0,0,0)
		inputBox.Text = ""
		inputBox.TextColor3 = Color3.fromRGB(0,0,0)
		inputBox.TextTransparency = 1
		inputBox.TextSize = 17
		inputBox.TextWrapped = true
		inputBox.TextXAlignment = Enum.TextXAlignment.Left
		inputBox.TextYAlignment = Enum.TextYAlignment.Top
		inputBox.Parent = inputFrame
		local ib_sc = Instance.new("UISizeConstraint")
		ib_sc.MinSize = Vector2.new(0,160)
		ib_sc.Parent = inputBox

		inputBox:GetPropertyChangedSignal("Text"):Connect(function()
			tabData.code = inputBox.Text
			highlight.Text = Funcs.Highlight(inputBox.Text)
		end)

		tabData.tabBtn = tabBtn
		tabData.inputFrame = inputFrame
		tabData.inputBox = inputBox
		tabData.highlight = highlight

		nameBtn.MouseButton1Click:Connect(function()
			SwitchExeTab(tabData)
		end)
		nameBtn.MouseButton2Click:Connect(function()
			nameBtn.Visible = false
			nameBox.Visible = true
			nameBox:CaptureFocus()
		end)
		nameBox.FocusLost:Connect(function()
			local n = nameBox.Text
			if n and n~="" then
				tabData.name = n
				nameBtn.Text = n
			end
			nameBox.Visible = false
			nameBtn.Visible = true
		end)
		closeX.MouseButton1Click:Connect(function()
			if #ExeTabs2<=1 then return end
			local idx = table.find(ExeTabs2, tabData)
			if idx then table.remove(ExeTabs2, idx) end
			tabBtn:Destroy()
			inputFrame:Destroy()
			if ExeActiveTab2==tabData then
				local ni = math.min(idx or 1, #ExeTabs2)
				if ExeTabs2[ni] then
					ExeActiveTab2 = nil
					SwitchExeTab(ExeTabs2[ni])
				end
			end
		end)

		table.insert(ExeTabs2, tabData)
		SwitchExeTab(tabData)
		return tabData
	end
	Funcs.CreateExeTab = CreateExeTab

	addTabBtn.MouseButton1Click:Connect(function()
		CreateExeTab()
	end)

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

do
	MkPad(10,10,10,10,ConsoleContent)
	local cl = MkList(Enum.FillDirection.Vertical, 6, ConsoleContent)
	cl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	cl.VerticalFlex = Enum.UIFlexAlignment.Fill

	local consoleTopBar = MkFrame(BG2, UDim2.new(1,0,0,36), ConsoleContent)
	consoleTopBar.LayoutOrder = 1
	MkCorner(8, consoleTopBar)
	MkStroke(Color3.fromRGB(40,40,50),1,consoleTopBar)
	local ctbl = MkList(Enum.FillDirection.Horizontal, 8, consoleTopBar)
	ctbl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	ctbl.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(10,10,0,0,consoleTopBar)

	local consoleTitleIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Console.png") or "", SUBTEXT, consoleTopBar)
	consoleTitleIco.Size = UDim2.new(0,18,0,18)
	consoleTitleIco.LayoutOrder = 1
	Instance.new("UIAspectRatioConstraint").Parent = consoleTitleIco

	local consoleTitleL = MkLabel("Console", GothamBold, 14, TEXT, consoleTopBar)
	consoleTitleL.Size = UDim2.new(1,0,1,0)
	consoleTitleL.TextXAlignment = Enum.TextXAlignment.Left
	consoleTitleL.LayoutOrder = 2

	local consoleClearBtn = MkBtn("Clear", GothamMed, 12, TEXT, BG3, consoleTopBar)
	consoleClearBtn.LayoutOrder = 3
	consoleClearBtn.Size = UDim2.new(0,52,0,26)
	MkCorner(6, consoleClearBtn)

	local consoleScroll = Instance.new("ScrollingFrame")
	consoleScroll.BackgroundColor3 = BG2
	consoleScroll.BorderSizePixel = 0
	consoleScroll.ScrollBarThickness = 4
	consoleScroll.ScrollBarImageColor3 = Color3.fromRGB(60,60,70)
	consoleScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	consoleScroll.CanvasSize = UDim2.new(0,0,0,0)
	consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	consoleScroll.Size = UDim2.new(1,0,1,0)
	consoleScroll.LayoutOrder = 2
	consoleScroll.Parent = ConsoleContent
	MkCorner(8, consoleScroll)
	MkStroke(Color3.fromRGB(40,40,50),1,consoleScroll)
	MkPad(8,8,6,6,consoleScroll)
	local consoleList = MkList(Enum.FillDirection.Vertical, 2, consoleScroll)
	consoleList.HorizontalFlex = Enum.UIFlexAlignment.Fill
	UI.ConsoleScroll = consoleScroll
	UI.ConsoleList = consoleList

	local ConsoleEntries = {}

	local function AddConsoleEntry(kind, msg)
		local col = kind=="warn" and Color3.fromRGB(255,200,60)
			or kind=="error" and Color3.fromRGB(255,80,80)
			or Color3.fromRGB(200,200,200)
		local prefix = kind=="warn" and "[WARN] " or kind=="error" and "[ERROR] " or "[INFO] "
		local entry = Instance.new("TextLabel")
		entry.BackgroundTransparency = 1
		entry.BorderSizePixel = 0
		entry.FontFace = Inconsolata
		entry.TextSize = 13
		entry.TextColor3 = col
		entry.Text = prefix..tostring(msg)
		entry.Size = UDim2.new(1,0,0,0)
		entry.AutomaticSize = Enum.AutomaticSize.Y
		entry.TextWrapped = true
		entry.TextXAlignment = Enum.TextXAlignment.Left
		entry.TextYAlignment = Enum.TextYAlignment.Top
		entry.RichText = false
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
		pcall(function()
			if ConsoleContent and ConsoleContent.Parent then
				AddConsoleEntry("print", msg)
			end
		end)
	end

	warn = function(...)
		local args = {...}
		local parts = {}
		for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
		local msg = table.concat(parts, "\t")
		_warn(...)
		pcall(function()
			if ConsoleContent and ConsoleContent.Parent then
				AddConsoleEntry("warn", msg)
			end
		end)
	end

	consoleClearBtn.MouseButton1Click:Connect(function()
		for _, e in ipairs(ConsoleEntries) do if e and e.Parent then e:Destroy() end end
		ConsoleEntries = {}
	end)

	AddConsoleEntry("print", "Console ready. print/warn output will appear here.")
end

local SearchPrevBtn, SearchNextBtn
do
	MkPad(0,0,10,10,SearchContent)
	local sl = MkList(Enum.FillDirection.Vertical, 8, SearchContent)
	sl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	sl.VerticalFlex = Enum.UIFlexAlignment.Fill

	local searchBar = MkFrame(BG2, UDim2.new(1,0,0,46), SearchContent)
	searchBar.LayoutOrder = 1
	MkCorner(10, searchBar)
	MkStroke(Color3.fromRGB(40,40,50),1,searchBar)
	local sbl = MkList(Enum.FillDirection.Horizontal, 6, searchBar)
	sbl.VerticalAlignment = Enum.VerticalAlignment.Center
	MkPad(8,6,0,0,searchBar)

	local srcBtn = MkBtn("● RScripts", GothamMed, 13, Color3.fromRGB(80,220,120), BG3, searchBar)
	srcBtn.LayoutOrder = 1
	srcBtn.Size = UDim2.new(0,110,0,32)
	MkCorner(8, srcBtn)
	UI.SourceBtn = srcBtn

	local sbox = Instance.new("TextBox")
	sbox.BackgroundTransparency = 1
	sbox.BorderSizePixel = 0
	sbox.FontFace = GothamMed
	sbox.TextSize = 13
	sbox.PlaceholderColor3 = SUBTEXT
	sbox.PlaceholderText = "Search scripts..."
	sbox.TextColor3 = TEXT
	sbox.Text = ""
	sbox.TextXAlignment = Enum.TextXAlignment.Left
	sbox.Size = UDim2.new(1,-195,0,32)
	sbox.LayoutOrder = 2
	sbox.ClearTextOnFocus = false
	sbox.Parent = searchBar
	UI.SearchBox = sbox

	local filterBtn = MkBtn("", GothamMed, 12, SUBTEXT, BG3, searchBar)
	filterBtn.Size = UDim2.new(0,75,0,32)
	filterBtn.LayoutOrder = 3
	filterBtn.ClipsDescendants = true
	MkCorner(8, filterBtn)
	local filterLayout = MkList(Enum.FillDirection.Horizontal, 6, filterBtn)
	filterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	filterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	MkPad(8,8,0,0,filterBtn)

	local filterIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Filter.png") or "", SUBTEXT, filterBtn)
	filterIco.Size = UDim2.new(0,14,0,14)
	filterIco.LayoutOrder = 1
	filterIco.Active = false
	Instance.new("UIAspectRatioConstraint").Parent = filterIco
	task.defer(function()
		local asset = Funcs.GetAsset("Lucid/Assets/Lucid_Filter.png")
		if asset then filterIco.Image = asset end
	end)

	local filterLbl = MkLabel("All", GothamMed, 13, SUBTEXT, filterBtn)
	filterLbl.Size = UDim2.new(0,0,1,0)
	filterLbl.AutomaticSize = Enum.AutomaticSize.X
	filterLbl.TextWrapped = false
	filterLbl.LayoutOrder = 2
	filterLbl.Active = false

	UI.FilterBtn = filterBtn
	UI.FilterLabel = filterLbl

	local resultsScroll = MkScroll(Enum.ScrollingDirection.Y, SearchContent)
	resultsScroll.LayoutOrder = 2
	resultsScroll.Size = UDim2.new(1,0,1,0)
	local rsl = MkList(Enum.FillDirection.Vertical, 8, resultsScroll)
	rsl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkPad(2,2,2,2,resultsScroll)
	UI.SearchResults = resultsScroll
	UI.SearchResultsLayout = rsl

	local noResultsL = MkLabel("No scripts found.", GothamMed, 14, SUBTEXT, resultsScroll)
	noResultsL.Size = UDim2.new(1,0,0,40)
	noResultsL.Visible = false
	UI.NoResultsLabel = noResultsL

	local pageRow = MkFrame(BG2, UDim2.new(1,0,0,44), SearchContent)
	pageRow.LayoutOrder = 3
	MkCorner(8, pageRow)
	local prl = MkList(Enum.FillDirection.Horizontal, 8, pageRow)
	prl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	prl.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(10,10,0,0,pageRow)

	local prevBtn = MkBtn("← Prev", GothamMed, 13, TEXT, BG3, pageRow)
	prevBtn.LayoutOrder = 1
	prevBtn.Size = UDim2.new(0,70,0,32)
	prevBtn.Visible = false
	MkCorner(8, prevBtn)
	SearchPrevBtn = prevBtn
	UI.PrevBtn = prevBtn

	local pfill = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), pageRow)
	pfill.BackgroundTransparency = 1
	pfill.LayoutOrder = 2

	local nextBtn = MkBtn("Next →", GothamMed, 13, TEXT, BG3, pageRow)
	nextBtn.LayoutOrder = 3
	nextBtn.Size = UDim2.new(0,70,0,32)
	nextBtn.Visible = false
	MkCorner(8, nextBtn)
	SearchNextBtn = nextBtn
	UI.NextBtn = nextBtn

	local SRTemplate = Instance.new("Frame")
	SRTemplate.BackgroundColor3 = BG2
	SRTemplate.BorderSizePixel = 0
	SRTemplate.Size = UDim2.new(1,0,0,88)
	SRTemplate.Visible = false
	SRTemplate.Name = "SRTemplate"
	SRTemplate.Parent = resultsScroll
	MkCorner(10, SRTemplate)
	MkStroke(Color3.fromRGB(40,40,50),1,SRTemplate)
	UI.SRTemplate = SRTemplate

	local srtl = MkList(Enum.FillDirection.Horizontal, 0, SRTemplate)
	srtl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	srtl.VerticalFlex = Enum.UIFlexAlignment.Fill

	local srtImg = Instance.new("ImageLabel")
	srtImg.BackgroundColor3 = BG3
	srtImg.BorderSizePixel = 0
	srtImg.LayoutOrder = 1
	srtImg.Name = "SRImg"
	srtImg.Size = UDim2.new(0,88,1,0)
	srtImg.ScaleType = Enum.ScaleType.Crop
	srtImg.Parent = SRTemplate
	MkCorner(10, srtImg)

	local srtInfo = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), SRTemplate)
	srtInfo.BackgroundTransparency = 1
	srtInfo.LayoutOrder = 2
	srtInfo.Name = "SRInfo"
	local srtInfoL = MkList(Enum.FillDirection.Vertical, 4, srtInfo)
	srtInfoL.HorizontalFlex = Enum.UIFlexAlignment.Fill
	srtInfoL.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(10,8,6,6,srtInfo)

	local srtName = MkLabel("Script Name", GothamBold, 14, WHITE, srtInfo)
	srtName.Size = UDim2.new(1,0,0,18)
	srtName.TextXAlignment = Enum.TextXAlignment.Left
	srtName.LayoutOrder = 1
	srtName.Name = "SRName"
	srtName.TextTruncate = Enum.TextTruncate.AtEnd

	local srtKey = MkLabel("Keyless", GothamMed, 12, Color3.fromRGB(80,200,120), srtInfo)
	srtKey.Size = UDim2.new(1,0,0,14)
	srtKey.TextXAlignment = Enum.TextXAlignment.Left
	srtKey.LayoutOrder = 2
	srtKey.Name = "SRKey"

	local srtActions = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,26), srtInfo)
	srtActions.BackgroundTransparency = 1
	srtActions.LayoutOrder = 3
	srtActions.Name = "SRActions"
	local srtActL = MkList(Enum.FillDirection.Horizontal, 6, srtActions)

	local function MkSRBtn(text, iconPath, order, parent)
		local b = MkBtn("", GothamMed, 12, TEXT, BG3, parent)
		b.LayoutOrder = order
		b.Size = UDim2.new(0.31,0,1,0)
		b.ClipsDescendants = true
		MkCorner(6, b)
		MkPad(4,4,4,4,b)
		local bl = MkList(Enum.FillDirection.Horizontal, 4, b)
		bl.VerticalAlignment = Enum.VerticalAlignment.Center
		bl.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local img = MkImg("", TEXT, b)
		img.Size = UDim2.new(0,14,0,14)
		img.LayoutOrder = 1
		img.Active = false
		Instance.new("UIAspectRatioConstraint").Parent = img
		task.defer(function()
			local asset = Funcs.GetAsset(iconPath)
			if asset then img.Image = asset end
		end)

		local lbl = MkLabel(text, GothamMed, 11, TEXT, b)
		lbl.Size = UDim2.new(1,-18,1,0)
		lbl.LayoutOrder = 2
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		lbl.Active = false

		return b, lbl
	end
	local srtRun, srtRunLbl = MkSRBtn("Run", "Lucid/Assets/Lucid_Execute.png", 1, srtActions) srtRun.Name = "SRRun"
	local srtCopy, srtCopyLbl = MkSRBtn("Copy", "Lucid/Assets/Lucid_Clipboard.png", 2, srtActions) srtCopy.Name = "SRCopy"
	local srtSave, srtSaveLbl = MkSRBtn("Save", "Lucid/Assets/Lucid_Star.png", 3, srtActions) srtSave.Name = "SRSave"

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
					local safeName = "Lucid/Cache/"..HttpService:GenerateGUID(false):gsub("-","")..".png"
					if not IsFolder("Lucid/Cache") then MakeFolder("Lucid/Cache") end
					local ok, res = pcall(function()
						local f = (syn and syn.request) or request or http_request
						return f and f({Url=rawUrl, Method="GET"})
					end)
					if ok and res and res.Body and #res.Body > 0 then
						pcall(function() WriteFile(safeName, res.Body) end)
						local asset = pcall(LoadAsset, safeName) and LoadAsset(safeName)
						if asset and img and img.Parent then
							img.Image = asset
		end
	end
	Funcs.RefreshMusicList()
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
						if lbl then
							lbl.Text="✓ Copied"
							task.delay(1.5,function() lbl.Text="Copy" end)
						end
					end
				end) end
				if saveB then saveB.MouseButton1Click:Connect(function()
					local code = ResolveCode()
					if code then
						Funcs.SaveScript({Name=title, Description=data.description or "", Code=code})
						local lbl = saveB:FindFirstChildOfClass("TextLabel")
						if lbl then
							lbl.Text="✓ Saved"
							task.delay(1.5,function() lbl.Text="Save" end)
						end
					end
				end) end
			end
		end
	end

	function Funcs.RenderSearchResults()
		for _, child in ipairs(resultsScroll:GetChildren()) do
			if child~=UI.NoResultsLabel and child~=SRTemplate and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
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
		if shown==0 then
			UI.NoResultsLabel.Text = #CurrentScripts==0 and "No scripts found." or "No scripts match the current filter."
		end
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
		prevBtn.Visible=false nextBtn.Visible=false
		local q = sbox.Text
		if q~="" then Funcs.PerformSearch(q,1)
		elseif SrcIdx==2 then Funcs.PerformSearch("",1)
		else CurrentScripts={} Funcs.RenderSearchResults() UI.NoResultsLabel.Visible=false end
	end)
	prevBtn.MouseButton1Click:Connect(function()
		if currentPage>1 then Funcs.PerformSearch(currentQuery, currentPage-1) end
	end)
	nextBtn.MouseButton1Click:Connect(function()
		if currentPage<totalPages then Funcs.PerformSearch(currentQuery, currentPage+1) end
	end)
	srcBtn.MouseButton1Click:Connect(function()
		SrcIdx = SrcIdx%#Srcs+1
		if SrcIdx==1 then srcBtn.Text="● RScripts" srcBtn.TextColor3=Color3.fromRGB(80,220,120)
		else srcBtn.Text="● ScriptBlox" srcBtn.TextColor3=Color3.fromRGB(230,160,60) end
		Funcs.PerformSearch(sbox.Text,1)
	end)
	filterBtn.MouseButton1Click:Connect(function()
		FilterIdx = FilterIdx%#Filters+1
		UI.FilterLabel.Text = Filters[FilterIdx]
		Funcs.RenderSearchResults()
	end)
end

do
	MkPad(0,0,10,10,ScriptsContent)
	local sl = MkList(Enum.FillDirection.Vertical, 8, ScriptsContent)
	sl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local searchBar = MkFrame(BG2, UDim2.new(1,0,0,46), ScriptsContent)
	searchBar.LayoutOrder = 1
	MkCorner(10, searchBar)
	MkStroke(Color3.fromRGB(40,40,50),1,searchBar)
	local sbl = MkList(Enum.FillDirection.Horizontal, 6, searchBar)
	sbl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	sbl.VerticalFlex = Enum.UIFlexAlignment.Fill
	MkPad(8,6,0,0,searchBar)

	local sbox2 = Instance.new("TextBox")
	sbox2.BackgroundTransparency = 1
	sbox2.BorderSizePixel = 0
	sbox2.FontFace = GothamMed
	sbox2.TextSize = 13
	sbox2.PlaceholderColor3 = SUBTEXT
	sbox2.PlaceholderText = "Search saved scripts..."
	sbox2.TextColor3 = TEXT
	sbox2.Text = ""
	sbox2.TextXAlignment = Enum.TextXAlignment.Left
	sbox2.Size = UDim2.new(1,0,1,0)
	sbox2.LayoutOrder = 1
	sbox2.ClearTextOnFocus = false
	sbox2.Parent = searchBar
	UI.SavedSearchBox = sbox2

	local newScriptBtn = MkBtn("", GothamBold, 20, WHITE, ACCENT, searchBar)
	newScriptBtn.LayoutOrder = 2
	newScriptBtn.Size = UDim2.new(0,32,0,32)
	MkCorner(8, newScriptBtn)
	local nsRatio = Instance.new("UIAspectRatioConstraint")
	nsRatio.AspectType = Enum.AspectType.FitWithinMaxSize
	nsRatio.DominantAxis = Enum.DominantAxis.Height
	nsRatio.AspectRatio = 1
	nsRatio.Parent = newScriptBtn
	local newScriptIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png") or "", WHITE, newScriptBtn)
	newScriptIco.AnchorPoint = Vector2.new(0.5,0.5)
	newScriptIco.Position = UDim2.new(0.5,0,0.5,0)
	newScriptIco.Size = UDim2.new(0.6,0,0.6,0)
	newScriptIco.Active = false
	task.defer(function()
		local asset = Funcs.GetAsset("Lucid/Assets/Lucid_AddFile.png")
		if asset then newScriptIco.Image = asset end
	end)
	UI.NewScriptBtn = newScriptBtn

	local savedScroll = MkScroll(Enum.ScrollingDirection.Y, ScriptsContent)
	savedScroll.LayoutOrder = 2
	savedScroll.Size = UDim2.new(1,0,1,0)
	local ssl = MkList(Enum.FillDirection.Vertical, 6, savedScroll)
	ssl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkPad(2,2,2,10,savedScroll)
	UI.SavedScriptsScroll = savedScroll

	local noSavedL = MkLabel("No saved scripts.\nSave scripts from Search tab.", GothamMed, 13, SUBTEXT, savedScroll)
	noSavedL.Size = UDim2.new(1,0,0,60)
	noSavedL.Visible = false
	UI.NoSavedLabel = noSavedL

	function Funcs.RefreshSavedScripts(query)
		for _, child in ipairs(savedScroll:GetChildren()) do
			if child~=UI.NoSavedLabel and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
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
		local builtIn, normal = {}, {}
		for _, sd in ipairs(scripts) do
			if (sd.Name or ""):find("%(Built%-In%)") then table.insert(builtIn, sd)
			else table.insert(normal, sd) end
		end
		table.sort(builtIn, function(a,b) return (a.Name or ""):lower()<(b.Name or ""):lower() end)
		table.sort(normal, function(a,b) return (a.Name or ""):lower()<(b.Name or ""):lower() end)

		local function MakeCard(sd)
			local card = MkFrame(BG2, UDim2.new(1,0,0,66), savedScroll)
			card.Name = Funcs.SanitizeName(sd.Name)
			MkCorner(10, card)
			MkStroke(Color3.fromRGB(40,40,50),1,card)
			MkPad(12,10,8,8,card)

			local layout = MkList(Enum.FillDirection.Vertical, 4, card)
			layout.HorizontalFlex = Enum.UIFlexAlignment.Fill

			local nameRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,18), card)
			nameRow.BackgroundTransparency = 1
			nameRow.LayoutOrder = 1
			local nameLbl = MkLabel(sd.Name or "Unknown", GothamBold, 14, WHITE, nameRow)
			nameLbl.Size = UDim2.new(1,0,1,0)
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

			local actRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,26), card)
			actRow.BackgroundTransparency = 1
			actRow.LayoutOrder = 2
			local actLayout = MkList(Enum.FillDirection.Horizontal, 6, actRow)

			local function MkCardBtn(label, iconPath, bgCol, textCol)
				local btn = MkBtn("", GothamMed, 13, textCol, bgCol, actRow)
				btn.AutomaticSize = Enum.AutomaticSize.X
				btn.Size = UDim2.new(0,0,1,0)
				btn.ClipsDescendants = true
				MkCorner(7, btn)
				local innerLayout = MkList(Enum.FillDirection.Horizontal, 5, btn)
				innerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				innerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				MkPad(8,8,0,0,btn)

				if iconPath then
					local iconImg = MkImg("", WHITE, btn)
					iconImg.Size = UDim2.new(0,14,0,14)
					iconImg.LayoutOrder = 1
					iconImg.Active = false
					Instance.new("UIAspectRatioConstraint").Parent = iconImg
					task.defer(function()
						local asset = Funcs.GetAsset(iconPath)
						if asset then iconImg.Image = asset end
					end)
				end

				local lbl = MkLabel(label, GothamMed, 13, textCol, btn)
				lbl.Size = UDim2.new(0,0,1,0)
				lbl.AutomaticSize = Enum.AutomaticSize.X
				lbl.TextWrapped = false
				lbl.TextTruncate = Enum.TextTruncate.None
				lbl.TextXAlignment = Enum.TextXAlignment.Center
				lbl.LayoutOrder = 2
				lbl.Active = false

				return btn
			end

			local runClick = MkCardBtn("Execute", "Lucid/Assets/Lucid_Execute.png", BG3, TEXT)
			local delClick = MkCardBtn("Delete", nil, Color3.fromRGB(50,20,20), Color3.fromRGB(220,80,80))

			runClick.MouseButton1Click:Connect(function()
				local code = sd.Code or sd.Script
				if code and code ~= "" then pcall(loadstring(code)) end
			end)
			delClick.MouseButton1Click:Connect(function()
				Funcs.DeleteScript(sd.Name)
				Funcs.RefreshSavedScripts(sbox2.Text)
			end)
		end

		for _, sd in ipairs(builtIn) do MakeCard(sd) end
		for _, sd in ipairs(normal) do MakeCard(sd) end
	end

	sbox2:GetPropertyChangedSignal("Text"):Connect(function()
		Funcs.RefreshSavedScripts(sbox2.Text)
	end)

	local NewScriptPopup = Instance.new("Frame")
	NewScriptPopup.AnchorPoint = Vector2.new(0.5,0.5)
	NewScriptPopup.BackgroundColor3 = BG2
	NewScriptPopup.BorderSizePixel = 0
	NewScriptPopup.Position = UDim2.new(0.5,0,0.5,0)
	NewScriptPopup.Size = UDim2.new(0.9,0,0,220)
	NewScriptPopup.Visible = false
	NewScriptPopup.ZIndex = 10
	NewScriptPopup.Name = "NewScriptPopup"
	NewScriptPopup.Parent = Screen
	MkCorner(12, NewScriptPopup)
	MkStroke(ACCENT, 1.5, NewScriptPopup)
	MkPad(14,14,14,14,NewScriptPopup)
	local nsl = MkList(Enum.FillDirection.Vertical, 8, NewScriptPopup)
	nsl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local function MkInputField(placeholder, order, multiline)
		local box = Instance.new("TextBox")
		if multiline then
			box.MultiLine = true
			box.TextYAlignment = Enum.TextYAlignment.Top
		end
		box.BackgroundColor3 = BG3
		box.BorderSizePixel = 0
		box.FontFace = multiline and Inconsolata or GothamMed
		box.TextSize = 13
		box.PlaceholderColor3 = SUBTEXT
		box.PlaceholderText = placeholder
		box.TextColor3 = TEXT
		box.Text = ""
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Size = UDim2.new(1,0,0,multiline and 80 or 30)
		box.LayoutOrder = order
		box.ClearTextOnFocus = false
		box.Parent = NewScriptPopup
		MkCorner(7, box)
		MkStroke(Color3.fromRGB(45,45,55),1,box)
		MkPad(8,8,4,4,box)
		return box
	end

	local nameBox3 = MkInputField("Script name...", 1, false)
	local descBox3 = MkInputField("Description...", 2, false)
	local codeBox3 = MkInputField("-- Code here...", 3, true)

	local popupBtns = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,32), NewScriptPopup)
	popupBtns.BackgroundTransparency = 1
	popupBtns.LayoutOrder = 4
	local pbL = MkList(Enum.FillDirection.Horizontal, 8, popupBtns)
	pbL.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local pfillr = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,1,0), popupBtns)
	pfillr.BackgroundTransparency = 1
	pfillr.LayoutOrder = 1

	local savePopupBtn = MkBtn("Save", GothamMed, 13, WHITE, ACCENT, popupBtns)
	savePopupBtn.LayoutOrder = 2
	savePopupBtn.Size = UDim2.new(0,70,1,0)
	MkCorner(7, savePopupBtn)

	local cancelPopupBtn = MkBtn("Cancel", GothamMed, 13, TEXT, BG3, popupBtns)
	cancelPopupBtn.LayoutOrder = 3
	cancelPopupBtn.Size = UDim2.new(0,70,1,0)
	MkCorner(7, cancelPopupBtn)

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

do
	MkPad(14, 14, 12, 12, MusicContent)
	local ml = MkList(Enum.FillDirection.Vertical, 10, MusicContent)
	ml.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local controlsHolder = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,290), MusicContent)
	controlsHolder.BackgroundTransparency = 1
	controlsHolder.LayoutOrder = 1
	local chl = MkList(Enum.FillDirection.Vertical, 10, controlsHolder)
	chl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local nowPlayingBox = MkFrame(BG2, UDim2.new(1,0,0,76), controlsHolder)
	nowPlayingBox.LayoutOrder = 1
	MkCorner(10, nowPlayingBox)
	MkStroke(Color3.fromRGB(40,40,50),1,nowPlayingBox)
	MkPad(16,16,12,12,nowPlayingBox)
	local npL = MkList(Enum.FillDirection.Vertical, 4, nowPlayingBox)
	npL.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local npTitle = MkLabel("No song playing", GothamBold, 15, WHITE, nowPlayingBox)
	npTitle.LayoutOrder = 1
	npTitle.TextXAlignment = Enum.TextXAlignment.Center
	npTitle.TextTruncate = Enum.TextTruncate.AtEnd
	npTitle.Size = UDim2.new(1,0,0,22)
	UI.NowPlayingLabel = npTitle

	local npSub = MkLabel("Place audio files in Lucid/Music/", GothamMed, 12, SUBTEXT, nowPlayingBox)
	npSub.LayoutOrder = 2
	npSub.TextXAlignment = Enum.TextXAlignment.Center
	npSub.TextTruncate = Enum.TextTruncate.AtEnd
	npSub.Size = UDim2.new(1,0,0,18)
	UI.NowPlayingSubLabel = npSub

	local sliderOuter = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,22), controlsHolder)
	sliderOuter.BackgroundTransparency = 1
	sliderOuter.LayoutOrder = 2
	sliderOuter.ClipsDescendants = false

	local sliderBar = MkFrame(BG3, UDim2.new(1,-28,0,6), sliderOuter)
	sliderBar.AnchorPoint = Vector2.new(0,0.5)
	sliderBar.Position = UDim2.new(0,14,0.5,0)
	sliderBar.Name = "SliderBar"
	MkCorner(3, sliderBar)
	UI.MusicSliderBar = sliderBar

	local sliderFill = MkFrame(ACCENT, UDim2.new(0,0,1,0), sliderBar)
	sliderFill.Name = "SliderFill"
	MkCorner(3, sliderFill)
	UI.MusicSliderFill = sliderFill

	local sliderKnob = MkFrame(WHITE, UDim2.new(0,14,0,14), sliderBar)
	sliderKnob.AnchorPoint = Vector2.new(0.5,0.5)
	sliderKnob.Position = UDim2.new(0,0,0.5,0)
	sliderKnob.Name = "SliderKnob"
	MkCorner(7, sliderKnob)
	UI.MusicSliderKnob = sliderKnob

	local timeRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,16), controlsHolder)
	timeRow.BackgroundTransparency = 1
	timeRow.LayoutOrder = 3
	local trl = MkList(Enum.FillDirection.Horizontal, 0, timeRow)
	trl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	local timeCurrent = MkLabel("0:00", GothamMed, 11, SUBTEXT, timeRow)
	timeCurrent.Size = UDim2.new(0.5,0,1,0)
	timeCurrent.TextXAlignment = Enum.TextXAlignment.Left
	UI.MusicTimeCurrent = timeCurrent
	local timeDuration = MkLabel("0:00", GothamMed, 11, SUBTEXT, timeRow)
	timeDuration.Size = UDim2.new(0.5,0,1,0)
	timeDuration.TextXAlignment = Enum.TextXAlignment.Right
	UI.MusicTimeDuration = timeDuration

	local controlsRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,52), controlsHolder)
	controlsRow.BackgroundTransparency = 1
	controlsRow.LayoutOrder = 4
	local crl = MkList(Enum.FillDirection.Horizontal, 16, controlsRow)
	crl.HorizontalAlignment = Enum.HorizontalAlignment.Center
	crl.VerticalAlignment = Enum.VerticalAlignment.Center

	local function MkCtrlBtn(iconPath, size)
		local b = MkBtn("", GothamBold, 16, TEXT, BG2, controlsRow)
		b.Size = UDim2.new(0,size,0,size)
		MkCorner(size//2, b)
		MkStroke(Color3.fromRGB(45,45,55),1,b)
		Instance.new("UIAspectRatioConstraint").Parent = b

		local img = MkImg(Funcs.GetAsset(iconPath) or "", TEXT, b)
		img.AnchorPoint = Vector2.new(0.5,0.5)
		img.Position = UDim2.new(0.5,0,0.5,0)
		img.Size = UDim2.new(0.5,0,0.5,0)
		img.Name = "CtrlIcon"
		img.Active = false
		task.defer(function()
			local asset = Funcs.GetAsset(iconPath)
			if asset then img.Image = asset end
		end)
		return b, img
	end
	local prevMusicBtn, prevIcon = MkCtrlBtn("Lucid/Assets/Lucid_Previous.png", 40) prevMusicBtn.LayoutOrder=1 UI.MusicPrevBtn=prevMusicBtn
	local playMusicBtn, playIcon = MkCtrlBtn("Lucid/Assets/Lucid_Play.png", 48) playMusicBtn.LayoutOrder=2 UI.MusicPlayBtn=playMusicBtn UI.MusicPlayIcon=playIcon
	local nextMusicBtn, nextIcon = MkCtrlBtn("Lucid/Assets/Lucid_Next.png", 40) nextMusicBtn.LayoutOrder=3 UI.MusicNextBtn=nextMusicBtn

	local musicSettingsRow = MkFrame(BG2, UDim2.new(1,0,0,74), controlsHolder)
	musicSettingsRow.LayoutOrder = 5
	MkCorner(10, musicSettingsRow)
	MkStroke(Color3.fromRGB(40,40,50),1,musicSettingsRow)
	MkPad(12,12,8,8,musicSettingsRow)
	local msrl = MkList(Enum.FillDirection.Horizontal, 10, musicSettingsRow)
	msrl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local function MkMusicSetting(label, default, name)
		local col = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(0.31,0,1,0), musicSettingsRow)
		col.BackgroundTransparency = 1
		local cl = MkList(Enum.FillDirection.Vertical, 4, col)
		cl.HorizontalFlex = Enum.UIFlexAlignment.Fill
		local lbl = MkLabel(label, GothamMed, 11, SUBTEXT, col)
		lbl.Size = UDim2.new(1,0,0,14)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.LayoutOrder = 1
		local box = Instance.new("TextBox")
		box.BackgroundColor3 = BG3
		box.BorderSizePixel = 0
		box.FontFace = GothamMed
		box.TextSize = 13
		box.TextColor3 = TEXT
		box.Text = default
		box.PlaceholderColor3 = SUBTEXT
		box.Size = UDim2.new(1,0,0,36)
		box.LayoutOrder = 2
		box.Parent = col
		box.TextXAlignment = Enum.TextXAlignment.Center
		box.TextYAlignment = Enum.TextYAlignment.Center
		MkCorner(7, box)
		MkStroke(Color3.fromRGB(40,40,50),1,box)
		UI[name] = box
		return box
	end
	MkMusicSetting("Volume", "1", "MusicVolumeBox")
	MkMusicSetting("Speed", "1", "MusicSpeedBox")

	local loopCol = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(0.31,0,1,0), musicSettingsRow)
	loopCol.BackgroundTransparency = 1
	local lcl = MkList(Enum.FillDirection.Vertical, 4, loopCol)
	lcl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	local loopLbl = MkLabel("Loop", GothamMed, 11, SUBTEXT, loopCol)
	loopLbl.Size = UDim2.new(1,0,0,14)
	loopLbl.TextXAlignment = Enum.TextXAlignment.Left
	loopLbl.LayoutOrder = 1
	local loopToggle = MkBtn("OFF", GothamMed, 13, Color3.fromRGB(200,70,70), BG3, loopCol)
	loopToggle.Size = UDim2.new(1,0,0,36)
	loopToggle.LayoutOrder = 2
	MkCorner(7, loopToggle)
	UI.MusicLoopToggle = loopToggle
	local loopState = false
	loopToggle.MouseButton1Click:Connect(function()
		loopState = not loopState
		loopToggle.Text = loopState and "ON" or "OFF"
		loopToggle.TextColor3 = loopState and Color3.fromRGB(80,200,120) or Color3.fromRGB(200,70,70)
		if MusicSound then MusicSound.Looped = loopState end
	end)

	local musicListScroll = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,0), MusicContent)
	musicListScroll.BackgroundTransparency = 1
	musicListScroll.LayoutOrder = 2
	musicListScroll.AutomaticSize = Enum.AutomaticSize.Y
	local mll = MkList(Enum.FillDirection.Vertical, 6, musicListScroll)
	mll.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkPad(2,2,2,2,musicListScroll)
	UI.MusicListScroll = musicListScroll

	local noMusicL = MkLabel("No music found.\nPlace files in Lucid/Music/", GothamMed, 13, SUBTEXT, musicListScroll)
	noMusicL.Size = UDim2.new(1,0,0,60)
	noMusicL.Visible = false
	UI.NoMusicLabel = noMusicL

	function Funcs.UpdateMusicSlider()
		if not MusicSound or not MusicSound.Parent then return end
		local dur = MusicSound.TimeLength
		local pos = MusicSound.TimePosition
		if dur and dur>0 and not MusicSliderDragging then
			local frac = math.clamp(pos/dur, 0, 1)
			UI.MusicSliderFill.Size = UDim2.new(frac, 0, 1, 0)
			UI.MusicSliderKnob.Position = UDim2.new(frac, 0, 0.5, 0)
			UI.MusicTimeCurrent.Text = Funcs.FormatTime(pos)
			UI.MusicTimeDuration.Text = Funcs.FormatTime(dur)
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
			UI.NowPlayingLabel.Text = "Load failed: "..Funcs.GetMusicDisplayName(filePath)
			return
		end
		MusicSound = Instance.new("Sound")
		MusicSound.SoundId = assetId
		MusicSound.Volume = tonumber(UI.MusicVolumeBox.Text) or 1
		MusicSound.PlaybackSpeed = tonumber(UI.MusicSpeedBox.Text) or 1
		MusicSound.Looped = loopState
		MusicSound.Parent = Workspace
		MusicSound:Play()
		MusicPlaying = true
		if UI.MusicPlayIcon then UI.MusicPlayIcon.Image = Funcs.GetAsset("Lucid/Assets/Lucid_Pause.png") or "" end
		UI.NowPlayingLabel.Text = Funcs.GetMusicDisplayName(filePath)
		UI.NowPlayingSubLabel.Text = "Track "..index.." of "..#MusicFiles
		MusicSound.Ended:Connect(function()
			if not MusicSound.Looped then Funcs.LoadAndPlayMusic(MusicIndex+1) end
		end)
		Funcs.RefreshMusicList()
	end

	function Funcs.RefreshMusicList()
		MusicFiles = Funcs.GetMusicFiles()
		for _, child in ipairs(musicListScroll:GetChildren()) do
			if child~=UI.NoMusicLabel and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
				child:Destroy()
			end
		end
		if #MusicFiles==0 then
			UI.NoMusicLabel.Visible=true
			if UI.NowPlayingSubLabel and not MusicPlaying then
				UI.NowPlayingSubLabel.Text = "Place audio files in Lucid/Music/"
			end
			return
		end
		UI.NoMusicLabel.Visible = false
		if UI.NowPlayingSubLabel and not MusicPlaying then
			UI.NowPlayingSubLabel.Text = #MusicFiles.." tracks available"
		end
		for i, filePath in ipairs(MusicFiles) do
			local dn = Funcs.GetMusicDisplayName(filePath)
			local isActive = i==MusicIndex and MusicPlaying
			local row = MkBtn("", GothamMed, 13, TEXT, isActive and Color3.fromRGB(28,38,62) or BG2, musicListScroll)
			row.Size = UDim2.new(1,0,0,42)
			row.Name = "MusicRow_"..i
			MkCorner(8, row)
			if isActive then MkStroke(ACCENT, 1, row) end
			MkPad(12,12,0,0,row)
			local rl = MkList(Enum.FillDirection.Horizontal, 10, row)
			rl.VerticalAlignment = Enum.VerticalAlignment.Center

			local idxL = MkLabel(tostring(i), GothamMed, 12, isActive and ACCENT or SUBTEXT, row)
			idxL.Size = UDim2.new(0,24,1,0)
			idxL.LayoutOrder = 1
			idxL.TextXAlignment = Enum.TextXAlignment.Center

			local nameL = MkLabel(dn, GothamMed, 13, isActive and WHITE or TEXT, row)
			nameL.Size = UDim2.new(1,-34,1,0)
			nameL.LayoutOrder = 2
			nameL.TextXAlignment = Enum.TextXAlignment.Left
			nameL.TextTruncate = Enum.TextTruncate.AtEnd

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

	UI.MusicVolumeBox:GetPropertyChangedSignal("Text"):Connect(function()
		local v = tonumber(UI.MusicVolumeBox.Text)
		if v and MusicSound then MusicSound.Volume=math.clamp(v,0,10) end
	end)
	UI.MusicSpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
		local v = tonumber(UI.MusicSpeedBox.Text)
		if v and MusicSound then MusicSound.PlaybackSpeed=math.clamp(v,0.1,10) end
	end)

	local sDragging, sInputConn = false, nil
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			sDragging=true MusicSliderDragging=true
			local function Update(inp)
				local bp = sliderBar.AbsolutePosition.X
				local bs = sliderBar.AbsoluteSize.X
				local frac = math.clamp((inp.Position.X-bp)/bs,0,1)
				UI.MusicSliderFill.Size = UDim2.new(frac,0,1,0)
				UI.MusicSliderKnob.Position = UDim2.new(frac,0,0.5,0)
				if MusicSound and MusicSound.TimeLength and MusicSound.TimeLength>0 then
					MusicSound.TimePosition = frac*MusicSound.TimeLength
					UI.MusicTimeCurrent.Text = Funcs.FormatTime(MusicSound.TimePosition)
				end
			end
			Update(input)
			if sInputConn then sInputConn:Disconnect() end
			sInputConn = UIS.InputChanged:Connect(function(inp)
				if sDragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then Update(inp) end
			end)
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then sDragging=false MusicSliderDragging=false if sInputConn then sInputConn:Disconnect() end end
			end)
		end
	end)
end

function Funcs.CreateDropdown(parent, labelText, options, defaultOption, callback)
	local row = MkFrame(BG2, UDim2.new(1,0,0,50), parent)
	row.LayoutOrder = 99
	row.ClipsDescendants = true
	row.AutomaticSize = Enum.AutomaticSize.Y
	MkCorner(10, row)
	MkStroke(Color3.fromRGB(40,40,50),1,row)
	MkPad(14,12,8,8,row)
	local rl = MkList(Enum.FillDirection.Vertical, 8, row)
	rl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local topRow = MkFrame(Color3.fromRGB(0,0,0), UDim2.new(1,0,0,34), row)
	topRow.BackgroundTransparency = 1
	topRow.LayoutOrder = 1
	local trl = MkList(Enum.FillDirection.Horizontal, 8, topRow)
	trl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	trl.VerticalAlignment = Enum.VerticalAlignment.Center

	local lbl = MkLabel(labelText, GothamMed, 13, TEXT, topRow)
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = 1

	local dropBtn = MkBtn(defaultOption or options[1] or "Select...", GothamMed, 13, TEXT, BG3, topRow)
	dropBtn.Size = UDim2.new(0,140,0,32)
	dropBtn.LayoutOrder = 2
	MkCorner(8, dropBtn)
	MkStroke(Color3.fromRGB(45,45,55), 1, dropBtn)
	MkPad(10,10,4,4,dropBtn)

	local listFrame = Instance.new("Frame")
	listFrame.BackgroundColor3 = BG3
	listFrame.BorderSizePixel = 0
	listFrame.Size = UDim2.new(1,0,0,0)
	listFrame.AutomaticSize = Enum.AutomaticSize.Y
	listFrame.Visible = false
	listFrame.LayoutOrder = 2
	listFrame.Parent = row
	MkCorner(8, listFrame)
	MkStroke(Color3.fromRGB(50,50,65), 1, listFrame)
	local lfl = MkList(Enum.FillDirection.Vertical, 2, listFrame)
	lfl.HorizontalFlex = Enum.UIFlexAlignment.Fill
	MkPad(4,4,4,4,listFrame)

	local isOpen = false
	dropBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		listFrame.Visible = isOpen
	end)

	for _, opt in ipairs(options) do
		local optBtn = MkBtn(opt, GothamMed, 12, TEXT, BG3, listFrame)
		optBtn.Size = UDim2.new(1,0,0,30)
		MkCorner(6, optBtn)
		optBtn.MouseButton1Click:Connect(function()
			dropBtn.Text = opt
			isOpen = false
			listFrame.Visible = false
			if callback then callback(opt) end
		end)
	end

	return row
end

do
	MkPad(12,0,10,10,SettingsContent)
	local sl = MkList(Enum.FillDirection.Vertical, 8, SettingsContent)
	sl.HorizontalFlex = Enum.UIFlexAlignment.Fill

	local function MkSettingRow(label, layoutOrder)
		local row = MkFrame(BG2, UDim2.new(1,0,0,50), SettingsContent)
		row.LayoutOrder = layoutOrder
		MkCorner(10, row)
		MkStroke(Color3.fromRGB(40,40,50),1,row)
		MkPad(14,12,0,0,row)
		local rl = MkList(Enum.FillDirection.Horizontal, 8, row)
		rl.HorizontalFlex = Enum.UIFlexAlignment.Fill
		rl.VerticalAlignment = Enum.VerticalAlignment.Center
		local lbl = MkLabel(label, GothamMed, 14, TEXT, row)
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.LayoutOrder = 1
		return row
	end

	local discordRow = MkFrame(BG2, UDim2.new(1,0,0,50), SettingsContent)
	discordRow.LayoutOrder = 1
	MkCorner(10, discordRow)
	MkStroke(Color3.fromRGB(40,40,50),1,discordRow)
	MkPad(14,12,0,0,discordRow)
	local drl = MkList(Enum.FillDirection.Horizontal, 10, discordRow)
	drl.VerticalAlignment = Enum.VerticalAlignment.Center

	local discordIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Discord.png") or "", WHITE, discordRow)
	discordIco.Size = UDim2.new(0,22,0,22)
	discordIco.LayoutOrder = 1
	discordIco.Active = false
	Instance.new("UIAspectRatioConstraint").Parent = discordIco
	task.defer(function()
		local asset = Funcs.GetAsset("Lucid/Assets/Lucid_Discord.png")
		if asset then discordIco.Image = asset end
	end)

	local discordLbl = MkLabel("Copy Discord Server Url", GothamMed, 14, TEXT, discordRow)
	discordLbl.Size = UDim2.new(1,-130,1,0)
	discordLbl.TextXAlignment = Enum.TextXAlignment.Left
	discordLbl.LayoutOrder = 2
	discordLbl.TextTruncate = Enum.TextTruncate.AtEnd

	local discordCopyBtn = MkBtn("", GothamMed, 13, TEXT, BG3, discordRow)
	discordCopyBtn.LayoutOrder = 3
	discordCopyBtn.Size = UDim2.new(0,88,0,32)
	discordCopyBtn.ClipsDescendants = true
	MkCorner(8, discordCopyBtn)
	MkStroke(Color3.fromRGB(45,45,55), 1, discordCopyBtn)
	local dcbLayout = MkList(Enum.FillDirection.Horizontal, 6, discordCopyBtn)
	dcbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	dcbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	MkPad(8,8,4,4,discordCopyBtn)

	local clipIco = MkImg(Funcs.GetAsset("Lucid/Assets/Lucid_Clipboard.png") or "", TEXT, discordCopyBtn)
	clipIco.Size = UDim2.new(0,14,0,14)
	clipIco.LayoutOrder = 1
	clipIco.Active = false
	Instance.new("UIAspectRatioConstraint").Parent = clipIco
	task.defer(function()
		local asset = Funcs.GetAsset("Lucid/Assets/Lucid_Clipboard.png")
		if asset then clipIco.Image = asset end
	end)

	local copyLbl = MkLabel("Copy", GothamMed, 13, TEXT, discordCopyBtn)
	copyLbl.Size = UDim2.new(0,0,1,0)
	copyLbl.AutomaticSize = Enum.AutomaticSize.X
	copyLbl.TextWrapped = false
	copyLbl.LayoutOrder = 2
	copyLbl.Active = false

	discordCopyBtn.MouseButton1Click:Connect(function()
		SetClipboard("https://discord.gg/KS8dBeQm9q")
		copyLbl.Text = "Copied!"
		task.delay(1.5, function() copyLbl.Text = "Copy" end)
	end)

	local animRow = MkSettingRow("Animations", 2)
	local animToggle = MkBtn(Settings.Animations and "ON" or "OFF", GothamMed, 13, Settings.Animations and Color3.fromRGB(80,200,120) or Color3.fromRGB(200,70,70), BG3, animRow)
	animToggle.LayoutOrder = 2
	animToggle.Size = UDim2.new(0,72,0,32)
	MkCorner(8, animToggle)
	MkStroke(Color3.fromRGB(45,45,55), 1, animToggle)
	MkPad(8,8,4,4,animToggle)
	animToggle.MouseButton1Click:Connect(function()
		Settings.Animations = not Settings.Animations
		animToggle.Text = Settings.Animations and "ON" or "OFF"
		animToggle.TextColor3 = Settings.Animations and Color3.fromRGB(80,200,120) or Color3.fromRGB(200,70,70)
		Funcs.SaveSettings()
	end)

	local themes = {"Default Dark", "Midnight", "Amethyst", "Crimson", "Emerald", "Ocean"}
	Funcs.CreateDropdown(SettingsContent, "Theme Preset", themes, Settings.ThemePreset or "Default Dark", function(selected)
		Funcs.ApplyTheme(selected)
	end)

	local function MkColorSetting(label, settingKey, order)
		local row = MkFrame(BG2, UDim2.new(1,0,0,50), SettingsContent)
		row.LayoutOrder = order
		MkCorner(10, row)
		MkStroke(Color3.fromRGB(40,40,50),1,row)
		MkPad(14,12,0,0,row)
		local rl = MkList(Enum.FillDirection.Horizontal, 8, row)
		rl.HorizontalFlex = Enum.UIFlexAlignment.Fill
		rl.VerticalAlignment = Enum.VerticalAlignment.Center
		local lbl = MkLabel(label, GothamMed, 13, TEXT, row)
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.LayoutOrder = 1
		local input = Instance.new("TextBox")
		input.BackgroundColor3 = BG3
		input.BorderSizePixel = 0
		input.FontFace = GothamMed
		input.TextSize = 13
		input.PlaceholderColor3 = SUBTEXT
		local c = Settings[settingKey]
		input.PlaceholderText = string.format("%d, %d, %d", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
		input.TextColor3 = TEXT
		input.Text = ""
		input.Size = UDim2.new(0,116,0,32)
		input.LayoutOrder = 2
		input.ClearTextOnFocus = false
		input.Parent = row
		MkCorner(8, input)
		MkStroke(Color3.fromRGB(45,45,55),1,input)
		MkPad(8,8,4,4,input)
		input.FocusLost:Connect(function(enter)
			if enter then
				local color = Funcs.ParseColor(input.Text)
				if color then
					Settings[settingKey] = color
					Funcs.SaveSettings()
					input.PlaceholderText = input.Text
					input.Text = ""
				end
			end
		end)
	end

	MkColorSetting("Accent Color (R,G,B)", "AccentColor", 3)
	MkColorSetting("Background Color (R,G,B)", "BGColor", 4)
	MkColorSetting("Secondary BG Color (R,G,B)", "BG2Color", 5)

	local resetRow = MkSettingRow("Reset Theme", 6)
	local resetBtn = MkBtn("Reset", GothamMed, 13, WHITE, Color3.fromRGB(180,50,50), resetRow)
	resetBtn.LayoutOrder = 2
	resetBtn.Size = UDim2.new(0,80,0,32)
	MkCorner(8, resetBtn)
	MkStroke(Color3.fromRGB(45,45,55), 1, resetBtn)
	MkPad(8,8,4,4,resetBtn)
	resetBtn.MouseButton1Click:Connect(function()
		Settings.AccentColor = Color3.fromRGB(60,130,255)
		Settings.BGColor = Color3.fromRGB(15,15,18)
		Settings.BG2Color = Color3.fromRGB(22,22,27)
		Funcs.SaveSettings()
	end)

	local destroyRow = MkSettingRow("Destroy UI", 8)
	local destroyBtn = MkBtn("Destroy", GothamMed, 13, Color3.fromRGB(220,80,80), BG3, destroyRow)
	destroyBtn.LayoutOrder = 2
	destroyBtn.Size = UDim2.new(0,80,0,32)
	MkCorner(8, destroyBtn)
	MkStroke(Color3.fromRGB(45,45,55), 1, destroyBtn)
	MkPad(8,8,4,4,destroyBtn)
	destroyBtn.MouseButton1Click:Connect(function()
		Env.__Lucid.IsLoaded = false
		if MusicSound then pcall(function() MusicSound:Stop() MusicSound:Destroy() end) end
		pcall(function() Screen:Destroy() end)
		pcall(function() ShowBtn:Destroy() end)
		pcall(function() Overlay:Destroy() end)
	end)
	local clearBtn = MkBtn("Clear", GothamMed, 13, WHITE, BG3, clearCacheRow)
	clearBtn.LayoutOrder = 2
	clearBtn.Size = UDim2.new(0,80,0,32)
	MkCorner(8, clearBtn)
	MkStroke(Color3.fromRGB(45,45,55), 1, clearBtn)
	MkPad(8,8,4,4,clearBtn)
	clearBtn.MouseButton1Click:Connect(function()
		if IsFolder("Lucid/Cache") then
			local files = ListFiles("Lucid/Cache")
			for _, f in ipairs(files) do pcall(function() DelFile(f) end) end
		end
		clearBtn.Text = "Done!"
		task.delay(2, function() clearBtn.Text = "Clear" end)
	end)
end

ShowBtn.MouseButton1Click:Connect(function() Funcs.OpenUI() end)
CloseBtn.MouseButton1Click:Connect(function() Funcs.CloseUI() end)
Funcs.Dragify(ShowBtn)

PageBtns["Home"].frame.BackgroundTransparency = 0
PageBtns["Home"].icon.ImageColor3 = WHITE
PageContents["Home"].Visible = true

Funcs.InitDefaultScripts()
Funcs.UpdateStats()

coroutine.wrap(function()
	while Screen and Screen.Parent do
		pcall(function()
			local fps = math.floor(workspace:GetRealPhysicsFPS() or 0)
			local ping = math.floor((Player:GetNetworkPing() or 0)*1000)
			UI.FpsLbl.Text = fps.." FPS"
			UI.PingLbl.Text = ping.." ms"
		end)
		task.wait(0.1)
	end
end)()

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
