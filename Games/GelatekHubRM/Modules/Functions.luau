local Global = (getgenv and getgenv()) or shared
local getsynasset = getsynasset or getcustomasset or function() warn("no getcustomasset/getsynasset") end

Global.Notification = function(Title, Text, Duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = Title or "",
		Text = Text or "",
		Duration = Duration or 3
	})
end

Global.AntiScript = function()
	local part = Instance.new("Part")
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.Name = "ScriptCheck"
	part.Parent = game:FindFirstChildOfClass("TestService")
end

Global.AlignPart = function(Part0, Part1, Position, Orientation)
	Part0:BreakJoints()
	local Attachment0 = Instance.new("Attachment")
	Attachment0.Name = "Att0"
	Attachment0.Position = Position or Vector3.new()
	Attachment0.Orientation = Orientation or Vector3.new()
	Attachment0.Parent = Part0
	
	local Attachment1 = Instance.new("Attachment")
	Attachment1.Name = "Att1"
	Attachment1.Parent = Part1
	
	local AlignPosition = Instance.new("AlignPosition")
	AlignPosition.MaxForce = math.huge
	AlignPosition.Responsiveness = 200
	AlignPosition.Attachment0 = Attachment0
	AlignPosition.Attachment1 = Attachment1
	AlignPosition.Parent = Part0
	
	local AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.MaxTorque = 9e9
	AlignOrientation.Responsiveness = 200
	AlignOrientation.Attachment0 = Attachment0
	AlignOrientation.Attachment1 = Attachment1
	AlignOrientation.Parent = Part0
end

Global.GetLoadLibrary = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Games/GelatekHubRM/Modules/Utilities.luau"))()
end

Global.StopScript = function()
	if game:GetService("Players").LocalPlayer.Character.Name ~= "GelatekReanimate" then
        Notification("Not Reanimated")
		error("Not Reanimated")
	end
	local Global = (getgenv and getgenv()) or shared
	Global.PartDisconnected = false
	local function CreateJoint(Name,Part0,Part1,C0,C1)
		local Joint = Instance.new("Motor6D")
		Joint.Parent = Part0
		Joint.Name = Name
		Joint.Part0 = Part0
		Joint.Part1 = Part1
		Joint.C0 = C0
		Joint.C1 = C1
	end
	
	Global.Stopped = true
	for i,v in pairs(Global.TableOfEvents) do
		v:Disconnect()
	end

	local Figure = workspace:WaitForChild("GelatekReanimate")
	local Character = Figure:FindFirstChild(game:FindFirstChildOfClass("Players").LocalPlayer.Name)
	local TestServ = game:GetService("TestService")
	local Humanoid = Figure:FindFirstChildOfClass("Humanoid")
	
	for _,v in pairs(Humanoid:GetChildren()) do
		if v:IsA("Animator") then
			v:Destroy()
		end
		local NewAnimator = Instance.new("Animator", Humanoid)
	end
	if not Figure:FindFirstChild("Animate") then
		local Script = Instance.new("LocalScript")
		Script.Name = "Animate"
		Script.Parent = Figure
	end
	Humanoid.Name = "Humanoid"
	Humanoid.WalkSpeed = 16
	Humanoid.JumpPower = 50
	Humanoid.AutoRotate = true
	Humanoid.HipHeight = 0
	Humanoid.MaxHealth = 100
	Humanoid.Health = 100
	Humanoid.CameraOffset = Vector3.new()
	workspace.CurrentCamera.FieldOfView = 70
	
	for _,v in pairs(Figure:GetChildren()) do
		if v.ClassName ~= "Accessory" and v.Name ~= game.Players.LocalPlayer.Name and v.Name ~= "Head" and v.Name ~= "Torso" and 
			v.Name ~= "Right Arm" and v.Name ~= "Left Arm" and v.Name ~= "Right Leg" and v.Name ~= "Left Leg" and v.Name ~= "HumanoidRootPart" and v.Name ~= "Humanoid"
			and v.Name ~= "BodyColors" and v.Name ~= "Pants" and v.Name ~= "Shirt" and v.Name ~= "Animate" then
			v:Destroy()
		end
	end
	
	local Head, Torso, Root = Figure.Head, Figure.Torso, Figure.HumanoidRootPart
	local RA, LA, RL, LL = Figure["Right Arm"], Figure["Left Arm"], Figure["Right Leg"], Figure["Left Leg"]
	Root.Anchored = true
	for _,v in pairs(Head:GetDescendants()) do
		if v:IsA("BillboardGui") then
			v:Destroy()
		end
	end
	for _,v in pairs(Torso:GetDescendants()) do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
		if v:IsA("PointLight") then
			v:Destroy()
		end
		if v:IsA("Weld") then
			v:Destroy()
		end
		if v:IsA("ManualWeld") then
			v:Destroy()
		end
		if v:IsA("Sound") then
			v:Destroy()
		end
	end
	
	for _,v in pairs(Head:GetDescendants()) do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
		if v:IsA("PointLight") then
			v:Destroy()
		end
		if v:IsA("Weld") then
			v:Destroy()
		end
		if v:IsA("ManualWeld") then
			v:Destroy()
		end
		if v:IsA("Sound") then
			v:Destroy()
		end
	end
	
	Root:BreakJoints()
	CreateJoint("Neck",Torso,Head,CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0))
	CreateJoint("RootJoint",Root,Torso,CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0))
	CreateJoint("Right Shoulder",Torso,RA,CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0))
	CreateJoint("Left Shoulder",Torso,LA,CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0))
	CreateJoint("Right Hip",Torso,RL,CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0))
	CreateJoint("Left Hip",Torso,LL,CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0))

	for i,v in pairs(Figure:GetChildren()) do
		if v:IsA("Accessory") then
			if v.Handle:FindFirstChildOfClass("Weld") then
				v.Handle:FindFirstChildOfClass("Weld"):Destroy()
			end
			for i2,v2 in pairs(v.Handle:GetDescendants()) do
				if v2:IsA("AlignPosition") or v2:IsA("AlignOrientation") or v2.Name == "Att0" then
					v2:Destroy()
				end
			end
		end
	end
	local Hats = TestServ:FindFirstChild("FakeHats") 
	for i,v in pairs(Hats:GetChildren()) do
		local FakeWeld = v.Handle:FindFirstChild("AccessoryWeld"):Clone()
		FakeWeld.Part0 = Figure:FindFirstChild(v.Name).Handle
		FakeWeld.Part1 = Figure:FindFirstChild(FakeWeld.Part1.Name)
		FakeWeld.Parent = Figure:FindFirstChild(v.Name).Handle
	end
	
	if game:FindFirstChildOfClass("TestService"):FindFirstChild("ScriptCheck") then
		game:FindFirstChildOfClass("TestService"):FindFirstChild("ScriptCheck"):Destroy()
	end
	if Character:FindFirstChild("Bullet") then
		local blt = Character:FindFirstChild("Bullet")
		if blt:FindFirstChild("Flinger") then blt:FindFirstChild("Flinger"):Destroy() end
		if blt:FindFirstChild("Movement") then blt:FindFirstChild("Movement"):Destroy() end
	end
	task.wait(0.125)
	Global.Stopped = false
	Root.Anchored = false
	Root.CFrame = Root.CFrame * CFrame.new(0,5,0)
end

Global.PlayAnimation = function(ID,AudioPath)
	if game:GetService("Players").LocalPlayer.Character.Name ~= "GelatekReanimate" then
		Notification("Not Reanimated")
		error("Not Reanimated")
	end
	if game:FindFirstChildOfClass("TestService"):FindFirstChild("ScriptCheck") then
		StopScript()
	end
	local Character = game.Players.LocalPlayer.Character
	Character["Humanoid"].WalkSpeed = 8
	local CurrentID = ID
	local AnimationModel = game:GetObjects("rbxassetid://"..tostring(CurrentID))[1]
	local AnimPlayer = AnimationModel
	AnimPlayer.Name = "AnimPlayer"
	AnimPlayer.Parent = Character

	Global.AntiScript()
	task.wait(1)

	local Torso = Character:WaitForChild("Torso")
	local N,RJ = Torso["Neck"],Character["HumanoidRootPart"]["RootJoint"]
	local RS,LS = Torso["Right Shoulder"],Torso["Left Shoulder"]
	local RH,LH = Torso["Right Hip"],Torso["Left Hip"]
	local Frames = {}
	local Positions = {}
	local Sound = Instance.new("Sound")
	Sound.Parent = Character.Torso
	Sound.Looped = true
	Sound.Name = "Music"
	Sound.Volume = 1
	if AudioPath then
		pcall(function()
			Sound.SoundId = getsynasset(AudioPath)
		end)
		Sound:Play()
	end

	for i,v in pairs(AnimPlayer:GetChildren()) do
		table.insert(Frames, v.Time)
		Positions[v.Time] = {}
		for _,g in pairs(v:GetDescendants()) do 
			g.Parent = v; table.insert(Positions[v.Time],g)
		end
	end
	if Character.Humanoid:FindFirstChild("Animator") then
		Character.Humanoid.Animator:Destroy()
	end
	while true do
		if Global.Stopped == true then break end
		for i,v in pairs(Frames) do
			task.spawn(function()
				if Global.Stopped == true then return end
				if Frames[i-1] then
					task.wait(Frames[i-1])
				end
				for i2,v2 in pairs(Positions[v]) do
					if v2.Name == "Right Arm" then
						RS.Transform = v2.CFrame
					end
					if v2.Name == "Left Arm" then
						LS.Transform = v2.CFrame
					end
					if v2.Name == "Right Leg" then
						RH.Transform = v2.CFrame
					end
					if v2.Name == "Left Leg" then
						LH.Transform = v2.CFrame
					end
					if v2.Name == "Torso" then
						RJ.Transform = v2.CFrame
					end
					if v2.Name == "Head" then
						N.Transform = v2.CFrame
					end
				end
			end)
		end
		task.wait(Frames[#Frames])
	end
	Sound:Destroy()
	AnimationModel:Destroy()
end