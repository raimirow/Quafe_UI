----------------------------------------------------------------
-- Init
----------------------------------------------------------------

local AddonName, Engine = ...
Engine[1] = {}

local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

_G[AddonName] = Engine

OW.Name = AddonName
OW.Path = function(tex)
	return format("%s%s%s%s", "Interface\\AddOns\\", AddonName, "\\Media\\", tex)
end