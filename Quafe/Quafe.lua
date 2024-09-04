local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API Localization
----------------------------------------------------------------

local _G = getfenv(0)
local gsub = string.gsub
local insert = table.insert
local wipe = table.wipe

----------------------------------------------------------------
--> 
----------------------------------------------------------------

local function Database_Load()
	for k, v in ipairs(E.Module) do
		if v.Config and v.Config.Database then
			for d, dv in pairs(v.Config.Database) do
				E.Database.Profile.Default[d] = dv
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
				if type(A[k]) == "table" then
					Quafe_CheckTable(A[k], v)
				else
					A[k] = v
				end
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
				Quafe_DB.Profile["Default"] = E.Database.Profile.Default
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
	Quafe_CheckTable(Quafe_DB, E.Database)
	Profile_Check()
	Quafe_CheckTable(Quafe_DB.Profile[Quafe_DBP.Profile], E.Database.Profile.Default)
end

function F.Reset()
	if Quafe_DB then
		wipe(Quafe_DB)
	else
		Quafe_DB = {}
	end
	if not Quafe_DBP then
		Quafe_DBP = {}
		Quafe_DBP.Profile = "Default"
	end
	Quafe_CheckTable(Quafe_DB, E.Database)
	Quafe_CheckTable(Quafe_DB.Profile[Quafe_DBP.Profile], E.Database.Profile.Default)
	Profile_Check()
	if not Quafe_DB.Global.AuraWatch then
		Quafe_DB.Global.AuraWatch = E.Aurawatch
	end
end

local function Aura_Load()
	if not Quafe_DB.Global.AuraWatch then
		Quafe_DB.Global.AuraWatch = E.Aurawatch
	end
	--[[
	local class = select(2, UnitClass("player"))
	if Quafe_DB.Global.AuraWatch[class] then
		for k1, v1 in ipairs(Quafe_DB.Global.AuraWatch[class]) do
			if v1 then
				for k2, v2 in ipairs(v1) do
					if v2.Aura then
						EAuraUpdate.AuraList[v2.Aura] = {
							Aura = v2.Aura,
							Unit = v2.Unit,
							Caster = v2.Caster,
						}
						if not tContains(EAuraUpdate.UnitList, v2.Unit) then
							tinsert(EAuraUpdate.UnitList, v2.Unit)
						end
					end
				end
			end
		end
	end
	--]]
end

local function Module_Load()
	for k, v in ipairs(E.Module) do
		if v.Load then
			v.Load()
		end
	end
end

local function Module_LoadDelay()
	for k, v in ipairs(E.Module) do
		if v.LoadDelay then
			v.LoadDelay()
		end
	end
end

--- ------------------------------------------------------------
--> 
--- ------------------------------------------------------------

local function Quafe_Init()
	BINDING_HEADER_QUAFE = C_AddOns.GetAddOnMetadata(E.Name, "Title")
	BINDING_NAME_QUAFE_COMMUNICATIONMENU = L['BINDING_COMMUNICATIONMENU']

	--> 战斗字体
	--DAMAGE_TEXT_FONT = F.Path("Fonts\\Txt.ttf")
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
	Module_LoadDelay()
	--SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	--SetCVar("rawMouseEnable", 1) --(0)[0,1]
	--SetCVar("rawMouseRate", 1000) --(125)[125]
	--SetCVar("rawMouseResolution", 2000) --(400)[400]
	--SetCVar("cameraYawMoveSpeed", 270) --(180)[90-270]
	--SetCVar("cameraPitchMoveSpeed", 1) --(90)[45-135]
	--SetCVar("breakUpLargeNumbers", 1) 
	--SetCVar("autoQuestProgress", 1)
	if GetLocale() == "zhCN" then
		SetCVar("overrideArchive", 0) --反和谐(1)[0,1]
		SetCVar("profanityFilter", 0) --语言过滤器(1)[0,1]
		if not F.IsClassic then
			SetCVar("showQuestTrackingTooltips", 1) --鼠标提示中显示任务追踪(1)[0,1]
			--/console showQuestTrackingTooltips 1
		end
		--SetCVar("nameplateMaxDistance", "4e1") --姓名板最大距离
		--/console ffxGlow 0 全屏泛光(1)[0,1]
		--/console flightAngleLookAhead 飞行时视角锁定向前(0)[0,1]
		--/console weatherDensity 2 --天气效果(2)[0,1,2,3]
		--/console RAIDweatherDensity 2 --副本天气效果(2)[0,1,2,3]
	end
end

local function Button_Template(frame, color)
	local Dummy = CreateFrame("Button", nil, frame)
	Dummy: SetSize(240,28)

	local Bg = F.Create.Backdrop(Dummy, 2, true, 2, 2, color, 0.9, color, 0.9)
    local Text = F.Create.Font(Dummy, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "CENTER", "CENTER")
    Text: SetPoint("CENTER", Dummy, "CENTER", 0,0)

    Dummy: SetScript("OnEnter", function(self)
		Bg: SetBackdropColor(F.Color(color, 0.7))
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
	end)
	Dummy: SetScript("OnLeave", function(self)
		Bg: SetBackdropColor(F.Color(color, 0.9))
        Bg: SetBackdropBorderColor(F.Color(color, 0.9))
	end)
	
	Dummy.Text = Text

    return Dummy
end

local function Quafe_InterfaceOptions()
	local QuafeInterfaceOptionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
	QuafeInterfaceOptionsFrame: SetSize(396,400)

	local LogoText = F.Create.Font(QuafeInterfaceOptionsFrame, "ARTWORK", C.Font.NumOW, 60, nil, C.Color.Y1,1)
	LogoText: SetPoint("TOPLEFT", QuafeInterfaceOptionsFrame, "TOPLEFT", 24,-28)
	LogoText: SetText("Quafe UI")
	LogoText: SetAlpha(1)

	local VersionText = F.Create.Font(QuafeInterfaceOptionsFrame, "ARTWORK", C.Font.NumOW, 22, nil, C.Color.W3,1)
	VersionText: SetPoint("BOTTOMLEFT", LogoText, "BOTTOMRIGHT", 30,14)
	local ver = gsub(C_AddOns.GetAddOnMetadata("Quafe", "Version"), "%d+%p", "") or ""
	VersionText: SetText("Version: "..ver)
	VersionText: SetAlpha(1)

	local Setupwizard_Button = Button_Template(QuafeInterfaceOptionsFrame, C.Color.Config.Bar2)
	Setupwizard_Button: SetPoint("TOP", QuafeInterfaceOptionsFrame, "CENTER", 0,-40)
	Setupwizard_Button.Text: SetText(L['OPEN_SETUP_WIZARD'])
	Setupwizard_Button: SetScript("OnClick", function(self, button)
		if Quafe_Setupwizard then
			--InterfaceOptionsFrameOkay_OnClick()
			HideUIPanel(SettingsPanel)
			Quafe_Setupwizard: Show()
		end
	end)

	local Settings_Button = Button_Template(QuafeInterfaceOptionsFrame, C.Color.Config.Bar2)
	Settings_Button: SetPoint("TOP", Setupwizard_Button, "BOTTOM", 0,-16)
	Settings_Button.Text: SetText(L['OPEN_CONFIG_FRAME'])
	Settings_Button: SetScript("OnClick", function(self, button)
		if Quafe_Config then
			--InterfaceOptionsFrameOkay_OnClick()
			HideUIPanel(SettingsPanel)
			Quafe_Config: Show()
		end
	end)

	local Options_Button = Button_Template(QuafeInterfaceOptionsFrame, C.Color.Config.Bar2)
	Options_Button: SetPoint("TOP", Settings_Button, "BOTTOM", 0,-16)
	Options_Button.Text: SetText(L['LOAD_CONFIG_FRAME'])
	Options_Button: SetScript("OnClick", function(self, button)
		if not IsAddOnLoaded("Quafe_Options") then
			LoadAddOn("Quafe_Options")
		end
	end)
	Options_Button: Hide()

	--QuafeInterfaceOptionsFrame: SetScript("OnShow", function(self)
		--if not IsAddOnLoaded("Quafe_Options") then
		--	LoadAddOn("Quafe_Options")
		--end
	--end)

	QuafeInterfaceOptionsFrame.name = "Quafe UI"
	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(QuafeInterfaceOptionsFrame)
	else
		local category, layout = Settings.RegisterCanvasLayoutCategory(QuafeInterfaceOptionsFrame, QuafeInterfaceOptionsFrame.name);
		--Settings.RegisterCanvasLayoutSubcategory(parentCategory, frame, name)
		Settings.RegisterAddOnCategory(category);
	end
end

local function Quafe_AddonCompartment()
	AddonCompartmentFrame:RegisterAddon({
		text = "Quafe UI",
		icon = F.Path("Minimap\\MinimapButton_Icon"),
		notCheckable = true,
		func = function()
			Quafe_Config: Show()
		end,
	})
end

local Init_Help = CreateFrame("Frame", nil, E)
Init_Help: RegisterEvent("ADDON_LOADED")
Init_Help: RegisterEvent("PLAYER_LOGIN")
Init_Help: SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == E.Name then
			Quafe_Init()
			local QE_Load,QE_Reason = C_AddOns.LoadAddOn("Quafe_Extra")
			local OW_Load,OW_Reason = C_AddOns.LoadAddOn("Quafe_Overwatch")
			local TI_Load,TI_Reason = C_AddOns.LoadAddOn("Quafe_TIE")
			local MK_Load,MK_Reason = C_AddOns.LoadAddOn("Quafe_MEKA")

			C.PlayerName = GetUnitName("player", false)
			C.PlayerClass = select(2, UnitClass("player"))
			C.PlayerRealm = GetRealmName()
			C.PlayerGuid = UnitGUID( "player")
			Quafe_Load()
			Quafe_InterfaceOptions()
			Quafe_AddonCompartment()
			self: UnregisterEvent(event)
		end
	elseif event == "PLAYER_LOGIN" then
		Quafe_Login()
	end
end)