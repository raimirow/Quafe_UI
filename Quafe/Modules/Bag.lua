local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale
--if F.IsClassic then return end

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
local find = string.find
local insert = table.insert
local wipe = table.wipe

--local GetItemClassInfo = _G.GetItemClassInfo
--local GetItemSubClassInfo = _G.GetItemSubClassInfo

local MAX_CONTAINER_ITEMS = 36
local NUM_CONTAINER_COLUMNS = 4
local BACKPACK_BASE_SIZE = 16

-- NUM_CONTAINER_FRAMES = 13;
-- NUM_BAG_FRAMES = Constants.InventoryConstants.NumBagSlots;	4
-- NUM_REAGENTBAG_FRAMES = Constants.InventoryConstants.NumReagentBagSlots;		1
-- NUM_TOTAL_BAG_FRAMES = Constants.InventoryConstants.NumBagSlots + Constants.InventoryConstants.NumReagentBagSlots;

--- ------------------------------------------------------------
--> Bag
--- ------------------------------------------------------------
--- 
--- BagID
--- 0			BACKPACK_CONTAINER		Enum.BagIndex.Backpack
--- 1 to 4		NUM_BAG_SLOTS			Enum.BagIndex.Bag_1 to Bag_4
--- 5			NUM_REAGENTBAG_SLOTS	Enum.BagIndex.ReagentBag
--- 6 to 12		NUM_BANKBAGSLOTS		Enum.BagIndex.BankBag_1 to BankBag_7
--- 13 to 17							Enum.BagIndex.AccountBankTab_1 to AccountBankTab_5
--- -1			BANK_CONTAINER			Enum.BagIndex.Bank
--- -2			KEYRING_CONTAINER		Enum.BagIndex.Keyring
--- -3			REAGENTBANK_CONTAINER	Enum.BagIndex.Reagentbank
--- -5									Enum.BagIndex.Accountbanktab
--- 
--- BANK
--- REAGENT_BANK
--- ACCOUNT_BANK_PANEL_TITLE
--- 
--- ACCOUNT_BANK_TAB_NAME_PROMPT
--- ACCOUNT_BANK_DEPOSIT_BUTTON_LABEL
--- ACCOUNT_BANK_TAB_PURCHASE_PROMPT
--- ACCOUNT_BANK_LOCKED_PROMPT 战团银行正在被使用

-- texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered = C_Container.GetContainerItemInfo(bag, slot);
-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")
-- itemID, itemType, itemSubType, itemEquipLoc, itemTexture, itemClassID, itemSubClassID = GetItemInfoInstant(itemLink) 
-- GetItemClassInfo(classIndex)
-- GetItemSubClassInfo(classIndex, subClassIndex)
-- ITEM_QUALITY_COLORS

--local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, reforging, Name = 
--string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

--local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, reforging, Name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

--local itemString = string.match(itemLink, "item[%-?%d:]+")

--[[
ITEM_QUALITY0_DESC = "Poor";
ITEM_QUALITY1_DESC = "Common";
ITEM_QUALITY2_DESC = "Uncommon";
ITEM_QUALITY3_DESC = "Rare";
ITEM_QUALITY4_DESC = "Epic";
ITEM_QUALITY5_DESC = "Legendary";
ITEM_QUALITY6_DESC = "Artifact";
ITEM_QUALITY7_DESC = "Heirloom";
ITEM_QUALITY8_DESC = "WoW Token";

	ITEMCLASS = {
		["Elixir"] =				{L = 1,  C = {r= 46, g=204, b=113}, T = "Bag_Elixir"},			--药剂
		["Food"] =					{L = 2,  C = {r= 46, g=204, b=113}, T = "Bag_Food"},			--食物
		[ITEMCLASS_Consumable] =	{L = 3,  C = {r= 46, g=204, b=113}, T = "Bag_Consumable"},		--消耗品 Consumable 
		[GetItemClassInfo(12)] =	{L = 4,  C = {r=241, g=196, b= 15}, T = "Bag_Quest"},			--任务
		[GetItemClassInfo(2)] =		{L = 5,  C = {r=231, g= 76, b= 60}, T = "Bag_Weapon"},			--武器
		[GetItemClassInfo(4)] =		{L = 6,  C = {r=231, g= 76, b= 60}, T = "Bag_Armor"},			--护甲
		[GetItemClassInfo(3)] =		{L = 7,  C = {r=155, g= 89, b=182}, T = "White"},				--宝石
		[GetItemClassInfo(16)] =	{L = 8,  C = {r=155, g= 89, b=182}, T = "White"},				--雕文
		[GetItemClassInfo(8)] =		{L = 9,  C = {r=155, g= 89, b=182}, T = "White"},				--物品强化
		[GetItemClassInfo(9)] =		{L = 10, C = {r=236, g=240, b=241}, T = "White"},				--配方
		[GetItemClassInfo(7)] =		{L = 11, C = {r= 52, g=152, b=219}, T = "White"},				--商业技能
		[GetItemClassInfo(5)] =		{L = 12, C = {r= 52, g=152, b=219}, T = "White"},				--材料
		[GetItemClassInfo(13)] = 	{L = 13, C = {r= 52, g=152, b=219}, T = "White"},				--钥匙
		[GetItemClassInfo(15)] =	{L = 14, C = {r=155, g= 89, b=182}, T = "White"},				--杂项
		["Other"] = 				{L = 15, C = {r= 22, g=160, b=133}, T = "White"},				--其它
		["Sale"] =					{L = 16, C = {r= 52, g= 73, b= 94}, T = "White"},				--垃圾
	}

--]]

--[[
local function Get_FullItemClass()
	local COMPILED_ITEM_CLASSES = {}
	local classIndex = 0
	local className = GetItemClassInfo(classIndex)

	while className and className ~= "" do
		COMPILED_ITEM_CLASSES[classIndex] = {
			name = className,
			subClasses = {},
		}

		local subClassIndex = 0
		local subClassName = GetItemSubClassInfo(classIndex, subClassIndex)

		while subClassName and subClassName ~= "" do
			COMPILED_ITEM_CLASSES[classIndex].subClasses[subClassIndex] = subClassName

			subClassIndex = subClassIndex + 1
			subClassName = GetItemSubClassInfo(classIndex, subClassIndex)
		end

		classIndex = classIndex + 1
		className = GetItemClassInfo(classIndex)
	end
	return COMPILED_ITEM_CLASSES
end

local COMPILED_ITEM_CLASSES = Get_FullItemClass()
for k1, v1 in pairs(COMPILED_ITEM_CLASSES) do
	for k2, v2 in pairs(v1.subClasses) do
		print(k1, v1.name, k2, v2)
	end
end
--]]

--[[
local RefEquipmentSlots = {
	INVTYPE_AMMO = 0,
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_BODY = 4,
	INVTYPE_CHEST = 5,
	INVTYPE_ROBE = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = 11,
	INVTYPE_TRINKET = 12,
	INVTYPE_CLOAK = 13,
	INVTYPE_WEAPON = 14,
	INVTYPE_SHIELD = 15,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPONMAINHAND = 18,
	INVTYPE_WEAPONOFFHAND = 19,
	INVTYPE_HOLDABLE = 20,
	INVTYPE_RANGED = 21,
	INVTYPE_THROWN = 22,
	INVTYPE_RANGEDRIGHT = 23,
	INVTYPE_RELIC = 24,
	INVTYPE_TABARD = 25
}
local ItemCategories = {
	AUCTION_CATEGORY_WEAPONS,  --武器
	AUCTION_CATEGORY_ARMOR,  --护甲
	AUCTION_CATEGORY_CONTAINERS,  --容器
	AUCTION_CATEGORY_CONSUMABLES,  --消耗品
	AUCTION_CATEGORY_ITEM_ENHANCEMENT,  --物品附魔
	AUCTION_CATEGORY_GLYPHS,  --雕文
	AUCTION_CATEGORY_TRADE_GOODS,  --杂货
	AUCTION_CATEGORY_RECIPES,  --配方
	AUCTION_CATEGORY_GEMS,  --宝石
	AUCTION_CATEGORY_MISCELLANEOUS,  --杂项
	AUCTION_CATEGORY_QUEST_ITEMS,
	AUCTION_CATEGORY_BATTLE_PETS
}

local sortingCache = {
	[1] = {}, --BAG
	[2] = {}, --ID
	[3] = {}, --PETID
	[4] = {}, --STACK
	[5] = {}, --MAXSTACK
	[6] = {}, --MOVES
}
--]]

-- 11.0.0
-- C_NewItems.RemoveNewItem(itemButton:GetBagID(), itemButton:GetID())


local Bag = {}
local BagFree = {}
local BagNew = {}
local Bank = {}
local BankFree = {}
local BankSpecical = {}
local BankSpecicalFree = {}
local Reagent = {}
local ReagentFree = {}
local AccountSlots = {}
local AccountBankSlotsFree  = {}

local config = {
	buttonSize = 32,
	iconSize = 28,
	buttonGap = 3,
	border = 8,
	perLine = 12,
	bankperLine = 18,
	reagentperLine = 18,
}

local SlotNum = {
	["Total"] = 0,
	["Free"] = 0,
	["Bag0"] = 0,
	["Bag1"] = 0,
	["Bag2"] = 0,
	["Bag3"] = 0,
	["Bag4"] = 0,
	["Bank"] = 0,
	["BankFree"] = 0,
}

local ITEMCLASS = {}
local ITEMCLASS_Consumable = GetItemClassInfo(0)
local ITEMCLASS_Weapon = GetItemClassInfo(2)
local ITEMCLASS_Armor = GetItemClassInfo(4)
local ITEMCLASS_Miscellaneous = GetItemClassInfo(15)
local function Init_ItemClass()
	wipe(ITEMCLASS)
	if F.IsClassic then
		ITEMCLASS = {
			--["New"] = 				{L = 1,  C = C.Color.B1, T = "Bag_New"},         --新物品
			["Elixir"] =				{L = 1,  C = C.Color.Y1, T = "Bag_Elixir",			D = GetItemSubClassInfo(0, 1)},         --药剂
			["Food"] =					{L = 2,  C = C.Color.Y1, T = "Bag_Food",			D = GetItemSubClassInfo(0, 5)},			--食物
			[ITEMCLASS_Consumable] =	{L = 3,  C = C.Color.Y1, T = "Bag_Consumable",		D = ITEMCLASS_Consumable},	   			--消耗品
			[GetItemClassInfo(12)] =	{L = 4,  C = C.Color.Y1, T = "Bag_Quest",			D = GetItemClassInfo(12)},				--任务
			[ITEMCLASS_Weapon] =		{L = 5,  C = C.Color.Y1, T = "Bag_Weapon",			D = ITEMCLASS_Weapon},					--武器
			[ITEMCLASS_Armor] =			{L = 6,  C = C.Color.Y1, T = "Bag_Armor",			D = ITEMCLASS_Armor},					--护甲
			[GetItemClassInfo(3)] =		{L = 7,  C = C.Color.Y1, T = "Bag_Gem",				D = GetItemClassInfo(3)},				--宝石
			--[GetItemClassInfo(16)] =	{L = 8,  C = C.Color.Y1, T = "Bag_Glyphs",			D = GetItemClassInfo(16)},		  		--雕文
			[GetItemClassInfo(8)] =		{L = 9,  C = C.Color.Y1, T = "Bag_Upgrade",			D = GetItemClassInfo(8)},				--物品强化
			[GetItemClassInfo(9)] =		{L = 10, C = C.Color.Y1, T = "Bag_Glyph",			D = GetItemClassInfo(9)},				--配方
			[GetItemClassInfo(7)] =		{L = 11, C = C.Color.Y1, T = "Bag_Trade",			D = GetItemClassInfo(7)},				--商业技能
			[GetItemClassInfo(5)] =		{L = 12, C = C.Color.Y1, T = "Bag_Material",		D = GetItemClassInfo(5)},				--材料
			[GetItemClassInfo(13)] = 	{L = 13, C = C.Color.Y1, T = "Bag_Key",				D = GetItemClassInfo(13)},				--钥匙
			[ITEMCLASS_Miscellaneous] =	{L = 14, C = C.Color.Y1, T = "Bag_Goods",			D = ITEMCLASS_Miscellaneous},			--杂项
			["Other"] = 				{L = 15, C = C.Color.Y1, T = "Bag_Other",			D = OTHER},								--其它
			["Hearthstone"] =			{L = 16, C = C.Color.Y1, T = "Bag_Hearthstone"},	--炉石
			["Sale"] =					{L = 17, C = C.Color.Y1, T = "Bag_Junk"},			--垃圾
		}
		ITEMCLASS.Elixir.SubClass = {
			[GetItemSubClassInfo(0, 1)] = {L = 1},  --药水
			[GetItemSubClassInfo(0, 2)] = {L = 2},  --药剂
			--[GetItemSubClassInfo(0, 3)] = {L = 3},  --合剂
			--[GetItemSubClassInfo(0, 7)] = {L = 4},  --绷带
		}
		ITEMCLASS.Food.SubClass = {
			--[GetItemSubClassInfo(0, 5)] = {L = 1},  --餐饮供应商
		}
	else
		ITEMCLASS = {
			--["New"] = 				{L = 1,  C = C.Color.B1, T = "Bag_New"},         --新物品
			["Elixir"] =				{L = 1,  C = C.Color.Y1, T = "Bag_Elixir",			D = C_Item.GetItemSubClassInfo(0, 1)},         --药剂
			["Food"] =					{L = 2,  C = C.Color.Y1, T = "Bag_Food",			D = C_Item.GetItemSubClassInfo(0, 5)},			--食物
			[ITEMCLASS_Consumable] =	{L = 3,  C = C.Color.Y1, T = "Bag_Consumable",		D = ITEMCLASS_Consumable},	   			--消耗品
			[GetItemClassInfo(12)] =	{L = 4,  C = C.Color.Y1, T = "Bag_Quest",			D = C_Item.GetItemClassInfo(12)},				--任务
			[ITEMCLASS_Weapon] =		{L = 5,  C = C.Color.Y1, T = "Bag_Weapon",			D = ITEMCLASS_Weapon},					--武器
			[ITEMCLASS_Armor] =			{L = 6,  C = C.Color.Y1, T = "Bag_Armor",			D = ITEMCLASS_Armor},					--护甲
			[GetItemClassInfo(3)] =		{L = 7,  C = C.Color.Y1, T = "Bag_Gem",				D = C_Item.GetItemClassInfo(3)},				--宝石
			[GetItemClassInfo(16)] =	{L = 8,  C = C.Color.Y1, T = "Bag_Glyphs",			D = C_Item.GetItemClassInfo(16)},		  		--雕文
			[GetItemClassInfo(8)] =		{L = 9,  C = C.Color.Y1, T = "Bag_Upgrade",			D = C_Item.GetItemClassInfo(8)},				--物品强化
			[GetItemClassInfo(9)] =		{L = 10, C = C.Color.Y1, T = "Bag_Glyph",			D = C_Item.GetItemClassInfo(9)},				--配方
			[GetItemClassInfo(7)] =		{L = 11, C = C.Color.Y1, T = "Bag_Trade",			D = C_Item.GetItemClassInfo(7)},				--商业技能
			[GetItemClassInfo(5)] =		{L = 12, C = C.Color.Y1, T = "Bag_Material",		D = C_Item.GetItemClassInfo(5)},				--材料
			[GetItemClassInfo(13)] = 	{L = 13, C = C.Color.Y1, T = "Bag_Key",				D = C_Item.GetItemClassInfo(13)},				--钥匙
			[ITEMCLASS_Miscellaneous] =	{L = 14, C = C.Color.Y1, T = "Bag_Goods",			D = ITEMCLASS_Miscellaneous},			--杂项
			["Other"] = 				{L = 15, C = C.Color.Y1, T = "Bag_Other",			D = OTHER},								--其它
			["Hearthstone"] =			{L = 16, C = C.Color.Y1, T = "Bag_Hearthstone",		D = GetItemInfo(6948)},					--炉石
			["Sale"] =					{L = 17, C = C.Color.Y1, T = "Bag_Junk"},			--垃圾
		}
		ITEMCLASS.Elixir.SubClass = {
			[C_Item.GetItemSubClassInfo(0, 1)] = {L = 1},  --药水
			[C_Item.GetItemSubClassInfo(0, 2)] = {L = 2},  --药剂
			[C_Item.GetItemSubClassInfo(0, 3)] = {L = 3},  --合剂
			[C_Item.GetItemSubClassInfo(0, 7)] = {L = 4},  --绷带
		}
		ITEMCLASS.Food.SubClass = {
			[C_Item.GetItemSubClassInfo(0, 5)] = {L = 1},  --餐饮供应商
		}
	end

	ITEMCLASS.Hearthstone.itemID = {
		[6948] =	{L = 1},   --炉石
		[140192] =	{L = 2},   --达拉然炉石
		[110560] =	{L = 3},   --要塞炉石
		[141605] =	{L = 4},   --飞行管理员的哨子
		[65360] =	{L = 5},   --协同披风
		[63206] =	{L = 6},   --协和披风
		[63352] =	{L = 7},   --协作披风
		[46874] =	{L = 8},   --银色北伐军战袍
		[128353] =	{L = 9},   --海军上将的罗盘
		[37863] =	{L = 10},  --黑铁遥控器
		[32757] =	{L = 11},  --卡拉波神圣勋章
		[118663] =	{L = 12},  --卡拉波圣物
	}
end

local BANKITEMCLASS = {}
local function Init_BankItemClass()
	wipe(BANKITEMCLASS)
	if F.IsClassic then
		BANKITEMCLASS = {
			["Elixir"] =				{L = 1,  C = C.Color.Y1, T = "Bag_Elixir",			D = GetItemSubClassInfo(0, 1)},         --药剂
			["Food"] =					{L = 2,  C = C.Color.Y1, T = "Bag_Food",			D = GetItemSubClassInfo(0, 5)},			--食物
			[ITEMCLASS_Consumable] =	{L = 3,  C = C.Color.Y1, T = "Bag_Consumable",		D = ITEMCLASS_Consumable},     			--消耗品
			[GetItemClassInfo(12)] =	{L = 4,  C = C.Color.Y1, T = "Bag_Quest",			D = GetItemClassInfo(12)},				--任务
			[ITEMCLASS_Weapon] =		{L = 5,  C = C.Color.Y1, T = "Bag_Weapon",			D = ITEMCLASS_Weapon},         			--武器
			[ITEMCLASS_Armor] =			{L = 6,  C = C.Color.Y1, T = "Bag_Armor",			D = ITEMCLASS_Armor},					--护甲
			[GetItemClassInfo(3)] =		{L = 7,  C = C.Color.Y1, T = "Bag_Gem",				D = GetItemClassInfo(3)},				--宝石
			--[GetItemClassInfo(16)] =	{L = 8,  C = C.Color.Y1, T = "Bag_Glyphs",			D = GetItemClassInfo(16)},	    	    --雕文
			[GetItemClassInfo(8)] =		{L = 9,  C = C.Color.Y1, T = "Bag_Upgrade",			D = GetItemClassInfo(8)},				--物品强化
			[GetItemClassInfo(9)] =		{L = 10, C = C.Color.Y1, T = "Bag_Glyph",			D = GetItemClassInfo(9)},				--配方
			[GetItemClassInfo(7)] =		{L = 11, C = C.Color.Y1, T = "Bag_Trade",			D = GetItemClassInfo(7)},				--商业技能
			[GetItemClassInfo(5)] =		{L = 12, C = C.Color.Y1, T = "Bag_Material",		D = GetItemClassInfo(5)},				--材料
			[GetItemClassInfo(13)] = 	{L = 13, C = C.Color.Y1, T = "Bag_Key",				D = GetItemClassInfo(13)},				--钥匙
			[ITEMCLASS_Miscellaneous] =	{L = 14, C = C.Color.Y1, T = "Bag_Goods",			D = ITEMCLASS_Miscellaneous},			--杂项
			["Other"] = 				{L = 15, C = C.Color.Y1, T = "Bag_Other",			D = OTHER},								--其它
			["Sale"] =					{L = 17, C = C.Color.Y1, T = "Bag_Junk"},			--垃圾
		}
		BANKITEMCLASS.Elixir.SubClass = {
			[GetItemSubClassInfo(0, 1)] = {L = 1},  --药水
			[GetItemSubClassInfo(0, 2)] = {L = 2},  --药剂
			--[GetItemSubClassInfo(0, 3)] = {L = 3},  --合剂
			--[GetItemSubClassInfo(0, 7)] = {L = 4},  --绷带
		}
		BANKITEMCLASS.Food.SubClass = {
			--[GetItemSubClassInfo(0, 5)] = {L = 1},  --餐饮供应商
		}
	else
		BANKITEMCLASS = {
			["Elixir"] =				{L = 1,  C = C.Color.Y1, T = "Bag_Elixir",			D = C_Item.GetItemSubClassInfo(0, 1)},         --药剂
			["Food"] =					{L = 2,  C = C.Color.Y1, T = "Bag_Food",			D = C_Item.GetItemSubClassInfo(0, 5)},			--食物
			[ITEMCLASS_Consumable] =	{L = 3,  C = C.Color.Y1, T = "Bag_Consumable",		D = ITEMCLASS_Consumable},     			--消耗品
			[GetItemClassInfo(12)] =	{L = 4,  C = C.Color.Y1, T = "Bag_Quest",			D = C_Item.GetItemClassInfo(12)},				--任务
			[ITEMCLASS_Weapon] =		{L = 5,  C = C.Color.Y1, T = "Bag_Weapon",			D = ITEMCLASS_Weapon},         			--武器
			[ITEMCLASS_Armor] =			{L = 6,  C = C.Color.Y1, T = "Bag_Armor",			D = ITEMCLASS_Armor},					--护甲
			[GetItemClassInfo(3)] =		{L = 7,  C = C.Color.Y1, T = "Bag_Gem",				D = C_Item.GetItemClassInfo(3)},				--宝石
			[GetItemClassInfo(16)] =	{L = 8,  C = C.Color.Y1, T = "Bag_Glyphs",			D = C_Item.GetItemClassInfo(16)},	    	    --雕文
			[GetItemClassInfo(8)] =		{L = 9,  C = C.Color.Y1, T = "Bag_Upgrade",			D = C_Item.GetItemClassInfo(8)},				--物品强化
			[GetItemClassInfo(9)] =		{L = 10, C = C.Color.Y1, T = "Bag_Glyph",			D = C_Item.GetItemClassInfo(9)},				--配方
			[GetItemClassInfo(7)] =		{L = 11, C = C.Color.Y1, T = "Bag_Trade",			D = C_Item.GetItemClassInfo(7)},				--商业技能
			[GetItemClassInfo(5)] =		{L = 12, C = C.Color.Y1, T = "Bag_Material",		D = C_Item.GetItemClassInfo(5)},				--材料
			[GetItemClassInfo(13)] = 	{L = 13, C = C.Color.Y1, T = "Bag_Key",				D = C_Item.GetItemClassInfo(13)},				--钥匙
			[ITEMCLASS_Miscellaneous] =	{L = 14, C = C.Color.Y1, T = "Bag_Goods",			D = ITEMCLASS_Miscellaneous},			--杂项
			["Other"] = 				{L = 15, C = C.Color.Y1, T = "Bag_Other",			D = OTHER},								--其它
			["Sale"] =					{L = 17, C = C.Color.Y1, T = "Bag_Junk"},			--垃圾
		}
		BANKITEMCLASS.Elixir.SubClass = {
			[C_Item.GetItemSubClassInfo(0, 1)] = {L = 1},  --药水
			[C_Item.GetItemSubClassInfo(0, 2)] = {L = 2},  --药剂
			[C_Item.GetItemSubClassInfo(0, 3)] = {L = 3},  --合剂
			[C_Item.GetItemSubClassInfo(0, 7)] = {L = 4},  --绷带
		}
		BANKITEMCLASS.Food.SubClass = {
			[C_Item.GetItemSubClassInfo(0, 5)] = {L = 1},  --餐饮供应商
		}
	end
end

local function ButtonHighLight_Create(frame, color)
	frame: SetBackdrop({
		bgFile = F.Path("StatusBar\\Raid"),
		edgeFile = F.Path("White"), 
		edgeSize = 2,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	frame: SetBackdropColor(F.Color(color, 0))
	frame: SetBackdropBorderColor(F.Color(color, 0))
	
	frame: HookScript("OnEnter", function(self)
		self: SetBackdropColor(F.Color(color,1))
		self: SetBackdropBorderColor(F.Color(color,1))
		self.Tex: SetVertexColor(F.Color(C.Color.Config.Back))
	end)
	frame: HookScript("OnLeave", function(self)
		self: SetBackdropColor(F.Color(color,0))
		self: SetBackdropBorderColor(F.Color(color,0))
		self.Tex: SetVertexColor(F.Color(color))
	end)
end

local function Button_Template(f)
	local button = CreateFrame("Button", nil, f)
	button: SetSize(24,24)
	button: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	F.create_Backdrop(button, 2, 8, 4, C.Color.Y1,0, C.Color.W4,0.9)
	button.Bg: SetAlpha(0)
	
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon: SetSize(16,16)
	button.Icon: SetPoint("CENTER", button, "CENTER", 0,0)
	button.Icon: SetVertexColor(F.Color(C.Color.W3))
	
	button: SetScript("OnEnter", function(self)
		self.Bg: SetAlpha(1)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			GameTooltip:SetText(self.tooltipText)
			GameTooltip:Show()
		end
		--self.Icon: SetVertexColor(F.Color(C.Color.Config.Back))
	end)
	button: SetScript("OnLeave", function(self)
		self.Bg: SetAlpha(0)
		GameTooltip:Hide()
		--self.Icon: SetVertexColor(F.Color(C.Color.W3))
	end)
	
	return button
end

local function Sell_Junk()
	local JUNK_NUM = 0
	local JUNK_PRICE = 0
	for k,v in ipairs(Bag[0]) do
		if v.itemType then
			if v.itemType == "Sale" then
				if JUNK_NUM < 12 then
					local currPrice = (select(11, C_Item.GetItemInfo(v.itemID)) or 0) * (v.itemCount or 1)
					C_Container.PickupContainerItem(v.bagID, v.slotID)
					PickupMerchantItem(0)
					JUNK_NUM = JUNK_NUM + 1
					JUNK_PRICE = JUNK_PRICE + currPrice
				else
					DEFAULT_CHAT_FRAME:AddMessage(L['SOLD'].." "..JUNK_NUM.."  "..L['GAINED'].." "..C_CurrencyInfo.GetCoinTextureString(JUNK_PRICE))
					return
				end
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(L['SOLD'].." "..JUNK_NUM.."  "..L['GAINED'].." "..C_CurrencyInfo.GetCoinTextureString(JUNK_PRICE))
end

local function Init_BagGap(f, classtable, p, bank)
	local parent
	if p then
		parent = p
	else
		parent = f
	end
	for k, v in pairs(classtable) do
		local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
		frame: SetSize(config.buttonSize, config.buttonSize)

		local icon = frame:CreateTexture(nil, "ARTWORK")
		icon: SetSize(config.iconSize, config.iconSize)
		icon: SetPoint("CENTER", frame, "CENTER", 0,0)
		icon: SetTexture(F.Path(v.T))
		icon: SetVertexColor(F.Color(v.C))
		
		local shadow = frame:CreateTexture(nil, "BORDER")
		shadow: SetSize(config.iconSize, config.iconSize)
		shadow: SetPoint("CENTER", icon, "CENTER", 2,2)
		shadow: SetTexture(F.Path(v.T))
		shadow: SetVertexColor(F.Color(C.Color.W2))
		shadow: SetAlpha(0.5)

		if v.D then
			frame: SetScript("OnEnter", function(self)
				GameTooltip: SetOwner(self, "ANCHOR_NONE", 0,0)
				GameTooltip: SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0,4)
				GameTooltip: SetText(v.D)
				GameTooltip: Show()
			end)
			frame: SetScript("OnLeave", function(self)
				GameTooltip: Hide()
			end)
		end

		f["BagIcon"..k] = frame
		f["BagIcon"..k].Tex = icon
	end

	--> NewItem
	local NewItem = CreateFrame("Button", nil, parent, "BackdropTemplate")
	NewItem: SetSize(config.buttonSize, config.buttonSize)

	local NewItemIcon = NewItem:CreateTexture(nil, "ARTWORK")
	NewItemIcon: SetSize(config.iconSize, config.iconSize)
	NewItemIcon: SetPoint("CENTER", NewItem, "CENTER", 0,0)
	NewItemIcon: SetTexture(F.Path("Bag_New"))
	NewItemIcon: SetVertexColor(F.Color(C.Color.Y1))

	f["BagIconNew"] = NewItem
	f["BagIconNew"].Tex = NewItemIcon
	
	local numfree = CreateFrame("Button", nil, parent)
	numfree: SetSize(config.buttonSize, config.buttonSize)
	f["BagIconFree"] = numfree
	
	local freetext = F.Create.Font(numfree, "ARTWORK", C.Font.Num, 16, nil, C.Color.Y1, 1, C.Color.W1, 0, {0,0}, "CENTER", "CENTER")
	freetext: SetPoint("CENTER", numfree, "CENTER", 0,0)
	f["BagIconFreeText"] = freetext

	f["BagIconNew"]: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	f["BagIconNew"]: SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			GameTooltip: Hide()
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" or Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
				f:FullUpdate_BagItem()
			end
		end
	end)
	f["BagIconNew"]: SetScript("OnEnter", function(self)
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" or Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
			GameTooltip: SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip: SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0,4)
			GameTooltip: SetText(L['BAG_GROUP_REFRESH'])
			GameTooltip: Show()
		end
	end)
	f["BagIconNew"]: SetScript("OnLeave", function(self)
		GameTooltip: Hide()
	end)
	ButtonHighLight_Create(f["BagIconNew"], C.Color.Y1)

	f["BagIconSale"]: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	f["BagIconSale"]: SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			GameTooltip: Hide()
			Sell_Junk()
		end
	end)
	if not bank then
		f["BagIconSale"]: SetScript("OnEnter", function(self)
			GameTooltip: SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip: SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0,4)
			GameTooltip: SetText(L['SELL_JUNK'])
			GameTooltip: Show()
		end)
		f["BagIconSale"]: SetScript("OnLeave", function(self)
			GameTooltip: Hide()
		end)
		ButtonHighLight_Create(f["BagIconSale"], C.Color.Y1)
	end
end

local function BagGap_Reset(f, classtable)
	for k, v in pairs(classtable) do
		f["BagIcon"..k]: ClearAllPoints()
		f["BagIcon"..k]: Hide()
	end
	f["BagIconNew"]: ClearAllPoints()
	f["BagIconNew"]: Hide()
	f["BagIconFree"]: ClearAllPoints()
	f["BagIconFree"]: Hide()
end

local function Create_ButtonBg(f, e, d)
	local backdrop = {
		bgFile = F.Path("White"),
		edgeFile = F.Path("White"),
		tile = false, tileSize = 0, edgeSize = e, 
		insets = { left = d, right = d, top = d, bottom = d }
	}
	f: SetBackdrop(backdrop)
end

local function Create_BagFrame(frame, bagID)
	local button = CreateFrame("Button", "Quafe_Bag"..bagID, frame)
	button: SetID(bagID)
	
	return button
end

local function Create_BagItemButton(f, bagID, slotID)
	local template
	if bagID == BANK_CONTAINER then 
		template = "BankItemButtonGenericTemplate"
	elseif bagID == REAGENTBANK_CONTAINER then
		template = "ReagentBankItemButtonGenericTemplate"
		--template = "BankItemButtonGenericTemplate"
	else
		template = "ContainerFrameItemButtonTemplate"
	end

	local buttonAnchor = CreateFrame("Frame", nil, f)
	buttonAnchor: SetSize(config.buttonSize, config.buttonSize)
	buttonAnchor: SetID(bagID)

	local button = CreateFrame(F.IsClassic and "CheckButton" or "ItemButton", "Quafe_Bag"..bagID.."Slot"..slotID, buttonAnchor, template)
	--ContainerFrameItemButtonMixin.OnLoad(button)
	button: SetAllPoints(buttonAnchor)
	button: SetSize(config.buttonSize, config.buttonSize)
	button: SetPoint("BOTTOMRIGHT", buttonAnchor, "BOTTOMRIGHT", 0, 0)
	
	--local button = CreateFrame("CheckButton", "Quafe_Bag"..bagID.."Slot"..slotID, f, template)
	--local button = CreateFrame(F.IsClassic and "CheckButton" or "ItemButton", "Quafe_Bag"..bagID.."Slot"..slotID, f, template)
	--button: SetSize(config.buttonSize, config.buttonSize)
	button: SetBagID(bagID)
	button: SetID(slotID)
	button.bagID = bagID
	button.slotID = slotID
	button: RegisterForDrag("LeftButton")
	button: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button: Enable()
	button: Show()

	if bagID == BANK_CONTAINER then 
		button: SetFrameLevel(4)
	elseif bagID == REAGENTBANK_CONTAINER then
		button: SetFrameLevel(8)
	end

	local slotName = button: GetName()
	
	button.Border = F.Create.Backdrop(button, {wide = 0, border = true, edge = 2, inset = 0, cBg = C.Color.W1, aBg = 0, cBd = C.Color.W4, aBd = 0.9})
	
	button.icon: SetAllPoints(button)
	button.icon: SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count: SetFont(C.Font.Num, 12, "OUTLINE")
	button.Count: SetTextColor(197/255, 202/255, 233/255, 1)
	button.Count: ClearAllPoints()
	button.Count: SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1,2)
	
	button.Level = F.Create.Font(button, "ARTWORK", C.Font.Num, 12, "OUTLINE", C.Color.W4, 0.9)
	button.Level: SetPoint("CENTER", button, "CENTER", 1,0)
	--[[
	if (not button.NewItemTexture) then
		button.NewItemTexture = button:CreateTexture(nil, "OVERLAY", 1);
	end
	button.NewItemTexture: SetTexture(F.Path("Bag_Icon_Quality"))
	button.NewItemTexture: SetVertexColor(0/255, 200/255, 248/255)
	button.NewItemTexture: SetBlendMode("BLEND")
	button.NewItemTexture: SetAlpha(1)
	button.NewItemTexture: SetSize(14,14)
	button.NewItemTexture: ClearAllPoints()
	button.NewItemTexture: SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2,2)
	button.NewItemTexture: Hide()
	--]]
	if (not button.NewItemTextureSkin) then
		local Flash = CreateFrame("Frame", nil, button, "Quafe_GarrisonNotificationTemplate")
		Flash: SetAllPoints(button)
		
		local FlashGlow = Flash: CreateTexture(nil, "BORDER")
		FlashGlow: SetTexture(F.Path("White"))
		FlashGlow: SetVertexColor(F.Color(C.Color.W3))
		FlashGlow: SetAlpha(0.75)
		FlashGlow: SetAllPoints(button)

		button.NewItemTexture = Flash
		button.NewItemTextureSkin = true
	end
	button.NewItemTexture: Hide()
	
	if(not button.BattlepayItemTexture) then
		button.BattlepayItemTexture = button:CreateTexture(nil, "OVERLAY", nil, 1);
	end
	button.BattlepayItemTexture: SetTexture("")
	button.BattlepayItemTexture: Hide()

	if(not button.JunkIcon) then
		button.JunkIcon = button:CreateTexture(nil, "OVERLAY", nil, 1);
	end
	button.JunkIcon: SetTexture([[Interface\BUTTONS\UI-GroupLoot-Coin-Up]])
	button.JunkIcon: SetSize(14,14)
	button.JunkIcon: ClearAllPoints()
	button.JunkIcon: SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2,0)

	if (not button.UpgradeIcon) then
		button.UpgradeIcon = button: CreateTexture(nil, "OVERLAY", nil, 1);
	end
	--Texture:SetAtlas("atlasName"[, useAtlasSize, "filterMode"])
	button.UpgradeIcon: SetAtlas("bags-greenarrow", true)
	button.UpgradeIcon: SetSize(18,20)
	button.UpgradeIcon: ClearAllPoints()
	button.UpgradeIcon: SetPoint("TOPLEFT", button, "TOPLEFT", -2,2)
	button.UpgradeIcon: Hide()

	button.QuestIcon = _G[slotName.."IconQuestTexture"] or button: CreateTexture(nil, "OVERLAY", nil, 2)
	button.QuestIcon: SetTexture(F.Path("Bag_Icon_Quest"))
	button.QuestIcon: SetVertexColor(F.Color(C.Color.W3))
	button.QuestIcon: SetBlendMode("BLEND")
	button.QuestIcon: SetAlpha(1)
	button.QuestIcon: SetSize(24,24)
	button.QuestIcon: ClearAllPoints()
	button.QuestIcon: SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2,2)

	button.QualityIcon = button: CreateTexture(nil, "OVERLAY", nil, 2)
	--button.QualityIcon: SetTexture(F.Path("Bag_Icon_Quality"))
	--button.QualityIcon: SetSize(12,12)
	--button.QualityIcon: SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2,2)
	button.QualityIcon: SetTexture(F.Path("Bag_Icon_Glow"))
	button.QualityIcon: SetSize(config.buttonSize, config.buttonSize)
	button.QualityIcon: SetPoint("CENTER", button, "CENTER", 0,0)
	button.QualityIcon: SetVertexColor(F.Color(C.Color.W3))
	
	--button: SetNormalTexture("")
	--button: SetNormalTexture(0)
	button: ClearNormalTexture()
	--_G[slotName.."NormalTexture"]:ClearAllPoints()
	--_G[slotName.."NormalTexture"]:SetAllPoints(button)
	button: SetPushedTexture(F.Path("Button\\Bag_Pushed"))
	button: SetHighlightTexture(F.Path("Button\\Bag_Hightlight"))
	
	button.cooldown = _G[format("%sCooldown", slotName)]
	button.cooldown: ClearAllPoints()
	button.cooldown: SetAllPoints(button)

	button.Anchor = buttonAnchor
	
	return button
end

local function SortFunc(v1, v2)
	if (not v1.itemType) and (not v2.itemType) then
		if v1.bagID ~= v2.bagID then
			return v1.bagID < v2.bagID
		else
			return v1.slotID < v2.slotID
		end
	elseif not v1.itemType then
		return false
	elseif not v2.itemType then
		return true
	elseif ITEMCLASS[v1.itemType].L ~= ITEMCLASS[v2.itemType].L then
		return ITEMCLASS[v1.itemType].L < ITEMCLASS[v2.itemType].L
	elseif v1.itemType == "Hearthstone" then
		if v1.itemID ~= v2.itemID then
			return ITEMCLASS.Hearthstone.itemID[v1.itemID].L < ITEMCLASS.Hearthstone.itemID[v2.itemID].L
		end
	elseif v1.itemSubType and v2.itemSubType and (v1.itemSubType ~= v2.itemSubType) then
		if ITEMCLASS[v1.itemType].SubClass and ITEMCLASS[v2.itemType].SubClass then
			return ITEMCLASS[v1.itemType].SubClass[v1.itemSubType].L < ITEMCLASS[v2.itemType].SubClass[v2.itemSubType].L
		elseif ITEMCLASS[v1.itemType].SubClass then
			return true
		elseif ITEMCLASS[v2.itemType].SubClass then
			return false
		else
			return v1.itemSubType < v2.itemSubType
		end
	else
		if v1.itemType == "Food" then
			if v1.itemLevel ~= v2.itemLevel then
				return v1.itemLevel > v2.itemLevel
			elseif v1.itemID ~= v2.itemID then
				return v1.itemID > v2.itemID
			else
				return v1.itemCount > v2.itemCount
			end
		elseif v1.itemType == ITEMCLASS_Consumable then
			if v1.itemLevel ~= v2.itemLevel then
				return v1.itemLevel > v2.itemLevel
			elseif v1.itemID ~= v2.itemID then
				if v1.itemID and v2.itemID then
					return v1.itemID > v2.itemID
				else
					return v1.itemName < v2.itemName
				end
			else
				return v1.itemCount > v2.itemCount
			end
		elseif v1.itemType == ITEMCLASS_Weapon then
			if v1.itemSubType and v2.itemSubType and (v1.itemSubType ~= v2.itemSubType) then
				return v1.itemSubType < v2.itemSubType
			elseif v1.itemLevel ~= v2.itemLevel then
				return v1.itemLevel > v2.itemLevel
			elseif v1.itemQuality ~= v2.itemQuality then
				return v1.itemQuality > v2.itemQuality
			elseif v1.itemID ~= v2.itemID then
				if v1.itemID and v2.itemID then
					return v1.itemID > v2.itemID
				else
					return v1.itemName < v2.itemName
				end
			else
				return v1.itemCount > v2.itemCount
			end
		elseif v1.itemType == ITEMCLASS_Armor then
			if (v1.itemSubType and v2.itemSubType) and (v1.itemSubType ~= v2.itemSubType) then
				return v1.itemSubType < v2.itemSubType
			elseif (v1.itemEquipLoc and v2.itemEquipLoc) and (v1.itemEquipLoc ~= v2.itemEquipLoc) then
				return v1.itemEquipLoc < v2.itemEquipLoc
			elseif v1.itemLevel ~= v2.itemLevel then
				return v1.itemLevel > v2.itemLevel
			elseif v1.itemQuality ~= v2.itemQuality then
				return v1.itemQuality > v2.itemQuality
			elseif v1.itemID ~= v2.itemID then
				if v1.itemID and v2.itemID then
					return v1.itemID > v2.itemID
				else
					return v1.itemName < v2.itemName
				end
			else
				return v1.itemCount > v2.itemCount
			end
		else
			if v1.itemSubType and v2.itemSubType and (v1.itemSubType ~= v2.itemSubType) then
				return v1.itemSubType < v2.itemSubType
			elseif (v1.itemLevel and v2.itemLevel and (v1.itemLevel ~= v2.itemLevel)) then
				return v1.itemLevel > v2.itemLevel
			elseif v1.itemID ~= v2.itemID then
				if v1.itemID and v2.itemID then
					return v1.itemID > v2.itemID
				else
					return v1.itemName < v2.itemName
				end
			else
				return v1.itemCount > v2.itemCount
			end
		end
	end
end

local function Sort_BagItem(ItemTable)
	for BagType, Slots in pairs(ItemTable) do
		table.sort(Slots, SortFunc)
	end
end

--[[
local function Update_CIMI(button)
	--CIMI_AddToFrame(button, ContainerFrameItemButton_CIMIUpdateIcon)
    --ContainerFrameItemButton_CIMIUpdateIcon(button.CanIMogItOverlay)
end
--]]

local function Update_SlotItem(slot, v)
	SetItemButtonTexture(slot, v.itemTexture or F.Path("Bag_Slot")) --Interface\Paperdoll\UI-PaperDoll-Slot-Bag
	--SetItemButtonQuality(itemButton, quality, itemID)
	SetItemButtonCount(slot, v.itemCount)
	--SetItemButtonDesaturated(slot, v.itemLocked, 0.5,0.5,0.5)
	SetItemButtonDesaturated(slot, v.itemLocked)
	if not F.IsClassic then
		--ContainerFrameItemButton_UpdateItemUpgradeIcon(slot); --待改

		--local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(v.bagID, v.slotID)
		local QuestInfo = C_Container.GetContainerItemQuestInfo(v.bagID, v.slotID)
		if QuestInfo.isQuestItem then
			slot.QuestIcon: Show()
		else
			slot.QuestIcon: Hide()
		end
	else
		slot.QuestIcon: Hide()
	end

	if v.itemQuality == 0 then
		slot.JunkIcon: Show()
	else
		slot.JunkIcon: Hide()
	end
	if v.itemQuality and (v.itemQuality > 1) then
		local color = ITEM_QUALITY_COLORS[v.itemQuality]
		slot.QualityIcon: SetVertexColor(color.r,color.g,color.b)
		slot.QualityIcon: Show()
		slot.Border: SetBackdropBorderColor(color.r,color.g,color.b, 0.9)
	else
		slot.QualityIcon: Hide()
		slot.Border: SetBackdropBorderColor(F.Color(C.Color.W4, 0.9))
	end
	
	local isNewItem = C_NewItems.IsNewItem(v.bagID, v.slotID)
	if isNewItem then
		slot.NewItemTexture: Show()
	else
		slot.NewItemTexture: Hide()
	end
	
	if (v.itemType == ITEMCLASS_Weapon) or (v.itemType == ITEMCLASS_Armor) then
		slot.Level: SetText(v.itemLevel)
	else
		slot.Level: SetText("")
	end
	
	--local start, duration, enable = GetContainerItemCooldown(v.bagID, v.slotID)
	local start, duration, enable = C_Container.GetContainerItemCooldown(v.bagID, v.slotID)
	CooldownFrame_Set(slot.cooldown, start, duration, enable)
	if duration > 0 and enable == 0 then
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
	else
		SetItemButtonTextureVertexColor(slot, 1, 1, 1)
	end

	--local isBattlePayItem = IsBattlePayItem(v.bagID, v.slotID)
	local isBattlePayItem = C_Container.IsBattlePayItem(v.bagID, v.slotID)
	--Update_CIMI(slot)
end

local function Update_BagItem(frame)
	for BagType, Slots in pairs(Bag) do
		for k,v in ipairs(Bag[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
		for k,v in ipairs(BagFree[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
	end
end

local function Init_Pos(frame, bag)
	bag.NumBag = bag.NumBag or 0
	bag.NumFree = bag.NumFree or 0
	bag.NumExtra = bag.NumExtra or 0
	bag.NumExtraT = bag.NumExtraT or 0
end

local function BagItem_Pos(frame, bag)
	local pos_x, pos_y
	local num = 0
	local item_type = ""
	BagGap_Reset(frame, ITEMCLASS)
	for k,v in ipairs(Bag[0]) do
		num = num + 1
		if v.itemType and it ~= v.itemType then
			it = v.itemType
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num - y * config.perLine - 1
			frame["BagIcon"..it]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIcon"..it]: Show()
			num = num + 1
		end
		y = floor((num+config.perLine-1)/config.perLine) - 1
		x = num - y * config.perLine - 1
		--[[
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end
	bag.NumBag = num
end

local function BagFreeItem_Pos(frame, bag)
	local newgap = false
	local freegap = false
	local num = bag.NumBag
	for k,v in ipairs(BagFree[0]) do
		num = num + 1
		if (not newgap) and v.itemType then
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num- y * config.perLine - 1
			frame["BagIconNew"]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIconNew"]: Show()
			num = num + 1
			newgap = true
		end
		if (not freegap) and (not v.itemType) then
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num- y * config.perLine - 1
			frame["BagIconFree"]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIconFreeText"]: SetText(SlotNum.Free)
			frame["BagIconFree"]: Show()
			num = num + 1
			freegap = true
		end
		y = floor((num+config.perLine-1)/config.perLine) - 1
		x = num- y * config.perLine - 1
		--[[
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end
	bag.NumFree = num - bag.NumBag
end

local function OtherBagItem_Pos(frame, bag)
	local e = 0
	local et = 0
	local num = bag.NumBag + bag.NumFree
	for t,s in pairs(Bag) do
		if t ~= 0 then
			et = et + 1
			e = ceil(e/config.perLine)*config.perLine
			for k,v in ipairs(s) do
				e = e + 1
				y = floor((num+config.perLine-1)/config.perLine)+floor((e+config.perLine-1)/config.perLine) - 1
				x = e - (floor((e+config.perLine-1)/config.perLine)-1) * config.perLine - 1
				--[[
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
				--]]
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
			end
			for k,v in ipairs(BagFree[t]) do
				e = e + 1
				y = floor((num+config.perLine-1)/config.perLine)+floor((e+config.perLine-1)/config.perLine) - 1
				x = e - (floor((e+config.perLine-1)/config.perLine)-1) * config.perLine - 1
				--[[
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
				--]]
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", bag, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
			end
		end
	end
	bag.NumExtra = e
	bag.NumExtraT = et
end

local function BagFrame_ReSize(frame, bag)
	y = (config.buttonSize+config.buttonGap*2)*(ceil((bag.NumBag + bag.NumFree)/config.perLine)+ceil(bag.NumExtra/config.perLine))+config.border*(2+bag.NumExtraT)
	frame.Bags: SetHeight(y)
	frame: SetHeight(y+48+2)
end

local function Pos_AllBagItem(frame, pos)
	local x,y
	local num = 0
	local e = 0
	local et = 0
	local it = ""
	BagGap_Reset(frame, ITEMCLASS)
	for k,v in ipairs(Bag[0]) do
		num = num + 1
		if v.itemType and it ~= v.itemType then
			it = v.itemType
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num - y * config.perLine - 1
			frame["BagIcon"..it]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIcon"..it]: Show()
			num = num + 1
		end
		y = floor((num+config.perLine-1)/config.perLine) - 1
		x = num - y * config.perLine - 1
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end
	
	local newgap = false
	local freegap = false
	for k,v in ipairs(BagFree[0]) do
		num = num + 1
		if (not newgap) and v.itemType then
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num- y * config.perLine - 1
			frame["BagIconNew"]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIconNew"]: Show()
			num = num + 1
			newgap = true
		end
		if (not freegap) and (not v.itemType) then
			y = floor((num+config.perLine-1)/config.perLine) - 1
			x = num- y * config.perLine - 1
			frame["BagIconFree"]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIconFreeText"]: SetText(SlotNum.Free)
			frame["BagIconFree"]: Show()
			num = num + 1
			freegap = true
		end
		y = floor((num+config.perLine-1)/config.perLine) - 1
		x = num- y * config.perLine - 1
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end

	for t,s in pairs(Bag) do
		if t ~= 0 then
			et = et + 1
			e = ceil(e/config.perLine)*config.perLine
			for k,v in ipairs(s) do
				e = e + 1
				y = floor((num+config.perLine-1)/config.perLine)+floor((e+config.perLine-1)/config.perLine) - 1
				x = e - (floor((e+config.perLine-1)/config.perLine)-1) * config.perLine - 1
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
			for k,v in ipairs(BagFree[t]) do
				e = e + 1
				y = floor((num+config.perLine-1)/config.perLine)+floor((e+config.perLine-1)/config.perLine) - 1
				x = e - (floor((e+config.perLine-1)/config.perLine)-1) * config.perLine - 1
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
		end
	end

	y = (config.buttonSize+config.buttonGap*2)*(ceil(num/config.perLine)+ceil(e/config.perLine))+config.border*(2+et)
	frame.Bags: SetHeight(y)
	frame: SetHeight(y+48+2)
end

local function GetItemInfoFromBS(BagID, SlotID)
	--local texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = C_Container.GetContainerItemInfo(BagID, SlotID)
	local ItemInfo = C_Container.GetContainerItemInfo(BagID, SlotID)
	--if texture then
	if ItemInfo then
		--local _, itemID = strsplit(":", itemLink)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = C_Item.GetItemInfo(ItemInfo.itemID)
		--local itemID, itemType, itemSubType, itemEquipLoc, itemTexture, itemClassID, itemSubClassID = GetItemInfoInstant(itemLink) 
		if (itemType == ITEMCLASS_Weapon) or (itemType == ITEMCLASS_Armor) then
			--local EffectiveItemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
			local EffectiveItemLevel = C_Item.GetDetailedItemLevelInfo(ItemInfo.hyperlink)
			itemLevel = EffectiveItemLevel or itemLevel
		end
		itemType = itemType or "Other"
		if not ITEMCLASS[itemType] then
			itemType = "Other"
		end
		if ItemInfo.quality == 0 then
			itemType = "Sale"
		end
		if itemType == ITEMCLASS_Consumable then
			if ITEMCLASS.Elixir.SubClass[itemSubType] then
				itemType = "Elixir"
			end
			if ITEMCLASS.Food.SubClass[itemSubType] then
				itemType = "Food"
			end
		end
		if ITEMCLASS.Hearthstone.itemID[ItemInfo.itemID] then
			itemType = "Hearthstone"
		end

		return itemName, ItemInfo.itemID, ItemInfo.iconFileID, ItemInfo.stackCount, itemType, itemSubType, itemEquipLoc, ItemInfo.quality, itemLevel, ItemInfo.isLocked
	else
		return nil,nil,nil,nil,nil,nil,nil,nil,nil
	end
end

local function GetItemTable(bagID, slotID, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked)
	local table = {
		bagID = bagID, slotID = slotID, 
		itemName = itemName, itemID = itemID, 
		itemTexture = texture, itemCount = itemCount, 
		itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc,
		itemQuality = quality, itemLevel = itemLevel,
		itemLocked = locked
	}
	return table
end

local function RefreshItemTable(table, bagID, slotID, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked)
	table.bagID = bagID
	table.slotID = slotID
	table.itemName = itemName
	table.itemID = itemID
	table.itemTexture = texture
	table.itemCount = itemCount
	table.itemType = itemType
	table.itemSubType = itemSubType
	table.itemEquipLoc = itemEquipLoc
	table.itemQuality = quality
	table.itemLevel = itemLevel
	table.itemLocked = locked
end

local function Check_BagNumSlots(frame, bagID)
	local num = C_Container.GetContainerNumSlots(bagID)
	if frame.Num then
		if frame.Num > num then
			for i = num,frame.Num do
				if frame["Slot"..i] then
					frame["Slot"..i]:Hide()
				end
			end
		elseif frame.Num < num then
			for i = frame.Num,num do
				if frame["Slot"..i] then
					frame["Slot"..i]:Show()
				end
			end
		end
	end
	frame.Num = num
end

local function Insert_BagItem(f)
	wipe(Bag)
	wipe(BagFree)
	for b = 0, NUM_BAG_SLOTS + 1 do
		local BagType = select(2,C_Container.GetContainerNumFreeSlots(b)) or 0
		if not f["Bag"..b] then
			f["Bag"..b] = Create_BagFrame(f, b)
		end
		Check_BagNumSlots(f["Bag"..b], b)
		if not Bag[BagType] then
			Bag[BagType] = {}
		end
		if not BagFree[BagType] then
			BagFree[BagType] = {}
		end
		for s = 1, ContainerFrame_GetContainerNumSlots(b) do
			if not f["Bag"..b]["Slot"..s] then
				f["Bag"..b]["Slot"..s] = Create_BagItemButton(f["Bag"..b], b, s)
			end
			local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(b, s)
			if texture then
				insert(Bag[BagType], GetItemTable(b, s, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked))
			else
				insert(BagFree[BagType], GetItemTable(b, s, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil))
			end
		end
	end
	SlotNum.Free = #BagFree[0]
	SlotNum.Total = SlotNum.Free + #Bag[0]
end

local BagFreeNew = {}
local function BagFreeItem_Insert(frame)
	wipe(BagFreeNew)
	for b = 0, NUM_BAG_SLOTS + 1 do
		local BagType = select(2,C_Container.GetContainerNumFreeSlots(b)) or 0
		if not frame["Bag"..b] then
			frame["Bag"..b] = Create_BagFrame(frame, b)
		end
		Check_BagNumSlots(frame["Bag"..b], b)
		if not Bag[BagType] then
			Bag[BagType] = {}
		end
		if not BagFree[BagType] then
			BagFree[BagType] = {}
		end
		for s = 1, ContainerFrame_GetContainerNumSlots(b) do
			if not frame["Bag"..b]["Slot"..s] then
				frame["Bag"..b]["Slot"..s] = Create_BagItemButton(frame["Bag"..b], b, s)
				local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(b, s)
				insert(BagFree[BagType], GetItemTable(b, s, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked))
			end
		end
	end
end

local function Refresh_SlotNumFree(frame)
	SlotNum.Free = 0
	for BagID = 0, NUM_BAG_SLOTS + 1 do
		local FreeSlots,BagType = C_Container.GetContainerNumFreeSlots(BagID)
		if BagType == 0 then
			SlotNum.Free = SlotNum.Free + FreeSlots or 0
		end
	end
	frame["BagIconFreeText"]: SetText(SlotNum.Free)
end

local function Refresh_BagItemInfo(frame)
	for BagType, Slots in pairs(Bag) do
		for k,v in ipairs(Bag[BagType]) do
			local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(v.bagID, v.slotID)
			if texture then
				RefreshItemTable(v, v.bagID, v.slotID, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked)
			else
				RefreshItemTable(v, v.bagID, v.slotID, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil)
			end
		end
		for k,v in ipairs(BagFree[BagType]) do
			local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(v.bagID, v.slotID)
			if texture then
				RefreshItemTable(v, v.bagID, v.slotID, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked)
			else
				RefreshItemTable(v, v.bagID, v.slotID, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil)
			end
		end
	end
end

local function Remove_BagItem(frame)
	for b = 0, NUM_BAG_SLOTS + 1 do
		Check_BagNumSlots(frame["Bag"..b], b)
	end
	for BagType, Slots in pairs(Bag) do
		for k,v in ipairs(Bag[BagType]) do
			if not v.itemTexture then
				tinsert(BagFree[BagType], v)
				tremove(Bag[BagType], k)
			end
		end
	end
end

local function FullUpdate_BagItem(frame)
	Insert_BagItem(frame)
	Sort_BagItem(Bag)
	Update_BagItem(frame)
	--Pos_AllBagItem(frame, frame.Bags)
	Init_Pos(frame, frame.Bags)
	BagItem_Pos(frame, frame.Bags)
	BagFreeItem_Pos(frame, frame.Bags)
	OtherBagItem_Pos(frame, frame.Bags)
	BagFrame_ReSize(frame, frame.Bags)
end

local function LimitedUpdate_BagItem(frame)
	BagFreeItem_Insert(frame)
	Refresh_BagItemInfo()
	Remove_BagItem(frame)
	Sort_BagItem(Bag)
	Sort_BagItem(BagFree)
	Refresh_SlotNumFree(frame)
	Update_BagItem(frame)
	--Pos_AllBagItem(frame, frame.Bags)
	Init_Pos(frame, frame.Bags)
	BagItem_Pos(frame, frame.Bags)
	BagFreeItem_Pos(frame, frame.Bags)
	OtherBagItem_Pos(frame, frame.Bags)
	BagFrame_ReSize(frame, frame.Bags)
end

local function Update_ItemLock(self, ...)
	if (not (self and self:IsShown())) then return end
	local bagID, slotID = ...
	if bagID and slotID and self["Bag"..bagID] and self["Bag"..bagID]["Slot"..slotID] then
		local _, _, locked, quality = C_Container.GetContainerItemInfo(bagID, slotID)
		local button = self["Bag"..bagID]["Slot"..slotID]
		SetItemButtonDesaturated(button, locked, 0.5,0.5,0.5)
		if locked then
			if quality and (quality > 1) then
				button.QualityIcon: SetVertexColor(0.5,0.5,0.5)
				button.Border: SetBackdropBorderColor(0.5,0.5,0.5, 0.9)
			end
		else
			if quality and (quality > 1) then
				local color = ITEM_QUALITY_COLORS[quality]
				button.QualityIcon: SetVertexColor(color.r,color.g,color.b)
				button.Border: SetBackdropBorderColor(color.r,color.g,color.b, 0.9)
			end
		end
	end
end

local function Update_ItemCooldown(frame, ...)
	if (not frame) then return end
	local itemButton
	for bagID = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		if _G[format("Quafe_Bag%s", bagID)] then
			for slotID = 1, ContainerFrame_GetContainerNumSlots(bagID)do
				local start, duration, enable = C_Container.GetContainerItemCooldown(bagID, slotID)
				itemButton = _G[format("Quafe_Bag%sSlot%s", bagID, slotID)]
				if itemButton then
					CooldownFrame_Set(itemButton.cooldown, start, duration, enable)
					if duration > 0 and enable == 0 then
						SetItemButtonTextureVertexColor(itemButton, 0.4, 0.4, 0.4)
					else
						SetItemButtonTextureVertexColor(itemButton, 1, 1, 1)
					end
				end
			end
		end
	end
end

local function Update_ItemUpgradeIcons(frame)
	if F.IsClassic then return end
	local itemButton
	for bagID = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		if _G[format("Quafe_Bag%s", bagID)] then
			for slotID = 1, ContainerFrame_GetContainerNumSlots(bagID)do
				itemButton = _G[format("Quafe_Bag%sSlot%s", bagID, slotID)]
				if itemButton then
					--ContainerFrameItemButton_UpdateItemUpgradeIcon(itemButton)	--待改
				end
			end
		end
	end
end

local function Search_BagItem(frame, ...)
	if (not (frame and frame:IsShown())) then return end
	local itemButton
	local ItemInfo
	for bagID = 0, NUM_BAG_SLOTS + 1 do
		for slotID = 1, ContainerFrame_GetContainerNumSlots(bagID) do
			--local _, _, _, quality, _, _, _, isFiltered = C_Container.GetContainerItemInfo(bagID, slotID)
			itemButton = frame["Bag"..bagID]["Slot"..slotID]
			if itemButton then
				ItemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
				if ItemInfo then
					if  ItemInfo.isFiltered then
						SetItemButtonDesaturated(item, 1)
						itemButton.Anchor:SetAlpha(0.4)
						--itemButton.searchOverlay:Show();
						if ItemInfo.quality and (ItemInfo.quality > 1) then
							itemButton.QualityIcon: SetVertexColor(0.5,0.5,0.5)
							itemButton.Border: SetBackdropBorderColor(0.5,0.5,0.5, 0.9)
						end
					else
						SetItemButtonDesaturated(item)
						itemButton.Anchor:SetAlpha(1)
						--itemButton.searchOverlay:Hide();
						if ItemInfo.quality and (ItemInfo.quality > 1) then
							local color = ITEM_QUALITY_COLORS[ItemInfo.quality]
							itemButton.QualityIcon: SetVertexColor(color.r,color.g,color.b)
							itemButton.Border: SetBackdropBorderColor(color.r,color.g,color.b, 0.9)
						end
					end
				end
			end
		end
	end
end

----------------------------------------------------------------
--> Key Ring
----------------------------------------------------------------

-- KEYRING_CONTAINER = -2

local function KeyRing_OnClick()
	if (CursorHasItem()) then
		PutKeyInKeyRing();
	else
		ToggleBag(KEYRING_CONTAINER);
	end
end

local function KeyRing_Template(frame)
	local KeyRingFrame = CreateFrame("CheckButton", nil, frame)
	KeyRingFrame: SetSize(24,24)
	KeyRingFrame: RegisterForClicks("LeftButtonUp", "RightButtonUp")

	F.create_Backdrop(KeyRingFrame, 2, 8, 4, C.Color.Y1,0, C.Color.W4,0.9)
	KeyRingFrame.Bg: SetAlpha(0)
	KeyRingFrame.tooltipText = KEYRING

	local Icon = KeyRingFrame:CreateTexture(nil, "ARTWORK")
	Icon: SetTexture(F.Path("Bag_Key"))
	Icon: SetSize(20,20)
	Icon: SetPoint("CENTER")
	Icon: SetVertexColor(F.Color(C.Color.W3))

	KeyRingFrame.Icon = Icon

	KeyRingFrame: SetScript("OnClick", KeyRing_OnClick)
	KeyRingFrame: SetScript("OnReceiveDrag", function(self)
		if (CursorHasItem()) then
			PutKeyInKeyRing();
		end
	end)

	KeyRingFrame: SetScript("OnEnter", function(self)
		self.Bg: SetAlpha(1)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			GameTooltip:SetText(self.tooltipText)
			GameTooltip:Show()
		end
	end)
	KeyRingFrame: SetScript("OnLeave", function(self)
		self.Bg: SetAlpha(0)
		GameTooltip:Hide()
	end)

	return KeyRingFrame
end

local function KeyRingButton_Init(frame)
	if not frame.BagKeys then
		frame.BagKeys = Create_BagFrame(frame, KEYRING_CONTAINER)
	end
	Check_BagNumSlots(frame.BagKeys, KEYRING_CONTAINER)
	for slotID = 1, ContainerFrame_GetContainerNumSlots(KEYRING_CONTAINER) do
		if not frame.BagKeys[slotID] then
			frame.BagKeys[slotID] = Create_BagItemButton(frame.BagKeys, KEYRING_CONTAINER, slotID)
		end
	end
end

local function KeyRingItem_Update(frame)
	for slotID = 1, ContainerFrame_GetContainerNumSlots(KEYRING_CONTAINER) do
		local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(KEYRING_CONTAINER, slotID)
	end
end

----------------------------------------------------------------
--> Currency
----------------------------------------------------------------

local function RefreshButton_Template(frame)
	local DummyButton = CreateFrame("Button", nil, frame)
	DummyButton: SetSize(24,24)
	DummyButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")

	local Backdrop = F.Create.Backdrop(DummyButton, 2, false, 8, 4, C.Color.Y1,0, C.Color.W4,0.9)
	Backdrop: SetAlpha(0)
	DummyButton.tooltipText = L['BAG_GROUP_REFRESH']

	local Icon = F.Create.Texture(DummyButton, "ARTWORK", 1, F.Path("Bag_Clean"), C.Color.W3, 1, {20,20})
	Icon: SetPoint("CENTER")

	DummyButton: SetScript("OnEnter", function(self)
		Backdrop: SetAlpha(1)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			GameTooltip:SetText(self.tooltipText)
			GameTooltip:Show()
		end
	end)
	DummyButton: SetScript("OnLeave", function(self)
		Backdrop: SetAlpha(0)
		GameTooltip:Hide()
	end)

	DummyButton: SetScript("OnClick", function(self)
		frame:GetParent():FullUpdate_BagItem()
	end)

	return DummyButton
end

local function RefreshButton_Toggle(frame)
	local point, relativeTo, relativePoint = frame.Currency.RefreshButton:GetPoint()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
		frame.Currency.RefreshButton: SetPoint(point, relativeTo, relativePoint, 0, 0)
		frame.Currency.RefreshButton: Hide()
	else
		frame.Currency.RefreshButton: SetPoint(point, relativeTo, relativePoint, 40, 0)
		frame.Currency.RefreshButton: Show()
	end
end

local function Currency_Frame(f)
	local currency = CreateFrame("Frame", nil, f)
	currency: SetSize((config.buttonSize+config.buttonGap*2)*config.perLine+config.border*2, 48)
	currency: SetPoint("TOP", f, "TOP", 0,0)
	F.create_Backdrop(currency, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)
	f.Currency = currency

	local money = F.Create.Font(currency, "ARTWORK", C.Font.NumOW, 24, nil, C.Color.Y2, 1, C.Color.W1, 0, {0,0}, "RIGHT", "CENTER")
	money: SetPoint("RIGHT", currency, "RIGHT", -42,0)
	f.Currency.Money = money

	local MoneyHelp = CreateFrame("Button", nil, currency)
	MoneyHelp: SetAllPoints(money)
	MoneyHelp.List = {}
	MoneyHelp.Total = 0
	MoneyHelp: SetScript("OnEnter", function(self)
		if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold then
			wipe(self.List)
			self.Total = 0
			for k,v in pairs(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold) do
				self.Total = self.Total + v.Gold
				tinsert(self.List, v)
			end
			table.sort(self.List, function(v1, v2)
				return v1.Gold > v2.Gold 
			end)
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0,-10)
			GameTooltip:AddDoubleLine(TOTAL, format("%s%s", self.Total, F.Hex(C.Color.Y2).."G|r"), 1,1,1,1,1,1)
			--GameTooltip:SetText(format(GOLD_AMOUNT_TEXTURE, self.Total), 1,1,1)
			GameTooltip:AddLine(" ")
			for i = 1,#self.List do
				if i <= 20 then
					GameTooltip:AddDoubleLine(self.List[i]["Name"].."-"..self.List[i]["Realm"], format("%s%s", self.List[i]["Gold"],F.Hex(C.Color.Y2).."G|r"), 1, 1, 1, 1, 1, 1)
				end
			end
			GameTooltip: Show()
		end
	end)
	MoneyHelp: SetScript("OnLeave", function(self)
		GameTooltip: Hide()
	end)

	f.Currency.MoneyHold = MoneyHelp

	local closebutton = CreateFrame("Button", nil, currency)
	closebutton: SetSize(24,30)
	closebutton: SetPoint("RIGHT", currency, "RIGHT", -2,0)
	closebutton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	F.create_Backdrop(closebutton, 0, 0, 0, C.Color.Y1,0, C.Color.W1,0)

	local closebuttonicon = F.Create.Font(closebutton, "ARTWORK", C.Font.NumOW, 24, nil, C.Color.W3, 1, C.Color.W1, 0, {0,0}, "CENTER", "CENTER")
	closebuttonicon: SetPoint("CENTER", closebutton, "CENTER")
	closebuttonicon: SetText("X")
	
	closebutton: SetScript("OnClick", function(self, button)
		f:Hide()
	end)
	closebutton: SetScript("OnEnter", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Y1,1))
		closebuttonicon: SetTextColor(F.Color(C.Color.Config.Back))
	end)
	closebutton: SetScript("OnLeave", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Y1,0))
		closebuttonicon: SetTextColor(F.Color(C.Color.W3))
	end)
	
	local menubutton = CreateFrame("Button", nil, currency)
	menubutton: SetSize(24,30)
	menubutton: SetPoint("LEFT", currency, "LEFT", 2,0)
	F.create_Backdrop(menubutton, 0, 0, 0, C.Color.Y1,0, C.Color.W1,0)
	
	local menubuttonicon = F.Create.Texture(menubutton, "ARTWORK", 1, F.Path("Bag_Menu"), C.Color.W3, 1, {32,32})
	menubuttonicon: SetPoint("CENTER", menubutton, "CENTER", 0,0)
	
	menubutton: SetScript("OnClick", function(self, button)
		if f.Extra then
			if f.Extra: IsShown() then
				f.Extra: Hide()
			else
				f.Extra: Show()
			end
		end
	end)
	menubutton: SetScript("OnEnter", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Y1,1))
		menubuttonicon: SetVertexColor(F.Color(C.Color.Config.Back))
	end)
	menubutton: SetScript("OnLeave", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Config.Exit,0))
		menubuttonicon: SetVertexColor(F.Color(C.Color.W3))
	end)

	local RefreshButton = RefreshButton_Template(currency)
	RefreshButton: SetPoint("CENTER", menubutton, "CENTER", 40, 0)

	if F.IsClassic then
		local KeyRingFrame = KeyRing_Template(currency)
		KeyRingFrame: SetPoint("CENTER", RefreshButton, "CENTER", 40, 0)
	end

	f.Currency.RefreshButton = RefreshButton
	RefreshButton_Toggle(f)
end

local function BagExtra_Frame(f)
	local bagextra = CreateFrame("Frame", "Quafe_BagExtra", f)
	bagextra: SetSize((config.buttonSize+config.buttonGap*2)*config.perLine+config.border*2, 36)
	bagextra: SetPoint("BOTTOM", f, "TOP", 0,2)
	F.create_Backdrop(bagextra, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)
	bagextra: Hide()
	f.Extra = bagextra
	
	local editbox = CreateFrame("EditBox", "Quafe_BagEditBox", bagextra, "BagSearchBoxTemplate")
	editbox: SetSize(120,16)
	editbox: SetPoint("LEFT", bagextra, "LEFT", 35,0)
	editbox: SetAutoFocus(false)
	editbox.Left: Hide()
	editbox.Middle: Hide()
	editbox.Right: Hide()
	F.create_Backdrop(editbox, 6, 8, 6, C.Color.W2,0, C.Color.W4,0.9)

	local AddSlotButton = CreateFrame("Button", nil, bagextra)
	AddSlotButton: SetSize(24,24)
	AddSlotButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	AddSlotButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	F.create_Backdrop(AddSlotButton, 2, 8, 4, C.Color.Y1,0, C.Color.W4,0.9)
	AddSlotButton.Bg: SetAlpha(0)
	AddSlotButton.tooltipText = BACKPACK_AUTHENTICATOR_INCREASE_SIZE

	local AddSlotButtonIcon = F.Create.Texture(AddSlotButton, "ARTWORK", 0, F.Path("Bag_Button3"), C.Color.W3, 1, {18,18})
	--local AddSlotButtonIcon = AddSlotButton:CreateTexture(nil, "ARTWORK", )
	--AddSlotButtonIcon: SetTexture(F.Path("Bag_Button3"))
	--AddSlotButtonIcon: SetSize(18,18)
	AddSlotButtonIcon: SetPoint("CENTER", AddSlotButton, "CENTER", 0,0)
	--AddSlotButtonIcon: SetVertexColor(F.Color(C.Color.W3))

	AddSlotButton: RegisterEvent("BAG_OPEN")
	AddSlotButton: RegisterEvent("BAG_UPDATE")
	AddSlotButton: SetScript("OnEvent", function(self, event, ...)
		local size = ContainerFrame_GetContainerNumSlots(0)
		local extended = size > BACKPACK_BASE_SIZE
		if extended then
			AddSlotButton: Hide()
		else
			AddSlotButton: Show()
		end
	end)

	AddSlotButton: SetScript("OnClick", function(self, button, ...)
		StaticPopup_Show("BACKPACK_INCREASE_SIZE")
		ContainerFrame_SetBackpackForceExtended(true)
	end)

	AddSlotButton: SetScript("OnEnter", function(self)
		self.Bg: SetAlpha(1)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			GameTooltip:SetText(self.tooltipText)
			GameTooltip:Show()
		end
	end)
	AddSlotButton: SetScript("OnLeave", function(self)
		self.Bg: SetAlpha(0)
		GameTooltip:Hide()
	end)
	
	local lastbutton
	for bagID = 0, NUM_BAG_SLOTS + 1 do
		local button
		if F.IsClassic then
			if bagID == 0 then
				button = CreateFrame("CheckButton", "Quafe_BagBackpack", bagextra, "Quafe_BackpackButtonClassicTemplate")
				
			else
				button = CreateFrame("CheckButton", "Quafe_BagBag"..(bagID-1).."Slot", bagextra, "Quafe_BagSlotButtonClassicTemplate")
			end
		else
			if bagID == 0 then
				button = CreateFrame("ItemButton", "Quafe_BagBackpack", bagextra, "Quafe_BackpackButtonTemplate")
				button.commandName = "TOGGLEBACKPACK"
			elseif bagID == 5 then
				button = CreateFrame("ItemButton", "Quafe_BagReagentBag0Slot", bagextra, "Quafe_BagSlotButtonTemplate")
				button.commandName = "TOGGLEREAGENTBAG1"
			else
				button = CreateFrame("ItemButton", "Quafe_BagBag"..(bagID-1).."Slot", bagextra, "Quafe_BagSlotButtonTemplate")
				button.commandName = "TOGGLEBAG"..(5-bagID)
			end
		end
		button: SetSize(24,24)
		local invID
		if bagID == 0 then
			invID = bagID
			button: SetPoint("RIGHT", bagextra, "RIGHT", -33,0)
		else
			invID = C_Container.ContainerIDToInventoryID(bagID)
			button: SetPoint("RIGHT", lastbutton, "LEFT", -4,0)
		end
		button.invID = invID
		button.bagID = bagID
		button: SetID(invID)
		
		--button: SetNormalTexture("")
		--button: SetNormalTexture(0)
		button: ClearNormalTexture()
		button: SetPushedTexture(F.Path("Button\\Bag_Pushed"))
		button: SetHighlightTexture(F.Path("Button\\Bag_Hightlight"))

		button.icon: SetAllPoints(button)
		button.icon: SetTexCoord(0.1,0.9, 0.1,0.9)
		
		button.Border = CreateFrame("Frame", nil, button, "BackdropTemplate")
		button.Border: SetFrameLevel(button:GetFrameLevel()+1)
		button.Border: SetAllPoints(button)

		Create_ButtonBg(button.Border, 1, 0)
		button.Border: SetBackdropColor(F.Color(C.Color.W1, 0))
		button.Border: SetBackdropBorderColor(F.Color(C.Color.W4, 0.9))

		if button.IconBorder then
			--button.IconBorder: SetTexture("")
			--button.IconBorder: Hide()
			button.IconBorder: SetAlpha(0)
		end
		
		button: RegisterForDrag("LeftButton", "RightButton")
		--button: RegisterForClicks("anyUp")
		--[[
		button: SetScript("OnClick", function(self, btn)
			if(PutItemInBag(self.invID)) then return end
			if not IsShiftKeyDown() then
				PickupBagFromSlot(self.invID)
			end
		end)
		button: SetScript("OnReceiveDrag", function(self)
			if(PutItemInBag(self.invID)) then return end
			if not IsShiftKeyDown() then
				PickupBagFromSlot(self.invID)
			end
		end)
		button: SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if ( GameTooltip:SetInventoryItem("player", self:GetID()) ) then
				local bindingKey = GetBindingKey("TOGGLEBAG"..(4 -  (self:GetID() - CharacterBag0Slot:GetID())))
				if ( bindingKey ) then
					GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..bindingKey..")"..FONT_COLOR_CODE_CLOSE)
				end
				GameTooltip: Show()
			else
				GameTooltip:SetText(EQUIP_CONTAINER, 1.0, 1.0, 1.0)
			end
		end)
		button: SetScript("OnLeave", function(self)
			GameTooltip: Hide()
		end)
		--]]
		lastbutton = button
		f.Extra["Bag"..bagID] = button
	end
	
	f.Extra: RegisterEvent("BAG_UPDATE")
	--f.Extra: RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	f.Extra: RegisterEvent("ITEM_LOCK_CHANGED")
	f.Extra: SetScript("OnEvent", function(self, event, ...)
		for bagID = 0, NUM_BAG_SLOTS + 1 do
			if bagID == 0 then
				f.Extra["Bag"..bagID].icon:SetTexture([[Interface\Buttons\Button-Backpack-Up]])
			else
				local icon = GetInventoryItemTexture("player", f.Extra["Bag"..bagID].invID)
				f.Extra["Bag"..bagID].icon:SetTexture(icon or [[Interface\Paperdoll\UI-PaperDoll-Slot-Bag]])
			end
			f.Extra["Bag"..bagID].icon:SetDesaturated(IsInventoryItemLocked(f.Extra["Bag"..bagID].invID))
		end
	end)
end

--- ------------------------------------------------------------
--> Can I Mog it
--- ------------------------------------------------------------

local CIMI_Load = false
local function CanIMogIt_Load()
	if C_AddOns.IsAddOnLoaded("CanIMogIt") and (not CIMI_Load) then
		--> UpdateIcon functions
		function QuafeItemButton_CIMIUpdateIcon(self)
			if not self or not self:GetParent() then return end
			if not CIMI_CheckOverlayIconEnabled(self) then
				self.CIMIIconTexture:SetShown(false)
				self:SetScript("OnUpdate", nil)
				return
			end
			local bag = self:GetParent().bagID
			local slot = self:GetParent().slotID
			CIMI_SetIcon(self, QuafeItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
		end
		
		--> Begin adding to frames
		function CIMI_QuafeAddFrame(event, addonName)
			if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CIMIEvents[event] then return end
			-- Add to frames
			-- Bags
			for bagID = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				for slotID = 1, MAX_CONTAINER_ITEMS do
					local frame = _G["Quafe_Bag"..bagID.."Slot"..slotID]
					if frame then
						CIMI_AddToFrame(frame, QuafeItemButton_CIMIUpdateIcon)
					end
				end
			end
			--C_Timer.After(.5, function() CIMI_QuafeAddFrame() end)
		end
		CanIMogIt.frame:AddEventFunction(CIMI_QuafeAddFrame)
		
		--> Event functions
		function CIMI_QuafeUpdate(self, event, ...)
			--CIMI_QuafeAddFrame(nil, "BANKFRAME_OPENED")
			for bagID = BANK_CONTAINER, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				for slotID = 1, MAX_CONTAINER_ITEMS do
					local frame = _G["Quafe_Bag"..bagID.."Slot"..slotID]
					if frame then
						QuafeItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
					end
				end
			end
		end
		--CanIMogIt: RegisterMessage("ResetCache", CIMI_QuafeUpdate)
		
		--function CIMI_QuafeEvents(self, event, ...)
		function CIMI_QuafeEvents(event)
			-- Update based on wow events
			if not CIMIEvents[event] then return end
			CIMI_QuafeUpdate()
		end
		--hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_QuafeEvents)
		CanIMogIt.frame:AddOverlayEventFunction(CIMI_QuafeEvents)

		--C_Timer.After(15, function() CanIMogIt:ResetCache() end)
		CIMI_Load = true
	end
	--[[
	function Quafe_UpdateAfter()
        C_Timer.After(.5, function() CIMI_QuafeAddFrame(nil, "PLAYER_LOGIN") end)
        C_Timer.After(.5, function() CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE") end)
    end
	--]]
end
--[[
local function CIMI_LoadCheck()
	if C_AddOns.IsAddOnLoaded("CanIMogIt") then
		Update_CIMI = function(button)
			CIMI_AddToFrame(button, ContainerFrameItemButton_CIMIUpdateIcon)
			ContainerFrameItemButton_CIMIUpdateIcon(button.CanIMogItOverlay)
		end
	end
end
--]]

--- ------------------------------------------------------------
--> Bag Frame
--- ------------------------------------------------------------

local function PlayerMoney_Update(frame)
	local money = GetMoney()
	local gold = floor(abs(money / 10000))
	local silver = floor(abs(mod(money / 100, 100)))
	local copper = floor(abs(mod(money, 100)))
	frame.Currency.Money: SetText(format("%s%s%s%s%s%s", gold,"|cff616161G|r",silver,"|cff616161S|r",copper,"|cff616161C|r"))

	if C.PlayerGuid and C.PlayerName and C.PlayerRealm then
		if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold[C.PlayerGuid] then
			Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold[C.PlayerGuid]["Gold"] = floor(abs(money / 10000))
		else
			Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold[C.PlayerGuid] = {
				Name = C.PlayerName,
				Realm = C.PlayerRealm,
				Class = C.PlayerClass,
				Gold = floor(abs(money / 10000)),
			}
		end
	end
end

local function UpdatePostion(frame, database)
	frame:StopMovingOrSizing()
	database[1], database[2], database[3], database[4], database[5] = frame:GetPoint()
end

local function Bag_Frame(frame)
	local BagFrame = CreateFrame("Frame", "Quafe_BagFrame", UIParent)
	BagFrame: SetFrameLevel(2)
	BagFrame: SetSize((config.buttonSize+config.buttonGap*2)*config.perLine+config.border*2, 48)
	--BagFrame: SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -40,-240)
	BagFrame: SetPoint("RIGHT", UIParent, "RIGHT", -80,0)

	function BagFrame: FullUpdate_BagItem()
		FullUpdate_BagItem(self)
	end
	
	BagFrame: SetClampedToScreen(true)
	BagFrame: SetMovable(true)

	frame.BagFrame = BagFrame

	Currency_Frame(frame.BagFrame)
	BagExtra_Frame(frame.BagFrame)

	local bags = CreateFrame("Frame", nil, frame.BagFrame)
	bags: SetSize((config.buttonSize+config.buttonGap*2)*config.perLine+config.border*2, config.buttonSize+config.border*2)
	bags: SetPoint("TOP", frame.BagFrame.Currency, "BOTTOM", 0,-2)
	F.create_Backdrop(bags, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)
	frame.BagFrame.Bags = bags
	
	Init_ItemClass()
	Init_BagGap(frame.BagFrame, ITEMCLASS)
	Insert_BagItem(frame.BagFrame)

	frame.BagFrame.Currency: EnableMouse(true)
	frame.BagFrame.Currency: RegisterForDrag("LeftButton","RightButton")
	frame.BagFrame.Currency: SetScript("OnDragStart", function(self) frame.BagFrame:StartMoving() end)
	frame.BagFrame.Currency: SetScript("OnDragStop", function(self)
		UpdatePostion(frame.BagFrame, Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BagPos)
	end)

	frame.BagFrame.Currency.MoneyHold: EnableMouse(true)
	frame.BagFrame.Currency.MoneyHold: RegisterForDrag("LeftButton","RightButton")
	frame.BagFrame.Currency.MoneyHold: SetScript("OnDragStart", function(self) frame.BagFrame:StartMoving() end)
	frame.BagFrame.Currency.MoneyHold: SetScript("OnDragStop", function(self)
		UpdatePostion(frame.BagFrame, Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BagPos)
	end)

	frame.BagFrame: RegisterEvent("PLAYER_LOGIN")
	frame.BagFrame: RegisterEvent("PLAYER_ENTERING_WORLD")
	--frame.BagFrame: RegisterEvent("BAG_OPEN");
	--frame.BagFrame: RegisterEvent("BAG_CLOSED");
	--frame.BagFrame: RegisterEvent("QUEST_ACCEPTED");
	--frame.BagFrame: RegisterEvent("UNIT_QUEST_LOG_CHANGED");
	frame.BagFrame: RegisterEvent("UNIT_INVENTORY_CHANGED")
	if not F.IsClassic then
		frame.BagFrame: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
	frame.BagFrame: RegisterEvent("BAG_UPDATE")
	frame.BagFrame: RegisterEvent("BAG_UPDATE_DELAYED")
	frame.BagFrame: RegisterEvent("BAG_NEW_ITEMS_UPDATED")
	frame.BagFrame: RegisterEvent("ITEM_LOCK_CHANGED")
	--frame.BagFrame: RegisterEvent("ITEM_UNLOCKED")
	frame.BagFrame: RegisterEvent("BAG_UPDATE_COOLDOWN")
	frame.BagFrame: RegisterEvent("INVENTORY_SEARCH_UPDATE")
	frame.BagFrame: RegisterEvent("PLAYER_MONEY")
	frame.BagFrame: SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			self:Hide()
			--[[
			ToggleBag = Bag_Toggle
			ToggleAllBags = Bag_Toggle
			ToggleBackpack = Bag_Toggle
			OpenBag = Bag_Open
			OpenAllBags = Bag_Open
			--]]
			--OpenBackpack = Bag_Open
			--CloseAllBags = Bag_Close
			--CloseBackpack = Bag_Close
			FullUpdate_BagItem(self)
			C_Timer.After(2, function() FullUpdate_BagItem(self) end)
			self.FullUpdate = true
		elseif event == "PLAYER_ENTERING_WORLD" then
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
				LimitedUpdate_BagItem(self)
			elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
				LimitedUpdate_BagItem(self)
			elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
				FullUpdate_BagItem(self)
			end
			PlayerMoney_Update(self)
		elseif event == "PLAYER_MONEY" then
			PlayerMoney_Update(self)
		elseif event == "BAG_OPEN" then

		elseif event == "BAG_CLOSED" then

		elseif event == "BAG_UPDATE" then
			if self:IsShown() then
				if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
					LimitedUpdate_BagItem(self)
				elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
					LimitedUpdate_BagItem(self)
				elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
					FullUpdate_BagItem(self)
				end
			end
		elseif event == "BAG_UPDATE_DELAYED" then
			
		elseif event == "BAG_NEW_ITEMS_UPDATED" then
			Update_BagItem(self)
		elseif event == "UNIT_INVENTORY_CHANGED" then
			Update_ItemUpgradeIcons(self)
		elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
			Update_ItemUpgradeIcons(self)
		elseif event == "ITEM_LOCK_CHANGED" then
			Update_ItemLock(self, ...)
		elseif event == "BAG_UPDATE_COOLDOWN" then
			Update_ItemCooldown(self, ...)
		elseif event == "INVENTORY_SEARCH_UPDATE" then
			Search_BagItem(self, ...)
		end
	end)
	
	frame.BagFrame: SetScript("OnShow", function(self)
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
			if self.FullUpdate then
				LimitedUpdate_BagItem(self)
			else
				FullUpdate_BagItem(self)
				C_Timer.After(2, function() FullUpdate_BagItem(self) end)
				self.FullUpdate = true
			end
		elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
			if self.FullUpdate then
				LimitedUpdate_BagItem(self)
			else
				FullUpdate_BagItem(self)
				C_Timer.After(2, function() FullUpdate_BagItem(self) end)
				self.FullUpdate = true
			end
		elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
			if self.FullUpdate then
				FullUpdate_BagItem(self)
			else
				FullUpdate_BagItem(self)
				C_Timer.After(2, function() FullUpdate_BagItem(self) end)
				self.FullUpdate = true
			end
		end
		--Quafe_UpdateAfter()
		PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
	end)
	
	frame.BagFrame: SetScript("OnHide", function(self)
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
			LimitedUpdate_BagItem(self)
		elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
			FullUpdate_BagItem(self)
		elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
			FullUpdate_BagItem(self)
		end
		--PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
	end)
end

--- ------------------------------------------------------------
--> Bank Functions
--- ------------------------------------------------------------

local Bank_BagID = {-3,-1,6,7,8,9,10,11,12}

local function GetActiveBankType(self)
	if not self:IsShown() then
		return nil;
	end
	if self.activeTabIndex == 1 then
		return Enum.BankType.Character;
	--elseif self.activeTabIndex == 2 then
		-- Insert reagent bank override if needed here
	elseif self.activeTabIndex == 3 then
		return Enum.BankType.Account;
	end
	return Enum.BankType.Character;
end

local function Create_BankFrame(f, bagID)
	local button = CreateFrame("Button", "Quafe_Bag"..bagID, f)
	button: SetID(bagID)
	button.isBag = 1

	return button
end

local function Sort_ReagentItem(ItemTable)
	local function SortFunc(v1, v2)
		if v1.itemType ~= v2.itemType then
			return v1.itemType < v2.itemType
		elseif v1.itemSubType ~= v2.itemSubType then
			return v1.itemSubType < v2.itemSubType
		elseif v1.itemLevel ~= v2.itemLevel then
			return v1.itemLevel > v2.itemLevel
		elseif v1.itemID ~= v2.itemID then
			if v1.itemID and v2.itemID then
				return v1.itemID > v2.itemID
			elseif v1.itemID then
				return true
			elseif v2.itemID then
				return false
			else
				return v1.itemName < v2.itemName
			end
		else
			return v1.itemCount > v2.itemCount
		end
	end
	table.sort(ItemTable, SortFunc)
end

local function Update_BankItem(frame)
	for BagType, Slots in pairs(Bank) do
		for k,v in ipairs(Bank[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
		for k,v in ipairs(BankFree[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
	end
end

local function Update_ReagentItem(f)
	for k,v in ipairs(Reagent) do
		Update_SlotItem(f["Bag"..v.bagID]["Slot"..v.slotID], v)
	end
	for k,v in ipairs(ReagentFree) do
		Update_SlotItem(f["Bag"..v.bagID]["Slot"..v.slotID], v)
	end
end

local function Pos_BankItem(frame, pos)
	local x,y
	local num = 0
	local e = 0
	local et = 0
	local it = ""
	BagGap_Reset(frame, ITEMCLASS)
	for k,v in ipairs(Bank[0]) do
		num = num + 1
		if v.itemType and it ~= v.itemType then
			it = v.itemType
			y = floor((num+config.bankperLine-1)/config.bankperLine) - 1
			x = num - y * config.bankperLine - 1
			frame["BagIcon"..it]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIcon"..it]: Show()
			num = num + 1
		end
		y = floor((num+config.bankperLine-1)/config.bankperLine) - 1
		x = num - y * config.bankperLine - 1
		--[[
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end

	for k,v in ipairs(BankFree[0]) do
		num = num + 1
		if k == 1 then
			y = floor((num+config.bankperLine-1)/config.bankperLine) - 1
			x = num - y * config.bankperLine - 1
			frame["BagIconFree"]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
			frame["BagIconFreeText"]: SetText(SlotNum.BankFree)
			frame["BagIconFree"]: Show()
			num = num + 1
		end
		y = floor((num+config.bankperLine-1)/config.bankperLine) - 1
		x = num- y * config.bankperLine - 1
		--[[
		frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end

	for t,s in pairs(Bank) do
		if t ~= 0 then
			et = et + 1
			e = ceil(e/config.bankperLine)*config.bankperLine
			for k,v in ipairs(s) do
				e = e + 1
				y = floor((num+config.bankperLine-1)/config.bankperLine)+floor((e+config.bankperLine-1)/config.bankperLine) - 1
				x = e - (floor((e+config.bankperLine-1)/config.bankperLine)-1) * config.bankperLine - 1
				--[[
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
				--]]
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
			end
			for k,v in ipairs(BankFree[t]) do
				e = e + 1
				y = floor((num+config.bankperLine-1)/config.bankperLine)+floor((e+config.bankperLine-1)/config.bankperLine) - 1
				x = e - (floor((e+config.bankperLine-1)/config.bankperLine)-1) * config.bankperLine - 1
				--[[
				frame["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border*(et+1)-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
				--]]
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
				frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
			end
		end
	end

	y = (config.buttonSize+config.buttonGap*2)*(ceil(num/config.bankperLine)+ceil(e/config.bankperLine))+config.border*(2+et)
	frame.Bags: SetHeight(y)
	frame: SetHeight(y+48+2)
end

local function Pos_ReagentItem(frame, pos)
	local x,y
	local num = 0
	for k,v in ipairs(Reagent) do
		num = num + 1
		y = floor((num+config.reagentperLine-1)/config.reagentperLine) - 1
		x = num - y * config.reagentperLine - 1
		--[[
		f["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		f["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		f["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end
	
	for k,v in ipairs(ReagentFree) do
		num = num + 1
		y = floor((num+config.reagentperLine-1)/config.reagentperLine) - 1
		x = num- y * config.reagentperLine - 1
		--[[
		f["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		f["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		f["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
		--]]
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: ClearAllPoints()
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetPoint("TOPLEFT", pos, "TOPLEFT", config.border+config.buttonGap+x*(config.buttonSize+config.buttonGap*2), -config.border-config.buttonGap-y*(config.buttonSize+config.buttonGap*2))
		frame["Bag"..v.bagID]["Slot"..v.slotID].Anchor: SetAlpha(1)
	end

	pos: SetHeight((config.buttonSize+config.buttonGap*2)*ceil(num/config.reagentperLine)+config.border*2)
end

local function Insert_BankItem(f)
	wipe(Bank)
	wipe(BankFree)
	wipe(Reagent)
	wipe(ReagentFree)
	for _, b in ipairs(Bank_BagID) do
		local BagType = select(2,C_Container.GetContainerNumFreeSlots(b)) or 0
		if not f["Bag"..b] then
			f["Bag"..b] = Create_BankFrame(f, b)
			if b == REAGENTBANK_CONTAINER then
				f["Bag"..b]: SetParent(f.Reagent)
			else
				f["Bag"..b]: SetParent(f.Bags)
			end
		end
		Check_BagNumSlots(f["Bag"..b], b)
		if not Bank[BagType] then
			Bank[BagType] = {}
		end
		if not BankFree[BagType] then
			BankFree[BagType] = {}
		end
		for s = 1, ContainerFrame_GetContainerNumSlots(b) do
			if not f["Bag"..b]["Slot"..s] then
				f["Bag"..b]["Slot"..s] = Create_BagItemButton(f["Bag"..b], b, s)
			end
			local itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,lockde = GetItemInfoFromBS(b, s)
			--local texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered = C_Container.GetContainerItemInfo(b, s)
			if texture then
				--local _, itemID = strsplit(":", itemLink)
				--local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
				if b == REAGENTBANK_CONTAINER then
					insert(Reagent, GetItemTable(b, s, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked))
				else
					insert(Bank[BagType], GetItemTable(b, s, itemName,itemID,texture,itemCount,itemType,itemSubType,itemEquipLoc,quality,itemLevel,locked))
				end
			else
				if b == REAGENTBANK_CONTAINER then
					insert(ReagentFree, GetItemTable(b, s, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil))
				else
					insert(BankFree[BagType], GetItemTable(b, s, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil))
				end
			end
		end
	end
	SlotNum.BankFree = #BankFree[0]
	SlotNum.Bank = SlotNum.BankFree + #Bank[0]
	SlotNum.ReagentFree = #ReagentFree
	SlotNum.Reagent = SlotNum.ReagentFree + #Reagent
end

local function FullUpdate_BankItem(frame)
	Insert_BankItem(frame)
	Sort_BagItem(Bank)
	Update_BankItem(frame)
	Pos_BankItem(frame, frame.Bags)

	if not F.IsClassic then
		Sort_ReagentItem(Reagent)
		Update_ReagentItem(frame)
		Pos_ReagentItem(frame, frame.Reagent)
	end
end

local function Search_BankItem(frame, ...)
	if (not frame and frame:IsShown()) then return end
	local itemButton
	local ItemInfo
	for _, bagID in ipairs(Bank_BagID) do
		for slotID = 1, ContainerFrame_GetContainerNumSlots(bagID) do
			--local _, _, _, quality, _, _, _, isFiltered = C_Container.GetContainerItemInfo(bagID, slotID)
			itemButton = frame["Bag"..bagID]["Slot"..slotID]
			if itemButton then
				ItemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
				if ItemInfo then
					if ItemInfo.isFiltered then
						print(bagID, slotID)
						SetItemButtonDesaturated(item, 1)
						itemButton.Anchor:SetAlpha(0.4)
						--itemButton.searchOverlay:Show();
						if ItemInfo.quality and (ItemInfo.quality > 1) then
							itemButton.QualityIcon: SetVertexColor(0.5,0.5,0.5)
							itemButton.Border: SetBackdropBorderColor(0.5,0.5,0.5, 0.9)
						end
					else
						SetItemButtonDesaturated(item)
						itemButton.Anchor:SetAlpha(1)
						--itemButton.searchOverlay:Hide();
						if ItemInfo.quality and (ItemInfo.quality > 1) then
							local color = ITEM_QUALITY_COLORS[ItemInfo.quality]
							itemButton.QualityIcon: SetVertexColor(color.r,color.g,color.b)
							itemButton.Border: SetBackdropBorderColor(color.r,color.g,color.b, 0.9)
						end
					end
				end
			end
		end
	end
end

--- ------------------------------------------------------------
--> Reagent Frame
--- ------------------------------------------------------------

local function Reagent_Frame(f)
	local ReagentFrame = CreateFrame("Frame", "Quafe_BankReagent", f)
	ReagentFrame: SetFrameLevel(5)
	ReagentFrame: SetSize((config.buttonSize+config.buttonGap*2)*config.reagentperLine + config.border*2, 48)
	ReagentFrame: SetPoint("TOP", f.Extra, "BOTTOM", 0,-2)
	F.create_Backdrop(ReagentFrame, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)

	local RegentUnlockInfo = CreateFrame("Frame", "Quafe_BankReagent.UnlockInfo", ReagentFrame)
	RegentUnlockInfo: SetAllPoints(ReagentFrame)
	RegentUnlockInfo: SetFrameLevel(18)
	RegentUnlockInfo: EnableMouse(true)
	F.create_Backdrop(RegentUnlockInfo, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0)

	local RegentUnlockInfoText = F.Create.Font(RegentUnlockInfo, "ARTWORK", C.Font.Txt, 14, nil, nil, 1, nil, nil, nil, "CENTER", "MIDDLE")
	RegentUnlockInfoText: SetSize(512,32)
	RegentUnlockInfoText: SetPoint("BOTTOM", RegentUnlockInfo, "CENTER", 0, 0)
	RegentUnlockInfoText: SetText(REAGENTBANK_PURCHASE_TEXT)

	local RegentUnlockInfoTitle = F.Create.Font(RegentUnlockInfo, "ARTWORK", C.Font.Txt, 22, nil, nil, 1, nil, nil, nil, "CENTER", "MIDDLE")
	RegentUnlockInfoTitle: SetSize(384,0)
	RegentUnlockInfoTitle: SetPoint("BOTTOM", RegentUnlockInfoText, "TOP", 0, 8)
	RegentUnlockInfoTitle: SetText(REAGENT_BANK)
	
	local RegentUnlockInfoCost = F.Create.Font(RegentUnlockInfo, "ARTWORK", C.Font.Txt, 14, nil, nil, 1, nil, nil, nil, "RIGHT", "MIDDLE")
	RegentUnlockInfoCost: SetSize(384,21)
	RegentUnlockInfoCost: SetPoint("TOPRIGHT", RegentUnlockInfoText, "BOTTOM", -10, -8)
	RegentUnlockInfoCost: SetText(COSTS_LABEL)

	local RegentUnlockInfoPurchaseButton = CreateFrame("Button", nil, RegentUnlockInfo, "UIPanelButtonTemplate")
	RegentUnlockInfoPurchaseButton: SetSize(124,21)
	RegentUnlockInfoPurchaseButton: SetPoint("TOPLEFT", RegentUnlockInfoText, "BOTTOM", 10, -8)
	--RegentUnlockInfoPurchaseButton: SetFont(C.Font.Txt, 14, nil)
	RegentUnlockInfoPurchaseButton: SetText(BANKSLOTPURCHASE)
	RegentUnlockInfoPurchaseButton: SetScript("OnClick", function(self, button)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
		StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
	end)

	ReagentFrame: RegisterEvent("BANKFRAME_OPENED")
	ReagentFrame: RegisterEvent("REAGENTBANK_PURCHASED")
	ReagentFrame: SetScript("OnEvent", function(self, event)
		if event == "BANKFRAME_OPENED" then
			if(not IsReagentBankUnlocked()) then
				local cost = GetReagentBankCost()
				local gold = floor(abs(cost / 10000))
				local silver = floor(abs(mod(cost / 100, 100)))
				local copper = floor(abs(mod(cost, 100)))
				local hexcolor = F.Hex(C.Color.Y1)
				RegentUnlockInfoCost: SetText(format("%s%s%s%s%s%s%s", COSTS_LABEL, gold, hexcolor.."G|r",silver, hexcolor.."S|r",copper, hexcolor.."C|r"))
				RegentUnlockInfo: Show()
			else
				RegentUnlockInfo: Hide()
			end
		end
		if event == "REAGENTBANK_PURCHASED" then
			RegentUnlockInfo: Hide()
		end
	end)
	
	f.Reagent = ReagentFrame
end

--- ------------------------------------------------------------
--> AccountBank Frame 13-17
--- ------------------------------------------------------------

local AccountBank_Frame = function(frame)
	local AccountBankFrame = CreateFrame("Frame", "Quafe_AccountBank", frame)
	AccountBankFrame: SetFrameLevel(5)
	AccountBankFrame: SetSize((config.buttonSize+config.buttonGap*2)*config.reagentperLine + config.border*2, 48)
	AccountBankFrame: SetPoint("TOP", frame.Extra, "BOTTOM", 0,-2)
	F.Create.Backdrop(AccountBankFrame, 2, false, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)

	local UnlockInfo = CreateFrame("Frame", "Quafe_BankReagent.UnlockInfo", AccountBankFrame)
	UnlockInfo: SetAllPoints(AccountBankFrame)
	UnlockInfo: SetFrameLevel(18)
	UnlockInfo: EnableMouse(true)
	F.Create.Backdrop(UnlockInfo, 2, false, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0)

	local UnlockInfoText = F.Create.Font(UnlockInfo, "ARTWORK", C.Font.Txt, 14, nil, nil, 1, nil, nil, nil, "CENTER", "MIDDLE")
	UnlockInfoText: SetSize(512,64)
	UnlockInfoText: SetPoint("BOTTOM", UnlockInfo, "CENTER", 0, 0)
	UnlockInfoText: SetText(ACCOUNT_BANK_TAB_PURCHASE_PROMPT)

	local UnlockInfoTitle = F.Create.Font(UnlockInfo, "ARTWORK", C.Font.Txt, 22, nil, nil, 1, nil, nil, nil, "CENTER", "MIDDLE")
	UnlockInfoTitle: SetSize(384,0)
	UnlockInfoTitle: SetPoint("BOTTOM", UnlockInfoText, "TOP", 0, 8)
	UnlockInfoTitle: SetText(ACCOUNT_BANK_PANEL_TITLE)

	local UnlockInfoCost = F.Create.Font(UnlockInfo, "ARTWORK", C.Font.Txt, 14, nil, nil, 1, nil, nil, nil, "RIGHT", "MIDDLE")
	UnlockInfoCost: SetSize(384,21)
	UnlockInfoCost: SetPoint("TOPRIGHT", UnlockInfoText, "BOTTOM", -10, -8)
	UnlockInfoCost: SetText(COSTS_LABEL)

	local UnlockInfoPurchaseButton = CreateFrame("Button", nil, UnlockInfo, "UIPanelButtonTemplate")
	UnlockInfoPurchaseButton: SetSize(124,21)
	UnlockInfoPurchaseButton: SetPoint("TOPLEFT", UnlockInfoText, "BOTTOM", 10, -8)
	--UnlockInfoPurchaseButton: SetFont(C.Font.Txt, 14, nil)
	UnlockInfoPurchaseButton: SetText(BANKSLOTPURCHASE)
	UnlockInfoPurchaseButton: SetScript("OnClick", function(self, button)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
		local textArg1, textArg2 = nil, nil;
		StaticPopup_Show("CONFIRM_BUY_BANK_TAB", textArg1, textArg2, { bankType = Enum.BankType.Account });
	end)

	AccountBankFrame.UnlockInfo = UnlockInfo
	AccountBankFrame.UnlockInfo.Cost = UnlockInfoCost

	local function AccountBank_UpdateUnlockInfo(self)
		local purchasedBankTabData = C_Bank.FetchPurchasedBankTabData(Enum.BankType.Account)
		local hasPurchasedTabs = purchasedBankTabData and #purchasedBankTabData > 0;
		if hasPurchasedTabs then
			self.UnlockInfo: Hide()
		else
			local cost = C_Bank.FetchNextPurchasableBankTabCost(Enum.BankType.Account)
			local gold = floor(abs(cost / 10000))
			local silver = floor(abs(mod(cost / 100, 100)))
			local copper = floor(abs(mod(cost, 100)))
			local hexcolor = F.Hex(C.Color.Y1)
			self.UnlockInfo.Cost: SetText(format("%s%s%s%s%s%s%s", COSTS_LABEL, gold, hexcolor.."G|r",silver, hexcolor.."S|r",copper, hexcolor.."C|r"))
			self.UnlockInfo: Show()
		end
	end

	AccountBankFrame: RegisterEvent("BANKFRAME_OPENED")
	AccountBankFrame: RegisterEvent("BANK_TAB_SETTINGS_UPDATED")
	AccountBankFrame: SetScript("OnEvent", function(self, event)
		if event == "BANKFRAME_OPENED" then
			AccountBank_UpdateUnlockInfo(self)
		elseif event == "BANK_TAB_SETTINGS_UPDATED" then
			if self.UnlockInfo: IsShow() then
				AccountBank_UpdateUnlockInfo(self)
			end
		end
	end)


	frame.AccountBank = AccountBankFrame
end

--- ------------------------------------------------------------
--> Bank Frames
--- ------------------------------------------------------------
local function TabButton_Templplate(frame)

end

local function BankExtra_Frame(f)
	local bagextra = CreateFrame("Frame", "Quafe_BankExtra", f)
	bagextra: SetFrameLevel(3)
	bagextra: SetSize((config.buttonSize+config.buttonGap*2)*config.bankperLine+config.border*2, 48)
	bagextra: SetPoint("TOP", f, "TOP", 0,0)
	F.create_Backdrop(bagextra, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)
	f.Extra = bagextra
	
	local editbox = CreateFrame("EditBox", "Quafe_BankEditBox", bagextra, "BagSearchBoxTemplate")
	editbox: SetSize(120,16)
	editbox: SetPoint("LEFT", bagextra, "LEFT", 35,0)
	editbox: SetAutoFocus(false)
	editbox.Left: Hide()
	editbox.Middle: Hide()
	editbox.Right: Hide()
	F.create_Backdrop(editbox, 6, 8, 6, C.Color.W2,0, C.Color.W4,0.9)
	
	local ToggleButton = Button_Template(bagextra)
	ToggleButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	ToggleButton.Icon: SetTexture(F.Path("Bag_Button1"))

	local DepositButton = Button_Template(bagextra)
	DepositButton: SetPoint("LEFT", ToggleButton, "RIGHT", 2, 0)
	DepositButton.Icon: SetTexture(F.Path("Bag_Button2"))

	if not F.IsClassic then
		ToggleButton.tooltipText = REAGENT_BANK
		ToggleButton: SetScript("OnClick", function(self)
			--PlaySound(852)
			PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
			if f.Bags:IsShown() then
				f.Bags: Hide()
				f.Reagent: Show()
				self.tooltipText = BANK
			else
				f.Bags: Show()
				f.Reagent: Hide()
				self.tooltipText = REAGENT_BANK
			end
			GameTooltip:SetText(self.tooltipText)
		end)
		
		DepositButton.tooltipText = REAGENTBANK_DEPOSIT
		DepositButton: SetScript("OnClick", function(self)
			--PlaySound(852)
			PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
			DepositReagentBank()
		end)
	else
		ToggleButton: Hide()
		DepositButton: Hide()
	end

--> Purchase
	local PurchaseButton = CreateFrame("Button", nil, bagextra)
	PurchaseButton: SetSize(24,24)
	if F.IsClassic then
		PurchaseButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	else
		PurchaseButton: SetPoint("LEFT", DepositButton, "RIGHT", 2, 0)
	end
	PurchaseButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	F.create_Backdrop(PurchaseButton, 2, 8, 4, C.Color.Y1,0, C.Color.W4,0.9)
	PurchaseButton.Bg: SetAlpha(0)
	PurchaseButton.tooltipText = BANKSLOTPURCHASE_LABEL

	local PurchaseButtonIcon = PurchaseButton:CreateTexture(nil, "ARTWORK")
	PurchaseButtonIcon: SetTexture(F.Path("Bag_Button3"))
	PurchaseButtonIcon: SetSize(18,18)
	PurchaseButtonIcon: SetPoint("CENTER", PurchaseButton, "CENTER", 0,0)
	PurchaseButtonIcon: SetVertexColor(F.Color(C.Color.W3))

	PurchaseButton: RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	PurchaseButton: RegisterEvent("BANKFRAME_OPENED")
	PurchaseButton: SetScript("OnEvent", function(self, event, ...)
		local numSlots,full = GetNumBankSlots()
		local cost = GetBankSlotCost(numSlots)
		BankFrame.nextSlotCost = cost
		if (full) then
			self: Hide()
		else
			self: Show()
		end
	end)

	PurchaseButton: SetScript("OnClick", function(self, button, ...)
		PlaySound(852)
		StaticPopup_Show("CONFIRM_BUY_BANK_SLOT")
	end)
	
	PurchaseButton: SetScript("OnEnter", function(self)
		self.Bg: SetAlpha(1)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			GameTooltip:SetText(self.tooltipText)
			GameTooltip:Show()
		end
		--self.Icon: SetVertexColor(F.Color(C.Color.Config.Back))
	end)
	PurchaseButton: SetScript("OnLeave", function(self)
		self.Bg: SetAlpha(0)
		GameTooltip:Hide()
		--self.Icon: SetVertexColor(F.Color(C.Color.W3))
	end)
	--StaticPopup_Show("CONFIRM_BUY_BANK_SLOT");
	--StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
	
	--> Close
	local closebutton = CreateFrame("Button", nil, bagextra)
	closebutton: SetSize(24,30)
	closebutton: SetPoint("RIGHT", bagextra, "RIGHT", -2,0)
	closebutton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	F.create_Backdrop(closebutton, 0, 0, 0, C.Color.Config.Exit,0, C.Color.W1,0)
	
	local closebuttonicon = F.Create.Font(closebutton, "ARTWORK", C.Font.Big, 24, nil, C.Color.W3, 1, C.Color.W1, 0, {0,0}, "CENTER", "CENTER")
	closebuttonicon: SetPoint("CENTER", closebutton, "CENTER", 0,0)
	closebuttonicon: SetText("X")
	
	closebutton: SetScript("OnClick", function(self, button)
		f:Hide()
	end)
	closebutton: SetScript("OnEnter", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Y1,1))
		closebuttonicon: SetTextColor(F.Color(C.Color.Config.Back))
	end)
	closebutton: SetScript("OnLeave", function(self)
		self.Bg: SetBackdropColor(F.Color(C.Color.Config.Exit,0))
		closebuttonicon: SetTextColor(F.Color(C.Color.W3))
	end)
	
	--> Bank Slot
	local lastbutton
	for bagID = NUM_BAG_SLOTS+1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		local button
		if F.IsClassic then
			button = CreateFrame("CheckButton", "Quafe_BankButton"..bagID, bagextra, "Quafe_BankSlotButtonClassicTemplate")
		else
			button = CreateFrame("ItemButton", "Quafe_BankButton"..bagID, bagextra, "Quafe_BankSlotButtonTemplate")
		end
		button: SetSize(24,24)
		if bagID == NUM_BAG_SLOTS+1 then
			button: SetPoint("RIGHT", bagextra, "RIGHT", -33-30*6,0)
		else
			button: SetPoint("LEFT", lastbutton, "RIGHT", 6,0)
		end
		
		local invID = BankButtonIDToInvSlotID(bagID-4, 1)
		button.invID = invID
		button.bagID = bagID
		button: SetID(bagID - 4)
		
		--button: SetNormalTexture("")
		--button: SetNormalTexture(0)
		button: ClearNormalTexture()
		button: SetPushedTexture(F.Path("Button\\Bag_Pushed"))
		button: SetHighlightTexture(F.Path("Button\\Bag_Hightlight"))

		button.icon: SetAllPoints(button)
		button.icon: SetTexCoord(0.1,0.9, 0.1,0.9)
		
		button.Border = CreateFrame("Frame", nil, button, "BackdropTemplate")
		button.Border: SetFrameLevel(button:GetFrameLevel()+1)
		button.Border: SetAllPoints(button)

		Create_ButtonBg(button.Border, 1, 0)
		button.Border: SetBackdropColor(F.Color(C.Color.W1, 0))
		button.Border: SetBackdropBorderColor(F.Color(C.Color.W4, 0.9))

		if button.IconBorder then
			--button.IconBorder: SetTexture("")
			--button.IconBorder: Hide()
			button.IconBorder: SetAlpha(0)
		end

		--[[
		button: RegisterForDrag("LeftButton", "RightButton")
		button: RegisterForClicks("anyUp")
		
		button: SetScript("OnClick", function(self, btn)
			if(PutItemInBag(self.invID)) then return end
			if not IsShiftKeyDown() then
				PickupBagFromSlot(self.invID)
			end
		end)
		button: SetScript("OnReceiveDrag", function(self)
			if(PutItemInBag(self.invID)) then return end
			if not IsShiftKeyDown() then
				PickupBagFromSlot(self.invID)
			end
		end)
		button: SetScript("OnEnter", function(self)
			--GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetOwner(self, "ANCHOR_NONE", 0,0)
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
			if ( GameTooltip:SetInventoryItem("player", self:GetID()) ) then
				local bindingKey = GetBindingKey("TOGGLEBAG"..(4 -  (self:GetID() - CharacterBag0Slot:GetID())))
				if ( bindingKey ) then
					GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..bindingKey..")"..FONT_COLOR_CODE_CLOSE)
				end
			else
				--GameTooltip:SetText(EQUIP_CONTAINER, 1.0, 1.0, 1.0)
				GameTooltip:SetText(self.tooltipText, 1.0, 1.0, 1.0)
			end
			GameTooltip: Show()
		end)
		button: SetScript("OnLeave", function(self)
			GameTooltip: Hide()
		end)
		--]]
		lastbutton = button
		f.Extra["Bag"..bagID] = button
	end
	
	f.Extra: RegisterEvent("BAG_UPDATE")
	f.Extra: RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	f.Extra: RegisterEvent("BANKFRAME_OPENED")
	f.Extra: RegisterEvent("ITEM_LOCK_CHANGED")
	f.Extra: SetScript("OnEvent", function(self, event, ...)
		local numSlots,full = GetNumBankSlots()
		for bagID = NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
			local icon = GetInventoryItemTexture("player", f.Extra["Bag"..bagID].invID)
			f.Extra["Bag"..bagID].icon: SetTexture(icon or [[Interface\Paperdoll\UI-PaperDoll-Slot-Bag]])
			f.Extra["Bag"..bagID].icon: SetDesaturated(IsInventoryItemLocked(f.Extra["Bag"..bagID].invID))
			if bagID <= NUM_BAG_SLOTS+numSlots then
				SetItemButtonTextureVertexColor(f.Extra["Bag"..bagID], 1.0,1.0,1.0);
				f.Extra["Bag"..bagID].tooltipText = BANK_BAG
			else
				SetItemButtonTextureVertexColor(f.Extra["Bag"..bagID], 1.0,0.1,0.1);
				f.Extra["Bag"..bagID].tooltipText = BANK_BAG_PURCHASE
			end
		end
	end)
end

local function BankFrame_OnShow(self)
	self:RegisterEvent("ITEM_LOCK_CHANGED");
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	self:RegisterEvent("PLAYER_MONEY");
	self:RegisterEvent("BAG_UPDATE_COOLDOWN");
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE");

	FullUpdate_BankItem(self)

	for i=1, NUM_BANKGENERIC_SLOTS, 1 do

	end
end

local function BankFrame_OnHide(self)
	self:UnregisterEvent("ITEM_LOCK_CHANGED");
	self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED");
	self:UnregisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
	self:UnregisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	self:UnregisterEvent("PLAYER_MONEY");
	self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
	self:UnregisterEvent("INVENTORY_SEARCH_UPDATE");

	StaticPopup_Hide("CONFIRM_BUY_BANK_SLOT")
	--CloseBankFrame()
	C_Bank.CloseBankFrame()
end

local function BankFrame_OnEvent(self)

end

local BankPanelEvents = {
	"ACCOUNT_MONEY",
	"BANK_TABS_CHANGED",
	"BAG_UPDATE",
	"BANK_TAB_SETTINGS_UPDATED",
	"INVENTORY_SEARCH_UPDATE",
	"ITEM_LOCK_CHANGED",
	"PLAYER_MONEY",
};

local function Bank_Frame(f)
	local bank = CreateFrame("Frame", "Quafe_BankFrame", f)
	bank: SetFrameLevel(2)
	bank: SetSize((config.buttonSize+config.buttonGap*2)*config.bankperLine + config.border*2, 48)
	--bank: SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20,-200)
	bank: SetPoint("LEFT", UIParent, "LEFT", 20,0)
	
	bank: SetClampedToScreen(true)
	bank: SetMovable(true)
	--bank: EnableMouse(true)
	--bank: RegisterForDrag("LeftButton","RightButton")
	--bank: SetScript("OnDragStart", function(self) self:StartMoving() end)
	--bank: SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	BankExtra_Frame(bank)
	if not F.IsClassic then
		Reagent_Frame(bank)
		AccountBank_Frame(bank)
	end
	f.Bank = bank
	
	local bags = CreateFrame("Frame", nil, bank)
	bags: SetFrameLevel(3)
	bags: SetSize((config.buttonSize+config.buttonGap*2)*config.bankperLine+config.border*2, config.buttonSize+config.border*2)
	bags: SetPoint("TOP", bank.Extra, "BOTTOM", 0,-2)
	F.create_Backdrop(bags, 2, 8, 4, C.Color.Config.Back,0.9, C.Color.Config.Back,0.9)
	f.Bank.Bags = bags
	
	Init_BankItemClass()
	Init_BagGap(f.Bank, ITEMCLASS, f.Bank.Bags, true)
	Insert_BankItem(f.Bank)

	f.Bank.Extra: EnableMouse(true)
	f.Bank.Extra: RegisterForDrag("LeftButton","RightButton")
	f.Bank.Extra: SetScript("OnDragStart", function(self) f.Bank:StartMoving() end)
	f.Bank.Extra: SetScript("OnDragStop", function(self)
		UpdatePostion(f.Bank, Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BankPos)
	end)
	
	f.Bank: RegisterEvent("BANKFRAME_OPENED")
	f.Bank: RegisterEvent("BANKFRAME_CLOSED")
	f.Bank: RegisterEvent("PLAYER_LOGIN")
	f.Bank: RegisterEvent("PLAYER_ENTERING_WORLD")
	f.Bank: RegisterEvent("BAG_UPDATE")
	f.Bank: RegisterEvent("BAG_UPDATE_DELAYED")
	--f.Bank: RegisterEvent("BAG_NEW_ITEMS_UPDATED") --不考虑新物品
	--f.Bank: RegisterEvent("ITEM_LOCK_CHANGED")
	--f.Bank: RegisterEvent("BAG_UPDATE_COOLDOWN")
	--f.Bank: RegisterEvent("INVENTORY_SEARCH_UPDATE")
	f.Bank: SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			self:Hide()
			self.Bags:Show()
			if not F.IsClassic then
				self.Reagent:Hide()
			end
			BankFrame:UnregisterAllEvents()
			--Quafe_UpdateAfter()
		elseif event == "PLAYER_ENTERING_WORLD" then
			FullUpdate_BankItem(self)
		elseif event == "BANKFRAME_OPENED" then
			self: Show()
			self.Bags:Show()
			if not F.IsClassic then
				self.Reagent:Hide()
			end
			--FullUpdate_BankItem(self)
			--C_Timer.After(2, function() FullUpdate_BankItem(self) end)
			--Quafe_UpdateAfter()
		elseif event == "BANKFRAME_CLOSED" then
			self: Hide()
		elseif event == "BAG_UPDATE" then
			if self:IsShown() then
				FullUpdate_BankItem(self)
			end
		elseif event == "ITEM_LOCK_CHANGED" then
			Update_ItemLock(self, ...)
		elseif event == "BAG_UPDATE_COOLDOWN" then
			Update_ItemCooldown(self, ...)
		elseif event == "INVENTORY_SEARCH_UPDATE" then
			Search_BankItem(self, ...)
		end
	end)

	f.Bank: SetScript("OnShow", BankFrame_OnShow)
	f.Bank: SetScript("OnHide", BankFrame_OnHide)
end

--- ------------------------------------------------------------
--> Container Frame
--- ------------------------------------------------------------

local Quafe_Container = CreateFrame("Frame", "Quafe_Container", E)
Quafe_Container: SetFrameStrata("HIGH")
Quafe_Container: SetSize(8,8)
Quafe_Container.Init = false

local function Bag_Open()
	if not ContainerFrame_AllowedToOpenBags() then
		return;
	end
	if Quafe_Container.BagFrame then
		Quafe_Container.BagFrame:Show()
	end
end

local function Bag_Close()
	if Quafe_Container.BagFrame then
		Quafe_Container.BagFrame:Hide()
	end
end

local function Bag_Toggle()
	if Quafe_Container.BagFrame and Quafe_Container.BagFrame: IsShown() then
		Bag_Close()
	else
		Bag_Open()
	end
end

function Quafe_ToggleBags()
	Bag_Toggle()
end

local function BindingFrame_Init(self)
	local function CheckBingdings(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		ClearOverrideBindings(self)
		local bindings = {
			"TOGGLEBACKPACK",
			"TOGGLEREAGENTBAG",
			"TOGGLEBAG1",
			"TOGGLEBAG2",
			"TOGGLEBAG3",
			"TOGGLEBAG4",
			"OPENALLBAGS"
		}
		for _, binding in pairs(bindings) do
			local key, otherkey = GetBindingKey(binding)
			if key ~= nil then
				SetOverrideBinding(self, true, key, "QUAFE_BAG_TOGGLE")
			end
			if otherkey ~= nil then
				SetOverrideBinding(self, true, otherkey, "QUAFE_BAG_TOGGLE")
			end
		end
	end

	local BindingFrame = CreateFrame("Frame")
	BindingFrame: RegisterEvent("PLAYER_LOGIN")
	BindingFrame: RegisterEvent("UPDATE_BINDINGS")
	BindingFrame: SetScript("OnEvent", CheckBingdings)
end

local function Quafe_Container_Load()
	if F.IsAddonEnabled("EuiScript") then return end
	if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable then
		Bag_Frame(Quafe_Container)
		Quafe_Container.BagFrame: ClearAllPoints()
		Quafe_Container.BagFrame: SetPoint(unpack(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BagPos))
		tinsert(UISpecialFrames, Quafe_Container.BagFrame:GetName())
		
		Bank_Frame(Quafe_Container)
		Quafe_Container.Bank: ClearAllPoints()
		Quafe_Container.Bank: SetPoint(unpack(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BankPos))
		tinsert(UISpecialFrames, Quafe_Container.Bank:GetName())
		
		BindingFrame_Init(Quafe_Container)
		CanIMogIt_Load()
		--CIMI_LoadCheck()
	
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.Scale then
			Quafe_Container: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.Scale)
		end

		Quafe_Container.Init = true
	end
end

local function Quafe_Container_Toggle(arg1,arg2)
	if arg1 == "ON" then
		Quafe_NoticeReload()
	elseif arg1 == "OFF" then
		Quafe_NoticeReload()
	elseif arg1 == "SCALE" then
		Quafe_Container: SetScale(arg2)
	end
end

local Quafe_Container_Config = {
	Database = {
		["Quafe_Container"] = {
			Enable = true,
			Gold = {},
			RefreshRate = "Closing", --Always, Closing, Manual
			Scale = 1,
			BagPos = {"RIGHT", UIParent, "RIGHT", -80,0},
			BankPos = {"LEFT", UIParent, "LEFT", 20,0},
		},
	},

	Config = {
		Name = "Quafe "..L['BAG'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable = false
				self.Text:SetText(L["OFF"])
				Quafe_Container_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable = true
				self.Text:SetText(L["ON"])
				Quafe_Container_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
				Name = L['GROUP_REFRESH_RATE'],
				Type = "Dropdown",
				Click = function(self, button)
					
				end,
				Load = function(self)

				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container then
						if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
							self.Text:SetText(L['手动刷新'])
						elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
							self.Text:SetText(L['关闭时刷新'])
						elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
							self.Text:SetText(L['实时刷新'])
						end
					end
				end,
				DropMenu = {
					[1] = {
						Text = L['手动刷新'],
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate = "Manual"
							RefreshButton_Toggle(Quafe_Container.BagFrame)
						end,
					},
					[2] = {
						Text = L['关闭时刷新'],
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate = "Closing"
							RefreshButton_Toggle(Quafe_Container.BagFrame)
						end,
					},
					[3] = {
						Text = L['实时刷新'],
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate = "Always"
							RefreshButton_Toggle(Quafe_Container.BagFrame)
						end,
					},
				},
			},
			[2] = {
                Name = L['SCALE'],
                Type = "Slider",
                State = "ALL",
				Click = nil,
                Load = function(self)
                    self.Slider: SetMinMaxValues(0.5, 2)
					self.Slider: SetValueStep(0.05)
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
                        Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.Scale = value
						Quafe_Container_Toggle("SCALE", value)
					end)
                end,
                Show = nil,
            },
			[3] = {
				Name = L['重置金币数据'],
				Type = "Trigger",
				Click = function(self, button)
					wipe(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold)
					DEFAULT_CHAT_FRAME:AddMessage("Quafe "..L['背包金币数据已重置'])
				end,
				Show = function(self)
					self.Text:SetText(L['CONFIRM'])
				end,
			},
		},
	},
}

Quafe_Container.Load = Quafe_Container_Load
Quafe_Container.Config = Quafe_Container_Config
tinsert(E.Module, Quafe_Container)
