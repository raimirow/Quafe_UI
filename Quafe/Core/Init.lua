----------------------------------------------------------------
-- Init
----------------------------------------------------------------

local AddonName, Engine = ...
local Quafe_UIParent = CreateFrame("Frame", "Quafe_UIParent", UIParent)
Quafe_UIParent: SetSize(12,12)
Quafe_UIParent: SetPoint("CENTER", UIParent, "CENTER", 0,0)

Engine[1] = Quafe_UIParent
Engine[2] = {}	-->C, Config and Constant
Engine[3] = {}	-->F, Function and Lib
Engine[4] = {}	-->L, Locale
_G[AddonName] = Engine	-->Allow other addons to use Engine

local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale
--This should be at the top of every file inside of the Quafe AddOn:	
--local E, C, F, L = unpack(select(2, ...))

--[[
local QUAFE_NS = {}
QUAFE_NS[1] = Quafe_UIParent
QUAFE_NS[2] = {}
QUAFE_NS[3] = {}
QUAFE_NS[4] = {}
_G.Quafe = QUAFE_NS	-->Allow other addons to use NS
--]]

--This is how another addon imports the Quafe NS:	
--local E, C, F, L = unpack(Quafe)
--(learned from Tukui)

E.Name = AddonName
E.Version = tonumber(C_AddOns.GetAddOnMetadata(E.Name, "Version"))

E.Module = {}
E.Config = {}
E.AuraUpdate = {
	player = {
		Buff = {},
		Debuff = {},
	},
	target = {
		Buff = {},
		Debuff = {},
	},
	pet = {
		Buff = {},
		Debuff = {},
	},
	focus = {
		Buff = {},
		Debuff = {},
	},
	AuraList = {},
	UnitList = {"player", "target"},
}
E.Aurawatch = {}
E.AurawatchStyle = {}
E.FCS_Refresh = {}
C.Database = {
	Reset = false,
	Global = {},
	Profile = {
		Default = {},
	},
}
E.Value = {
	["player"] = {
		Health = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Power = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Mana = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Absorb = {Min = 0, Max = 0, Per = 0, Cur = 0},
	},
	["target"] = {
		Health = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Power = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Mana = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Absorb = {Min = 0, Max = 0, Per = 0, Cur = 0},
	},
	["focus"] = {
		Health = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Power = {Min = 0, Max = 0, Per = 0, Cur = 0},
	},
	["pet"] = {
		Health = {Min = 0, Max = 0, Per = 0, Cur = 0},
		Power = {Min = 0, Max = 0, Per = 0, Cur = 0},
	},
}
E.UBU = {
	Player = {
		HP = {},
		PP = {},
		AS = {},
		MN = {},
	},
	Pet = {
		HP = {},
		PP = {},
	},
	Target = {
		HP = {},
		PP = {},
		AS = {},
		MN = {},
	},
}
E.Aura = {}
E.CombatLogList = {}


--F.Media = "Interface\\AddOns\\"..AddonName.."\\Media\\"
F.Path = function(tex)
	--return format("%s%s%s%s", "Interface\\AddOns\\", AddonName, "\\Media\\", tex)
	return "Interface\\AddOns\\"..AddonName.."\\Media\\"..tex
end

----------------------------------------------------------------
-- Slash
----------------------------------------------------------------

--> Reload UI
SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = "/rl"

--> Calendar
SlashCmdList["CALENDAR"] = function()
	ToggleCalendar()
end
SLASH_CALENDAR1 = "/cl"
SLASH_CALENDAR2 = "/calendar"

--> Clear Focus
SlashCmdList.CLEARFOCUS = ClearFocus

--> Config Frame
SlashCmdList["QUAFE"] = function(msg)
	msg = msg:lower()
	if msg == "reset" then
		F.Reset()
		DEFAULT_CHAT_FRAME:AddMessage("Quafe UI has be reset")
	elseif msg == "aurawatch reset" then
		wipe(Quafe_DB.Global.AuraWatch)
		Quafe_DB.Global.AuraWatch = E.Aurawatch
		DEFAULT_CHAT_FRAME:AddMessage("Quafe AuraWatch has be reset")
		Quafe_WarningReload()
	elseif msg == "locale debug" then
		if F.Locale_Debug then
			F.Locale_Debug()
		end
	else
		if _G["Quafe_Config"] then _G["Quafe_Config"]: Show() end
		DEFAULT_CHAT_FRAME:AddMessage("/quafe reset\n>>>Reset quafe savedvariables")
		DEFAULT_CHAT_FRAME:AddMessage("/quafe aurawatch reset\n>>>Reset quafe aurawatch savedvariables")
	end
end
SLASH_QUAFE1 = "/quafe"
SLASH_QUAFE2 = "/qf"