getgenv().MusicPLR = getgenv().MusicPLR or {}

if getgenv().MusicPLR.isLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Music Player",
        Text = "Music Player is already running!",
        Duration = 4
    })
    error("Music Player is already running", 0)
end

getgenv().MusicPLR.isLoaded = true

local UI = {};

UI["MusicPlayer_1"] = Instance.new("ScreenGui", game.CoreGui);
UI["MusicPlayer_1"]["Name"] = [[MusicPlayer]];
UI["MusicPlayer_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


UI["MainScript_2"] = Instance.new("LocalScript", UI["MusicPlayer_1"]);
UI["MainScript_2"]["Name"] = [[MainScript]];


UI["ToggleBtn_3"] = Instance.new("ImageButton", UI["MusicPlayer_1"]);
UI["ToggleBtn_3"]["BorderSizePixel"] = 0;
UI["ToggleBtn_3"]["BackgroundTransparency"] = 1;
-- UI["ToggleBtn_3"]["ImageContent"] = ;
UI["ToggleBtn_3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["ToggleBtn_3"]["Image"] = [[rbxassetid://129731700727303]];
UI["ToggleBtn_3"]["Size"] = UDim2.new(0, 44, 0, 44);
UI["ToggleBtn_3"]["Name"] = [[ToggleBtn]];
UI["ToggleBtn_3"]["Position"] = UDim2.new(0.07698, 0, 0.00566, 0);


UI["UIPadding_4"] = Instance.new("UIPadding", UI["ToggleBtn_3"]);
UI["UIPadding_4"]["PaddingTop"] = UDim.new(0, 10);
UI["UIPadding_4"]["PaddingRight"] = UDim.new(0, 10);
UI["UIPadding_4"]["PaddingLeft"] = UDim.new(0, 10);
UI["UIPadding_4"]["PaddingBottom"] = UDim.new(0, 10);


UI["UIAspectRatioConstraint_5"] = Instance.new("UIAspectRatioConstraint", UI["ToggleBtn_3"]);



UI["ImageLabel_6"] = Instance.new("ImageLabel", UI["ToggleBtn_3"]);
UI["ImageLabel_6"]["BorderSizePixel"] = 0;
UI["ImageLabel_6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
-- UI["ImageLabel_6"]["ImageContent"] = ;
UI["ImageLabel_6"]["Image"] = [[rbxassetid://7059338404]];
UI["ImageLabel_6"]["Size"] = UDim2.new(1, 0, 1, 0);
UI["ImageLabel_6"]["BackgroundTransparency"] = 1;


UI["MainFrame_7"] = Instance.new("Frame", UI["MusicPlayer_1"]);
UI["MainFrame_7"]["BorderSizePixel"] = 0;
UI["MainFrame_7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["MainFrame_7"]["Size"] = UDim2.new(0, 284, 0, 184);
UI["MainFrame_7"]["Position"] = UDim2.new(0.13771, 0, 0.0181, 0);
UI["MainFrame_7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["MainFrame_7"]["Name"] = [[MainFrame]];
UI["MainFrame_7"]["BackgroundTransparency"] = 0.2;


UI["NameSong_8"] = Instance.new("TextLabel", UI["MainFrame_7"]);
UI["NameSong_8"]["TextWrapped"] = true;
UI["NameSong_8"]["BorderSizePixel"] = 0;
UI["NameSong_8"]["TextSize"] = 14;
UI["NameSong_8"]["TextScaled"] = true;
UI["NameSong_8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["NameSong_8"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
UI["NameSong_8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["NameSong_8"]["BackgroundTransparency"] = 1;
UI["NameSong_8"]["Size"] = UDim2.new(0.74167, 0, 0.2193, 0);
UI["NameSong_8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["NameSong_8"]["Name"] = [[NameSong]];
UI["NameSong_8"]["Position"] = UDim2.new(0.13056, 0, 0.07456, 0);


UI["UIAspectRatioConstraint_9"] = Instance.new("UIAspectRatioConstraint", UI["NameSong_8"]);
UI["UIAspectRatioConstraint_9"]["AspectRatio"] = 5.34;


UI["Previous_a"] = Instance.new("ImageButton", UI["MainFrame_7"]);
UI["Previous_a"]["BorderSizePixel"] = 0;
UI["Previous_a"]["BackgroundTransparency"] = 1;
-- UI["Previous_a"]["ImageContent"] = ;
UI["Previous_a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Previous_a"]["Image"] = [[rbxassetid://12008863261]];
UI["Previous_a"]["Size"] = UDim2.new(0.15833, 0, 0.25, 0);
UI["Previous_a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["Previous_a"]["Name"] = [[Previous]];
UI["Previous_a"]["Rotation"] = -180;
UI["Previous_a"]["Position"] = UDim2.new(0.19167, 0, 0.53947, 0);


UI["UIAspectRatioConstraint_b"] = Instance.new("UIAspectRatioConstraint", UI["Previous_a"]);



UI["UIAspectRatioConstraint_c"] = Instance.new("UIAspectRatioConstraint", UI["MainFrame_7"]);
UI["UIAspectRatioConstraint_c"]["AspectRatio"] = 1.579;


UI["UIStroke_d"] = Instance.new("UIStroke", UI["MainFrame_7"]);
UI["UIStroke_d"]["Transparency"] = 0.33;
UI["UIStroke_d"]["Thickness"] = 3;


UI["BarBackground_e"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["BarBackground_e"]["BorderSizePixel"] = 0;
UI["BarBackground_e"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["BarBackground_e"]["Size"] = UDim2.new(0.90833, 0, 0.01754, 0);
UI["BarBackground_e"]["Position"] = UDim2.new(0.04722, 0, 0.42544, 0);
UI["BarBackground_e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["BarBackground_e"]["Name"] = [[BarBackground]];


UI["UICorner_f"] = Instance.new("UICorner", UI["BarBackground_e"]);
UI["UICorner_f"]["CornerRadius"] = UDim.new(1, 0);


UI["Bar_10"] = Instance.new("Frame", UI["BarBackground_e"]);
UI["Bar_10"]["BorderSizePixel"] = 0;
UI["Bar_10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Bar_10"]["Size"] = UDim2.new(0, 0, 0, 4);
UI["Bar_10"]["Position"] = UDim2.new(-0.00171, 0, -0.07454, 0);
UI["Bar_10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["Bar_10"]["Name"] = [[Bar]];


UI["UICorner_11"] = Instance.new("UICorner", UI["Bar_10"]);
UI["UICorner_11"]["CornerRadius"] = UDim.new(1, 0);


UI["Next_12"] = Instance.new("ImageButton", UI["MainFrame_7"]);
UI["Next_12"]["BorderSizePixel"] = 0;
UI["Next_12"]["BackgroundTransparency"] = 1;
-- UI["Next_12"]["ImageContent"] = ;
UI["Next_12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Next_12"]["Image"] = [[rbxassetid://12008863261]];
UI["Next_12"]["Size"] = UDim2.new(0.15833, 0, 0.25, 0);
UI["Next_12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["Next_12"]["Name"] = [[Next]];
UI["Next_12"]["Position"] = UDim2.new(0.66944, 0, 0.53947, 0);


UI["UIAspectRatioConstraint_13"] = Instance.new("UIAspectRatioConstraint", UI["Next_12"]);



UI["UICorner_14"] = Instance.new("UICorner", UI["MainFrame_7"]);
UI["UICorner_14"]["CornerRadius"] = UDim.new(0, 10);


UI["UIGradient_15"] = Instance.new("UIGradient", UI["MainFrame_7"]);
UI["UIGradient_15"]["Rotation"] = 90;
UI["UIGradient_15"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(52, 52, 52)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(6, 6, 6))};


UI["SongDuration_16"] = Instance.new("TextLabel", UI["MainFrame_7"]);
UI["SongDuration_16"]["TextWrapped"] = true;
UI["SongDuration_16"]["BorderSizePixel"] = 0;
UI["SongDuration_16"]["TextSize"] = 14;
UI["SongDuration_16"]["TextScaled"] = true;
UI["SongDuration_16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["SongDuration_16"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
UI["SongDuration_16"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["SongDuration_16"]["BackgroundTransparency"] = 1;
UI["SongDuration_16"]["Size"] = UDim2.new(0.55556, 0, 0.0614, 0);
UI["SongDuration_16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["SongDuration_16"]["Name"] = [[SongDuration]];
UI["SongDuration_16"]["Position"] = UDim2.new(0.21944, 0, 0.35965, 0);


UI["UIAspectRatioConstraint_17"] = Instance.new("UIAspectRatioConstraint", UI["SongDuration_16"]);
UI["UIAspectRatioConstraint_17"]["AspectRatio"] = 14.28572;


UI["Loop_18"] = Instance.new("ImageButton", UI["MainFrame_7"]);
UI["Loop_18"]["BorderSizePixel"] = 0;
UI["Loop_18"]["BackgroundTransparency"] = 1;
-- UI["Loop_18"]["ImageContent"] = ;
UI["Loop_18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Loop_18"]["Image"] = [[rbxassetid://127077202039990]];
UI["Loop_18"]["Size"] = UDim2.new(0, 24, 0, 24);
UI["Loop_18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["Loop_18"]["Name"] = [[Loop]];
UI["Loop_18"]["Position"] = UDim2.new(0.01201, 0, 0.84242, 0);


UI["UIDragDetector_19"] = Instance.new("UIDragDetector", UI["MainFrame_7"]);
UI["UIDragDetector_19"]["DragUDim2"] = UDim2.new(0, -1, 0, 1);


UI["Pause_1a"] = Instance.new("ImageButton", UI["MainFrame_7"]);
UI["Pause_1a"]["BorderSizePixel"] = 0;
UI["Pause_1a"]["BackgroundTransparency"] = 1;
-- UI["Pause_1a"]["ImageContent"] = ;
UI["Pause_1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Pause_1a"]["Image"] = [[rbxassetid://12099513379]];
UI["Pause_1a"]["Size"] = UDim2.new(0.15833, 0, 0.25, 0);
UI["Pause_1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
UI["Pause_1a"]["Name"] = [[Pause]];
UI["Pause_1a"]["Position"] = UDim2.new(0.41944, 0, 0.53947, 0);


UI["UIAspectRatioConstraint_1b"] = Instance.new("UIAspectRatioConstraint", UI["Pause_1a"]);

local function C_2()
    local script = UI["MainScript_2"]
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local UIS = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    
    local songPlayer = script.Parent
    local mainFrame = songPlayer:WaitForChild("MainFrame")
    local barBackground = mainFrame:WaitForChild("BarBackground")
    local bar = barBackground:WaitForChild("Bar")
    local nextButton = mainFrame:WaitForChild("Next")
    local previousButton = mainFrame:WaitForChild("Previous")
    local pauseButton = mainFrame:WaitForChild("Pause")
    local nameSongLabel = mainFrame:WaitForChild("NameSong")
    local songDurationLabel = mainFrame:WaitForChild("SongDuration")
    local loopButton = mainFrame:WaitForChild("Loop")
    local toggleButton = songPlayer:WaitForChild("ToggleBtn")
    
    local isMobile = UIS.TouchEnabled and (
        UIS:GetPlatform() == Enum.Platform.Android
        or UIS:GetPlatform() == Enum.Platform.IOS
    )

    local function updateTogglePosition()
        if CoreGui:FindFirstChild("ModernTouchGui") or CoreGui:FindFirstChild("SChat") then
            toggleButton.Position = UDim2.new(0, 64, 0, 2)
        else
            toggleButton.Position = UDim2.new(0.0197599996, 0, 0.00286999997, 0)
        end
    end

    updateTogglePosition()

    CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "ModernTouchGui" or child.Name == "SChat" then
            updateTogglePosition()
        end
    end)

    CoreGui.ChildRemoved:Connect(function(child)
        if child.Name == "ModernTouchGui" or child.Name == "SChat" then
            updateTogglePosition()
        end
    end)
    
    toggleButton.Visible = true
    mainFrame.Visible = false
    
    local folderName = "MusicPlayer"
    if not isfolder(folderName) then makefolder(folderName) end
    
    local songs = {}
    for _, file in ipairs(listfiles(folderName)) do
        if file:sub(-4):lower() == ".mp3" then
            table.insert(songs, file)
        end
    end
    
    if #songs == 0 then
        StarterGui:SetCore("SendNotification", {
            Title = "Music Player",
            Text = "No songs found. Add MP3s to the MusicPlayer folder.",
            Duration = 5
        })
        songPlayer:Destroy()
        return
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Music Player",
            Text = #songs.." song(s) loaded from MusicPlayer folder.",
            Duration = 5
        })
    end
    
    local currentSongIndex = 1
    local currentSound = nil
    local isPaused = false
    local currentTween = nil
    local currentSongTime = 0
    local defaultPauseImage = "rbxassetid://13980756617"
    local pausedImage = "rbxassetid://12099513379"
    local defaultLoopColor = loopButton.ImageColor3
    local loopisLoadedColor = Color3.fromRGB(0, 170, 255)
    local fadeTime = 0.5
    local fadeTweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Linear)
    local lastMainFramePosition = mainFrame.Position
    local isLooping = false
    
    local function formatTime(seconds)
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = math.floor(seconds % 60)
        return string.format("%d:%02d", minutes, remainingSeconds)
    end
    
    local function updateSongDurationLabel()
        if not currentSound then return end
        songDurationLabel.Text = formatTime(currentSongTime).." / "..formatTime(currentSound.TimeLength)
    end
    
    local function fadeOut(sound)
        if not sound then return end
        local tween = TweenService:Create(sound, fadeTweenInfo, {Volume = 0})
        tween:Play()
        tween.Completed:Wait()
    end
    
    local function fadeIn(sound)
        if not sound then return end
        sound.Volume = 0
        local tween = TweenService:Create(sound, fadeTweenInfo, {Volume = 0.5})
        tween:Play()
    end
    
    local function updateProgressBar(sound, startTime)
        if not sound then return end
        bar.Visible = true
        if currentTween then currentTween:Cancel() currentTween = nil end
        local remainingTime = sound.TimeLength - startTime
        local startProgress = startTime / sound.TimeLength
        bar.Size = UDim2.new(startProgress, 0, 1, 0)
        if isPaused then return end
        local tweenInfo = TweenInfo.new(remainingTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
        currentTween = TweenService:Create(bar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
        currentTween:Play()
    end
    
    local function stopCurrentSong()
        if currentSound then fadeOut(currentSound) currentSound:Stop() currentSound = nil end
        if currentTween then currentTween:Cancel() currentTween = nil end
        bar.Size = UDim2.new(0, 0, 1, 0)
        currentSongTime = 0
        updateSongDurationLabel()
    end
    
    local function playSong(index)
        if #songs == 0 then return end
        stopCurrentSong()
        if index < 1 then index = #songs elseif index > #songs then index = 1 end
        currentSongIndex = index
        local path = songs[currentSongIndex]
        if not path then return end
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = getcustomasset(path)
        sound.Volume = 0.5
        local filename = path:match("([^/\\]+)$")
        filename = filename:gsub("%.mp3$", "")
        nameSongLabel.Text = filename
        sound:Play()
        fadeIn(sound)
        currentSound = sound
        currentSongTime = 0
        bar.Visible = true
        updateProgressBar(sound, 0)
        isPaused = false
        pauseButton.Image = defaultPauseImage
        sound.Ended:Connect(function()
            if sound == currentSound then
                if isLooping then
                    playSong(currentSongIndex)
                else
                    playSong(currentSongIndex + 1)
                end
            end
        end)
    end
    
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if currentSound and currentSound.IsPlaying and not isPaused then
                currentSongTime = currentSound.TimePosition
                updateSongDurationLabel()
                updateProgressBar(currentSound, currentSongTime)
            end
        end)
    end)
    
    pauseButton.MouseButton1Click:Connect(function()
        if not currentSound then return end
        isPaused = not isPaused
        if isPaused then
            fadeOut(currentSound)
            currentSound:Pause()
            pauseButton.Image = pausedImage
            if currentTween then currentTween:Cancel() currentTween = nil end
        else
            currentSound:Resume()
            fadeIn(currentSound)
            pauseButton.Image = defaultPauseImage
            currentSongTime = currentSound.TimePosition
            updateProgressBar(currentSound, currentSongTime)
        end
    end)
    
    nextButton.MouseButton1Click:Connect(function()
        playSong(currentSongIndex + 1)
    end)
    
    previousButton.MouseButton1Click:Connect(function()
        playSong(currentSongIndex - 1)
    end)
    
    loopButton.MouseButton1Click:Connect(function()
        isLooping = not isLooping
        loopButton.ImageColor3 = isLooping and loopisLoadedColor or defaultLoopColor
    end)
    
    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    local guideFile = "MusicPlayerGuideSeen.txt"
    local buttonGuide = {
        {icon = nextButton.Image, title = "Next Button (The one on the right)", text = "Plays next song"},
        {icon = previousButton.Image, title = "Previous Button (The one on the left)", text = "Plays previous song"},
        {icon = defaultPauseImage, title = "Pause Button", text = "Pauses/resumes current song"},
        {icon = loopButton.Image, title = "Loop Button", text = "Toggles looping of current song"}
    }
    if not isfile(guideFile) then
        for i, info in ipairs(buttonGuide) do
            task.delay((i-1)*2, function()
                StarterGui:SetCore("SendNotification", {
                    Title = info.title,
                    Text = info.text,
                    Icon = info.icon,
                    Duration = 2
                })
            end)
        end
        writefile(guideFile, "seen")
    end
    
    playSong(currentSongIndex)
end

task.spawn(C_2)

return UI["MusicPlayer_1"]
