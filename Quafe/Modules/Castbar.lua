local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

--- ------------------------------------------------------------
--> API and Variable
--- ------------------------------------------------------------

local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad

--- ------------------------------------------------------------
--> Castbar
--- ------------------------------------------------------------

local CAST_COLOR = {
	Cast = C.Color.Blue,
	Stop = C.Color.Green,
	Shield = C.Color.Yellow,
	Fail = C.Color.Red,
}

local function CastBar_FinishSpell(frame)
	--[[
	if not self.finishedColorSameAsStart then
		self:SetStatusBarColor(self.finishedCastColor:GetRGB());
	end
	if ( self.Spark ) then
		self.Spark:Hide();
	end
	if ( self.Flash ) then
		self.Flash:SetAlpha(0.0);
		self.Flash:Show();
	end
	--]]
	self.Flash = true;
	self.FadeOut = true;
	self.Casting = nil;
	self.Channeling = nil;
end

local function CastBar_OnEvent(frame, event, ...)
	local arg1 = ...;
	local unit = frame.Unit;

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		local nameChannel = UnitChannelInfo(unit);
		local nameSpell = UnitCastingInfo(unit);
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
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
		if ( not name or (not frame.ShowTradeSkills and isTradeSkill)) then
			frame:Hide();
			return;
		end

		frame.Value = (GetTime() - (startTime / 1000));
		frame.MaxValue = (endTime - startTime) / 1000;

		frame.HoldTime = 0;
		frame.Casting = true;
		frame.CastID = castID;
		frame.Channeling = nil;
		frame.FadeOut = nil;

		if ( frame.ShowCastbar ) then
			frame:Show();
		end

	elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		if ( not frame:IsVisible() ) then
			frame:Hide();
		end
		if ( (frame.Casting and event == "UNIT_SPELLCAST_STOP" and select(4, ...) == frame.CastID) or
		     (frame.Channeling and event == "UNIT_SPELLCAST_CHANNEL_STOP") ) then
			--frame:SetValue(frame.MaxValue);
			if ( event == "UNIT_SPELLCAST_STOP" ) then
				frame.Casting = nil;
			else
				frame.Channeling = nil;
			end
			frame.Flash = true;
			frame.FadeOut = true;
			frame.HoldTime = 0;
		end
	
	elseif ( event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" ) then

	elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then

	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then

	elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then

	elseif ( event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" ) then

	end

	
end

local function CastBar_OnUpdate(frame, elapsed)
	if ( frame.Casting ) then
		frame.Value = frame.Value + elapsed;
		if ( frame.Value >= frame.MaxValue ) then
			--
			return
		end
		--
	elseif ( frame.Channeling ) then
		frame.Value = frame.Value - elapsed;
		if ( frame.Value <= 0 ) then
			--
			return
		end
		--
	elseif ( GetTime() < frame.HoldTime ) then
		return
	elseif ( frame.Flash ) then
		--
	elseif ( frame.FadeOut ) then
		--
	end
end

local function CastBar_SetUnit(frame, unit)
	if self.Unit ~= unit then
		self.Unit = unit

		self.Casting = nil
		self.Channeling = nil
		self.HoldTime = 0
		self.FadeOut = nil

		if unit then
			frame: RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			frame: RegisterEvent("UNIT_SPELLCAST_DELAYED");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			frame: RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			frame: RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
			frame: RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			frame: RegisterEvent("PLAYER_ENTERING_WORLD");
			frame: RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
			frame: RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
			frame: RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
		else
			frame: UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			frame: UnregisterEvent("UNIT_SPELLCAST_DELAYED");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			frame: UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			frame: UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
			frame: UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			frame: UnregisterEvent("PLAYER_ENTERING_WORLD");
			frame: UnregisterEvent("UNIT_SPELLCAST_START");
			frame: UnregisterEvent("UNIT_SPELLCAST_STOP");
			frame: UnregisterEvent("UNIT_SPELLCAST_FAILED");

			frame: Hide()
		end
	end
end

function F.CastBar_Create(frame)
	local CastBar = CreateFrame("Frame", nil, frame)
	
end