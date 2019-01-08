local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API Localization
----------------------------------------------------------------

local _G = getfenv(0)
local format = string.format
local find = string.find

local min = math.min
local max = math.max
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad
local acos = math.acos
local atan = math.atan
local rad = math.rad
local modf = math.modf

local insert = table.insert
local remove = table.remove
local wipe = table.wipe

----------------------------------------------------------------
--> 
----------------------------------------------------------------

local function Database_Load()
	for k, v in ipairs(P.Module) do
		if v.Config and v.Config.Database then
			for d, dv in pairs(v.Config.Database) do
				P.Database.Profile.Default[d] = dv
			end
		end
	end
end

function Quafe_CheckTable(A, B)
	for k, v in pairs(B) do
		if A[k] == nil then
			A[k] = v
		else
			if type(v) == "table" then
				Quafe_CheckTable(A[k], v)
			end
		end
	end
end

local function Profile_Check()
	if Quafe_DB.Profile then
		if Quafe_DB.Profile[Quafe_DBP.Profile] then
			return 0
		else
			Quafe_DBP.Profile = "Default"
			if Quafe_DB.Profile["Default"] then
				return 1
			else
				Quafe_DB.Profile["Default"] = P.Database.Profile.Default
				return 2
			end
		end
	end
end

local function Profile_Load()
	if Quafe_DB then
		if Quafe_DB.Reset then
			wipe(Quafe_DB)
		end
	else
		Quafe_DB = {}
	end
	if not Quafe_DBP then
		Quafe_DBP = {}
		Quafe_DBP.Profile = "Default"
	end
	Quafe_CheckTable(Quafe_DB, P.Database)
	Quafe_CheckTable(Quafe_DB.Profile[Quafe_DBP.Profile], P.Database.Profile.Default)
	Profile_Check()
end

local function Aura_Load()
	if not Quafe_DB.Global.AuraWatch then
		Quafe_DB.Global.AuraWatch = P.Aurawatch
	end
	--[[
	local class = select(2, UnitClass("player"))
	if Quafe_DB.Global.AuraWatch[class] then
		for k1, v1 in ipairs(Quafe_DB.Global.AuraWatch[class]) do
			if v1 then
				for k2, v2 in ipairs(v1) do
					if v2.Aura then
						P.AuraUpdate.AuraList[v2.Aura] = {
							Aura = v2.Aura,
							Unit = v2.Unit,
							Caster = v2.Caster,
						}
						if not tContains(P.AuraUpdate.UnitList, v2.Unit) then
							tinsert(P.AuraUpdate.UnitList, v2.Unit)
						end
					end
				end
			end
		end
	end
	--]]
end

local function Module_Load()
	for k, v in ipairs(P.Module) do
		if v.Load then
			v.Load()
		end
	end
end

--- ------------------------------------------------------------
--> 
--- ------------------------------------------------------------

local function Quafe_Init()
	BINDING_HEADER_QUAFE = GetAddOnMetadata(P.Name, "Title")
	BINDING_NAME_QUAFE_COMMUNICATIONMENU = L['BINDING_COMMUNICATIONMENU']

	--> 战斗字体
	DAMAGE_TEXT_FONT = F.Media.."Fonts\\TTTGB-Medium.ttf"
	--> 最大装备方案数量
	MAX_EQUIPMENT_SETS_PER_PLAYER = 20
end

local function Quafe_Load()
	Database_Load()
	Profile_Load()
	Aura_Load()
	Module_Load()
end

local function Quafe_Login()
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	--SetCVar("rawMouseEnable", 1) --(0)[0,1]
	--SetCVar("rawMouseRate", 1000) --(125)[125]
	--SetCVar("rawMouseResolution", 2000) --(400)[400]
	SetCVar("cameraYawMoveSpeed", 270) --(180)[90-270]
	--SetCVar("cameraPitchMoveSpeed", 1) --(90)[45-135]
	SetCVar("breakUpLargeNumbers", 1) 
	SetCVar("autoQuestProgress", 1) 
	SetCVar("overrideArchive", 0) --反和谐(1)[0,1]
end

local Init_Help = CreateFrame("Frame", nil, P)
Init_Help: RegisterEvent("ADDON_LOADED")
Init_Help: RegisterEvent("PLAYER_LOGIN")
Init_Help: SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == P.Name then
			Quafe_Init()
			local OW_Load,OW_Reason = LoadAddOn("Quafe_Overwatch")
			local TI_Load,TI_Reason = LoadAddOn("Quafe_TIE")
			local MK_Load,MK_Reason = LoadAddOn("Quafe_MEKA")
			C.PlayerName = GetUnitName("player", false)
			C.PlayerClass = select(2, UnitClass("player"))
			C.PlayerRealm = GetRealmName()
			C.PlayerGuid = UnitGUID( "player")
			Quafe_Load()
			self: UnregisterEvent(event)
		end
	end
	if event == "PLAYER_LOGIN" then
		Quafe_Login()
	end
end)