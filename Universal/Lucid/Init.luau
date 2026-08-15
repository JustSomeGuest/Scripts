if not game:IsLoaded() then
game.Loaded:Wait()
end
local _0x012A = (type(getgenv) ==string.char(102,117,110,99,116,105,111,110)and getgenv()) or shared or _G
local function _0x4783(_0x3E08)
local _0x3E08 = game:GetService(_0x3E08)
return cloneref and cloneref(_0x3E08) or _0x3E08
end
local _0x6A51 = gethui and gethui() or _0x4783(string.char(67,111,114,101,71,117,105))
local _0x34CA = _0x4783(string.char(87,111,114,107,115,112,97,99,101))
local _0x2D6D = _0x4783(string.char(72,116,116,112,83,101,114,118,105,99,101))
local _0x436D = _0x4783(string.char(80,108,97,121,101,114,115))
local _0x0F90 = _0x436D.LocalPlayer
local _0x86B4 = _0x4783(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local _0x44D7 = _0x4783(string.char(84,119,101,101,110,83,101,114,118,105,99,101))
local _0xB65B = _0x4783(string.char(83,116,97,114,116,101,114,71,117,105))
local _0x5D17 = _0x4783(string.char(82,117,110,83,101,114,118,105,99,101))
local _0xC889 = writefile or function() end
local _0x0B78 = readfile or function() end
local _0x51AC = delfile or function() end
local _0x0172 = isfile or function() end
local _0x7C4A = isfolder or function() end
local _0xC3F3 = makefolder or function() end
local _0xE3A8 = listfiles or function() end
local _0x5444 = getcustomasset or getsynasset or function() end
local _0x8139 = setclipboard or function() end
local _0x8239 = task.wait
local _0x0EEB = Font.new(string.char(114,98,120,97,115,115,101,116,58,47,47,102,111,110,116,115,47,102,97,109,105,108,105,101,115,47,71,111,116,104,97,109,83,83,109,46,106,115,111,110), Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local _0x1033 = Font.new(string.char(114,98,120,97,115,115,101,116,58,47,47,102,111,110,116,115,47,102,97,109,105,108,105,101,115,47,71,111,116,104,97,109,83,83,109,46,106,115,111,110), Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local _0x340D = Font.new(string.char(114,98,120,97,115,115,101,116,58,47,47,102,111,110,116,115,47,102,97,109,105,108,105,101,115,47,66,117,105,108,100,101,114,83,97,110,115,46,106,115,111,110), Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local _0x296B = Font.new(string.char(114,98,120,97,115,115,101,116,58,47,47,102,111,110,116,115,47,102,97,109,105,108,105,101,115,47,73,110,99,111,110,115,111,108,97,116,97,46,106,115,111,110), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local _0xEFDB = {
Keyword =string.char(35,70,56,54,68,55,67),
Number =string.char(35,70,70,67,54,54,68),
String =string.char(35,65,53,69,48,55,53),
Comment =string.char(35,55,70,56,67,57,56),
Global =string.char(35,56,52,68,54,70,55),
Function =string.char(35,70,56,68,54,54,68),
Property =string.char(35,68,55,66,65,55,68),
Class =string.char(35,52,69,67,57,66,48),
Enum =string.char(35,67,53,56,54,67,48),
EnumItem =string.char(35,66,56,68,55,70,70),
Operator =string.char(35,68,52,68,52,68,52),
Identifier =string.char(35,69,54,69,54,69,54),
Nil =string.char(35,53,54,57,67,68,54),
Boolean =string.char(35,53,54,57,67,68,54)}
_0x012A.Lucid = {
_0xE3E8 = {},
_0x418A = {},
_0x0C17 = {
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,108,111,103,111,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,108,111,103,111,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,104,111,109,101,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,104,111,109,101,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,101,120,101,99,117,116,111,114,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,101,120,101,99,117,116,111,114,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,101,97,114,99,104,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,115,101,97,114,99,104,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,99,114,105,112,116,115,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,115,99,114,105,112,116,115,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,109,117,115,105,99,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,109,117,115,105,99,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,101,116,116,105,110,103,115,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,115,101,116,116,105,110,103,115,46,112,110,103),
[string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,99,108,111,115,101,46,112,110,103)] =string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,74,117,115,116,83,111,109,101,71,117,101,115,116,47,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,76,117,99,105,100,47,65,115,115,101,116,115,47,99,108,111,115,101,46,112,110,103),
},
_0x87A2 = {
Animations = true,
BackgroundColor = Color3.fromRGB(0, 0, 0),
SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10),
AccentColor = Color3.fromRGB(0, 99, 255),
SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
},
IsLoaded = false
}
local _0xE3E8 = _0x012A.Lucid.UI
local _0x418A = _0x012A.Lucid.Funcs
local _0x0C17 = _0x012A.Lucid.Assets
local _0x87A2 = _0x012A.Lucid.Settings
local _0xCC51 = 1
local _0xB84E = 1
local _0x1CC3 =""_0x418A.Sources = {string.char(82,83,99,114,105,112,116,115),string.char(83,99,114,105,112,116,66,108,111,120)}
_0x418A.CurrentSource =string.char(82,83,99,114,105,112,116,115)_0x418A.Filters = {string.char(65,108,108),string.char(75,101,121),string.char(75,101,121,108,101,115,115)}
_0x418A.CurrentFilter =string.char(65,108,108)_0x418A.CurrentScripts = {}
local _0x2B10 = {}
local _0xBFF5 = 0
local _0x1CF4 = nil
local _0x6B61 = nil
local _0x3162 = {}
local _0xD865 = 1
local _0x140A = false
local _0xEFB8 = false
local _0x4D82 = {string.char(108,111,99,97,108),string.char(102,117,110,99,116,105,111,110),string.char(105,102),string.char(116,104,101,110),string.char(101,108,115,101),string.char(101,108,115,101,105,102),string.char(101,110,100),string.char(102,111,114),string.char(119,104,105,108,101),string.char(114,101,112,101,97,116),string.char(117,110,116,105,108),string.char(100,111),string.char(114,101,116,117,114,110),string.char(98,114,101,97,107),string.char(99,111,110,116,105,110,117,101),string.char(105,110),string.char(110,111,116),string.char(97,110,100),string.char(111,114),string.char(110,105,108),string.char(116,114,117,101),string.char(102,97,108,115,101),string.char(116,121,112,101),string.char(116,121,112,101,111,102),string.char(101,120,112,111,114,116)}
local _0x1D7E = {string.char(103,97,109,101),string.char(119,111,114,107,115,112,97,99,101),string.char(115,99,114,105,112,116),string.char(73,110,115,116,97,110,99,101),string.char(69,110,117,109),string.char(67,111,108,111,114,51),string.char(86,101,99,116,111,114,50),string.char(86,101,99,116,111,114,51),string.char(85,68,105,109),string.char(85,68,105,109,50),string.char(67,70,114,97,109,101),string.char(109,97,116,104),string.char(115,116,114,105,110,103),string.char(116,97,98,108,101),string.char(116,97,115,107),string.char(99,111,114,111,117,116,105,110,101),string.char(111,115),string.char(117,116,102,56),string.char(105,112,97,105,114,115),string.char(112,97,105,114,115),string.char(110,101,120,116),string.char(112,99,97,108,108),string.char(120,112,99,97,108,108),string.char(116,111,110,117,109,98,101,114),string.char(116,111,115,116,114,105,110,103),string.char(119,97,114,110),string.char(112,114,105,110,116),string.char(114,101,113,117,105,114,101),string.char(115,101,108,101,99,116),string.char(114,97,119,101,113,117,97,108),string.char(114,97,119,103,101,116),string.char(114,97,119,115,101,116),string.char(116,121,112,101),string.char(117,110,112,97,99,107),string.char(97,115,115,101,114,116),string.char(101,114,114,111,114),string.char(103,101,116,102,101,110,118),string.char(115,101,116,102,101,110,118),string.char(103,101,116,109,101,116,97,116,97,98,108,101),string.char(115,101,116,109,101,116,97,116,97,98,108,101),string.char(108,111,97,100,115,116,114,105,110,103),string.char(108,111,97,100),string.char(99,111,108,108,101,99,116,103,97,114,98,97,103,101),string.char(103,99,105,110,102,111),string.char(110,101,119,112,114,111,120,121),string.char(100,101,108,97,121),string.char(115,112,97,119,110),string.char(116,105,99,107),string.char(116,105,109,101),string.char(100,97,116,101),string.char(99,108,111,99,107),string.char(66,114,105,99,107,67,111,108,111,114),string.char(78,117,109,98,101,114,83,101,113,117,101,110,99,101),string.char(67,111,108,111,114,83,101,113,117,101,110,99,101),string.char(78,117,109,98,101,114,82,97,110,103,101),string.char(82,97,110,100,111,109),string.char(82,101,99,116),string.char(82,101,103,105,111,110,51),string.char(84,119,101,101,110,83,101,114,118,105,99,101),string.char(82,117,110,83,101,114,118,105,99,101),string.char(80,108,97,121,101,114,115),string.char(82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101),string.char(83,101,114,118,101,114,83,99,114,105,112,116,83,101,114,118,105,99,101),string.char(83,101,114,118,101,114,83,116,111,114,97,103,101),string.char(76,105,103,104,116,105,110,103),string.char(83,111,117,110,100,83,101,114,118,105,99,101),string.char(83,116,97,114,116,101,114,71,117,105),string.char(83,116,97,114,116,101,114,80,97,99,107),string.char(83,116,97,114,116,101,114,80,108,97,121,101,114),string.char(84,101,108,101,112,111,114,116,83,101,114,118,105,99,101),string.char(68,97,116,97,83,116,111,114,101,83,101,114,118,105,99,101),string.char(72,116,116,112,83,101,114,118,105,99,101),string.char(77,97,114,107,101,116,112,108,97,99,101,83,101,114,118,105,99,101),string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101),string.char(67,111,110,116,101,120,116,65,99,116,105,111,110,83,101,114,118,105,99,101),string.char(67,111,108,108,101,99,116,105,111,110,83,101,114,118,105,99,101),string.char(68,101,98,114,105,115),string.char(80,104,121,115,105,99,115,83,101,114,118,105,99,101)}
local _0x9F08 = {}
for _, v in ipairs(_0x4D82) do _0x9F08[v] = true end
local _0xF8BA = {}
for _, v in ipairs(_0x1D7E) do _0xF8BA[v] = true end
function _0x418A.Highlight(_0xBC87)
if type(_0xBC87) ~=string.char(115,116,114,105,110,103)then return""end
local _0xBFC0 = {}
local _0x1DF8 = 1
local _0x8D8B = #_0xBC87
while _0x1DF8 <= _0x8D8B do
local _0xF2E7 = _0xBC87:sub(_0x1DF8, _0x1DF8)
if _0xF2E7 ==string.char(34)or _0xF2E7 ==string.char(39)then
local _0x7FDF = _0x1DF8
local _0x760B = _0xF2E7
_0x1DF8 = _0x1DF8 + 1
while _0x1DF8 <= _0x8D8B do
if _0xBC87:sub(_0x1DF8, _0x1DF8) ==string.char(92)then
_0x1DF8 = _0x1DF8 + 2
elseif _0xBC87:sub(_0x1DF8, _0x1DF8) == _0x760B then
_0x1DF8 = _0x1DF8 + 1
break
else
_0x1DF8 = _0x1DF8 + 1
end
end
local _0xB2EF = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1):gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.String ..string.char(34,62).. _0xB2EF ..string.char(60,47,102,111,110,116,62))
elseif _0xF2E7 ==string.char(91)and _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(91,91)then
local _0x7FDF = _0x1DF8
local _0xCEDC = 0
while _0x1DF8 <= _0x8D8B do
if _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(91,91)then _0xCEDC = _0xCEDC + 1; _0x1DF8 = _0x1DF8 + 2
elseif _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(93,93)then _0xCEDC = _0xCEDC - 1; _0x1DF8 = _0x1DF8 + 2; if _0xCEDC == 0 then break end
else _0x1DF8 = _0x1DF8 + 1 end
end
local _0xB2EF = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1):gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.String ..string.char(34,62).. _0xB2EF ..string.char(60,47,102,111,110,116,62))
elseif _0xF2E7 ==string.char(45)and _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(45,45)then
if _0xBC87:sub(_0x1DF8, _0x1DF8 + 3) ==string.char(45,45,91,91)then
local _0x7FDF = _0x1DF8
_0x1DF8 = _0x1DF8 + 4
local _0xCEDC = 0
while _0x1DF8 <= _0x8D8B do
if _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(91,91)then _0xCEDC = _0xCEDC + 1; _0x1DF8 = _0x1DF8 + 2
elseif _0xBC87:sub(_0x1DF8, _0x1DF8 + 1) ==string.char(93,93)then _0xCEDC = _0xCEDC - 1; _0x1DF8 = _0x1DF8 + 2; if _0xCEDC == 0 then break end
else _0x1DF8 = _0x1DF8 + 1 end
end
local _0xB2EF = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1):gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Comment ..string.char(34,62).. _0xB2EF ..string.char(60,47,102,111,110,116,62))
else
local _0x7FDF = _0x1DF8
while _0x1DF8 <= _0x8D8B do
local _0x4030 = _0xBC87:sub(_0x1DF8, _0x1DF8)
if _0x4030 ==string.char(10)or _0x4030 ==string.char(13)then break end
_0x1DF8 = _0x1DF8 + 1
end
local _0xB2EF = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1):gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Comment ..string.char(34,62).. _0xB2EF ..string.char(60,47,102,111,110,116,62))
end
elseif _0xF2E7:match(string.char(37,100)) then
local _0x7FDF = _0x1DF8
while _0x1DF8 <= _0x8D8B do
local _0x4030 = _0xBC87:sub(_0x1DF8, _0x1DF8)
if not _0x4030:match(string.char(37,100)) and _0x4030 ~=string.char(46)then break end
_0x1DF8 = _0x1DF8 + 1
end
local _0xB2EF = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1):gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Number ..string.char(34,62).. _0xB2EF ..string.char(60,47,102,111,110,116,62))
elseif _0xF2E7:match(string.char(37,97)) or _0xF2E7 ==string.char(95)then
local _0x7FDF = _0x1DF8
while _0x1DF8 <= _0x8D8B do
local _0x4030 = _0xBC87:sub(_0x1DF8, _0x1DF8)
if not _0x4030:match(string.char(37,119)) and _0x4030 ~=string.char(95)then break end
_0x1DF8 = _0x1DF8 + 1
end
local _0x2057 = _0xBC87:sub(_0x7FDF, _0x1DF8 - 1)
local _0xA480 = _0x2057:gsub(string.char(38),string.char(38,97,109,112,59)):gsub(string.char(60),string.char(38,108,116,59)):gsub(string.char(62),string.char(38,103,116,59))
if _0x2057 ==string.char(110,105,108)then
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Nil ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
elseif _0x2057 ==string.char(116,114,117,101)or _0x2057 ==string.char(102,97,108,115,101)then
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Boolean ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
elseif _0x9F08[_0x2057] then
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Keyword ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
elseif _0xF8BA[_0x2057] then
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Global ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
else
local _0x1D73 = _0xBC87:sub(_0x1DF8, _0x1DF8)
if _0x1D73 ==string.char(40)then
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Function ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
else
table.insert(_0xBFC0,string.char(60,102,111,110,116,32,99,111,108,111,114,61,34).. _0xEFDB.Identifier ..string.char(34,62).. _0xA480 ..string.char(60,47,102,111,110,116,62))
end
end
else
if _0xF2E7 ==string.char(38)then table.insert(_0xBFC0,string.char(38,97,109,112,59))
elseif _0xF2E7 ==string.char(60)then table.insert(_0xBFC0,string.char(38,108,116,59))
elseif _0xF2E7 ==string.char(62)then table.insert(_0xBFC0,string.char(38,103,116,59))
else table.insert(_0xBFC0, _0xF2E7) end
_0x1DF8 = _0x1DF8 + 1
end
end
return table.concat(_0xBFC0)
end
local function _0x33BE()
local _0x9B0E = {
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
local function _0x099B(Name)
if #Name > 30 then return true end
if Name:match(string.char(91,94,37,119,37,115,37,45,37,46,93)) then return true end
local _0x26D1 = select(2, Name:gsub(string.char(91,65,45,90,93),""))
if _0x26D1 >= 5 then return true end
return false
end
local function _0x5438(Parent)
if not Parent then return end
for _, Obj in ipairs(Parent:GetDescendants()) do
if Obj:IsA(string.char(83,99,114,101,101,110,71,117,105)) and Obj.Name ~=string.char(95,95,73,110,118,101,110,116,111,114,121)and Obj.Name ~=string.char(83,105,109,112,108,101,67,77,68,83)and not _0x9B0E[Obj.Name] and _0x099B(Obj.Name) then
pcall(function() Obj.Enabled = false end)
end
end
end
_0x5438(_0x4783(string.char(67,111,114,101,71,117,105)))
if _0x6A51 and _0x6A51 ~= _0x4783(string.char(67,111,114,101,71,117,105)) then _0x5438(_0x6A51) end
end
function _0x418A.HttpGet(_0x009A)
local _0x02FB = (syn and syn.request) or request or http_request
if not _0x02FB then return nil end
local _0xA271, _0x835B = pcall(function()
return _0x02FB({
Url = _0x009A,
Method =string.char(71,69,84),
Headers = {
[string.char(85,115,101,114,45,65,103,101,110,116)] =string.char(76,117,99,105,100,45,69,120,101,99,117,116,111,114,47,49,46,48),
[string.char(65,99,99,101,112,116)] =string.char(97,112,112,108,105,99,97,116,105,111,110,47,106,115,111,110)}
})
end)
return _0xA271 and _0x835B or nil
end
function _0x418A.GetAsset(Path)
if not _0x5444 then return nil end
if not _0x7C4A(string.char(76,117,99,105,100)) then _0xC3F3(string.char(76,117,99,105,100)) end
if not _0x7C4A(string.char(76,117,99,105,100,47,65,115,115,101,116,115)) then _0xC3F3(string.char(76,117,99,105,100,47,65,115,115,101,116,115)) end
if Path:match(string.char(94,114,98,120,97,115,115,101,116,105,100,58,47,47)) then return Path end
if _0x0172(Path) then return _0x5444(Path) end
local _0x009A = _0x0C17[Path]
if not _0x009A then return nil end
local _0xC6DE = _0x418A.HttpGet(_0x009A)
if not _0xC6DE or not _0xC6DE.Body then return nil end
_0xC889(Path, _0xC6DE.Body)
return _0x5444(Path)
end
function _0x418A.PreloadAssets()
if not _0x7C4A(string.char(76,117,99,105,100)) then _0xC3F3(string.char(76,117,99,105,100)) end
if not _0x7C4A(string.char(76,117,99,105,100,47,65,115,115,101,116,115)) then _0xC3F3(string.char(76,117,99,105,100,47,65,115,115,101,116,115)) end
for path, _0x009A in pairs(_0x0C17) do
if not _0x0172(path) then
local _0xC6DE = _0x418A.HttpGet(_0x009A)
if _0xC6DE and _0xC6DE.Body then
_0xC889(path, _0xC6DE.Body)
end
end
end
end
function _0x418A.SanitizeName(_0x1671)
if not _0x1671 then returnstring.char(83,99,114,105,112,116,95).. _0x2D6D:GenerateGUID(false):sub(1, 8) end
local _0x224D =""for _0xF2E7 in _0x1671:gmatch(string.char(46)) do
local _0xD0E3 = string.byte(_0xF2E7)
if (_0xD0E3 >= 65 and _0xD0E3 <= 90) or (_0xD0E3 >= 97 and _0xD0E3 <= 122) or (_0xD0E3 >= 48 and _0xD0E3 <= 57) then
_0x224D = _0x224D .. _0xF2E7
end
end
if _0x224D ==""then _0x224D =string.char(83,99,114,105,112,116,95).. _0x2D6D:GenerateGUID(false):sub(1, 8) end
return _0x224D
end
function _0x418A.ClearCache()
if _0x7C4A(string.char(76,117,99,105,100,47,67,97,99,104,101)) then
local _0xA398 = _0xE3A8(string.char(76,117,99,105,100,47,67,97,99,104,101))
for _, file in ipairs(_0xA398) do
pcall(function() _0x51AC(file) end)
end
end
end
function _0x418A.LoadSavedScripts()
if not _0x7C4A(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)) then _0xC3F3(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)); return {} end
local _0xA398 = _0xE3A8(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115))
local _0x2EE6 = {}
for _, file in ipairs(_0xA398) do
local _0x3B49 = _0x0B78(file)
local _0x9378, _0x957B = pcall(function() return _0x2D6D:JSONDecode(_0x3B49) end)
if _0x9378 and _0x957B then table.insert(_0x2EE6, _0x957B) end
end
return _0x2EE6
end
function _0x418A.SaveScript(_0x8E3B)
if not _0x7C4A(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)) then _0xC3F3(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)) end
local _0xCA1B =string.char(76,117,99,105,100,47,83,99,114,105,112,116,115,47).. _0x8E3B.Name:gsub(string.char(91,94,37,119,93),string.char(95)) ..string.char(46,106,115,111,110)_0xC889(_0xCA1B, _0x2D6D:JSONEncode(_0x8E3B))
end
function _0x418A.DeleteScript(_0x3CE3)
local _0xCA1B =string.char(76,117,99,105,100,47,83,99,114,105,112,116,115,47).. _0x3CE3:gsub(string.char(91,94,37,119,93),string.char(95)) ..string.char(46,106,115,111,110)if _0x0172(_0xCA1B) then _0x51AC(_0xCA1B) end
end
local _0x8F79 = {
{
Name =string.char(68,101,120,43,43,32,40,66,117,105,108,116,45,73,110,41),
Description =string.char(65,32,115,105,109,112,108,101,32,98,117,116,32,112,111,119,101,114,102,117,108,32,116,111,111,108,32,102,111,114,32,101,120,112,108,111,114,105,110,103,32,103,97,109,101,32,105,110,115,116,97,110,99,101,115,46),
Code =[[loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()]]},
{
Name =string.char(75,101,121,98,111,97,114,100,32,40,66,117,105,108,116,45,73,110,41),
Description =string.char(65,32,118,105,114,116,117,97,108,32,107,101,121,98,111,97,114,100,32,71,85,73,32,109,97,100,101,32,102,111,114,32,109,111,98,105,108,101,32,100,101,118,105,99,101,115,46),
Code =[[loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/main/Init.luau"))()
Init.DeltaKD()]]}
}
function _0x418A.InitDefaultScripts()
if not _0x7C4A(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)) then _0xC3F3(string.char(76,117,99,105,100,47,83,99,114,105,112,116,115)) end
for _, _0x8E3B in ipairs(_0x8F79) do
local _0xCA1B =string.char(76,117,99,105,100,47,83,99,114,105,112,116,115,47).. _0x8E3B.Name:gsub(string.char(91,94,37,119,93),string.char(95)) ..string.char(46,106,115,111,110)if not _0x0172(_0xCA1B) then _0x418A.SaveScript(_0x8E3B) end
end
end
function _0x418A.ParseColor(_0x71BF)
if type(_0x71BF) ~=string.char(115,116,114,105,110,103)then return nil end
local _0xF676, _0xC8AE, _0x6A50 = _0x71BF:match(string.char(40,37,100,43,41,37,115,42,44,37,115,42,40,37,100,43,41,37,115,42,44,37,115,42,40,37,100,43,41))
if _0xF676 and _0xC8AE and _0x6A50 then return Color3.fromRGB(tonumber(_0xF676), tonumber(_0xC8AE), tonumber(_0x6A50)) end
return nil
end
function _0x418A.SaveSettings()
if not _0x7C4A(string.char(76,117,99,105,100)) then _0xC3F3(string.char(76,117,99,105,100)) end
local _0x957B = {
Animations = _0x87A2.Animations,
BackgroundColor = {R = math.floor(_0x87A2.BackgroundColor.R * 255), G = math.floor(_0x87A2.BackgroundColor.G * 255), B = math.floor(_0x87A2.BackgroundColor.B * 255)},
SecondaryBackgroundColor = {R = math.floor(_0x87A2.SecondaryBackgroundColor.R * 255), G = math.floor(_0x87A2.SecondaryBackgroundColor.G * 255), B = math.floor(_0x87A2.SecondaryBackgroundColor.B * 255)},
AccentColor = {R = math.floor(_0x87A2.AccentColor.R * 255), G = math.floor(_0x87A2.AccentColor.G * 255), B = math.floor(_0x87A2.AccentColor.B * 255)},
SecondaryAccentColor = {R = math.floor(_0x87A2.SecondaryAccentColor.R * 255), G = math.floor(_0x87A2.SecondaryAccentColor.G * 255), B = math.floor(_0x87A2.SecondaryAccentColor.B * 255)}
}
_0xC889(string.char(76,117,99,105,100,47,83,101,116,116,105,110,103,115,46,106,115,111,110), _0x2D6D:JSONEncode(_0x957B))
end
function _0x418A.LoadSettings()
if not _0x0172(string.char(76,117,99,105,100,47,83,101,116,116,105,110,103,115,46,106,115,111,110)) then return end
local _0x3B49 = _0x0B78(string.char(76,117,99,105,100,47,83,101,116,116,105,110,103,115,46,106,115,111,110))
if not _0x3B49 or _0x3B49 ==""then return end
local _0x9378, _0x957B = pcall(function() return _0x2D6D:JSONDecode(_0x3B49) end)
if _0x9378 and _0x957B then
if _0x957B.Animations ~= nil then _0x87A2.Animations = _0x957B.Animations end
if _0x957B.BackgroundColor then _0x87A2.BackgroundColor = Color3.fromRGB(_0x957B.BackgroundColor.R or 10, _0x957B.BackgroundColor.G or 10, _0x957B.BackgroundColor.B or 10) end
if _0x957B.SecondaryBackgroundColor then _0x87A2.SecondaryBackgroundColor = Color3.fromRGB(_0x957B.SecondaryBackgroundColor.R or 18, _0x957B.SecondaryBackgroundColor.G or 18, _0x957B.SecondaryBackgroundColor.B or 18) end
if _0x957B.AccentColor then _0x87A2.AccentColor = Color3.fromRGB(_0x957B.AccentColor.R or 0, _0x957B.AccentColor.G or 99, _0x957B.AccentColor.B or 255) end
if _0x957B.SecondaryAccentColor then _0x87A2.SecondaryAccentColor = Color3.fromRGB(_0x957B.SecondaryAccentColor.R or 0, _0x957B.SecondaryAccentColor.G or 64, _0x957B.SecondaryAccentColor.B or 180) end
end
end
function _0x418A.ScriptRequiresKey(_0x957B)
local _0x2E7D = _0x418A.CurrentSource ==string.char(83,99,114,105,112,116,66,108,111,120)and _0x957B.key or _0x957B.keySystem
if type(_0x2E7D) ==string.char(98,111,111,108,101,97,110)then return _0x2E7D end
if type(_0x2E7D) ==string.char(110,117,109,98,101,114)then return _0x2E7D ~= 0 end
if type(_0x2E7D) ==string.char(115,116,114,105,110,103)then
local _0x16D6 = _0x2E7D:lower()
if _0x16D6 ==""or _0x16D6 ==string.char(102,97,108,115,101)or _0x16D6 ==string.char(48)or _0x16D6 ==string.char(110,111,110,101)or _0x16D6 ==string.char(110,47,97)then return false end
if _0x16D6:find(string.char(110,111,32,107,101,121), 1, true) or _0x16D6:find(string.char(107,101,121,108,101,115,115), 1, true) then return false end
return true
end
return _0x2E7D ~= nil and _0x2E7D ~= false
end
function _0x418A.PassesFilter(_0x957B)
local _0xCCBF = _0x418A.ScriptRequiresKey(_0x957B)
if _0x418A.CurrentFilter ==string.char(75,101,121)then return _0xCCBF
elseif _0x418A.CurrentFilter ==string.char(75,101,121,108,101,115,115)then return not _0xCCBF end
return true
end
function _0x418A.ResolveImage(_0x957B)
local _0x3F13 = _0x957B.image or _0x957B.imageUrl or _0x957B.thumbnail or (_0x957B.game and (_0x957B.game.imageUrl or _0x957B.game.image)) or""if _0x3F13 ==""then return""end
if _0x3F13:match(string.char(94,104,116,116,112,115,63,58,47,47)) then return _0x3F13 end
if _0x3F13:sub(1, 2) ==string.char(47,47)then returnstring.char(104,116,116,112,115,58).. _0x3F13 end
local _0x5EBE = _0x418A.CurrentSource ==string.char(83,99,114,105,112,116,66,108,111,120)andstring.char(104,116,116,112,115,58,47,47,115,99,114,105,112,116,98,108,111,120,46,99,111,109)orstring.char(104,116,116,112,115,58,47,47,114,115,99,114,105,112,116,115,46,110,101,116)if _0x3F13:sub(1, 1) ==string.char(47)then return _0x5EBE .. _0x3F13 end
return _0x5EBE ..string.char(47).. _0x3F13
end
function _0x418A.FetchScripts(_0xB4BB, page)
page = page or 1
local _0x009A
if _0x418A.CurrentSource ==string.char(82,83,99,114,105,112,116,115)then
_0x009A =string.char(104,116,116,112,115,58,47,47,114,115,99,114,105,112,116,115,46,110,101,116,47,97,112,105,47,118,50,47,115,99,114,105,112,116,115,63,112,97,103,101,61).. page ..string.char(38,111,114,100,101,114,66,121,61,100,97,116,101,38,115,111,114,116,61,100,101,115,99)if _0xB4BB ~=""then _0x009A = _0x009A ..string.char(38,113,61).. _0x2D6D:UrlEncode(_0xB4BB) end
else
if _0xB4BB ~=""then
_0x009A =string.char(104,116,116,112,115,58,47,47,115,99,114,105,112,116,98,108,111,120,46,99,111,109,47,97,112,105,47,115,99,114,105,112,116,47,115,101,97,114,99,104,63,113,61).. _0x2D6D:UrlEncode(_0xB4BB) ..string.char(38,112,97,103,101,61).. page
else
_0x009A =string.char(104,116,116,112,115,58,47,47,115,99,114,105,112,116,98,108,111,120,46,99,111,109,47,97,112,105,47,115,99,114,105,112,116,47,102,101,116,99,104,63,112,97,103,101,61).. page
end
end
local _0xC6DE = _0x418A.HttpGet(_0x009A)
if not _0xC6DE or not _0xC6DE.Body then return nil, nil end
local _0x9378, _0xBD2D = pcall(function() return _0x2D6D:JSONDecode(_0xC6DE.Body) end)
if not _0x9378 or not _0xBD2D then return nil, nil end
local _0x2EE6, _0x8544
if _0x418A.CurrentSource ==string.char(82,83,99,114,105,112,116,115)then
_0x2EE6 = _0xBD2D.scripts or {}
_0x8544 = _0xBD2D.info and _0xBD2D.info.maxPages or 1
else
local _0xBFC0 = _0xBD2D.result or {}
_0x2EE6 = _0xBFC0.scripts or {}
_0x8544 = _0xBFC0.totalPages or 1
end
return _0x2EE6, _0x8544
end
function _0x418A.CreateResultCard(_0x957B, parent)
local _0xFE68 = _0x957B.title or _0x957B.name orstring.char(85,110,116,105,116,108,101,100,32,83,99,114,105,112,116)local _0x8926 = _0x418A.CurrentSource ==string.char(83,99,114,105,112,116,66,108,111,120)local _0x56C4 = _0x8926 and (_0x957B.script or"") or (_0x957B.rawScript or _0x957B.raw or"")
local _0xF147 = _0xE3E8.SearchResultTemplate:Clone()
_0xF147.Name = _0x418A.SanitizeName(_0xFE68)
_0xF147.Visible = true
_0xF147.Parent = parent
local _0xB77D = _0xF147:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0xB77D then _0xB77D.Color = _0x87A2.SecondaryAccentColor end
local _0x327D = _0xF147:FindFirstChild(string.char(83,99,114,105,112,116,73,109,97,103,101))
if _0x327D then _0x327D.Image = _0x418A.ResolveImage(_0x957B) end
local _0x2AD6 = _0xF147:FindFirstChild(string.char(67,111,110,116,97,105,110,101,114))
if _0x2AD6 then
local _0x3CE3 = _0x2AD6:FindFirstChild(string.char(83,99,114,105,112,116,78,97,109,101))
if _0x3CE3 then
_0x3CE3.Text = _0xFE68
local _0xBC85 = _0x3CE3:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0xBC85 then _0xBC85.Color = _0x87A2.AccentColor end
end
end
local _0xE7FA = _0x2AD6 and _0x2AD6:FindFirstChild(string.char(83,99,114,105,112,116,65,99,116,105,111,110,115))
if _0xE7FA then
local _0x38DA = _0xE7FA:FindFirstChild(string.char(82,117,110,83,99,114,105,112,116))
local _0xE3FE = _0xE7FA:FindFirstChild(string.char(67,111,112,121,83,99,114,105,112,116,66,116,110))
local _0x362E = _0xE7FA:FindFirstChild(string.char(83,97,118,101,83,99,114,105,112,116,66,116,110))
for _, btn in ipairs({_0x38DA, _0xE3FE, _0x362E}) do
if btn then
btn.BackgroundColor3 = _0x87A2.AccentColor
local _0xC349 = btn:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0xC349 then _0xC349.Color = _0x87A2.SecondaryAccentColor end
end
end
local function _0xEEFF()
if _0x56C4 ==""then return nil end
if _0x8926 then return _0x56C4 end
local _0x9378, _0x3B49 = pcall(function() return game:HttpGet(_0x56C4) end)
return _0x9378 and _0x3B49 or nil
end
if _0x38DA then
_0x38DA.MouseButton1Click:Connect(function()
local _0xF2FE, _0x072A = loadstring(_0x8E3B.Code or"")
if not _0xF2FE then error(_0x072A) end
local _0x9378, _0xFB0C = pcall(_0xF2FE)
if not _0x9378 then error(_0xFB0C) end
end)
end
if _0xE3FE then
_0xE3FE.MouseButton1Click:Connect(function()
local _0xBC87 = _0xEEFF()
if _0xBC87 then
_0x8139(_0xBC87)
_0xE3FE.Text =string.char(67,111,112,105,101,100,33)task.delay(1, function() _0xE3FE.Text =string.char(67,111,112,121)end)
end
end)
end
if _0x362E then
_0x362E.MouseButton1Click:Connect(function()
local _0xBC87 = _0xEEFF()
if _0xBC87 then
local _0x8E3B = { Name = _0xFE68, Description = _0x957B.description or"", Code = _0xBC87 }
_0x418A.SaveScript(_0x8E3B)
_0x362E.Text =string.char(83,97,118,101,100,33)task.delay(1, function() _0x362E.Text =string.char(83,97,118,101)end)
_0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2.Text)
end
end)
end
end
end
function _0x418A.RenderSearchResults()
local _0xF1DC = _0xE3E8.SearchResults
if not _0xF1DC then return end
for _, child in ipairs(_0xF1DC:GetChildren()) do
if child ~= _0xE3E8.NoResultsLabel and child ~= _0xE3E8.SearchResultsPadding and child ~= _0xE3E8.SearchResultsLayout and child ~= _0xE3E8.SearchResultTemplate then
child:Destroy()
end
end
local _0x4677 = 0
for _, _0x957B in ipairs(_0x418A.CurrentScripts) do
if _0x418A.PassesFilter(_0x957B) then
_0x4677 = _0x4677 + 1
_0x418A.CreateResultCard(_0x957B, _0xF1DC)
end
end
if _0x4677 == 0 then
if _0xE3E8.NoResultsLabel then
_0xE3E8.NoResultsLabel.Visible = true
if #_0x418A.CurrentScripts == 0 then
_0xE3E8.NoResultsLabel.Text = (_0x1CC3 ~="") andstring.char(78,111,32,115,99,114,105,112,116,115,32,102,111,117,110,100,32,109,97,116,99,104,105,110,103,32,121,111,117,114,32,113,117,101,114,121,46)orstring.char(78,111,32,115,99,114,105,112,116,115,32,102,111,117,110,100,46)else
_0xE3E8.NoResultsLabel.Text =string.char(78,111,32,115,99,114,105,112,116,115,32,109,97,116,99,104,32,116,104,101,32,99,117,114,114,101,110,116,32,102,105,108,116,101,114,46)end
end
elseif _0xE3E8.NoResultsLabel then
_0xE3E8.NoResultsLabel.Visible = false
end
end
function _0x418A.PerformSearch(_0xB4BB, page)
page = page or 1
_0x1CC3 = _0xB4BB
_0xCC51 = page
if _0xE3E8.NoResultsLabel then _0xE3E8.NoResultsLabel.Visible = false end
_0xE3E8.PrevBtn.Visible = false
_0xE3E8.NextBtn.Visible = false
local _0x2EE6, _0x8544 = _0x418A.FetchScripts(_0xB4BB, page)
if not _0x2EE6 then
_0x418A.CurrentScripts = {}
_0x418A.RenderSearchResults()
if _0xE3E8.NoResultsLabel then
_0xE3E8.NoResultsLabel.Visible = true
_0xE3E8.NoResultsLabel.Text =string.char(70,97,105,108,101,100,32,116,111,32,102,101,116,99,104,32,115,99,114,105,112,116,115,46,32,67,104,101,99,107,32,121,111,117,114,32,99,111,110,110,101,99,116,105,111,110,32,97,110,100,32,116,114,121,32,97,103,97,105,110,46)end
return
end
_0xB84E = _0x8544 or 1
_0x418A.CurrentScripts = _0x2EE6
_0xE3E8.PrevBtn.Visible = page > 1
_0xE3E8.NextBtn.Visible = page < _0xB84E
_0x418A.RenderSearchResults()
end
function _0x418A.CycleSource()
local _0x3B0F = table.find(_0x418A.Sources, _0x418A.CurrentSource) or 1
_0x418A.CurrentSource = _0x418A.Sources[_0x3B0F % #_0x418A.Sources + 1]
if _0x418A.CurrentSource ==string.char(82,83,99,114,105,112,116,115)then
_0xE3E8.SourceBtn.Text =string.char(239,191,189,239,191,189,32,83,111,117,114,99,101,58,32,82,83,99,114,105,112,116,115)else
_0xE3E8.SourceBtn.Text =string.char(226,154,160,239,184,143,32,83,111,117,114,99,101,58,32,83,99,114,105,112,116,66,108,111,120)end
_0x418A.PerformSearch(_0x1CC3, 1)
end
function _0x418A.CycleFilter()
local _0x3B0F = table.find(_0x418A.Filters, _0x418A.CurrentFilter) or 1
_0x418A.CurrentFilter = _0x418A.Filters[_0x3B0F % #_0x418A.Filters + 1]
_0xE3E8.FilterBtn.Text =string.char(70,105,108,116,101,114,58,32).. _0x418A.CurrentFilter
_0x418A.RenderSearchResults()
end
function _0x418A.ApplyTheme()
_0xE3E8.MainFrame.BackgroundColor3 = _0x87A2.BackgroundColor
_0xE3E8.HomeContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.ExeContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.SearchContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.ScriptsContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.SettingsContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.MusicContent.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.Sidebar.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.HomeContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.ExeContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.SearchContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.ScriptsContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.SettingsContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.MusicContentStroke.Color = _0x87A2.AccentColor
_0xE3E8.SidebarStroke.Color = _0x87A2.AccentColor
_0xE3E8.NewScriptFrameStroke.Color = _0x87A2.AccentColor
_0xE3E8.Title.TextColor3 = _0x87A2.AccentColor
_0xE3E8.TitleStroke.Color = _0x87A2.AccentColor
_0xE3E8.Icon.ImageColor3 = _0x87A2.AccentColor
_0xE3E8.Logo.ImageColor3 = _0x87A2.SecondaryAccentColor
_0xE3E8.TabUnderline.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.TabUnderline2.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.TabUnderline3.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.TabUnderline4.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.TabUnderline5.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.TabUnderline6Music.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.NoResultsLabelStroke.Color = _0x87A2.AccentColor
_0xE3E8.NoSavedScriptsLabelStroke.Color = _0x87A2.AccentColor
_0xE3E8.SearchResultTemplateStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.ScriptNameStroke.Color = _0x87A2.AccentColor
_0xE3E8.SavedScriptTemplateStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.ExeBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.ClrBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.CopyBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.RunScript.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.CopyScriptBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.SaveScriptBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.PrevBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.NextBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.Cancel.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.Save.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.RunSavedScript.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.DeleteSavedScript.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.SourceBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.FilterBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.AddExeTabBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.ExeBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.ClrBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.CopyBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.RunScriptStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.CopyScriptBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.SaveScriptBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.PrevBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.NextBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.CancelStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.SaveStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.RunSavedScriptStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.DeleteSavedScriptStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.SourceBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.FilterBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.AddExeTabBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.WelcomeLabelStroke.Color = _0x87A2.AccentColor
_0xE3E8.InfoLabelStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.InfoLabel2Stroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.PlayerHeadshotStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.MusicPlayBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.MusicPrevBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.MusicNextBtn.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.MusicPlayBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.MusicPrevBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.MusicNextBtnStroke.Color = _0x87A2.SecondaryAccentColor
_0xE3E8.MusicSliderBar.BackgroundColor3 = _0x87A2.SecondaryBackgroundColor
_0xE3E8.MusicSliderFill.BackgroundColor3 = _0x87A2.AccentColor
_0xE3E8.MusicSliderKnob.BackgroundColor3 = _0x87A2.AccentColor
if not _0x87A2.Animations then
_0xE3E8.ToggleState.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
local _0x4B72 = _0xE3E8.ToggleState:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0x4B72 then _0x4B72.Color = Color3.fromRGB(255, 0, 0) end
else
_0xE3E8.ToggleState.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
local _0x4B72 = _0xE3E8.ToggleState:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0x4B72 then _0x4B72.Color = Color3.fromRGB(0, 255, 0) end
end
for _, _0xF075 in ipairs(_0x2B10) do
if _0xF075.tabBtn then
local _0x7EA6 = _0xF075.tabBtn:FindFirstChild(string.char(65,99,116,105,118,101,76,105,110,101))
if _0x7EA6 then
_0x7EA6.BackgroundColor3 = _0x87A2.AccentColor
end
end
end
if _0xE3E8.SearchResults then _0x418A.RenderSearchResults() end
if _0xE3E8.SavedScriptsScroll then _0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2 and _0xE3E8.SearchBox2.Text or"") end
end
function _0x418A.UpdateStats()
local _0x3CF4 = _0x0F90.Name orstring.char(85,110,107,110,111,119,110)local _0xDA9E = _0x0F90.DisplayName orstring.char(85,110,107,110,111,119,110)local _0x910D = _0x0F90.UserId or 0
local _0x028C = math.floor(workspace:GetRealPhysicsFPS() or 0)
local _0xA0AF = _0x0F90:GetNetworkPing() and math.floor(_0x0F90:GetNetworkPing() * 1000) or 0
local _0xA3C4 = math.floor(collectgarbage(string.char(99,111,117,110,116)) / 1024) or 0
local _0xE34A = #_0x436D:GetPlayers() or 0
local _0x4443 = _0x436D.MaxPlayers or 0
local _0x6122 = math.floor((os.time() - workspace.DistributedGameTime) / 60) or 0
local _0xE155 = game.PlaceId or 0
local _0x8E6D = game.GameId orstring.char(85,110,107,110,111,119,110)local _0xCA57 = game.JobId orstring.char(85,110,107,110,111,119,110)local _0xEEE7 = string.format([[Username: %s
Display Name: %s
User ID: %s

FPS: %s
Ping: %s ms
Memory: %s MB

Players: %s/%s
Server Age: %s mins
Job ID: %s

Place ID: %s
Game ID: %s]], _0x3CF4, _0xDA9E, _0x910D, _0x028C, _0xA0AF, _0xA3C4, _0xE34A, _0x4443, _0x6122, _0xCA57, _0xE155, _0x8E6D)
if _0xE3E8.InfoLabel then _0xE3E8.InfoLabel.Text = _0xEEE7 end
if _0xE3E8.WelcomeLabel then _0xE3E8.WelcomeLabel.Text =string.char(87,101,108,99,111,109,101,32,116,111,32,76,117,99,105,100,44,32).. _0xDA9E ..string.char(33)end
local _0x33C1 =string.char(104,116,116,112,115,58,47,47,119,119,119,46,114,111,98,108,111,120,46,99,111,109,47,104,101,97,100,115,104,111,116,45,116,104,117,109,98,110,97,105,108,47,105,109,97,103,101,63,117,115,101,114,73,100,61).. _0x910D ..string.char(38,119,105,100,116,104,61,52,50,48,38,104,101,105,103,104,116,61,52,50,48,38,102,111,114,109,97,116,61,112,110,103)if _0xE3E8.PlayerHeadshot then _0xE3E8.PlayerHeadshot.Image = _0x33C1 end
end
function _0x418A.RefreshSavedScripts(searchQuery)
local _0xB3E7 = _0xE3E8.SavedScriptsScroll
if not _0xB3E7 then return end
for _, child in ipairs(_0xB3E7:GetChildren()) do
if child ~= _0xE3E8.NoSavedScriptsLabel and child ~= _0xE3E8.SavedScriptsScrollPadding and child ~= _0xE3E8.SavedScriptsScrollLayout and child ~= _0xE3E8.SavedScriptTemplate then
child:Destroy()
end
end
local _0x2EE6 = _0x418A.LoadSavedScripts()
if searchQuery and searchQuery ~=""then
local _0x93A3 = {}
local _0xB4BB = searchQuery:lower()
for _, _0x8E3B in ipairs(_0x2EE6) do
local _0x1671 = (_0x8E3B.Name or""):lower()
local _0x667C = (_0x8E3B.Description or""):lower()
if _0x1671:find(_0xB4BB) or _0x667C:find(_0xB4BB) then table.insert(_0x93A3, _0x8E3B) end
end
_0x2EE6 = _0x93A3
end
if #_0x2EE6 == 0 then
if _0xE3E8.NoSavedScriptsLabel then
_0xE3E8.NoSavedScriptsLabel.Visible = true
_0xE3E8.NoSavedScriptsLabel.Text = (searchQuery and searchQuery ~="") andstring.char(78,111,32,115,97,118,101,100,32,115,99,114,105,112,116,115,32,109,97,116,99,104,32,121,111,117,114,32,115,101,97,114,99,104,46)orstring.char(78,111,32,83,97,118,101,100,32,83,99,114,105,112,116,115,10,10,83,97,118,101,32,115,111,109,101,32,115,99,114,105,112,116,115,32,116,111,32,115,101,101,32,116,104,101,109,32,104,101,114,101,46)end
return
end
if _0xE3E8.NoSavedScriptsLabel then _0xE3E8.NoSavedScriptsLabel.Visible = false end
local _0x2463 = {}
local _0x906D = {}
for _, _0x8E3B in ipairs(_0x2EE6) do
if _0x8E3B.Name:find(string.char(37,40,66,117,105,108,116,37,45,73,110,37,41)) then
table.insert(_0x2463, _0x8E3B)
else
table.insert(_0x906D, _0x8E3B)
end
end
table.sort(_0x2463, function(a, _0x6A50) return (a.Name or""):lower() < (_0x6A50.Name or""):lower() end)
table.sort(_0x906D, function(a, _0x6A50) return (a.Name or""):lower() < (_0x6A50.Name or""):lower() end)
local function _0x753D(_0x8E3B)
local _0xF147 = _0xE3E8.SavedScriptTemplate:Clone()
_0xF147.Name = _0x418A.SanitizeName(_0x8E3B.Name)
_0xF147.Visible = true
_0xF147.Parent = _0xB3E7
local _0xB77D = _0xF147:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0xB77D then _0xB77D.Color = _0x87A2.SecondaryAccentColor end
local _0x4B25 = _0xF147:FindFirstChild(string.char(83,97,118,101,100,83,99,114,105,112,116,73,110,102,111))
if _0x4B25 then
local _0x02F1 = _0x4B25:FindFirstChild(string.char(83,97,118,101,100,83,99,114,105,112,116,84,105,116,108,101))
local _0x2426 = _0x4B25:FindFirstChild(string.char(83,97,118,101,100,83,99,114,105,112,116,68,101,115,99))
if _0x02F1 then _0x02F1.Text = _0x8E3B.Name orstring.char(85,110,107,110,111,119,110)end
if _0x2426 then _0x2426.Text = _0x8E3B.Description orstring.char(78,111,32,100,101,115,99,114,105,112,116,105,111,110)end
end
local _0xE7FA = _0xF147:FindFirstChild(string.char(83,97,118,101,100,83,99,114,105,112,116,65,99,116,105,111,110,115))
if _0xE7FA then
local _0x38DA = _0xE7FA:FindFirstChild(string.char(82,117,110,83,97,118,101,100,83,99,114,105,112,116))
local _0x9E3F = _0xE7FA:FindFirstChild(string.char(68,101,108,101,116,101,83,97,118,101,100,83,99,114,105,112,116))
for _, btn in ipairs({_0x38DA, _0x9E3F}) do
if btn then
btn.BackgroundColor3 = _0x87A2.AccentColor
local _0xC349 = btn:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0xC349 then _0xC349.Color = _0x87A2.SecondaryAccentColor end
end
end
if _0x38DA then
_0x38DA.MouseButton1Click:Connect(function()
local _0xF2FE, _0x072A = loadstring(_0x8E3B.Code or"")
if not _0xF2FE then error(_0x072A) end
local _0x9378, _0xFB0C = pcall(_0xF2FE)
if not _0x9378 then error(_0xFB0C) end
end)
end
if _0x9E3F then
_0x9E3F.MouseButton1Click:Connect(function()
_0x418A.DeleteScript(_0x8E3B.Name)
_0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2.Text)
end)
end
end
end
for _, _0x8E3B in ipairs(_0x2463) do _0x753D(_0x8E3B) end
for _, _0x8E3B in ipairs(_0x906D) do _0x753D(_0x8E3B) end
end
function _0x418A.SwitchTab(tabButton)
local _0x64D6 = {
[_0xE3E8.HomeTab] = _0xE3E8.HomeContent,
[_0xE3E8.ExeTab] = _0xE3E8.ExeContent,
[_0xE3E8.SearchTab] = _0xE3E8.SearchContent,
[_0xE3E8.ScriptsTab] = _0xE3E8.ScriptsContent,
[_0xE3E8.SettingsTab] = _0xE3E8.SettingsContent,
[_0xE3E8.MusicTab] = _0xE3E8.MusicContent,
}
local _0xECC5 = _0x64D6[tabButton]
if not _0xECC5 then return end
local _0x759D = nil
for _0x4149, _0x3B49 in pairs(_0x64D6) do
if _0x3B49 and _0x3B49 ~= _0xECC5 and _0x3B49.Visible then
_0x759D = _0x3B49
break
end
end
if _0x759D == _0xECC5 then return end
if _0x759D then _0x759D.Visible = false end
_0xECC5.Visible = true
if _0x87A2.Animations then
_0xECC5.Position = UDim2.new(-1, 0, 0, 0)
_0x44D7:Create(_0xECC5, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 0)
}):Play()
else
_0xECC5.Position = UDim2.new(0, 0, 0, 0)
end
if _0xECC5 == _0xE3E8.HomeContent then _0x418A.UpdateStats() end
if _0xECC5 == _0xE3E8.ScriptsContent then _0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2.Text) end
if _0xECC5 == _0xE3E8.MusicContent then _0x418A.RefreshMusicList() end
end
function _0x418A.UpdateUnderline(tabButton, active)
local _0xB15B = tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101)) or tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101,50)) or tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101,51)) or tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101,52)) or tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101,53)) or tabButton:FindFirstChild(string.char(84,97,98,85,110,100,101,114,108,105,110,101,54,77,117,115,105,99))
if not _0xB15B then return end
if active then
if _0x87A2.Animations then
_0x44D7:Create(_0xB15B, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 1) }):Play()
else
_0xB15B.Size = UDim2.new(1, 0, 0, 1)
end
else
if _0x87A2.Animations then
_0x44D7:Create(_0xB15B, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 1) }):Play()
else
_0xB15B.Size = UDim2.new(0, 0, 0, 1)
end
end
end
function _0x418A.SetAllUnderlines(activeTab)
local _0xB465 = {_0xE3E8.HomeTab, _0xE3E8.ExeTab, _0xE3E8.SearchTab, _0xE3E8.ScriptsTab, _0xE3E8.SettingsTab, _0xE3E8.MusicTab}
for _, _0x4149 in ipairs(_0xB465) do
_0x418A.UpdateUnderline(_0x4149, _0x4149 == activeTab)
end
end
function _0x418A.Dragify(Object)
local _0xAF79 = false
local _0xD7BB
local _0x9959
local _0xF85C
local function _0xD10C(_0x8D87, _0x4821)
local _0x56D8 = workspace.CurrentCamera.ViewportSize
local _0xF23F = Object.AbsoluteSize
local _0xD298 = 16
local _0x72A5 = 12
_0x8D87 = math.clamp(_0x8D87, _0xD298, _0x56D8.X - _0xF23F.X - _0xD298)
_0x4821 = math.clamp(_0x4821, _0x72A5, _0x56D8.Y - _0xF23F.Y - _0x72A5)
return _0x8D87, _0x4821
end
Object.InputBegan:Connect(function(_0x71BF)
if _0x71BF.UserInputType == Enum.UserInputType.MouseButton1 or _0x71BF.UserInputType == Enum.UserInputType.Touch then
_0xAF79 = true
_0x9959 = _0x71BF.Position
_0xF85C = Object.Position
_0x71BF.Changed:Connect(function()
if _0x71BF.UserInputState == Enum.UserInputState.End then _0xAF79 = false end
end)
end
end)
Object.InputChanged:Connect(function(_0x71BF)
if _0x71BF.UserInputType == Enum.UserInputType.MouseMovement or _0x71BF.UserInputType == Enum.UserInputType.Touch then
_0xD7BB = _0x71BF
end
end)
_0x86B4.InputChanged:Connect(function(_0x71BF)
if _0x71BF == _0xD7BB and _0xAF79 then
local _0x625B = _0x71BF.Position - _0x9959
local _0x8D87 = _0xF85C.X.Offset + _0x625B.X
local _0x4821 = _0xF85C.Y.Offset + _0x625B.Y
_0x8D87, _0x4821 = _0xD10C(_0x8D87, _0x4821)
Object.Position = UDim2.new(_0xF85C.X.Scale, _0x8D87, _0xF85C.Y.Scale, _0x4821)
end
end)
end
function _0x418A.GetActiveContent()
local _0xF201 = {_0xE3E8.HomeContent, _0xE3E8.ExeContent, _0xE3E8.SearchContent, _0xE3E8.ScriptsContent, _0xE3E8.SettingsContent, _0xE3E8.MusicContent}
for _, _0x3B49 in ipairs(_0xF201) do
if _0x3B49 and _0x3B49.Visible then return _0x3B49 end
end
return _0xE3E8.HomeContent
end
function _0x418A.OpenUI()
_0xE3E8.MainFrame.Visible = true
_0xE3E8.MainFrame.BackgroundTransparency = 1
local _0xF366 = _0x418A.GetActiveContent()
_0xF366.Position = UDim2.new(-1, 0, 0, 0)
_0xE3E8.Sidebar.Position = UDim2.new(1.2, 8, 0.5, 0)
if _0x87A2.Animations then
_0x44D7:Create(_0xE3E8.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 }):Play()
_0x44D7:Create(_0xF366, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
_0x44D7:Create(_0xE3E8.Sidebar, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(1, 8, 0.5, 0) }):Play()
_0x44D7:Create(_0xE3E8.Show, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 1, BackgroundTransparency = 1 }):Play()
else
_0xE3E8.MainFrame.BackgroundTransparency = 0.35
_0xF366.Position = UDim2.new(0, 0, 0, 0)
_0xE3E8.Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
_0xE3E8.Show.ImageTransparency = 1
_0xE3E8.Show.BackgroundTransparency = 1
end
_0xE3E8.Show.Visible = false
_0x418A.UpdateStats()
end
function _0x418A.CloseUI()
local _0xF366 = _0x418A.GetActiveContent()
if _0x87A2.Animations then
local _0x6116 = _0x44D7:Create(_0xE3E8.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
local _0x2CD1 = _0x44D7:Create(_0xF366, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(-1, 0, 0, 0) })
local _0x6D02 = _0x44D7:Create(_0xE3E8.Sidebar, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Position = UDim2.new(1.2, 8, 0.5, 0) })
local _0x9375 = _0x44D7:Create(_0xE3E8.Show, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { ImageTransparency = 0, BackgroundTransparency = 0.08 })
_0x6116:Play(); _0x2CD1:Play(); _0x6D02:Play(); _0x9375:Play()
_0x2CD1.Completed:Wait()
_0xE3E8.MainFrame.Visible = false
_0xE3E8.Show.Visible = true
else
_0xE3E8.MainFrame.BackgroundTransparency = 1
_0xE3E8.MainFrame.Visible = false
_0xE3E8.Show.Visible = true
_0xE3E8.Show.ImageTransparency = 0
_0xE3E8.Show.BackgroundTransparency = 0.08
_0xF366.Position = UDim2.new(0, 0, 0, 0)
_0xE3E8.Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
end
end
function _0x418A.CreateTab(iconPath, labelText, _0x3B49, layoutOrder, underlineKey)
local _0x4149 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x4149.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_0x4149.BackgroundTransparency = 1
_0x4149.BorderSizePixel = 0
_0x4149.LayoutOrder = layoutOrder or 1
_0x4149.Name = labelText ..string.char(84,97,98)_0x4149.Size = UDim2.new(0, 30, 0, 58)
_0x4149.Text =""_0x4149.Parent = _0xE3E8.Sidebar
local _0xFF1B = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xFF1B.Padding = UDim.new(0, 4)
_0xFF1B.SortOrder = Enum.SortOrder.LayoutOrder
_0xFF1B.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xFF1B.Parent = _0x4149
local _0x7D4E = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0x7D4E.MaxSize = Vector2.new(2147483647, 34)
_0x7D4E.MinSize = Vector2.new(0, 28)
_0x7D4E.Parent = _0x4149
local _0x0BF0 = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0x0BF0.PaddingBottom = UDim.new(0, 3)
_0x0BF0.PaddingTop = UDim.new(0, 3)
_0x0BF0.Parent = _0x4149
local _0x2AD6 = Instance.new(string.char(70,114,97,109,101))
_0x2AD6.BackgroundTransparency = 1
_0x2AD6.BorderSizePixel = 0
_0x2AD6.LayoutOrder = 1
_0x2AD6.Name =string.char(84,97,98,67,111,110,116,97,105,110,101,114)_0x2AD6.Size = UDim2.new(1, 0, 0, 22)
_0x2AD6.Parent = _0x4149
local _0xAEAC = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xAEAC.FillDirection = Enum.FillDirection.Horizontal
_0xAEAC.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xAEAC.Padding = UDim.new(0, 4)
_0xAEAC.SortOrder = Enum.SortOrder.LayoutOrder
_0xAEAC.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xAEAC.Parent = _0x2AD6
local _0xEF28 = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xEF28.BackgroundTransparency = 1
_0xEF28.BorderSizePixel = 0
_0xEF28.Image = _0x418A.GetAsset(iconPath) or""_0xEF28.LayoutOrder = 1
_0xEF28.Name =string.char(84,97,98,73,99,111,110)_0xEF28.Size = UDim2.new(0, 30, 0, 30)
_0xEF28.Parent = _0x2AD6
local _0x9AF3 = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0x9AF3.Parent = _0xEF28
local _0x13F9 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x13F9.BackgroundTransparency = 1
_0x13F9.BorderSizePixel = 0
_0x13F9.FontFace = _0x340D
_0x13F9.LayoutOrder = 2
_0x13F9.Name =string.char(84,97,98,76,97,98,101,108)_0x13F9.Size = UDim2.new(0, 60, 0, 30)
_0x13F9.Text = labelText
_0x13F9.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x13F9.TextScaled = true
_0x13F9.TextWrapped = true
_0x13F9.TextXAlignment = Enum.TextXAlignment.Left
_0x13F9.Parent = _0x2AD6
local _0xB15B = Instance.new(string.char(70,114,97,109,101))
_0xB15B.BackgroundColor3 = _0x87A2.AccentColor
_0xB15B.BorderSizePixel = 0
_0xB15B.LayoutOrder = 2
_0xB15B.Name = underlineKey orstring.char(84,97,98,85,110,100,101,114,108,105,110,101)_0xB15B.Size = UDim2.new(0, 0, 0, 1)
_0xB15B.Parent = _0x4149
local _0xCD4A = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xCD4A.CornerRadius = UDim.new(0, 6)
_0xCD4A.Parent = _0xB15B
_0xE3E8[labelText ..string.char(84,97,98)] = _0x4149
_0xE3E8[underlineKey orstring.char(84,97,98,85,110,100,101,114,108,105,110,101)] = _0xB15B
if _0x3B49 then _0x3B49.Parent = _0xE3E8.Pages end
_0x4149.MouseButton1Click:Connect(function()
if _0x3B49 then
_0x418A.SwitchTab(_0x4149)
_0x418A.SetAllUnderlines(_0x4149)
end
end)
return _0x4149
end
function _0x418A.CreateSettingsInputbox(labelText, placeholderText, settingKey, layoutOrder)
local _0xD05E = Instance.new(string.char(70,114,97,109,101))
_0xD05E.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xD05E.BorderSizePixel = 0
_0xD05E.LayoutOrder = layoutOrder or 2
_0xD05E.Name = labelText:gsub(string.char(32),"")
_0xD05E.Size = UDim2.new(1, 0, 0, 38)
_0xD05E.Parent = _0xE3E8.SettingsFrame
local _0x840E = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0x840E.CornerRadius = UDim.new(0, 6)
_0x840E.Parent = _0xD05E
local _0x4B72 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0x4B72.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0x4B72.Color = Color3.fromRGB(36, 36, 36)
_0x4B72.Parent = _0xD05E
local _0xE9CE = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE9CE.FillDirection = Enum.FillDirection.Horizontal
_0xE9CE.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE9CE.Padding = UDim.new(0, 6)
_0xE9CE.SortOrder = Enum.SortOrder.LayoutOrder
_0xE9CE.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE9CE.Parent = _0xD05E
local _0x3E3A = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0x3E3A.PaddingBottom = UDim.new(0, 8)
_0x3E3A.PaddingLeft = UDim.new(0, 8)
_0x3E3A.PaddingRight = UDim.new(0, 8)
_0x3E3A.PaddingTop = UDim.new(0, 8)
_0x3E3A.Parent = _0xD05E
local _0x4D5B = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x4D5B.BackgroundTransparency = 1
_0x4D5B.BorderSizePixel = 0
_0x4D5B.FontFace = _0x1033
_0x4D5B.LayoutOrder = 1
_0x4D5B.Size = UDim2.new(0.8, 0, 1, 0)
_0x4D5B.Text = labelText
_0x4D5B.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x4D5B.TextScaled = true
_0x4D5B.TextWrapped = true
_0x4D5B.TextXAlignment = Enum.TextXAlignment.Left
_0x4D5B.Parent = _0xD05E
local _0x71BF = Instance.new(string.char(84,101,120,116,66,111,120))
_0x71BF.BackgroundTransparency = 1
_0x71BF.BorderSizePixel = 0
_0x71BF.FontFace = _0x1033
_0x71BF.LayoutOrder = 2
_0x71BF.PlaceholderColor3 = Color3.fromRGB(221, 221, 221)
_0x71BF.PlaceholderText = placeholderText
_0x71BF.Size = UDim2.new(0.2, 0, 1, 0)
_0x71BF.Text =""_0x71BF.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x71BF.TextScaled = true
_0x71BF.TextWrapped = true
_0x71BF.Parent = _0xD05E
local _0x8244 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0x8244.CornerRadius = UDim.new(0, 6)
_0x8244.Parent = _0x71BF
local _0xDA87 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xDA87.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xDA87.Color = Color3.fromRGB(36, 36, 36)
_0xDA87.Parent = _0x71BF
local _0x1CAE = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0x1CAE.PaddingBottom = UDim.new(0, 4)
_0x1CAE.PaddingLeft = UDim.new(0, 4)
_0x1CAE.PaddingRight = UDim.new(0, 4)
_0x1CAE.PaddingTop = UDim.new(0, 4)
_0x1CAE.Parent = _0x71BF
if settingKey then
_0x71BF.FocusLost:Connect(function(enterPressed)
if enterPressed then
local _0xA0ED = _0x418A.ParseColor(_0x71BF.Text)
if _0xA0ED then
_0x87A2[settingKey] = _0xA0ED
_0x418A.ApplyTheme()
_0x418A.SaveSettings()
end
end
end)
end
return _0x71BF
end
function _0x418A.GetNextTabName()
local _0x58CC = {}
for _, t in ipairs(_0x2B10) do
local _0xFBA6 = tonumber(t.name:match(string.char(94,84,97,98,32,40,37,100,43,41,36)))
if _0xFBA6 then _0x58CC[_0xFBA6] = true end
end
local _0x7E97 = 1
while _0x58CC[_0x7E97] do _0x7E97 = _0x7E97 + 1 end
returnstring.char(84,97,98,32).. _0x7E97
end
function _0x418A.SwitchExeTab(_0xF075)
if _0x1CF4 and _0x1CF4 ~= _0xF075 then
_0x1CF4.inputFrame.Visible = false
local _0x8D62 = _0x1CF4.tabBtn
if _0x8D62 then
local _0xAF13 = _0x8D62:FindFirstChild(string.char(65,99,116,105,118,101,76,105,110,101))
if _0xAF13 then _0xAF13.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
end
end
_0x1CF4 = _0xF075
_0xF075.inputFrame.Visible = true
local _0xD5D6 = _0xF075.tabBtn
if _0xD5D6 then
local _0xAF13 = _0xD5D6:FindFirstChild(string.char(65,99,116,105,118,101,76,105,110,101))
if _0xAF13 then _0xAF13.BackgroundColor3 = _0x87A2.AccentColor end
end
_0xE3E8.ExeBottomButtons.Visible = true
end
function _0x418A.CreateExeTab(_0x1671)
local _0xF075 = {}
_0xF075.name = _0x1671 or _0x418A.GetNextTabName()
_0xF075.code =""local _0xD5D6 = Instance.new(string.char(70,114,97,109,101))
_0xD5D6.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
_0xD5D6.BorderSizePixel = 0
_0xD5D6.Name =string.char(69,120,101,84,97,98,66,116,110,95).. _0xF075.name
_0xD5D6.Size = UDim2.new(0, 90, 1, 0)
_0xD5D6.Parent = _0xE3E8.ExeTabBarScroll
local _0xF7B0 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xF7B0.CornerRadius = UDim.new(0, 5)
_0xF7B0.Parent = _0xD5D6
local _0x2C41 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0x2C41.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0x2C41.Color = Color3.fromRGB(36, 36, 36)
_0x2C41.Parent = _0xD5D6
local _0xAF13 = Instance.new(string.char(70,114,97,109,101))
_0xAF13.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_0xAF13.BorderSizePixel = 0
_0xAF13.Name =string.char(65,99,116,105,118,101,76,105,110,101)_0xAF13.Size = UDim2.new(1, 0, 0, 2)
_0xAF13.AnchorPoint = Vector2.new(0, 1)
_0xAF13.Position = UDim2.new(0, 0, 1, 0)
_0xAF13.Parent = _0xD5D6
local _0xC0EF = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xC0EF.CornerRadius = UDim.new(0, 2)
_0xC0EF.Parent = _0xAF13
local _0xB257 = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xB257.FillDirection = Enum.FillDirection.Horizontal
_0xB257.VerticalAlignment = Enum.VerticalAlignment.Center
_0xB257.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xB257.Padding = UDim.new(0, 2)
_0xB257.SortOrder = Enum.SortOrder.LayoutOrder
_0xB257.Parent = _0xD5D6
local _0x9BBC = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0x9BBC.PaddingLeft = UDim.new(0, 6)
_0x9BBC.PaddingRight = UDim.new(0, 4)
_0x9BBC.PaddingTop = UDim.new(0, 2)
_0x9BBC.PaddingBottom = UDim.new(0, 4)
_0x9BBC.Parent = _0xD5D6
local _0xE149 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE149.BackgroundTransparency = 1
_0xE149.BorderSizePixel = 0
_0xE149.FontFace = _0x1033
_0xE149.LayoutOrder = 1
_0xE149.Name =string.char(84,97,98,78,97,109,101,66,116,110)_0xE149.Size = UDim2.new(1, -20, 1, 0)
_0xE149.Text = _0xF075.name
_0xE149.TextColor3 = Color3.fromRGB(200, 200, 200)
_0xE149.TextScaled = true
_0xE149.TextTruncate = Enum.TextTruncate.AtEnd
_0xE149.TextXAlignment = Enum.TextXAlignment.Left
_0xE149.Parent = _0xD5D6
local _0x39DA = Instance.new(string.char(84,101,120,116,66,111,120))
_0x39DA.BackgroundTransparency = 1
_0x39DA.BorderSizePixel = 0
_0x39DA.FontFace = _0x1033
_0x39DA.LayoutOrder = 1
_0x39DA.Name =string.char(84,97,98,78,97,109,101,66,111,120)_0x39DA.Size = UDim2.new(1, -20, 1, 0)
_0x39DA.Text = _0xF075.name
_0x39DA.TextColor3 = Color3.fromRGB(200, 200, 200)
_0x39DA.TextScaled = true
_0x39DA.TextXAlignment = Enum.TextXAlignment.Left
_0x39DA.Visible = false
_0x39DA.ClearTextOnFocus = false
_0x39DA.Parent = _0xD5D6
local _0xFD8F = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xFD8F.BackgroundTransparency = 1
_0xFD8F.BorderSizePixel = 0
_0xFD8F.FontFace = _0x0EEB
_0xFD8F.LayoutOrder = 2
_0xFD8F.Name =string.char(67,108,111,115,101,69,120,101,84,97,98)_0xFD8F.Size = UDim2.new(0, 16, 0, 16)
_0xFD8F.Text =string.char(88)_0xFD8F.TextColor3 = Color3.fromRGB(160, 160, 160)
_0xFD8F.TextScaled = true
_0xFD8F.Parent = _0xD5D6
local _0xEEA7 = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xEEA7.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xEEA7.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xEEA7.BorderSizePixel = 0
_0xEEA7.CanvasSize = UDim2.new(0, 0, 0, 0)
_0xEEA7.Name =string.char(69,120,101,73,110,112,117,116,70,114,97,109,101,95).. _0xF075.name
_0xEEA7.ScrollingDirection = Enum.ScrollingDirection.Y
_0xEEA7.ScrollBarThickness = 6
_0xEEA7.Size = UDim2.new(1, 0, 1, 0)
_0xEEA7.Visible = false
_0xEEA7.Parent = _0xE3E8.ExeEditorArea
local _0x9750 = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0x9750.PaddingBottom = UDim.new(0, 6)
_0x9750.PaddingLeft = UDim.new(0, 6)
_0x9750.PaddingRight = UDim.new(0, 6)
_0x9750.PaddingTop = UDim.new(0, 6)
_0x9750.Parent = _0xEEA7
local _0xFDC2 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xFDC2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xFDC2.Color = Color3.fromRGB(36, 36, 36)
_0xFDC2.Parent = _0xEEA7
local _0x13FA = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0x13FA.CornerRadius = UDim.new(0, 6)
_0x13FA.Parent = _0xEEA7
local _0x4E6A = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x4E6A.AutomaticSize = Enum.AutomaticSize.Y
_0x4E6A.BackgroundTransparency = 1
_0x4E6A.FontFace = _0x296B
_0x4E6A.Name =string.char(72,105,103,104,108,105,103,104,116)_0x4E6A.RichText = true
_0x4E6A.Size = UDim2.new(1, 0, 0, 0)
_0x4E6A.Text =""_0x4E6A.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x4E6A.TextSize = 18
_0x4E6A.TextWrapped = true
_0x4E6A.TextXAlignment = Enum.TextXAlignment.Left
_0x4E6A.TextYAlignment = Enum.TextYAlignment.Top
_0x4E6A.Active = false
_0x4E6A.Selectable = false
_0x4E6A.Parent = _0xEEA7
local _0x54E7 = Instance.new(string.char(84,101,120,116,66,111,120))
_0x54E7.AutomaticSize = Enum.AutomaticSize.Y
_0x54E7.BackgroundTransparency = 1
_0x54E7.BorderSizePixel = 0
_0x54E7.ClearTextOnFocus = false
_0x54E7.FontFace = _0x296B
_0x54E7.MultiLine = true
_0x54E7.Name =string.char(73,110,112,117,116,66,111,120)_0x54E7.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
_0x54E7.PlaceholderText =string.char(69,110,116,101,114,32,99,111,100,101,32,104,101,114,101,46,46,46)_0x54E7.Size = UDim2.new(1, 0, 0, 0)
_0x54E7.Text =""_0x54E7.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x54E7.TextSize = 18
_0x54E7.TextTransparency = 1
_0x54E7.TextWrapped = true
_0x54E7.TextXAlignment = Enum.TextXAlignment.Left
_0x54E7.TextYAlignment = Enum.TextYAlignment.Top
_0x54E7.Parent = _0xEEA7
local _0x6C4B = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0x6C4B.MaxSize = Vector2.new(2147483647, 2147483647)
_0x6C4B.MinSize = Vector2.new(0, 200)
_0x6C4B.Parent = _0x54E7
_0x54E7:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(function()
_0xF075.code = _0x54E7.Text
_0x4E6A.Text = _0x418A.Highlight(_0x54E7.Text)
end)
_0xF075.tabBtn = _0xD5D6
_0xF075.inputFrame = _0xEEA7
_0xF075.inputBox = _0x54E7
_0xF075.highlight = _0x4E6A
_0xE149.MouseButton1Click:Connect(function()
_0x418A.SwitchExeTab(_0xF075)
end)
_0xE149.MouseButton2Click:Connect(function()
_0xE149.Visible = false
_0x39DA.Visible = true
_0x39DA:CaptureFocus()
end)
_0x39DA.FocusLost:Connect(function()
local _0x8713 = _0x39DA.Text
if _0x8713 and _0x8713 ~=""then
_0xF075.name = _0x8713
_0xE149.Text = _0x8713
end
_0x39DA.Visible = false
_0xE149.Visible = true
end)
_0xFD8F.MouseButton1Click:Connect(function()
if #_0x2B10 <= 1 then return end
local _0x0A4C = table.find(_0x2B10, _0xF075)
table.remove(_0x2B10, _0x0A4C)
_0xD5D6:Destroy()
_0xEEA7:Destroy()
if _0x1CF4 == _0xF075 then
local _0xF21E = math.min(_0x0A4C, #_0x2B10)
if _0x2B10[_0xF21E] then
_0x1CF4 = nil
_0x418A.SwitchExeTab(_0x2B10[_0xF21E])
end
end
end)
table.insert(_0x2B10, _0xF075)
_0x418A.SwitchExeTab(_0xF075)
return _0xF075
end
function _0x418A.GetMusicFiles()
if not _0x7C4A(string.char(76,117,99,105,100,47,77,117,115,105,99)) then _0xC3F3(string.char(76,117,99,105,100,47,77,117,115,105,99)) end
local _0xA398 = _0xE3A8(string.char(76,117,99,105,100,47,77,117,115,105,99)) or {}
local _0x49EA = {}
local _0xB696 = {mp3 = true, m4a = true, ogg = true, wav = true, flac = true, aiff = true}
for _, file in ipairs(_0xA398) do
local _0x0C13 = file:match(string.char(37,46,40,91,94,37,46,93,43,41,36))
if _0x0C13 and _0xB696[_0x0C13:lower()] then
table.insert(_0x49EA, file)
end
end
return _0x49EA
end
function _0x418A.GetMusicDisplayName(path)
local _0x1671 = path:match(string.char(40,91,94,47,92,93,43,41,36)) or path
_0x1671 = _0x1671:gsub(string.char(37,46,91,94,37,46,93,43,36),"")
return _0x1671
end
function _0x418A.FormatTime(seconds)
if not seconds or seconds ~= seconds then returnstring.char(48,58,48,48)end
seconds = math.floor(seconds)
local _0x6D2C = math.floor(seconds / 60)
local _0xCBBD = seconds % 60
return string.format(string.char(37,100,58,37,48,50,100), _0x6D2C, _0xCBBD)
end
function _0x418A.UpdateMusicSlider()
if not _0x6B61 or not _0x6B61.Parent then return end
local _0xBE35 = _0x6B61.TimeLength
local _0x201B = _0x6B61.TimePosition
if _0xBE35 and _0xBE35 > 0 and not _0xEFB8 then
local _0x5186 = math.clamp(_0x201B / _0xBE35, 0, 1)
_0xE3E8.MusicSliderFill.Size = UDim2.new(_0x5186, 0, 1, 0)
_0xE3E8.MusicSliderKnob.Position = UDim2.new(_0x5186, -6, 0.5, -6)
_0xE3E8.MusicTimeLabel.Text = _0x418A.FormatTime(_0x201B) ..string.char(32,47,32).. _0x418A.FormatTime(_0xBE35)
end
end
function _0x418A.LoadAndPlayMusic(_0x3B0F)
if not _0x3162 or #_0x3162 == 0 then return end
_0x3B0F = ((_0x3B0F - 1) % #_0x3162) + 1
_0xD865 = _0x3B0F
local _0x4C08 = _0x3162[_0x3B0F]
if _0x6B61 then
_0x6B61:Stop()
_0x6B61:Destroy()
_0x6B61 = nil
end
local _0xB03F = pcall(_0x5444, _0x4C08) and _0x5444(_0x4C08)
if not _0xB03F then
_0xE3E8.MusicNowPlaying.Text =string.char(70,97,105,108,101,100,32,116,111,32,108,111,97,100,58,32).. _0x418A.GetMusicDisplayName(_0x4C08)
return
end
_0x6B61 = Instance.new(string.char(83,111,117,110,100))
_0x6B61.SoundId = _0xB03F
_0x6B61.Volume = tonumber(_0xE3E8.MusicVolumeBox.Text) or 1
_0x6B61.PlaybackSpeed = tonumber(_0xE3E8.MusicSpeedBox.Text) or 1
_0x6B61.Looped = _0xE3E8.MusicLoopToggle:FindFirstChild(string.char(76,111,111,112,83,116,97,116,101)) and _0xE3E8.MusicLoopToggle.LoopState.BackgroundColor3 == Color3.fromRGB(0, 255, 0) or false
_0x6B61.Parent = _0x34CA
_0x6B61:Play()
_0x140A = true
_0xE3E8.MusicPlayBtn.Text =string.char(226,143,184)_0xE3E8.MusicNowPlaying.Text = _0x418A.GetMusicDisplayName(_0x4C08)
_0x6B61.Ended:Connect(function()
if not _0x6B61.Looped then
_0x418A.LoadAndPlayMusic(_0xD865 + 1)
end
end)
_0x418A.RefreshMusicList()
end
function _0x418A.RefreshMusicList()
_0x3162 = _0x418A.GetMusicFiles()
local _0xB3E7 = _0xE3E8.MusicListScroll
if not _0xB3E7 then return end
for _, child in ipairs(_0xB3E7:GetChildren()) do
if child.Name ~=string.char(77,117,115,105,99,76,105,115,116,76,97,121,111,117,116)and child.Name ~=string.char(77,117,115,105,99,76,105,115,116,80,97,100,100,105,110,103)and child.Name ~=string.char(78,111,77,117,115,105,99,76,97,98,101,108)then
child:Destroy()
end
end
if #_0x3162 == 0 then
if _0xE3E8.NoMusicLabel then
_0xE3E8.NoMusicLabel.Visible = true
end
return
end
if _0xE3E8.NoMusicLabel then _0xE3E8.NoMusicLabel.Visible = false end
for _0x1DF8, _0x4C08 in ipairs(_0x3162) do
local _0xDA9E = _0x418A.GetMusicDisplayName(_0x4C08)
local _0x7676 = (_0x1DF8 == _0xD865 and _0x140A)
local _0xD71C = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xD71C.BackgroundColor3 = _0x7676 and _0x87A2.AccentColor or Color3.fromRGB(22, 22, 22)
_0xD71C.BackgroundTransparency = _0x7676 and 0.5 or 0
_0xD71C.BorderSizePixel = 0
_0xD71C.Name =string.char(77,117,115,105,99,82,111,119,95).. _0x1DF8
_0xD71C.Size = UDim2.new(1, 0, 0, 32)
_0xD71C.Text =""_0xD71C.Parent = _0xB3E7
local _0xDA94 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xDA94.CornerRadius = UDim.new(0, 5)
_0xDA94.Parent = _0xD71C
local _0x5E33 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0x5E33.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0x5E33.Color = _0x7676 and _0x87A2.AccentColor or Color3.fromRGB(36, 36, 36)
_0x5E33.Parent = _0xD71C
local _0x0878 = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0x0878.FillDirection = Enum.FillDirection.Horizontal
_0x0878.VerticalAlignment = Enum.VerticalAlignment.Center
_0x0878.Padding = UDim.new(0, 6)
_0x0878.SortOrder = Enum.SortOrder.LayoutOrder
_0x0878.Parent = _0xD71C
local _0xC0E9 = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xC0E9.PaddingLeft = UDim.new(0, 10)
_0xC0E9.PaddingRight = UDim.new(0, 10)
_0xC0E9.Parent = _0xD71C
local _0xD755 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xD755.BackgroundTransparency = 1
_0xD755.BorderSizePixel = 0
_0xD755.FontFace = _0x1033
_0xD755.LayoutOrder = 1
_0xD755.Size = UDim2.new(0, 20, 1, 0)
_0xD755.Text = tostring(_0x1DF8)
_0xD755.TextColor3 = _0x7676 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
_0xD755.TextScaled = true
_0xD755.Parent = _0xD71C
local _0x0282 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x0282.BackgroundTransparency = 1
_0x0282.BorderSizePixel = 0
_0x0282.FontFace = _0x1033
_0x0282.LayoutOrder = 2
_0x0282.Size = UDim2.new(1, -30, 1, 0)
_0x0282.Text = _0xDA9E
_0x0282.TextColor3 = _0x7676 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
_0x0282.TextScaled = true
_0x0282.TextTruncate = Enum.TextTruncate.AtEnd
_0x0282.TextXAlignment = Enum.TextXAlignment.Left
_0x0282.Parent = _0xD71C
local _0xC44A = _0x1DF8
_0xD71C.MouseButton1Click:Connect(function()
_0x418A.LoadAndPlayMusic(_0xC44A)
end)
end
end
_0x418A.PreloadAssets()
_0x33BE()
if _0x012A.Lucid.IsLoaded then
_0xB65B:SetCore(string.char(83,101,110,100,78,111,116,105,102,105,99,97,116,105,111,110), {
Title =string.char(76,117,99,105,100,32,69,120,101,99,117,116,111,114),
Text =string.char(76,117,99,105,100,32,105,115,32,97,108,114,101,97,100,121,32,114,117,110,110,105,110,103,33),
Icon = _0x418A.GetAsset(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,108,111,103,111,46,112,110,103)),
Duration = 4
})
return
end
_0x012A.Lucid.IsLoaded = true
_0xE3E8.ScreenGui = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0xE3E8.ScreenGui.DisplayOrder = 2147483647
_0xE3E8.ScreenGui.IgnoreGuiInset = true
_0xE3E8.ScreenGui.Name =string.char(76,117,99,105,100)_0xE3E8.ScreenGui.ResetOnSpawn = false
_0xE3E8.ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
_0xE3E8.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_0xE3E8.ScreenGui.Parent = _0x6A51
_0xE3E8.Show = Instance.new(string.char(73,109,97,103,101,66,117,116,116,111,110))
_0xE3E8.Show.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
_0xE3E8.Show.BackgroundTransparency = 0.08
_0xE3E8.Show.BorderSizePixel = 0
_0xE3E8.Show.Name =string.char(83,104,111,119)_0xE3E8.Show.Position = UDim2.new(0, 16, 0, 60)
_0xE3E8.Show.Size = UDim2.new(0, 44, 0, 44)
_0xE3E8.Show.Visible = true
_0xE3E8.Show.ZIndex = 3
_0xE3E8.Show.Parent = _0xE3E8.ScreenGui
_0xE3E8.ShowRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.ShowRatio.Name =string.char(83,104,111,119,82,97,116,105,111)_0xE3E8.ShowRatio.Parent = _0xE3E8.Show
_0xE3E8.ShowCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ShowCorner.CornerRadius = UDim.new(1, 0)
_0xE3E8.ShowCorner.Parent = _0xE3E8.Show
_0xE3E8.ShowIcon = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.ShowIcon.AnchorPoint = Vector2.new(0.5, 0.5)
_0xE3E8.ShowIcon.BackgroundTransparency = 1
_0xE3E8.ShowIcon.BorderSizePixel = 0
_0xE3E8.ShowIcon.Image = _0x418A.GetAsset(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,108,111,103,111,46,112,110,103))
_0xE3E8.ShowIcon.Name =string.char(83,104,111,119,73,99,111,110)_0xE3E8.ShowIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xE3E8.ShowIcon.Size = UDim2.new(0, 28, 0, 28)
_0xE3E8.ShowIcon.Parent = _0xE3E8.Show
_0xE3E8.MainFrame = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MainFrame.AutoLocalize = false
_0xE3E8.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_0xE3E8.MainFrame.BackgroundTransparency = 0.35
_0xE3E8.MainFrame.BorderSizePixel = 0
_0xE3E8.MainFrame.Name =string.char(77,97,105,110,70,114,97,109,101)_0xE3E8.MainFrame.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.MainFrame.Visible = false
_0xE3E8.MainFrame.Parent = _0xE3E8.ScreenGui
_0xE3E8.MainFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MainFrameLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.MainFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MainFrameLayout.Name =string.char(77,97,105,110,70,114,97,109,101,76,97,121,111,117,116)_0xE3E8.MainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MainFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MainFrameLayout.Parent = _0xE3E8.MainFrame
_0xE3E8.Pages = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Pages.BackgroundTransparency = 1
_0xE3E8.Pages.BorderSizePixel = 0
_0xE3E8.Pages.LayoutOrder = 1
_0xE3E8.Pages.Name =string.char(80,97,103,101,115)_0xE3E8.Pages.Size = UDim2.new(0, 576, 0, 116)
_0xE3E8.Pages.Parent = _0xE3E8.MainFrame
_0xE3E8.PagesPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.PagesPadding.Name =string.char(80,97,103,101,115,80,97,100,100,105,110,103)_0xE3E8.PagesPadding.PaddingBottom = UDim.new(0, 8)
_0xE3E8.PagesPadding.PaddingLeft = UDim.new(0, 8)
_0xE3E8.PagesPadding.PaddingTop = UDim.new(0, 60)
_0xE3E8.PagesPadding.Parent = _0xE3E8.Pages
_0xE3E8.HomeContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.HomeContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.HomeContent.BorderSizePixel = 0
_0xE3E8.HomeContent.LayoutOrder = 1
_0xE3E8.HomeContent.Name =string.char(72,111,109,101,67,111,110,116,101,110,116)_0xE3E8.HomeContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.HomeContent.Visible = false
_0xE3E8.HomeContent.Parent = _0xE3E8.Pages
_0xE3E8.HomeContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.HomeContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.HomeContentCorner.Parent = _0xE3E8.HomeContent
_0xE3E8.HomeContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.HomeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.HomeContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.HomeContentStroke.Name =string.char(72,111,109,101,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.HomeContentStroke.Parent = _0xE3E8.HomeContent
_0xE3E8.HomeContentLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.HomeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.HomeContentLayout.Padding = UDim.new(0, 6)
_0xE3E8.HomeContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.HomeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.HomeContentLayout.Parent = _0xE3E8.HomeContent
_0xE3E8.HomeInfo = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.HomeInfo.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xE3E8.HomeInfo.BackgroundTransparency = 1
_0xE3E8.HomeInfo.BorderSizePixel = 0
_0xE3E8.HomeInfo.CanvasSize = UDim2.new(0, 0, 0, 0)
_0xE3E8.HomeInfo.Name =string.char(72,111,109,101,73,110,102,111)_0xE3E8.HomeInfo.ScrollBarThickness = 0
_0xE3E8.HomeInfo.ScrollingDirection = Enum.ScrollingDirection.Y
_0xE3E8.HomeInfo.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.HomeInfo.Parent = _0xE3E8.HomeContent
_0xE3E8.HomeInfoPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.HomeInfoPadding.PaddingBottom = UDim.new(0, 5)
_0xE3E8.HomeInfoPadding.PaddingLeft = UDim.new(0, 5)
_0xE3E8.HomeInfoPadding.PaddingRight = UDim.new(0, 5)
_0xE3E8.HomeInfoPadding.PaddingTop = UDim.new(0, 5)
_0xE3E8.HomeInfoPadding.Parent = _0xE3E8.HomeInfo
_0xE3E8.HomeInfoLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.HomeInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.HomeInfoLayout.Padding = UDim.new(0, 6)
_0xE3E8.HomeInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.HomeInfoLayout.Parent = _0xE3E8.HomeInfo
_0xE3E8.PlayerStats = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.PlayerStats.BackgroundTransparency = 1
_0xE3E8.PlayerStats.BorderSizePixel = 0
_0xE3E8.PlayerStats.LayoutOrder = 1
_0xE3E8.PlayerStats.Name =string.char(80,108,97,121,101,114,83,116,97,116,115)_0xE3E8.PlayerStats.Size = UDim2.new(1, 0, 0, 400)
_0xE3E8.PlayerStats.Parent = _0xE3E8.HomeInfo
_0xE3E8.PlayerStatsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.PlayerStatsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.PlayerStatsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PlayerStatsLayout.Padding = UDim.new(0, 6)
_0xE3E8.PlayerStatsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.PlayerStatsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PlayerStatsLayout.Parent = _0xE3E8.PlayerStats
_0xE3E8.Avatar = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Avatar.BackgroundTransparency = 1
_0xE3E8.Avatar.BorderSizePixel = 0
_0xE3E8.Avatar.LayoutOrder = 1
_0xE3E8.Avatar.Name =string.char(65,118,97,116,97,114)_0xE3E8.Avatar.Size = UDim2.new(0, 0, 1, 0)
_0xE3E8.Avatar.Parent = _0xE3E8.PlayerStats
_0xE3E8.PlayerHeadshot = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.PlayerHeadshot.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.PlayerHeadshot.BorderSizePixel = 0
_0xE3E8.PlayerHeadshot.Interactable = false
_0xE3E8.PlayerHeadshot.Name =string.char(80,108,97,121,101,114,72,101,97,100,115,104,111,116)_0xE3E8.PlayerHeadshot.ScaleType = Enum.ScaleType.Fit
_0xE3E8.PlayerHeadshot.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.PlayerHeadshot.Parent = _0xE3E8.Avatar
_0xE3E8.PlayerHeadshotRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.PlayerHeadshotRatio.Parent = _0xE3E8.PlayerHeadshot
_0xE3E8.PlayerHeadshotCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.PlayerHeadshotCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.PlayerHeadshotCorner.Parent = _0xE3E8.PlayerHeadshot
_0xE3E8.PlayerHeadshotStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.PlayerHeadshotStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.PlayerHeadshotStroke.Name =string.char(80,108,97,121,101,114,72,101,97,100,115,104,111,116,83,116,114,111,107,101)_0xE3E8.PlayerHeadshotStroke.Parent = _0xE3E8.PlayerHeadshot
_0xE3E8.PlayerInfo = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.PlayerInfo.BackgroundTransparency = 1
_0xE3E8.PlayerInfo.BorderSizePixel = 0
_0xE3E8.PlayerInfo.LayoutOrder = 2
_0xE3E8.PlayerInfo.Name =string.char(80,108,97,121,101,114,73,110,102,111)_0xE3E8.PlayerInfo.Size = UDim2.new(0.75, 0, 1, 0)
_0xE3E8.PlayerInfo.Parent = _0xE3E8.PlayerStats
_0xE3E8.PlayerInfoLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.PlayerInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PlayerInfoLayout.Padding = UDim.new(0, 6)
_0xE3E8.PlayerInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.PlayerInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PlayerInfoLayout.Parent = _0xE3E8.PlayerInfo
_0xE3E8.WelcomeLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.WelcomeLabel.BackgroundTransparency = 1
_0xE3E8.WelcomeLabel.BorderSizePixel = 0
_0xE3E8.WelcomeLabel.FontFace = _0x1033
_0xE3E8.WelcomeLabel.Name =string.char(87,101,108,99,111,109,101,76,97,98,101,108)_0xE3E8.WelcomeLabel.Size = UDim2.new(0, 432, 0, 0)
_0xE3E8.WelcomeLabel.Text =string.char(87,101,108,99,111,109,101,32,116,111,32,76,117,99,105,100,44,32,68,105,115,112,108,97,121,78,97,109,101,33)_0xE3E8.WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.WelcomeLabel.TextScaled = true
_0xE3E8.WelcomeLabel.TextSize = 20
_0xE3E8.WelcomeLabel.TextWrapped = true
_0xE3E8.WelcomeLabel.Parent = _0xE3E8.PlayerInfo
_0xE3E8.WelcomeLabelStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.WelcomeLabelStroke.Color = Color3.fromRGB(0, 94, 255)
_0xE3E8.WelcomeLabelStroke.Name =string.char(87,101,108,99,111,109,101,76,97,98,101,108,83,116,114,111,107,101)_0xE3E8.WelcomeLabelStroke.Parent = _0xE3E8.WelcomeLabel
_0xE3E8.InfoLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.InfoLabel.BackgroundTransparency = 1
_0xE3E8.InfoLabel.BorderSizePixel = 0
_0xE3E8.InfoLabel.FontFace = _0x1033
_0xE3E8.InfoLabel.Name =string.char(73,110,102,111,76,97,98,101,108)_0xE3E8.InfoLabel.RichText = true
_0xE3E8.InfoLabel.Size = UDim2.new(1, 0, 0.75, 0)
_0xE3E8.InfoLabel.Text =string.char(76,111,97,100,105,110,103,46,46,46)_0xE3E8.InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.InfoLabel.TextScaled = true
_0xE3E8.InfoLabel.TextWrapped = true
_0xE3E8.InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
_0xE3E8.InfoLabel.Parent = _0xE3E8.PlayerInfo
_0xE3E8.InfoLabelStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.InfoLabelStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.InfoLabelStroke.Name =string.char(73,110,102,111,76,97,98,101,108,83,116,114,111,107,101)_0xE3E8.InfoLabelStroke.Parent = _0xE3E8.InfoLabel
_0xE3E8.InfoLabel2 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.InfoLabel2.AutomaticSize = Enum.AutomaticSize.Y
_0xE3E8.InfoLabel2.BackgroundTransparency = 1
_0xE3E8.InfoLabel2.BorderSizePixel = 0
_0xE3E8.InfoLabel2.LayoutOrder = 2
_0xE3E8.InfoLabel2.Name =string.char(73,110,102,111,76,97,98,101,108,50)_0xE3E8.InfoLabel2.RichText = true
_0xE3E8.InfoLabel2.Size = UDim2.new(1, 0, 0, 0)
_0xE3E8.InfoLabel2.Text =[[<p align="center"><font size="22"><b>About Lucid</b></font></p>

<p align="left">
Lucid is a modern interface that replaces your executor's UI while keeping its original functionality. It provides a cleaner design, smoother animations, and a more consistent experience.
</p>

<p align="center"><font size="22"><b>Features</b></font></p>

<p align="left">
- Search scripts directly from <b>RScripts.net</b> or <b>ScriptBlox.com</b>, switchable from the Search tab.<br/>
- Save your favorite scripts for quick access in the <b>Scripts</b> tab.<br/>
- Multi-tab code editor with renameable tabs.<br/>
- Built-in music player from <b>Lucid/Music/</b> folder.<br/>
- Customize Lucid's appearance with your own colors.<br/>
- Automatically save your settings and preferences.
</p>

<p align="center"><font size="22"><b>Credits</b></font></p>

<p align="left">
Created and maintained by <b>JustAGuest</b>.
</p>

<p align="center"><i>Thank you for using Lucid!</i></p>]]_0xE3E8.InfoLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.InfoLabel2.TextSize = 14
_0xE3E8.InfoLabel2.TextWrapped = true
_0xE3E8.InfoLabel2.Parent = _0xE3E8.HomeInfo
_0xE3E8.InfoLabel2Stroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.InfoLabel2Stroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.InfoLabel2Stroke.Name =string.char(73,110,102,111,76,97,98,101,108,50,83,116,114,111,107,101)_0xE3E8.InfoLabel2Stroke.Parent = _0xE3E8.InfoLabel2
_0xE3E8.ExeContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.ExeContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.ExeContent.BorderSizePixel = 0
_0xE3E8.ExeContent.LayoutOrder = 1
_0xE3E8.ExeContent.Name =string.char(69,120,101,67,111,110,116,101,110,116)_0xE3E8.ExeContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.ExeContent.Visible = false
_0xE3E8.ExeContent.Parent = _0xE3E8.Pages
_0xE3E8.ExeContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ExeContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ExeContentCorner.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ExeContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ExeContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.ExeContentStroke.Name =string.char(69,120,101,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.ExeContentStroke.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeContentLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ExeContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeContentLayout.Padding = UDim.new(0, 4)
_0xE3E8.ExeContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ExeContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeContentLayout.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeContentPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ExeContentPadding.PaddingBottom = UDim.new(0, 5)
_0xE3E8.ExeContentPadding.PaddingLeft = UDim.new(0, 5)
_0xE3E8.ExeContentPadding.PaddingRight = UDim.new(0, 5)
_0xE3E8.ExeContentPadding.PaddingTop = UDim.new(0, 5)
_0xE3E8.ExeContentPadding.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeTabBarWrapper = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.ExeTabBarWrapper.BackgroundTransparency = 1
_0xE3E8.ExeTabBarWrapper.BorderSizePixel = 0
_0xE3E8.ExeTabBarWrapper.LayoutOrder = 1
_0xE3E8.ExeTabBarWrapper.Name =string.char(69,120,101,84,97,98,66,97,114,87,114,97,112,112,101,114)_0xE3E8.ExeTabBarWrapper.Size = UDim2.new(1, 0, 0, 30)
_0xE3E8.ExeTabBarWrapper.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeTabBarWrapperLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ExeTabBarWrapperLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.ExeTabBarWrapperLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeTabBarWrapperLayout.Padding = UDim.new(0, 4)
_0xE3E8.ExeTabBarWrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ExeTabBarWrapperLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeTabBarWrapperLayout.Parent = _0xE3E8.ExeTabBarWrapper
_0xE3E8.ExeTabBarSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.ExeTabBarSizeCons.MaxSize = Vector2.new(2147483647, 30)
_0xE3E8.ExeTabBarSizeCons.MinSize = Vector2.new(0, 30)
_0xE3E8.ExeTabBarSizeCons.Parent = _0xE3E8.ExeTabBarWrapper
_0xE3E8.ExeTabBarScroll = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.ExeTabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
_0xE3E8.ExeTabBarScroll.BackgroundTransparency = 1
_0xE3E8.ExeTabBarScroll.BorderSizePixel = 0
_0xE3E8.ExeTabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
_0xE3E8.ExeTabBarScroll.LayoutOrder = 1
_0xE3E8.ExeTabBarScroll.Name =string.char(69,120,101,84,97,98,66,97,114,83,99,114,111,108,108)_0xE3E8.ExeTabBarScroll.ScrollBarThickness = 3
_0xE3E8.ExeTabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
_0xE3E8.ExeTabBarScroll.Size = UDim2.new(1, -38, 1, 0)
_0xE3E8.ExeTabBarScroll.Parent = _0xE3E8.ExeTabBarWrapper
_0xE3E8.ExeTabBarScrollLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ExeTabBarScrollLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.ExeTabBarScrollLayout.Padding = UDim.new(0, 4)
_0xE3E8.ExeTabBarScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ExeTabBarScrollLayout.VerticalAlignment = Enum.VerticalAlignment.Center
_0xE3E8.ExeTabBarScrollLayout.Parent = _0xE3E8.ExeTabBarScroll
_0xE3E8.ExeTabBarScrollPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ExeTabBarScrollPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.ExeTabBarScrollPadding.Parent = _0xE3E8.ExeTabBarScroll
_0xE3E8.AddExeTabBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.AddExeTabBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.AddExeTabBtn.BorderSizePixel = 0
_0xE3E8.AddExeTabBtn.FontFace = _0x0EEB
_0xE3E8.AddExeTabBtn.LayoutOrder = 2
_0xE3E8.AddExeTabBtn.Name =string.char(65,100,100,69,120,101,84,97,98,66,116,110)_0xE3E8.AddExeTabBtn.Size = UDim2.new(0, 30, 1, 0)
_0xE3E8.AddExeTabBtn.Text =string.char(43)_0xE3E8.AddExeTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.AddExeTabBtn.TextScaled = true
_0xE3E8.AddExeTabBtn.Parent = _0xE3E8.ExeTabBarWrapper
_0xE3E8.AddExeTabBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.AddExeTabBtnCorner.CornerRadius = UDim.new(0, 5)
_0xE3E8.AddExeTabBtnCorner.Parent = _0xE3E8.AddExeTabBtn
_0xE3E8.AddExeTabBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.AddExeTabBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.AddExeTabBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.AddExeTabBtnStroke.Name =string.char(65,100,100,69,120,101,84,97,98,66,116,110,83,116,114,111,107,101)_0xE3E8.AddExeTabBtnStroke.Parent = _0xE3E8.AddExeTabBtn
_0xE3E8.AddExeTabBtnRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.AddExeTabBtnRatio.Parent = _0xE3E8.AddExeTabBtn
_0xE3E8.ExeEditorArea = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.ExeEditorArea.BackgroundTransparency = 1
_0xE3E8.ExeEditorArea.BorderSizePixel = 0
_0xE3E8.ExeEditorArea.LayoutOrder = 2
_0xE3E8.ExeEditorArea.Name =string.char(69,120,101,69,100,105,116,111,114,65,114,101,97)_0xE3E8.ExeEditorArea.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.ExeEditorArea.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeBottomButtons = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.ExeBottomButtons.BackgroundTransparency = 1
_0xE3E8.ExeBottomButtons.BorderSizePixel = 0
_0xE3E8.ExeBottomButtons.LayoutOrder = 3
_0xE3E8.ExeBottomButtons.Name =string.char(69,120,101,66,111,116,116,111,109,66,117,116,116,111,110,115)_0xE3E8.ExeBottomButtons.Size = UDim2.new(1, 0, 0, 38)
_0xE3E8.ExeBottomButtons.Visible = false
_0xE3E8.ExeBottomButtons.Parent = _0xE3E8.ExeContent
_0xE3E8.ExeBottomButtonsSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.ExeBottomButtonsSizeCons.MaxSize = Vector2.new(2147483647, 38)
_0xE3E8.ExeBottomButtonsSizeCons.Parent = _0xE3E8.ExeBottomButtons
_0xE3E8.ExeBottomButtonsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ExeBottomButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.ExeBottomButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeBottomButtonsLayout.Padding = UDim.new(0, 6)
_0xE3E8.ExeBottomButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ExeBottomButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ExeBottomButtonsLayout.Parent = _0xE3E8.ExeBottomButtons
_0xE3E8.ExeBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.ExeBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.ExeBtn.BorderSizePixel = 0
_0xE3E8.ExeBtn.FontFace = _0x340D
_0xE3E8.ExeBtn.LayoutOrder = 1
_0xE3E8.ExeBtn.Name =string.char(69,120,101,66,116,110)_0xE3E8.ExeBtn.Size = UDim2.new(0.2, 0, 1, 0)
_0xE3E8.ExeBtn.Text =string.char(69,120,101,99,117,116,101)_0xE3E8.ExeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.ExeBtn.TextScaled = true
_0xE3E8.ExeBtn.TextWrapped = true
_0xE3E8.ExeBtn.Parent = _0xE3E8.ExeBottomButtons
_0xE3E8.ExeBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ExeBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ExeBtnCorner.Parent = _0xE3E8.ExeBtn
_0xE3E8.ExeBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ExeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ExeBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.ExeBtnStroke.Name =string.char(69,120,101,66,116,110,83,116,114,111,107,101)_0xE3E8.ExeBtnStroke.Parent = _0xE3E8.ExeBtn
_0xE3E8.ExeBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ExeBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.ExeBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.ExeBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.ExeBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.ExeBtnPadding.Parent = _0xE3E8.ExeBtn
_0xE3E8.ClrBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.ClrBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.ClrBtn.BorderSizePixel = 0
_0xE3E8.ClrBtn.FontFace = _0x340D
_0xE3E8.ClrBtn.LayoutOrder = 2
_0xE3E8.ClrBtn.Name =string.char(67,108,114,66,116,110)_0xE3E8.ClrBtn.Size = UDim2.new(0.2, 0, 1, 0)
_0xE3E8.ClrBtn.Text =string.char(67,108,101,97,114)_0xE3E8.ClrBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.ClrBtn.TextScaled = true
_0xE3E8.ClrBtn.TextWrapped = true
_0xE3E8.ClrBtn.Parent = _0xE3E8.ExeBottomButtons
_0xE3E8.ClrBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ClrBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ClrBtnCorner.Parent = _0xE3E8.ClrBtn
_0xE3E8.ClrBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ClrBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ClrBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.ClrBtnStroke.Name =string.char(67,108,114,66,116,110,83,116,114,111,107,101)_0xE3E8.ClrBtnStroke.Parent = _0xE3E8.ClrBtn
_0xE3E8.ClrBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ClrBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.ClrBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.ClrBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.ClrBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.ClrBtnPadding.Parent = _0xE3E8.ClrBtn
_0xE3E8.CopyBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.CopyBtn.BorderSizePixel = 0
_0xE3E8.CopyBtn.FontFace = _0x340D
_0xE3E8.CopyBtn.LayoutOrder = 3
_0xE3E8.CopyBtn.Name =string.char(67,111,112,121,66,116,110)_0xE3E8.CopyBtn.Size = UDim2.new(0.2, 0, 1, 0)
_0xE3E8.CopyBtn.Text =string.char(67,111,112,121)_0xE3E8.CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.CopyBtn.TextScaled = true
_0xE3E8.CopyBtn.TextWrapped = true
_0xE3E8.CopyBtn.Parent = _0xE3E8.ExeBottomButtons
_0xE3E8.CopyBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.CopyBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.CopyBtnCorner.Parent = _0xE3E8.CopyBtn
_0xE3E8.CopyBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.CopyBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.CopyBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.CopyBtnStroke.Name =string.char(67,111,112,121,66,116,110,83,116,114,111,107,101)_0xE3E8.CopyBtnStroke.Parent = _0xE3E8.CopyBtn
_0xE3E8.CopyBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.CopyBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.CopyBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.CopyBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.CopyBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.CopyBtnPadding.Parent = _0xE3E8.CopyBtn
_0xE3E8.SearchContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.SearchContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.SearchContent.BorderSizePixel = 0
_0xE3E8.SearchContent.LayoutOrder = 2
_0xE3E8.SearchContent.Name =string.char(83,101,97,114,99,104,67,111,110,116,101,110,116)_0xE3E8.SearchContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.SearchContent.Visible = false
_0xE3E8.SearchContent.Parent = _0xE3E8.Pages
_0xE3E8.SearchContentPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SearchContentPadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.SearchContentPadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.SearchContentPadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.SearchContentPadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.SearchContentPadding.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchContentLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SearchContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SearchContentLayout.Padding = UDim.new(0, 6)
_0xE3E8.SearchContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SearchContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SearchContentLayout.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SearchContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SearchContentCorner.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SearchContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SearchContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.SearchContentStroke.Name =string.char(83,101,97,114,99,104,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.SearchContentStroke.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchFrame = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SearchFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.SearchFrame.BorderSizePixel = 0
_0xE3E8.SearchFrame.LayoutOrder = 1
_0xE3E8.SearchFrame.Name =string.char(83,101,97,114,99,104,70,114,97,109,101)_0xE3E8.SearchFrame.Size = UDim2.new(1, 0, 0, 30)
_0xE3E8.SearchFrame.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SearchFrameLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.SearchFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SearchFrameLayout.Padding = UDim.new(0, 2)
_0xE3E8.SearchFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SearchFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SearchFrameLayout.Parent = _0xE3E8.SearchFrame
_0xE3E8.SearchFrameSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.SearchFrameSizeCons.MaxSize = Vector2.new(2147483647, 30)
_0xE3E8.SearchFrameSizeCons.MinSize = Vector2.new(0, 30)
_0xE3E8.SearchFrameSizeCons.Parent = _0xE3E8.SearchFrame
_0xE3E8.SearchFrameCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SearchFrameCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SearchFrameCorner.Parent = _0xE3E8.SearchFrame
_0xE3E8.SearchFrameStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SearchFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SearchFrameStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.SearchFrameStroke.Parent = _0xE3E8.SearchFrame
_0xE3E8.SourceBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.SourceBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.SourceBtn.BorderSizePixel = 0
_0xE3E8.SourceBtn.FontFace = _0x340D
_0xE3E8.SourceBtn.LayoutOrder = 1
_0xE3E8.SourceBtn.Name =string.char(83,111,117,114,99,101,66,116,110)_0xE3E8.SourceBtn.Size = UDim2.new(0.24, 0, 1, 0)
_0xE3E8.SourceBtn.Text =string.char(239,191,189,239,191,189,32,83,111,117,114,99,101,58,32,82,83,99,114,105,112,116,115)_0xE3E8.SourceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SourceBtn.TextScaled = true
_0xE3E8.SourceBtn.TextWrapped = true
_0xE3E8.SourceBtn.Parent = _0xE3E8.SearchFrame
_0xE3E8.SourceBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SourceBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SourceBtnCorner.Parent = _0xE3E8.SourceBtn
_0xE3E8.SourceBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SourceBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SourceBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.SourceBtnStroke.Name =string.char(83,111,117,114,99,101,66,116,110,83,116,114,111,107,101)_0xE3E8.SourceBtnStroke.Parent = _0xE3E8.SourceBtn
_0xE3E8.SourceBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SourceBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.SourceBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.SourceBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.SourceBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.SourceBtnPadding.Parent = _0xE3E8.SourceBtn
_0xE3E8.SearchBox = Instance.new(string.char(84,101,120,116,66,111,120))
_0xE3E8.SearchBox.BackgroundTransparency = 1
_0xE3E8.SearchBox.BorderSizePixel = 0
_0xE3E8.SearchBox.FontFace = _0x1033
_0xE3E8.SearchBox.LayoutOrder = 2
_0xE3E8.SearchBox.Name =string.char(83,101,97,114,99,104,66,111,120)_0xE3E8.SearchBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SearchBox.PlaceholderText =string.char(83,101,97,114,99,104,32,102,111,114,32,115,99,114,105,112,116,115,46,46,46)_0xE3E8.SearchBox.Size = UDim2.new(0.52, 0, 1, 0)
_0xE3E8.SearchBox.Text =""_0xE3E8.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SearchBox.TextScaled = true
_0xE3E8.SearchBox.TextWrapped = true
_0xE3E8.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.SearchBox.Parent = _0xE3E8.SearchFrame
_0xE3E8.SearchBoxPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SearchBoxPadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.SearchBoxPadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.SearchBoxPadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.SearchBoxPadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.SearchBoxPadding.Parent = _0xE3E8.SearchBox
_0xE3E8.FilterBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.FilterBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.FilterBtn.BorderSizePixel = 0
_0xE3E8.FilterBtn.FontFace = _0x340D
_0xE3E8.FilterBtn.LayoutOrder = 3
_0xE3E8.FilterBtn.Name =string.char(70,105,108,116,101,114,66,116,110)_0xE3E8.FilterBtn.Size = UDim2.new(0.24, 0, 1, 0)
_0xE3E8.FilterBtn.Text =string.char(70,105,108,116,101,114,58,32,65,108,108)_0xE3E8.FilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.FilterBtn.TextScaled = true
_0xE3E8.FilterBtn.TextWrapped = true
_0xE3E8.FilterBtn.Parent = _0xE3E8.SearchFrame
_0xE3E8.FilterBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.FilterBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.FilterBtnCorner.Parent = _0xE3E8.FilterBtn
_0xE3E8.FilterBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.FilterBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.FilterBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.FilterBtnStroke.Name =string.char(70,105,108,116,101,114,66,116,110,83,116,114,111,107,101)_0xE3E8.FilterBtnStroke.Parent = _0xE3E8.FilterBtn
_0xE3E8.FilterBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.FilterBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.FilterBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.FilterBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.FilterBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.FilterBtnPadding.Parent = _0xE3E8.FilterBtn
_0xE3E8.SearchResults = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.SearchResults.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xE3E8.SearchResults.BackgroundTransparency = 1
_0xE3E8.SearchResults.BorderSizePixel = 0
_0xE3E8.SearchResults.LayoutOrder = 2
_0xE3E8.SearchResults.Name =string.char(83,101,97,114,99,104,82,101,115,117,108,116,115)_0xE3E8.SearchResults.ScrollBarThickness = 0
_0xE3E8.SearchResults.ScrollingDirection = Enum.ScrollingDirection.Y
_0xE3E8.SearchResults.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.SearchResults.Parent = _0xE3E8.SearchContent
_0xE3E8.SearchResultsPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SearchResultsPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.SearchResultsPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.SearchResultsPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.SearchResultsPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.SearchResultsPadding.Parent = _0xE3E8.SearchResults
_0xE3E8.SearchResultsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SearchResultsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SearchResultsLayout.Padding = UDim.new(0, 8)
_0xE3E8.SearchResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SearchResultsLayout.Parent = _0xE3E8.SearchResults
_0xE3E8.NoResultsLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.NoResultsLabel.BackgroundTransparency = 1
_0xE3E8.NoResultsLabel.BorderSizePixel = 0
_0xE3E8.NoResultsLabel.FontFace = _0x1033
_0xE3E8.NoResultsLabel.Name =string.char(78,111,82,101,115,117,108,116,115,76,97,98,101,108)_0xE3E8.NoResultsLabel.Size = UDim2.new(1, 0, 0, 30)
_0xE3E8.NoResultsLabel.Text =string.char(78,111,32,115,99,114,105,112,116,115,32,102,111,117,110,100,32,109,97,116,99,104,105,110,103,32,121,111,117,114,32,113,117,101,114,121,46)_0xE3E8.NoResultsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.NoResultsLabel.TextScaled = true
_0xE3E8.NoResultsLabel.TextWrapped = true
_0xE3E8.NoResultsLabel.Visible = false
_0xE3E8.NoResultsLabel.Parent = _0xE3E8.SearchResults
_0xE3E8.NoResultsLabelStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NoResultsLabelStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.NoResultsLabelStroke.Name =string.char(78,111,82,101,115,117,108,116,115,76,97,98,101,108,83,116,114,111,107,101)_0xE3E8.NoResultsLabelStroke.Parent = _0xE3E8.NoResultsLabel
_0xE3E8.SearchResultTemplate = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.SearchResultTemplate.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.SearchResultTemplate.BorderSizePixel = 0
_0xE3E8.SearchResultTemplate.Name =string.char(83,101,97,114,99,104,82,101,115,117,108,116,84,101,109,112,108,97,116,101)_0xE3E8.SearchResultTemplate.Size = UDim2.new(0, 358, 0, 132)
_0xE3E8.SearchResultTemplate.Visible = false
_0xE3E8.SearchResultTemplate.Parent = _0xE3E8.SearchResults
_0xE3E8.SearchResultTemplateCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SearchResultTemplateCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SearchResultTemplateCorner.Parent = _0xE3E8.SearchResultTemplate
_0xE3E8.SearchResultTemplateStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SearchResultTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SearchResultTemplateStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.SearchResultTemplateStroke.Name =string.char(83,101,97,114,99,104,82,101,115,117,108,116,84,101,109,112,108,97,116,101,83,116,114,111,107,101)_0xE3E8.SearchResultTemplateStroke.Parent = _0xE3E8.SearchResultTemplate
_0xE3E8.ScriptImage = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.ScriptImage.BackgroundTransparency = 1
_0xE3E8.ScriptImage.BorderSizePixel = 0
_0xE3E8.ScriptImage.LayoutOrder = 1
_0xE3E8.ScriptImage.Name =string.char(83,99,114,105,112,116,73,109,97,103,101)_0xE3E8.ScriptImage.ScaleType = Enum.ScaleType.Crop
_0xE3E8.ScriptImage.Size = UDim2.new(1, 0, 0.7, -2)
_0xE3E8.ScriptImage.Parent = _0xE3E8.SearchResultTemplate
_0xE3E8.Container = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Container.BackgroundTransparency = 1
_0xE3E8.Container.BorderSizePixel = 0
_0xE3E8.Container.LayoutOrder = 2
_0xE3E8.Container.Name =string.char(67,111,110,116,97,105,110,101,114)_0xE3E8.Container.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.Container.Parent = _0xE3E8.SearchResultTemplate
_0xE3E8.ScriptName = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.ScriptName.BackgroundTransparency = 1
_0xE3E8.ScriptName.BorderSizePixel = 0
_0xE3E8.ScriptName.FontFace = _0x1033
_0xE3E8.ScriptName.Name =string.char(83,99,114,105,112,116,78,97,109,101)_0xE3E8.ScriptName.Position = UDim2.new(0, 4, 0, 0)
_0xE3E8.ScriptName.Size = UDim2.new(0, 350, 0, 30)
_0xE3E8.ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.ScriptName.TextScaled = true
_0xE3E8.ScriptName.TextWrapped = true
_0xE3E8.ScriptName.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.ScriptName.Parent = _0xE3E8.Container
_0xE3E8.ScriptNameStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ScriptNameStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.ScriptNameStroke.Name =string.char(83,99,114,105,112,116,78,97,109,101,83,116,114,111,107,101)_0xE3E8.ScriptNameStroke.Parent = _0xE3E8.ScriptName
_0xE3E8.ScriptNameCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ScriptNameCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ScriptNameCorner.Parent = _0xE3E8.ScriptName
_0xE3E8.ScriptActions = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.ScriptActions.BackgroundTransparency = 1
_0xE3E8.ScriptActions.BorderSizePixel = 0
_0xE3E8.ScriptActions.Name =string.char(83,99,114,105,112,116,65,99,116,105,111,110,115)_0xE3E8.ScriptActions.Position = UDim2.new(0, 0, 0, 92)
_0xE3E8.ScriptActions.Size = UDim2.new(1, 0, 0.3, 0)
_0xE3E8.ScriptActions.Parent = _0xE3E8.Container
_0xE3E8.ScriptActionsPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ScriptActionsPadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.ScriptActionsPadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.ScriptActionsPadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.ScriptActionsPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.ScriptActionsPadding.Parent = _0xE3E8.ScriptActions
_0xE3E8.ScriptActionsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ScriptActionsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.ScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ScriptActionsLayout.Padding = UDim.new(0, 6)
_0xE3E8.ScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ScriptActionsLayout.Parent = _0xE3E8.ScriptActions
_0xE3E8.RunScript = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.RunScript.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.RunScript.BorderSizePixel = 0
_0xE3E8.RunScript.FontFace = _0x1033
_0xE3E8.RunScript.LayoutOrder = 1
_0xE3E8.RunScript.Name =string.char(82,117,110,83,99,114,105,112,116)_0xE3E8.RunScript.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.RunScript.Text =string.char(82,117,110)_0xE3E8.RunScript.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.RunScript.TextScaled = true
_0xE3E8.RunScript.TextWrapped = true
_0xE3E8.RunScript.Parent = _0xE3E8.ScriptActions
_0xE3E8.RunScriptStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.RunScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.RunScriptStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.RunScriptStroke.Name =string.char(82,117,110,83,99,114,105,112,116,83,116,114,111,107,101)_0xE3E8.RunScriptStroke.Parent = _0xE3E8.RunScript
_0xE3E8.RunScriptCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.RunScriptCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.RunScriptCorner.Parent = _0xE3E8.RunScript
_0xE3E8.RunScriptPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.RunScriptPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.RunScriptPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.RunScriptPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.RunScriptPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.RunScriptPadding.Parent = _0xE3E8.RunScript
_0xE3E8.CopyScriptBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.CopyScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.CopyScriptBtn.BorderSizePixel = 0
_0xE3E8.CopyScriptBtn.FontFace = _0x1033
_0xE3E8.CopyScriptBtn.LayoutOrder = 2
_0xE3E8.CopyScriptBtn.Name =string.char(67,111,112,121,83,99,114,105,112,116,66,116,110)_0xE3E8.CopyScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.CopyScriptBtn.Text =string.char(67,111,112,121)_0xE3E8.CopyScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.CopyScriptBtn.TextScaled = true
_0xE3E8.CopyScriptBtn.TextWrapped = true
_0xE3E8.CopyScriptBtn.Parent = _0xE3E8.ScriptActions
_0xE3E8.CopyScriptBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.CopyScriptBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.CopyScriptBtnCorner.Parent = _0xE3E8.CopyScriptBtn
_0xE3E8.CopyScriptBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.CopyScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.CopyScriptBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.CopyScriptBtnStroke.Name =string.char(67,111,112,121,83,99,114,105,112,116,66,116,110,83,116,114,111,107,101)_0xE3E8.CopyScriptBtnStroke.Parent = _0xE3E8.CopyScriptBtn
_0xE3E8.CopyScriptBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.CopyScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.CopyScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.CopyScriptBtnPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.CopyScriptBtnPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.CopyScriptBtnPadding.Parent = _0xE3E8.CopyScriptBtn
_0xE3E8.SaveScriptBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.SaveScriptBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.SaveScriptBtn.BorderSizePixel = 0
_0xE3E8.SaveScriptBtn.FontFace = _0x1033
_0xE3E8.SaveScriptBtn.LayoutOrder = 3
_0xE3E8.SaveScriptBtn.Name =string.char(83,97,118,101,83,99,114,105,112,116,66,116,110)_0xE3E8.SaveScriptBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.SaveScriptBtn.Text =string.char(83,97,118,101)_0xE3E8.SaveScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SaveScriptBtn.TextScaled = true
_0xE3E8.SaveScriptBtn.TextWrapped = true
_0xE3E8.SaveScriptBtn.Parent = _0xE3E8.ScriptActions
_0xE3E8.SaveScriptBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SaveScriptBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SaveScriptBtnCorner.Parent = _0xE3E8.SaveScriptBtn
_0xE3E8.SaveScriptBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SaveScriptBtnPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.SaveScriptBtnPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.SaveScriptBtnPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.SaveScriptBtnPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.SaveScriptBtnPadding.Parent = _0xE3E8.SaveScriptBtn
_0xE3E8.SaveScriptBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SaveScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SaveScriptBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.SaveScriptBtnStroke.Name =string.char(83,97,118,101,83,99,114,105,112,116,66,116,110,83,116,114,111,107,101)_0xE3E8.SaveScriptBtnStroke.Parent = _0xE3E8.SaveScriptBtn
_0xE3E8.PageButtons = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.PageButtons.BackgroundTransparency = 1
_0xE3E8.PageButtons.BorderSizePixel = 0
_0xE3E8.PageButtons.LayoutOrder = 3
_0xE3E8.PageButtons.Name =string.char(80,97,103,101,66,117,116,116,111,110,115)_0xE3E8.PageButtons.Size = UDim2.new(1, 0, 0, 38)
_0xE3E8.PageButtons.Parent = _0xE3E8.SearchContent
_0xE3E8.PageButtonsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.PageButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.PageButtonsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PageButtonsLayout.Padding = UDim.new(0, 6)
_0xE3E8.PageButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.PageButtonsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.PageButtonsLayout.Parent = _0xE3E8.PageButtons
_0xE3E8.PageButtonsSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.PageButtonsSizeCons.MaxSize = Vector2.new(2147483647, 38)
_0xE3E8.PageButtonsSizeCons.Parent = _0xE3E8.PageButtons
_0xE3E8.PrevBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.PrevBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.PrevBtn.BorderSizePixel = 0
_0xE3E8.PrevBtn.FontFace = _0x340D
_0xE3E8.PrevBtn.LayoutOrder = 1
_0xE3E8.PrevBtn.Name =string.char(80,114,101,118,66,116,110)_0xE3E8.PrevBtn.Size = UDim2.new(0.25, 0, 1, 0)
_0xE3E8.PrevBtn.Text =string.char(80,114,101,118,105,111,117,115)_0xE3E8.PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.PrevBtn.TextScaled = true
_0xE3E8.PrevBtn.TextWrapped = true
_0xE3E8.PrevBtn.Parent = _0xE3E8.PageButtons
_0xE3E8.PrevBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.PrevBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.PrevBtnCorner.Parent = _0xE3E8.PrevBtn
_0xE3E8.PrevBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.PrevBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.PrevBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.PrevBtnStroke.Name =string.char(80,114,101,118,66,116,110,83,116,114,111,107,101)_0xE3E8.PrevBtnStroke.Parent = _0xE3E8.PrevBtn
_0xE3E8.PrevBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.PrevBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.PrevBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.PrevBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.PrevBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.PrevBtnPadding.Parent = _0xE3E8.PrevBtn
_0xE3E8.PageFiller = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.PageFiller.BackgroundTransparency = 1
_0xE3E8.PageFiller.BorderSizePixel = 0
_0xE3E8.PageFiller.LayoutOrder = 2
_0xE3E8.PageFiller.Name =string.char(80,97,103,101,70,105,108,108,101,114)_0xE3E8.PageFiller.Size = UDim2.new(0.5, 0, 1, 0)
_0xE3E8.PageFiller.Parent = _0xE3E8.PageButtons
_0xE3E8.NextBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.NextBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.NextBtn.BorderSizePixel = 0
_0xE3E8.NextBtn.FontFace = _0x340D
_0xE3E8.NextBtn.LayoutOrder = 3
_0xE3E8.NextBtn.Name =string.char(78,101,120,116,66,116,110)_0xE3E8.NextBtn.Size = UDim2.new(0.25, 0, 1, 0)
_0xE3E8.NextBtn.Text =string.char(78,101,120,116)_0xE3E8.NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.NextBtn.TextScaled = true
_0xE3E8.NextBtn.TextWrapped = true
_0xE3E8.NextBtn.Parent = _0xE3E8.PageButtons
_0xE3E8.NextBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.NextBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.NextBtnCorner.Parent = _0xE3E8.NextBtn
_0xE3E8.NextBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NextBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.NextBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.NextBtnStroke.Name =string.char(78,101,120,116,66,116,110,83,116,114,111,107,101)_0xE3E8.NextBtnStroke.Parent = _0xE3E8.NextBtn
_0xE3E8.NextBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.NextBtnPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.NextBtnPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.NextBtnPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.NextBtnPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.NextBtnPadding.Parent = _0xE3E8.NextBtn
_0xE3E8.ScriptsContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.ScriptsContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.ScriptsContent.BorderSizePixel = 0
_0xE3E8.ScriptsContent.LayoutOrder = 3
_0xE3E8.ScriptsContent.Name =string.char(83,99,114,105,112,116,115,67,111,110,116,101,110,116)_0xE3E8.ScriptsContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.ScriptsContent.Visible = false
_0xE3E8.ScriptsContent.Parent = _0xE3E8.Pages
_0xE3E8.ScriptsContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ScriptsContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ScriptsContentCorner.Parent = _0xE3E8.ScriptsContent
_0xE3E8.ScriptsContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ScriptsContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ScriptsContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.ScriptsContentStroke.Name =string.char(83,99,114,105,112,116,115,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.ScriptsContentStroke.Parent = _0xE3E8.ScriptsContent
_0xE3E8.ScriptsContentLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ScriptsContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ScriptsContentLayout.Padding = UDim.new(0, 6)
_0xE3E8.ScriptsContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ScriptsContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ScriptsContentLayout.Parent = _0xE3E8.ScriptsContent
_0xE3E8.ScriptsContentPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ScriptsContentPadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.ScriptsContentPadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.ScriptsContentPadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.ScriptsContentPadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.ScriptsContentPadding.Parent = _0xE3E8.ScriptsContent
_0xE3E8.SavedScriptsSearchFrame = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SavedScriptsSearchFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.SavedScriptsSearchFrame.BorderSizePixel = 0
_0xE3E8.SavedScriptsSearchFrame.LayoutOrder = 1
_0xE3E8.SavedScriptsSearchFrame.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,115,83,101,97,114,99,104,70,114,97,109,101)_0xE3E8.SavedScriptsSearchFrame.Size = UDim2.new(1, 0, 0, 30)
_0xE3E8.SavedScriptsSearchFrame.Parent = _0xE3E8.ScriptsContent
_0xE3E8.SavedScriptsSearchFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SavedScriptsSearchFrameLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.SavedScriptsSearchFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptsSearchFrameLayout.Padding = UDim.new(0, 2)
_0xE3E8.SavedScriptsSearchFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SavedScriptsSearchFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptsSearchFrameLayout.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.SavedScriptsSearchFrameSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.SavedScriptsSearchFrameSizeCons.MaxSize = Vector2.new(2147483647, 30)
_0xE3E8.SavedScriptsSearchFrameSizeCons.MinSize = Vector2.new(0, 30)
_0xE3E8.SavedScriptsSearchFrameSizeCons.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.SavedScriptsSearchFrameCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SavedScriptsSearchFrameCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SavedScriptsSearchFrameCorner.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.SavedScriptsSearchFrameStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SavedScriptsSearchFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SavedScriptsSearchFrameStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.SavedScriptsSearchFrameStroke.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.SearchBox2 = Instance.new(string.char(84,101,120,116,66,111,120))
_0xE3E8.SearchBox2.BackgroundTransparency = 1
_0xE3E8.SearchBox2.BorderSizePixel = 0
_0xE3E8.SearchBox2.FontFace = _0x1033
_0xE3E8.SearchBox2.LayoutOrder = 1
_0xE3E8.SearchBox2.Name =string.char(83,101,97,114,99,104,66,111,120,50)_0xE3E8.SearchBox2.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SearchBox2.PlaceholderText =string.char(83,101,97,114,99,104,32,115,97,118,101,100,32,115,99,114,105,112,116,115,46,46,46)_0xE3E8.SearchBox2.Size = UDim2.new(0.95, 0, 1, 0)
_0xE3E8.SearchBox2.Text =""_0xE3E8.SearchBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SearchBox2.TextScaled = true
_0xE3E8.SearchBox2.TextWrapped = true
_0xE3E8.SearchBox2.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.SearchBox2.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.SearchBox2Padding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SearchBox2Padding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.SearchBox2Padding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.SearchBox2Padding.PaddingRight = UDim.new(0, 6)
_0xE3E8.SearchBox2Padding.PaddingTop = UDim.new(0, 6)
_0xE3E8.SearchBox2Padding.Parent = _0xE3E8.SearchBox2
_0xE3E8.NewScriptBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.NewScriptBtn.BackgroundTransparency = 1
_0xE3E8.NewScriptBtn.BorderSizePixel = 0
_0xE3E8.NewScriptBtn.FontFace = _0x1033
_0xE3E8.NewScriptBtn.LayoutOrder = 2
_0xE3E8.NewScriptBtn.Name =string.char(78,101,119,83,99,114,105,112,116,66,116,110)_0xE3E8.NewScriptBtn.Size = UDim2.new(0.05, 0, 1, 0)
_0xE3E8.NewScriptBtn.Text =string.char(43)_0xE3E8.NewScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.NewScriptBtn.TextScaled = true
_0xE3E8.NewScriptBtn.TextWrapped = true
_0xE3E8.NewScriptBtn.Parent = _0xE3E8.SavedScriptsSearchFrame
_0xE3E8.NewScriptBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NewScriptBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.NewScriptBtnStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.NewScriptBtnStroke.Parent = _0xE3E8.NewScriptBtn
_0xE3E8.NewScriptBtnRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.NewScriptBtnRatio.Parent = _0xE3E8.NewScriptBtn
_0xE3E8.NewScriptBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.NewScriptBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.NewScriptBtnCorner.Parent = _0xE3E8.NewScriptBtn
_0xE3E8.SavedScriptsScroll = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.SavedScriptsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xE3E8.SavedScriptsScroll.BackgroundTransparency = 1
_0xE3E8.SavedScriptsScroll.BorderSizePixel = 0
_0xE3E8.SavedScriptsScroll.LayoutOrder = 2
_0xE3E8.SavedScriptsScroll.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,115,83,99,114,111,108,108)_0xE3E8.SavedScriptsScroll.ScrollBarThickness = 0
_0xE3E8.SavedScriptsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
_0xE3E8.SavedScriptsScroll.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.SavedScriptsScroll.Parent = _0xE3E8.ScriptsContent
_0xE3E8.SavedScriptsScrollPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SavedScriptsScrollPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.SavedScriptsScrollPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.SavedScriptsScrollPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.SavedScriptsScrollPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.SavedScriptsScrollPadding.Parent = _0xE3E8.SavedScriptsScroll
_0xE3E8.SavedScriptsScrollLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SavedScriptsScrollLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptsScrollLayout.Padding = UDim.new(0, 8)
_0xE3E8.SavedScriptsScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SavedScriptsScrollLayout.Parent = _0xE3E8.SavedScriptsScroll
_0xE3E8.NoSavedScriptsLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.NoSavedScriptsLabel.BackgroundTransparency = 1
_0xE3E8.NoSavedScriptsLabel.BorderSizePixel = 0
_0xE3E8.NoSavedScriptsLabel.FontFace = _0x1033
_0xE3E8.NoSavedScriptsLabel.Name =string.char(78,111,83,97,118,101,100,83,99,114,105,112,116,115,76,97,98,101,108)_0xE3E8.NoSavedScriptsLabel.Size = UDim2.new(1, 0, 0, 60)
_0xE3E8.NoSavedScriptsLabel.Text =string.char(78,111,32,83,97,118,101,100,32,83,99,114,105,112,116,115,10,10,83,97,118,101,32,115,111,109,101,32,115,99,114,105,112,116,115,32,116,111,32,115,101,101,32,116,104,101,109,32,104,101,114,101,46)_0xE3E8.NoSavedScriptsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.NoSavedScriptsLabel.TextScaled = true
_0xE3E8.NoSavedScriptsLabel.TextWrapped = true
_0xE3E8.NoSavedScriptsLabel.Visible = false
_0xE3E8.NoSavedScriptsLabel.Parent = _0xE3E8.SavedScriptsScroll
_0xE3E8.NoSavedScriptsLabelStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NoSavedScriptsLabelStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.NoSavedScriptsLabelStroke.Name =string.char(78,111,83,97,118,101,100,83,99,114,105,112,116,115,76,97,98,101,108,83,116,114,111,107,101)_0xE3E8.NoSavedScriptsLabelStroke.Parent = _0xE3E8.NoSavedScriptsLabel
_0xE3E8.SavedScriptTemplate = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SavedScriptTemplate.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.SavedScriptTemplate.BorderSizePixel = 0
_0xE3E8.SavedScriptTemplate.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,84,101,109,112,108,97,116,101)_0xE3E8.SavedScriptTemplate.Size = UDim2.new(0, 166, 0, 64)
_0xE3E8.SavedScriptTemplate.Visible = false
_0xE3E8.SavedScriptTemplate.Parent = _0xE3E8.SavedScriptsScroll
_0xE3E8.SavedScriptTemplateCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SavedScriptTemplateCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SavedScriptTemplateCorner.Parent = _0xE3E8.SavedScriptTemplate
_0xE3E8.SavedScriptTemplateStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SavedScriptTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SavedScriptTemplateStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.SavedScriptTemplateStroke.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,84,101,109,112,108,97,116,101,83,116,114,111,107,101)_0xE3E8.SavedScriptTemplateStroke.Parent = _0xE3E8.SavedScriptTemplate
_0xE3E8.SavedScriptTemplateLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SavedScriptTemplateLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.SavedScriptTemplateLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptTemplateLayout.Padding = UDim.new(0, 2)
_0xE3E8.SavedScriptTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SavedScriptTemplateLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptTemplateLayout.Parent = _0xE3E8.SavedScriptTemplate
_0xE3E8.SavedScriptInfo = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SavedScriptInfo.BackgroundTransparency = 1
_0xE3E8.SavedScriptInfo.BorderSizePixel = 0
_0xE3E8.SavedScriptInfo.LayoutOrder = 1
_0xE3E8.SavedScriptInfo.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,73,110,102,111)_0xE3E8.SavedScriptInfo.Size = UDim2.new(0, 380, 0, 12)
_0xE3E8.SavedScriptInfo.Parent = _0xE3E8.SavedScriptTemplate
_0xE3E8.SavedScriptInfoPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SavedScriptInfoPadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.SavedScriptInfoPadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.SavedScriptInfoPadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.SavedScriptInfoPadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.SavedScriptInfoPadding.Parent = _0xE3E8.SavedScriptInfo
_0xE3E8.SavedScriptInfoLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SavedScriptInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptInfoLayout.Padding = UDim.new(0, 2)
_0xE3E8.SavedScriptInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SavedScriptInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptInfoLayout.Parent = _0xE3E8.SavedScriptInfo
_0xE3E8.SavedScriptTitle = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.SavedScriptTitle.BackgroundTransparency = 1
_0xE3E8.SavedScriptTitle.BorderSizePixel = 0
_0xE3E8.SavedScriptTitle.FontFace = _0x0EEB
_0xE3E8.SavedScriptTitle.LayoutOrder = 1
_0xE3E8.SavedScriptTitle.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,84,105,116,108,101)_0xE3E8.SavedScriptTitle.Size = UDim2.new(1, 0, 0.6, 0)
_0xE3E8.SavedScriptTitle.Text =string.char(83,99,114,105,112,116,32,110,97,109,101)_0xE3E8.SavedScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SavedScriptTitle.TextScaled = true
_0xE3E8.SavedScriptTitle.TextWrapped = true
_0xE3E8.SavedScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.SavedScriptTitle.Parent = _0xE3E8.SavedScriptInfo
_0xE3E8.SavedScriptDesc = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.SavedScriptDesc.BackgroundTransparency = 1
_0xE3E8.SavedScriptDesc.BorderSizePixel = 0
_0xE3E8.SavedScriptDesc.FontFace = _0x1033
_0xE3E8.SavedScriptDesc.LayoutOrder = 2
_0xE3E8.SavedScriptDesc.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,68,101,115,99)_0xE3E8.SavedScriptDesc.Size = UDim2.new(1, 0, 0.4, 0)
_0xE3E8.SavedScriptDesc.Text =string.char(83,99,114,105,112,116,32,100,101,115,99,114,105,112,116,105,111,110)_0xE3E8.SavedScriptDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.SavedScriptDesc.TextScaled = true
_0xE3E8.SavedScriptDesc.TextWrapped = true
_0xE3E8.SavedScriptDesc.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.SavedScriptDesc.Parent = _0xE3E8.SavedScriptInfo
_0xE3E8.SavedScriptActions = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SavedScriptActions.BackgroundTransparency = 1
_0xE3E8.SavedScriptActions.BorderSizePixel = 0
_0xE3E8.SavedScriptActions.LayoutOrder = 2
_0xE3E8.SavedScriptActions.Name =string.char(83,97,118,101,100,83,99,114,105,112,116,65,99,116,105,111,110,115)_0xE3E8.SavedScriptActions.Size = UDim2.new(0, 0, 0, 12)
_0xE3E8.SavedScriptActions.Parent = _0xE3E8.SavedScriptTemplate
_0xE3E8.SavedScriptActionsPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SavedScriptActionsPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.SavedScriptActionsPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.SavedScriptActionsPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.SavedScriptActionsPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.SavedScriptActionsPadding.Parent = _0xE3E8.SavedScriptActions
_0xE3E8.SavedScriptActionsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SavedScriptActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptActionsLayout.Padding = UDim.new(0, 6)
_0xE3E8.SavedScriptActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SavedScriptActionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SavedScriptActionsLayout.Parent = _0xE3E8.SavedScriptActions
_0xE3E8.RunSavedScript = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.RunSavedScript.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.RunSavedScript.BorderSizePixel = 0
_0xE3E8.RunSavedScript.FontFace = _0x1033
_0xE3E8.RunSavedScript.LayoutOrder = 1
_0xE3E8.RunSavedScript.Name =string.char(82,117,110,83,97,118,101,100,83,99,114,105,112,116)_0xE3E8.RunSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.RunSavedScript.Text =string.char(82,117,110)_0xE3E8.RunSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.RunSavedScript.TextScaled = true
_0xE3E8.RunSavedScript.TextWrapped = true
_0xE3E8.RunSavedScript.Parent = _0xE3E8.SavedScriptActions
_0xE3E8.RunSavedScriptStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.RunSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.RunSavedScriptStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.RunSavedScriptStroke.Name =string.char(82,117,110,83,97,118,101,100,83,99,114,105,112,116,83,116,114,111,107,101)_0xE3E8.RunSavedScriptStroke.Parent = _0xE3E8.RunSavedScript
_0xE3E8.RunSavedScriptCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.RunSavedScriptCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.RunSavedScriptCorner.Parent = _0xE3E8.RunSavedScript
_0xE3E8.RunSavedScriptPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.RunSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.RunSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.RunSavedScriptPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.RunSavedScriptPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.RunSavedScriptPadding.Parent = _0xE3E8.RunSavedScript
_0xE3E8.DeleteSavedScript = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.DeleteSavedScript.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.DeleteSavedScript.BorderSizePixel = 0
_0xE3E8.DeleteSavedScript.FontFace = _0x1033
_0xE3E8.DeleteSavedScript.LayoutOrder = 2
_0xE3E8.DeleteSavedScript.Name =string.char(68,101,108,101,116,101,83,97,118,101,100,83,99,114,105,112,116)_0xE3E8.DeleteSavedScript.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.DeleteSavedScript.Text =string.char(68,101,108,101,116,101)_0xE3E8.DeleteSavedScript.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.DeleteSavedScript.TextScaled = true
_0xE3E8.DeleteSavedScript.TextWrapped = true
_0xE3E8.DeleteSavedScript.Parent = _0xE3E8.SavedScriptActions
_0xE3E8.DeleteSavedScriptCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.DeleteSavedScriptCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.DeleteSavedScriptCorner.Parent = _0xE3E8.DeleteSavedScript
_0xE3E8.DeleteSavedScriptStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.DeleteSavedScriptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.DeleteSavedScriptStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.DeleteSavedScriptStroke.Name =string.char(68,101,108,101,116,101,83,97,118,101,100,83,99,114,105,112,116,83,116,114,111,107,101)_0xE3E8.DeleteSavedScriptStroke.Parent = _0xE3E8.DeleteSavedScript
_0xE3E8.DeleteSavedScriptPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.DeleteSavedScriptPadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.DeleteSavedScriptPadding.PaddingLeft = UDim.new(0, 2)
_0xE3E8.DeleteSavedScriptPadding.PaddingRight = UDim.new(0, 2)
_0xE3E8.DeleteSavedScriptPadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.DeleteSavedScriptPadding.Parent = _0xE3E8.DeleteSavedScript
_0xE3E8.MusicContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.MusicContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.MusicContent.BorderSizePixel = 0
_0xE3E8.MusicContent.LayoutOrder = 5
_0xE3E8.MusicContent.Name =string.char(77,117,115,105,99,67,111,110,116,101,110,116)_0xE3E8.MusicContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.MusicContent.Visible = false
_0xE3E8.MusicContent.Parent = _0xE3E8.Pages
_0xE3E8.MusicContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.MusicContentCorner.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.MusicContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicContentStroke.Name =string.char(77,117,115,105,99,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.MusicContentStroke.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicContentLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MusicContentLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicContentLayout.Padding = UDim.new(0, 6)
_0xE3E8.MusicContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MusicContentLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicContentLayout.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicContentPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.MusicContentPadding.PaddingBottom = UDim.new(0, 8)
_0xE3E8.MusicContentPadding.PaddingLeft = UDim.new(0, 8)
_0xE3E8.MusicContentPadding.PaddingRight = UDim.new(0, 8)
_0xE3E8.MusicContentPadding.PaddingTop = UDim.new(0, 8)
_0xE3E8.MusicContentPadding.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicNowPlaying = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.MusicNowPlaying.AutomaticSize = Enum.AutomaticSize.Y
_0xE3E8.MusicNowPlaying.BackgroundTransparency = 1
_0xE3E8.MusicNowPlaying.BorderSizePixel = 0
_0xE3E8.MusicNowPlaying.FontFace = _0x0EEB
_0xE3E8.MusicNowPlaying.LayoutOrder = 1
_0xE3E8.MusicNowPlaying.Name =string.char(77,117,115,105,99,78,111,119,80,108,97,121,105,110,103)_0xE3E8.MusicNowPlaying.Size = UDim2.new(1, 0, 0, 24)
_0xE3E8.MusicNowPlaying.Text =string.char(78,111,32,115,111,110,103,32,112,108,97,121,105,110,103)_0xE3E8.MusicNowPlaying.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.MusicNowPlaying.TextScaled = false
_0xE3E8.MusicNowPlaying.TextSize = 24
_0xE3E8.MusicNowPlaying.TextWrapped = true
_0xE3E8.MusicNowPlaying.TextXAlignment = Enum.TextXAlignment.Center
_0xE3E8.MusicNowPlaying.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicNowPlayingStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicNowPlayingStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.MusicNowPlayingStroke.Parent = _0xE3E8.MusicNowPlaying
_0xE3E8.MusicSliderArea = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicSliderArea.BackgroundTransparency = 1
_0xE3E8.MusicSliderArea.BorderSizePixel = 0
_0xE3E8.MusicSliderArea.LayoutOrder = 2
_0xE3E8.MusicSliderArea.Name =string.char(77,117,115,105,99,83,108,105,100,101,114,65,114,101,97)_0xE3E8.MusicSliderArea.Size = UDim2.new(1, 0, 0, 20)
_0xE3E8.MusicSliderArea.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicSliderAreaSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.MusicSliderAreaSizeCons.MaxSize = Vector2.new(2147483647, 20)
_0xE3E8.MusicSliderAreaSizeCons.Parent = _0xE3E8.MusicSliderArea
_0xE3E8.MusicSliderBar = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicSliderBar.AnchorPoint = Vector2.new(0, 0.5)
_0xE3E8.MusicSliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_0xE3E8.MusicSliderBar.BorderSizePixel = 0
_0xE3E8.MusicSliderBar.Name =string.char(77,117,115,105,99,83,108,105,100,101,114,66,97,114)_0xE3E8.MusicSliderBar.Position = UDim2.new(0, 0, 0.5, 0)
_0xE3E8.MusicSliderBar.Size = UDim2.new(1, 0, 0, 6)
_0xE3E8.MusicSliderBar.Parent = _0xE3E8.MusicSliderArea
_0xE3E8.MusicSliderBarCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicSliderBarCorner.CornerRadius = UDim.new(0, 3)
_0xE3E8.MusicSliderBarCorner.Parent = _0xE3E8.MusicSliderBar
_0xE3E8.MusicSliderFill = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicSliderFill.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicSliderFill.BorderSizePixel = 0
_0xE3E8.MusicSliderFill.Name =string.char(77,117,115,105,99,83,108,105,100,101,114,70,105,108,108)_0xE3E8.MusicSliderFill.Size = UDim2.new(0, 0, 1, 0)
_0xE3E8.MusicSliderFill.Parent = _0xE3E8.MusicSliderBar
_0xE3E8.MusicSliderFillCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicSliderFillCorner.CornerRadius = UDim.new(0, 3)
_0xE3E8.MusicSliderFillCorner.Parent = _0xE3E8.MusicSliderFill
_0xE3E8.MusicSliderKnob = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicSliderKnob.AnchorPoint = Vector2.new(0, 0)
_0xE3E8.MusicSliderKnob.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicSliderKnob.BorderSizePixel = 0
_0xE3E8.MusicSliderKnob.Name =string.char(77,117,115,105,99,83,108,105,100,101,114,75,110,111,98)_0xE3E8.MusicSliderKnob.Position = UDim2.new(0, -6, 0.5, -6)
_0xE3E8.MusicSliderKnob.Size = UDim2.new(0, 12, 0, 12)
_0xE3E8.MusicSliderKnob.Parent = _0xE3E8.MusicSliderBar
_0xE3E8.MusicSliderKnobCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicSliderKnobCorner.CornerRadius = UDim.new(1, 0)
_0xE3E8.MusicSliderKnobCorner.Parent = _0xE3E8.MusicSliderKnob
_0xE3E8.MusicTimeLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.MusicTimeLabel.BackgroundTransparency = 1
_0xE3E8.MusicTimeLabel.BorderSizePixel = 0
_0xE3E8.MusicTimeLabel.FontFace = _0x1033
_0xE3E8.MusicTimeLabel.LayoutOrder = 3
_0xE3E8.MusicTimeLabel.Name =string.char(77,117,115,105,99,84,105,109,101,76,97,98,101,108)_0xE3E8.MusicTimeLabel.Size = UDim2.new(1, 0, 0, 16)
_0xE3E8.MusicTimeLabel.Text =string.char(48,58,48,48,32,47,32,48,58,48,48)_0xE3E8.MusicTimeLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
_0xE3E8.MusicTimeLabel.TextScaled = true
_0xE3E8.MusicTimeLabel.TextXAlignment = Enum.TextXAlignment.Center
_0xE3E8.MusicTimeLabel.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicTimeLabelSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.MusicTimeLabelSizeCons.MaxSize = Vector2.new(2147483647, 16)
_0xE3E8.MusicTimeLabelSizeCons.Parent = _0xE3E8.MusicTimeLabel
_0xE3E8.MusicControls = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicControls.BackgroundTransparency = 1
_0xE3E8.MusicControls.BorderSizePixel = 0
_0xE3E8.MusicControls.LayoutOrder = 4
_0xE3E8.MusicControls.Name =string.char(77,117,115,105,99,67,111,110,116,114,111,108,115)_0xE3E8.MusicControls.Size = UDim2.new(1, 0, 0, 36)
_0xE3E8.MusicControls.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicControlsSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.MusicControlsSizeCons.MaxSize = Vector2.new(2147483647, 36)
_0xE3E8.MusicControlsSizeCons.Parent = _0xE3E8.MusicControls
_0xE3E8.MusicControlsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MusicControlsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.MusicControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
_0xE3E8.MusicControlsLayout.Padding = UDim.new(0, 8)
_0xE3E8.MusicControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MusicControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
_0xE3E8.MusicControlsLayout.Parent = _0xE3E8.MusicControls
_0xE3E8.MusicPrevBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.MusicPrevBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicPrevBtn.BorderSizePixel = 0
_0xE3E8.MusicPrevBtn.FontFace = _0x0EEB
_0xE3E8.MusicPrevBtn.LayoutOrder = 1
_0xE3E8.MusicPrevBtn.Name =string.char(77,117,115,105,99,80,114,101,118,66,116,110)_0xE3E8.MusicPrevBtn.Size = UDim2.new(0, 60, 1, 0)
_0xE3E8.MusicPrevBtn.Text =string.char(226,143,174)_0xE3E8.MusicPrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.MusicPrevBtn.TextScaled = true
_0xE3E8.MusicPrevBtn.Parent = _0xE3E8.MusicControls
_0xE3E8.MusicPrevBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicPrevBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.MusicPrevBtnCorner.Parent = _0xE3E8.MusicPrevBtn
_0xE3E8.MusicPrevBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicPrevBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.MusicPrevBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.MusicPrevBtnStroke.Name =string.char(77,117,115,105,99,80,114,101,118,66,116,110,83,116,114,111,107,101)_0xE3E8.MusicPrevBtnStroke.Parent = _0xE3E8.MusicPrevBtn
_0xE3E8.MusicPlayBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.MusicPlayBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicPlayBtn.BorderSizePixel = 0
_0xE3E8.MusicPlayBtn.FontFace = _0x0EEB
_0xE3E8.MusicPlayBtn.LayoutOrder = 2
_0xE3E8.MusicPlayBtn.Name =string.char(77,117,115,105,99,80,108,97,121,66,116,110)_0xE3E8.MusicPlayBtn.Size = UDim2.new(0, 80, 1, 0)
_0xE3E8.MusicPlayBtn.Text =string.char(226,150,182)_0xE3E8.MusicPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.MusicPlayBtn.TextScaled = true
_0xE3E8.MusicPlayBtn.Parent = _0xE3E8.MusicControls
_0xE3E8.MusicPlayBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicPlayBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.MusicPlayBtnCorner.Parent = _0xE3E8.MusicPlayBtn
_0xE3E8.MusicPlayBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicPlayBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.MusicPlayBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.MusicPlayBtnStroke.Name =string.char(77,117,115,105,99,80,108,97,121,66,116,110,83,116,114,111,107,101)_0xE3E8.MusicPlayBtnStroke.Parent = _0xE3E8.MusicPlayBtn
_0xE3E8.MusicNextBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.MusicNextBtn.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.MusicNextBtn.BorderSizePixel = 0
_0xE3E8.MusicNextBtn.FontFace = _0x0EEB
_0xE3E8.MusicNextBtn.LayoutOrder = 3
_0xE3E8.MusicNextBtn.Name =string.char(77,117,115,105,99,78,101,120,116,66,116,110)_0xE3E8.MusicNextBtn.Size = UDim2.new(0, 60, 1, 0)
_0xE3E8.MusicNextBtn.Text =string.char(226,143,173)_0xE3E8.MusicNextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.MusicNextBtn.TextScaled = true
_0xE3E8.MusicNextBtn.Parent = _0xE3E8.MusicControls
_0xE3E8.MusicNextBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicNextBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.MusicNextBtnCorner.Parent = _0xE3E8.MusicNextBtn
_0xE3E8.MusicNextBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicNextBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.MusicNextBtnStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.MusicNextBtnStroke.Name =string.char(77,117,115,105,99,78,101,120,116,66,116,110,83,116,114,111,107,101)_0xE3E8.MusicNextBtnStroke.Parent = _0xE3E8.MusicNextBtn
_0xE3E8.MusicSettingsFrame = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicSettingsFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.MusicSettingsFrame.BorderSizePixel = 0
_0xE3E8.MusicSettingsFrame.LayoutOrder = 5
_0xE3E8.MusicSettingsFrame.Name =string.char(77,117,115,105,99,83,101,116,116,105,110,103,115,70,114,97,109,101)_0xE3E8.MusicSettingsFrame.Size = UDim2.new(1, 0, 0, 70)
_0xE3E8.MusicSettingsFrame.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicSettingsFrameSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.MusicSettingsFrameSizeCons.MaxSize = Vector2.new(2147483647, 70)
_0xE3E8.MusicSettingsFrameSizeCons.Parent = _0xE3E8.MusicSettingsFrame
_0xE3E8.MusicSettingsFrameCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicSettingsFrameCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.MusicSettingsFrameCorner.Parent = _0xE3E8.MusicSettingsFrame
_0xE3E8.MusicSettingsFrameStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicSettingsFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.MusicSettingsFrameStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.MusicSettingsFrameStroke.Parent = _0xE3E8.MusicSettingsFrame
_0xE3E8.MusicSettingsFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MusicSettingsFrameLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.MusicSettingsFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicSettingsFrameLayout.Padding = UDim.new(0, 8)
_0xE3E8.MusicSettingsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MusicSettingsFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicSettingsFrameLayout.Parent = _0xE3E8.MusicSettingsFrame
_0xE3E8.MusicSettingsFramePadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.MusicSettingsFramePadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.MusicSettingsFramePadding.PaddingLeft = UDim.new(0, 10)
_0xE3E8.MusicSettingsFramePadding.PaddingRight = UDim.new(0, 10)
_0xE3E8.MusicSettingsFramePadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.MusicSettingsFramePadding.Parent = _0xE3E8.MusicSettingsFrame
local function _0x844C(labelText, defaultVal, layoutOrder, _0x1671)
local _0xE617 = Instance.new(string.char(70,114,97,109,101))
_0xE617.BackgroundTransparency = 1
_0xE617.BorderSizePixel = 0
_0xE617.LayoutOrder = layoutOrder
_0xE617.Name = _0x1671 ..string.char(67,111,108)_0xE617.Size = UDim2.new(0.28, 0, 1, 0)
_0xE617.Parent = _0xE3E8.MusicSettingsFrame
local _0x5D01 = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0x5D01.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0x5D01.Padding = UDim.new(0, 2)
_0x5D01.SortOrder = Enum.SortOrder.LayoutOrder
_0x5D01.VerticalFlex = Enum.UIFlexAlignment.Fill
_0x5D01.Parent = _0xE617
local _0x4D5B = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x4D5B.BackgroundTransparency = 1
_0x4D5B.BorderSizePixel = 0
_0x4D5B.FontFace = _0x1033
_0x4D5B.LayoutOrder = 1
_0x4D5B.Size = UDim2.new(1, 0, 0.5, 0)
_0x4D5B.Text = labelText
_0x4D5B.TextColor3 = Color3.fromRGB(180, 180, 180)
_0x4D5B.TextScaled = true
_0x4D5B.Parent = _0xE617
local _0x46F9 = Instance.new(string.char(84,101,120,116,66,111,120))
_0x46F9.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
_0x46F9.BorderSizePixel = 0
_0x46F9.FontFace = _0x1033
_0x46F9.LayoutOrder = 2
_0x46F9.Name = _0x1671 ..string.char(66,111,120)_0x46F9.Size = UDim2.new(1, 0, 0.5, 0)
_0x46F9.Text = defaultVal
_0x46F9.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x46F9.TextScaled = true
_0x46F9.Parent = _0xE617
local _0xE1AF = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE1AF.CornerRadius = UDim.new(0, 4)
_0xE1AF.Parent = _0x46F9
local _0xAF31 = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xAF31.Color = Color3.fromRGB(36, 36, 36)
_0xAF31.Parent = _0x46F9
_0xE3E8[_0x1671 ..string.char(66,111,120)] = _0x46F9
return _0x46F9
end
_0x844C(string.char(86,111,108,117,109,101),string.char(49), 1,string.char(77,117,115,105,99,86,111,108,117,109,101))
_0x844C(string.char(83,112,101,101,100),string.char(49), 2,string.char(77,117,115,105,99,83,112,101,101,100))
_0xE3E8.MusicLoopCol = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicLoopCol.BackgroundTransparency = 1
_0xE3E8.MusicLoopCol.BorderSizePixel = 0
_0xE3E8.MusicLoopCol.LayoutOrder = 3
_0xE3E8.MusicLoopCol.Name =string.char(77,117,115,105,99,76,111,111,112,67,111,108)_0xE3E8.MusicLoopCol.Size = UDim2.new(0.28, 0, 1, 0)
_0xE3E8.MusicLoopCol.Parent = _0xE3E8.MusicSettingsFrame
_0xE3E8.MusicLoopColLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MusicLoopColLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicLoopColLayout.Padding = UDim.new(0, 2)
_0xE3E8.MusicLoopColLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MusicLoopColLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicLoopColLayout.Parent = _0xE3E8.MusicLoopCol
_0xE3E8.MusicLoopLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.MusicLoopLabel.BackgroundTransparency = 1
_0xE3E8.MusicLoopLabel.BorderSizePixel = 0
_0xE3E8.MusicLoopLabel.FontFace = _0x1033
_0xE3E8.MusicLoopLabel.LayoutOrder = 1
_0xE3E8.MusicLoopLabel.Size = UDim2.new(1, 0, 0.5, 0)
_0xE3E8.MusicLoopLabel.Text =string.char(76,111,111,112)_0xE3E8.MusicLoopLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
_0xE3E8.MusicLoopLabel.TextScaled = true
_0xE3E8.MusicLoopLabel.Parent = _0xE3E8.MusicLoopCol
_0xE3E8.MusicLoopToggle = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.MusicLoopToggle.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
_0xE3E8.MusicLoopToggle.BorderSizePixel = 0
_0xE3E8.MusicLoopToggle.FontFace = _0x1033
_0xE3E8.MusicLoopToggle.LayoutOrder = 2
_0xE3E8.MusicLoopToggle.Name =string.char(77,117,115,105,99,76,111,111,112,84,111,103,103,108,101)_0xE3E8.MusicLoopToggle.Size = UDim2.new(1, 0, 0.5, 0)
_0xE3E8.MusicLoopToggle.Text =""_0xE3E8.MusicLoopToggle.Parent = _0xE3E8.MusicLoopCol
_0xE3E8.MusicLoopToggleCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicLoopToggleCorner.CornerRadius = UDim.new(0, 4)
_0xE3E8.MusicLoopToggleCorner.Parent = _0xE3E8.MusicLoopToggle
_0xE3E8.MusicLoopToggleStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.MusicLoopToggleStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.MusicLoopToggleStroke.Parent = _0xE3E8.MusicLoopToggle
_0xE3E8.MusicLoopState = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.MusicLoopState.AnchorPoint = Vector2.new(0.5, 0.5)
_0xE3E8.MusicLoopState.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
_0xE3E8.MusicLoopState.BorderSizePixel = 0
_0xE3E8.MusicLoopState.Name =string.char(76,111,111,112,83,116,97,116,101)_0xE3E8.MusicLoopState.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xE3E8.MusicLoopState.Size = UDim2.new(0.7, 0, 0.6, 0)
_0xE3E8.MusicLoopState.Parent = _0xE3E8.MusicLoopToggle
_0xE3E8.MusicLoopStateCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.MusicLoopStateCorner.CornerRadius = UDim.new(0, 4)
_0xE3E8.MusicLoopStateCorner.Parent = _0xE3E8.MusicLoopState
_0xE3E8.MusicListScroll = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.MusicListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xE3E8.MusicListScroll.BackgroundTransparency = 1
_0xE3E8.MusicListScroll.BorderSizePixel = 0
_0xE3E8.MusicListScroll.LayoutOrder = 6
_0xE3E8.MusicListScroll.Name =string.char(77,117,115,105,99,76,105,115,116,83,99,114,111,108,108)_0xE3E8.MusicListScroll.ScrollBarThickness = 4
_0xE3E8.MusicListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
_0xE3E8.MusicListScroll.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.MusicListScroll.Parent = _0xE3E8.MusicContent
_0xE3E8.MusicListLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.MusicListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.MusicListLayout.Name =string.char(77,117,115,105,99,76,105,115,116,76,97,121,111,117,116)_0xE3E8.MusicListLayout.Padding = UDim.new(0, 4)
_0xE3E8.MusicListLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.MusicListLayout.Parent = _0xE3E8.MusicListScroll
_0xE3E8.MusicListPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.MusicListPadding.Name =string.char(77,117,115,105,99,76,105,115,116,80,97,100,100,105,110,103)_0xE3E8.MusicListPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.MusicListPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.MusicListPadding.Parent = _0xE3E8.MusicListScroll
_0xE3E8.NoMusicLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.NoMusicLabel.BackgroundTransparency = 1
_0xE3E8.NoMusicLabel.BorderSizePixel = 0
_0xE3E8.NoMusicLabel.FontFace = _0x1033
_0xE3E8.NoMusicLabel.Name =string.char(78,111,77,117,115,105,99,76,97,98,101,108)_0xE3E8.NoMusicLabel.Size = UDim2.new(1, 0, 0, 60)
_0xE3E8.NoMusicLabel.Text =string.char(78,111,32,109,117,115,105,99,32,102,111,117,110,100,46,10,10,80,108,97,99,101,32,97,117,100,105,111,32,102,105,108,101,115,32,105,110,32,76,117,99,105,100,47,77,117,115,105,99,47)_0xE3E8.NoMusicLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
_0xE3E8.NoMusicLabel.TextScaled = true
_0xE3E8.NoMusicLabel.TextWrapped = true
_0xE3E8.NoMusicLabel.Visible = false
_0xE3E8.NoMusicLabel.Parent = _0xE3E8.MusicListScroll
_0xE3E8.SettingsContent = Instance.new(string.char(67,97,110,118,97,115,71,114,111,117,112))
_0xE3E8.SettingsContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.SettingsContent.BorderSizePixel = 0
_0xE3E8.SettingsContent.LayoutOrder = 1
_0xE3E8.SettingsContent.Name =string.char(83,101,116,116,105,110,103,115,67,111,110,116,101,110,116)_0xE3E8.SettingsContent.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.SettingsContent.Visible = false
_0xE3E8.SettingsContent.Parent = _0xE3E8.Pages
_0xE3E8.SettingsContentCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SettingsContentCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SettingsContentCorner.Parent = _0xE3E8.SettingsContent
_0xE3E8.SettingsContentStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SettingsContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SettingsContentStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.SettingsContentStroke.Name =string.char(83,101,116,116,105,110,103,115,67,111,110,116,101,110,116,83,116,114,111,107,101)_0xE3E8.SettingsContentStroke.Parent = _0xE3E8.SettingsContent
_0xE3E8.SettingsFrame = Instance.new(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
_0xE3E8.SettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
_0xE3E8.SettingsFrame.BackgroundTransparency = 1
_0xE3E8.SettingsFrame.BorderSizePixel = 0
_0xE3E8.SettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
_0xE3E8.SettingsFrame.Name =string.char(83,101,116,116,105,110,103,115,70,114,97,109,101)_0xE3E8.SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
_0xE3E8.SettingsFrame.Parent = _0xE3E8.SettingsContent
_0xE3E8.SettingsFramePadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SettingsFramePadding.PaddingBottom = UDim.new(0, 5)
_0xE3E8.SettingsFramePadding.PaddingLeft = UDim.new(0, 5)
_0xE3E8.SettingsFramePadding.PaddingRight = UDim.new(0, 5)
_0xE3E8.SettingsFramePadding.PaddingTop = UDim.new(0, 5)
_0xE3E8.SettingsFramePadding.Parent = _0xE3E8.SettingsFrame
_0xE3E8.SettingsFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SettingsFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SettingsFrameLayout.Padding = UDim.new(0, 6)
_0xE3E8.SettingsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SettingsFrameLayout.Parent = _0xE3E8.SettingsFrame
_0xE3E8.AnimsToggle = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.AnimsToggle.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.AnimsToggle.BorderSizePixel = 0
_0xE3E8.AnimsToggle.LayoutOrder = 1
_0xE3E8.AnimsToggle.Name =string.char(65,110,105,109,115,84,111,103,103,108,101)_0xE3E8.AnimsToggle.Size = UDim2.new(1, 0, 0, 38)
_0xE3E8.AnimsToggle.Text =""_0xE3E8.AnimsToggle.Parent = _0xE3E8.SettingsFrame
_0xE3E8.AnimsToggleCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.AnimsToggleCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.AnimsToggleCorner.Parent = _0xE3E8.AnimsToggle
_0xE3E8.AnimsToggleStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.AnimsToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.AnimsToggleStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.AnimsToggleStroke.Parent = _0xE3E8.AnimsToggle
_0xE3E8.AnimsTogglePadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.AnimsTogglePadding.PaddingBottom = UDim.new(0, 8)
_0xE3E8.AnimsTogglePadding.PaddingLeft = UDim.new(0, 8)
_0xE3E8.AnimsTogglePadding.PaddingRight = UDim.new(0, 8)
_0xE3E8.AnimsTogglePadding.PaddingTop = UDim.new(0, 8)
_0xE3E8.AnimsTogglePadding.Parent = _0xE3E8.AnimsToggle
_0xE3E8.AnimsToggleLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.AnimsToggleLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.AnimsToggleLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.AnimsToggleLayout.Padding = UDim.new(0, 6)
_0xE3E8.AnimsToggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.AnimsToggleLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.AnimsToggleLayout.Parent = _0xE3E8.AnimsToggle
_0xE3E8.AnimsToggleLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.AnimsToggleLabel.BackgroundTransparency = 1
_0xE3E8.AnimsToggleLabel.BorderSizePixel = 0
_0xE3E8.AnimsToggleLabel.FontFace = _0x1033
_0xE3E8.AnimsToggleLabel.LayoutOrder = 1
_0xE3E8.AnimsToggleLabel.Name =string.char(65,110,105,109,115,84,111,103,103,108,101,76,97,98,101,108)_0xE3E8.AnimsToggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
_0xE3E8.AnimsToggleLabel.Text =string.char(65,110,105,109,97,116,105,111,110,115)_0xE3E8.AnimsToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.AnimsToggleLabel.TextScaled = true
_0xE3E8.AnimsToggleLabel.TextWrapped = true
_0xE3E8.AnimsToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.AnimsToggleLabel.Parent = _0xE3E8.AnimsToggle
_0xE3E8.ToggleState = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.ToggleState.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
_0xE3E8.ToggleState.BorderSizePixel = 0
_0xE3E8.ToggleState.LayoutOrder = 2
_0xE3E8.ToggleState.Name =string.char(84,111,103,103,108,101,83,116,97,116,101)_0xE3E8.ToggleState.Size = UDim2.new(0.2, 0, 0.6, 0)
_0xE3E8.ToggleState.Parent = _0xE3E8.AnimsToggle
_0xE3E8.ToggleStateCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ToggleStateCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ToggleStateCorner.Parent = _0xE3E8.ToggleState
_0xE3E8.ToggleStateRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.ToggleStateRatio.Parent = _0xE3E8.ToggleState
_0xE3E8.ToggleStateStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ToggleStateStroke.Color = Color3.fromRGB(255, 0, 0)
_0xE3E8.ToggleStateStroke.Transparency = 0.5
_0xE3E8.ToggleStateStroke.Parent = _0xE3E8.ToggleState
_0xE3E8.SidebarContainer = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.SidebarContainer.BackgroundTransparency = 1
_0xE3E8.SidebarContainer.BorderSizePixel = 0
_0xE3E8.SidebarContainer.LayoutOrder = 2
_0xE3E8.SidebarContainer.Name =string.char(83,105,100,101,98,97,114,67,111,110,116,97,105,110,101,114)_0xE3E8.SidebarContainer.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.SidebarContainer.Parent = _0xE3E8.MainFrame
_0xE3E8.Sidebar = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Sidebar.AnchorPoint = Vector2.new(1, 0.5)
_0xE3E8.Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
_0xE3E8.Sidebar.BorderSizePixel = 0
_0xE3E8.Sidebar.Name =string.char(83,105,100,101,98,97,114)_0xE3E8.Sidebar.Position = UDim2.new(1, 8, 0.5, 0)
_0xE3E8.Sidebar.Size = UDim2.new(1, 0, 1, -10)
_0xE3E8.Sidebar.Parent = _0xE3E8.SidebarContainer
_0xE3E8.SidebarCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SidebarCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SidebarCorner.Parent = _0xE3E8.Sidebar
_0xE3E8.SidebarStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SidebarStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.SidebarStroke.Name =string.char(83,105,100,101,98,97,114,83,116,114,111,107,101)_0xE3E8.SidebarStroke.Parent = _0xE3E8.Sidebar
_0xE3E8.SidebarPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.SidebarPadding.PaddingBottom = UDim.new(0, 8)
_0xE3E8.SidebarPadding.PaddingLeft = UDim.new(0, 8)
_0xE3E8.SidebarPadding.PaddingRight = UDim.new(0, 18)
_0xE3E8.SidebarPadding.PaddingTop = UDim.new(0, 8)
_0xE3E8.SidebarPadding.Parent = _0xE3E8.Sidebar
_0xE3E8.SidebarLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.SidebarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SidebarLayout.Padding = UDim.new(0, 3)
_0xE3E8.SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.SidebarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.SidebarLayout.Parent = _0xE3E8.Sidebar
_0xE3E8.Topbar = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Topbar.BackgroundTransparency = 1
_0xE3E8.Topbar.BorderSizePixel = 0
_0xE3E8.Topbar.Name =string.char(84,111,112,98,97,114)_0xE3E8.Topbar.Size = UDim2.new(1, 0, 0, 30)
_0xE3E8.Topbar.Parent = _0xE3E8.Sidebar
_0xE3E8.TopbarSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.TopbarSizeCons.MaxSize = Vector2.new(2147483647, 30)
_0xE3E8.TopbarSizeCons.MinSize = Vector2.new(0, 28)
_0xE3E8.TopbarSizeCons.Parent = _0xE3E8.Topbar
_0xE3E8.TopbarLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.TopbarLayout.Padding = UDim.new(0, 4)
_0xE3E8.TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.TopbarLayout.Parent = _0xE3E8.Topbar
_0xE3E8.Logo = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.Logo.BackgroundTransparency = 1
_0xE3E8.Logo.BorderSizePixel = 0
_0xE3E8.Logo.Image = _0x418A.GetAsset(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,108,111,103,111,46,112,110,103))
_0xE3E8.Logo.ImageColor3 = Color3.fromRGB(0, 64, 180)
_0xE3E8.Logo.LayoutOrder = 1
_0xE3E8.Logo.Name =string.char(76,111,103,111)_0xE3E8.Logo.Size = UDim2.new(0, 30, 0, 30)
_0xE3E8.Logo.Parent = _0xE3E8.Topbar
_0xE3E8.LogoRatio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.LogoRatio.Parent = _0xE3E8.Logo
_0xE3E8.Icon = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
_0xE3E8.Icon.BackgroundTransparency = 1
_0xE3E8.Icon.BorderSizePixel = 0
_0xE3E8.Icon.Image = _0x418A.GetAsset(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,108,111,103,111,46,112,110,103))
_0xE3E8.Icon.ImageColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.Icon.LayoutOrder = 1
_0xE3E8.Icon.Name =string.char(73,99,111,110)_0xE3E8.Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xE3E8.Icon.Size = UDim2.new(1, -2, 1, -2)
_0xE3E8.Icon.Parent = _0xE3E8.Logo
_0xE3E8.Title = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.Title.BackgroundTransparency = 1
_0xE3E8.Title.BorderSizePixel = 0
_0xE3E8.Title.FontFace = _0x340D
_0xE3E8.Title.LayoutOrder = 2
_0xE3E8.Title.Name =string.char(84,105,116,108,101)_0xE3E8.Title.Size = UDim2.new(0, 60, 0, 30)
_0xE3E8.Title.Text =string.char(76,117,99,105,100)_0xE3E8.Title.TextColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.Title.TextScaled = true
_0xE3E8.Title.TextWrapped = true
_0xE3E8.Title.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.Title.Parent = _0xE3E8.Topbar
_0xE3E8.TitleStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.TitleStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.TitleStroke.Transparency = 0.6
_0xE3E8.TitleStroke.Name =string.char(84,105,116,108,101,83,116,114,111,107,101)_0xE3E8.TitleStroke.Parent = _0xE3E8.Title
_0xE3E8.TitlePadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.TitlePadding.PaddingBottom = UDim.new(0, 2)
_0xE3E8.TitlePadding.PaddingTop = UDim.new(0, 2)
_0xE3E8.TitlePadding.Parent = _0xE3E8.Title
_0xE3E8.CloseTab = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.CloseTab.BackgroundTransparency = 1
_0xE3E8.CloseTab.BorderSizePixel = 0
_0xE3E8.CloseTab.LayoutOrder = 100
_0xE3E8.CloseTab.Name =string.char(67,108,111,115,101,84,97,98)_0xE3E8.CloseTab.Size = UDim2.new(0, 30, 0, 58)
_0xE3E8.CloseTab.Text =""_0xE3E8.CloseTab.Parent = _0xE3E8.Sidebar
_0xE3E8.CloseTabLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.CloseTabLayout.Padding = UDim.new(0, 4)
_0xE3E8.CloseTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.CloseTabLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.CloseTabLayout.Parent = _0xE3E8.CloseTab
_0xE3E8.CloseTabSizeCons = Instance.new(string.char(85,73,83,105,122,101,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.CloseTabSizeCons.MaxSize = Vector2.new(2147483647, 34)
_0xE3E8.CloseTabSizeCons.MinSize = Vector2.new(0, 28)
_0xE3E8.CloseTabSizeCons.Parent = _0xE3E8.CloseTab
_0xE3E8.CloseTabPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.CloseTabPadding.PaddingBottom = UDim.new(0, 3)
_0xE3E8.CloseTabPadding.PaddingTop = UDim.new(0, 3)
_0xE3E8.CloseTabPadding.Parent = _0xE3E8.CloseTab
_0xE3E8.TabContainer6 = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.TabContainer6.BackgroundTransparency = 1
_0xE3E8.TabContainer6.BorderSizePixel = 0
_0xE3E8.TabContainer6.LayoutOrder = 1
_0xE3E8.TabContainer6.Name =string.char(84,97,98,67,111,110,116,97,105,110,101,114,54)_0xE3E8.TabContainer6.Size = UDim2.new(1, 0, 0, 22)
_0xE3E8.TabContainer6.Parent = _0xE3E8.CloseTab
_0xE3E8.TabContainer6Layout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.TabContainer6Layout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.TabContainer6Layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.TabContainer6Layout.Padding = UDim.new(0, 4)
_0xE3E8.TabContainer6Layout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.TabContainer6Layout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.TabContainer6Layout.Parent = _0xE3E8.TabContainer6
_0xE3E8.TabIcon6 = Instance.new(string.char(73,109,97,103,101,76,97,98,101,108))
_0xE3E8.TabIcon6.BackgroundTransparency = 1
_0xE3E8.TabIcon6.BorderSizePixel = 0
_0xE3E8.TabIcon6.Image = _0x418A.GetAsset(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,99,108,111,115,101,46,112,110,103))
_0xE3E8.TabIcon6.LayoutOrder = 1
_0xE3E8.TabIcon6.Name =string.char(84,97,98,73,99,111,110,54)_0xE3E8.TabIcon6.Size = UDim2.new(0, 30, 0, 30)
_0xE3E8.TabIcon6.Parent = _0xE3E8.TabContainer6
_0xE3E8.TabIcon6Ratio = Instance.new(string.char(85,73,65,115,112,101,99,116,82,97,116,105,111,67,111,110,115,116,114,97,105,110,116))
_0xE3E8.TabIcon6Ratio.Parent = _0xE3E8.TabIcon6
_0xE3E8.TabLabel6 = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.TabLabel6.BackgroundTransparency = 1
_0xE3E8.TabLabel6.BorderSizePixel = 0
_0xE3E8.TabLabel6.FontFace = _0x340D
_0xE3E8.TabLabel6.LayoutOrder = 2
_0xE3E8.TabLabel6.Name =string.char(84,97,98,76,97,98,101,108,54)_0xE3E8.TabLabel6.Size = UDim2.new(0, 60, 0, 30)
_0xE3E8.TabLabel6.Text =string.char(67,108,111,115,101)_0xE3E8.TabLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.TabLabel6.TextScaled = true
_0xE3E8.TabLabel6.TextWrapped = true
_0xE3E8.TabLabel6.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.TabLabel6.Parent = _0xE3E8.TabContainer6
_0xE3E8.TabUnderline6Close = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.TabUnderline6Close.BackgroundTransparency = 1
_0xE3E8.TabUnderline6Close.BorderSizePixel = 0
_0xE3E8.TabUnderline6Close.LayoutOrder = 2
_0xE3E8.TabUnderline6Close.Name =string.char(84,97,98,85,110,100,101,114,108,105,110,101,54,67,108,111,115,101)_0xE3E8.TabUnderline6Close.Size = UDim2.new(0, 0, 0, 1)
_0xE3E8.TabUnderline6Close.Parent = _0xE3E8.CloseTab
_0xE3E8.NewScriptFrame = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.NewScriptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
_0xE3E8.NewScriptFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
_0xE3E8.NewScriptFrame.BorderSizePixel = 0
_0xE3E8.NewScriptFrame.Name =string.char(78,101,119,83,99,114,105,112,116,70,114,97,109,101)_0xE3E8.NewScriptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xE3E8.NewScriptFrame.Size = UDim2.new(0, 408, 0, 214)
_0xE3E8.NewScriptFrame.Visible = false
_0xE3E8.NewScriptFrame.ZIndex = 2
_0xE3E8.NewScriptFrame.Parent = _0xE3E8.ScreenGui
_0xE3E8.NewScriptFrameStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NewScriptFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.NewScriptFrameStroke.Color = Color3.fromRGB(0, 99, 255)
_0xE3E8.NewScriptFrameStroke.Name =string.char(78,101,119,83,99,114,105,112,116,70,114,97,109,101,83,116,114,111,107,101)_0xE3E8.NewScriptFrameStroke.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.NewScriptFramePadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.NewScriptFramePadding.PaddingBottom = UDim.new(0, 6)
_0xE3E8.NewScriptFramePadding.PaddingLeft = UDim.new(0, 6)
_0xE3E8.NewScriptFramePadding.PaddingRight = UDim.new(0, 6)
_0xE3E8.NewScriptFramePadding.PaddingTop = UDim.new(0, 6)
_0xE3E8.NewScriptFramePadding.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.NewScriptFrameLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.NewScriptFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.NewScriptFrameLayout.Padding = UDim.new(0, 8)
_0xE3E8.NewScriptFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.NewScriptFrameLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.NewScriptFrameLayout.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.NewScriptFrameCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.NewScriptFrameCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.NewScriptFrameCorner.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.NameBox = Instance.new(string.char(84,101,120,116,66,111,120))
_0xE3E8.NameBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.NameBox.BorderSizePixel = 0
_0xE3E8.NameBox.FontFace = _0x1033
_0xE3E8.NameBox.LayoutOrder = 1
_0xE3E8.NameBox.Name =string.char(78,97,109,101,66,111,120)_0xE3E8.NameBox.PlaceholderText =string.char(69,110,116,101,114,32,115,99,114,105,112,116,32,110,97,109,101,46,46,46)_0xE3E8.NameBox.Size = UDim2.new(0, 76, 0, 30)
_0xE3E8.NameBox.Text =""_0xE3E8.NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.NameBox.TextScaled = true
_0xE3E8.NameBox.TextWrapped = true
_0xE3E8.NameBox.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.NameBox.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.NameBoxPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.NameBoxPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.NameBoxPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.NameBoxPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.NameBoxPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.NameBoxPadding.Parent = _0xE3E8.NameBox
_0xE3E8.NameBoxStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.NameBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.NameBoxStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.NameBoxStroke.Parent = _0xE3E8.NameBox
_0xE3E8.NameBoxCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.NameBoxCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.NameBoxCorner.Parent = _0xE3E8.NameBox
_0xE3E8.DescBox = Instance.new(string.char(84,101,120,116,66,111,120))
_0xE3E8.DescBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.DescBox.BorderSizePixel = 0
_0xE3E8.DescBox.FontFace = _0x1033
_0xE3E8.DescBox.LayoutOrder = 2
_0xE3E8.DescBox.Name =string.char(68,101,115,99,66,111,120)_0xE3E8.DescBox.PlaceholderText =string.char(69,110,116,101,114,32,115,99,114,105,112,116,32,100,101,115,99,114,105,112,116,105,111,110,46,46,46)_0xE3E8.DescBox.Size = UDim2.new(0, 76, 0, 30)
_0xE3E8.DescBox.Text =""_0xE3E8.DescBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.DescBox.TextScaled = true
_0xE3E8.DescBox.TextWrapped = true
_0xE3E8.DescBox.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.DescBox.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.DescBoxCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.DescBoxCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.DescBoxCorner.Parent = _0xE3E8.DescBox
_0xE3E8.DescBoxPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.DescBoxPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.DescBoxPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.DescBoxPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.DescBoxPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.DescBoxPadding.Parent = _0xE3E8.DescBox
_0xE3E8.DescBoxStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.DescBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.DescBoxStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.DescBoxStroke.Parent = _0xE3E8.DescBox
_0xE3E8.ScriptBox = Instance.new(string.char(84,101,120,116,66,111,120))
_0xE3E8.ScriptBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.ScriptBox.BorderSizePixel = 0
_0xE3E8.ScriptBox.FontFace = _0x296B
_0xE3E8.ScriptBox.LayoutOrder = 3
_0xE3E8.ScriptBox.Name =string.char(83,99,114,105,112,116,66,111,120)_0xE3E8.ScriptBox.PlaceholderText =string.char(69,110,116,101,114,32,115,99,114,105,112,116,46,46,46)_0xE3E8.ScriptBox.Size = UDim2.new(0, 76, 0, 80)
_0xE3E8.ScriptBox.Text =""_0xE3E8.ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.ScriptBox.TextSize = 20
_0xE3E8.ScriptBox.TextWrapped = true
_0xE3E8.ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
_0xE3E8.ScriptBox.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.ScriptBoxPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ScriptBoxPadding.PaddingBottom = UDim.new(0, 4)
_0xE3E8.ScriptBoxPadding.PaddingLeft = UDim.new(0, 4)
_0xE3E8.ScriptBoxPadding.PaddingRight = UDim.new(0, 4)
_0xE3E8.ScriptBoxPadding.PaddingTop = UDim.new(0, 4)
_0xE3E8.ScriptBoxPadding.Parent = _0xE3E8.ScriptBox
_0xE3E8.ScriptBoxCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ScriptBoxCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ScriptBoxCorner.Parent = _0xE3E8.ScriptBox
_0xE3E8.ScriptBoxStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ScriptBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ScriptBoxStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.ScriptBoxStroke.Parent = _0xE3E8.ScriptBox
_0xE3E8.Options = Instance.new(string.char(70,114,97,109,101))
_0xE3E8.Options.BackgroundTransparency = 1
_0xE3E8.Options.BorderSizePixel = 0
_0xE3E8.Options.LayoutOrder = 4
_0xE3E8.Options.Name =string.char(79,112,116,105,111,110,115)_0xE3E8.Options.Size = UDim2.new(0, 76, 0, 34)
_0xE3E8.Options.Parent = _0xE3E8.NewScriptFrame
_0xE3E8.OptionsCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.OptionsCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.OptionsCorner.Parent = _0xE3E8.Options
_0xE3E8.OptionsLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.OptionsLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.OptionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.OptionsLayout.Padding = UDim.new(0, 8)
_0xE3E8.OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.OptionsLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.OptionsLayout.Parent = _0xE3E8.Options
_0xE3E8.Save = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.Save.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.Save.BorderSizePixel = 0
_0xE3E8.Save.FontFace = _0x1033
_0xE3E8.Save.LayoutOrder = 1
_0xE3E8.Save.Name =string.char(83,97,118,101)_0xE3E8.Save.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.Save.Text =string.char(83,97,118,101)_0xE3E8.Save.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.Save.TextScaled = true
_0xE3E8.Save.TextWrapped = true
_0xE3E8.Save.Parent = _0xE3E8.Options
_0xE3E8.SaveStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.SaveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.SaveStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.SaveStroke.Name =string.char(83,97,118,101,83,116,114,111,107,101)_0xE3E8.SaveStroke.Parent = _0xE3E8.Save
_0xE3E8.SaveCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.SaveCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.SaveCorner.Parent = _0xE3E8.Save
_0xE3E8.Cancel = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.Cancel.BackgroundColor3 = Color3.fromRGB(0, 99, 255)
_0xE3E8.Cancel.BorderSizePixel = 0
_0xE3E8.Cancel.FontFace = _0x1033
_0xE3E8.Cancel.LayoutOrder = 2
_0xE3E8.Cancel.Name =string.char(67,97,110,99,101,108)_0xE3E8.Cancel.Size = UDim2.new(0.2, 0, 0.3, 0)
_0xE3E8.Cancel.Text =string.char(67,97,110,99,101,108)_0xE3E8.Cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.Cancel.TextScaled = true
_0xE3E8.Cancel.TextWrapped = true
_0xE3E8.Cancel.Parent = _0xE3E8.Options
_0xE3E8.CancelCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.CancelCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.CancelCorner.Parent = _0xE3E8.Cancel
_0xE3E8.CancelStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.CancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.CancelStroke.Color = Color3.fromRGB(0, 64, 180)
_0xE3E8.CancelStroke.Name =string.char(67,97,110,99,101,108,83,116,114,111,107,101)_0xE3E8.CancelStroke.Parent = _0xE3E8.Cancel
_0xE3E8.ResetThemeBtn = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xE3E8.ResetThemeBtn.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
_0xE3E8.ResetThemeBtn.BorderSizePixel = 0
_0xE3E8.ResetThemeBtn.LayoutOrder = 6
_0xE3E8.ResetThemeBtn.Name =string.char(82,101,115,101,116,84,104,101,109,101,66,116,110)_0xE3E8.ResetThemeBtn.Size = UDim2.new(1, 0, 0, 38)
_0xE3E8.ResetThemeBtn.Text =""_0xE3E8.ResetThemeBtn.Parent = _0xE3E8.SettingsFrame
_0xE3E8.ResetThemeBtnCorner = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE3E8.ResetThemeBtnCorner.CornerRadius = UDim.new(0, 6)
_0xE3E8.ResetThemeBtnCorner.Parent = _0xE3E8.ResetThemeBtn
_0xE3E8.ResetThemeBtnStroke = Instance.new(string.char(85,73,83,116,114,111,107,101))
_0xE3E8.ResetThemeBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xE3E8.ResetThemeBtnStroke.Color = Color3.fromRGB(36, 36, 36)
_0xE3E8.ResetThemeBtnStroke.Parent = _0xE3E8.ResetThemeBtn
_0xE3E8.ResetThemeBtnLayout = Instance.new(string.char(85,73,76,105,115,116,76,97,121,111,117,116))
_0xE3E8.ResetThemeBtnLayout.FillDirection = Enum.FillDirection.Horizontal
_0xE3E8.ResetThemeBtnLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ResetThemeBtnLayout.Padding = UDim.new(0, 6)
_0xE3E8.ResetThemeBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
_0xE3E8.ResetThemeBtnLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
_0xE3E8.ResetThemeBtnLayout.Parent = _0xE3E8.ResetThemeBtn
_0xE3E8.ResetThemeBtnPadding = Instance.new(string.char(85,73,80,97,100,100,105,110,103))
_0xE3E8.ResetThemeBtnPadding.PaddingBottom = UDim.new(0, 8)
_0xE3E8.ResetThemeBtnPadding.PaddingLeft = UDim.new(0, 8)
_0xE3E8.ResetThemeBtnPadding.PaddingRight = UDim.new(0, 8)
_0xE3E8.ResetThemeBtnPadding.PaddingTop = UDim.new(0, 8)
_0xE3E8.ResetThemeBtnPadding.Parent = _0xE3E8.ResetThemeBtn
_0xE3E8.ResetThemeBtnLabel = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xE3E8.ResetThemeBtnLabel.BackgroundTransparency = 1
_0xE3E8.ResetThemeBtnLabel.BorderSizePixel = 0
_0xE3E8.ResetThemeBtnLabel.FontFace = _0x1033
_0xE3E8.ResetThemeBtnLabel.LayoutOrder = 1
_0xE3E8.ResetThemeBtnLabel.Size = UDim2.new(0.8, 0, 1, 0)
_0xE3E8.ResetThemeBtnLabel.Text =string.char(82,101,115,101,116,32,84,104,101,109,101)_0xE3E8.ResetThemeBtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xE3E8.ResetThemeBtnLabel.TextScaled = true
_0xE3E8.ResetThemeBtnLabel.TextWrapped = true
_0xE3E8.ResetThemeBtnLabel.TextXAlignment = Enum.TextXAlignment.Left
_0xE3E8.ResetThemeBtnLabel.Parent = _0xE3E8.ResetThemeBtn
_0xE3E8.HomeTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,104,111,109,101,46,112,110,103),string.char(72,111,109,101), _0xE3E8.HomeContent, 1,string.char(84,97,98,85,110,100,101,114,108,105,110,101))
_0xE3E8.ExeTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,101,120,101,99,117,116,111,114,46,112,110,103),string.char(69,120,101,99,117,116,111,114), _0xE3E8.ExeContent, 2,string.char(84,97,98,85,110,100,101,114,108,105,110,101,50))
_0xE3E8.SearchTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,101,97,114,99,104,46,112,110,103),string.char(83,101,97,114,99,104), _0xE3E8.SearchContent, 3,string.char(84,97,98,85,110,100,101,114,108,105,110,101,51))
_0xE3E8.ScriptsTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,99,114,105,112,116,115,46,112,110,103),string.char(83,99,114,105,112,116,115), _0xE3E8.ScriptsContent, 4,string.char(84,97,98,85,110,100,101,114,108,105,110,101,52))
_0xE3E8.MusicTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,109,117,115,105,99,46,112,110,103),string.char(77,117,115,105,99), _0xE3E8.MusicContent, 5,string.char(84,97,98,85,110,100,101,114,108,105,110,101,54,77,117,115,105,99))
_0xE3E8.SettingsTab = _0x418A.CreateTab(string.char(76,117,99,105,100,47,65,115,115,101,116,115,47,108,117,99,105,100,95,115,101,116,116,105,110,103,115,46,112,110,103),string.char(83,101,116,116,105,110,103,115), _0xE3E8.SettingsContent, 6,string.char(84,97,98,85,110,100,101,114,108,105,110,101,53))
_0x418A.CreateSettingsInputbox(string.char(66,97,99,107,103,114,111,117,110,100,32,67,111,108,111,114,32,40,82,71,66,41),string.char(49,48,44,32,49,48,44,32,49,48),string.char(66,97,99,107,103,114,111,117,110,100,67,111,108,111,114), 2)
_0x418A.CreateSettingsInputbox(string.char(83,101,99,111,110,100,97,114,121,32,66,97,99,107,103,114,111,117,110,100,32,67,111,108,111,114,32,40,82,71,66,41),string.char(49,56,44,32,49,56,44,32,49,56),string.char(83,101,99,111,110,100,97,114,121,66,97,99,107,103,114,111,117,110,100,67,111,108,111,114), 3)
_0x418A.CreateSettingsInputbox(string.char(65,99,99,101,110,116,32,67,111,108,111,114,32,40,82,71,66,41),string.char(48,44,32,57,56,44,32,50,53,53),string.char(65,99,99,101,110,116,67,111,108,111,114), 4)
_0x418A.CreateSettingsInputbox(string.char(83,101,99,111,110,100,97,114,121,32,65,99,99,101,110,116,32,67,111,108,111,114,32,40,82,71,66,41),string.char(48,44,32,54,51,44,32,49,55,57),string.char(83,101,99,111,110,100,97,114,121,65,99,99,101,110,116,67,111,108,111,114), 5)
_0x418A.LoadSettings()
_0x418A.ApplyTheme()
_0x418A.InitDefaultScripts()
_0x418A.Dragify(_0xE3E8.Show)
_0x418A.CreateExeTab(string.char(84,97,98,32,49))
_0xE3E8.AddExeTabBtn.MouseButton1Click:Connect(function()
_0x418A.CreateExeTab()
end)
_0xE3E8.Show.MouseButton1Click:Connect(function()
_0x418A.OpenUI()
end)
_0xE3E8.CloseTab.MouseButton1Click:Connect(function()
_0x418A.CloseUI()
end)
_0xE3E8.Save.MouseButton1Click:Connect(function()
local _0x3CE3 = _0xE3E8.NameBox.Text
local _0xCDC0 = _0xE3E8.DescBox.Text
local _0x69D9 = _0xE3E8.ScriptBox.Text
if _0x3CE3 ==""then return end
_0x418A.SaveScript({ Name = _0x3CE3, Description = _0xCDC0, Code = _0x69D9 })
_0xE3E8.NewScriptFrame.Visible = false
_0xE3E8.NameBox.Text =""_0xE3E8.DescBox.Text =""_0xE3E8.ScriptBox.Text =""_0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2.Text)
end)
_0xE3E8.Cancel.MouseButton1Click:Connect(function()
_0xE3E8.NewScriptFrame.Visible = false
_0xE3E8.NameBox.Text =""_0xE3E8.DescBox.Text =""_0xE3E8.ScriptBox.Text =""end)
_0xE3E8.NewScriptBtn.MouseButton1Click:Connect(function()
_0xE3E8.NewScriptFrame.Visible = true
_0xE3E8.NameBox.Text =""_0xE3E8.DescBox.Text =""_0xE3E8.ScriptBox.Text =""end)
_0xE3E8.SearchBox:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(function()
local _0xB4BB = _0xE3E8.SearchBox.Text
_0xE3E8.PrevBtn.Visible = false
_0xE3E8.NextBtn.Visible = false
if _0xB4BB ~=""then
_0x418A.PerformSearch(_0xB4BB, 1)
elseif _0x418A.CurrentSource ==string.char(83,99,114,105,112,116,66,108,111,120)then
_0x418A.PerformSearch("", 1)
else
if _0xE3E8.NoResultsLabel then _0xE3E8.NoResultsLabel.Visible = false end
_0x418A.CurrentScripts = {}
_0x418A.RenderSearchResults()
end
end)
_0xE3E8.PrevBtn.MouseButton1Click:Connect(function()
if _0xCC51 > 1 then _0x418A.PerformSearch(_0x1CC3, _0xCC51 - 1) end
end)
_0xE3E8.NextBtn.MouseButton1Click:Connect(function()
if _0xCC51 < _0xB84E then _0x418A.PerformSearch(_0x1CC3, _0xCC51 + 1) end
end)
_0xE3E8.SourceBtn.MouseButton1Click:Connect(function()
_0x418A.CycleSource()
end)
_0xE3E8.FilterBtn.MouseButton1Click:Connect(function()
_0x418A.CycleFilter()
end)
_0xE3E8.SearchBox2:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(function()
_0x418A.RefreshSavedScripts(_0xE3E8.SearchBox2.Text)
end)
_0xE3E8.ExeBtn.MouseButton1Click:Connect(function()
if _0x1CF4 then
local _0xBC87 = _0x1CF4.inputBox.Text
if _0xBC87 and _0xBC87 ~=""then
loadstring(_0xBC87)()
end
end
end)
_0xE3E8.ClrBtn.MouseButton1Click:Connect(function()
if _0x1CF4 then _0x1CF4.inputBox.Text =""end
end)
_0xE3E8.CopyBtn.MouseButton1Click:Connect(function()
if _0x1CF4 then _0x8139(_0x1CF4.inputBox.Text) end
end)
_0xE3E8.AnimsToggle.MouseButton1Click:Connect(function()
_0x87A2.Animations = not _0x87A2.Animations
if _0xE3E8.ToggleState then
local _0xE617 = _0x87A2.Animations and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
if _0x87A2.Animations then
_0x44D7:Create(_0xE3E8.ToggleState, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = _0xE617 }):Play()
local _0x4B72 = _0xE3E8.ToggleState:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0x4B72 then _0x44D7:Create(_0x4B72, TweenInfo.new(0.3), { Color = _0xE617 }):Play() end
else
_0x44D7:Create(_0xE3E8.ToggleState, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = _0xE617 }):Play()
local _0x4B72 = _0xE3E8.ToggleState:FindFirstChildOfClass(string.char(85,73,83,116,114,111,107,101))
if _0x4B72 then _0x44D7:Create(_0x4B72, TweenInfo.new(0.3), { Color = _0xE617 }):Play() end
end
end
_0x418A.SaveSettings()
end)
_0xE3E8.ResetThemeBtn.MouseButton1Click:Connect(function()
_0x87A2.BackgroundColor = Color3.fromRGB(0, 0, 0)
_0x87A2.SecondaryBackgroundColor = Color3.fromRGB(10, 10, 10)
_0x87A2.AccentColor = Color3.fromRGB(0, 99, 255)
_0x87A2.SecondaryAccentColor = Color3.fromRGB(0, 64, 180)
_0x418A.ApplyTheme()
_0x418A.SaveSettings()
end)
_0xE3E8.MusicPlayBtn.MouseButton1Click:Connect(function()
if not _0x6B61 or not _0x6B61.Parent then
_0x3162 = _0x418A.GetMusicFiles()
if #_0x3162 > 0 then
_0x418A.LoadAndPlayMusic(_0xD865)
end
return
end
if _0x140A then
_0x6B61:Pause()
_0x140A = false
_0xE3E8.MusicPlayBtn.Text =string.char(226,150,182)else
_0x6B61:Resume()
_0x140A = true
_0xE3E8.MusicPlayBtn.Text =string.char(226,143,184)end
end)
_0xE3E8.MusicPrevBtn.MouseButton1Click:Connect(function()
_0x3162 = _0x418A.GetMusicFiles()
if #_0x3162 > 0 then
_0x418A.LoadAndPlayMusic(_0xD865 - 1)
end
end)
_0xE3E8.MusicNextBtn.MouseButton1Click:Connect(function()
_0x3162 = _0x418A.GetMusicFiles()
if #_0x3162 > 0 then
_0x418A.LoadAndPlayMusic(_0xD865 + 1)
end
end)
_0xE3E8.MusicLoopToggle.MouseButton1Click:Connect(function()
local _0xBE93 = _0xE3E8.MusicLoopState.BackgroundColor3 == Color3.fromRGB(0, 255, 0)
local _0x180D = _0xBE93 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
_0xE3E8.MusicLoopState.BackgroundColor3 = _0x180D
if _0x6B61 then _0x6B61.Looped = not _0xBE93 end
end)
_0xE3E8.MusicVolumeBox:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(function()
local _0x2A1F = tonumber(_0xE3E8.MusicVolumeBox.Text)
if _0x2A1F and _0x6B61 then
_0x6B61.Volume = math.clamp(_0x2A1F, 0, 10)
end
end)
_0xE3E8.MusicSpeedBox:GetPropertyChangedSignal(string.char(84,101,120,116)):Connect(function()
local _0x5DB3 = tonumber(_0xE3E8.MusicSpeedBox.Text)
if _0x5DB3 and _0x6B61 then
_0x6B61.PlaybackSpeed = math.clamp(_0x5DB3, 0.1, 10)
end
end)
local _0x971C = false
local _0x6E55
_0xE3E8.MusicSliderBar.InputBegan:Connect(function(_0x71BF)
if _0x71BF.UserInputType == Enum.UserInputType.MouseButton1 or _0x71BF.UserInputType == Enum.UserInputType.Touch then
_0x971C = true
_0xEFB8 = true
local function _0x7A7C(inp)
local _0x9B88 = _0xE3E8.MusicSliderBar.AbsolutePosition.X
local _0x72D3 = _0xE3E8.MusicSliderBar.AbsoluteSize.X
local _0x5186 = math.clamp((inp.Position.X - _0x9B88) / _0x72D3, 0, 1)
_0xE3E8.MusicSliderFill.Size = UDim2.new(_0x5186, 0, 1, 0)
_0xE3E8.MusicSliderKnob.Position = UDim2.new(_0x5186, -6, 0.5, -6)
if _0x6B61 and _0x6B61.TimeLength and _0x6B61.TimeLength > 0 then
_0x6B61.TimePosition = _0x5186 * _0x6B61.TimeLength
_0xE3E8.MusicTimeLabel.Text = _0x418A.FormatTime(_0x6B61.TimePosition) ..string.char(32,47,32).. _0x418A.FormatTime(_0x6B61.TimeLength)
end
end
_0x7A7C(_0x71BF)
if _0x6E55 then _0x6E55:Disconnect() end
_0x6E55 = _0x86B4.InputChanged:Connect(function(inp)
if _0x971C and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
_0x7A7C(inp)
end
end)
_0x71BF.Changed:Connect(function()
if _0x71BF.UserInputState == Enum.UserInputState.End then
_0x971C = false
_0xEFB8 = false
if _0x6E55 then _0x6E55:Disconnect() end
end
end)
end
end)
_0x418A.SwitchTab(_0xE3E8.HomeTab)
_0x418A.SetAllUnderlines(_0xE3E8.HomeTab)
_0xE3E8.Show.Visible = true
_0xE3E8.MainFrame.Visible = false
coroutine.wrap(function()
while _0xE3E8.ScreenGui and _0xE3E8.ScreenGui.Parent do
_0x418A.UpdateStats()
_0x418A.UpdateMusicSlider()
_0x8239(0.5)
end
end)()
_0x436D.PlayerRemoving:Connect(function(player)
if player == _0x0F90 then
_0x418A.ClearCache()
if _0x6B61 then _0x6B61:Stop(); _0x6B61:Destroy() end
end
end)