local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API and Variable
----------------------------------------------------------------

local _G = getfenv(0)
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local asin = math.asin
local cos = math.cos
local acos = math.acos
local tan = math.tan
local atan = math.atan
local rad = math.rad
local modf = math.modf
local GetTime = _G.GetTime

local Details = _G["Details"]
local Recount = _G["Recount"]
local Skada = _G["Skada"]
local EAST_ASIA = true

----------------------------------------------------------------
--> Tactics Data Recording System
----------------------------------------------------------------

