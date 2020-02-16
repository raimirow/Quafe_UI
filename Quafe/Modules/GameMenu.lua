local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

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

local insert = table.insert
local remove = table.remove
local wipe = table.wipe

local find = string.find

----------------------------------------------------------------
--> Game Menu
----------------------------------------------------------------
