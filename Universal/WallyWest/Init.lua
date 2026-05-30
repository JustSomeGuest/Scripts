if not game:IsLoaded() then game.Loaded:Wait() end

function default(expected, value, fallback)
	if type(value) == expected then
		return value
	end
	return fallback
end

cloneref = default("function", cloneref, function(...) return ... end)

Services = setmetatable({}, {
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

getgenv().WallyWest = getgenv().WallyWest or {}

if getgenv().WallyWest.isLoaded then
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Wally West",
        Text = "Wally West is already running!",
        Duration = 4
    })
    return
end

getgenv().WallyWest.isLoaded = true

local WriteFile = default("function", writefile, function() end)
local IsFile = default("function", isfile, function() return false end)
local IsFolder = default("function", isfolder, function() return false end)
local MakeFolder = default("function", makefolder, function() end)
local LoadAsset = default("function", getcustomasset, default("function", getsynasset, nil))

local Assets = {
    ["WallyWest/Assets/music.mp3"] = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Universal/WallyWest/Assets/music.mp3",
}

local function HttpGet(url)
    local RequestFunc = default("function", syn and syn.request, 
        default("function", request, 
            default("function", http_request, nil)))
    
    if not RequestFunc then
        return nil
    end
    
    local success, result = pcall(function()
        return RequestFunc({
            Url = url,
            Method = "GET"
        })
    end)
    
    return success and result or nil
end

local function GetAsset(Path)
    if not LoadAsset then
        return nil
    end

    local Asset = Assets[Path]
    if not Asset then
        return nil
    end

    if not IsFolder("WallyWest") then
        MakeFolder("WallyWest")
    end

    if not IsFolder("WallyWest/Assets") then
        MakeFolder("WallyWest/Assets")
    end

    if Asset:match("^rbxassetid://") then
        return Asset
    end

    if not IsFile(Path) then
        local Success, Response = pcall(function()
            return HttpGet(Asset)
        end)

        if not Success or not Response or not Response.Success or not Response.Body then
            return nil
        end

        WriteFile(Path, Response.Body)
    end

    return LoadAsset(Path)
end

local Players = Services.Players
local RunService = Services.RunService
local HttpService = Services.HttpService
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local Player = Players.LocalPlayer
local CoreGui = (gethui and select(2, pcall(gethui))) or Services.CoreGui

local GothamFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local WallyWestGui = Instance.new("ScreenGui", CoreGui)
WallyWestGui.Name = "WallyWest"
WallyWestGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WallyWestGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", WallyWestGui)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.ClipsDescendants = true
MainFrame.Size = UDim2.new(0, 280, 0, 190)
MainFrame.Position = UDim2.new(0, 20, 0, 8)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundTransparency = 0.5

local MainFramePadding = Instance.new("UIPadding", MainFrame)
MainFramePadding.PaddingTop = UDim.new(0, 2)
MainFramePadding.PaddingRight = UDim.new(0, 2)
MainFramePadding.Name = "MainFramePadding"
MainFramePadding.PaddingLeft = UDim.new(0, 2)
MainFramePadding.PaddingBottom = UDim.new(0, 2)

local Content = Instance.new("Frame", MainFrame)
Content.ZIndex = 0
Content.BorderSizePixel = 0
Content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Content.AutomaticSize = Enum.AutomaticSize.Y
Content.Size = UDim2.new(0, 276, 0, 0)
Content.Name = "Content"
Content.LayoutOrder = 3
Content.BackgroundTransparency = 0.5

local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.Name = "ContentCorner"
ContentCorner.CornerRadius = UDim.new(0, 4)

local Toggle = Instance.new("TextButton", Content)
Toggle.TextWrapped = true
Toggle.BorderSizePixel = 0
Toggle.TextScaled = true
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toggle.BackgroundTransparency = 1
Toggle.Size = UDim2.new(0, 230, 0, 28)
Toggle.LayoutOrder = 1
Toggle.Text = ""
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 8, 0, 44)

local ToggleCorner = Instance.new("UICorner", Toggle)
ToggleCorner.Name = "ToggleCorner"
ToggleCorner.CornerRadius = UDim.new(0, 4)

local ToggleSizeCons = Instance.new("UISizeConstraint", Toggle)
ToggleSizeCons.MinSize = Vector2.new(0, 28)
ToggleSizeCons.MaxSize = Vector2.new(math.huge, 30)

local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleStroke.Name = "ToggleStroke"
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)

local Label = Instance.new("TextLabel", Toggle)
Label.TextWrapped = true
Label.BorderSizePixel = 0
Label.TextScaled = true
Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label.FontFace = GothamFont
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1
Label.Size = UDim2.new(1, 0, 1, 0)
Label.Text = "Toggle: Off"
Label.Name = "Label"

local LabelPadding = Instance.new("UIPadding", Label)
LabelPadding.PaddingTop = UDim.new(0, 4)
LabelPadding.PaddingRight = UDim.new(0, 5)
LabelPadding.Name = "LabelPadding"
LabelPadding.PaddingLeft = UDim.new(0, 5)
LabelPadding.PaddingBottom = UDim.new(0, 4)

local Music = Instance.new("TextButton", Content)
Music.TextWrapped = true
Music.BorderSizePixel = 0
Music.TextScaled = true
Music.TextColor3 = Color3.fromRGB(255, 255, 255)
Music.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Music.BackgroundTransparency = 1
Music.Size = UDim2.new(0, 230, 0, 28)
Music.LayoutOrder = 2
Music.Text = ""
Music.Name = "Music"
Music.Position = UDim2.new(0, 8, 0, 44)

local MusicStroke = Instance.new("UIStroke", Music)
MusicStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MusicStroke.Name = "MusicStroke"
MusicStroke.Color = Color3.fromRGB(255, 255, 255)

local MusicCorner = Instance.new("UICorner", Music)
MusicCorner.Name = "MusicCorner"
MusicCorner.CornerRadius = UDim.new(0, 4)

local Label4 = Instance.new("TextLabel", Music)
Label4.TextWrapped = true
Label4.BorderSizePixel = 0
Label4.TextScaled = true
Label4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label4.FontFace = GothamFont
Label4.TextColor3 = Color3.fromRGB(255, 255, 255)
Label4.BackgroundTransparency = 1
Label4.Size = UDim2.new(1, 0, 1, 0)
Label4.Text = "Music: On"
Label4.Name = "Label"

local Label4Padding = Instance.new("UIPadding", Label4)
Label4Padding.PaddingTop = UDim.new(0, 4)
Label4Padding.PaddingRight = UDim.new(0, 5)
Label4Padding.Name = "LabelPadding"
Label4Padding.PaddingLeft = UDim.new(0, 5)
Label4Padding.PaddingBottom = UDim.new(0, 4)

local MusicSizeCons = Instance.new("UISizeConstraint", Music)
MusicSizeCons.MinSize = Vector2.new(0, 28)
MusicSizeCons.Name = "MusicSC"
MusicSizeCons.MaxSize = Vector2.new(math.huge, 30)

local ParticlesBtn = Instance.new("TextButton", Content)
ParticlesBtn.TextWrapped = true
ParticlesBtn.BorderSizePixel = 0
ParticlesBtn.TextScaled = true
ParticlesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ParticlesBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ParticlesBtn.BackgroundTransparency = 1
ParticlesBtn.Size = UDim2.new(0, 230, 0, 28)
ParticlesBtn.LayoutOrder = 3
ParticlesBtn.Text = ""
ParticlesBtn.Name = "ParticlesBtn"
ParticlesBtn.Position = UDim2.new(0, 8, 0, 44)

local ParticlesSizeCons = Instance.new("UISizeConstraint", ParticlesBtn)
ParticlesSizeCons.MinSize = Vector2.new(0, 28)
ParticlesSizeCons.Name = "ParticlesSC"
ParticlesSizeCons.MaxSize = Vector2.new(math.huge, 30)

local Label2 = Instance.new("TextLabel", ParticlesBtn)
Label2.TextWrapped = true
Label2.BorderSizePixel = 0
Label2.TextScaled = true
Label2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label2.FontFace = GothamFont
Label2.TextColor3 = Color3.fromRGB(255, 255, 255)
Label2.BackgroundTransparency = 1
Label2.Size = UDim2.new(1, 0, 1, 0)
Label2.Text = "Particles: On"
Label2.Name = "Label"

local Label2Padding = Instance.new("UIPadding", Label2)
Label2Padding.PaddingTop = UDim.new(0, 4)
Label2Padding.PaddingRight = UDim.new(0, 5)
Label2Padding.Name = "LabelPadding"
Label2Padding.PaddingLeft = UDim.new(0, 5)
Label2Padding.PaddingBottom = UDim.new(0, 4)

local ParticlesStroke = Instance.new("UIStroke", ParticlesBtn)
ParticlesStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ParticlesStroke.Name = "ParticlesStroke"
ParticlesStroke.Color = Color3.fromRGB(255, 255, 255)

local ParticlesCorner = Instance.new("UICorner", ParticlesBtn)
ParticlesCorner.Name = "ParticlesCorner"
ParticlesCorner.CornerRadius = UDim.new(0, 4)

local BlueFX = Instance.new("TextButton", Content)
BlueFX.TextWrapped = true
BlueFX.BorderSizePixel = 0
BlueFX.TextScaled = true
BlueFX.TextColor3 = Color3.fromRGB(255, 255, 255)
BlueFX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BlueFX.BackgroundTransparency = 1
BlueFX.Size = UDim2.new(0, 230, 0, 28)
BlueFX.LayoutOrder = 4
BlueFX.Text = ""
BlueFX.Name = "BlueFX"
BlueFX.Position = UDim2.new(0, 8, 0, 44)

local BlueFXStroke = Instance.new("UIStroke", BlueFX)
BlueFXStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BlueFXStroke.Name = "BlueFXStroke"
BlueFXStroke.Color = Color3.fromRGB(255, 255, 255)

local Label3 = Instance.new("TextLabel", BlueFX)
Label3.TextWrapped = true
Label3.BorderSizePixel = 0
Label3.TextScaled = true
Label3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label3.FontFace = GothamFont
Label3.TextColor3 = Color3.fromRGB(255, 255, 255)
Label3.BackgroundTransparency = 1
Label3.Size = UDim2.new(1, 0, 1, 0)
Label3.Text = "Blue Effect: On"
Label3.Name = "Label"

local Label3Padding = Instance.new("UIPadding", Label3)
Label3Padding.PaddingTop = UDim.new(0, 4)
Label3Padding.PaddingRight = UDim.new(0, 5)
Label3Padding.Name = "LabelPadding"
Label3Padding.PaddingLeft = UDim.new(0, 5)
Label3Padding.PaddingBottom = UDim.new(0, 4)

local BlueFXCorner = Instance.new("UICorner", BlueFX)
BlueFXCorner.Name = "BlueFXCorner"
BlueFXCorner.CornerRadius = UDim.new(0, 4)

local BlueFXSizeCons = Instance.new("UISizeConstraint", BlueFX)
BlueFXSizeCons.MinSize = Vector2.new(0, 28)
BlueFXSizeCons.Name = "BlueFXSC"
BlueFXSizeCons.MaxSize = Vector2.new(math.huge, 30)

local ContentPadding = Instance.new("UIPadding", Content)
ContentPadding.PaddingTop = UDim.new(0, 6)
ContentPadding.PaddingRight = UDim.new(0, 6)
ContentPadding.Name = "ContentPadding"
ContentPadding.PaddingLeft = UDim.new(0, 6)
ContentPadding.PaddingBottom = UDim.new(0, 6)

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
ContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Name = "ContentList"

local MainFrameCorner = Instance.new("UICorner", MainFrame)
MainFrameCorner.Name = "MainFrameCorner"
MainFrameCorner.CornerRadius = UDim.new(0, 4)

local Topbar = Instance.new("Frame", MainFrame)
Topbar.BorderSizePixel = 0
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.AutomaticSize = Enum.AutomaticSize.Y
Topbar.Size = UDim2.new(0, 330, 0, 28)
Topbar.Position = UDim2.new(0, 56, 0, 48)
Topbar.Name = "Topbar"
Topbar.LayoutOrder = 1
Topbar.BackgroundTransparency = 1

local TopbarSizeCons = Instance.new("UISizeConstraint", Topbar)
TopbarSizeCons.MinSize = Vector2.new(0, 28)
TopbarSizeCons.Name = "TopbarSC"
TopbarSizeCons.MaxSize = Vector2.new(math.huge, 30)

local CloseBtn = Instance.new("TextButton", Topbar)
CloseBtn.TextWrapped = true
CloseBtn.BorderSizePixel = 0
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.FontFace = GothamFont
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.LayoutOrder = 3
CloseBtn.Text = "×"
CloseBtn.Name = "CloseBtn"
CloseBtn.Position = UDim2.new(0, 246, 0, -2)

local CloseBtnRatio = Instance.new("UIAspectRatioConstraint", CloseBtn)
CloseBtnRatio.Name = "CloseBtnRatio"

local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.Name = "CloseBtnCorner"
CloseBtnCorner.CornerRadius = UDim.new(0, 4)

local Title = Instance.new("TextLabel", Topbar)
Title.TextWrapped = true
Title.BorderSizePixel = 0
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = GothamFont
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 180, 0, 28)
Title.Text = "Universal | Wally West (R15)"
Title.LayoutOrder = 1
Title.AutomaticSize = Enum.AutomaticSize.Y
Title.Name = "Title"
Title.Position = UDim2.new(0, 2, 0, 2)

local TitlePadding = Instance.new("UIPadding", Title)
TitlePadding.PaddingTop = UDim.new(0, 4)
TitlePadding.PaddingRight = UDim.new(0, 4)
TitlePadding.Name = "TitlePadding"
TitlePadding.PaddingLeft = UDim.new(0, 4)
TitlePadding.PaddingBottom = UDim.new(0, 4)

local TitleStroke = Instance.new("UIStroke", Title)
TitleStroke.Transparency = 0.66
TitleStroke.Name = "TitleStroke"
TitleStroke.Thickness = 2

local MinimizeBtn = Instance.new("TextButton", Topbar)
MinimizeBtn.TextWrapped = true
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.TextScaled = true
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.FontFace = GothamFont
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.LayoutOrder = 2
MinimizeBtn.Text = "-"
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Position = UDim2.new(0, 216, 0, -2)

local MinimizeBtnRatio = Instance.new("UIAspectRatioConstraint", MinimizeBtn)
MinimizeBtnRatio.Name = "MinimizeBtnRatio"

local MinimizeBtnCorner = Instance.new("UICorner", MinimizeBtn)
MinimizeBtnCorner.Name = "MinimizeBtnCorner"
MinimizeBtnCorner.CornerRadius = UDim.new(0, 4)

local TopbarLayout = Instance.new("UIListLayout", Topbar)
TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
TopbarLayout.Padding = UDim.new(0, 2)
TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopbarLayout.Name = "TopbarList"
TopbarLayout.FillDirection = Enum.FillDirection.Horizontal

local Separator = Instance.new("Frame", MainFrame)
Separator.BorderSizePixel = 0
Separator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Separator.Size = UDim2.new(0, 276, 0, 2)
Separator.Position = UDim2.new(0, 2, 0, 33)
Separator.Name = "Separator"
Separator.LayoutOrder = 2
Separator.BackgroundTransparency = 0.5

local SeparatorSizeCons = Instance.new("UISizeConstraint", Separator)
SeparatorSizeCons.MinSize = Vector2.new(0, 2)
SeparatorSizeCons.Name = "TopbarSC"
SeparatorSizeCons.MaxSize = Vector2.new(math.huge, 3)

local SeparatorCorner = Instance.new("UICorner", Separator)
SeparatorCorner.Name = "SeparatorCorner"
SeparatorCorner.CornerRadius = UDim.new(1, 0)

local MainFrameLayout = Instance.new("UIListLayout", MainFrame)
MainFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
MainFrameLayout.Padding = UDim.new(0, 4)
MainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainFrameLayout.Name = "MainFrameList"

local MainFrameStroke = Instance.new("UIStroke", MainFrame)
MainFrameStroke.Transparency = 0.33
MainFrameStroke.Name = "MainFrameStroke"
MainFrameStroke.Thickness = 2

local MusicSound = Instance.new("Sound", WallyWestGui)
local musicAsset = GetAsset("WallyWest/Assets/music.mp3")
if musicAsset then
    MusicSound.SoundId = musicAsset
end
MusicSound.Looped = true
MusicSound.Volume = 1
MusicSound.PlaybackSpeed = 1
MusicSound.Name = "Music"

local ToggleSound = Instance.new("Sound", WallyWestGui)
ToggleSound.SoundId = "rbxassetid://139909368044571"
ToggleSound.Name = "ToggleSound"

local ColorCorrection = Instance.new("ColorCorrectionEffect", game.Lighting)
ColorCorrection.Contrast = 0.5
ColorCorrection.Saturation = 0.6
ColorCorrection.TintColor = Color3.fromRGB(87, 216, 255)
ColorCorrection.Name = "WallyWestBlueFX"
ColorCorrection.Enabled = false

local isToggled = false
local currentSpeed = 120
local targetSpeed = 120
local isMoving = false
local speedDecayConnection = nil
local renderConnection = nil
local speedCheckConnection = nil
local allTrails = {}
local auraEmitters = {}
local particleAuraObjects = {}
local originalAnimationIds = {}
local originalJumpPower = nil

local particlesEnabled = true
local blueFXEnabled = true
local musicEnabled = true

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

local function SaveOriginalAnims()
    local character = Player.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    
    originalAnimationIds = {
        walk = animate.walk.WalkAnim.AnimationId,
        run = animate.run.RunAnim.AnimationId,
        idle1 = animate.idle.Animation1.AnimationId,
        idle2 = animate.idle.Animation2.AnimationId,
        jump = animate.jump.JumpAnim.AnimationId,
        fall = animate.fall.FallAnim.AnimationId,
        climb = animate.climb.ClimbAnim.AnimationId
    }
end

local function RemoveAnims()
    local character = Player.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Jump = false
    end
end

local function ApplyAnims()
    local character = Player.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=121350640829746"
    animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=121350640829746"
    animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=135425213693488"
    animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=135579638960045"
    animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=104108770420406"
    animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=104108770420406"
    animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=421121499"
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Jump = false
    end
end

local function RestoreOriginalAnims()
    local character = Player.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    
    if originalAnimationIds.walk then animate.walk.WalkAnim.AnimationId = originalAnimationIds.walk end
    if originalAnimationIds.run then animate.run.RunAnim.AnimationId = originalAnimationIds.run end
    if originalAnimationIds.idle1 then animate.idle.Animation1.AnimationId = originalAnimationIds.idle1 end
    if originalAnimationIds.idle2 then animate.idle.Animation2.AnimationId = originalAnimationIds.idle2 end
    if originalAnimationIds.jump then animate.jump.JumpAnim.AnimationId = originalAnimationIds.jump end
    if originalAnimationIds.fall then animate.fall.FallAnim.AnimationId = originalAnimationIds.fall end
    if originalAnimationIds.climb then animate.climb.ClimbAnim.AnimationId = originalAnimationIds.climb end
end

local function SaveOriginalJumpPower()
    local character = Player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and originalJumpPower == nil then
        originalJumpPower = humanoid.JumpPower
    end
end

local function SetJumpPower(value)
    local character = Player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = value
    end
end

local function RestoreOriginalJumpPower()
    if originalJumpPower then
        SetJumpPower(originalJumpPower)
    else
        SetJumpPower(50)
    end
end

local function CreateTrail(part, offset0, offset1, width)
    local a0 = Instance.new("Attachment", part)
    local a1 = Instance.new("Attachment", part)
    a0.Position = offset0
    a1.Position = offset1
    
    local trail = Instance.new("Trail", part)
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = 0.3
    trail.LightEmission = 1
    trail.WidthScale = NumberSequence.new(width)
    trail.Color = ColorSequence.new(Color3.fromRGB(0, 220, 255), Color3.fromRGB(255, 255, 255))
    trail.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    }
    table.insert(allTrails, trail)
end

local function CreateAllTrails()
    local parts = {
        "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
        "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "HumanoidRootPart"
    }
    local offsetPairs = {
        {Vector3.new(0,0.3,0), Vector3.new(0,-0.3,0)},
        {Vector3.new(0.1,0.4,0), Vector3.new(0.1,-0.4,0)},
        {Vector3.new(-0.1,0.4,0), Vector3.new(-0.1,-0.4,0)},
        {Vector3.new(0.15,0.2,0.1), Vector3.new(0.15,-0.2,0.1)},
        {Vector3.new(-0.15,0.2,0.1), Vector3.new(-0.15,-0.2,0.1)},
        {Vector3.new(0.1,0,0.15), Vector3.new(0.1,0,-0.15)},
        {Vector3.new(-0.1,0,0.15), Vector3.new(-0.1,0,-0.15)},
    }
    for _, name in ipairs(parts) do
        local part = Player.Character:FindFirstChild(name)
        if part then
            for i, offsets in ipairs(offsetPairs) do
                local width = 0.05 + (i * 0.02)
                CreateTrail(part, offsets[1], offsets[2], width)
            end
        end
    end
end

local function RemoveAllTrails()
    for _, trail in ipairs(allTrails) do
        if trail and trail.Parent then trail:Destroy() end
    end
    table.clear(allTrails)
end

local function CreateAuraEmitter(part)
    local attachment = Instance.new("Attachment", part)
    local particle = Instance.new("ParticleEmitter", attachment)
    particle.Texture = "rbxassetid://3442350629"
    particle.Rate = 20
    particle.Lifetime = NumberRange.new(0.2, 0.4)
    particle.Speed = NumberRange.new(3, 6)
    particle.VelocitySpread = 360
    particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,1.2),NumberSequenceKeypoint.new(1,0.4)})
    particle.LightEmission = 1
    particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(1,1)})
    particle.Color = ColorSequence.new(Color3.fromRGB(0,255,255))
    particle.ZOffset = 1
    table.insert(auraEmitters, attachment)
end

local function CreateElectricAura()
    local parts = {
        "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
        "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "HumanoidRootPart"
    }
    for _, name in ipairs(parts) do
        local part = Player.Character:FindFirstChild(name)
        if part then CreateAuraEmitter(part) end
    end
end

local function RemoveElectricAura()
    for _, emitter in ipairs(auraEmitters) do
        if emitter and emitter.Parent then emitter:Destroy() end
    end
    table.clear(auraEmitters)
end

local function CreateParticleAura()
    if not Player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = Player.Character
    highlight.FillTransparency = 0.875
    highlight.FillColor = Color3.fromRGB(87, 216, 255)
    highlight.OutlineColor = Color3.fromRGB(180, 240, 255)
    highlight.OutlineTransparency = 0.65
    highlight.DepthMode = "Occluded"
    highlight.Parent = Player.Character
    table.insert(particleAuraObjects, highlight)

    for _, part in next, Player.Character:GetDescendants() do
        if part:IsA("BasePart") then
            local particle = Instance.new("ParticleEmitter")
            particle.Rate = 1000
            particle.LockedToPart = true
            particle.Texture = "rbxassetid://11745241946"
            particle.Lifetime = NumberRange.new(0.375, 0.375)
            particle.Size = NumberSequence.new(0.435, 0.435)
            particle.ZOffset = -1
            particle.Speed = NumberRange.new(0, 0)
            particle.LightEmission = 1
            particle.Color = ColorSequence.new(Color3.fromRGB(87, 216, 255), Color3.fromRGB(200, 255, 255))
            particle.Parent = part
            table.insert(particleAuraObjects, particle)
        end
    end
end

local function RemoveParticleAura()
    for _, obj in ipairs(particleAuraObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    table.clear(particleAuraObjects)
end

local function RemoveEffects()
    RemoveAllTrails()
    RemoveElectricAura()
    RemoveParticleAura()
end

local function CreateEffects()
    RemoveEffects()
    CreateAllTrails()
    CreateElectricAura()
    CreateParticleAura()
end

local function StartSpeedDecay()
    if speedDecayConnection then speedDecayConnection:Disconnect() end
    speedDecayConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not isToggled then return end
        if not isMoving then
            targetSpeed = math.max(120, targetSpeed - (deltaTime * 50))
            if targetSpeed <= 120 then
                targetSpeed = 120
                if speedDecayConnection then
                    speedDecayConnection:Disconnect()
                    speedDecayConnection = nil
                end
            end
        end
    end)
end

local function UpdateSpeed()
    local character = Player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if currentSpeed ~= targetSpeed then
        currentSpeed = currentSpeed + ((targetSpeed - currentSpeed) * 0.2)
        if math.abs(currentSpeed - targetSpeed) < 0.5 then
            currentSpeed = targetSpeed
        end
        humanoid.WalkSpeed = currentSpeed
    end
end

local function OnMove(isMovingNow)
    if isMovingNow == isMoving then return end
    isMoving = isMovingNow
    
    if isMoving then
        if speedDecayConnection then
            speedDecayConnection:Disconnect()
            speedDecayConnection = nil
        end
    else
        StartSpeedDecay()
    end
end

local function StartBoost()
    local character = Player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    currentSpeed = 120
    targetSpeed = 120
    isMoving = false
    
    if speedDecayConnection then speedDecayConnection:Disconnect() end
    
    if renderConnection then renderConnection:Disconnect() end
    renderConnection = RunService.RenderStepped:Connect(function()
        if not isToggled then return end
        
        local character = Player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
        
        if humanoid and rootPart then
            local velocity = rootPart.AssemblyLinearVelocity
            local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
            local isPlayerMoving = horizontalSpeed > 5
            
            OnMove(isPlayerMoving)
            
            if isMoving and isToggled then
                targetSpeed = math.min(700, targetSpeed + (RunService.RenderStepped:Wait() * 25))
            end
            
            UpdateSpeed()
            
            if blueFXEnabled then
                local speedIntensity = math.min((currentSpeed - 120) / 580, 1.5)
                local pulse = tick() * 10
                local intensityPulse = 0.5 + (math.sin(pulse) * 0.15) + (speedIntensity * 0.3)
                ColorCorrection.Contrast = 0.5 + (intensityPulse * 0.2)
                ColorCorrection.Saturation = 0.6 + (intensityPulse * 0.4)
                ColorCorrection.TintColor = Color3.fromRGB(
                    87 + (speedIntensity * 50),
                    216 - (speedIntensity * 20),
                    255
                )
            end
        end
    end)
    
    if speedCheckConnection then speedCheckConnection:Disconnect() end
    speedCheckConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if isToggled and humanoid.WalkSpeed ~= currentSpeed and humanoid.WalkSpeed ~= 0 then
            humanoid.WalkSpeed = currentSpeed
        end
    end)
end

local function StopBoost()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    if speedDecayConnection then
        speedDecayConnection:Disconnect()
        speedDecayConnection = nil
    end
    if speedCheckConnection then
        speedCheckConnection:Disconnect()
        speedCheckConnection = nil
    end
    
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
    
    currentSpeed = 120
    targetSpeed = 120
    isMoving = false
end

local function FullCleanup()
    if isToggled then
        StopBoost()
        RemoveEffects()
        ColorCorrection.Enabled = false
        MusicSound:Stop()
        RestoreOriginalAnims()
        RestoreOriginalJumpPower()
        isToggled = false
        Label.Text = "Toggle: Off"
    end
    if renderConnection then renderConnection:Disconnect() end
    if speedDecayConnection then speedDecayConnection:Disconnect() end
    if speedCheckConnection then speedCheckConnection:Disconnect() end
end

local function OnMainToggle()
    isToggled = not isToggled
    
    if isToggled then
        ToggleSound:Play()
        Label.Text = "Toggle: On"
        
        SaveOriginalAnims()
        SaveOriginalJumpPower()
        RemoveAnims()
        ApplyAnims()
        SetJumpPower(120)
        
        if particlesEnabled then
            CreateEffects()
        end
        
        StartBoost()
        
        if musicEnabled then
            MusicSound:Play()
        end
        
        if blueFXEnabled then
            ColorCorrection.Enabled = true
        end
        
    else
        ToggleSound:Play()
        Label.Text = "Toggle: Off"
        
        StopBoost()
        RemoveEffects()
        
        ColorCorrection.Enabled = false
        ColorCorrection.Contrast = 0.5
        ColorCorrection.Saturation = 0.6
        
        MusicSound:Stop()
        RestoreOriginalAnims()
        RestoreOriginalJumpPower()
    end
end

local function OnParticlesToggle()
    particlesEnabled = not particlesEnabled
    Label2.Text = particlesEnabled and "Particles: On" or "Particles: Off"
    if isToggled then
        if particlesEnabled then
            CreateEffects()
        else
            RemoveEffects()
        end
    end
end

local function OnBlueFXToggle()
    blueFXEnabled = not blueFXEnabled
    Label3.Text = blueFXEnabled and "Blue Effect: On" or "Blue Effect: Off"
    if isToggled then
        ColorCorrection.Enabled = blueFXEnabled
    end
    if not blueFXEnabled and not isToggled then
        ColorCorrection.Enabled = false
        ColorCorrection.Contrast = 0.5
        ColorCorrection.Saturation = 0.6
    end
end

local function OnMusicToggle()
    musicEnabled = not musicEnabled
    Label4.Text = musicEnabled and "Music: On" or "Music: Off"
    if isToggled and musicEnabled then
        MusicSound:Play()
    elseif not musicEnabled then
        MusicSound:Stop()
    end
end

local minimized = false
local minimizeTween = nil
local function ToggleMinimize()
    minimized = not minimized
    local targetHeight = minimized and 32 or 190
    if minimizeTween then minimizeTween:Cancel() end
    minimizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, 280, 0, targetHeight)
    })
    minimizeTween:Play()
    MinimizeBtn.Text = minimized and "+" or "-"
    for _, child in pairs(Content:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = not minimized
        end
    end
end

Toggle.MouseButton1Click:Connect(OnMainToggle)
Music.MouseButton1Click:Connect(OnMusicToggle)
ParticlesBtn.MouseButton1Click:Connect(OnParticlesToggle)
BlueFX.MouseButton1Click:Connect(OnBlueFXToggle)
MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
CloseBtn.MouseButton1Click:Connect(function()
    FullCleanup()
    WallyWestGui:Destroy()
    ColorCorrection:Destroy()
    getgenv().WallyWest.isLoaded = false
end)

local function OnCharacterAdded(character)
    if isToggled then
        task.wait(0.5)
        SaveOriginalAnims()
        SaveOriginalJumpPower()
        RemoveAnims()
        ApplyAnims()
        SetJumpPower(120)
        if particlesEnabled then
            CreateEffects()
        end
        StartBoost()
    end
end

local function OnCharacterDeath()
    if isToggled then
        ToggleSound:Play()
        Label.Text = "Toggle: Off"
        StopBoost()
        RemoveEffects()
        ColorCorrection.Enabled = false
        MusicSound:Stop()
        RestoreOriginalAnims()
        RestoreOriginalJumpPower()
        isToggled = false
    end
end

Player.CharacterAdded:Connect(OnCharacterAdded)
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(OnCharacterDeath)
end)

if Player.Character then
    local humanoid = Player.Character:FindFirstChild("Humanoid")
    if humanoid then
        originalJumpPower = humanoid.JumpPower
        humanoid.Died:Connect(OnCharacterDeath)
    end
end

Dragify(MainFrame)
