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