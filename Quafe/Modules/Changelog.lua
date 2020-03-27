local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)

----------------------------------------------------------------
--> Game Menu
----------------------------------------------------------------

local function Picture_Frame(frame)
	local Dummy = CreateFrame("Frame", nil, frame)
	Dummy: SetSize(820,420)
	Dummy: Hide()

	local Backdrop = F.Create.Backdrop(Dummy, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
	local Picture = F.Create.Texture(Dummy, "ARTWORK", 1, "", nil, nil, {1024,512})
	Picture: SetPoint("CENTER")

	Dummy.Texture = Picture

	return Dummy
end