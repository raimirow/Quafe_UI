local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

--- ------------------------------------------------------------
--> API Localization
--- ------------------------------------------------------------

local _G = getfenv(0)

local LibCastClassic = F.IsClassic and LibStub and LibStub('LibClassicCasterino', true)
--> LibCastClassic:UnitCastingInfo(unit)
--> LibCastClassic:UnitChannelInfo(unit)

local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
if F.IsClassic then
    UnitCastingInfo = CastingInfo
    UnitChannelInfo = ChannelInfo
end

----------------------------------------------------------------
--> CastBar
----------------------------------------------------------------

local function CastBar_FinishSpell(frame)
	frame.ApplyColor(frame, "Finished")
	frame.Flash = true;
	frame.FadeOut = true;
	frame.Casting = nil;
	frame.Channeling = nil;
end

local function CastBar_OnEvent(frame, event, ...)
	if frame.ApplyEvent then
		frame.ApplyEvent(frame, event, ...)
	end

	local arg1 = ...;
	local unit = frame.Unit;

	if ( event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" ) then
		local nameSpell, nameChannel
		if F.IsClassic then
			nameChannel = LibCastClassic:UnitChannelInfo(unit);
			nameSpell = LibCastClassic:UnitCastingInfo(unit);
		else
			nameChannel = UnitChannelInfo(unit);
			nameSpell = UnitCastingInfo(unit);
		end
		if ( nameChannel ) then
			event = "UNIT_SPELLCAST_CHANNEL_START";
			arg1 = unit;
		elseif ( nameSpell ) then
			event = "UNIT_SPELLCAST_START";
			arg1 = unit;
		else
		    CastBar_FinishSpell(frame);
		end
	end

	if ( arg1 ~= unit ) then
		return;
	end

	if ( event == "UNIT_SPELLCAST_START" ) then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID
		if F.IsClassic and LibCastClassic then
			name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = LibCastClassic:UnitCastingInfo(unit);
		else
			name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo(unit);
		end
		if ( not name or (not frame.ShowTradeSkills and isTradeSkill)) then
			frame:Hide();
			return;
		end
		frame.ApplyColor(frame, "Start", notInterruptible)
		frame.Value = (GetTime() - (startTime / 1000));
		frame.MaxValue = (endTime - startTime) / 1000;
		if ( frame.Text ) then
			text = text or name
			frame.Text:SetText(text)
		end
		if ( frame.Icon ) then
			frame.Icon: SetTexture(texture)
		end
		frame.ApplyUpdate(frame)
		frame.ApplyAlpha(frame, 1.0)

		frame.HoldTime = 0;
		frame.Casting = true;
		frame.CastID = castID;
		frame.Channeling = nil;
		frame.FadeOut = nil;

		if ( frame.ShowCastbar and frame.EnableCastbar ) then
			frame:Show();
		end

	elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		if ( not frame:IsVisible() ) then
			frame:Hide();
		end
		if ( (frame.Casting and event == "UNIT_SPELLCAST_STOP" and select(4, ...) == frame.CastID) or (frame.Channeling and event == "UNIT_SPELLCAST_CHANNEL_STOP") ) then
			frame.ApplyUpdate(frame, 1)
			if ( event == "UNIT_SPELLCAST_STOP" ) then
				frame.Casting = nil;
				frame.ApplyColor(frame, "Finished")
			else
				frame.Channeling = nil;
			end
			frame.Flash = true;
			frame.FadeOut = true;
			frame.HoldTime = 0;
		end
	
	elseif ( event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" ) then
		if ( frame:IsShown() and (frame.Casting and select(2, ...) == frame.CastID) and not frame.FadeOut ) then
			frame.ApplyUpdate(frame, 1)
			frame.ApplyColor(frame, "Failed")
			if ( frame.Text ) then
				if ( event == "UNIT_SPELLCAST_FAILED" ) then
					frame.Text:SetText(FAILED);
				else
					frame.Text:SetText(INTERRUPTED);
				end
			end
			frame.Casting = nil;
			frame.Channeling = nil;
			frame.FadeOut = true;
			frame.HoldTime = GetTime() + CASTING_BAR_HOLD_TIME;
		end
	elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then
		if ( frame:IsShown() ) then
			local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible
			if F.IsClassic and LibCastClassic then
				name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = LibCastClassic:UnitCastingInfo(unit);
			else
				name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
			end
			if ( not name or (not frame.showTradeSkills and isTradeSkill)) then
				-- if there is no name, there is no bar
				frame:Hide();
				return;
			end
			frame.Value = (GetTime() - (startTime / 1000));
			frame.MaxValue = (endTime - startTime) / 1000;
			frame.ApplyUpdate(frame)
			if ( not frame.Casting ) then
				frame.ApplyColor(frame, "Start", notInterruptible)
				frame.Casting = true;
				frame.Channeling = nil;
				frame.Flash = nil;
				frame.FadeOut = nil;
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID
		if F.IsClassic and LibCastClassic then
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = LibCastClassic:UnitChannelInfo(unit);
		else
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo(unit);
		end
		if ( not name or (not frame.showTradeSkills and isTradeSkill)) then
			-- if there is no name, there is no bar
			frame:Hide();
			return;
		end
		frame.ApplyColor(frame, "Start", notInterruptible)
		frame.Value = (endTime / 1000) - GetTime();
		frame.MaxValue = (endTime - startTime) / 1000;
		frame.ApplyUpdate(frame)
		if ( frame.Text ) then
			text = text or name
			frame.Text:SetText(text);
		end
		if ( frame.Icon ) then
			frame.Icon:SetTexture(texture);
		end
		frame.ApplyAlpha(frame, 1.0)
		frame.HoldTime = 0;
		frame.Casting = nil;
		frame.Channeling = true;
		frame.FadeOut = nil;
		if ( frame.ShowCastbar and frame.EnableCastbar ) then
			frame:Show();
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
		if ( frame:IsShown() ) then
			local name, text, texture, startTime, endTime, isTradeSkill
			if F.IsClassic and LibCastClassic then
				name, text, texture, startTime, endTime, isTradeSkill = LibCastClassic:UnitChannelInfo(unit);
			else
				name, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);
			end
			if ( not name or (not frame.showTradeSkills and isTradeSkill)) then
				-- if there is no name, there is no bar
				frame:Hide();
				return;
			end
			frame.Value = ((endTime / 1000) - GetTime());
			frame.MaxValue = (endTime - startTime) / 1000;
			frame.ApplyUpdate(frame)
		end
	elseif ( event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" ) then
		if ( frame.Casting or frame.Channeling ) then
			frame.ApplyColor(frame, "Start", event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local function CastBar_OnUpdate(frame, elapsed)
	if ( frame.Casting ) then
		frame.Value = frame.Value + elapsed;
		if ( frame.Value >= frame.MaxValue ) then
			frame.ApplyUpdate(frame, 1)
			CastBar_FinishSpell(frame)
			return
		end
		frame.ApplyUpdate(frame)
	elseif ( frame.Channeling ) then
		frame.Value = frame.Value - elapsed;
		if ( frame.Value <= 0 ) then
			CastBar_FinishSpell(frame)
			return
		end
		frame.ApplyUpdate(frame)
	elseif ( GetTime() < frame.HoldTime ) then
		return
	--elseif ( frame.Flash ) then
		--
	elseif ( frame.FadeOut ) then
		local alpha = frame:GetAlpha() - CASTING_BAR_ALPHA_STEP;
		if ( alpha > 0 ) then
			frame.ApplyAlpha(frame, alpha);
		else
			frame.FadeOut = nil;
			frame:Hide();
		end
	end
end

local function CastBar_OnShow(frame)
	if ( frame.Unit ) then
		local name, text, texture, startTime, endTime
		if ( frame.Casting ) then
			if F.IsClassic and LibCastClassic then
				name, text, texture, startTime, endTime = LibCastClassic:UnitCastingInfo(frame.Unit);
			else
				name, text, texture, startTime, endTime = UnitCastingInfo(frame.Unit);
			end
			if ( startTime ) then
				frame.Value = (GetTime() - (startTime / 1000));
			end
		else
			if F.IsClassic and LibCastClassic then
				name, text, texture, startTime, endTime = LibCastClassic:UnitChannelInfo(frame.Unit);
			else
				name, text, texture, startTime, endTime = UnitChannelInfo(frame.Unit);
			end
			if ( endTime ) then
				frame.Value = ((endTime / 1000) - GetTime());
			end
		end
	end
end

local function CastBar_SetUnit(frame)
	frame.Casting = nil
	frame.Channeling = nil
	frame.HoldTime = 0
	frame.FadeOut = nil

	if frame.Unit then
		if LibCastClassic then
			local CastbarEventHandler = function(event, ...)
				return CastBar_OnEvent(frame, event, ...)
			end

			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_START', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_DELAYED', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_STOP', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_FAILED', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_INTERRUPTED', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_START', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_UPDATE', CastbarEventHandler)
			LibCastClassic.RegisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_STOP', CastbarEventHandler)
		else
			frame: RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			frame: RegisterEvent("UNIT_SPELLCAST_DELAYED");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			if not F.IsClassic then
				frame: RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
				frame: RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			end
			frame: RegisterEvent("PLAYER_ENTERING_WORLD");
			frame: RegisterUnitEvent("UNIT_SPELLCAST_START", frame.Unit);
			frame: RegisterUnitEvent("UNIT_SPELLCAST_STOP", frame.Unit);
			frame: RegisterUnitEvent("UNIT_SPELLCAST_FAILED", frame.Unit);
		end
	else
		if LibCastClassic then
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_START')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_DELAYED')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_STOP')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_FAILED')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_INTERRUPTED')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_START')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_UPDATE')
			LibCastClassic.UnregisterCallback(frame, 'UNIT_SPELLCAST_CHANNEL_STOP')
		else
			frame: UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			frame: UnregisterEvent("UNIT_SPELLCAST_DELAYED");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			if not F.IsClassic then
				frame: UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
				frame: UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			end
			frame: UnregisterEvent("PLAYER_ENTERING_WORLD");
			frame: UnregisterEvent("UNIT_SPELLCAST_START");
			frame: UnregisterEvent("UNIT_SPELLCAST_STOP");
			frame: UnregisterEvent("UNIT_SPELLCAST_FAILED");
		end
		frame: Hide()
	end
end

local function CastBar_OnLoad(frame)
	CastBar_SetUnit(frame)
	if not frame.ShowTradeSkills then
		frame.ShowTradeSkills = false
	end
	frame: SetScript("OnEvent", function(self, event, ...)
		CastBar_OnEvent(self, event, ...)
	end)
	frame: SetScript("OnUpdate", function(self, elapsed)
		CastBar_OnUpdate(self, elapsed)
	end)
	frame: SetScript("OnShow", function(self)
		CastBar_OnShow(self)
	end)
	frame: Hide()
end

function F.CastBar_Create(frame)
	CastBar_OnLoad(frame)
end

--[[
local CAST_COLOR = {
	Cast = C.Color.Blue,
	Shield = C.Color.Yellow,
	Stop = C.Color.Green,
	Fail = C.Color.Red,
}
--]]


----------------------------------------------------------------
--> CastBar Classic
----------------------------------------------------------------
--[[
local CastBarClassic_SetUnit = function(frame)
	frame.Casting = nil
	frame.Channeling = nil
	frame.HoldTime = 0
	frame.FadeOut = nil
end

local CastBarClassic_GetSpellInfo = function(frame, spellName)
	local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellName)
	return icon, castTime, spellID
end

local CastBarClassic_OnEvent = function(frame, eventParam, sourceGUID, spellName)
	if eventParam == "SPELL_CAST_START" then

	elseif eventParam == "SPELL_CAST_SUCCESS" then

	elseif eventParam == "SPELL_CAST_FAILED" then

	elseif eventType == "SPELL_INTERRUPT" or eventType == "PARTY_KILL" or eventType == "UNIT_DIED" then

	end
end

F.CastBarClassic_Create = function(frame)

end
--]]