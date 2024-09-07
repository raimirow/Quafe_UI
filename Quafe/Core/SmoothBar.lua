local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Local

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad

local Lerp = Lerp
local next = next

--> Credit: ls- (lightspark)
local SmoothObjects = {}
local HandledObjects = {}
local TARGET_FPS = 60
local FPS_RATE = 1.5
--local AMOUNT = 0.33
local AMOUNT = 0.1

----------------------------------------------------------------
--> Function
----------------------------------------------------------------

local function clamp(value, min_value, max_value)
	if value > max_value then
		return max_value
	elseif value < min_value then
		return min_value
	end

	return value
end

local function isCloseEnough(new, target, range)
	if range > 0 then
		return abs((new - target) / range) <= 0.001
	end

	return true
end

local SmoothBackground = CreateFrame("Frame", nil, UIParent)
local LAST = 0
local function SmoothBackground_Update(self, elapsed)
	LAST = LAST + elapsed
	if LAST >= FPS_RATE * elapsed then
		for object, target in next, SmoothObjects do
			local new = Lerp(object._Value, target, clamp(AMOUNT * LAST * TARGET_FPS, 0, 1))
			--local new = Lerp(object._Value, target, clamp(AMOUNT * elapsed * TARGET_FPS, 0, 1))
			if isCloseEnough(new, target, object._MaxValue - object._MinValue) then
				new = target
				SmoothObjects[object] = nil
			end
			object:_UpdateValue(new)
			object._Value = new
		end
		LAST = 0
	end
end

local function SetSmoothValue(frame, value)
	value = tonumber(value)
	
	frame._Value = frame._OldValue or 0
	SmoothObjects[frame] = clamp(value, frame._MinValue, frame._MaxValue)
end

local function SetSmoothMinMax(frame, min_value, max_value)
	min_value, max_value = tonumber(min_value), max(tonumber(max_value),1)

	if (frame._MinValue and frame._MinValue ~= min_value) or (frame._MaxValue and frame._MaxValue ~= max_value) then
		local ratio = 1
		if max_value ~= 0 and frame._MaxValue and frame._MaxValue ~= 0 then
			ratio = max_value / (frame._MaxValue or max_value)
		end

		local target = SmoothObjects[frame]
		if target then
			SmoothObjects[frame] = target * ratio
		end

		frame._MinValue = min_value
		frame._MaxValue = max_value
		
		local cur = frame._Value
		if cur then
			frame:_UpdateValue(cur * ratio)
			frame._Value = cur * ratio
		end
	end
	frame:_UpdateMaxValue(min_value,max_value)
end

local function DoSmooth(frame)
	frame._MinValue = frame._MinValue or 0
	frame._MaxValue = frame._MaxValue or 1

	if not frame._UpdateValue then
		frame._UpdateValue = frame.UpdateValue
		frame.UpdateValue = SetSmoothValue
	end

	if not frame._UpdateMaxValue then
		frame._UpdateMaxValue = frame.UpdateMaxValue
		frame.UpdateMaxValue = SetSmoothMinMax
	end

	if not SmoothBackground:GetScript('OnUpdate') then
		SmoothBackground:SetScript('OnUpdate', SmoothBackground_Update)
	end

	HandledObjects[frame] = true
end

local function DeSmooth(frame)
	if SmoothObjects[frame] then
		frame:_UpdateValue(SmoothObjects[frame])
		SmoothObjects[frame] = nil
	end
	if not next(HandledObjects) then
		SmoothBackground:SetScript('OnUpdate', nil)
	end
end

F.SetSmoothRate = function(value)
	if value then
		FPS_RATE = clamp(value, 1, 10)
	end
end

F.SetSmooth = function(frame, enable)
	if enable then
		DoSmooth(frame)
	else
		DeSmooth(frame)
	end
end

