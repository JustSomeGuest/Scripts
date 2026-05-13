--[[
════════════〔 Loader 〕════════════
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Init.lua"))()
Init.KilobyteKD()
]]

getgenv().KilobyteKD = getgenv().KilobyteKD or {}

if getgenv().KilobyteKD.isLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kilobyte Keyboard",
        Text = "Kilobyte Keyboard is already running!",
        Duration = 4
    })
    error("Kilobyte Keyboard is already running", 0)
end

getgenv().KilobyteKD.isLoaded = true

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService")
    CoreGui = game:GetService("CoreGui")
}

local Player = Services.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", Services.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local MainStroke = Instance.new("UIStroke", Main)
local Background = Instance.new("Frame", Main)
local Backquote = Instance.new("TextButton", Background)
local BackquoteStroke = Instance.new("UIStroke", Backquote)
local BackquoteCorner = Instance.new("UICorner", Backquote)
local One = Instance.new("TextButton", Background)
local OneStroke = Instance.new("UIStroke", One)
local OneCorner = Instance.new("UICorner", One)
local Two = Instance.new("TextButton", Background)
local TwoStroke = Instance.new("UIStroke", Two)
local TwoCorner = Instance.new("UICorner", Two)
local Three = Instance.new("TextButton", Background)
local ThreeStroke = Instance.new("UIStroke", Three)
local ThreeCorner = Instance.new("UICorner", Three)
local Four = Instance.new("TextButton", Background)
local FourStroke = Instance.new("UIStroke", Four)
local FourCorner = Instance.new("UICorner", Four)
local Five = Instance.new("TextButton", Background)
local FiveStroke = Instance.new("UIStroke", Five)
local FiveCorner = Instance.new("UICorner", Five)
local Zero = Instance.new("TextButton", Background)
local ZeroStroke = Instance.new("UIStroke", Zero)
local ZeroCorner = Instance.new("UICorner", Zero)
local Six = Instance.new("TextButton", Background)
local SixStroke = Instance.new("UIStroke", Six)
local SixCorner = Instance.new("UICorner", Six)
local Seven = Instance.new("TextButton", Background)
local SevenStroke = Instance.new("UIStroke", Seven)
local SevenCorner = Instance.new("UICorner", Seven)
local Eight = Instance.new("TextButton", Background)
local EightStroke = Instance.new("UIStroke", Eight)
local EightCorner = Instance.new("UICorner", Eight)
local Nine = Instance.new("TextButton", Background)
local NineStroke = Instance.new("UIStroke", Nine)
local NineCorner = Instance.new("UICorner", Nine)
local Minus = Instance.new("TextButton", Background)
local MinusStroke = Instance.new("UIStroke", Minus)
local MinusCorner = Instance.new("UICorner", Minus)
local Equals = Instance.new("TextButton", Background)
local EqualsStroke = Instance.new("UIStroke", Equals)
local EqualsCorner = Instance.new("UICorner", Equals)
local Backspace = Instance.new("TextButton", Background)
local BackspaceStroke = Instance.new("UIStroke", Backspace)
local BackspaceCorner = Instance.new("UICorner", Backspace)
local Q = Instance.new("TextButton", Background)
local QStroke = Instance.new("UIStroke", Q)
local QCorner = Instance.new("UICorner", Q)
local W = Instance.new("TextButton", Background)
local WStroke = Instance.new("UIStroke", W)
local WCorner = Instance.new("UICorner", W)
local O = Instance.new("TextButton", Background)
local OStroke = Instance.new("UIStroke", O)
local OCorner = Instance.new("UICorner", O)
local I = Instance.new("TextButton", Background)
local IStroke = Instance.new("UIStroke", I)
local ICorner = Instance.new("UICorner", I)
local U = Instance.new("TextButton", Background)
local UStroke = Instance.new("UIStroke", U)
local UCorner = Instance.new("UICorner", U)
local Y = Instance.new("TextButton", Background)
local YStroke = Instance.new("UIStroke", Y)
local YCorner = Instance.new("UICorner", Y)
local T = Instance.new("TextButton", Background)
local TStroke = Instance.new("UIStroke", T)
local TCorner = Instance.new("UICorner", T)
local R = Instance.new("TextButton", Background)
local RStroke = Instance.new("UIStroke", R)
local RCorner = Instance.new("UICorner", R)
local E = Instance.new("TextButton", Background)
local EStroke = Instance.new("UIStroke", E)
local ECorner = Instance.new("UICorner", E)
local P = Instance.new("TextButton", Background)
local PStroke = Instance.new("UIStroke", P)
local PCorner = Instance.new("UICorner", P)
local Semicolon = Instance.new("TextButton", Background)
local SemicolonStroke = Instance.new("UIStroke", Semicolon)
local SemicolonCorner = Instance.new("UICorner", Semicolon)
local A = Instance.new("TextButton", Background)
local AStroke = Instance.new("UIStroke", A)
local ACorner = Instance.new("UICorner", A)
local S = Instance.new("TextButton", Background)
local SStroke = Instance.new("UIStroke", S)
local SCorner = Instance.new("UICorner", S)
local G = Instance.new("TextButton", Background)
local GStroke = Instance.new("UIStroke", G)
local GCorner = Instance.new("UICorner", G)
local F = Instance.new("TextButton", Background)
local FStroke = Instance.new("UIStroke", F)
local FCorner = Instance.new("UICorner", F)
local H = Instance.new("TextButton", Background)
local HStroke = Instance.new("UIStroke", H)
local HCorner = Instance.new("UICorner", H)
local J = Instance.new("TextButton", Background)
local JStroke = Instance.new("UIStroke", J)
local JCorner = Instance.new("UICorner", J)
local K = Instance.new("TextButton", Background)
local KStroke = Instance.new("UIStroke", K)
local KCorner = Instance.new("UICorner", K)
local L = Instance.new("TextButton", Background)
local LStroke = Instance.new("UIStroke", L)
local LCorner = Instance.new("UICorner", L)
local Z = Instance.new("TextButton", Background)
local ZStroke = Instance.new("UIStroke", Z)
local ZCorner = Instance.new("UICorner", Z)
local X = Instance.new("TextButton", Background)
local XStroke = Instance.new("UIStroke", X)
local XCorner = Instance.new("UICorner", X)
local C = Instance.new("TextButton", Background)
local CStroke = Instance.new("UIStroke", C)
local CCorner = Instance.new("UICorner", C)
local V = Instance.new("TextButton", Background)
local VStroke = Instance.new("UIStroke", V)
local VCorner = Instance.new("UICorner", V)
local B = Instance.new("TextButton", Background)
local BStroke = Instance.new("UIStroke", B)
local BCorner = Instance.new("UICorner", B)
local N = Instance.new("TextButton", Background)
local NStroke = Instance.new("UIStroke", N)
local NCorner = Instance.new("UICorner", N)
local M = Instance.new("TextButton", Background)
local MStroke = Instance.new("UIStroke", M)
local MCorner = Instance.new("UICorner", M)
local Period = Instance.new("TextButton", Background)
local PeriodStroke = Instance.new("UIStroke", Period)
local PeriodCorner = Instance.new("UICorner", Period)
local Comma = Instance.new("TextButton", Background)
local CommaStroke = Instance.new("UIStroke", Comma)
local CommaCorner = Instance.new("UICorner", Comma)
local RightShift = Instance.new("TextButton", Background)
local RightShiftStroke = Instance.new("UIStroke", RightShift)
local RightShiftCorner = Instance.new("UICorner", RightShift)
local Slash = Instance.new("TextButton", Background)
local SlashStroke = Instance.new("UIStroke", Slash)
local SlashCorner = Instance.new("UICorner", Slash)
local Enter = Instance.new("TextButton", Background)
local EnterStroke = Instance.new("UIStroke", Enter)
local EnterCorner = Instance.new("UICorner", Enter)
local Quote = Instance.new("TextButton", Background)
local QuoteStroke = Instance.new("UIStroke", Quote)
local QuoteCorner = Instance.new("UICorner", Quote)
local BackSlash = Instance.new("TextButton", Background)
local BackSlashStroke = Instance.new("UIStroke", BackSlash)
local BackSlashCorner = Instance.new("UICorner", BackSlash)
local RightBracket = Instance.new("TextButton", Background)
local RightBracketStroke = Instance.new("UIStroke", RightBracket)
local RightBracketCorner = Instance.new("UICorner", RightBracket)
local LeftBracket = Instance.new("TextButton", Background)
local LeftBracketStroke = Instance.new("UIStroke", LeftBracket)
local LeftBracketCorner = Instance.new("UICorner", LeftBracket)
local Tab = Instance.new("TextButton", Background)
local TabStroke = Instance.new("UIStroke", Tab)
local TabCorner = Instance.new("UICorner", Tab)
local CapsLock = Instance.new("TextButton", Background)
local CapsLockStroke = Instance.new("UIStroke", CapsLock)
local CapsLockCorner = Instance.new("UICorner", CapsLock)
local LeftShift = Instance.new("TextButton", Background)
local LeftShiftStroke = Instance.new("UIStroke", LeftShift)
local LeftShiftCorner = Instance.new("UICorner", LeftShift)
local LeftControl = Instance.new("TextButton", Background)
local LeftControlStroke = Instance.new("UIStroke", LeftControl)
local LeftControlCorner = Instance.new("UICorner", LeftControl)
local F12 = Instance.new("TextButton", Background)
local F12Stroke = Instance.new("UIStroke", F12)
local F12Corner = Instance.new("UICorner", F12)
local Delete = Instance.new("TextButton", Background)
local DeleteStroke = Instance.new("UIStroke", Delete)
local DeleteCorner = Instance.new("UICorner", Delete)
local LeftAlt = Instance.new("TextButton", Background)
local LeftAltStroke = Instance.new("UIStroke", LeftAlt)
local LeftAltCorner = Instance.new("UICorner", LeftAlt)
local Space = Instance.new("TextButton", Background)
local SpaceStroke = Instance.new("UIStroke", Space)
local SpaceCorner = Instance.new("UICorner", Space)
local RightAlt = Instance.new("TextButton", Background)
local RightAltStroke = Instance.new("UIStroke", RightAlt)
local RightAltCorner = Instance.new("UICorner", RightAlt)
local RightControl = Instance.new("TextButton", Background)
local RightControlStroke = Instance.new("UIStroke", RightControl)
local RightControlCorner = Instance.new("UICorner", RightControl)
local PageUp = Instance.new("TextButton", Background)
local PageUpStroke = Instance.new("UIStroke", PageUp)
local PageUpCorner = Instance.new("UICorner", PageUp)
local PageDown = Instance.new("TextButton", Background)
local PageDownStroke = Instance.new("UIStroke", PageDown)
local PageDownCorner = Instance.new("UICorner", PageDown)
local EndKey = Instance.new("TextButton", Background)
local EndKeyStroke = Instance.new("UIStroke", EndKey)
local EndKeyCorner = Instance.new("UICorner", EndKey)
local Home = Instance.new("TextButton", Background)
local HomeStroke = Instance.new("UIStroke", Home)
local HomeCorner = Instance.new("UICorner", Home)
local Escape = Instance.new("TextButton", Background)
local EscapeStroke = Instance.new("UIStroke", Escape)
local EscapeCorner = Instance.new("UICorner", Escape)
local F1 = Instance.new("TextButton", Background)
local F1Stroke = Instance.new("UIStroke", F1)
local F1Corner = Instance.new("UICorner", F1)
local F2 = Instance.new("TextButton", Background)
local F2Stroke = Instance.new("UIStroke", F2)
local F2Corner = Instance.new("UICorner", F2)
local F3 = Instance.new("TextButton", Background)
local F3Stroke = Instance.new("UIStroke", F3)
local F3Corner = Instance.new("UICorner", F3)
local F4 = Instance.new("TextButton", Background)
local F4Stroke = Instance.new("UIStroke", F4)
local F4Corner = Instance.new("UICorner", F4)
local F5 = Instance.new("TextButton", Background)
local F5Stroke = Instance.new("UIStroke", F5)
local F5Corner = Instance.new("UICorner", F5)
local F6 = Instance.new("TextButton", Background)
local F6Stroke = Instance.new("UIStroke", F6)
local F6Corner = Instance.new("UICorner", F6)
local F7 = Instance.new("TextButton", Background)
local F7Stroke = Instance.new("UIStroke", F7)
local F7Corner = Instance.new("UICorner", F7)
local F8 = Instance.new("TextButton", Background)
local F8Stroke = Instance.new("UIStroke", F8)
local F8Corner = Instance.new("UICorner", F8)
local F9 = Instance.new("TextButton", Background)
local F9Stroke = Instance.new("UIStroke", F9)
local F9Corner = Instance.new("UICorner", F9)
local F10 = Instance.new("TextButton", Background)
local F10Stroke = Instance.new("UIStroke", F10)
local F10Corner = Instance.new("UICorner", F10)
local F11 = Instance.new("TextButton", Background)
local F11Stroke = Instance.new("UIStroke", F11)
local F11Corner = Instance.new("UICorner", F11)
local Pipe = Instance.new("TextButton", Background)
local PipeStroke = Instance.new("UIStroke", Pipe)
local PipeCorner = Instance.new("UICorner", Pipe)
local Tilde = Instance.new("TextButton", Background)
local TildeStroke = Instance.new("UIStroke", Tilde)
local TildeCorner = Instance.new("UICorner", Tilde)
local Exclamation = Instance.new("TextButton", Background)
local ExclamationStroke = Instance.new("UIStroke", Exclamation)
local ExclamationCorner = Instance.new("UICorner", Exclamation)
local At = Instance.new("TextButton", Background)
local AtStroke = Instance.new("UIStroke", At)
local AtCorner = Instance.new("UICorner", At)
local Hash = Instance.new("TextButton", Background)
local HashStroke = Instance.new("UIStroke", Hash)
local HashCorner = Instance.new("UICorner", Hash)
local Dollar = Instance.new("TextButton", Background)
local DollarStroke = Instance.new("UIStroke", Dollar)
local DollarCorner = Instance.new("UICorner", Dollar)
local Percent = Instance.new("TextButton", Background)
local PercentStroke = Instance.new("UIStroke", Percent)
local PercentCorner = Instance.new("UICorner", Percent)
local Caret = Instance.new("TextButton", Background)
local CaretStroke = Instance.new("UIStroke", Caret)
local CaretCorner = Instance.new("UICorner", Caret)
local Ampersand = Instance.new("TextButton", Background)
local AmpersandStroke = Instance.new("UIStroke", Ampersand)
local AmpersandCorner = Instance.new("UICorner", Ampersand)
local Asterisk = Instance.new("TextButton", Background)
local AsteriskStroke = Instance.new("UIStroke", Asterisk)
local AsteriskCorner = Instance.new("UICorner", Asterisk)
local LeftParenthesis = Instance.new("TextButton", Background)
local LeftParenthesisStroke = Instance.new("UIStroke", LeftParenthesis)
local LeftParenthesisCorner = Instance.new("UICorner", LeftParenthesis)
local RightParenthesis = Instance.new("TextButton", Background)
local RightParenthesisStroke = Instance.new("UIStroke", RightParenthesis)
local RightParenthesisCorner = Instance.new("UICorner", RightParenthesis)
local Underscore = Instance.new("TextButton", Background)
local UnderscoreStroke = Instance.new("UIStroke", Underscore)
local UnderscoreCorner = Instance.new("UICorner", Underscore)
local Plus = Instance.new("TextButton", Background)
local PlusStroke = Instance.new("UIStroke", Plus)
local PlusCorner = Instance.new("UICorner", Plus)
local RightCurly = Instance.new("TextButton", Background)
local RightCurlyStroke = Instance.new("UIStroke", RightCurly)
local RightCurlyCorner = Instance.new("UICorner", RightCurly)
local LeftCurly = Instance.new("TextButton", Background)
local LeftCurlyStroke = Instance.new("UIStroke", LeftCurly)
local LeftCurlyCorner = Instance.new("UICorner", LeftCurly)
local QuotedDouble = Instance.new("TextButton", Background)
local QuotedDoubleStroke = Instance.new("UIStroke", QuotedDouble)
local QuotedDoubleCorner = Instance.new("UICorner", QuotedDouble)
local Colon = Instance.new("TextButton", Background)
local ColonStroke = Instance.new("UIStroke", Colon)
local ColonCorner = Instance.new("UICorner", Colon)
local Question = Instance.new("TextButton", Background)
local QuestionStroke = Instance.new("UIStroke", Question)
local QuestionCorner = Instance.new("UICorner", Question)
local GreaterThan = Instance.new("TextButton", Background)
local GreaterThanStroke = Instance.new("UIStroke", GreaterThan)
local GreaterThanCorner = Instance.new("UICorner", GreaterThan)
local LessThan = Instance.new("TextButton", Background)
local LessThanStroke = Instance.new("UIStroke", LessThan)
local LessThanCorner = Instance.new("UICorner", LessThan)
local BackgroundCorner = Instance.new("UICorner", Background)
local D = Instance.new("TextButton", Background)
local DStroke = Instance.new("UIStroke", D)
local DCorner = Instance.new("UICorner", D)
local MainCorner = Instance.new("UICorner", Main)
local ToggleRGB = Instance.new("TextButton", Main)
local ToggleRGBCorner = Instance.new("UICorner", ToggleRGB)
local ToggleRGBStroke = Instance.new("UIStroke", ToggleRGB)
local Tesy = Instance.new("TextButton", Main)
local TesyCorner = Instance.new("UICorner", Tesy)
local TesyStroke = Instance.new("UIStroke", Tesy)
local Close = Instance.new("TextButton", Main)
local Minimize = Instance.new("TextButton", Main)
local Window = Instance.new("TextButton", Main)
local Title = Instance.new("TextLabel", Main)
local Settings = Instance.new("TextButton", Main)
local IsSelectingKey = Instance.new("BoolValue", ScreenGui)
local Key = Instance.new("TextButton", ScreenGui)
local KeyCorner = Instance.new("UICorner", Key)
local KeyStroke = Instance.new("UIStroke", Key)
local KeyClose = Instance.new("TextButton", Key)
local KeyCloseCorner = Instance.new("UICorner", KeyClose)
local CreateKey = Instance.new("Frame", ScreenGui)
local CreateKeyCorner = Instance.new("UICorner", CreateKey)
local CreateKeyStroke = Instance.new("UIStroke", CreateKey)
local CreateTitle = Instance.new("TextLabel", CreateKey)
local CreateButton = Instance.new("TextButton", CreateKey)
local CreateButtonCorner = Instance.new("UICorner", CreateButton)
local CreateButtonStroke = Instance.new("UIStroke", CreateButton)
local Title2 = Instance.new("TextLabel", CreateKey)
local TextBox = Instance.new("TextBox", CreateKey)
local TextBoxStroke = Instance.new("UIStroke", TextBox)
local TextBoxCorner = Instance.new("UICorner", TextBox)
local CloseButton = Instance.new("TextButton", CreateKey)
local CloseButtonCorner = Instance.new("UICorner", CloseButton)
local CloseButtonStroke = Instance.new("UIStroke", CloseButton)
local CreateKeyScript = Instance.new("LocalScript", CreateKey)
local Keys = Instance.new("Folder", ScreenGui)
local ToggleShift = Instance.new("BoolValue", ScreenGui)
local Shifting = Instance.new("BoolValue", ScreenGui)
local FloatingIcon = Instance.new("ImageButton", ScreenGui)
local FloatingIconCorner = Instance.new("UICorner", FloatingIcon)
local FloatingIconStroke = Instance.new("UIStroke", FloatingIcon)

ScreenGui.Name = "KilobyteV3"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Main.Active = true
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Size = UDim2.new(0, 478, 0, 236)
Main.Position = UDim2.new(0.5, -239, 0.5, -118)
Main.Name = "Main"

MainStroke.Color = Color3.fromRGB(158, 0, 255)

Background.Active = true
Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Background.BackgroundTransparency = 1
Background.Size = UDim2.new(0.9978905916213989, 0, 0.8684942126274109, 0)
Background.Position = UDim2.new(0, 0, 0.12748458981513977, 0)
Background.Name = "Background"

Backquote.TextWrapped = true
Backquote.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Backquote.TextSize = 21
Backquote.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Backquote.TextColor3 = Color3.fromRGB(255, 255, 255)
Backquote.Size = UDim2.new(0, 25, 0, 25)
Backquote.Name = "-Backquote"
Backquote.Text = "`"
Backquote.Position = UDim2.new(0, 7, 0, 31)

BackquoteStroke.Color = Color3.fromRGB(255, 255, 255)
BackquoteStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

BackquoteCorner.CornerRadius = UDim.new(0, 4)

One.TextWrapped = true
One.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
One.TextSize = 21
One.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
One.TextColor3 = Color3.fromRGB(255, 255, 255)
One.Size = UDim2.new(0, 25, 0, 25)
One.Name = "-One"
One.Text = "1"
One.Position = UDim2.new(0, 39, 0, 31)

OneStroke.Color = Color3.fromRGB(255, 255, 255)
OneStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

OneCorner.CornerRadius = UDim.new(0, 4)

Two.TextWrapped = true
Two.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Two.TextSize = 21
Two.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Two.TextColor3 = Color3.fromRGB(255, 255, 255)
Two.Size = UDim2.new(0, 25, 0, 25)
Two.Name = "-Two"
Two.Text = "2"
Two.Position = UDim2.new(0, 71, 0, 31)

TwoStroke.Color = Color3.fromRGB(255, 255, 255)
TwoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TwoCorner.CornerRadius = UDim.new(0, 4)

Three.TextWrapped = true
Three.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Three.TextSize = 21
Three.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Three.TextColor3 = Color3.fromRGB(255, 255, 255)
Three.Size = UDim2.new(0, 25, 0, 25)
Three.Name = "-Three"
Three.Text = "3"
Three.Position = UDim2.new(0, 104, 0, 31)

ThreeStroke.Color = Color3.fromRGB(255, 255, 255)
ThreeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ThreeCorner.CornerRadius = UDim.new(0, 4)

Four.TextWrapped = true
Four.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Four.TextSize = 21
Four.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Four.TextColor3 = Color3.fromRGB(255, 255, 255)
Four.Size = UDim2.new(0, 25, 0, 25)
Four.Name = "-Four"
Four.Text = "4"
Four.Position = UDim2.new(0, 135, 0, 31)

FourStroke.Color = Color3.fromRGB(255, 255, 255)
FourStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

FourCorner.CornerRadius = UDim.new(0, 4)

Five.TextWrapped = true
Five.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Five.TextSize = 21
Five.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Five.TextColor3 = Color3.fromRGB(255, 255, 255)
Five.Size = UDim2.new(0, 25, 0, 25)
Five.Name = "-Five"
Five.Text = "5"
Five.Position = UDim2.new(0, 167, 0, 31)

FiveStroke.Color = Color3.fromRGB(255, 255, 255)
FiveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

FiveCorner.CornerRadius = UDim.new(0, 4)

Zero.TextWrapped = true
Zero.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Zero.TextSize = 21
Zero.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Zero.TextColor3 = Color3.fromRGB(255, 255, 255)
Zero.Size = UDim2.new(0, 24, 0, 25)
Zero.Name = "-Zero"
Zero.Text = "0"
Zero.Position = UDim2.new(0, 327, 0, 31)

ZeroStroke.Color = Color3.fromRGB(255, 255, 255)
ZeroStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ZeroCorner.CornerRadius = UDim.new(0, 4)

Six.TextWrapped = true
Six.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Six.TextSize = 21
Six.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Six.TextColor3 = Color3.fromRGB(255, 255, 255)
Six.Size = UDim2.new(0, 25, 0, 25)
Six.Name = "-Six"
Six.Text = "6"
Six.Position = UDim2.new(0, 199, 0, 31)

SixStroke.Color = Color3.fromRGB(255, 255, 255)
SixStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SixCorner.CornerRadius = UDim.new(0, 4)

Seven.TextWrapped = true
Seven.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Seven.TextSize = 21
Seven.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Seven.TextColor3 = Color3.fromRGB(255, 255, 255)
Seven.Size = UDim2.new(0, 25, 0, 25)
Seven.Name = "-Seven"
Seven.Text = "7"
Seven.Position = UDim2.new(0, 231, 0, 31)

SevenStroke.Color = Color3.fromRGB(255, 255, 255)
SevenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SevenCorner.CornerRadius = UDim.new(0, 4)

Eight.TextWrapped = true
Eight.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Eight.TextSize = 21
Eight.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Eight.TextColor3 = Color3.fromRGB(255, 255, 255)
Eight.Size = UDim2.new(0, 24, 0, 25)
Eight.Name = "-Eight"
Eight.Text = "8"
Eight.Position = UDim2.new(0, 264, 0, 31)

EightStroke.Color = Color3.fromRGB(255, 255, 255)
EightStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

EightCorner.CornerRadius = UDim.new(0, 4)

Nine.TextWrapped = true
Nine.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Nine.TextSize = 21
Nine.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Nine.TextColor3 = Color3.fromRGB(255, 255, 255)
Nine.Size = UDim2.new(0, 24, 0, 25)
Nine.Name = "-Nine"
Nine.Text = "9"
Nine.Position = UDim2.new(0, 295, 0, 31)

NineStroke.Color = Color3.fromRGB(255, 255, 255)
NineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

NineCorner.CornerRadius = UDim.new(0, 4)

Minus.TextWrapped = true
Minus.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Minus.TextSize = 21
Minus.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Minus.TextColor3 = Color3.fromRGB(255, 255, 255)
Minus.Size = UDim2.new(0, 24, 0, 25)
Minus.Name = "-Minus"
Minus.Text = "-"
Minus.Position = UDim2.new(0, 358, 0, 31)

MinusStroke.Color = Color3.fromRGB(255, 255, 255)
MinusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MinusCorner.CornerRadius = UDim.new(0, 4)

Equals.TextWrapped = true
Equals.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Equals.TextSize = 21
Equals.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Equals.TextColor3 = Color3.fromRGB(255, 255, 255)
Equals.Size = UDim2.new(0, 24, 0, 25)
Equals.Name = "-Equals"
Equals.Text = "="
Equals.Position = UDim2.new(0, 389, 0, 31)

EqualsStroke.Color = Color3.fromRGB(255, 255, 255)
EqualsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

EqualsCorner.CornerRadius = UDim.new(0, 4)

Backspace.TextWrapped = true
Backspace.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Backspace.TextSize = 11
Backspace.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Backspace.TextColor3 = Color3.fromRGB(255, 255, 255)
Backspace.Size = UDim2.new(0, 47, 0, 25)
Backspace.Name = "Backspace"
Backspace.Text = "Backspace"
Backspace.Position = UDim2.new(0, 422, 0, 31)

BackspaceStroke.Color = Color3.fromRGB(255, 255, 255)
BackspaceStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

BackspaceCorner.CornerRadius = UDim.new(0, 4)

Q.TextWrapped = true
Q.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Q.TextSize = 21
Q.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Q.TextColor3 = Color3.fromRGB(255, 255, 255)
Q.Size = UDim2.new(0, 25, 0, 25)
Q.Name = "Q"
Q.Text = "Q"
Q.Position = UDim2.new(0, 54, 0, 63)

QStroke.Color = Color3.fromRGB(255, 255, 255)
QStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

QCorner.CornerRadius = UDim.new(0, 4)

W.TextWrapped = true
W.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
W.TextSize = 21
W.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
W.TextColor3 = Color3.fromRGB(255, 255, 255)
W.Size = UDim2.new(0, 25, 0, 25)
W.Name = "W"
W.Text = "W"
W.Position = UDim2.new(0, 87, 0, 63)

WStroke.Color = Color3.fromRGB(255, 255, 255)
WStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

WCorner.CornerRadius = UDim.new(0, 4)

O.TextWrapped = true
O.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
O.TextSize = 21
O.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
O.TextColor3 = Color3.fromRGB(255, 255, 255)
O.Size = UDim2.new(0, 25, 0, 25)
O.Name = "O"
O.Text = "O"
O.Position = UDim2.new(0, 312, 0, 63)

OStroke.Color = Color3.fromRGB(255, 255, 255)
OStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

OCorner.CornerRadius = UDim.new(0, 4)

I.TextWrapped = true
I.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
I.TextSize = 21
I.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
I.TextColor3 = Color3.fromRGB(255, 255, 255)
I.Size = UDim2.new(0, 25, 0, 25)
I.Name = "I"
I.Text = "I"
I.Position = UDim2.new(0, 280, 0, 63)

IStroke.Color = Color3.fromRGB(255, 255, 255)
IStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ICorner.CornerRadius = UDim.new(0, 4)

U.TextWrapped = true
U.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
U.TextSize = 21
U.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
U.TextColor3 = Color3.fromRGB(255, 255, 255)
U.Size = UDim2.new(0, 25, 0, 25)
U.Name = "U"
U.Text = "U"
U.Position = UDim2.new(0, 249, 0, 63)

UStroke.Color = Color3.fromRGB(255, 255, 255)
UStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UCorner.CornerRadius = UDim.new(0, 4)

Y.TextWrapped = true
Y.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Y.TextSize = 21
Y.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Y.TextColor3 = Color3.fromRGB(255, 255, 255)
Y.Size = UDim2.new(0, 25, 0, 25)
Y.Name = "Y"
Y.Text = "Y"
Y.Position = UDim2.new(0, 216, 0, 63)

YStroke.Color = Color3.fromRGB(255, 255, 255)
YStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

YCorner.CornerRadius = UDim.new(0, 4)

T.TextWrapped = true
T.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
T.TextSize = 21
T.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
T.TextColor3 = Color3.fromRGB(255, 255, 255)
T.Size = UDim2.new(0, 25, 0, 25)
T.Name = "T"
T.Text = "T"
T.Position = UDim2.new(0, 184, 0, 63)

TStroke.Color = Color3.fromRGB(255, 255, 255)
TStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TCorner.CornerRadius = UDim.new(0, 4)

R.TextWrapped = true
R.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
R.TextSize = 21
R.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
R.TextColor3 = Color3.fromRGB(255, 255, 255)
R.Size = UDim2.new(0, 25, 0, 25)
R.Name = "R"
R.Text = "R"
R.Position = UDim2.new(0, 152, 0, 63)

RStroke.Color = Color3.fromRGB(255, 255, 255)
RStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RCorner.CornerRadius = UDim.new(0, 4)

E.TextWrapped = true
E.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
E.TextSize = 21
E.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
E.TextColor3 = Color3.fromRGB(255, 255, 255)
E.Size = UDim2.new(0, 25, 0, 25)
E.Name = "E"
E.Text = "E"
E.Position = UDim2.new(0, 120, 0, 63)

EStroke.Color = Color3.fromRGB(255, 255, 255)
EStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ECorner.CornerRadius = UDim.new(0, 4)

P.TextWrapped = true
P.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
P.TextSize = 21
P.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
P.TextColor3 = Color3.fromRGB(255, 255, 255)
P.Size = UDim2.new(0, 25, 0, 25)
P.Name = "P"
P.Text = "P"
P.Position = UDim2.new(0, 344, 0, 63)

PStroke.Color = Color3.fromRGB(255, 255, 255)
PStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PCorner.CornerRadius = UDim.new(0, 4)

Semicolon.TextWrapped = true
Semicolon.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Semicolon.TextSize = 21
Semicolon.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Semicolon.TextColor3 = Color3.fromRGB(255, 255, 255)
Semicolon.Size = UDim2.new(0, 25, 0, 25)
Semicolon.Name = "-Semicolon"
Semicolon.Text = ";"
Semicolon.Position = UDim2.new(0, 354, 0, 95)

SemicolonStroke.Color = Color3.fromRGB(255, 255, 255)
SemicolonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SemicolonCorner.CornerRadius = UDim.new(0, 4)

A.TextWrapped = true
A.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
A.TextSize = 21
A.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
A.TextColor3 = Color3.fromRGB(255, 255, 255)
A.Size = UDim2.new(0, 25, 0, 25)
A.Name = "A"
A.Text = "A"
A.Position = UDim2.new(0, 64, 0, 95)

AStroke.Color = Color3.fromRGB(255, 255, 255)
AStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ACorner.CornerRadius = UDim.new(0, 4)

S.TextWrapped = true
S.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
S.TextSize = 21
S.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
S.TextColor3 = Color3.fromRGB(255, 255, 255)
S.Size = UDim2.new(0, 25, 0, 25)
S.Name = "S"
S.Text = "S"
S.Position = UDim2.new(0, 97, 0, 95)

SStroke.Color = Color3.fromRGB(255, 255, 255)
SStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SCorner.CornerRadius = UDim.new(0, 4)

G.TextWrapped = true
G.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
G.TextSize = 21
G.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G.TextColor3 = Color3.fromRGB(255, 255, 255)
G.Size = UDim2.new(0, 25, 0, 25)
G.Name = "G"
G.Text = "G"
G.Position = UDim2.new(0, 194, 0, 95)

GStroke.Color = Color3.fromRGB(255, 255, 255)
GStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

GCorner.CornerRadius = UDim.new(0, 4)

F.TextWrapped = true
F.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F.TextSize = 21
F.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F.TextColor3 = Color3.fromRGB(255, 255, 255)
F.Size = UDim2.new(0, 25, 0, 25)
F.Name = "F"
F.Text = "F"
F.Position = UDim2.new(0, 162, 0, 95)

FStroke.Color = Color3.fromRGB(255, 255, 255)
FStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

FCorner.CornerRadius = UDim.new(0, 4)

H.TextWrapped = true
H.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
H.TextSize = 21
H.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
H.TextColor3 = Color3.fromRGB(255, 255, 255)
H.Size = UDim2.new(0, 25, 0, 25)
H.Name = "H"
H.Text = "H"
H.Position = UDim2.new(0, 226, 0, 95)

HStroke.Color = Color3.fromRGB(255, 255, 255)
HStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

HCorner.CornerRadius = UDim.new(0, 4)

J.TextWrapped = true
J.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
J.TextSize = 21
J.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
J.TextColor3 = Color3.fromRGB(255, 255, 255)
J.Size = UDim2.new(0, 25, 0, 25)
J.Name = "J"
J.Text = "J"
J.Position = UDim2.new(0, 258, 0, 95)

JStroke.Color = Color3.fromRGB(255, 255, 255)
JStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

JCorner.CornerRadius = UDim.new(0, 4)

K.TextWrapped = true
K.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
K.TextSize = 21
K.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
K.TextColor3 = Color3.fromRGB(255, 255, 255)
K.Size = UDim2.new(0, 25, 0, 25)
K.Name = "K"
K.Text = "K"
K.Position = UDim2.new(0, 290, 0, 95)

KStroke.Color = Color3.fromRGB(255, 255, 255)
KStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

KCorner.CornerRadius = UDim.new(0, 4)

L.TextWrapped = true
L.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
L.TextSize = 21
L.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
L.TextColor3 = Color3.fromRGB(255, 255, 255)
L.Size = UDim2.new(0, 25, 0, 25)
L.Name = "L"
L.Text = "L"
L.Position = UDim2.new(0, 322, 0, 95)

LStroke.Color = Color3.fromRGB(255, 255, 255)
LStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LCorner.CornerRadius = UDim.new(0, 4)

Z.TextWrapped = true
Z.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Z.TextSize = 21
Z.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Z.TextColor3 = Color3.fromRGB(255, 255, 255)
Z.Size = UDim2.new(0, 25, 0, 25)
Z.Name = "Z"
Z.Text = "Z"
Z.Position = UDim2.new(0, 80, 0, 127)

ZStroke.Color = Color3.fromRGB(255, 255, 255)
ZStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ZCorner.CornerRadius = UDim.new(0, 4)

X.TextWrapped = true
X.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
X.TextSize = 21
X.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
X.TextColor3 = Color3.fromRGB(255, 255, 255)
X.Size = UDim2.new(0, 25, 0, 25)
X.Name = "X"
X.Text = "X"
X.Position = UDim2.new(0, 112, 0, 127)

XStroke.Color = Color3.fromRGB(255, 255, 255)
XStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

XCorner.CornerRadius = UDim.new(0, 4)

C.TextWrapped = true
C.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
C.TextSize = 21
C.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
C.TextColor3 = Color3.fromRGB(255, 255, 255)
C.Size = UDim2.new(0, 25, 0, 25)
C.Name = "C"
C.Text = "C"
C.Position = UDim2.new(0, 145, 0, 127)

CStroke.Color = Color3.fromRGB(255, 255, 255)
CStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CCorner.CornerRadius = UDim.new(0, 4)

V.TextWrapped = true
V.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
V.TextSize = 21
V.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
V.TextColor3 = Color3.fromRGB(255, 255, 255)
V.Size = UDim2.new(0, 25, 0, 25)
V.Name = "V"
V.Text = "V"
V.Position = UDim2.new(0, 177, 0, 127)

VStroke.Color = Color3.fromRGB(255, 255, 255)
VStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

VCorner.CornerRadius = UDim.new(0, 4)

B.TextWrapped = true
B.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
B.TextSize = 21
B.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
B.TextColor3 = Color3.fromRGB(255, 255, 255)
B.Size = UDim2.new(0, 25, 0, 25)
B.Name = "B"
B.Text = "B"
B.Position = UDim2.new(0, 209, 0, 127)

BStroke.Color = Color3.fromRGB(255, 255, 255)
BStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

BCorner.CornerRadius = UDim.new(0, 4)

N.TextWrapped = true
N.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
N.TextSize = 21
N.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
N.TextColor3 = Color3.fromRGB(255, 255, 255)
N.Size = UDim2.new(0, 25, 0, 25)
N.Name = "N"
N.Text = "N"
N.Position = UDim2.new(0, 241, 0, 127)

NStroke.Color = Color3.fromRGB(255, 255, 255)
NStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

NCorner.CornerRadius = UDim.new(0, 4)

M.TextWrapped = true
M.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
M.TextSize = 21
M.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
M.TextColor3 = Color3.fromRGB(255, 255, 255)
M.Size = UDim2.new(0, 25, 0, 25)
M.Name = "M"
M.Text = "M"
M.Position = UDim2.new(0, 273, 0, 127)

MStroke.Color = Color3.fromRGB(255, 255, 255)
MStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MCorner.CornerRadius = UDim.new(0, 4)

Period.TextWrapped = true
Period.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Period.TextSize = 21
Period.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Period.TextColor3 = Color3.fromRGB(255, 255, 255)
Period.Size = UDim2.new(0, 25, 0, 25)
Period.Name = "-Period"
Period.Text = "."
Period.Position = UDim2.new(0, 338, 0, 127)

PeriodStroke.Color = Color3.fromRGB(255, 255, 255)
PeriodStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PeriodCorner.CornerRadius = UDim.new(0, 4)

Comma.TextWrapped = true
Comma.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Comma.TextSize = 21
Comma.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Comma.TextColor3 = Color3.fromRGB(255, 255, 255)
Comma.Size = UDim2.new(0, 25, 0, 25)
Comma.Name = "-Comma"
Comma.Text = ","
Comma.Position = UDim2.new(0, 305, 0, 127)

CommaStroke.Color = Color3.fromRGB(255, 255, 255)
CommaStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CommaCorner.CornerRadius = UDim.new(0, 4)

RightShift.TextWrapped = true
RightShift.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightShift.TextSize = 21
RightShift.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightShift.TextColor3 = Color3.fromRGB(255, 255, 255)
RightShift.Size = UDim2.new(0, 64, 0, 25)
RightShift.Name = "RightShift"
RightShift.Text = "Shift"
RightShift.Position = UDim2.new(0, 405, 0, 127)

RightShiftStroke.Color = Color3.fromRGB(255, 255, 255)
RightShiftStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightShiftCorner.CornerRadius = UDim.new(0, 4)

Slash.TextWrapped = true
Slash.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Slash.TextSize = 21
Slash.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Slash.TextColor3 = Color3.fromRGB(255, 255, 255)
Slash.Size = UDim2.new(0, 25, 0, 25)
Slash.Name = "-Slash"
Slash.Text = "/"
Slash.Position = UDim2.new(0, 372, 0, 127)

SlashStroke.Color = Color3.fromRGB(255, 255, 255)
SlashStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SlashCorner.CornerRadius = UDim.new(0, 4)

Enter.TextWrapped = true
Enter.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Enter.TextSize = 21
Enter.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Enter.TextColor3 = Color3.fromRGB(255, 255, 255)
Enter.Size = UDim2.new(0, 51, 0, 25)
Enter.Name = "Enter"
Enter.Text = "Enter"
Enter.Position = UDim2.new(0, 418, 0, 95)

EnterStroke.Color = Color3.fromRGB(255, 255, 255)
EnterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

EnterCorner.CornerRadius = UDim.new(0, 4)

Quote.TextWrapped = true
Quote.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Quote.TextSize = 21
Quote.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Quote.TextColor3 = Color3.fromRGB(255, 255, 255)
Quote.Size = UDim2.new(0, 25, 0, 25)
Quote.Name = "-Quote"
Quote.Text = "'"
Quote.Position = UDim2.new(0, 386, 0, 95)

QuoteStroke.Color = Color3.fromRGB(255, 255, 255)
QuoteStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

QuoteCorner.CornerRadius = UDim.new(0, 4)

BackSlash.TextWrapped = true
BackSlash.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
BackSlash.TextSize = 21
BackSlash.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
BackSlash.TextColor3 = Color3.fromRGB(255, 255, 255)
BackSlash.Size = UDim2.new(0, 25, 0, 25)
BackSlash.Name = "-BackSlash"
BackSlash.Text = "\\"
BackSlash.Position = UDim2.new(0, 442, 0, 63)

BackSlashStroke.Color = Color3.fromRGB(255, 255, 255)
BackSlashStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

BackSlashCorner.CornerRadius = UDim.new(0, 4)

RightBracket.TextWrapped = true
RightBracket.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightBracket.TextSize = 21
RightBracket.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightBracket.TextColor3 = Color3.fromRGB(255, 255, 255)
RightBracket.Size = UDim2.new(0, 25, 0, 25)
RightBracket.Name = "-RightBracket"
RightBracket.Text = "]"
RightBracket.Position = UDim2.new(0, 410, 0, 63)

RightBracketStroke.Color = Color3.fromRGB(255, 255, 255)
RightBracketStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightBracketCorner.CornerRadius = UDim.new(0, 4)

LeftBracket.TextWrapped = true
LeftBracket.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftBracket.TextSize = 21
LeftBracket.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftBracket.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftBracket.Size = UDim2.new(0, 25, 0, 25)
LeftBracket.Name = "-LeftBracket"
LeftBracket.Text = "["
LeftBracket.Position = UDim2.new(0, 378, 0, 63)

LeftBracketStroke.Color = Color3.fromRGB(255, 255, 255)
LeftBracketStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftBracketCorner.CornerRadius = UDim.new(0, 4)

Tab.TextWrapped = true
Tab.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Tab.TextSize = 21
Tab.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Size = UDim2.new(0, 40, 0, 25)
Tab.Name = "Tab"
Tab.Text = "Tab"
Tab.Position = UDim2.new(0, 7, 0, 63)

TabStroke.Color = Color3.fromRGB(255, 255, 255)
TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TabCorner.CornerRadius = UDim.new(0, 4)

CapsLock.TextWrapped = true
CapsLock.TextScaled = true
CapsLock.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
CapsLock.TextSize = 1
CapsLock.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CapsLock.TextColor3 = Color3.fromRGB(255, 255, 255)
CapsLock.Size = UDim2.new(0, 50, 0, 25)
CapsLock.Name = "CapsLock"
CapsLock.Text = "Caps Lock"
CapsLock.Position = UDim2.new(0, 7, 0, 95)

CapsLockStroke.Color = Color3.fromRGB(255, 255, 255)
CapsLockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CapsLockCorner.CornerRadius = UDim.new(0, 4)

LeftShift.TextWrapped = true
LeftShift.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftShift.TextSize = 21
LeftShift.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftShift.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftShift.Size = UDim2.new(0, 65, 0, 25)
LeftShift.Name = "LeftShift"
LeftShift.Text = "Shift"
LeftShift.Position = UDim2.new(0, 7, 0, 127)

LeftShiftStroke.Color = Color3.fromRGB(255, 255, 255)
LeftShiftStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftShiftCorner.CornerRadius = UDim.new(0, 4)

LeftControl.TextWrapped = true
LeftControl.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftControl.TextSize = 23
LeftControl.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftControl.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftControl.Size = UDim2.new(0, 57, 0, 25)
LeftControl.Name = "LeftControl"
LeftControl.Text = "Ctrl"
LeftControl.Position = UDim2.new(0, 7, 0, 160)

LeftControlStroke.Color = Color3.fromRGB(255, 255, 255)
LeftControlStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftControlCorner.CornerRadius = UDim.new(0, 4)

F12.TextWrapped = true
F12.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F12.TextSize = 15
F12.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F12.TextColor3 = Color3.fromRGB(255, 255, 255)
F12.Size = UDim2.new(0, 24, 0, 25)
F12.Name = "F12"
F12.Text = "F12"
F12.Position = UDim2.new(0, 389, 0, -1)

F12Stroke.Color = Color3.fromRGB(255, 255, 255)
F12Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F12Corner.CornerRadius = UDim.new(0, 4)

Delete.TextWrapped = true
Delete.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Delete.TextSize = 14
Delete.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Delete.TextColor3 = Color3.fromRGB(255, 255, 255)
Delete.Size = UDim2.new(0, 44, 0, 25)
Delete.Name = "Delete"
Delete.Text = "Del"
Delete.Position = UDim2.new(0, 423, 0, -1)

DeleteStroke.Color = Color3.fromRGB(255, 255, 255)
DeleteStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

DeleteCorner.CornerRadius = UDim.new(0, 4)

LeftAlt.TextWrapped = true
LeftAlt.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftAlt.TextSize = 21
LeftAlt.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftAlt.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftAlt.Size = UDim2.new(0, 56, 0, 25)
LeftAlt.Name = "LeftAlt"
LeftAlt.Text = "Alt"
LeftAlt.Position = UDim2.new(0, 73, 0, 160)

LeftAltStroke.Color = Color3.fromRGB(255, 255, 255)
LeftAltStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftAltCorner.CornerRadius = UDim.new(0, 4)

Space.TextWrapped = true
Space.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Space.TextSize = 21
Space.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Space.TextColor3 = Color3.fromRGB(255, 255, 255)
Space.Size = UDim2.new(0, 159, 0, 25)
Space.Name = "Space"
Space.Text = ""
Space.Position = UDim2.new(0, 137, 0, 160)

SpaceStroke.Color = Color3.fromRGB(255, 255, 255)
SpaceStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SpaceCorner.CornerRadius = UDim.new(0, 4)

RightAlt.TextWrapped = true
RightAlt.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightAlt.TextSize = 21
RightAlt.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightAlt.TextColor3 = Color3.fromRGB(255, 255, 255)
RightAlt.Size = UDim2.new(0, 25, 0, 25)
RightAlt.Name = "RightAlt"
RightAlt.Text = "Alt"
RightAlt.Position = UDim2.new(0, 305, 0, 160)

RightAltStroke.Color = Color3.fromRGB(255, 255, 255)
RightAltStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightAltCorner.CornerRadius = UDim.new(0, 4)

RightControl.TextWrapped = true
RightControl.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightControl.TextSize = 12
RightControl.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightControl.TextColor3 = Color3.fromRGB(255, 255, 255)
RightControl.Size = UDim2.new(0, 25, 0, 25)
RightControl.Name = "RightControl"
RightControl.Text = "Ctrl"
RightControl.Position = UDim2.new(0, 337, 0, 160)

RightControlStroke.Color = Color3.fromRGB(255, 255, 255)
RightControlStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightControlCorner.CornerRadius = UDim.new(0, 4)

PageUp.TextWrapped = true
PageUp.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
PageUp.TextSize = 12
PageUp.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PageUp.TextColor3 = Color3.fromRGB(255, 255, 255)
PageUp.Size = UDim2.new(0, 33, 0, 11)
PageUp.Name = "PageUp"
PageUp.Text = "Up"
PageUp.Position = UDim2.new(0, 400, 0, 160)

PageUpStroke.Color = Color3.fromRGB(255, 255, 255)
PageUpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PageUpCorner.CornerRadius = UDim.new(0, 4)

PageDown.TextWrapped = true
PageDown.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
PageDown.TextSize = 12
PageDown.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PageDown.TextColor3 = Color3.fromRGB(255, 255, 255)
PageDown.Size = UDim2.new(0, 33, 0, 10)
PageDown.Name = "PageDown"
PageDown.Text = "Down"
PageDown.Position = UDim2.new(0, 400, 0, 174)

PageDownStroke.Color = Color3.fromRGB(255, 255, 255)
PageDownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PageDownCorner.CornerRadius = UDim.new(0, 4)

EndKey.TextWrapped = true
EndKey.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
EndKey.TextSize = 12
EndKey.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
EndKey.TextColor3 = Color3.fromRGB(255, 255, 255)
EndKey.Size = UDim2.new(0, 33, 0, 10)
EndKey.Name = "End"
EndKey.Text = ">"
EndKey.Position = UDim2.new(0, 436, 0, 174)

EndKeyStroke.Color = Color3.fromRGB(255, 255, 255)
EndKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

EndKeyCorner.CornerRadius = UDim.new(0, 4)

Home.TextWrapped = true
Home.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Home.TextSize = 12
Home.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Home.TextColor3 = Color3.fromRGB(255, 255, 255)
Home.Size = UDim2.new(0, 30, 0, 10)
Home.Name = "Home"
Home.Text = "<"
Home.Position = UDim2.new(0, 366, 0, 174)

HomeStroke.Color = Color3.fromRGB(255, 255, 255)
HomeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

HomeCorner.CornerRadius = UDim.new(0, 4)

Escape.TextWrapped = true
Escape.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Escape.TextSize = 21
Escape.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Escape.TextColor3 = Color3.fromRGB(255, 255, 255)
Escape.Size = UDim2.new(0, 25, 0, 25)
Escape.Name = "Escape"
Escape.Text = "Esc"
Escape.Position = UDim2.new(0, 7, 0, -1)

EscapeStroke.Color = Color3.fromRGB(255, 255, 255)
EscapeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

EscapeCorner.CornerRadius = UDim.new(0, 4)

F1.TextWrapped = true
F1.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F1.TextSize = 21
F1.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F1.TextColor3 = Color3.fromRGB(255, 255, 255)
F1.Size = UDim2.new(0, 25, 0, 25)
F1.Name = "F1"
F1.Text = "F1"
F1.Position = UDim2.new(0, 39, 0, -1)

F1Stroke.Color = Color3.fromRGB(255, 255, 255)
F1Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F1Corner.CornerRadius = UDim.new(0, 4)

F2.TextWrapped = true
F2.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F2.TextSize = 21
F2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F2.TextColor3 = Color3.fromRGB(255, 255, 255)
F2.Size = UDim2.new(0, 25, 0, 25)
F2.Name = "F2"
F2.Text = "F2"
F2.Position = UDim2.new(0, 71, 0, -1)

F2Stroke.Color = Color3.fromRGB(255, 255, 255)
F2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F2Corner.CornerRadius = UDim.new(0, 4)

F3.TextWrapped = true
F3.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F3.TextSize = 21
F3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F3.TextColor3 = Color3.fromRGB(255, 255, 255)
F3.Size = UDim2.new(0, 25, 0, 25)
F3.Name = "F3"
F3.Text = "F3"
F3.Position = UDim2.new(0, 104, 0, -1)

F3Stroke.Color = Color3.fromRGB(255, 255, 255)
F3Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F3Corner.CornerRadius = UDim.new(0, 4)

F4.TextWrapped = true
F4.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F4.TextSize = 21
F4.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F4.TextColor3 = Color3.fromRGB(255, 255, 255)
F4.Size = UDim2.new(0, 25, 0, 25)
F4.Name = "F4"
F4.Text = "F4"
F4.Position = UDim2.new(0, 135, 0, -1)

F4Stroke.Color = Color3.fromRGB(255, 255, 255)
F4Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F4Corner.CornerRadius = UDim.new(0, 4)

F5.TextWrapped = true
F5.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F5.TextSize = 21
F5.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F5.TextColor3 = Color3.fromRGB(255, 255, 255)
F5.Size = UDim2.new(0, 25, 0, 25)
F5.Name = "F5"
F5.Text = "F5"
F5.Position = UDim2.new(0, 167, 0, -1)

F5Stroke.Color = Color3.fromRGB(255, 255, 255)
F5Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F5Corner.CornerRadius = UDim.new(0, 4)

F6.TextWrapped = true
F6.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F6.TextSize = 21
F6.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F6.TextColor3 = Color3.fromRGB(255, 255, 255)
F6.Size = UDim2.new(0, 25, 0, 25)
F6.Name = "F6"
F6.Text = "F6"
F6.Position = UDim2.new(0, 199, 0, -1)

F6Stroke.Color = Color3.fromRGB(255, 255, 255)
F6Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F6Corner.CornerRadius = UDim.new(0, 4)

F7.TextWrapped = true
F7.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F7.TextSize = 21
F7.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F7.TextColor3 = Color3.fromRGB(255, 255, 255)
F7.Size = UDim2.new(0, 25, 0, 25)
F7.Name = "F7"
F7.Text = "F7"
F7.Position = UDim2.new(0, 231, 0, -1)

F7Stroke.Color = Color3.fromRGB(255, 255, 255)
F7Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F7Corner.CornerRadius = UDim.new(0, 4)

F8.TextWrapped = true
F8.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F8.TextSize = 21
F8.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F8.TextColor3 = Color3.fromRGB(255, 255, 255)
F8.Size = UDim2.new(0, 24, 0, 25)
F8.Name = "F8"
F8.Text = "F8"
F8.Position = UDim2.new(0, 264, 0, -1)

F8Stroke.Color = Color3.fromRGB(255, 255, 255)
F8Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F8Corner.CornerRadius = UDim.new(0, 4)

F9.TextWrapped = true
F9.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F9.TextSize = 21
F9.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F9.TextColor3 = Color3.fromRGB(255, 255, 255)
F9.Size = UDim2.new(0, 25, 0, 25)
F9.Name = "F9"
F9.Text = "F9"
F9.Position = UDim2.new(0, 295, 0, -1)

F9Stroke.Color = Color3.fromRGB(255, 255, 255)
F9Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F9Corner.CornerRadius = UDim.new(0, 4)

F10.TextWrapped = true
F10.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F10.TextSize = 15
F10.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F10.TextColor3 = Color3.fromRGB(255, 255, 255)
F10.Size = UDim2.new(0, 24, 0, 25)
F10.Name = "F10"
F10.Text = "F10"
F10.Position = UDim2.new(0, 327, 0, -1)

F10Stroke.Color = Color3.fromRGB(255, 255, 255)
F10Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F10Corner.CornerRadius = UDim.new(0, 4)

F11.TextWrapped = true
F11.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
F11.TextSize = 15
F11.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
F11.TextColor3 = Color3.fromRGB(255, 255, 255)
F11.Size = UDim2.new(0, 24, 0, 25)
F11.Name = "F11"
F11.Text = "F11"
F11.Position = UDim2.new(0, 358, 0, -1)

F11Stroke.Color = Color3.fromRGB(255, 255, 255)
F11Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

F11Corner.CornerRadius = UDim.new(0, 4)

Pipe.TextWrapped = true
Pipe.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Pipe.TextSize = 21
Pipe.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Pipe.TextColor3 = Color3.fromRGB(255, 255, 255)
Pipe.Visible = false
Pipe.Size = UDim2.new(0, 25, 0, 25)
Pipe.Name = "_Pipe"
Pipe.Text = "|"
Pipe.Position = UDim2.new(0, 442, 0, 63)

PipeStroke.Color = Color3.fromRGB(255, 255, 255)
PipeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PipeCorner.CornerRadius = UDim.new(0, 4)

Tilde.TextWrapped = true
Tilde.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Tilde.TextSize = 21
Tilde.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Tilde.TextColor3 = Color3.fromRGB(255, 255, 255)
Tilde.Visible = false
Tilde.Size = UDim2.new(0, 25, 0, 25)
Tilde.Name = "_Tilde"
Tilde.Text = "~"
Tilde.Position = UDim2.new(0, 7, 0, 31)

TildeStroke.Color = Color3.fromRGB(255, 255, 255)
TildeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TildeCorner.CornerRadius = UDim.new(0, 4)

Exclamation.TextWrapped = true
Exclamation.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Exclamation.TextSize = 21
Exclamation.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Exclamation.TextColor3 = Color3.fromRGB(255, 255, 255)
Exclamation.Visible = false
Exclamation.Size = UDim2.new(0, 25, 0, 25)
Exclamation.Name = "_Exclamation"
Exclamation.Text = "!"
Exclamation.Position = UDim2.new(0, 39, 0, 31)

ExclamationStroke.Color = Color3.fromRGB(255, 255, 255)
ExclamationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ExclamationCorner.CornerRadius = UDim.new(0, 4)

At.TextWrapped = true
At.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
At.TextSize = 21
At.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
At.TextColor3 = Color3.fromRGB(255, 255, 255)
At.Visible = false
At.Size = UDim2.new(0, 25, 0, 25)
At.Name = "_At"
At.Text = "@"
At.Position = UDim2.new(0, 71, 0, 31)

AtStroke.Color = Color3.fromRGB(255, 255, 255)
AtStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

AtCorner.CornerRadius = UDim.new(0, 4)

Hash.TextWrapped = true
Hash.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Hash.TextSize = 21
Hash.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Hash.TextColor3 = Color3.fromRGB(255, 255, 255)
Hash.Visible = false
Hash.Size = UDim2.new(0, 25, 0, 25)
Hash.Name = "_Hash"
Hash.Text = "#"
Hash.Position = UDim2.new(0, 104, 0, 31)

HashStroke.Color = Color3.fromRGB(255, 255, 255)
HashStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

HashCorner.CornerRadius = UDim.new(0, 4)

Dollar.TextWrapped = true
Dollar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Dollar.TextSize = 21
Dollar.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Dollar.TextColor3 = Color3.fromRGB(255, 255, 255)
Dollar.Visible = false
Dollar.Size = UDim2.new(0, 25, 0, 25)
Dollar.Name = "_Dollar"
Dollar.Text = "$"
Dollar.Position = UDim2.new(0, 135, 0, 31)

DollarStroke.Color = Color3.fromRGB(255, 255, 255)
DollarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

DollarCorner.CornerRadius = UDim.new(0, 4)

Percent.TextWrapped = true
Percent.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Percent.TextSize = 21
Percent.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Percent.TextColor3 = Color3.fromRGB(255, 255, 255)
Percent.Visible = false
Percent.Size = UDim2.new(0, 25, 0, 25)
Percent.Name = "_Percent"
Percent.Text = "%"
Percent.Position = UDim2.new(0, 167, 0, 31)

PercentStroke.Color = Color3.fromRGB(255, 255, 255)
PercentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PercentCorner.CornerRadius = UDim.new(0, 4)

Caret.TextWrapped = true
Caret.TextStrokeTransparency = 0
Caret.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Caret.TextSize = 21
Caret.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Caret.TextColor3 = Color3.fromRGB(255, 255, 255)
Caret.Visible = false
Caret.Size = UDim2.new(0, 25, 0, 25)
Caret.Name = "_Caret"
Caret.Text = "^"
Caret.Position = UDim2.new(0, 199, 0, 31)

CaretStroke.Color = Color3.fromRGB(255, 255, 255)
CaretStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CaretCorner.CornerRadius = UDim.new(0, 4)

Ampersand.TextWrapped = true
Ampersand.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Ampersand.TextSize = 21
Ampersand.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Ampersand.TextColor3 = Color3.fromRGB(255, 255, 255)
Ampersand.Visible = false
Ampersand.Size = UDim2.new(0, 25, 0, 25)
Ampersand.Name = "_Ampersand"
Ampersand.Text = "&"
Ampersand.Position = UDim2.new(0, 231, 0, 31)

AmpersandStroke.Color = Color3.fromRGB(255, 255, 255)
AmpersandStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

AmpersandCorner.CornerRadius = UDim.new(0, 4)

Asterisk.TextWrapped = true
Asterisk.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Asterisk.TextSize = 21
Asterisk.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Asterisk.TextColor3 = Color3.fromRGB(255, 255, 255)
Asterisk.Visible = false
Asterisk.Size = UDim2.new(0, 24, 0, 25)
Asterisk.Name = "_Asterisk"
Asterisk.Text = "*"
Asterisk.Position = UDim2.new(0, 264, 0, 31)

AsteriskStroke.Color = Color3.fromRGB(255, 255, 255)
AsteriskStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

AsteriskCorner.CornerRadius = UDim.new(0, 4)

LeftParenthesis.TextWrapped = true
LeftParenthesis.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftParenthesis.TextSize = 21
LeftParenthesis.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftParenthesis.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftParenthesis.Visible = false
LeftParenthesis.Size = UDim2.new(0, 24, 0, 25)
LeftParenthesis.Name = "_LeftParenthesis"
LeftParenthesis.Text = "("
LeftParenthesis.Position = UDim2.new(0, 295, 0, 31)

LeftParenthesisStroke.Color = Color3.fromRGB(255, 255, 255)
LeftParenthesisStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftParenthesisCorner.CornerRadius = UDim.new(0, 4)

RightParenthesis.TextWrapped = true
RightParenthesis.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightParenthesis.TextSize = 21
RightParenthesis.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightParenthesis.TextColor3 = Color3.fromRGB(255, 255, 255)
RightParenthesis.Visible = false
RightParenthesis.Size = UDim2.new(0, 24, 0, 25)
RightParenthesis.Name = "_RightParenthesis"
RightParenthesis.Text = ")"
RightParenthesis.Position = UDim2.new(0, 327, 0, 31)

RightParenthesisStroke.Color = Color3.fromRGB(255, 255, 255)
RightParenthesisStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightParenthesisCorner.CornerRadius = UDim.new(0, 4)

Underscore.TextWrapped = true
Underscore.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Underscore.TextSize = 21
Underscore.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Underscore.TextColor3 = Color3.fromRGB(255, 255, 255)
Underscore.Visible = false
Underscore.Size = UDim2.new(0, 24, 0, 25)
Underscore.Name = "_Underscore"
Underscore.Text = "_"
Underscore.Position = UDim2.new(0, 358, 0, 31)

UnderscoreStroke.Color = Color3.fromRGB(255, 255, 255)
UnderscoreStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UnderscoreCorner.CornerRadius = UDim.new(0, 4)

Plus.TextWrapped = true
Plus.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Plus.TextSize = 21
Plus.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Plus.TextColor3 = Color3.fromRGB(255, 255, 255)
Plus.Visible = false
Plus.Size = UDim2.new(0, 24, 0, 25)
Plus.Name = "_Plus"
Plus.Text = "+"
Plus.Position = UDim2.new(0, 389, 0, 31)

PlusStroke.Color = Color3.fromRGB(255, 255, 255)
PlusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

PlusCorner.CornerRadius = UDim.new(0, 4)

RightCurly.TextWrapped = true
RightCurly.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RightCurly.TextSize = 21
RightCurly.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RightCurly.TextColor3 = Color3.fromRGB(255, 255, 255)
RightCurly.Visible = false
RightCurly.Size = UDim2.new(0, 25, 0, 25)
RightCurly.Name = "_RightCurly"
RightCurly.Text = "}"
RightCurly.Position = UDim2.new(0, 410, 0, 63)

RightCurlyStroke.Color = Color3.fromRGB(255, 255, 255)
RightCurlyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RightCurlyCorner.CornerRadius = UDim.new(0, 4)

LeftCurly.TextWrapped = true
LeftCurly.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LeftCurly.TextSize = 21
LeftCurly.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LeftCurly.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftCurly.Visible = false
LeftCurly.Size = UDim2.new(0, 25, 0, 25)
LeftCurly.Name = "_LeftCurly"
LeftCurly.Text = "{"
LeftCurly.Position = UDim2.new(0, 378, 0, 63)

LeftCurlyStroke.Color = Color3.fromRGB(255, 255, 255)
LeftCurlyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LeftCurlyCorner.CornerRadius = UDim.new(0, 4)

QuotedDouble.TextWrapped = true
QuotedDouble.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
QuotedDouble.TextSize = 21
QuotedDouble.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
QuotedDouble.TextColor3 = Color3.fromRGB(255, 255, 255)
QuotedDouble.Visible = false
QuotedDouble.Size = UDim2.new(0, 25, 0, 25)
QuotedDouble.Name = "_QuotedDouble"
QuotedDouble.Text = '"'
QuotedDouble.Position = UDim2.new(0, 386, 0, 95)

QuotedDoubleStroke.Color = Color3.fromRGB(255, 255, 255)
QuotedDoubleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

QuotedDoubleCorner.CornerRadius = UDim.new(0, 4)

Colon.TextWrapped = true
Colon.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Colon.TextSize = 21
Colon.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Colon.TextColor3 = Color3.fromRGB(255, 255, 255)
Colon.Visible = false
Colon.Size = UDim2.new(0, 25, 0, 25)
Colon.Name = "_Colon"
Colon.Text = ":"
Colon.Position = UDim2.new(0, 354, 0, 95)

ColonStroke.Color = Color3.fromRGB(255, 255, 255)
ColonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ColonCorner.CornerRadius = UDim.new(0, 4)

Question.TextWrapped = true
Question.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Question.TextSize = 21
Question.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Question.TextColor3 = Color3.fromRGB(255, 255, 255)
Question.Visible = false
Question.Size = UDim2.new(0, 25, 0, 25)
Question.Name = "_Question"
Question.Text = "?"
Question.Position = UDim2.new(0, 372, 0, 127)

QuestionStroke.Color = Color3.fromRGB(255, 255, 255)
QuestionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

QuestionCorner.CornerRadius = UDim.new(0, 4)

GreaterThan.TextWrapped = true
GreaterThan.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
GreaterThan.TextSize = 21
GreaterThan.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
GreaterThan.TextColor3 = Color3.fromRGB(255, 255, 255)
GreaterThan.Visible = false
GreaterThan.Size = UDim2.new(0, 25, 0, 25)
GreaterThan.Name = "_GreaterThan"
GreaterThan.Text = ">"
GreaterThan.Position = UDim2.new(0, 338, 0, 127)

GreaterThanStroke.Color = Color3.fromRGB(255, 255, 255)
GreaterThanStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

GreaterThanCorner.CornerRadius = UDim.new(0, 4)

LessThan.TextWrapped = true
LessThan.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LessThan.TextSize = 21
LessThan.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LessThan.TextColor3 = Color3.fromRGB(255, 255, 255)
LessThan.Visible = false
LessThan.Size = UDim2.new(0, 25, 0, 25)
LessThan.Name = "_LessThan"
LessThan.Text = "<"
LessThan.Position = UDim2.new(0, 305, 0, 127)

LessThanStroke.Color = Color3.fromRGB(255, 255, 255)
LessThanStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

LessThanCorner.CornerRadius = UDim.new(0, 4)

BackgroundCorner.CornerRadius = UDim.new(0, 4)

D.TextWrapped = true
D.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
D.TextSize = 21
D.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
D.TextColor3 = Color3.fromRGB(255, 255, 255)
D.Size = UDim2.new(0, 25, 0, 25)
D.Name = "D"
D.Text = "D"
D.Position = UDim2.new(0, 130, 0, 95)

DStroke.Color = Color3.fromRGB(255, 255, 255)
DStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

DCorner.CornerRadius = UDim.new(0, 4)

MainCorner.CornerRadius = UDim.new(0, 4)

ToggleRGB.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleRGB.TextSize = 14
ToggleRGB.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ToggleRGB.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleRGB.Size = UDim2.new(0, 14, 0, 14)
ToggleRGB.Name = "ToggleRGB"
ToggleRGB.Text = ""
ToggleRGB.Position = UDim2.new(0.9649999737739563, 0, 0.9300000071525574, 0)

ToggleRGBCorner.CornerRadius = UDim.new(0, 4)

ToggleRGBStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleRGBStroke.Thickness = 0.8999999761581421
ToggleRGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Tesy.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Tesy.TextSize = 14
Tesy.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Tesy.TextColor3 = Color3.fromRGB(0, 0, 0)
Tesy.Visible = false
Tesy.Size = UDim2.new(0, 58, 0, 14)
Tesy.Name = "tesy"
Tesy.Text = ""
Tesy.Position = UDim2.new(0.8352929353713989, 0, 0.9299998879432678, 0)

TesyCorner.CornerRadius = UDim.new(0, 4)

TesyStroke.Color = Color3.fromRGB(255, 255, 255)
TesyStroke.Thickness = 0.8999999761581421
TesyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Close.BorderSizePixel = 0
Close.AutoButtonColor = false
Close.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Close.TextSize = 16
Close.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Size = UDim2.new(0, 34, 0, 22)
Close.Name = "Close"
Close.BorderColor3 = Color3.fromRGB(255, 255, 255)
Close.Text = "X"
Close.Position = UDim2.new(0, 437, 0, 2)

Minimize.BorderSizePixel = 0
Minimize.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Minimize.TextSize = 21
Minimize.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Size = UDim2.new(0, 34, 0, 22)
Minimize.Name = "Minimize"
Minimize.Text = "-"
Minimize.Position = UDim2.new(0, 367, 0, 2)
Minimize.BackgroundTransparency = 1

Window.BorderSizePixel = 0
Window.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Window.TextSize = 21
Window.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Window.TextColor3 = Color3.fromRGB(255, 255, 255)
Window.Size = UDim2.new(0, 34, 0, 22)
Window.Name = "Window"
Window.Text = "☐"
Window.Position = UDim2.new(0, 401, 0, 2)
Window.BackgroundTransparency = 1

Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(0, 121, 0, 22)
Title.Active = true
Title.Text = "Kilobyte keyboard [V3]"
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 9, 0, 2)

Settings.BorderSizePixel = 0
Settings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Settings.FontFace = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Settings.TextColor3 = Color3.fromRGB(255, 255, 255)
Settings.Selectable = false
Settings.Size = UDim2.new(0, 17, 0, 17)
Settings.Name = "Settings"
Settings.Text = "a +"
Settings.Position = UDim2.new(0.0041841003112494946, 0, 0.9237288236618042, 0)
Settings.BackgroundTransparency = 1

IsSelectingKey.Name = "IsSelectingKey"

Key.TextWrapped = true
Key.TextScaled = true
Key.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Key.FontFace = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Key.TextColor3 = Color3.fromRGB(255, 255, 255)
Key.Selectable = false
Key.Visible = false
Key.Size = UDim2.new(0, 40, 0, 40)
Key.Name = "KEY"
Key.Text = "KEY"
Key.Position = UDim2.new(0.47962817549705505, 0, 0.46487605571746826, 0)

KeyStroke.Color = Color3.fromRGB(255, 255, 255)
KeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

KeyClose.TextWrapped = true
KeyClose.TextScaled = true
KeyClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
KeyClose.TextSize = 14
KeyClose.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
KeyClose.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyClose.Size = UDim2.new(0, 11, 0, 11)
KeyClose.Name = "Close"
KeyClose.Text = "X"
KeyClose.Position = UDim2.new(1, 0, -0.125, 0)

CreateKey.Active = true
CreateKey.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
CreateKey.Size = UDim2.new(0, 284, 0, 292)
CreateKey.Position = UDim2.new(0.3589794337749481, 0, 0.24793387949466705, 0)
CreateKey.Visible = false
CreateKey.Name = "CreateKey"

CreateKeyStroke.Color = Color3.fromRGB(158, 0, 255)
CreateKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CreateTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CreateTitle.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
CreateTitle.Selectable = true
CreateTitle.TextSize = 18
CreateTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CreateTitle.Size = UDim2.new(0, 285, 0, 24)
CreateTitle.Active = true
CreateTitle.Text = "Kilobyte keyboard [V3] - Setting floating key"
CreateTitle.Name = "Title"
CreateTitle.BackgroundTransparency = 1
CreateTitle.Position = UDim2.new(-0.0035211266949772835, 0, 0.02054794505238533, 0)

CreateButton.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
CreateButton.TextSize = 31
CreateButton.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
CreateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CreateButton.Size = UDim2.new(0, 166, 0, 46)
CreateButton.Name = "Create"
CreateButton.Text = "Create"
CreateButton.Position = UDim2.new(0.2042253464460373, 0, 0.6095890402793884, 0)

CreateButtonStroke.Color = Color3.fromRGB(255, 255, 255)
CreateButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title2.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title2.Selectable = true
Title2.TextSize = 20
Title2.TextColor3 = Color3.fromRGB(255, 255, 255)
Title2.Size = UDim2.new(0, 285, 0, 24)
Title2.Active = true
Title2.Text = "Enter your keybind here."
Title2.Name = "Title2"
Title2.BackgroundTransparency = 1
Title2.Position = UDim2.new(-0.003521125763654709, 0, 0.19178083539009094, 0)

TextBox.TextSize = 14
TextBox.TextWrapped = true
TextBox.TextScaled = true
TextBox.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextBox.Size = UDim2.new(0, 167, 0, 76)
TextBox.Text = ""
TextBox.Position = UDim2.new(0.2042253464460373, 0, 0.29109588265419006, 0)

TextBoxStroke.Color = Color3.fromRGB(255, 255, 255)
TextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CloseButton.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
CloseButton.TextSize = 20
CloseButton.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Size = UDim2.new(0, 166, 0, 22)
CloseButton.Name = "Close"
CloseButton.Text = "Close"
CloseButton.Position = UDim2.new(0.2042253464460373, 0, 0.8835616707801819, 0)

CloseButtonStroke.Color = Color3.fromRGB(255, 255, 255)
CloseButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Keys.Name = "Keys"

ToggleShift.Value = true
ToggleShift.Name = "ToggleShift"

Shifting.Name = "Shifting"

FloatingIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingIcon.Image = "http://www.roblox.com/asset/?id=114265663904736"
FloatingIcon.Size = UDim2.new(0, 40, 0, 40)
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Visible = false
FloatingIcon.Position = UDim2.new(0.015649452805519104, 0, 0.03064066171646118, 0)

FloatingIconCorner.CornerRadius = UDim.new(0, 4)

FloatingIconStroke.Color = Color3.fromRGB(158, 0, 255)
FloatingIconStroke.Thickness = 1.2999999523162842
FloatingIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

function CreateFloatingKey(Keybind, Text)
    local NewKey = Key:Clone()
    if Text == "" then
        Text = "Space"
        Keybind = "Space"
    end
    NewKey.Parent = Keys
    NewKey.Visible = true
    NewKey.Draggable = true
    NewKey.Name = Keybind
    NewKey.Text = Text
    NewKey.MouseButton1Up:Connect(function()
        keyrelease(Enum.KeyCode[Keybind])
    end)
    NewKey.MouseButton1Down:Connect(function()
        keypress(Enum.KeyCode[Keybind])      
    end)
    NewKey.Close.MouseButton1Up:Connect(function()
        NewKey:Destroy()
    end)
end

function SetupButtonHandlers()
    local Buttons = Background
    for _, Button in pairs(Buttons:GetChildren()) do
        if Button:IsA("TextButton") then
            if string.find(Button.Name, "-") then
                local KeyName = string.sub(Button.Name, 2)
                Button.MouseButton1Down:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(KeyName, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keypress(Enum.KeyCode[KeyName])
                    end
                end)
                Button.MouseButton1Up:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(KeyName, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keyrelease(Enum.KeyCode[KeyName])
                    end
                end)
            elseif string.find(Button.Name, "_") then
                local KeyName = string.sub(Button.Name, 2)
                Button.MouseButton1Down:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(KeyName, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keypress(Enum.KeyCode[KeyName])
                    end
                end)
                Button.MouseButton1Up:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(KeyName, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keyrelease(Enum.KeyCode[KeyName])
                    end
                end)
            elseif Button.Name == "RightShift" then
                Button.MouseButton1Up:Connect(function()
                    if ToggleShift.Value == false then
                        if Shifting.Value then
                            Shifting.Value = false
                            for _, V in pairs(Buttons:GetChildren()) do
                                if V:IsA("TextButton") then
                                    local A = V.Name
                                    if string.find(A, "_") then
                                        V.Visible = false
                                    elseif string.find(A, "-") then
                                        V.Visible = true
                                    end
                                end
                            end
                        elseif not Shifting.Value then
                            Shifting.Value = true
                            for _, V in pairs(Buttons:GetChildren()) do
                                if V:IsA("TextButton") then
                                    local A = V.Name
                                    if string.find(A, "_") then
                                        V.Visible = true
                                    elseif string.find(A, "-") then
                                        V.Visible = false
                                    end
                                end
                            end
                        end
                    elseif ToggleShift.Value == true then
                        if IsSelectingKey.Value == false then
                            keypress(Enum.KeyCode[Button.Name])
                        elseif IsSelectingKey.Value == true then
                            IsSelectingKey.Value = false
                            CreateFloatingKey(Button.Name, Button.Name)
                        end
                    end
                end)
            elseif Button.Name == "LeftShift" then
                Button.MouseButton1Up:Connect(function()
                    if ToggleShift.Value == false then
                        if Shifting.Value then
                            Shifting.Value = false
                            for _, V in pairs(Buttons:GetChildren()) do
                                if V:IsA("TextButton") then
                                    local A = V.Name
                                    if string.find(A, "_") then
                                        V.Visible = false
                                    elseif string.find(A, "-") then
                                        V.Visible = true
                                    end
                                end
                            end
                        elseif not Shifting.Value then
                            Shifting.Value = true
                            for _, V in pairs(Buttons:GetChildren()) do
                                if V:IsA("TextButton") then
                                    local A = V.Name
                                    if string.find(A, "_") then
                                        V.Visible = true
                                    elseif string.find(A, "-") then
                                        V.Visible = false
                                    end
                                end
                            end
                        end
                    elseif ToggleShift.Value == true then
                        if IsSelectingKey.Value == false then
                            keypress(Enum.KeyCode[Button.Name])
                        elseif IsSelectingKey.Value == true then
                            IsSelectingKey.Value = false
                            CreateFloatingKey(Button.Name, Button.Name)
                        end
                    end
                end)
                Button.MouseButton1Down:Connect(function()
                    if ToggleShift.Value == true then
                        keypress(Enum.KeyCode[Button.Name])
                    end
                end)
            else
                Button.MouseButton1Down:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(Button.Text, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keypress(Enum.KeyCode[Button.Name])
                    end
                end)
                Button.MouseButton1Up:Connect(function()
                    if IsSelectingKey.Value == true then
                        CreateFloatingKey(Button.Text, Button.Text)
                        IsSelectingKey.Value = false
                    else
                        keyrelease(Enum.KeyCode[Button.Name])
                    end
                end)
            end     
        end
    end
end

function Dragify(Frame)
    local DragToggle = nil
    local DragSpeed = 0.25
    local DragInput = nil
    local DragStart = nil
    local DragPos = nil

    local function UpdateInput(Input)
        local Delta = Input.Position - DragStart
        local Position = UDim2.new(DragPos.X.Scale, DragPos.X.Offset + Delta.X, DragPos.Y.Scale, DragPos.Y.Offset + Delta.Y)
        Services.TweenService:Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
    end

    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragToggle = true
            DragStart = Input.Position
            DragPos = Frame.Position
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    DragToggle = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and DragToggle then
            UpdateInput(Input)
        end
    end)
end

function SetupWindowControls()
    local Cooldown = false
    Close.MouseButton1Up:Connect(function()
        ScreenGui:Destroy()
    end)
    Close.MouseEnter:Connect(function()
        Close.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    end)
    Close.MouseLeave:Connect(function()
        Close.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    Minimize.MouseButton1Up:Connect(function()
        Main.Visible = false
        FloatingIcon.Visible = true
    end)
    Window.MouseButton1Up:Connect(function()
        if not Cooldown then
            if Background.Visible == true then
                ToggleRGB.Visible = false
                Settings.Visible = false
                Background.Visible = false
                ToggleShift.Visible = false
                local Ti = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local Tw = Services.TweenService:Create(Main, Ti, {Size = UDim2.new(0, 478, 0, 29)})
                Tw:Play()
                Cooldown = true
                Tw.Completed:Wait()
                Cooldown = false
            elseif Background.Visible == false then
                local Ti = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local Tw = Services.TweenService:Create(Main, Ti, {Size = UDim2.new(0, 478, 0, 236)})
                Tw:Play()
                Cooldown = true
                Tw.Completed:Wait()
                ToggleRGB.Visible = true
                Settings.Visible = true
                Background.Visible = true
                ToggleShift.Visible = true
                Cooldown = false
            end
        end
    end)
    Settings.MouseButton1Up:Connect(function()
        IsSelectingKey.Value = true
    end)
    IsSelectingKey:GetPropertyChangedSignal("Value"):Connect(function()
        if IsSelectingKey.Value == true then
            Title.Text = "Kilobyte keyboard (Selecting Key)"
        elseif IsSelectingKey.Value == false then
            Title.Text = "Kilobyte keyboard"
        end
    end)
end

function SetupCreateKeyWindow()
    CreateKey.Draggable = true
    CloseButton.MouseButton1Up:Connect(function()
        CreateKey.Visible = false
    end)
    CreateButton.MouseButton1Up:Connect(function()
        if TextBox.Text ~= "" then
            local NewKey = Key:Clone()
            NewKey.Parent = Keys
            NewKey.Visible = true
            NewKey.Draggable = true
            NewKey.Name = TextBox.Text
            NewKey.MouseButton1Up:Connect(function()
                keyrelease(Enum.KeyCode[TextBox.Text])
            end)
            NewKey.MouseButton1Down:Connect(function()
                keypress(Enum.KeyCode[TextBox.Text])
            end)
            NewKey.Close.MouseButton1Up:Connect(function()
                NewKey:Destroy()
            end)
        end
    end)
end

function SetupFloatingIcon()
    FloatingIcon.MouseButton1Up:Connect(function()
        FloatingIcon.Visible = false
        Main.Visible = true
    end)
end

function ApplyGlobalStyles()
    local UbuntuFont = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    local GradientColor = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(101, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255))
    }
    for _, UIElement in ipairs(ScreenGui:GetDescendants()) do
        if UIElement.Name == "ToggleRGB" then
            UIElement:Destroy()
        end
        if UIElement:IsA("TextLabel") or UIElement:IsA("TextButton") or UIElement:IsA("TextBox") then
            UIElement.FontFace = UbuntuFont
            UIElement.TextScaled = true
            UIElement.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        if UIElement:IsA("TextLabel") or UIElement:IsA("TextButton") then
            if not UIElement:FindFirstChildWhichIsA("UIGradient") then
                local TG = Instance.new("UIGradient")
                TG.Color = GradientColor
                TG.Parent = UIElement
            end
        end
        if UIElement:IsA("UIStroke") then
            UIElement.Color = Color3.fromRGB(255, 255, 255)
            if not UIElement:FindFirstChildWhichIsA("UIGradient") then
                local SG = Instance.new("UIGradient")
                SG.Color = GradientColor
                SG.Parent = UIElement
            end
        end
    end
end

SetupButtonHandlers()
task.spawn(Dragify, Main)
task.spawn(Dragify, FloatingIcon)
SetupWindowControls()
SetupCreateKeyWindow()
SetupFloatingIcon()
ApplyGlobalStyles()

return ScreenGui
