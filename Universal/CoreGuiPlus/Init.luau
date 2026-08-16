if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Service)
    local Service = game:GetService(Service)
    return cloneref and cloneref(Service) or Service
end

local Hui = gethui and gethui() or GetService("CoreGui")
local CoreGui = GetService("CoreGui")
local TweenService = GetService("TweenService")
local Players = GetService("Players")
local StarterGui = GetService("StarterGui")
local TextChatService = GetService("TextChatService")
local UserInputService = GetService("UserInputService")

Shared.CoreGuiPlus = Shared.CoreGuiPlus or {}

if Shared.CoreGuiPlus.IsLoaded then
    StarterGui:SetCore("SendNotification", {
      Title = "CoreGui+",
      Text = "CoreGui+ is already running!",
      Duration = 4
    })
  return
end

Shared.CoreGuiPlus.IsLoaded = true

local WriteFile = (type(writefile) == "function" and writefile) or function()
  return
end
local IsFile = (type(isfile) == "function" and isfile) or function()
  return
end
local IsFolder = (type(isfolder) == "function" and isfolder) or function()
  return
end
local MakeFolder = (type(makefolder) == "function" and makefolder) or function()
  return
end
local LoadAsset =
(type(getcustomasset) == "function" and getcustomasset) or (type(getsynasset) == "function" and getsynasset) or nil

local Assets = {
["CoreGuiPlus/Assets/cgp_jump.png"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/CoreGuiPlus/Assets/jump.png"
}

local function HttpGet(Url)
  local RequestFunc =
  (type(syn) == "table" and type(syn.request) == "function" and syn.request) or
  (type(request) == "function" and request) or
  (type(http_request) == "function" and http_request) or
  nil

  if not RequestFunc then
    return nil
  end

  local Success, Result =
  pcall(
  function()
    return RequestFunc({Url = Url, Method = "GET"})
  end
  )

  return Success and Result or nil
end

local function GetAsset(Path)
  if not LoadAsset then
    return nil
  end

  if not IsFolder("CoreGuiPlus") then
    MakeFolder("CoreGuiPlus")
  end

  if not IsFolder("CoreGuiPlus/Assets") then
    MakeFolder("CoreGuiPlus/Assets")
  end

  if Path:match("^rbxassetid://") then
    return Path
  end

  local AssetPath = Path:match("^CoreGuiPlus/Assets/") and Path or ("CoreGuiPlus/Assets/" .. Path)

  if IsFile(AssetPath) then
    return LoadAsset(AssetPath)
  end

  local Url = Assets[Path]
  if not Url then
    return nil
  end

  local Response = HttpGet(Url)
  if not Response or not Response.Body then
    return nil
  end

  WriteFile(AssetPath, Response.Body)
  return LoadAsset(AssetPath)
end

local function Tween(Object, Speed, Props, Style, Dir)
    return TweenService:Create(
        Object,
        TweenInfo.new(
            Speed,
            Enum.EasingStyle[Style or "Quad"],
            Enum.EasingDirection[Dir or "Out"]
        ),
        Props
    )
end

local function UID(Length)
    Length = Length or 64

    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = table.create(Length)

    for i = 1, Length do
        local Rand = math.random(1, #Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end

    return table.concat(Id)
end

local IsMobile =
UserInputService.TouchEnabled and not UserInputService.MouseEnabled and not UserInputService.KeyboardEnabled
local IsDesktop =
not UserInputService.TouchEnabled and UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

local Strokes = {}
local GradientColor =
ColorSequence.new {
ColorSequenceKeypoint.new(0.000, Color3.fromRGB(19, 19, 22)),
ColorSequenceKeypoint.new(0.500, Color3.fromRGB(51, 101, 255)),
ColorSequenceKeypoint.new(1.000, Color3.fromRGB(19, 19, 22))
}

local NameColors = {
Color3.fromRGB(255, 100, 100),
Color3.fromRGB(255, 160, 80),
Color3.fromRGB(255, 220, 80),
Color3.fromRGB(120, 220, 80),
Color3.fromRGB(80, 220, 160),
Color3.fromRGB(80, 200, 255),
Color3.fromRGB(100, 140, 255),
Color3.fromRGB(160, 100, 255),
Color3.fromRGB(220, 80, 255),
Color3.fromRGB(255, 80, 200),
Color3.fromRGB(255, 80, 130),
Color3.fromRGB(255, 140, 180),
Color3.fromRGB(140, 255, 180),
Color3.fromRGB(80, 255, 220),
Color3.fromRGB(180, 255, 100),
Color3.fromRGB(255, 200, 120),
Color3.fromRGB(120, 180, 255),
Color3.fromRGB(200, 120, 255),
Color3.fromRGB(255, 120, 80),
Color3.fromRGB(80, 255, 140)
}

local function Error(Reason)
  error("[CoreGui+]: " .. Reason, 2)
end

local function ProtectProperty(Object, Property, Value)
  Object[Property] = Value
  Object:GetPropertyChangedSignal(Property):Connect(
  function()
    if Object[Property] ~= Value then
      Object[Property] = Value
    end
  end
  )
end

local function ProtectCorner(Corner, Radius)
  ProtectProperty(Corner, "CornerRadius", Radius or UDim.new(0, 12))
end

local function Style(Object, CornerRadius)
  if not Object then
    return
  end

  ProtectProperty(Object, "BackgroundColor3", Color3.fromRGB(18, 18, 21))
  ProtectProperty(Object, "BackgroundTransparency", 0.08)

  local Stroke = Object:FindFirstChildOfClass("UIStroke")
  if not Stroke then
    Stroke = Instance.new("UIStroke")
    Stroke.Name = "Stroke"
    Stroke.Parent = Object
  end

  ProtectProperty(Stroke, "ApplyStrokeMode", Enum.ApplyStrokeMode.Border)
  ProtectProperty(Stroke, "BorderStrokePosition", Enum.BorderStrokePosition.Inner)
  ProtectProperty(Stroke, "Color", Color3.fromRGB(255, 255, 255))

  local Gradient = Stroke:FindFirstChildOfClass("UIGradient")
  if not Gradient then
    Gradient = Instance.new("UIGradient")
    Gradient.Name = "Gradient"
    Gradient.Parent = Stroke
  end

  ProtectProperty(Gradient, "Color", GradientColor)
  table.insert(Strokes, Stroke)

  local RadiusValue
  if CornerRadius then
    local Parts = {}
    for Part in string.gmatch(CornerRadius, "[^,]+") do
      table.insert(Parts, tonumber(Part) or 0)
    end

    if #Parts == 2 then
      RadiusValue = UDim.new(Parts[1], Parts[2])
    end
  end

  local Corner = Object:FindFirstChildOfClass("UICorner")
  if not Corner then
    Corner = Instance.new("UICorner")
    Corner.Name = "Corner"
    Corner.Parent = Object
  end

  ProtectCorner(Corner, RadiusValue or UDim.new(0, 12))

  local function StyleDescendantCorners(Parent)
    for _, Child in ipairs(Parent:GetChildren()) do
      if Child:IsA("UICorner") then
        ProtectCorner(Child, RadiusValue or UDim.new(0, 12))
      else
      StyleDescendantCorners(Child)
    end
  end
end
StyleDescendantCorners(Object)

task.spawn(
function()
  while Object.Parent do
    local Sine = os.clock()
    Gradient.Rotation = (Sine * 60) % 360
    Gradient.Offset = Vector2.new(2.5 * math.sin(Sine), math.cos((Sine + 0.5) * 0.1))
    task.wait()
  end
end
)
end

local function AnimateStroke(Gradient)
  task.spawn(
  function()
    while Gradient and Gradient.Parent do
      local Sine = os.clock()
      Gradient.Rotation = (Sine * 60) % 360
      Gradient.Offset = Vector2.new(2.5 * math.sin(Sine), math.cos((Sine + 0.5) * 0.1))
      task.wait()
    end
  end
  )
end

local function FindIconButton(Icon)
  for _, Child in ipairs(Icon:GetChildren()) do
    if Child:IsA("Frame") and Child.BackgroundColor3 ~= Color3.fromRGB(0, 0, 0) then
      for _, Descendant in ipairs(Child:GetChildren()) do
        if Descendant:IsA("UICorner") then
          return Child
        end
      end
    end
  end
end

local UI = {}
UI.Chat = {}
local CUI = UI.Chat

CUI["ScreenGui"] = Instance.new("ScreenGui")
CUI["ScreenGui"]["Name"] = UID()
CUI["ScreenGui"]["ResetOnSpawn"] = false
CUI["ScreenGui"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
CUI["ScreenGui"]["Parent"] = Hui

CUI["Chat"] = Instance.new("CanvasGroup")
CUI["Chat"]["AnchorPoint"] = Vector2.new(0, 0)
CUI["Chat"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
CUI["Chat"]["BorderSizePixel"] = 0
CUI["Chat"]["ClipsDescendants"] = true
CUI["Chat"]["Name"] = "Chat"
CUI["Chat"]["Position"] = UDim2.new(0, -320, 0, 2)
CUI["Chat"]["Size"] = UDim2.new(0, 308, 0, 188)
CUI["Chat"]["Visible"] = true
CUI["Chat"]["Parent"] = CUI["ScreenGui"]

CUI["ChatCorner"] = Instance.new("UICorner")
CUI["ChatCorner"]["Name"] = "ChatCorner"
CUI["ChatCorner"]["CornerRadius"] = UDim.new(0, 12)
CUI["ChatCorner"]["Parent"] = CUI["Chat"]

CUI["ChatLayout"] = Instance.new("UIListLayout")
CUI["ChatLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
CUI["ChatLayout"]["Name"] = "ChatLayout"
CUI["ChatLayout"]["Padding"] = UDim.new(0, 2)
CUI["ChatLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
CUI["ChatLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
CUI["ChatLayout"]["Parent"] = CUI["Chat"]

CUI["ChatPadding"] = Instance.new("UIPadding")
CUI["ChatPadding"]["Name"] = "ChatPadding"
CUI["ChatPadding"]["PaddingBottom"] = UDim.new(0, 4)
CUI["ChatPadding"]["PaddingLeft"] = UDim.new(0, 4)
CUI["ChatPadding"]["PaddingRight"] = UDim.new(0, 4)
CUI["ChatPadding"]["PaddingTop"] = UDim.new(0, 4)
CUI["ChatPadding"]["Parent"] = CUI["Chat"]

CUI["ChatStroke"] = Instance.new("UIStroke")
CUI["ChatStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
CUI["ChatStroke"]["Name"] = "ChatStroke"
CUI["ChatStroke"]["Parent"] = CUI["Chat"]

CUI["ChatStrokeGradient"] = Instance.new("UIGradient")
CUI["ChatStrokeGradient"]["Color"] = GradientColor
CUI["ChatStrokeGradient"]["Name"] = "ChatStrokeGradient"
CUI["ChatStrokeGradient"]["Parent"] = CUI["ChatStroke"]

CUI["Messages"] = Instance.new("ScrollingFrame")
CUI["Messages"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
CUI["Messages"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
CUI["Messages"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
CUI["Messages"]["BackgroundTransparency"] = 1
CUI["Messages"]["BorderSizePixel"] = 0
CUI["Messages"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
CUI["Messages"]["LayoutOrder"] = 1
CUI["Messages"]["Name"] = "Messages"
CUI["Messages"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
CUI["Messages"]["ScrollBarThickness"] = 4
CUI["Messages"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
CUI["Messages"]["Size"] = UDim2.new(1, -8, 1, -8)
CUI["Messages"]["Parent"] = CUI["Chat"]

CUI["MessagesCorner"] = Instance.new("UICorner")
CUI["MessagesCorner"]["Name"] = "MessagesCorner"
CUI["MessagesCorner"]["CornerRadius"] = UDim.new(0, 12)
CUI["MessagesCorner"]["Parent"] = CUI["Messages"]

CUI["MessagesLayout"] = Instance.new("UIListLayout")
CUI["MessagesLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
CUI["MessagesLayout"]["Name"] = "MessagesLayout"
CUI["MessagesLayout"]["Padding"] = UDim.new(0, 2)
CUI["MessagesLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
CUI["MessagesLayout"]["Parent"] = CUI["Messages"]

CUI["MessagesPadding"] = Instance.new("UIPadding")
CUI["MessagesPadding"]["Name"] = "MessagesPadding"
CUI["MessagesPadding"]["PaddingRight"] = UDim.new(0, 6)
CUI["MessagesPadding"]["Parent"] = CUI["Messages"]

CUI["MessageTemplate"] = Instance.new("TextLabel")
CUI["MessageTemplate"]["AutomaticSize"] = Enum.AutomaticSize.Y
CUI["MessageTemplate"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
CUI["MessageTemplate"]["BackgroundTransparency"] = 1
CUI["MessageTemplate"]["BorderSizePixel"] = 0
CUI["MessageTemplate"]["FontFace"] =
Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CUI["MessageTemplate"]["Name"] = "MessageTemplate"
CUI["MessageTemplate"]["Position"] = UDim2.new(0, 0, 0, 0)
CUI["MessageTemplate"]["RichText"] = true
CUI["MessageTemplate"]["Size"] = UDim2.new(1, 0, 0, 0)
CUI["MessageTemplate"]["Text"] = [[<font color="#4DA6FF">[DisplayName]:</font> <font color="#FFFFFF">Message</font>]]
CUI["MessageTemplate"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
CUI["MessageTemplate"]["TextSize"] = 18
CUI["MessageTemplate"]["TextWrapped"] = true
CUI["MessageTemplate"]["TextXAlignment"] = Enum.TextXAlignment.Left
CUI["MessageTemplate"]["TextYAlignment"] = Enum.TextYAlignment.Top
CUI["MessageTemplate"]["Visible"] = false
CUI["MessageTemplate"]["Parent"] = CUI["Messages"]

CUI["ChatFrame"] = Instance.new("Frame")
CUI["ChatFrame"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
CUI["ChatFrame"]["BackgroundTransparency"] = 0.95
CUI["ChatFrame"]["BorderSizePixel"] = 0
CUI["ChatFrame"]["LayoutOrder"] = 2
CUI["ChatFrame"]["Name"] = "ChatFrame"
CUI["ChatFrame"]["Size"] = UDim2.new(1, 0, 0, 44)
CUI["ChatFrame"]["Parent"] = CUI["Chat"]

CUI["ChatFrameCorner"] = Instance.new("UICorner")
CUI["ChatFrameCorner"]["Name"] = "ChatFrameCorner"
CUI["ChatFrameCorner"]["CornerRadius"] = UDim.new(0, 12)
CUI["ChatFrameCorner"]["Parent"] = CUI["ChatFrame"]

CUI["ChatFrameLayout"] = Instance.new("UIListLayout")
CUI["ChatFrameLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
CUI["ChatFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
CUI["ChatFrameLayout"]["Name"] = "ChatFrameLayout"
CUI["ChatFrameLayout"]["Padding"] = UDim.new(0, 4)
CUI["ChatFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
CUI["ChatFrameLayout"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
CUI["ChatFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
CUI["ChatFrameLayout"]["Parent"] = CUI["ChatFrame"]

CUI["ChatFramePadding"] = Instance.new("UIPadding")
CUI["ChatFramePadding"]["Name"] = "ChatFramePadding"
CUI["ChatFramePadding"]["PaddingBottom"] = UDim.new(0, 2)
CUI["ChatFramePadding"]["PaddingLeft"] = UDim.new(0, 10)
CUI["ChatFramePadding"]["PaddingRight"] = UDim.new(0, 2)
CUI["ChatFramePadding"]["PaddingTop"] = UDim.new(0, 2)
CUI["ChatFramePadding"]["Parent"] = CUI["ChatFrame"]

CUI["ChatFrameStroke"] = Instance.new("UIStroke")
CUI["ChatFrameStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
CUI["ChatFrameStroke"]["Name"] = "ChatFrameStroke"
CUI["ChatFrameStroke"]["Parent"] = CUI["ChatFrame"]

CUI["ChatFrameStrokeGradient"] = Instance.new("UIGradient")
CUI["ChatFrameStrokeGradient"]["Color"] = GradientColor
CUI["ChatFrameStrokeGradient"]["Name"] = "ChatFrameStrokeGradient"
CUI["ChatFrameStrokeGradient"]["Parent"] = CUI["ChatFrameStroke"]

CUI["Chatbox"] = Instance.new("TextBox")
CUI["Chatbox"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
CUI["Chatbox"]["BackgroundTransparency"] = 1
CUI["Chatbox"]["BorderSizePixel"] = 0
CUI["Chatbox"]["FontFace"] =
Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CUI["Chatbox"]["LayoutOrder"] = 1
CUI["Chatbox"]["Name"] = "Chatbox"
CUI["Chatbox"]["PlaceholderColor3"] = Color3.fromRGB(114, 114, 114)
CUI["Chatbox"]["PlaceholderText"] = "Tap here to chat"
CUI["Chatbox"]["Text"] = ""
CUI["Chatbox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
CUI["Chatbox"]["TextScaled"] = true
CUI["Chatbox"]["TextSize"] = 18
CUI["Chatbox"]["TextWrapped"] = true
CUI["Chatbox"]["TextXAlignment"] = Enum.TextXAlignment.Left
CUI["Chatbox"]["Parent"] = CUI["ChatFrame"]

CUI["TextConstraint"] = Instance.new("UITextSizeConstraint")
CUI["TextConstraint"]["MaxTextSize"] = 22
CUI["TextConstraint"]["Name"] = "TextConstraint"
CUI["TextConstraint"]["Parent"] = CUI["Chatbox"]

CUI["Send"] = Instance.new("TextButton")
CUI["Send"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
CUI["Send"]["BackgroundTransparency"] = 1
CUI["Send"]["BorderSizePixel"] = 0
CUI["Send"]["FontFace"] =
Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CUI["Send"]["LayoutOrder"] = 2
CUI["Send"]["Name"] = "Send"
CUI["Send"]["Size"] = UDim2.new(0, 36, 0, 36)
CUI["Send"]["Text"] = "↑"
CUI["Send"]["TextColor3"] = Color3.fromRGB(114, 114, 114)
CUI["Send"]["TextScaled"] = true
CUI["Send"]["TextWrapped"] = true
CUI["Send"]["Parent"] = CUI["ChatFrame"]

CUI["SendRatio"] = Instance.new("UIAspectRatioConstraint")
CUI["SendRatio"]["AspectRatio"] = 1
CUI["SendRatio"]["Name"] = "SendRatio"
CUI["SendRatio"]["Parent"] = CUI["Send"]

CUI["SendCorner"] = Instance.new("UICorner")
CUI["SendCorner"]["Name"] = "SendCorner"
CUI["SendCorner"]["CornerRadius"] = UDim.new(0, 12)
CUI["SendCorner"]["Parent"] = CUI["Send"]

CUI["SendPadding"] = Instance.new("UIPadding")
CUI["SendPadding"]["Name"] = "SendPadding"
CUI["SendPadding"]["PaddingBottom"] = UDim.new(0, 2)
CUI["SendPadding"]["PaddingLeft"] = UDim.new(0, 2)
CUI["SendPadding"]["PaddingRight"] = UDim.new(0, 2)
CUI["SendPadding"]["PaddingTop"] = UDim.new(0, 2)
CUI["SendPadding"]["Parent"] = CUI["Send"]

CUI["SendStroke"] = Instance.new("UIStroke")
CUI["SendStroke"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
CUI["SendStroke"]["Color"] = Color3.fromRGB(255, 255, 255)
CUI["SendStroke"]["Name"] = "SendStroke"
CUI["SendStroke"]["Parent"] = CUI["Send"]

CUI["SendStrokeGradient"] = Instance.new("UIGradient")
CUI["SendStrokeGradient"]["Color"] = GradientColor
CUI["SendStrokeGradient"]["Name"] = "SendStrokeGradient"
CUI["SendStrokeGradient"]["Parent"] = CUI["SendStroke"]

AnimateStroke(CUI["ChatStrokeGradient"])
AnimateStroke(CUI["ChatFrameStrokeGradient"])
AnimateStroke(CUI["SendStrokeGradient"])

local PlayerNameColors = {}

local function GetNameColor(UserId)
  if not PlayerNameColors[UserId] then
    PlayerNameColors[UserId] = NameColors[(UserId % #NameColors) + 1]
  end
  return PlayerNameColors[UserId]
end

local function RGBToHex(Color)
  return string.format(
  "#%02X%02X%02X",
  math.floor(Color.R * 255),
  math.floor(Color.G * 255),
  math.floor(Color.B * 255)
  )
end

local MaxMessages = 20

local function GetMessageLabels()
  local Labels = {}
  for _, Child in ipairs(CUI["Messages"]:GetChildren()) do
    if Child:IsA("TextLabel") and Child.Name ~= CUI["MessageTemplate"].Name then
      table.insert(Labels, Child)
    end
  end
  return Labels
end

local function AddMessage(DisplayName, MessageText, UserId)
	local Labels = GetMessageLabels()

	table.sort(Labels, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)

	while #Labels >= MaxMessages do
		Labels[1]:Destroy()
		table.remove(Labels, 1)
	end

	Labels = GetMessageLabels()
	table.sort(Labels, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	for i, Label in ipairs(Labels) do
		Label.LayoutOrder = i
	end

	local NameColor = RGBToHex(GetNameColor(UserId or 0))
	local Clone = CUI["MessageTemplate"]:Clone()
	Clone.Text = string.format(
		[[<font color="%s">[%s]:</font> <font color="#FFFFFF">%s</font>]],
		NameColor,
		DisplayName,
		MessageText
	)
	Clone.Name = "Message_" .. tostring(UserId) .. "_" .. tostring(os.time())
	Clone.Visible = true
	Clone.LayoutOrder = #Labels + 1
	Clone.Parent = CUI["Messages"]

	task.wait()
	CUI["Messages"].CanvasPosition = Vector2.new(0, CUI["Messages"].AbsoluteCanvasSize.Y)
end

local ChatVisible = false
local SlideInPos = UDim2.new(0, 16, 0, 2)
local SlideOutPos = UDim2.new(0, -320, 0, 2)

local function ShowChat()
  ChatVisible = true
  CUI["Chat"].Visible = true
  Tween(CUI["Chat"], 0.35, {Position = SlideInPos}, "Back", "Out"):Play()
end

local function HideChat()
  ChatVisible = false
  local T = Tween(CUI["Chat"], 0.25, {Position = SlideOutPos}, "Quad", "In")
  T:Play()
  T.Completed:Connect(
  function()
    if not ChatVisible then
      CUI["Chat"].Visible = false
    end
  end
  )
end

local function SendMessage()
  local Text = CUI["Chatbox"].Text
  if Text == "" then
    return
  end
  CUI["Chatbox"].Text = ""
  local Channel = TextChatService:FindFirstChild("TextChannels")
  if Channel then
    Channel = Channel:FindFirstChild("RBXGeneral")
  end
  if Channel then
    Channel:SendAsync(Text)
  end
end

CUI["Chatbox"]:GetPropertyChangedSignal("Text"):Connect(
function()
  local TargetColor = CUI["Chatbox"].Text ~= "" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(114, 114, 114)
  Tween(CUI["Send"], 0.2, {TextColor3 = TargetColor}):Play()
end
)

CUI["Send"]["Activated"]:Connect(SendMessage)

CUI["Chatbox"]["FocusLost"]:Connect(
function(EnterPressed)
  if EnterPressed then
    SendMessage()
  end
end
)

TextChatService.MessageReceived:Connect(
function(Message)
  local Source = Message.TextSource
  if not Source then
    return
  end
  local Player = Players:GetPlayerByUserId(Source.UserId)
  local DisplayName = Player and Player.DisplayName or tostring(Source.UserId)
  AddMessage(DisplayName, Message.Text, Source.UserId)
end
)

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
  Error("LocalPlayer was not found")
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
  Error("PlayerGui was not found")
end

local TopbarStandard = PlayerGui:FindFirstChild("TopbarStandard")
if not TopbarStandard then
  Error("TopbarStandard was not found")
end

local Holders = TopbarStandard:FindFirstChild("Holders")
if not Holders then
  Error("Holders was not found")
end

local TopBarApp = CoreGui:FindFirstChild("TopBarApp")
if not TopBarApp then
  Error("TopBarApp was not found")
end

local TopBarAppInner = TopBarApp:FindFirstChild("TopBarApp")
if not TopBarAppInner then
  Error("TopBarApp.TopBarApp was not found")
end

local UnibarLeftFrame = TopBarAppInner:FindFirstChild("UnibarLeftFrame")
if not UnibarLeftFrame then
  Error("UnibarLeftFrame was not found")
end

local UnibarMenu = UnibarLeftFrame:FindFirstChild("UnibarMenu")
if not UnibarMenu then
  Error("UnibarMenu was not found")
end

local MenuBtn = UnibarMenu:FindFirstChild("2")
if not MenuBtn then
  Error('UnibarMenu["2"] was not found')
end

MenuBtn = MenuBtn:FindFirstChild("2")
if not MenuBtn then
  Error('UnibarMenu["2"]["2"] was not found')
end

local MenuIconHolder = TopBarAppInner:FindFirstChild("MenuIconHolder")
if not MenuIconHolder then
  Error("MenuIconHolder was not found")
end

local TriggerPoint = MenuIconHolder:FindFirstChild("TriggerPoint")
if not TriggerPoint then
  Error("TriggerPoint was not found")
end

local EscBtn = TriggerPoint:FindFirstChild("IconHitArea")
if not EscBtn then
  Error("IconHitArea was not found")
end

EscBtn["Activated"]:Connect(
function()
  if ChatVisible then
    HideChat()
  end
end
)

local LucidBtn = nil

if Hui then
	local Lucid = Hui:FindFirstChild("Lucid")
	if Lucid then
		LucidBtn = Lucid:FindFirstChild("Show")
	end
end

local ExperienceChat = CoreGui:FindFirstChild("ExperienceChat")
if ExperienceChat then
  ProtectProperty(ExperienceChat, "Enabled", false)
end

local NineDot = UnibarMenu["2"]:FindFirstChild("3")
if NineDot then
  NineDot = NineDot:FindFirstChild("nine_dot")
  if NineDot then
    NineDot = NineDot:FindFirstChild("IntegrationIconFrame")
    if NineDot then
      NineDot = NineDot:FindFirstChild("IntegrationIcon")
      if NineDot then
        local Corner = NineDot:FindFirstChild("Corner")
        if Corner and Corner:IsA("UICorner") then
          ProtectProperty(Corner, "CornerRadius", UDim.new(0, 12))
        end
      end
    end
  end
end

local ChatBtn = UnibarMenu["2"]:FindFirstChild("3")
if ChatBtn then
  ChatBtn = ChatBtn:FindFirstChild("chat")
  if ChatBtn then
    local ChatHitArea = ChatBtn:FindFirstChild("IconHitArea_chat")
    if ChatHitArea then
      ChatHitArea["Activated"]:Connect(
      function()
        if ChatVisible then
          HideChat()
        else
        ShowChat()
      end
    end
    )
  end
end
end

if IsMobile then
  local TouchGui = PlayerGui:FindFirstChild("TouchGui")
  if TouchGui then
    local TouchControlFrame = TouchGui:FindFirstChild("TouchControlFrame")
    if TouchControlFrame then
      local JumpButton = TouchControlFrame:FindFirstChild("JumpButton")
      if JumpButton then
        local JumpCorner = JumpButton:FindFirstChildOfClass("UICorner")
        if not JumpCorner then
          JumpCorner = Instance.new("UICorner")
          JumpCorner.Name = "JumpCorner"
          JumpCorner.Parent = JumpButton
        end
        JumpCorner.CornerRadius = UDim.new(1, 0)

        ProtectProperty(JumpButton, "Image", "")

        local JumpBtnIcon = JumpButton:FindFirstChild("JumpBtnIcon")
        if not JumpBtnIcon then
          JumpBtnIcon = Instance.new("ImageLabel")
          JumpBtnIcon.Name = "JumpBtnIcon"
          JumpBtnIcon.Image = GetAsset("CoreGuiPlus/Assets/cgp_jump.png")
          JumpBtnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
          JumpBtnIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
          JumpBtnIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
          JumpBtnIcon.BackgroundTransparency = 1
          JumpBtnIcon.Parent = JumpButton
        end

        Style(JumpButton, "1,0")
      end

      local ThumbstickFrame = TouchControlFrame:FindFirstChild("ThumbstickFrame")
      if ThumbstickFrame then
        local OuterImage = ThumbstickFrame:FindFirstChild("OuterImage")
        if OuterImage then
          OuterImage:Destroy()
        end

        Style(ThumbstickFrame, "1,0")

        local StickImage = ThumbstickFrame:FindFirstChild("StickImage")
        if StickImage then
          local StickImageDefaultPosition = UDim2.fromOffset(21, 21)

          StickImage.AnchorPoint = Vector2.new(0, 0)
          StickImage.Position = StickImageDefaultPosition
          ProtectProperty(StickImage, "Size", UDim2.new(0.4, 0, 0.4, 0))
          ProtectProperty(StickImage, "Image", "")
          ProtectProperty(StickImage, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
          ProtectProperty(StickImage, "BackgroundTransparency", 0)

          local StickCorner = StickImage:FindFirstChildOfClass("UICorner")
          if not StickCorner then
            StickCorner = Instance.new("UICorner")
            StickCorner.Name = "StickCorner"
            StickCorner.Parent = StickImage
          end
          ProtectCorner(StickCorner, UDim.new(1, 0))

          StickImage:GetPropertyChangedSignal("Position"):Connect(
          function()
            if StickImage.Position == UDim2.fromOffset(17, 17) then
              StickImage.Position = StickImageDefaultPosition
            end
          end
          )
        end
      end
    end
  end
end

local FoundTopbarIcon = false
for _, Holder in ipairs(Holders:GetChildren()) do
  for _, Icon in ipairs(Holder:GetChildren()) do
    if Icon:IsA("GuiObject") then
      local IconButton = FindIconButton(Icon)
      if IconButton then
        FoundTopbarIcon = true
        Style(IconButton)
      end
    end
  end
end

local Left = Holders:FindFirstChild("Left")
if Left then
  local BackpackBtn = Left:FindFirstChild("BackpackBtn")
  if BackpackBtn then
    Style(BackpackBtn)
  end
end

if not FoundTopbarIcon then
  Error("No topbar icons were detected")
end

Style(MenuBtn)
Style(EscBtn)

if LucidBtn then
	Style(LucidBtn)
end