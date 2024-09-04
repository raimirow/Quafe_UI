local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local tinsert = tinsert
local format = string.format
local floor = math.floor
local tan = math.tan
local rad = math.rad

----------------------------------------------------------------
--> Minimap
----------------------------------------------------------------

local TAN_4 = format("%.2f",tan(rad(4)))
local TAN_25 = format("%.2f",tan(rad(25)))

local NUM_40 = {
    [0] = {20,   2/512, 42/512},
    [1] = {16,  46/512, 78/512},
    [2] = {20,  90/512,130/512},
    [3] = {20, 134/512,174/512},
    [4] = {20, 178/512,218/512},
    [5] = {20, 222/512,262/512},
    [6] = {20, 266/512,306/512},
    [7] = {20, 310/512,350/512},
    [8] = {20, 354/512,394/512},
    [9] = {20, 398/512,438/512},
    ["%"] = {18, 442/512,478/512},
    ["N"] = {4, 511/512,512/512},
}

local function Minimap_Border(frame)
	local Bd = CreateFrame("Frame", nil, frame)
	Bd: SetSize(256,256)
	Bd: SetPoint("CENTER")

	local Bd1 = F.Create.Texture(Bd, "ARTWORK", 3, OW.Path("Minimap_Bd6"), C.Color.Main1, 1, {256,256})
	Bd1: SetPoint("CENTER")
	local Bd1Sd = F.Create.Texture(Bd, "BACKGROUND", 1, OW.Path("Minimap_Bd6Sd"), C.Color.Main0, 0.4, {256,256})
	Bd1Sd: SetPoint("CENTER")

	local Extra = F.Create.Texture(Bd, "ARTWORK", 1, OW.Path("Minimap_Bd7"), C.Color.Main0, 0.6, {256,256})
	Extra: SetPoint("CENTER")

	local ExtraBd = F.Create.Texture(Bd, "ARTWORK", 2, OW.Path("Minimap_Bd8"), C.Color.Main1, 0.4, {256,256})
	ExtraBd: SetPoint("CENTER")

	local Line1 = F.Create.Texture(Bd, "ARTWORK", 3, OW.Path("Minimap_Line1"), C.Color.Main1, 0.4, {32,8})
	Line1: SetPoint("CENTER", frame, "RIGHT", -45+6*TAN_25, 6)

	local Line2 = F.Create.Texture(Bd, "ARTWORK", 3, OW.Path("Minimap_Line1"), C.Color.Main1, 0.4, {32,8})
	Line2: SetPoint("CENTER", frame, "RIGHT", -45-18*TAN_25, -18)

	local Line3 = F.Create.Texture(Bd, "ARTWORK", 3, OW.Path("Minimap_Line1"), C.Color.Main1, 0.4, {32,8})
	Line3: SetPoint("CENTER", frame, "RIGHT", -45+30*TAN_25, 30)

	local Line4 = F.Create.Texture(Bd, "ARTWORK", 3, OW.Path("Minimap_Line1"), C.Color.Main1, 0.4, {32,8})
	Line4: SetPoint("CENTER", frame, "RIGHT", -45-42*TAN_25, -42)

	return Bd
end

local function Minimap_Anchor(frame)
	local Anchor = CreateFrame("Frame", nil, frame)
    Anchor: SetSize(36,64)

	local Bd1 = F.Create.Texture(Anchor, "ARTWORK", 1, OW.Path("Minimap_Bd1"), C.Color.Main3, 1, {36,64}, {2/256,74/256, 2/256,130/256})
	Bd1: SetPoint("CENTER")

	local Bd1Sd = F.Create.Texture(Anchor, "BACKGROUND", 1, OW.Path("Minimap_Bd1"), C.Color.Main0, 0.4, {36,64}, {78/256,150/256, 2/256,130/256})
	Bd1: SetPoint("CENTER")

	return Anchor
end

local function Minimap_Hold(frame)
	local Hold = CreateFrame("Frame", nil, frame)
	Hold: SetSize(256,256)
	Hold: SetFrameLevel(frame:GetFrameLevel())
	
	Minimap: SetSize(210,210)
	Minimap: SetHitRectInsets(0, 40, 0, 0);
	Minimap: SetFrameLevel(Hold:GetFrameLevel())
	Minimap: SetFrameStrata(Hold:GetFrameStrata())
	Minimap: SetParent(Hold)
	Minimap: ClearAllPoints()
	Minimap: SetPoint("CENTER", Hold, "CENTER", -16,16*TAN_4)
	Minimap: SetScale(1)
	Minimap: SetAlpha(1)
	--MinimapCluster: ClearAllPoints()
	--MinimapCluster: SetAllPoints(Minimap)

	Minimap: SetMaskTexture(OW.Path("MinimapMaskI"))
	Minimap: SetPlayerTexture(OW.Path("MinimapArrow"))
	if not F.IsClassic then
		Minimap: SetArchBlobRingScalar(0.6) --考古超出范围白圈
		Minimap: SetQuestBlobRingScalar(0.6) --任务超出范围白圈
		Minimap: SetTaskBlobRingScalar(0.6) --任务超出范围白圈
	end
	
	Minimap: SetScript("OnMouseUp", function(self, button)
		Minimap:StopMovingOrSizing()
		if (button == "LeftButton") then
			Minimap:OnClick()
		elseif (button == "RightButton") then	
 			if not F.IsClassic then
				--ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, -(Minimap:GetWidth()*1.2),(Minimap:GetHeight()*2))
			end
		elseif (button == "MiddleButton") then
			if not F.IsClassic then
				ToggleCalendar()
			end
		end
	end)
	
    F.Minimap_HideStuff()
    F.Minimap_MouseWheel()

	local Border_L = Minimap_Border(Hold)

	return Hold
end

local function MinimapButton_Template(frame)
	local Button = CreateFrame("Button", nil, frame, "OW_MinimapIconFlashTemplate")
	Button: SetSize(36,24)
	Button: SetFrameLevel(frame:GetFrameLevel()+2)

	local Icon = Button: CreateTexture(nil, "ARTWORK")
	Icon: SetVertexColor(F.Color(C.Color.Main1))
	Icon: SetAlpha(0.5)
	Icon: SetPoint("CENTER")

	Button: SetScript("OnEnter", function(self)
		self.Icon: SetAlpha(1)
	end)
	Button: SetScript("OnLeave", function(self)
		self.Icon: SetAlpha(0.5)
		GameTooltip:Hide();
	end)

	Button.Icon = Icon

	return Button
end

local function Mail_Template(frame)
	local Mail = MinimapButton_Template(frame)

	Mail.Icon: SetTexture(OW.Path("Minimap_Bd5"))
	Mail.Icon: SetSize(32,22)
	Mail.Icon: SetTexCoord(188/256,252/256, 1/128,45/128)

	Mail: RegisterEvent("UPDATE_PENDING_MAIL")
	Mail: RegisterEvent("PLAYER_ENTERING_WORLD")
	Mail: SetScript("OnEvent", function(self,event)
		if event == "PLAYER_ENTERING_WORLD" then
			self: UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
		if ( HasNewMail() ) then
			self.Flash: Play()
			--self.Icon: SetVertexColor(F.Color(C.Color.Main2))
			if( GameTooltip: IsOwned(self) ) then
				MinimapMailFrameUpdate()
			end
		else
			self.Flash: Stop()
			--self.Icon: SetVertexColor(F.Color(C.Color.Main1))
		end
	end)
	
	Mail: HookScript("OnEnter", function(self)
		GameTooltip: SetOwner(self, "ANCHOR_TOP")
		--self.Flash: Stop()
		if( GameTooltip:IsOwned(self) ) then
			if ( HasNewMail() ) then
				MinimapMailFrameUpdate()
			else
				GameTooltip: SetText(L['NO_MAIL'])
			end
		end
	end)

	return Mail
end

local function InstanceDifficulty_Template(frame)
	local Instance = MinimapButton_Template(frame)

	Instance.Icon: SetTexture(OW.Path("Minimap_Bd5"))
	Instance.Icon: SetSize(32,22)
	Instance.Icon: SetTexCoord(186/256,250/256, 47/128,91/128)

	local InstanceHold = CreateFrame("Frame", nil, Instance)
	InstanceHold: SetAllPoints(Instance)

	if not F.IsClassic then
		--QueueStatusButton
		--QueueStatusButtonIcon
		QueueStatusButton: SetParent(InstanceHold)
		QueueStatusButton: ClearAllPoints()
		QueueStatusButton.ClearAllPoints = function() end
		QueueStatusButton: SetPoint("CENTER", InstanceHold, "CENTER", 0, 0)
		QueueStatusButton: SetFrameStrata(InstanceHold:GetFrameStrata())
		QueueStatusButton: SetFrameLevel(InstanceHold:GetFrameLevel()+1)
		QueueStatusButton.SetPoint = function() end
		--QueueStatusButtonBorder: Hide()
		
		QueueStatusButton: SetHighlightTexture("") 
		QueueStatusButtonIcon: SetSize(32,32)
		QueueStatusButtonIcon.texture: SetTexture(OW.Path("InstanceEye"))
		QueueStatusButtonIcon.texture: SetVertexColor(F.Color(C.Color.Main2))
		
		--[[
		QueueStatusMinimapButton: SetParent(InstanceHold)
		QueueStatusMinimapButton: ClearAllPoints()
		QueueStatusMinimapButton.ClearAllPoints = function() end
		QueueStatusMinimapButton: SetPoint("CENTER", InstanceHold, "CENTER", 0, 0)
		QueueStatusMinimapButton: SetFrameStrata(InstanceHold:GetFrameStrata())
		QueueStatusMinimapButton: SetFrameLevel(InstanceHold:GetFrameLevel()+1)
		QueueStatusMinimapButton.SetPoint = function() end
		QueueStatusMinimapButtonBorder: Hide()
		
		QueueStatusMinimapButton: SetHighlightTexture("") 
		QueueStatusMinimapButtonIcon: SetSize(32,32)
		QueueStatusMinimapButtonIconTexture: SetTexture(OW.Path("InstanceEye"))
		QueueStatusMinimapButtonIconTexture: SetVertexColor(F.Color(C.Color.Main2))
		--]]
	end

	return Instance
end

--ExpansionLandingPageMinimapButton
local ExpansionLandingPageMode = {
	Garrison = 1,
	ExpansionOverlay = 2,
	MajorFactionRenown = 3,
}

local function Garrison_UpdateIcon(frame)
	frame.GarrisonType = C_Garrison.GetLandingPageGarrisonType();
	if (frame.GarrisonType == Enum.GarrisonType.Type_6_0_Garrison) then
		frame.title = GARRISON_LANDING_PAGE_TITLE;
		frame.description = MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP;
	elseif (frame.GarrisonType == Enum.GarrisonType.Type_7_0_Garrison) then
		frame.title = ORDER_HALL_LANDING_PAGE_TITLE;
		frame.description = MINIMAP_ORDER_HALL_LANDING_PAGE_TOOLTIP;
	elseif (frame.GarrisonType == Enum.GarrisonType.Type_8_0_Garrison) then
		frame.title = GARRISON_TYPE_8_0_LANDING_PAGE_TITLE;
		frame.description = GARRISON_TYPE_8_0_LANDING_PAGE_TOOLTIP;
	elseif (frame.GarrisonType == Enum.GarrisonType.Type_9_0_Garrison) then
		frame.title = GARRISON_TYPE_9_0_LANDING_PAGE_TITLE;
		frame.description = GARRISON_TYPE_9_0_LANDING_PAGE_TOOLTIP;
	end
end

local function Garrison_Template(frame)
	local Garrison = MinimapButton_Template(frame)
	Garrison.Icon: SetTexture(OW.Path("Minimap_Bd5"))
	Garrison.Icon: SetSize(32,22)
	Garrison.Icon: SetTexCoord(117/256,183/256, 67/128,111/128)

	if not F.IsClassic then
		--Garrison: HookScript("OnEnter", function(self)
		--	if self.title and self.description then
		--		GameTooltip:SetOwner(self, "ANCHOR_TOP");
		--		GameTooltip:SetText(self.title, 1, 1, 1);
		--		GameTooltip:AddLine(self.description, nil, nil, nil, true);
		--		GameTooltip:Show();
		--	end
		--end)

		Garrison: SetScript("OnClick", F.Minimap_Garrison_OnClick)
		
		Garrison: RegisterEvent("GARRISON_SHOW_LANDING_PAGE")
		Garrison: RegisterEvent("GARRISON_HIDE_LANDING_PAGE")
		Garrison: RegisterEvent("GARRISON_BUILDING_ACTIVATABLE")
		Garrison: RegisterEvent("GARRISON_BUILDING_ACTIVATED")
		Garrison: RegisterEvent("GARRISON_TALENT_COMPLETE")
		Garrison: RegisterEvent("GARRISON_ARCHITECT_OPENED")
		Garrison: RegisterEvent("GARRISON_MISSION_FINISHED")
		Garrison: RegisterEvent("GARRISON_MISSION_NPC_OPENED")
		Garrison: RegisterEvent("GARRISON_SHIPYARD_NPC_OPENED")
		Garrison: RegisterEvent("GARRISON_INVASION_AVAILABLE")
		Garrison: RegisterEvent("GARRISON_INVASION_UNAVAILABLE")
		Garrison: RegisterEvent("SHIPMENT_UPDATE")
		Garrison: SetScript("OnEvent", function(self, event, ...)
			if (event == "GARRISON_HIDE_LANDING_PAGE") then
				--self.Flash: Show()
				--Garrison_UpdateIcon(self)
			elseif (event == "GARRISON_SHOW_LANDING_PAGE") then
				Garrison_UpdateIcon(self)
				self.Flash: Stop()
			elseif ( event == "GARRISON_BUILDING_ACTIVATABLE" ) then
				self.Flash: Play()
			elseif ( event == "GARRISON_BUILDING_ACTIVATED" or event == "GARRISON_ARCHITECT_OPENED") then
				self.Flash: Stop()
			elseif ( event == "GARRISON_TALENT_COMPLETE") then
				self.Flash: Play()
			elseif ( event == "GARRISON_MISSION_FINISHED" ) then
				self.Flash: Play()
			elseif ( event == "GARRISON_MISSION_NPC_OPENED" ) then
				self.Flash: Stop()
			elseif ( event == "GARRISON_SHIPYARD_NPC_OPENED" ) then
				self.Flash: Stop()
			elseif (event == "GARRISON_INVASION_AVAILABLE") then
				self.Flash: Play()
			elseif (event == "GARRISON_INVASION_UNAVAILABLE") then
				self.Flash: Stop()
			elseif (event == "SHIPMENT_UPDATE") then
				local shipmentStarted, isTroop = ...
				if (shipmentStarted) then
					self.Flash: Play()
				end
			end
		end)

		--hooksecurefunc("GarrisonMinimap_ClearPulse", function()
		--	Garrison.Flash: Stop()
		--end)
	end

	return Garrison
end

----------------------------------------------------------------
--> Instance/Guild Difficulty
----------------------------------------------------------------

----------------------------------------------------------------
--> Icon Hold
----------------------------------------------------------------

----------------------------------------------------------------
--> Icons
----------------------------------------------------------------

----------------------------------------------------------------
--> Minimap Frame
----------------------------------------------------------------

local function Minimap_Frame(frame)
    local Anchor = Minimap_Anchor(frame)
    --Anchor: SetPoint("RIGHT", frame, "RIGHT", 22,-16)
	Anchor: SetPoint("RIGHT", frame, "RIGHT", 22,-16)

	local MapHold = Minimap_Hold(frame)
	MapHold: SetPoint("CENTER", frame, "CENTER", -50,50*TAN_4-6)

	local MailButton = Mail_Template(frame)
	MailButton: SetPoint("CENTER", MapHold, "RIGHT", -45+18*TAN_25, 18)

	local InstanceButton = InstanceDifficulty_Template(frame)
	InstanceButton: SetPoint("CENTER", MapHold, "RIGHT", -45-6*TAN_25, -6)

	local GarrisonButton = Garrison_Template(frame)
	GarrisonButton: SetPoint("CENTER", MapHold, "RIGHT", -45-30*TAN_25, -30)

	local DungeonDifficulty = F.DungeonDifficulty_Template(Anchor)
	DungeonDifficulty: SetPoint("BOTTOMRIGHT", MapHold, "TOPLEFT", -10, -30)
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local OW_MinimapFrame = CreateFrame("Frame", "Quafe_Overwatch.MinimapFrame", E)
OW_MinimapFrame: SetSize(156,170)
OW_MinimapFrame: SetFrameStrata("LOW")
OW_MinimapFrame.Init = false

F.OW_MinimapFrame_Pos = function(x,y)
	if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame and Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer then
		OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -x,y)
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosX = -x
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosY = y
	end
end

local function Joystick_Update(self, elapsed)
	local x2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosX
	local y2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosY
	local x0,y0 = OW_MinimapFrame: GetCenter()
	local x1,y1 = self: GetCenter()
	local step = floor(1/(GetFramerate())*1e3)/1e3
	if x0 ~= x1 then
		x2 = x2 + (x1-x0)*step/2
	end
	if y0 ~= y1 then
		y2 = y2 + (y1-y0)*step/2
	end
	if not Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer then
		OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", x2,y2)
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosX = x2
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosY = y2
	end
end

local function OW_MinimapFrame_Load()
	local DataBase = Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame
	if DataBase.Enable then
		OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", DataBase.PosX,DataBase.PosY)
		F.CreateJoystick(OW_MinimapFrame, 156,170, "Quafe_Overwatch "..L['MINI_MAP'])
		OW_MinimapFrame.Joystick.postUpdate = Joystick_Update

    	Minimap_Frame(OW_MinimapFrame)
		SetCVar("rotateMinimap", 0) --旋转小地图

		if DataBase.Scale then
			OW_MinimapFrame: SetScale(DataBase.Scale)
		end
		if DataBase.SyncPlayer and Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
			OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosY)
			OW_MinimapFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale)
		end

		OW_MinimapFrame.Init = true
	end
end

local function OW_MinimapFrame_Toggle(arg1, arg2)
	if arg1 == "ON" then
		if not OW_MinimapFrame.Init then
			OW_MinimapFrame_Load()
		end
		if not OW_MinimapFrame:IsShown() then
			OW_MinimapFrame: Show()
		end
	elseif arg1 == "OFF" then
		OW_MinimapFrame: Hide()
		Quafe_NoticeReload()
	elseif arg1 == "Scale" then
		if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer and Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
			OW_MinimapFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale)
		else
			OW_MinimapFrame: SetScale(arg2)
		end
	elseif arg1 == "Sync" then
		if arg2 == "ON" then
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
				OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosY)
				OW_MinimapFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale)
			end
		elseif arg2 == "OFF" then
			OW_MinimapFrame: SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.PosY)
			OW_MinimapFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Scale)
		end
	end
end

local OW_MinimapFrame_Config = {
	Database = {
		["OW_MinimapFrame"] = {
			["Enable"] = true,
			["Size"] = "M",
			["Minimize"] = false,
			["PosX"] = -100,
			["PosY"] = 60,
			Scale = 1,
			SyncPlayer = true,
		},
	},

	Config = {
		Name = "Overwatch "..L['MINI_MAP'],
		Type = "Switch",
		Click = function(self, button)
			if InCombatLockdown() then return end
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = false
				self.Text:SetText(L["OFF"])
				OW_MinimapFrame_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = true
				self.Text:SetText(L["ON"])
				OW_MinimapFrame_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
                Name = L['SCALE'],
                Type = "Slider",
                State = "ALL",
				Click = nil,
                Load = function(self)
                    self.Slider: SetMinMaxValues(0.5, 2)
					self.Slider: SetValueStep(0.05)
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
						OW_MinimapFrame_Toggle("Scale", value)
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Scale = value
					end)
                end,
                Show = nil,
            },
			[2] = {
                Name = L['SYNC_WITH_PLAYERFRAME'],
                Type = "Switch",
                Click = function(self, button)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer = false
                        self.Text:SetText(L["OFF"])
                        OW_MinimapFrame_Toggle("Sync", "OFF")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer = true
                        self.Text:SetText(L["ON"])
                        OW_MinimapFrame_Toggle("Sync", "ON")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.SyncPlayer then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
		},
	},
}

OW_MinimapFrame.Load = OW_MinimapFrame_Load
OW_MinimapFrame.Config = OW_MinimapFrame_Config
tinsert(E.Module, OW_MinimapFrame)