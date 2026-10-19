local oldgame = oldgame or game

cloneref = cloneref or function(ref)
	if not getreg then return ref end
	
	local InstanceList
	
	local a = Instance.new("Part")
	for _, c in pairs(getreg()) do
		if type(c) == "table" and #c then
			if rawget(c, "__mode") == "kvs" then
				for d, e in pairs(c) do
					if e == a then
						InstanceList = c
						break
					end
				end
			end
		end
	end
	local f = {}
	function f.invalidate(g)
		if not InstanceList then
			return
		end
		for b, c in pairs(InstanceList) do
			if c == g then
				InstanceList[b] = nil
				return g
			end
		end
	end
	return f.invalidate
end

local isFsSupported = readfile and writefile and isfile and isfolder and listfiles and delfile and delfolder

local Main, Explorer, Properties, ScriptViewer, Console, SaveInstance, ModelViewer, SettingsWindow, DefaultSettings, Notebook, Serializer, Lib local ggv = getgenv or nil
local API, RMD

DefaultSettings = (function()
	local rgb = Color3.fromRGB	
	
	return {
		Explorer = {
			_Recurse = true,
			Sorting = true,
			TeleportToOffset = Vector3.new(0,0,0),
			ClickToRename = true,
			AutoUpdateSearch = true,
			AutoUpdateMode = 0,
			PartSelectionBox = true,
			GuiSelectionBox = true,
			CopyPathUseGetChildren = true
		},
		Properties = {
			_Recurse = true,
			MaxConflictCheck = 50,
			ShowDeprecated = true,
			ShowHidden = false,
			ClearOnFocus = false,
			LoadstringInput = true,
			NumberRounding = 3,
			ShowAttributes = true,
			MaxAttributes = 50,
			ScaleType = 0
		},
		Theme = {
			_Recurse = true,
			Main1 = rgb(19,19,28),
			Main2 = rgb(14,14,21),
			Outline1 = rgb(10,10,17),
			Outline2 = rgb(58,58,82),
			Outline3 = rgb(24,24,35),
			TextBox = rgb(24,24,35),
			SearchBar = rgb(28,34,56),
			Menu = rgb(17,17,26),
			ListSelection = rgb(51,125,255),
			Button = rgb(33,33,47),
			ButtonHover = rgb(48,48,68),
			ButtonPress = rgb(26,26,38),
			Highlight = rgb(72,72,102),
			Text = rgb(240,240,248),
			PlaceholderText = rgb(135,135,162),
			Important = rgb(255,92,92),
			Accent = rgb(56,139,255),
			AccentDark = rgb(30,110,230),
			AccentLight = rgb(120,185,255),
			Success = rgb(62,185,130),
			ExplorerIconMap = "",
			MiscIconMap = "",
			CornerRadius = 10,
			Syntax = {
				Text = rgb(225,225,236),
				Background = rgb(17,17,26),
				Selection = rgb(255,255,255),
				SelectionBack = rgb(51,125,255),
				Operator = rgb(220,220,230),
				Number = rgb(255,198,0),
				String = rgb(173,241,149),
				Comment = rgb(110,110,125),
				Keyword = rgb(248,109,124),
				Error = rgb(255,85,85),
				FindBackground = rgb(141,118,0),
				MatchingWord = rgb(72,72,102),
				BuiltIn = rgb(132,214,247),
				CurrentLine = rgb(28,29,48),
				LocalMethod = rgb(253,251,172),
				LocalProperty = rgb(97,161,241),
				Nil = rgb(255,198,0),
				Bool = rgb(255,198,0),
				Function = rgb(248,109,124),
				Local = rgb(248,109,124),
				Self = rgb(248,109,124),
				FunctionName = rgb(253,251,172),
				Bracket = rgb(220,220,230)
			},
		},
		ScriptViewer = {
			ShowMoreInfo = true;
		},
		Window = {
			TitleOnMiddle = false,
			Transparency = 0
		},
		Decompiler = {
			DecompilerFallback = "Konstant",
			PreferDecompilerFallback = false,
			ShinyDecompilerPort = 3000,
		},
		
		RemoteBlockWriteAttribute = false,
		ClassIcon = "NewDark",
		
	}
end)()

local Settings = DefaultSettings or {}
local Apps = {}
local env = {}

local service = setmetatable({},{__index = function(self,name)
	local serv = cloneref(game:GetService(name))
	self[name] = serv
	return serv
end})
local plr = service.Players.LocalPlayer or service.Players.PlayerAdded:wait()

local create = function(data)
	local insts = {}
	for i,v in pairs(data) do insts[v[1]] = Instance.new(v[2]) end

	for _,v in pairs(data) do
		for prop,val in pairs(v[3]) do
			if type(val) == "table" then
				insts[v[1]][prop] = insts[val[1]]
			else
				insts[v[1]][prop] = val
			end
		end
	end

	return insts[1]
end

local createSimple = function(class,props)
	local inst = Instance.new(class)
	for i,v in next,props do
		inst[i] = v
	end
	return inst
end

Main = (function()
	local Main = {}

	Main.ModuleList = {"Explorer","Properties","ScriptViewer","Console","SaveInstance","ModelViewer","SettingsWindow"}
	Main.Elevated = false
	Main.AllowDraggableOnMobile = true
	Main.MissingEnv = {}
	Main.Version = "1.0"
	Main.AppName = "Dexium"
	Main.Mouse = plr:GetMouse()
	Main.AppControls = {}
	Main.Apps = Apps
	Main.MenuApps = {}
	Main.GitName = "JustSomeGuest"
	Main.RepoName = "Scripts"
	Main.Branch = "Main"
	Main.Folder = "Universal/Dexium"
	Main.BaseUrl = "https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Universal/Dexium"
	Main.GitRepoName = Main.GitName.."/"..Main.RepoName
	Main.LocalBase = "DexiumSRC"
	Main.DataFolder = "dexium"
	Main.SettingsPath = Main.DataFolder.."/settings.json"

	Main.DisplayOrders = {
		SideWindow = 8,
		Window = 10,
		Menu = 100000,
		Core = 101000
	}
	
	Main.Plugins = {}
	
	Main.GetRandomString = function()
		local output = ""
		for i = 2, 25 do
			output = output .. string.char(math.random(1,250))
		end
		
		return output
	end
	
	Main.GetSecureContainer = function()
		return
			syn and syn.protect_gui or
			gethui and gethui() or
			service.CoreGui or
			service.Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	
	Main.SecureGui = function(gui)
		gui.Name = "_DXM_".. Main.GetRandomString()
		if gethui then
			gui.Parent = gethui()
		elseif syn and syn.protect_gui then
			syn.protect_gui(gui)
			gui.Parent = service.CoreGui
		elseif protect_gui then
			protect_gui(gui)
			gui.Parent = service.CoreGui
		elseif protectgui then
			protectgui(gui)
			gui.Parent = service.CoreGui
		else
			if Main.Elevated then
				gui.Parent = service.CoreGui
			else
				gui.Parent = service.Players.LocalPlayer:WaitForChild("PlayerGui")
			end
		end
	end

	Main.GetInitDeps = function()
		return {
			Main = Main,
			Lib = Lib,
			Apps = Apps,
			Settings = Settings,

			API = API,
			RMD = RMD,
			env = env,
			service = service,
			plr = plr,
			create = create,
			createSimple = createSimple
		}
	end

	Main.Error = function(str)
		local msg = "[Dexium] ERROR: "..tostring(str)
		if rconsoleprint then
			rconsoleprint(msg.."\n")
		end
		warn(msg)
		if Main._Intro then
			pcall(function()
				Main._Intro.SetProgress("Error: "..tostring(str):sub(1, 80), 1)
			end)
		end
		error(str)
	end

	Main.Log = function(...)
		local msg = "[Dexium] "..table.concat({ ... }, " ")
		if rconsoleprint then
			rconsoleprint(msg.."\n")
		else
			print(msg)
		end
	end

	Main.GetGothamSSm = function(weight)
		local ok, f = pcall(Font.new, "rbxasset://fonts/families/GothamSSm.json", weight or Enum.FontWeight.Medium)
		if ok and f then return f end
		return nil
	end

	Main.ApplyGothamSSm = function(root)
		if not root then return end
		local boldFace = Main.GetGothamSSm(Enum.FontWeight.Bold)
		local medFace = Main.GetGothamSSm(Enum.FontWeight.Medium)
		local regFace = Main.GetGothamSSm(Enum.FontWeight.Regular)
		local function applyTo(d)
			if not (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) then return end
			pcall(function()
				local isTitle = (d.Name == "Title" or d.Name == "OpenButton" or d.Name == "AppName")
				if isTitle then
					if boldFace then d.FontFace = boldFace end
					d.Font = Enum.Font.GothamBold
				else
					if medFace or regFace then d.FontFace = medFace or regFace end
					d.Font = Enum.Font.GothamMedium
				end
			end)
		end
		if root.GetDescendants then
			for _, d in ipairs(root:GetDescendants()) do
				applyTo(d)
			end
		end
		pcall(function()
			if root:IsA("TextLabel") or root:IsA("TextButton") or root:IsA("TextBox") then
				applyTo(root)
			end
		end)
	end

	Main._HasLocalSrcCached = nil
	Main.HasLocalSrc = function()
		if Main._HasLocalSrcCached ~= nil then
			return Main._HasLocalSrcCached
		end
		local _isfile = (env and env.isfile) or isfile
		local _isfolder = (env and env.isfolder) or isfolder
		local function existsFile(p)
			if not _isfile then return false end
			local ok, res = pcall(_isfile, p)
			return ok and res == true
		end
		local function existsFolder(p)
			if not _isfolder then return false end
			local ok, res = pcall(_isfolder, p)
			return ok and res == true
		end
		local found = false
		if existsFile(Main.LocalBase.."/Modules/Lib.lua") or existsFile("Modules/Lib.lua") then
			found = true
		elseif existsFolder(Main.LocalBase.."/Modules") or existsFolder("Modules") then
			found = true
		end
		Main._HasLocalSrcCached = found
		return found
	end

	Main.TryReadLocal = function(path)
		local _read = env.readfile or readfile
		if not _read then return nil end
		local ok, data = pcall(_read, path)
		if ok and type(data) == "string" and #data > 0 then
			return data
		end
		return nil
	end

	Main.LoadModule = function(name)
		if Main.Elevated then
			local control

			if EmbeddedModules then
				control = EmbeddedModules[name]()

				if gethsfuncs then
					control = _G.moduleData
				end

				if not control then Main.Error("Missing Embedded Module: "..name) end
			else
				local localPaths = {
					Main.LocalBase.."/Modules/"..name..".lua",
					"Modules/"..name..".lua",
					Main.LocalBase.."/"..name..".lua",
				}
				local moduleStr
				local usedLocalPath
				for _, p in ipairs(localPaths) do
					local data = Main.TryReadLocal(p)
					if data then
						moduleStr = data
						usedLocalPath = p
						break
					end
				end
				if moduleStr then
					Main.Log("using local "..tostring(usedLocalPath).." ("..tostring(#moduleStr).." bytes)")
					local fn, err = (env.loadstring or loadstring)(moduleStr, "@"..name)
					if not fn then Main.Error("Failed to compile local module "..name.." ("..tostring(usedLocalPath).."): "..tostring(err)) end
					local okCall, res = pcall(fn)
					if not okCall then
						Main.Error("Failed to run local module "..name.." ("..tostring(usedLocalPath).."): "..tostring(res))
					end
					control = res
					if env.writefile then
						pcall(env.writefile, "dexium/ModuleCache/"..name..".lua", moduleStr)
					end
				else
					local filePath = "dexium/ModuleCache/"..name..".lua"
					local cached = Main.TryReadLocal(filePath)
					if cached and #cached > 100 then
						local fn = (env.loadstring or loadstring)(cached, name)
						if fn then
							local okCall, res = pcall(fn)
							if okCall and res then
								control = res
							else
								cached = nil
							end
							if control then
								if rconsoleprint then rconsoleprint("[Dexium] using cache "..name.."\n") end
							end
						end
					end

					if not control then
						local remoteUrl = Main.BaseUrl.."/Modules/"..name..".lua"
						local ok, remoteStr = pcall(oldgame.HttpGet, game, remoteUrl)
						if not ok or not remoteStr or #remoteStr < 100 or remoteStr:find("^404") then
							if cached then
								local fn = (env.loadstring or loadstring)(cached, name)
								if fn then control = fn() end
							end
							if not control then
								Main.Error("Failed to get module "..name.." from "..remoteUrl.." (not pushed yet? use DexiumSRC/ locally)")
							end
						else
							if env.writefile then
								pcall(env.writefile, filePath, remoteStr)
							end
							local fn, err = (env.loadstring or loadstring)(remoteStr, name)
							if not fn then Main.Error("Failed to compile remote module "..name..": "..tostring(err)) end
							control = fn()
						end
					end
				end
			end

			if not control or not control.InitDeps or not control.Main then
				Main.Error("Module "..name.." returned bad control (missing InitDeps/Main)")
			end
			Main.AppControls[name] = control
			local t0 = tick()
			Main.Log("initdeps "..name)
			control.InitDeps(Main.GetInitDeps())

			Main.Log("running Main() "..name)
			local okMain, moduleData = xpcall(control.Main, function(e) return tostring(e).."\n"..tostring(debug.traceback()) end)
			if not okMain then
				Main.Error("Module "..name.." Main() failed: "..tostring(moduleData))
			end
			Main.Log("done "..name.." in "..string.format("%.2f", tick()-t0).."s")
			Apps[name] = moduleData
			return moduleData
		else
			local module = script:WaitForChild("Modules"):WaitForChild(name,2)
			if not module then Main.Error("CANNOT FIND MODULE "..name) end

			local control = require(module)
			Main.AppControls[name] = control
			control.InitDeps(Main.GetInitDeps())

			local okMain, moduleData = pcall(control.Main)
			if not okMain then
				Main.Error("Module "..name.." Main() failed: "..tostring(moduleData))
			end
			Apps[name] = moduleData
			return moduleData
		end
	end
	
	Main.LoadPluginFile = function(pluginDir)
		if env.readfile then
			if isfile(pluginDir) then
				local preloadedPlugin = loadfile and loadfile(pluginDir) or loadstring(env.readfile(pluginDir))
				local loadedPlugin = preloadedPlugin()
				
				local control = loadedPlugin
				control.InitDeps(Main.GetInitDeps())

				local moduleData = control.Main()
				Apps[pluginDir] = moduleData
				Main.AppControls[pluginDir] = control
				
				moduleData.PluginData = control.PluginData
				
				return moduleData
			else
				Main.Error("CANNOT FIND FILE MODULE "..pluginDir)
			end
		end
	end

	Main.LoadModules = function(progressFn)
		Main._FailedModules = {}
		for i,v in ipairs(Main.ModuleList) do
			if progressFn then
				pcall(progressFn, v, i, #Main.ModuleList)
			end
			Main.Log("loading module "..tostring(i).."/"..tostring(#Main.ModuleList)..": "..tostring(v))
			local s,e = pcall(Main.LoadModule,v)
			if not s then
				warn("[Dexium] FAILED LOADING "..tostring(v).." CAUSE "..tostring(e))
				if rconsoleprint then rconsoleprint("[Dexium] FAILED LOADING "..tostring(v).." CAUSE "..tostring(e).."\n") end
				table.insert(Main._FailedModules, v)
			end
		end
		if #Main._FailedModules > 0 then
			warn("[Dexium] failed modules: "..table.concat(Main._FailedModules, ", "))
		end

		Explorer = Apps.Explorer
		Properties = Apps.Properties
		ScriptViewer = Apps.ScriptViewer
		Console = Apps.Console
		SaveInstance = Apps.SaveInstance
		ModelViewer = Apps.ModelViewer
		Notebook = Apps.Notebook
		SettingsWindow = Apps.SettingsWindow
		
		local appTable = {
			Explorer = Explorer,
			Properties = Properties,
			ScriptViewer = ScriptViewer,
			Console = Console,
			SaveInstance = SaveInstance,
			ModelViewer = ModelViewer,
			Notebook = Notebook,
			SettingsWindow = SettingsWindow
		}
		
		Main.AppControls.Lib.InitAfterMain(appTable)
		for i,v in pairs(Main.ModuleList) do
			local control = Main.AppControls[v]
			if control then
				control.InitAfterMain(appTable)
			end
		end
	end

	Main.InitEnv = function()
		setmetatable(env,{__newindex = function(self,name,func)
			if not func then Main.MissingEnv[#Main.MissingEnv+1] = name return end
			rawset(self,name,func)
		end})

		env.isonmobile = game:GetService("UserInputService").TouchEnabled
		
		env.loadstring = (pcall(loadstring,"local a = 1") and loadstring) or (game:GetService("RunService"):IsStudio() and script.Modules:FindFirstChild("Loadstring") and require(script.Modules:FindFirstChild("Loadstring")))

		env.isfile = isfile
		env.isfolder = isfolder
		env.readfile = readfile
		env.writefile = writefile
		env.appendfile = appendfile
		env.makefolder = makefolder
		env.listfiles = listfiles
		env.loadfile = loadfile
		env.saveinstance = saveinstance or (function()
			if game:GetService("RunService"):IsStudio() then return function() error("Cannot run in Roblox Studio!") end end
			local Params = {
				RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
				SSI = "saveinstance",
			}
			local synsaveinstance = loadstring(oldgame:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
		
			local function wrappedsaveinstance(obj, filepath, options)
				options["FilePath"] = filepath
				options["Object"] = obj
				return synsaveinstance(options)
			end
			
			getgenv().saveinstance = wrappedsaveinstance
			return wrappedsaveinstance
		end)()
		
		env.parsefile = function(name)
			return tostring(name):gsub("[*\\?:<>|]+", ""):sub(1, 175)
		end

		env.getupvalues = debug.getupvalues or getupvalues or getupvals
		env.getconstants = debug.getconstants or getconstants or getconsts
		env.islclosure = islclosure or is_l_closure
		env.checkcaller = checkcaller
		env.getreg = getreg
		env.getgc = getgc
		
		env.hookfunction = hookfunction
		env.hookmetamethod = hookmetamethod

		env.getscriptbytecode = getscriptbytecode
		env.setfflag = setfflag
		env.protectgui = protect_gui or (syn and syn.protect_gui)
		env.gethui = gethui
		env.setclipboard = setclipboard
		env.getnilinstances = getnilinstances or get_nil_instances
		env.getloadedmodules = getloadedmodules
		
		env.isViableDecompileScript = function(obj)
			if obj:IsA("ModuleScript") then
				return true
			elseif obj:IsA("LocalScript") and (obj.RunContext == Enum.RunContext.Client or obj.RunContext == Enum.RunContext.Legacy) then
				return true
			elseif obj:IsA("Script") and obj.RunContext == Enum.RunContext.Client then
				return true
			end
			return false
		end
		env.request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
		
		env.isdecompile = function()
			return typeof(decompile) == "function" or typeof(getscriptbytecode) == "function" or false
		end
		
		env.isdecompilefallback = function()
			return typeof(decompile) ~= "function" or typeof(getscriptbytecode) == "function" or false
		end
		
		local AdvancedDecompilerCache
		pcall(function()
			AdvancedDecompilerCache = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Advanced-Decompiler-V3/main/init.lua"))()
		end)
		
		local konstant_last_call = 0
		
		local function KonstantDec(...)
			local API = "http://api.plusgiant5.com"

			local request = env.request

			local function call(konstantType, scriptPath)
				local success, bytecode = pcall(env.getscriptbytecode, scriptPath)

				if (not success) then
					return 
				end

				local time_elapsed = os.clock() - konstant_last_call
				if time_elapsed <= .5 then
					task.wait(.5 - time_elapsed)
				end

				local httpResult = env.request({
					Url = API .. konstantType,
					Body = bytecode,
					Method = "POST",
					Headers = {
						["Content-Type"] = "text/plain"
					}
				})

				konstant_last_call = os.clock()

				if (httpResult.StatusCode ~= 200) then
					return `
				else
					return httpResult.Body
				end
			end

			local function konstantDecompile(scriptPath)
				return call("/konstant/decompile", scriptPath)
			end

			return konstantDecompile(...)
		end
		local ADDec = AdvancedDecompilerCache or function() return "Failed to load Advanced Decompiler" end

		local function ShinyDec(script_instance)
			if typeof(crypt) ~= "table" then return "-- 'crypt' library is missing!" end
			local success, result = pcall(function()
				return game:HttpGet("http://127.0.0.1:"..tostring(Settings.Decompiler.ShinyDecompilerPort))
			end)
			if not success then return "-- Shiny decompiler is not active or port is wrong!" end

			local bytecode = getscriptbytecode(script_instance)
			local encoded = crypt.base64encode(bytecode)
			return env.request(
				{
					Url = "http://127.0.0.1:"..tostring(Settings.Decompiler.ShinyDecompilerPort).."/luau/decompile",
					Method = "POST",
					Body = encoded
				}
			).Body
		end
		env.decompile = function(...)
			if typeof(decompile) == "function" and Settings.Decompiler.PreferDecompilerFallback == false then
				return decompile(...)
			elseif typeof(getscriptbytecode) == "function" then
				local fallbackMode = Settings.Decompiler.DecompilerFallback
				
				if fallbackMode == "Konstant" then
					return KonstantDec(...)
				elseif fallbackMode == "AdvancedDecompiler" then
					return ADDec(...)
				elseif  fallbackMode == "Shiny" then
					return ShinyDec(...)
				end
			end
		end
		
		if identifyexecutor then
			Main.Executor = identifyexecutor()
		end

		Main.GuiHolder = Main.Elevated and service.CoreGui or plr:FindFirstChildOfClass("PlayerGui")

		setmetatable(env,nil)
	end

	Main.IncompatibleTest = function()
	end
	
	local function serialize(val)
		if typeof(val) == "Color3" then
			local serializedColor = {}
			serializedColor.R = val.R
			serializedColor.G = val.G
			serializedColor.B = val.B
			return serializedColor
		else
			return val
		end
	end
	
	local function deserialize(val)
		if typeof(val) == "table" then
			if val.R and val.G and val.B then
				return Color3.new(val.R, val.G, val.B)
			else
				return val
			end
		else
			return val
		end
	end
	
	Main.ExportSettings = function()
		local rawData = Settings or DefaultSettings

		local function recur(tbl)
			local newTbl = {}
			for i, v in pairs(tbl) do
				if typeof(v) == "table" then
					newTbl[i] = recur(v)
				else
					newTbl[i] = serialize(v)
				end
			end
			return newTbl
		end

		local serializedData = recur(rawData)

		local s, json = pcall(service.HttpService.JSONEncode, service.HttpService, serializedData)
		if s and json then
			return json
		end
	end

	Main.LoadSettings = function()
		local s, data = pcall(env.readfile or error, Main.SettingsPath)
		if s and data and data ~= "" then
			
			local s, decoded = pcall(service.HttpService.JSONDecode, service.HttpService, data)
			if s and decoded then

				local function recur(tbl)
					local newTbl = {}
					for i, v in pairs(tbl) do
						if typeof(v) == "table" then
							newTbl[i] = deserialize(recur(v))
						else
							newTbl[i] = deserialize(v)
						end
					end
					return newTbl
				end

				local deserializedData = recur(decoded)
				for k, v in pairs(deserializedData) do
					Settings[k] = v
				end
			else
				warn("failed to decode settings json")
			end
		else
			Main.ResetSettings()
		end
	end

	Main.ResetSettings = function()
		local function recur(t,res)
			for set,val in pairs(t) do
				if type(val) == "table" and val._Recurse then
					if type(res[set]) ~= "table" then
						res[set] = {}
					end
					recur(val,res[set])
				else
					res[set] = val
				end
			end
			return res
		end
		recur(DefaultSettings,Settings)
	end

	Main.FetchAPI = function(callbackiflong, callbackiftoolong, XD)
		local downloaded = false
		local api,rawAPI
		if Main.Elevated then
			if Main.LocalDepsUpToDate() then
				local localAPI = Lib.ReadFile("dexium/rbx_api.dat")
				if localAPI then 
					rawAPI = localAPI
				else
					Main.DepsVersionData[1] = ""
				end
			end
			task.spawn(function()
				task.wait(10)
				if not downloaded and callbackiflong then callbackiflong() end

				task.wait(20)
				if not downloaded and callbackiftoolong then callbackiftoolong() end

				task.wait(30)
				if not downloaded and XD then XD() end
			end)
			rawAPI = rawAPI or game:HttpGet("http://setup.roblox.com/"..Main.RobloxVersion.."-API-Dump.json")
		else
			if script:FindFirstChild("API") then
				rawAPI = require(script.API)
			else
				error("NO API EXISTS")
			end
		end
		downloaded = true
		
		Main.RawAPI = rawAPI
		api = service.HttpService:JSONDecode(rawAPI)

		local classes,enums = {},{}
		local categoryOrder,seenCategories = {},{}

		local function insertAbove(t,item,aboveItem)
			local findPos = table.find(t,item)
			if not findPos then return end
			table.remove(t,findPos)

			local pos = table.find(t,aboveItem)
			if not pos then return end
			table.insert(t,pos,item)
		end

		for _,class in pairs(api.Classes) do
			local newClass = {}
			newClass.Name = class.Name
			newClass.Superclass = class.Superclass
			newClass.Properties = {}
			newClass.Functions = {}
			newClass.Events = {}
			newClass.Callbacks = {}
			newClass.Tags = {}

			if class.Tags then for c,tag in pairs(class.Tags) do newClass.Tags[tag] = true end end
			for __,member in pairs(class.Members) do
				local newMember = {}
				newMember.Name = member.Name
				newMember.Class = class.Name
				newMember.Security = member.Security
				newMember.Tags ={}
				if member.Tags then for c,tag in pairs(member.Tags) do newMember.Tags[tag] = true end end

				local mType = member.MemberType
				if mType == "Property" then
					local propCategory = member.Category or "Other"
					propCategory = propCategory:match("^%s*(.-)%s*$")
					if not seenCategories[propCategory] then
						categoryOrder[#categoryOrder+1] = propCategory
						seenCategories[propCategory] = true
					end
					newMember.ValueType = member.ValueType
					newMember.Category = propCategory
					newMember.Serialization = member.Serialization
					table.insert(newClass.Properties,newMember)
				elseif mType == "Function" then
					newMember.Parameters = {}
					newMember.ReturnType = member.ReturnType.Name
					for c,param in pairs(member.Parameters) do
						table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
					end
					table.insert(newClass.Functions,newMember)
				elseif mType == "Event" then
					newMember.Parameters = {}
					for c,param in pairs(member.Parameters) do
						table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
					end
					table.insert(newClass.Events,newMember)
				end
			end

			classes[class.Name] = newClass
		end

		for _,class in pairs(classes) do
			class.Superclass = classes[class.Superclass]
		end

		for _,enum in pairs(api.Enums) do
			local newEnum = {}
			newEnum.Name = enum.Name
			newEnum.Items = {}
			newEnum.Tags = {}

			if enum.Tags then for c,tag in pairs(enum.Tags) do newEnum.Tags[tag] = true end end
			for __,item in pairs(enum.Items) do
				local newItem = {}
				newItem.Name = item.Name
				newItem.Value = item.Value
				table.insert(newEnum.Items,newItem)
			end

			enums[enum.Name] = newEnum
		end

		local function getMember(class,member)
			if not classes[class] or not classes[class][member] then return end
			local result = {}

			local currentClass = classes[class]
			while currentClass do
				for _,entry in pairs(currentClass[member]) do
					result[#result+1] = entry
				end
				currentClass = currentClass.Superclass
			end

			table.sort(result,function(a,b) return a.Name < b.Name end)
			return result
		end

		insertAbove(categoryOrder,"Behavior","Tuning")
		insertAbove(categoryOrder,"Appearance","Data")
		insertAbove(categoryOrder,"Attachments","Axes")
		insertAbove(categoryOrder,"Cylinder","Slider")
		insertAbove(categoryOrder,"Localization","Jump Settings")
		insertAbove(categoryOrder,"Surface","Motion")
		insertAbove(categoryOrder,"Surface Inputs","Surface")
		insertAbove(categoryOrder,"Part","Surface Inputs")
		insertAbove(categoryOrder,"Assembly","Surface Inputs")
		insertAbove(categoryOrder,"Character","Controls")
		categoryOrder[#categoryOrder+1] = "Unscriptable"
		categoryOrder[#categoryOrder+1] = "Attributes"

		local categoryOrderMap = {}
		for i = 1,#categoryOrder do
			categoryOrderMap[categoryOrder[i]] = i
		end

		return {
			Classes = classes,
			Enums = enums,
			CategoryOrder = categoryOrderMap,
			GetMember = getMember
		}
	end

	Main.FetchRMD = function()
		local rawXML
		if Main.Elevated then
			if Main.LocalDepsUpToDate() then
				local localRMD = Lib.ReadFile("dexium/rbx_rmd.dat")
				if localRMD then 
					rawXML = localRMD
				else
					Main.DepsVersionData[1] = ""
				end
			end
			rawXML = rawXML or game:HttpGet("https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml")
		else
			if script:FindFirstChild("RMD") then
				rawXML = require(script.RMD)
			else
				error("NO RMD EXISTS")
			end
		end
		Main.RawRMD = rawXML
		local parsed = Lib.ParseXML(rawXML)
		local classList = parsed.children[1].children[1].children
		local enumList = parsed.children[1].children[2].children
		local propertyOrders = {}

		local classes,enums = {},{}
		for _,class in pairs(classList) do
			local className = ""
			for _,child in pairs(class.children) do
				if child.tag == "Properties" then
					local data = {Properties = {}, Functions = {}}
					local props = child.children
					for _,prop in pairs(props) do
						local name = prop.attrs.name
						name = name:sub(1,1):upper()..name:sub(2)
						data[name] = prop.children[1].text
					end
					className = data.Name
					classes[className] = data
				elseif child.attrs.class == "ReflectionMetadataProperties" then
					local members = child.children
					for _,member in pairs(members) do
						if member.attrs.class == "ReflectionMetadataMember" then
							local data = {}
							if member.children[1].tag == "Properties" then
								local props = member.children[1].children
								for _,prop in pairs(props) do
									if prop.attrs then
										local name = prop.attrs.name
										name = name:sub(1,1):upper()..name:sub(2)
										data[name] = prop.children[1].text
									end
								end
								if data.PropertyOrder then
									local orders = propertyOrders[className]
									if not orders then orders = {} propertyOrders[className] = orders end
									orders[data.Name] = tonumber(data.PropertyOrder)
								end
								classes[className].Properties[data.Name] = data
							end
						end
					end
				elseif child.attrs.class == "ReflectionMetadataFunctions" then
					local members = child.children
					for _,member in pairs(members) do
						if member.attrs.class == "ReflectionMetadataMember" then
							local data = {}
							if member.children[1].tag == "Properties" then
								local props = member.children[1].children
								for _,prop in pairs(props) do
									if prop.attrs then
										local name = prop.attrs.name
										name = name:sub(1,1):upper()..name:sub(2)
										data[name] = prop.children[1].text
									end
								end
								classes[className].Functions[data.Name] = data
							end
						end
					end
				end
			end
		end

		for _,enum in pairs(enumList) do
			local enumName = ""
			for _,child in pairs(enum.children) do
				if child.tag == "Properties" then
					local data = {Items = {}}
					local props = child.children
					for _,prop in pairs(props) do
						local name = prop.attrs.name
						name = name:sub(1,1):upper()..name:sub(2)
						data[name] = prop.children[1].text
					end
					enumName = data.Name
					enums[enumName] = data
				elseif child.attrs.class == "ReflectionMetadataEnumItem" then
					local data = {}
					if child.children[1].tag == "Properties" then
						local props = child.children[1].children
						for _,prop in pairs(props) do
							local name = prop.attrs.name
							name = name:sub(1,1):upper()..name:sub(2)
							data[name] = prop.children[1].text
						end
						enums[enumName].Items[data.Name] = data
					end
				end
			end
		end

		return {Classes = classes, Enums = enums, PropertyOrders = propertyOrders}
	end

	Main.ShowGui = Main.SecureGui

	Main.CreateIntro = function(initStatus)
		local ACCENT = Color3.fromRGB(56,139,255)
		local ACCENT_L = Color3.fromRGB(120,185,255)
		local BG = Color3.fromRGB(15,15,22)
		local CARD = Color3.fromRGB(19,19,29)
		local BAR_BG = Color3.fromRGB(32,32,46)
		local MUTED = Color3.fromRGB(135,135,162)
		local gui = create({
			{1,"ScreenGui",{Name="Intro",}},
			{2,"Frame",{Active=false,BackgroundColor3=BG,BackgroundTransparency=1,BorderSizePixel=0,Name="Dim",Parent={1},Size=UDim2.new(1,0,1,0),Visible=false,}},
			{3,"Frame",{Active=true,BackgroundColor3=CARD,BorderSizePixel=0,ClipsDescendants=true,Name="Main",Parent={1},Position=UDim2.new(0.5,-220,0.5,-120),Size=UDim2.new(0,440,0,240),}},
			{4,"UICorner",{CornerRadius=UDim.new(0,16),Parent={3},}},
			{5,"UIStroke",{Color=Color3.fromRGB(70,70,100),Thickness=1,Transparency=0.35,Parent={3},}},
			{6,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(28,28,42)),ColorSequenceKeypoint.new(1,Color3.fromRGB(17,17,27))}),Parent={3},Rotation=90,}},
			{7,"Frame",{BackgroundColor3=ACCENT,BackgroundTransparency=0.85,BorderSizePixel=0,Name="Glow",Parent={3},Position=UDim2.new(0.5,-120,1,-60),Size=UDim2.new(0,240,0,120),}},
			{8,"UICorner",{CornerRadius=UDim.new(1,0),Parent={7},}},
			{9,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(56,139,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(90,160,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(56,139,255))}),Parent={7},Rotation=0,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.4),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,0.4)}) ,}},
			{10,"Frame",{BackgroundColor3=CARD,BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,Name="Holder",Parent={3},Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),}},
			{15,"TextLabel",{BackgroundTransparency=1,Font=8,Name="Title",Parent={10},Position=UDim2.new(0,28,0,20),Size=UDim2.new(1,-120,0,40),Text="Dexium",TextColor3=Color3.fromRGB(242,242,250),TextSize=36,TextXAlignment=0,TextTransparency=1,}},
			{16,"TextLabel",{BackgroundTransparency=1,Font=7,Name="Desc",Parent={10},Position=UDim2.new(0,30,0,60),Size=UDim2.new(1,-120,0,18),Text="ULTIMATE DEBUGGING SUITE",TextColor3=MUTED,TextSize=11,TextXAlignment=0,TextTransparency=1,}},
			{17,"Frame",{BackgroundColor3=Color3.fromRGB(26,36,60),BorderSizePixel=0,Name="VersionPill",Parent={3},Position=UDim2.new(1,-84,0,16),Size=UDim2.new(0,60,0,24),}},
			{18,"UICorner",{CornerRadius=UDim.new(1,0),Parent={17},}},
			{19,"UIStroke",{Color=Color3.fromRGB(56,139,255),Thickness=1,Transparency=0.45,Parent={17},}},
			{20,"TextLabel",{BackgroundTransparency=1,Font=7,Name="Version",Parent={17},Size=UDim2.new(1,0,1,0),Text="v"..tostring(Main.Version),TextColor3=Color3.fromRGB(200,200,220),TextSize=12,TextTransparency=1,}},
			{21,"TextLabel",{BackgroundTransparency=1,Font=7,Name="StatusText",Parent={10},Position=UDim2.new(0,28,0,124),Size=UDim2.new(1,-110,0,20),Text="Fetching API",TextColor3=Color3.fromRGB(210,210,226),TextSize=13,TextXAlignment=0,TextTransparency=1,}},
			{22,"TextLabel",{BackgroundTransparency=1,Font=8,Name="Percent",Parent={10},Position=UDim2.new(1,-82,0,124),Size=UDim2.new(0,54,0,20),Text="0%",TextColor3=ACCENT_L,TextSize=13,TextXAlignment=1,TextTransparency=1,}},
			{23,"Frame",{BackgroundColor3=BAR_BG,BorderSizePixel=0,Name="ProgressBar",Parent={10},Position=UDim2.new(0,28,0,152),Size=UDim2.new(1,-56,0,8),}},
			{24,"UICorner",{CornerRadius=UDim.new(1,0),Parent={23},}},
			{25,"Frame",{BackgroundColor3=ACCENT,BorderSizePixel=0,Name="Bar",Parent={23},Size=UDim2.new(0,0,1,0),}},
			{26,"UICorner",{CornerRadius=UDim.new(1,0),Parent={25},}},
			{27,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(56,139,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(120,185,255))}),Parent={25},Rotation=0,}},
			{28,"Frame",{BackgroundColor3=ACCENT,BackgroundTransparency=0.5,BorderSizePixel=0,Name="BarGlow",Parent={25},Position=UDim2.new(0,0,0,-3),Size=UDim2.new(1,0,1,6),ZIndex=0,}},
			{29,"UICorner",{CornerRadius=UDim.new(1,0),Parent={28},}},
			{30,"TextLabel",{BackgroundTransparency=1,Font=7,Name="Creator",Parent={3},Position=UDim2.new(0,28,1,-30),Size=UDim2.new(1,-140,0,18),Text="Made by Chillz, Improved by JustSomeGuest",TextColor3=MUTED,TextSize=12,TextXAlignment=0,TextTransparency=1,}},
			{31,"TextLabel",{AnchorPoint=Vector2.new(1,0),BackgroundTransparency=1,Font=7,Name="Spin",Parent={3},Position=UDim2.new(1,-24,1,-30),Size=UDim2.new(0,80,0,18),Text="loading",TextColor3=MUTED,TextSize=12,TextXAlignment=1,TextTransparency=1,}},
			{32,"UIDragDetector", {Parent={3}}}
		})
		Main.ShowGui(gui)
		Main.ApplyGothamSSm(gui)
		local mainFrame = gui.Main
		local dim = gui.Dim
		local titleText = gui.Main.Holder.Title
		local descText = gui.Main.Holder.Desc
		local versionText = gui.Main.VersionPill.Version
		local versionPill = gui.Main.VersionPill
		local creatorText = gui.Main.Creator
		local spinText = gui.Main.Spin
		local statusText = gui.Main.Holder.StatusText
		local percentText = gui.Main.Holder.Percent
		local progressBar = gui.Main.Holder.ProgressBar
		local glow = gui.Main.Glow
		local tweenS = service.TweenService

		local renderStepped = service.RunService.RenderStepped
		local signalWait = renderStepped.wait
		local fastwait = function(s)
			if not s then return signalWait(renderStepped) end
			local start = tick()
			while tick() - start < s do signalWait(renderStepped) end
		end

		statusText.Text = initStatus or "Loading Dexium..."

		local ti = TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
		mainFrame.Size = UDim2.new(0,400,0,220)
		mainFrame.Position = UDim2.new(0.5,-200,0.5,-110)
		mainFrame.BackgroundTransparency = 1
		pcall(function()
			dim.Visible = false
			dim.Active = false
		end)
		tweenS:Create(mainFrame,ti,{Size = UDim2.new(0,440,0,240), Position = UDim2.new(0.5,-220,0.5,-120), BackgroundTransparency = 0}):Play()
		for _, v in ipairs({titleText, descText, versionText, creatorText, spinText, statusText, percentText}) do
			tweenS:Create(v,ti,{TextTransparency = 0}):Play()
		end
		tweenS:Create(versionPill,TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
		fastwait(0.35)

		local progressTI = TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
		fastwait(0.1)

		coroutine.wrap(function()
			local frames = {"loading", "loading.", "loading..", "loading..."}
			local i = 1
			while mainFrame.Parent do
				pcall(function()
					spinText.Text = frames[i]
					i = i % #frames + 1
					tweenS:Create(glow,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency = 0.7}):Play()
					task.wait(0.4)
					tweenS:Create(glow,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency = 0.9}):Play()
				end)
				task.wait(0.4)
				if not mainFrame.Parent then break end
			end
		end)()

		local function setProgress(text,n)
			statusText.Text = text
			local p = math.clamp(n or 0,0,1)
			percentText.Text = tostring(math.floor(p*100+0.5)).."%"
			tweenS:Create(progressBar.Bar,progressTI,{Size = UDim2.new(p,0,1,0)}):Play()
		end

		local function close()
			local closeTI = TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
			for _,v in ipairs({titleText,descText,versionText,creatorText,spinText,statusText,percentText}) do
				tweenS:Create(v,closeTI,{TextTransparency = 1}):Play()
			end
			tweenS:Create(progressBar,closeTI,{BackgroundTransparency = 1}):Play()
			tweenS:Create(progressBar.Bar,closeTI,{BackgroundTransparency = 1}):Play()
			tweenS:Create(versionPill,closeTI,{BackgroundTransparency = 1}):Play()
			fastwait(0.24)
			tweenS:Create(mainFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size = UDim2.new(0,400,0,210), Position = UDim2.new(0.5,-200,0.5,-105), BackgroundTransparency = 1}):Play()
			fastwait(0.25)
			pcall(function() gui:Destroy() end)
		end

		return {SetProgress = setProgress, Close = close, Object = gui}
	end

	Main.CreateApp = function(data)
		if Main.MenuApps[data.Name] then return end
		local control = {}

		local app = Main.AppTemplate:Clone()
		Main.ApplyGothamSSm(app)
		app.Name = "App_" .. tostring(data.Name):gsub("%s+", "")

		local mainBtn = app.Main
		local iconLabel = mainBtn:FindFirstChild("Icon")
		local iconBG = mainBtn:FindFirstChild("IconBG")
		local nameLabel = mainBtn:FindFirstChild("AppName")
		if iconBG and iconLabel then
			iconLabel.Parent = iconBG
		end

		local iconIndex = data.Icon
		local targetIcon = iconBG and iconBG:FindFirstChild("Icon") or mainBtn:FindFirstChild("Icon", true)
		if data.IconMap and iconIndex then
			if type(iconIndex) == "number" then
				data.IconMap:Display(targetIcon,iconIndex)
			elseif type(iconIndex) == "string" then
				data.IconMap:DisplayByKey(targetIcon,iconIndex)
			end
		elseif type(iconIndex) == "string" then
			targetIcon.Image = iconIndex
		else
			targetIcon.Image = ""
		end

		local tweenS = service.TweenService
		local function updateState()
			local open = data.Open and true or false
			mainBtn.BackgroundColor3 = open and Settings.Theme.ListSelection or Settings.Theme.Button
			if iconBG then
				iconBG.BackgroundColor3 = Color3.fromRGB(22,22,33)
				iconBG.BackgroundTransparency = 0
				local iconStroke = iconBG:FindFirstChildOfClass("UIStroke")
				if iconStroke then
					iconStroke.Color = open and Settings.Theme.Accent or Color3.fromRGB(70,70,100)
					iconStroke.Transparency = open and 0.1 or 0.55
				end
			end
			local hl = mainBtn:FindFirstChild("Highlight")
			if hl then hl.Visible = open end
			local stroke = mainBtn:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = open and Settings.Theme.AccentLight or Color3.fromRGB(62,62,88)
				stroke.Transparency = open and 0.05 or 0.4
			end
			if nameLabel then
				nameLabel.TextColor3 = open and Color3.fromRGB(255,255,255) or Settings.Theme.Text
			end
		end

		local function enable(silent)
			if data.Open then return end
			data.Open = true
			updateState()
			pcall(function()
				tweenS:Create(mainBtn,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,-4,0,82)}):Play()
				task.delay(0.12, function()
					pcall(function() tweenS:Create(mainBtn,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,0,86)}):Play() end)
				end)
			end)
			if not silent then
				if data.Window then data.Window:Show() end
				if data.OnClick then data.OnClick(data.Open) end
			end
		end

		local function disable(silent)
			if not data.Open then return end
			data.Open = false
			updateState()
			if not silent then
				if data.Window then data.Window:Hide() end
				if data.OnClick then data.OnClick(data.Open) end
			end
		end

		updateState()

		if nameLabel then nameLabel.Text = data.Name end

		mainBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if not data.Open then
					tweenS:Create(mainBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3 = Settings.Theme.ButtonHover}):Play()
				end
			end
		end)

		mainBtn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				updateState()
			end
		end)

		mainBtn.MouseButton1Click:Connect(function()
			if data.Open then disable() else enable() end
		end)

		local window = data.Window
		if window then
			window.OnActivate:Connect(function() enable(true) end)
			window.OnDeactivate:Connect(function() disable(true) end)
		end

		app.Visible = true
		app.Parent = Main.AppsContainer
		if Main._SearchFilter and Main._SearchFilter ~= "" then
			local q = string.lower(Main._SearchFilter)
			app.Visible = string.find(string.lower(data.Name), q, 1, true) ~= nil
		end

		control.Enable = enable
		control.Disable = disable
		Main.MenuApps[data.Name] = control
		return control
	end

	Main.SetMainGuiOpen = function(val)
		Main.MainGuiOpen = val

		local openBtn = Main.MainGui.OpenButton
		local titleLbl = openBtn:FindFirstChild("Title")
		local chevLbl = openBtn:FindFirstChild("Chevron")
		if titleLbl then titleLbl.Text = val and "Close" or "Dexium" end
		if chevLbl then chevLbl.Text = val and "^" or "v" end
		if val then openBtn.MainFrame.Visible = true end
		pcall(function()
			local sc = openBtn.MainFrame:FindFirstChild("UIScale")
			if sc then
				sc.Scale = val and 0.94 or 1
				service.TweenService:Create(sc,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale = 1}):Play()
			end
		end)
		openBtn.MainFrame:TweenSize(val and UDim2.new(0,300,0,368) or UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.22,true)
		service.TweenService:Create(openBtn,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = val and 0 or (Lib.CheckMouseInGui(openBtn) and 0 or 0.08)}):Play()

		if Main.MainGuiMouseEvent then Main.MainGuiMouseEvent:Disconnect() end

		if not val then
			local startTime = tick()
			Main.MainGuiCloseTime = startTime
			coroutine.wrap(function()
				Lib.FastWait(0.22)
				if not Main.MainGuiOpen and startTime == Main.MainGuiCloseTime then openBtn.MainFrame.Visible = false end
			end)()
		else
			Main.MainGuiMouseEvent = service.UserInputService.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Lib.CheckMouseInGui(openBtn) and not Lib.CheckMouseInGui(openBtn.MainFrame) then

					Main.SetMainGuiOpen(false)
				end
			end)
		end
	end

	Main.CreateMainGui = function()
		local ACC = Color3.fromRGB(56,139,255)
		local gui = create({
			{1,"ScreenGui",{IgnoreGuiInset=true,Name="MainMenu",}},
			{2,"TextButton",{AnchorPoint=Vector2.new(0.5,0),AutoButtonColor=false,BackgroundColor3=Color3.fromRGB(19,19,28),BorderSizePixel=0,Font=8,Name="OpenButton",Parent={1},Position=UDim2.new(0.5,0,0,8),Size=UDim2.new(0,112,0,38),Text="",TextColor3=Color3.fromRGB(240,240,248),TextSize=15,TextTransparency=0,}},
			{3,"UICorner",{CornerRadius=UDim.new(0,12),Parent={2},}},
			{4,"UIStroke",{Color=Color3.fromRGB(70,70,100),Thickness=1,Transparency=0.3,Parent={2},}},
			{5,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,44)),ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,28))}),Parent={2},Rotation=90,}},
			{50,"Frame",{BackgroundColor3=ACC,BorderSizePixel=0,Name="Dot",Parent={2},Position=UDim2.new(0,14,0.5,-5),Size=UDim2.new(0,10,0,10),}},
			{51,"UICorner",{CornerRadius=UDim.new(1,0),Parent={50},}},
			{52,"TextLabel",{BackgroundTransparency=1,Font=8,Name="Title",Parent={2},Position=UDim2.new(0,30,0,1),Size=UDim2.new(1,-52,1,-1),Text="Dexium",TextColor3=Color3.fromRGB(242,242,250),TextSize=15,TextXAlignment=0,}},
			{53,"TextLabel",{BackgroundTransparency=1,Font=8,Name="Chevron",Parent={2},Position=UDim2.new(1,-26,0,1),Size=UDim2.new(0,18,1,-1),Text="v",TextColor3=Color3.fromRGB(135,135,162),TextSize=14,}},
			{6,"Frame",{AnchorPoint=Vector2.new(0.5,0),BackgroundColor3=Color3.fromRGB(17,17,26),BorderSizePixel=0,ClipsDescendants=true,Name="MainFrame",Parent={2},Position=UDim2.new(0.5,0,1,8),Size=UDim2.new(0,300,0,368),}},
			{60,"UIScale",{Parent={6},}},
			{7,"UICorner",{CornerRadius=UDim.new(0,16),Parent={6},}},
			{8,"UIStroke",{Color=Color3.fromRGB(70,70,100),Thickness=1,Transparency=0.3,Parent={6},}},
			{61,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(26,26,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,15,24))}),Parent={6},Rotation=90,}},
			{62,"Frame",{BackgroundTransparency=1,Name="Header",Parent={6},Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,60),}},
			{67,"TextLabel",{BackgroundTransparency=1,Font=8,Name="AppTitle",Parent={62},Position=UDim2.new(0,16,0,10),Size=UDim2.new(1,-28,0,22),Text="Dexium",TextColor3=Color3.fromRGB(242,242,250),TextSize=17,TextXAlignment=0,}},
			{68,"TextLabel",{BackgroundTransparency=1,Font=7,Name="AppSub",Parent={62},Position=UDim2.new(0,17,0,31),Size=UDim2.new(1,-28,0,16),Text="v"..tostring(Main.Version).."  •  debugging suite",TextColor3=Color3.fromRGB(135,135,162),TextSize=11,TextXAlignment=0,}},
			{70,"Frame",{BackgroundColor3=Settings.Theme.SearchBar or Color3.fromRGB(28,34,56),BorderSizePixel=0,Name="SearchBG",Parent={6},Position=UDim2.new(0,14,0,62),Size=UDim2.new(1,-28,0,32),}},
			{71,"UICorner",{CornerRadius=UDim.new(0,10),Parent={70},}},
			{72,"UIStroke",{Color=Color3.fromRGB(62,62,88),Thickness=1,Transparency=0.45,Parent={70},}},
			{73,"TextLabel",{BackgroundTransparency=1,Font=7,Name="SearchIcon",Parent={70},Position=UDim2.new(0,10,0,0),Size=UDim2.new(0,18,1,0),Text="",TextColor3=Color3.fromRGB(135,135,162),TextSize=15,}},
			{74,"TextBox",{BackgroundTransparency=1,ClearTextOnFocus=false,Font=7,Name="SearchBox",Parent={70},PlaceholderColor3=Color3.fromRGB(135,135,162),PlaceholderText="Search tools...",Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-22,1,0),Text="",TextColor3=Color3.fromRGB(240,240,248),TextSize=13,TextXAlignment=0,}},
			{9,"Frame",{BackgroundColor3=Color3.fromRGB(24,24,35),BackgroundTransparency=1,BorderSizePixel=0,Name="BottomFrame",Parent={6},Position=UDim2.new(0,0,1,-42),Size=UDim2.new(1,0,0,42),}},
			{10,"UICorner",{CornerRadius=UDim.new(0,14),Parent={9},}},
			{11,"Frame",{BackgroundColor3=Color3.fromRGB(24,24,35),BackgroundTransparency=1,BorderSizePixel=0,Name="CoverFrame",Parent={9},Size=UDim2.new(1,0,0,14),}},
			{12,"Frame",{BackgroundColor3=Color3.fromRGB(45,45,62),BackgroundTransparency=0.5,BorderSizePixel=0,Name="Line",Parent={11},Position=UDim2.new(0,14,0,0),Size=UDim2.new(1,-28,0,1),}},
			{13,"TextButton",{BackgroundColor3=Color3.fromRGB(33,33,47),BackgroundTransparency=0.35,Font=7,Name="Settings",Parent={9},Position=UDim2.new(1,-76,0.5,-14),Size=UDim2.new(0,28,0,28),Text="",TextColor3=Color3.fromRGB(240,240,248),TextSize=14,}},
			{14,"ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://6578871732",ImageColor3=Color3.fromRGB(190,190,208),Name="Icon",Parent={13},Position=UDim2.new(0.5,-8,0.5,-8),Size=UDim2.new(0,16,0,16),}},
			{15,"UICorner",{CornerRadius=UDim.new(0,8),Parent={13},}},
			{16,"TextButton",{BackgroundColor3=Color3.fromRGB(33,33,47),BackgroundTransparency=0.35,Font=7,Name="Information",Parent={9},Position=UDim2.new(1,-40,0.5,-14),Size=UDim2.new(0,28,0,28),Text="",TextColor3=Color3.fromRGB(240,240,248),TextSize=14,}},
			{17,"ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://6578933307",ImageColor3=Color3.fromRGB(190,190,208),Name="Icon",Parent={16},Position=UDim2.new(0.5,-8,0.5,-8),Size=UDim2.new(0,16,0,16),}},
			{18,"UICorner",{CornerRadius=UDim.new(0,8),Parent={16},}},
			{19,"TextLabel",{BackgroundTransparency=1,Font=7,Name="TitleLabel",Parent={9},Position=UDim2.new(0,14,0,0),Size=UDim2.new(0,150,1,0),Text="Dexium v"..tostring(Main.Version),TextColor3=Color3.fromRGB(135,135,162),TextSize=12,TextXAlignment=0,}},
			{20,"ScrollingFrame",{Active=true,AnchorPoint=Vector2.new(0.5,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,Name="AppsFrame",Parent={6},Position=UDim2.new(0.5,0,0,102),ScrollBarImageColor3=ACC,ScrollBarThickness=3,Size=UDim2.new(1,-8,1,-152),CanvasSize=UDim2.new(0,0,0,0),ScrollBarImageTransparency=0.2,}},
			{21,"Frame",{AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Name="Container",Parent={20},Position=UDim2.new(0,10,0,4),Size=UDim2.new(1,-20,0,2),}},
			{22,"UIGridLayout",{CellPadding=UDim2.new(0,8,0,10),CellSize=UDim2.new(0,82,0,86),Parent={21},SortOrder=2,}},
			{23,"UIPadding",{PaddingTop=UDim.new(0,2),Parent={20},}},
			{24,"Frame",{BackgroundTransparency=1,Name="App",Parent={1},Size=UDim2.new(0,82,0,86),Visible=false,}},
			{25,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.fromRGB(33,33,47),BorderSizePixel=0,Font=7,Name="Main",Parent={24},Size=UDim2.new(1,0,0,86),Text="",TextColor3=Color3.fromRGB(0,0,0),TextSize=14,}},
			{26,"UICorner",{CornerRadius=UDim.new(0,14),Parent={25},}},
			{27,"UIStroke",{Color=Color3.fromRGB(62,62,88),Thickness=1,Transparency=0.4,Parent={25},}},
			{28,"Frame",{BackgroundColor3=Color3.fromRGB(22,22,33),BorderSizePixel=0,Name="IconBG",Parent={25},Position=UDim2.new(0.5,-20,0,10),Size=UDim2.new(0,40,0,40),}},
			{31,"UICorner",{CornerRadius=UDim.new(0,12),Parent={28},}},
			{32,"UIStroke",{Color=Color3.fromRGB(70,70,100),Thickness=1,Transparency=0.55,Parent={28},}},
			{29,"ImageLabel",{BackgroundTransparency=1,Image="rbxassetid://129589545519436",ImageRectSize=Vector2.new(32,32),Name="Icon",Parent={28},Position=UDim2.new(0.5,-13,0.5,-13),ScaleType=4,Size=UDim2.new(0,26,0,26),}},
			{30,"TextLabel",{BackgroundTransparency=1,Font=7,Name="AppName",Parent={25},Position=UDim2.new(0,4,0,54),Size=UDim2.new(1,-8,0,26),Text="Explorer",TextColor3=Color3.fromRGB(240,240,248),TextSize=11,TextTransparency=0,TextTruncate=1,TextWrapped=true,TextYAlignment=0,}},
			{33,"Frame",{BackgroundColor3=ACC,BorderSizePixel=0,Name="Highlight",Parent={25},Position=UDim2.new(0.5,-16,1,-7),Size=UDim2.new(0,32,0,4),Visible=false,}},
			{34,"UICorner",{CornerRadius=UDim.new(1,0),Parent={33},}},
			{35,"UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,ACC),ColorSequenceKeypoint.new(1,Color3.fromRGB(120,185,255))}),Parent={33},Rotation=0,}},
		})
		Main.ApplyGothamSSm(gui)
		Main.MainGui = gui
		Main.AppsFrame = gui.OpenButton.MainFrame.AppsFrame
		Main.AppsContainer = Main.AppsFrame.Container
		Main.AppsContainerGrid = Main.AppsContainer.UIGridLayout
		Main.AppTemplate = gui.App
		Main.MainGuiOpen = false

		local openButton = gui.OpenButton
		openButton.BackgroundTransparency = 0.08
		openButton.MainFrame.Size = UDim2.new(0,0,0,0)
		openButton.MainFrame.Visible = false
		openButton.MouseButton1Click:Connect(function()
			Main.SetMainGuiOpen(not Main.MainGuiOpen)
		end)

		openButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				service.TweenService:Create(openButton,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
			end
		end)

		openButton.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				service.TweenService:Create(openButton,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = Main.MainGuiOpen and 0 or 0.08}):Play()
			end
		end)

		Main._SearchFilter = ""
		local searchBox = openButton.MainFrame.SearchBG.SearchBox
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local q = string.lower(searchBox.Text or "")
			Main._SearchFilter = q
			for _, child in ipairs(Main.AppsContainer:GetChildren()) do
				if child:IsA("Frame") and child.Name ~= "UIGridLayout" then
					local btn = child:FindFirstChild("Main")
					local lbl = btn and btn:FindFirstChild("AppName")
					if lbl then
						child.Visible = q == "" or string.find(string.lower(lbl.Text), q, 1, true) ~= nil
					end
				end
			end
		end)
		openButton.MainFrame.SearchBG.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				pcall(function() searchBox:CaptureFocus() end)
			end
		end)

		for _, btnName in ipairs({"Settings", "Information"}) do
			local b = openButton.MainFrame.BottomFrame:FindFirstChild(btnName)
			if b then
				b.MouseEnter:Connect(function()
					service.TweenService:Create(b,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
				end)
				b.MouseLeave:Connect(function()
					service.TweenService:Create(b,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = 0.35}):Play()
				end)
			end
		end
		
		local creditsWindow
		
		openButton.MainFrame.BottomFrame.Settings.MouseButton1Click:Connect(function()
			if not SettingsWindow.Window.Closed then
				SettingsWindow.Window:Hide()
			else
				SettingsWindow.Window:Show()
			end		
		end)
		
		openButton.MainFrame.BottomFrame.Information.MouseButton1Click:Connect(function()
			if not creditsWindow then
				creditsWindow = Lib.Window.new()
				creditsWindow:SetTitle("Credits")
				creditsWindow:Resize(320, 330)
				creditsWindow.Alignable = false
				local content = creditsWindow.GuiElems.Content

				local contentCorner = content:FindFirstChildOfClass("UICorner")
				if contentCorner then
					contentCorner.TopLeftRadius = UDim.new(0, 0)
					contentCorner.TopRightRadius = UDim.new(0, 0)
				end

				local pad = Instance.new("UIPadding")
				pad.PaddingTop = UDim.new(0, 10)
				pad.PaddingLeft = UDim.new(0, 12)
				pad.PaddingRight = UDim.new(0, 12)
				pad.PaddingBottom = UDim.new(0, 10)
				pad.Parent = content

				local header = Instance.new("TextLabel")
				header.BackgroundTransparency = 1
				header.Font = Enum.Font.GothamBold
				header.TextSize = 22
				header.TextXAlignment = Enum.TextXAlignment.Left
				header.TextColor3 = Settings.Theme.Text
				header.Text = "Dexium v"..tostring(Main.Version)
				header.Position = UDim2.new(0, 0, 0, 0)
				header.Size = UDim2.new(1, 0, 0, 28)
				header.Parent = content

				local sub = Instance.new("TextLabel")
				sub.BackgroundTransparency = 1
				sub.Font = Enum.Font.GothamMedium
				sub.TextSize = 13
				sub.TextXAlignment = Enum.TextXAlignment.Left
				sub.TextColor3 = Settings.Theme.PlaceholderText
				sub.Text = "People who made this possible"
				sub.Position = UDim2.new(0, 0, 0, 30)
				sub.Size = UDim2.new(1, 0, 0, 18)
				sub.Parent = content

				local scroll = Instance.new("ScrollingFrame")
				scroll.BackgroundTransparency = 1
				scroll.BorderSizePixel = 0
				scroll.ScrollBarThickness = 3
				scroll.ScrollBarImageColor3 = Settings.Theme.Accent
				scroll.ScrollBarImageTransparency = 0.2
				scroll.Position = UDim2.new(0, 0, 0, 54)
				scroll.Size = UDim2.new(1, 0, 1, -64)
				scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scroll.ScrollingDirection = Enum.ScrollingDirection.Y
				scroll.Parent = content

				local list = Instance.new("UIListLayout")
				list.SortOrder = Enum.SortOrder.LayoutOrder
				list.Padding = UDim.new(0, 6)
				list.Parent = scroll

				local credits = {
				    {"Moon", "Original Dex"},
				    {"Chillz", "Dex++ - Mobile support & improvements"},
				    {"Toon", "IY Dex & PRs"},
    				{"Cazan", "3D Preview"},
   					{"JustSomeGuest", "Dexium - UI remake & maintenance"},
				}
				
				for i, c in ipairs(credits) do
					local row = Instance.new("Frame")
					row.BackgroundColor3 = Settings.Theme.Button
					row.BorderSizePixel = 0
					row.Size = UDim2.new(1, -6, 0, 46)
					row.LayoutOrder = i
					row.Parent = scroll

					local rowCorner = Instance.new("UICorner")
					rowCorner.CornerRadius = UDim.new(0, 10)
					rowCorner.Parent = row

					local rowStroke = Instance.new("UIStroke")
					rowStroke.Color = Settings.Theme.Outline2
					rowStroke.Transparency = 0.5
					rowStroke.Thickness = 1
					rowStroke.Parent = row

					local accent = Instance.new("Frame")
					accent.BackgroundColor3 = Settings.Theme.Accent
					accent.BorderSizePixel = 0
					accent.Position = UDim2.new(0, 0, 0, 10)
					accent.Size = UDim2.new(0, 3, 1, -20)
					accent.Parent = row
					local accentCorner = Instance.new("UICorner")
					accentCorner.CornerRadius = UDim.new(1, 0)
					accentCorner.Parent = accent

					local nameLabel = Instance.new("TextLabel")
					nameLabel.BackgroundTransparency = 1
					nameLabel.Font = Enum.Font.GothamBold
					nameLabel.TextSize = 14
					nameLabel.TextXAlignment = Enum.TextXAlignment.Left
					nameLabel.TextColor3 = Settings.Theme.Text
					nameLabel.Text = c[1]
					nameLabel.Position = UDim2.new(0, 14, 0, 4)
					nameLabel.Size = UDim2.new(1, -24, 0, 18)
					nameLabel.Parent = row

					local roleLabel = Instance.new("TextLabel")
					roleLabel.BackgroundTransparency = 1
					roleLabel.Font = Enum.Font.GothamMedium
					roleLabel.TextSize = 12
					roleLabel.TextXAlignment = Enum.TextXAlignment.Left
					roleLabel.TextColor3 = Settings.Theme.PlaceholderText
					roleLabel.Text = c[2]
					roleLabel.Position = UDim2.new(0, 14, 0, 23)
					roleLabel.Size = UDim2.new(1, -24, 0, 16)
					roleLabel.Parent = row
				end

				Main.ApplyGothamSSm(content)
			end
			if creditsWindow.Closed then
				creditsWindow:Show()
			else
				creditsWindow:Hide()
			end
		end)

		Main.CreateApp({Name = "Explorer", IconMap = Main.LargeIcons, Icon = "Explorer", Open = true, Window = Explorer.Window})

		Main.CreateApp({Name = "Properties", IconMap = Main.LargeIcons, Icon = "Properties", Open = true, Window = Properties.Window})

		local cptsOnMouseClick = nil
		Main.CreateApp({Name = "Click part to select", IconMap = Explorer.ClassIcons, Icon = "SelectionBox", OnClick = function(callback)
			if callback then
				local mouse = Main.Mouse
				cptsOnMouseClick = mouse.Button1Down:Connect(function()
					pcall(function()
						local object = mouse.Target
						if nodes[object] then
							selection:Set(nodes[object])
							Explorer.ViewNode(nodes[object])
						end
					end)
				end)
			else if cptsOnMouseClick ~= nil then cptsOnMouseClick:Disconnect() cptsOnMouseClick = nil end end
		end})

		Main.CreateApp({Name = "Notepad", IconMap = Main.LargeIcons, Icon = "Script_Viewer", Window = ScriptViewer.Window})
		
		Main.CreateApp({Name = "Console", IconMap = Main.LargeIcons, Icon = "Executor", Window = Console.Window})
		
		Main.CreateApp({Name = "Save Instance", IconMap = Main.LargeIcons, Icon = "Book", Window = SaveInstance.Window})
		
		Main.CreateApp({Name = "3D Viewer", IconMap = Main.LargeIcons, Icon = "Object", Window = ModelViewer.Window})

		for _, loadedplugin in pairs(Main.Plugins) do
			Main.CreateApp({Name = loadedplugin.PluginData.FriendlyName, IconMap = Explorer.ClassIcons, Icon = "Attachment", Window = loadedplugin.Window})
		end
		
		Lib.ShowGui(gui)
	end

	Main.SetupFilesystem = function()
		if not env.writefile or not env.makefolder then return end

		local writefile,makefolder = env.writefile,env.makefolder

		makefolder("dexium")
		makefolder("dexium/assets")
		makefolder("dexium/saved")
		makefolder("dexium/plugins")
		makefolder("dexium/ModuleCache")
	end

	Main.SaveCurrentSettings = function()
		local _writefile = (env and env.writefile) or writefile
		local _makefolder = (env and env.makefolder) or makefolder
		if _writefile then
			if _makefolder then pcall(_makefolder, Main.DataFolder) end
			pcall(_writefile, Main.SettingsPath, Main.ExportSettings())
		end
	end

	Main.LocalDepsUpToDate = function()
		return Main.DepsVersionData and Main.ClientVersion == Main.DepsVersionData[1]
	end

	Main.Init = function()
		Main.Elevated = pcall(function() local a = game:GetService("CoreGui"):GetFullName() end)
		
		Main.InitEnv()
		Main.SetupFilesystem()
		
		do
			local _isfile = env.isfile or isfile
			if _isfile then
				local ok, exists = pcall(_isfile, Main.SettingsPath)
				if not ok or not exists then
					Main.SaveCurrentSettings()
				end
			end
		end
		Main.LoadSettings()

		local intro = Main.CreateIntro("Initializing Library")
		Main._Intro = intro
		Lib = Main.LoadModule("Lib")
		Lib.FastWait()

		Main.IncompatibleTest()

		Main.MiscIcons = Lib.IconMap.new("rbxassetid://6511490623",256,256,16,16)
		Main.MiscIcons:SetDict({
			Reference = 0,             Cut = 1,                         Cut_Disabled = 2,      Copy = 3,               Copy_Disabled = 4,    Paste = 5,                Paste_Disabled = 6,
			Delete = 7,                Delete_Disabled = 8,             Group = 9,             Group_Disabled = 10,    Ungroup = 11,         Ungroup_Disabled = 12,    TeleportTo = 13,
			Rename = 14,               JumpToParent = 15,               ExploreData = 16,      Save = 17,              CallFunction = 18,    CallRemote = 19,          Undo = 20,
			Undo_Disabled = 21,        Redo = 22,                       Redo_Disabled = 23,    Expand_Over = 24,       Expand = 25,          Collapse_Over = 26,       Collapse = 27,
			SelectChildren = 28,       SelectChildren_Disabled = 29,    InsertObject = 30,     ViewScript = 31,        AddStar = 32,         RemoveStar = 33,          Script_Disabled = 34,
			LocalScript_Disabled = 35, Play = 36,                       Pause = 37,            Rename_Disabled = 38,   Empty = 1000
		})
		Main.LargeIcons = Lib.IconMap.new("rbxassetid://129589545519436",256,256,32,32)
		Main.LargeIcons:SetDict({
			Explorer = 0, Properties = 1, Script_Viewer = 2, Watcher = 3, Output = 4, ScriptEdit = 5, Book = 6, Executor = 7, Object = 8, Honey = 9
		})
		
		intro.SetProgress("Fetching Roblox Version",0.3)
		if Main.Elevated then
			local fileVer = Lib.ReadFile("dexium/deps_version.dat")
			Main.ClientVersion = Version()
			if fileVer then
				Main.DepsVersionData = string.split(fileVer,"\n")
				if Main.LocalDepsUpToDate() then
					Main.RobloxVersion = Main.DepsVersionData[2]
				end
			end
			
			Main.RobloxVersion = Main.RobloxVersion or oldgame:HttpGet("https://clientsettings.roblox.com/v2/client-version/WindowsStudio64/channel/LIVE"):match("(version%-[%w]+)")
		end

		intro.SetProgress("Fetching API",0.35)
		API = Main.FetchAPI(
			function()
				intro.SetProgress("Fetching API, Please Wait.",0.4)
			end,
			function()
				intro.SetProgress("Fetching API, Please Wait Due To Huge API File To Download.",0.45)
			end,
			function()
				intro.SetProgress("Fetching API, LOL STILL DOWNlOADING? bad wifi xD",0.475)
			end
		)
		Lib.FastWait()
		intro.SetProgress("Fetching RMD",0.5)
		RMD = Main.FetchRMD()
		Lib.FastWait()

		if Main.Elevated and env.writefile and not Main.LocalDepsUpToDate() then
			env.writefile("dexium/deps_version.dat",Main.ClientVersion.."\n"..Main.RobloxVersion)
			env.writefile("dexium/rbx_api.dat",Main.RawAPI)
			env.writefile("dexium/rbx_rmd.dat",Main.RawRMD)
		end

		intro.SetProgress("Loading Modules",0.75)
		Main.AppControls.Lib.InitDeps(Main.GetInitDeps())
		Main.LoadModules(function(modName, idx, total)
			intro.SetProgress("Loading modules ("..tostring(idx).."/"..tostring(total)..")", 0.75 + (idx/total)*0.05)
		end)
		Lib.FastWait()

		intro.SetProgress("Initializing Modules",0.8)
		Explorer.Init()
		Properties.Init()
		ScriptViewer.Init()
		Console.Init()
		SaveInstance.Init()
		ModelViewer.Init()
		SettingsWindow.Init()
		
		if env.readfile and listfiles then
			if #listfiles("dexium/plugins") > 0 then
				intro.SetProgress("Loading Plugin Files",0.8)
				for _, pluginDir in pairs(listfiles("dexium/plugins")) do
					local moduleData = Main.LoadPluginFile(pluginDir)
					moduleData.PluginData = moduleData.PluginData or {}

					moduleData.Init()

					local pluginFriendlyName = moduleData.PluginData.FriendlyName or moduleData.Window.GuiElems.Title.Text or "Unnamed Plugin"
					local pluginName = moduleData.PluginData.Name or moduleData.Window.GuiElems.Title.Text:gsub(" ", "") or "unnamedPlugin"

					intro.SetProgress("Initializing Plugin: ".. pluginFriendlyName,0.9)

					moduleData.PluginData.Name = pluginName
					moduleData.PluginData.FriendlyName = pluginFriendlyName

					table.insert(Main.Plugins, moduleData)
				end
			end	
		end
		
		Lib.FastWait()

		intro.SetProgress("Complete",1)
		coroutine.wrap(function()
			Lib.FastWait(1.25)
			intro.Close()
		end)()

		Lib.Window.Init()
		Main.CreateMainGui()
		Explorer.Window:Show({Align = "right", Pos = 1, Size = 0.5, Silent = true})
		Properties.Window:Show({Align = "right", Pos = 2, Size = 0.5, Silent = true})
		
		Lib.DeferFunc(function() Lib.Window.ToggleSide("right") end)
	end
	
	Main.Uninit = function()
		Main.MenuApps = {}
		Main.AppControls = {}
		Main.Plugins = {}
		for _, gui in pairs(Main.GetSecureContainer():GetChildren()) do
			if string.sub(gui.Name,1,5) == "_DXM_" then
				gui:Destroy()
			end
		end
	end

	Main.Reinit = function()
		Main.Uninit()
		task.wait()
		Main.Init()
	end

	return Main
end)()

Main.Init()