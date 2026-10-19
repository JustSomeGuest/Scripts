--[[
	Model Viewer App Module
	
	A model viewer :3
]]

-- Common Locals
local Main,Lib,Apps,Settings -- Main Containers
local Explorer, Properties, ScriptViewer, ModelViewer, Notebook -- Major Apps
local API,RMD,env,service,plr,create,createSimple -- Main Locals

local function initDeps(data)
	Main = data.Main
	Lib = data.Lib
	Apps = data.Apps
	Settings = data.Settings

	API = data.API
	RMD = data.RMD
	env = data.env
	service = data.service
	plr = data.plr
	create = data.create
	createSimple = data.createSimple
end

local function initAfterMain()
	Explorer = Apps.Explorer
	Properties = Apps.Properties
	ScriptViewer = Apps.ScriptViewer
	Notebook = Apps.Notebook
end

local function getPath(obj)
	if obj.Parent == nil then
		return "Nil parented"
	else
		return Explorer.GetInstancePath(obj)
	end
end

local function main()
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	
	local ModelViewer = {
		EnableInputCamera = true,
		IsViewing = false,
		AutoRefresh = false,
		ZoomMultiplier = 2,
		AutoRotate = true,
		RotationSpeed = 0.01,
		RefreshRate = 30 -- hertz
	}
	
	local window, viewportFrame, worldModel, pathLabel, settingsButton
	local model, camera, originalModel
	-- shared camera orbit state (upvalue so ViewModel can auto-fit distance)
	local rotationX, rotationY = math.rad(-15), 0
	local distance = 10

	ModelViewer.StopViewModel = function(updating)
		if updating then
			if model then
				pcall(function() model:Destroy() end)
				model = nil
			end
		else
			if model then
				pcall(function() model:Destroy() end)
				model = nil
			end
			if camera then
				pcall(function() camera:Destroy() end)
				camera = nil
			end
			if viewportFrame then
				pcall(function() viewportFrame.CurrentCamera = nil end)
			end
			originalModel = nil
			ModelViewer.IsViewing = false
			if window then window:SetTitle("3D Preview") end
			if pathLabel and pathLabel.Gui then pathLabel.Gui.Text = "" end
		end
	end

	-- collects every BasePart under obj (obj itself included)
	local function collectParts(obj)
		local parts = {}
		local ok, isPart = pcall(function() return obj:IsA("BasePart") end)
		if ok and isPart then
			parts[1] = obj
			return parts
		end
		local okDesc, desc = pcall(function() return obj:GetDescendants() end)
		if okDesc and desc then
			for _, d in ipairs(desc) do
				local okP, isP = pcall(function() return d:IsA("BasePart") end)
				if okP and isP then
					parts[#parts + 1] = d
				end
			end
		end
		return parts
	end

	ModelViewer.ViewModel = function(item, updating)
		if not item then return end
		if not viewportFrame then return end
		-- clear previous preview model (keep camera when live-updating)
		if model then
			pcall(function() model:Destroy() end)
			model = nil
		end
		if not updating then
			if camera then
				pcall(function() camera:Destroy() end)
				camera = nil
			end
			rotationX, rotationY = math.rad(-15), 0
			distance = 10
		end

		if item == workspace or (item:IsA("Terrain") == true) then
			if not updating then
				if pathLabel and pathLabel.Gui then
					pathLabel.Gui.Text = "Cannot preview workspace / Terrain"
				end
				window:Show()
			end
			return
		end

		pcall(function() item.Archivable = true end)

		-- clone the whole thing at once (preserves nested Models, meshes,
		-- decals, Tools, Folders - everything), then recenter via bounding box
		model = Instance.new("Model")
		model.Name = "Preview"
		local okClone, fullClone = pcall(function()
			return item:Clone()
		end)
		if not okClone or not fullClone then
			pcall(function() model:Destroy() end)
			model = nil
			if not updating and pathLabel and pathLabel.Gui then
				pathLabel.Gui.Text = "Failed to clone " .. tostring(item.ClassName) .. " (Archivable?)"
				if window then
					window:SetTitle(tostring(item.Name) .. " - 3D Preview")
					window:Show()
				end
			end
			return
		end
		fullClone.Parent = model

		-- engine bounding box of everything inside (works for nested Models too)
		local okBox, boxCF, boxSize = pcall(function()
			return model:GetBoundingBox()
		end)
		if not okBox or not boxCF or not boxSize then
			pcall(function() model:Destroy() end)
			model = nil
			if not updating and pathLabel and pathLabel.Gui then
				pathLabel.Gui.Text = "No BaseParts to preview in " .. tostring(item.ClassName)
				if window then
					window:SetTitle(tostring(item.Name) .. " - 3D Preview")
					window:Show()
				end
			end
			return
		end

		-- shift so the box center sits at origin (orbit target), anchor everything
		pcall(function()
			model:PivotTo(model:GetPivot() - boxCF.Position)
		end)
		for _, d in ipairs(model:GetDescendants()) do
			pcall(function()
				if d:IsA("BasePart") then
					d.Anchored = true
					d.CanCollide = false
				end
			end)
		end
		local partCount = #collectParts(model)

		-- park the preview container inside the ViewportFrame (WorldModel if present)
		local holder = worldModel or viewportFrame
		model.Parent = holder

		-- auto-fit camera distance to the model's size
		local radius = boxSize.Magnitude * 0.5
		distance = math.clamp(math.max(radius * 2.4, 5), 2, 5000)

		originalModel = item

		if ModelViewer.AutoRefresh and not updating then
			task.spawn(function()
				while model and ModelViewer.AutoRefresh do
					ModelViewer.ViewModel(originalModel, true)
					task.wait(1 / ModelViewer.RefreshRate)
				end
			end)
		end

		if not updating then
			camera = Instance.new("Camera")
			camera.FieldOfView = 50
			camera.Parent = viewportFrame
			viewportFrame.CurrentCamera = camera

			window:SetTitle(item.Name.." - 3D Preview")
			pathLabel.Gui.Text = "path: " .. getPath(originalModel) .. " (" .. tostring(partCount) .. " parts)"
			window:Show()
			ModelViewer.IsViewing = true
		end
	end

	ModelViewer.Init = function()
		window = Lib.Window.new()
		window:SetTitle("3D Preview")
		window:Resize(350,200)
		ModelViewer.Window =  window
		
		viewportFrame = Instance.new("ViewportFrame")
		viewportFrame.Parent = window.GuiElems.Content
		viewportFrame.BackgroundTransparency = 1
		viewportFrame.Size = UDim2.new(1,0,1,0)
		viewportFrame.Ambient = Color3.fromRGB(140, 140, 160)
		viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
		viewportFrame.LightDirection = Vector3.new(-1, -1, -1)

		-- WorldModel is the proper container for 3D objects inside a ViewportFrame
		worldModel = Instance.new("WorldModel")
		worldModel.Parent = viewportFrame
		
		pathLabel = Lib.Label.new()
		pathLabel.Gui.Parent = window.GuiElems.Content
		pathLabel.Gui.AnchorPoint = Vector2.new(0,0)
		pathLabel.Gui.Text = ""
		pathLabel.Gui.TextSize = 12
		pathLabel.Gui.TextTransparency = 0.8
		pathLabel.Gui.Position = UDim2.new(0,4,0,2)
		pathLabel.Gui.Size = UDim2.new(1,-24,0,15)
		pathLabel.Gui.BackgroundTransparency = 1
		pathLabel.Gui.TextXAlignment = Enum.TextXAlignment.Left
		pathLabel.Gui.TextTruncate = Enum.TextTruncate.AtEnd
		
		settingsButton = Instance.new("ImageButton",window.GuiElems.Content)
		settingsButton.AnchorPoint = Vector2.new(1,0)
		settingsButton.BackgroundTransparency = 1
		settingsButton.Size = UDim2.new(0,15,0,15)
		settingsButton.Position = UDim2.new(1,-3,0,3)
		settingsButton.Image = "rbxassetid://6578871732"
		settingsButton.ImageTransparency = 0.5
		-- mobile input check
		if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			settingsButton.Visible = true
		else
			settingsButton.Visible = false
		end

		-- zoom + spin controls (bottom-right, always visible)
		local spinBtn
		local function refreshSpinBtn()
			if not spinBtn then return end
			spinBtn.Text = ModelViewer.AutoRotate and "Spin: On" or "Spin: Off"
			spinBtn.BackgroundColor3 = ModelViewer.AutoRotate and Settings.Theme.ListSelection or Settings.Theme.Button
		end
		do
			local controls = Instance.new("Frame")
			controls.Name = "PreviewControls"
			controls.AnchorPoint = Vector2.new(1,1)
			controls.BackgroundTransparency = 1
			controls.BorderSizePixel = 0
			controls.Position = UDim2.new(1,-6,1,-6)
			controls.Size = UDim2.new(0,120,0,24)
			controls.Parent = window.GuiElems.Content

			local function makeBtn(text, x, w)
				local b = Instance.new("TextButton")
				b.Name = text
				b.Text = text
				b.Font = Enum.Font.GothamBold
				b.TextSize = 13
				b.TextColor3 = Settings.Theme.Text
				b.BackgroundColor3 = Settings.Theme.Button
				b.BorderSizePixel = 0
				b.AutoButtonColor = true
				b.Size = UDim2.new(0,w,0,24)
				b.Position = UDim2.new(0,x,0,0)
				b.Parent = controls
				local c = Instance.new("UICorner")
				c.CornerRadius = UDim.new(0,6)
				c.Parent = b
				local s = Instance.new("UIStroke")
				s.Color = Settings.Theme.Outline2
				s.Transparency = 0.4
				s.Thickness = 1
				s.Parent = b
				return b
			end

			spinBtn = makeBtn("Spin: On", 0, 64)
			local zoomOutBtn = makeBtn("-", 68, 24)
			local zoomInBtn = makeBtn("+", 96, 24)
			Main.ApplyGothamSSm(controls)

			spinBtn.MouseButton1Click:Connect(function()
				ModelViewer.AutoRotate = not ModelViewer.AutoRotate
				refreshSpinBtn()
			end)
			zoomInBtn.MouseButton1Click:Connect(function()
				distance = math.clamp(distance * 0.82, 0.5, 5000)
			end)
			zoomOutBtn.MouseButton1Click:Connect(function()
				distance = math.clamp(distance * 1.22, 0.5, 5000)
			end)
			refreshSpinBtn()
		end

		local dragging = false
		local hovering = false
		local lastpos = Vector2.zero

		viewportFrame.InputBegan:Connect(function(input)
			if not ModelViewer.EnableInputCamera then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				lastpos = input.Position
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				ModelViewer.ZoomMultiplier = 10
			end
		end)
		

		viewportFrame.MouseEnter:Connect(function()
			hovering = true
		end)
		viewportFrame.MouseLeave:Connect(function()
			hovering = false
		end)

		viewportFrame.InputEnded:Connect(function(input)
			if not ModelViewer.EnableInputCamera then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				ModelViewer.ZoomMultiplier = 2
			end
		end)

		viewportFrame.InputChanged:Connect(function(input)
			if not ModelViewer.EnableInputCamera then return end
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - lastpos
				lastpos = input.Position

				rotationY -= delta.X * 0.01
				rotationX -= delta.Y * 0.01
				rotationX = math.clamp(rotationX, -math.pi/2 + 0.1, math.pi/2 - 0.1)
			end

			if input.UserInputType == Enum.UserInputType.MouseWheel and hovering then
				distance = math.clamp(distance - (input.Position.Z * ModelViewer.ZoomMultiplier), 0.1, math.huge)
			end
		end)

		RunService.RenderStepped:Connect(function(dt)
			if camera and model and model.Parent then
				if not dragging and ModelViewer.AutoRotate then
					rotationY += ModelViewer.RotationSpeed * dt * 60
				end

				-- preview is centered at origin, so orbit around 0,0,0
				local center = Vector3.new(0, 0, 0)
				local offset = CFrame.new(0, 0, distance)
				local rotation = CFrame.Angles(0, rotationY, 0) * CFrame.Angles(rotationX, 0, 0)

				local camCF = CFrame.new(center) * rotation * offset

				pcall(function()
					camera.CFrame = CFrame.lookAt(camCF.Position, center)
				end)
			end
		end)
		
		-- context stuffs
		local context = Lib.ContextMenu.new()
		
		local absoluteSize = context.Gui.AbsoluteSize
		context.MaxHeight = (absoluteSize.Y <= 600 and (absoluteSize.Y - 40)) or nil

		-- Registers
		context:Register("STOP",{Name = "Stop Viewing", OnClick = function()
			ModelViewer.StopViewModel()
		end})
		context:Register("EXIT",{Name = "Exit", OnClick = function()
			ModelViewer.StopViewModel()
			context:Hide()
			window:Hide()
		end})
		context:Register("COPY_PATH",{Name = "Copy Path", OnClick = function()
			if model then
				env.setclipboard(getPath(originalModel))
			end
		end})
		context:Register("REFRESH",{Name = "Refresh", OnClick = function()
			if originalModel then
				ModelViewer.ViewModel(originalModel)
			end
		end})
		context:Register("ENABLE_AUTO_REFRESH",{Name = "Enable Auto Refresh", OnClick = function()
			if originalModel then
				ModelViewer.AutoRefresh = true
				ModelViewer.ViewModel(originalModel)
			end
		end})
		context:Register("DISABLE_AUTO_REFRESH",{Name = "Disable Auto Refresh", OnClick = function()
			if originalModel then
				ModelViewer.AutoRefresh = false
				ModelViewer.ViewModel(originalModel)
			end
		end})
		context:Register("SAVE_INST",{Name = "Save to File", OnClick = function()
			if model then
				Lib.SaveAsPrompt("Place_"..game.PlaceId.."_"..originalModel.Name.."_"..os.time(), function(filename)
					window:SetTitle(originalModel.Name.." - Model Viewer - Saving")	
					
					local success, result = pcall(env.saveinstance,
					originalModel, filename,
						{
							Decompile = true,
							RemovePlayerCharacters = false
						}
					)
					
					if success then
						window:SetTitle(originalModel.Name.." - Model Viewer - Saved")
						context:Hide()
						task.wait(5)
						if model then
							window:SetTitle(originalModel.Name.." - Model Viewer")
						end
					else
						window:SetTitle(originalModel.Name.." - Model Viewer - Error")
						warn("Error while saving model: "..result)
						context:Hide()
						task.wait(5)
						if model then
							window:SetTitle(originalModel.Name.." - Model Viewer")
						end
					end
				end)
			end
		end})
		
		context:Register("ENABLE_AUTO_ROTATE",{Name = "Enable Auto Rotate", OnClick = function()
			ModelViewer.AutoRotate = true
			refreshSpinBtn()
		end})
		context:Register("DISABLE_AUTO_ROTATE",{Name = "Disable Auto Rotate", OnClick = function()
			ModelViewer.AutoRotate = false
			refreshSpinBtn()
		end})
		context:Register("LOCK_CAM",{Name = "Lock Camera", OnClick = function()
			ModelViewer.EnableInputCamera = false
		end})
		context:Register("UNLOCK_CAM",{Name = "Unlock Camera", OnClick = function()
			ModelViewer.EnableInputCamera = true
		end})
		
		context:Register("ZOOM_IN",{Name = "Zoom In", OnClick = function()
			distance = math.clamp(distance - (ModelViewer.ZoomMultiplier * 2), 2, math.huge)
		end})
		
		context:Register("ZOOM_OUT",{Name = "Zoom Out", OnClick = function()
			distance = math.clamp(distance + (ModelViewer.ZoomMultiplier * 2), 2, math.huge)
		end})
		
		local function ShowContext()
			context:Clear()

			context:AddRegistered("STOP", not ModelViewer.IsViewing)	
			context:AddRegistered("REFRESH", not ModelViewer.IsViewing)
			context:AddRegistered("COPY_PATH", not ModelViewer.IsViewing)
			context:AddRegistered("SAVE_INST", not ModelViewer.IsViewing)
			context:AddDivider()
			
			if env.isonmobile then
				context:AddRegistered("ZOOM_IN")
				context:AddRegistered("ZOOM_OUT")
				context:AddDivider()
			end

			if ModelViewer.AutoRotate then
				context:AddRegistered("DISABLE_AUTO_ROTATE")
			else
				context:AddRegistered("ENABLE_AUTO_ROTATE")
			end
			if ModelViewer.AutoRefresh then
				context:AddRegistered("DISABLE_AUTO_REFRESH")
			else
				context:AddRegistered("ENABLE_AUTO_REFRESH")
			end
			if ModelViewer.EnableInputCamera then
				context:AddRegistered("LOCK_CAM")
			else
				context:AddRegistered("UNLOCK_CAM")
			end

			context:AddDivider()

			context:AddRegistered("EXIT")

			context:Show()
		end
		
		local function HideContext()
			context:Hide()
		end
		
		viewportFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				ShowContext()
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Lib.CheckMouseInGui(context.Gui) then
				HideContext()
			end
		end)
		settingsButton.MouseButton1Click:Connect(function()
			ShowContext()
		end)
	end

	return ModelViewer
end

-- TODO: Remove when open source
if gethsfuncs then
	_G.moduleData = {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
else
	return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
end