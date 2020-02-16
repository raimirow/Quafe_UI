local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)

----------------------------------------------------------------
--> Minimap
----------------------------------------------------------------

F.Minimap_HideStuff = function()
	local dummy = function() end

	local frames_Retail = {
		--"MiniMapVoiceChatFrame",
		--"MiniMapWorldMapButton",
		"MinimapZoneTextButton",
		--"MiniMapTrackingButton",
		"MiniMapMailFrame",
		"MiniMapMailBorder",
		"MiniMapInstanceDifficulty",
		"MinimapNorthTag",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBackdrop",
		"GameTimeFrame",
		"GuildInstanceDifficulty",
		"MinimapBorderTop",
		--"MinimapBorder",
		"MinimapBackdrop",

	}

	local frames_Classic = {
		"MinimapZoneTextButton",
		"MiniMapMailFrame",
		"MiniMapMailBorder",
		"MinimapNorthTag",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBackdrop",
		"GameTimeFrame",
		"MinimapBorderTop",
		"MinimapBackdrop",
		"MinimapToggleButton",
	}

	local frames = F.IsClassic and frames_Classic or frames_Retail
	for i in pairs(frames) do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = dummy
	end

	GameTimeFrame:SetAlpha(0)
	GameTimeFrame:EnableMouse(false)
	
	LoadAddOn("Blizzard_TimeManager")
	TimeManagerClockButton.Show = TimeManagerClockButton.Hide
	TimeManagerClockButton:Hide()
end

F.Minimap_MouseWheel = function()
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, d)
		local Zoom,maxZoom = Minimap:GetZoom(),(Minimap:GetZoomLevels()-1)
		if d > 0 then
			if Zoom < maxZoom then
				Minimap:SetZoom((Zoom+1 >= maxZoom and maxZoom) or Zoom+1)
				PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN);
			end
		elseif d < 0 then
			if Zoom > 0 then
				Minimap:SetZoom((Zoom-1 <= 0 and 0) or Zoom-1)
				PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT);
			end
		end
	end)
end

local Minimap_ButtonFilter = {
	"MiniMapTracking", "MiniMapTrackingButton", "MiniMapTrackingDropDownButton",
	"MiniMapVoiceChatFrame", "MiniMapVoiceChatDropDownButton",
	"MiniMapWorldMapButton",
	"QueueStatusMinimapButton", "QueueStatusMinimapButtonDropDownButton",
	"MinimapZoomIn", "MinimapZoomOut",
	"MiniMapMailFrame",
	"MiniMapBattlefieldFrame",
	"GameTimeFrame",
	"FeedbackUIButton",
	
	"MinimapBackdrop",	
	"TimeManagerClockButton",
	"GarrisonLandingPageMinimapButton"
}

local Miniamp_SpecButtonList = {
	"BagSync_MinimapButton",
	"LSItemTrackerMinimapButton",
}

local function MBC_IsMinimapButton(frame)
	local name = frame:GetName()
	local type = frame:GetObjectType()
	if name and (type == "Button") and frame:HasScript("OnClick") and frame:GetNumRegions() >= 3 then
	--if frame and frame:GetObjectType() == "Button" and frame:GetNumRegions() >= 3 then
		return true
	end
end

local function MBC_AddButton(frame, button)
	if button:GetParent() ~= frame then
		button:SetParent(frame)
	end
end

local function MBC_AddSpecButtons(frame)
	for k,v in ipairs(Miniamp_SpecButtonList) do
		button = _G[v]
		if button then
			button.Name = v
			if v == "BagSync_MinimapButton" then
				button.Icon = _G.bgMinimapButtonTexture
			end
			MBC_AddButton(frame, button)
		end
	end
end

F.FindMinimapButtons = function(hold, frame)
	if frame then
		for i, child in ipairs({frame:GetChildren()}) do
			child.Name = child:GetName()
			local parent = child:GetParent()
			local parentname = parent:GetName()
			local filter = nil
			for j = 1, #Minimap_ButtonFilter do
				if (child.Name  == Minimap_ButtonFilter[j]) or (parentname == Minimap_ButtonFilter[j]) then
					filter = true
				end
			end
			if MBC_IsMinimapButton(child) and parentname == "Minimap" and (not filter) then
				MBC_AddButton(hold, child)
			else
				F.FindMinimapButtons(hold, child)
			end	
		end

	end
end

F.Minimap_CollectButtons = function(frame)
	F.FindMinimapButtons(frame, Minimap)
	MBC_AddSpecButtons(frame)
end

----------------------------------------------------------------
--> Dungeon Difficulty
----------------------------------------------------------------

local IS_GUILD_GROUP;

local function DungeonDifficulty_Artwork(frame)
	local Border = frame:CreateTexture(nil, "ARTWORK")
	Border: SetTexture(F.Path("StatusBar\\Raid"))
	Border: SetSize(6,36)
	Border: SetPoint("LEFT", frame, "LEFT", 10,0)

	local Text1 = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, nil,1, {1,-1}, "LEFT", "CENTER")
	Text1: SetAlpha(1)
	Text1: SetPoint("BOTTOMLEFT", Border, "RIGHT", 10,-1)

	local Text2 =  F.Create.Font(frame, "ARTWORK", C.Font.Txt, 12, nil, C.Color.W3,1, nil,1, {1,-1}, "LEFT", "CENTER")
	Text2: SetAlpha(0)
	Text2: SetPoint("TOPLEFT", Border, "RIGHT", 10,-3)

	local Text3 =  F.Create.Font(frame, "ARTWORK", C.Font.Txt, 12, nil, C.Color.W3,1, nil,1, {1,-1}, "LEFT", "CENTER")
	Text3: SetAlpha(1)
	Text3: SetPoint("TOPLEFT", Border, "RIGHT", 12,-3)
	Text3: SetText("XY ")

	local Text4 =  F.Create.Font(frame, "ARTWORK", C.Font.Txt, 12, nil, C.Color.W3,1, nil,1, {1,-1}, "LEFT", "CENTER")
	Text4: SetAlpha(1)
	Text4: SetPoint("LEFT", Text3, "RIGHT", 0,0)

	frame.Text1 = Text1
	frame.Text2 = Text2
	frame.Text3 = Text3
	frame.Text4 = Text4
end

local function Location_Update(frame)
	local minimapzone = GetMinimapZoneText()
	frame.Text1: SetText(minimapzone)

	local pvpType, isSubZonePvP, factionName = GetZonePVPInfo();
	if ( pvpType == "sanctuary" ) then
		frame.Text1:SetTextColor(0.41, 0.8, 0.94);
	elseif ( pvpType == "arena" ) then
		frame.Text1:SetTextColor(1.0, 0.1, 0.1);
	elseif ( pvpType == "friendly" ) then
		frame.Text1:SetTextColor(0.1, 1.0, 0.1);
	elseif ( pvpType == "hostile" ) then
		frame.Text1:SetTextColor(1.0, 0.1, 0.1);
	elseif ( pvpType == "contested" ) then
		frame.Text1:SetTextColor(1.0, 0.7, 0.0);
	else
		frame.Text1:SetTextColor(F.Color(C.Color.W3));
	end
end

local function GetPlayerMapPos(mapID)
	--local px, py = C_Map.GetPlayerMapPosition(mapID, "player"):GetXY()
	if mapID then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		if position then
			return position.x*100, position.y*100
		else
			return 0, 0
		end
	else
		return 0, 0
	end
end

local function MapPos_Update(frame)
	----local px,py = GetPlayerMapPosition("player")
	local PlayerUiMapID = C_Map.GetBestMapForUnit("player")
	frame.Text3:SetText(format("XY   %.1f , %.1f", GetPlayerMapPos(PlayerUiMapID)))
end

local function Difficulty_Update(frame)
	local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
	if instanceType and instanceType ~= "none" then
		if not frame.ShowDifficulty then
			frame.ShowDifficulty = true
			frame.Text2: SetAlpha(1)
			frame.Text3: SetAlpha(0)
		end
		frame.Text2: SetText(difficultyName)
	elseif frame.ShowDifficulty then
		frame.ShowDifficulty = false
		frame.Text2: SetAlpha(0)
		frame.Text3: SetAlpha(1)
	end
end

local function DungeonDifficulty_OnEvent(frame, event, ...)
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
		Location_Update(frame)
	elseif ( event == "GUILD_PARTY_STATE_UPDATED" ) then
		local isGuildGroup = ...;
		if ( isGuildGroup ~= IS_GUILD_GROUP ) then
			IS_GUILD_GROUP = isGuildGroup;
			Difficulty_Update(frame);
		end
	elseif ( event == "PLAYER_DIFFICULTY_CHANGED") then
		Difficulty_Update(frame)
	elseif ( event == "UPDATE_INSTANCE_INFO" or event == "INSTANCE_GROUP_SIZE_CHANGED" ) then
		--RequestGuildPartyState();
		Difficulty_Update(frame)
	elseif ( event == "PLAYER_GUILD_UPDATE" ) then
		local tabard = GuildInstanceDifficulty;
		--SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background, tabard.border);
		if ( IsInGuild() ) then
			--RequestGuildPartyState();
		else
			IS_GUILD_GROUP = nil;
			Difficulty_Update(frame)
		end
	else
		--RequestGuildPartyState();
		Location_Update(frame)
	end
end

local function DungeonDifficulty_RgEvent(frame)
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ZONE_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	if not F.IsClassic then
		frame:RegisterEvent("PLAYER_DIFFICULTY_CHANGED");
	end
	frame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED");
	frame:RegisterEvent("UPDATE_INSTANCE_INFO");
	frame:RegisterEvent("GROUP_ROSTER_UPDATE");
	frame:RegisterEvent("PLAYER_GUILD_UPDATE");
	frame:RegisterEvent("PARTY_MEMBER_ENABLE");
	frame:RegisterEvent("PARTY_MEMBER_DISABLE");
	frame:RegisterEvent("GUILD_PARTY_STATE_UPDATED");
end

local function DungeonDifficulty_OnShow(frame)
	Location_Update(frame)
	MapPos_Update(frame)
	Difficulty_Update(frame)
	if frame.ShowDifficulty then return end
	local last = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		if last >= elapsed*5 then
			last = 0
			MapPos_Update(frame)
		else
			last = last + elapsed
		end
	end)
end

local function DungeonDifficulty_OnHide(frame)
	frame:SetScript("OnUpdate", nil)
end

F.DungeonDifficulty_Template = function(frame)
	local DungeonDifficulty = CreateFrame("Frame", nil, frame)
	DungeonDifficulty: SetSize(200, 54)
	DungeonDifficulty: Hide()
	local Backdrop = F.Create.Backdrop(DungeonDifficulty, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)

	DungeonDifficulty: SetScript("OnEvent", DungeonDifficulty_OnEvent)
	DungeonDifficulty: SetScript("OnShow", DungeonDifficulty_OnShow)
	DungeonDifficulty: SetScript("OnHide", DungeonDifficulty_OnHide)

	DungeonDifficulty_Artwork(DungeonDifficulty)
	DungeonDifficulty_RgEvent(DungeonDifficulty)

	Minimap: HookScript("OnEnter", function(...)
		DungeonDifficulty: Show()
	end)

	Minimap: HookScript("OnLeave", function(...)
		DungeonDifficulty: Hide()
	end)

	return DungeonDifficulty
end