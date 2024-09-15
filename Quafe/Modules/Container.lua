local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

--if F.IsClassic then return end

--MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceHook-3.0")

--- ------------------------------------------------------------
--> API and Variable
--- ------------------------------------------------------------

local MAX_CONTAINER_ITEMS = 36
local NUM_CONTAINER_COLUMNS = 4
local BACKPACK_BASE_SIZE = 16

local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local ceil = math.ceil
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad
local find = string.find
local insert = table.insert
local remove = table.remove
local wipe = table.wipe

local TBAG = {}
local TBAG_FREE = {}
local TBAG_FREE_NEW = {}
local BagNew = {}
local TBANK = {}
local TBANK_FREE = {}
local BankSpecical = {}
local BankSpecicalFree = {}
local TREAGENT = {}
local TREAGENT_FREE = {}
local TACCOUNT = {}
local TACCOUNT_FREE = {}

local ITEMCLASS = {}
local ITEMCLASS_INIT = false
local BANKITEMCLASS = {}

local CONFIG = {
	buttonSize = 32,
	iconSize = 28,
	buttonGap = 3,
	border = 8,
	perLine = 14,
	bankperLine = 20,
	reagentperLine = 14,
}

local NSLOT = {
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

local ITEMCLASS_NAME = {}
ITEMCLASS_NAME[Enum.ItemClass.Consumable] 				= "Consumable"				--0
ITEMCLASS_NAME[Enum.ItemClass.Container] 				= "Container"				--1
ITEMCLASS_NAME[Enum.ItemClass.Weapon] 					= "Weapon"					--2
ITEMCLASS_NAME[Enum.ItemClass.Gem] 						= "Gem"						--3
ITEMCLASS_NAME[Enum.ItemClass.Armor] 					= "Armor"					--4
ITEMCLASS_NAME[Enum.ItemClass.Reagent] 					= "Reagent"					--5
ITEMCLASS_NAME[Enum.ItemClass.Projectile] 				= "Projectile"				--6
ITEMCLASS_NAME[Enum.ItemClass.Tradegoods] 				= "Tradegoods"				--7
ITEMCLASS_NAME[Enum.ItemClass.ItemEnhancement] 			= "ItemEnhancement"			--8
ITEMCLASS_NAME[Enum.ItemClass.Recipe] 					= "Recipe"					--9
ITEMCLASS_NAME[Enum.ItemClass.CurrencyTokenObsolete	] 	= "CurrencyTokenObsolete"	--10
ITEMCLASS_NAME[Enum.ItemClass.Quiver] 					= "Quiver"					--11
ITEMCLASS_NAME[Enum.ItemClass.Questitem] 				= "Questitem"				--12
ITEMCLASS_NAME[Enum.ItemClass.Key] 						= "Key"						--13
ITEMCLASS_NAME[Enum.ItemClass.PermanentObsolete] 		= "PermanentObsolete"		--14
ITEMCLASS_NAME[Enum.ItemClass.Miscellaneous] 			= "Miscellaneous"			--15
ITEMCLASS_NAME[Enum.ItemClass.Glyph] 					= "Glyph"					--16
ITEMCLASS_NAME[Enum.ItemClass.Battlepet] 				= "Battlepet"				--17
ITEMCLASS_NAME[Enum.ItemClass.WoWToken] 				= "WoWToken"				--18
ITEMCLASS_NAME[Enum.ItemClass.Profession] 				= "Profession"				--19

local function GetItemInfo(itemID)
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = C_Item.GetItemInfo(itemID)
	return {
		itemName = itemName,
		itemLevel = itemLevel,
		classID = classID,
		subclassID = subclassID,
		itemEquipLoc = itemEquipLoc,
	}
end

local function GetItemClassInfo(itemClassID)
	return C_Item.GetItemClassInfo(itemClassID)
end

local function GetItemSubClassInfo(itemClassID, itemSubClassID)
	local subClassName, subClassUsesInvType = C_Item.GetItemSubClassInfo(itemClassID, itemSubClassID)
	return subClassName
end

local function GetContainerNumSlots(containerIndex)
	local numSlots = C_Container.GetContainerNumSlots(containerIndex)
	return numSlots
end

local function GetContainerItemLink(containerIndex, slotIndex)
	local itemLink = C_Container.GetContainerItemLink(containerIndex, slotIndex)
	return itemLink
end

local function GetBagType(bagIndex)
	local numFreeSlots, bagType = C_Container.GetContainerNumFreeSlots(bagIndex)
	return bagType, numFreeSlots
end

local function ItemClass_Init()
	if ITEMCLASS_INIT then return end
	ITEMCLASS = {
		["Elixir"] = 			{L = 1, F = "Bag_Elixir", id = 0, sub = 1}, --药剂
		["Food"] = 				{L = 2, F = "Bag_Food", id = 0, sub = 5}, --食物
		["Consumable"] = 		{L = 3, F = "Bag_Consumable", id = 0}, --消耗品
		["Questitem"] = 		{L = 4, F = "Bag_Quest", id = 12}, --任务
		["Weapon"] = 			{L = 5, F = "Bag_Weapon", id = 2}, --武器
		["Armor"] = 			{L = 6, F = "Bag_Armor", id = 4}, --护甲
		["Gem"] = 				{L = 7, F = "Bag_Gem", id = 3}, --宝石
		--["Glyph"} = 			{L = 8, }, --雕文
		["ItemEnhancement"] =	{L = 9, F = "Bag_Upgrade", id = 8}, --物品强化
		["Recipe"] = 			{L = 10, F = "Bag_Glyph", id = 9}, --配方
		["Tradegoods"] = 		{L = 11, F = "Bag_Trade", id = 7}, --商业技能
		["Reagent"] = 			{L = 12, F = "Bag_Material", id = 5}, --材料
		["Key"] = 				{L = 13, F = "Bag_Key", id = 13}, --钥匙
		["Miscellaneous"] =		{L = 14, F = "Bag_Goods", id = 15}, --杂项
		["Profession"]=			{L = 15, F = "Bag_Profession", id = 19}, --专业物品
		["Other"] = 			{L = 16, F = "Bag_Other", T = OTHER}, --其它
		["Hearthstone"] = 		{L = 17, F = "Bag_Hearthstone", T = GetItemInfo(6948).itemName}, --炉石
		["Sale"] = 				{L = 18, F = "Bag_Junk"}, --垃圾
	}

	ITEMCLASS.Elixir.SubClass = {}
	ITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Potion] = 		{L = 1}  --药水 1
	ITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Elixir] = 		{L = 2}  --药剂 2
	ITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Flasksphials] = 	{L = 3}  --合剂 3
	ITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Bandage] = 		{L = 4}  --绷带 7

	ITEMCLASS.Food.SubClass = {}
	ITEMCLASS.Food.SubClass[Enum.ItemConsumableSubclass.Fooddrink] = 		{L = 1}  --餐饮供应商 5

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
		[202046] =	{L = 13},  --始祖龟的幸运符
	}
	ITEMCLASS_INIT = true
end

local function Init_BankItemClass()
	wipe(BANKITEMCLASS)
	BANKITEMCLASS= {
		["Elixir"] = 			{L = 1, F = "Bag_Elixir", id = 0, sub = 1}, --药剂
		["Food"] = 				{L = 2, F = "Bag_Food", id = 0, sub = 5}, --食物
		["Consumable"] = 		{L = 3, F = "Bag_Consumable", id = 0}, --消耗品
		["Questitem"] = 		{L = 4, F = "Bag_Quest", id = 12}, --任务
		["Weapon"] = 			{L = 5, F = "Bag_Weapon", id = 2}, --武器
		["Armor"] = 			{L = 6, F = "Bag_Armor", id = 4}, --护甲
		["Gem"] = 				{L = 7, F = "Bag_Gem", id = 3}, --宝石
		--["Glyph"} = 			{L = 8, }, --雕文
		["ItemEnhancement"] =	{L = 9, F = "Bag_Upgrade", id = 8}, --物品强化
		["Recipe"] = 			{L = 10, F = "Bag_Glyph", id = 9}, --配方
		["Tradegoods"] = 		{L = 11, F = "Bag_Trade", id = 7}, --商业技能
		["Reagent"] = 			{L = 12, F = "Bag_Material", id = 5}, --材料
		["Key"] = 				{L = 13, F = "Bag_Key", id = 13}, --钥匙
		["Miscellaneous"] =		{L = 14, F = "Bag_Goods", id = 15}, --杂项
		["Other"] = 			{L = 15, F = "Bag_Other", T = OTHER}, --其它
		["Hearthstone"] = 		{L = 16, F = "Bag_Hearthstone", T = GetItemInfo(6948).itemName}, --炉石
		["Sale"] = 				{L = 17, F = "Bag_Junk"}, --垃圾
	}

	BANKITEMCLASS.Elixir.SubClass = {}
	BANKITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Potion] = 		{L = 1}  --药水 1
	BANKITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Elixir] = 		{L = 2}  --药剂 2
	BANKITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Flasksphials] = 	{L = 3}  --合剂 3
	BANKITEMCLASS.Elixir.SubClass[Enum.ItemConsumableSubclass.Bandage] = 		{L = 4}  --绷带 7

	BANKITEMCLASS.Food.SubClass = {}
	BANKITEMCLASS.Food.SubClass[Enum.ItemConsumableSubclass.Fooddrink] = 		{L = 1}  --餐饮供应商 5

	BANKITEMCLASS.Hearthstone.itemID = {
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

local function GetContainerItemInfo(bag_id, slot_id, infoTable)
	local slotInfo = C_Container.GetContainerItemInfo(bag_id, slot_id)
	--- iconFileID	number	
	--- stackCount	number	
	--- isLocked	boolean	
	--- quality		Enum.ItemQuality?🔗	
	--- isReadable	boolean	
	--- hasLoot		boolean	
	--- hyperlink	string	
	--- isFiltered	boolean	
	--- hasNoValue	boolean	
	--- itemID		number	
	--- isBound		boolean
	if slotInfo and slotInfo.itemID then
		local itemInfo = GetItemInfo(slotInfo.itemID)
		for k, v in pairs(itemInfo) do
			if k then
				slotInfo[k] = v
			end
		end
		slotInfo.itemName = itemInfo.itemName
		slotInfo.itemLevel = itemInfo.itemLevel
		slotInfo.classID = itemInfo.classID
		slotInfo.subclassID = itemInfo.subclassID
		slotInfo.itemEquipLoc = itemInfo.itemEquipLoc

		if (itemInfo.classID == Enum.ItemClass.Weapon) or (itemInfo.classID == Enum.ItemClass.Armor) then
			local EffectiveItemLevel = C_Item.GetDetailedItemLevelInfo(slotInfo.hyperlink)
			slotInfo.itemLevel = EffectiveItemLevel or slotInfo.itemLevel
		end
		if ITEMCLASS.Hearthstone.itemID[slotInfo.itemID] then
			slotInfo.itemType = "Hearthstone"
		elseif not ITEMCLASS[ITEMCLASS_NAME[itemInfo.classID]] then
			slotInfo.itemType = "Other"
		elseif (itemInfo.classID == Enum.ItemClass.Consumable) and (ITEMCLASS.Elixir.SubClass[slotInfo.subclassID]) then
			slotInfo.itemType = "Elixir"
		elseif (itemInfo.classID == Enum.ItemClass.Consumable) and (ITEMCLASS.Food.SubClass[slotInfo.subclassID]) then
			slotInfo.itemType = "Food"
		--elseif (itemInfo.classID == Enum.ItemClass.Miscellaneous) and (itemInfo.subclassID == Enum.ItemMiscellaneousSubclass.Junk) then
		elseif slotInfo.quality == Enum.ItemQuality.Poor and not slotInfo.hasNoValue then
			slotInfo.itemType = "Sale"
		else
			slotInfo.itemType = ITEMCLASS_NAME[itemInfo.classID]
		end
	else
		slotInfo = {}
		slotInfo.itemName = nil
		slotInfo.itemID = nil
		slotInfo.iconFileID = nil
		slotInfo.stackCount = nil
		slotInfo.itemType = nil
		slotInfo.classID = nil
		slotInfo.subclassID = nil
		slotInfo.itemEquipLoc = nil
		slotInfo.quality = nil
		slotInfo.itemLevel = nil
		slotInfo.isLocked = nil
		slotInfo.hasNoValue = nil
	end

	if not infoTable then
		infoTable = {
			bagID = bag_id,
			slotID = slot_id,
			itemName = slotInfo.itemName,
			itemID = slotInfo.itemID,
			iconFileID = slotInfo.iconFileID,
			stackCount = slotInfo.stackCount,
			itemType = slotInfo.itemType,
			classID = slotInfo.classID,
			subclassID = slotInfo.subclassID,
			itemEquipLoc = slotInfo.itemEquipLoc,
			quality = slotInfo.quality,
			itemLevel = slotInfo.itemLevel,
			isLocked = slotInfo.isLocked,
		}
		return infoTable
	else
		infoTable.bagID = bag_id
		infoTable.slotID = slot_id
		infoTable.itemName = slotInfo.itemName
		infoTable.itemID = slotInfo.itemID
		infoTable.iconFileID = slotInfo.iconFileID
		infoTable.stackCount = slotInfo.stackCount
		infoTable.itemType = slotInfo.itemType
		infoTable.classID = slotInfo.classID
		infoTable.subclassID = slotInfo.subclassID
		infoTable.itemEquipLoc = slotInfo.itemEquipLoc
		infoTable.quality = slotInfo.quality
		infoTable.itemLevel = slotInfo.itemLevel
		infoTable.isLocked = slotInfo.isLocke
	end
end

-- NUM_CONTAINER_FRAMES = 13;
-- NUM_BAG_FRAMES = Constants.InventoryConstants.NumBagSlots;	4
-- NUM_REAGENTBAG_FRAMES = Constants.InventoryConstants.NumReagentBagSlots;		1
-- NUM_TOTAL_BAG_FRAMES = Constants.InventoryConstants.NumBagSlots + Constants.InventoryConstants.NumReagentBagSlots;

--- ------------------------------------------------------------
--> Note
--- ------------------------------------------------------------
--- 
--- InCombatLockdown
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
--- 

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

--- Enum.ItemQuality
--- [0]  ITEM_QUALITY0_DESC = "Poor";
--- [1]  ITEM_QUALITY1_DESC = "Common";
--- [2]  ITEM_QUALITY2_DESC = "Uncommon";
--- [3]  ITEM_QUALITY3_DESC = "Rare";
--- [4]  ITEM_QUALITY4_DESC = "Epic";
--- [5]  ITEM_QUALITY5_DESC = "Legendary";
--- [6]  ITEM_QUALITY6_DESC = "Artifact";
--- [7]  ITEM_QUALITY7_DESC = "Heirloom";
--- [8]  ITEM_QUALITY8_DESC = "WoW Token";
--- 
--[[local itemFamilyIDs = {
	[1] = "Arrows",
	[2] = "Bullets",
	[3] = "Soul Shards",
	[4] = "Leatherworking Supplies",
	[5] = "Inscription Supplies",
	[6] = "Herbs",
	[7] = "Enchanting Supplies",
	[8] = "Engineering Supplies",
	[9] = "Keys",
	[10] = "Gems",
	[11] = "Mining Supplies",
	[12] = "Soulbound Equipment",
	[13] = "Vanity Pets",
	[14] = "Currency Tokens",
	[15] = "Quest Items",
	[16] = "Fishing Supplies",
	[17] = "Cooking Supplies",
	[20] = "Toys",
	[21] = "Archaeology",
	[22] = "Alchemy",
	[23] = "Blacksmithing",
	[24] = "First Aid",
	[25] = "Jewelcrafting",
	[26] = "Skinning",
	[27] = "Tailoring",
}
--]]
--- ------------------------------------------------------------
--- ItemButton
--- ------------------------------------------------------------

local function Create_ItemButton(self, bag_id, slot_id)
	local frame_type
	if F.IsClassic then
		frame_type = "CheckButton"
	else
		frame_type = "ItemButton"
	end

	local template_type
	if bag_id == Enum.BagIndex.Bank then 
		template_type = "BankItemButtonGenericTemplate"
	elseif bag_id == Enum.BagIndex.Reagentbank then
		template_type = "ReagentBankItemButtonGenericTemplate"
	else
		template_type = "ContainerFrameItemButtonTemplate"
	end
	
	local button = CreateFrame(frame_type, "Quafe_Bag"..bag_id.."Slot"..slot_id, self, template_type)
	button: SetFrameLevel(self:GetFrameLevel()+1)
	button: SetBagID(bag_id)
	button: SetID(slot_id)
	button.bag_id = bag_id
	button.slot_id = slot_id
	button: SetSize(CONFIG.buttonSize, CONFIG.buttonSize)
	button: Enable()
	button: Show()

	if bag_id == BANK_CONTAINER then 
		--button: SetFrameLevel(4)
	elseif bag_id == REAGENTBANK_CONTAINER then
		--button: SetFrameLevel(8)
	end

	local slotName = button: GetName()

	button.Border = F.Create.Backdrop(button, {wide = 0, border = true, edge = 1, inset = 0, cBg = C.Color.W1, aBg = 0, cBd = C.Color.W4, aBd = 0.9})

	button: ClearNormalTexture()
	button: SetPushedTexture(F.Path("Button\\Bag_Pushed"))
	button: SetHighlightTexture(F.Path("Button\\Bag_Hightlight"))

	button.icon: SetAllPoints(button)
	button.icon: SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count: SetFont(C.Font.Num, 12, "OUTLINE")
	button.Count: SetTextColor(197/255, 202/255, 233/255, 1)
	button.Count: ClearAllPoints()
	button.Count: SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1,2)

	button.cooldown = _G[format("%sCooldown", slotName)]
	button.cooldown: ClearAllPoints()
	button.cooldown: SetAllPoints(button)

	button.Level = F.Create.Font(button, "ARTWORK", C.Font.Num, 12, "OUTLINE", C.Color.W4, 0.9)
	button.Level: SetPoint("CENTER", button, "CENTER", 1,0)

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
	button.QualityIcon: SetSize(CONFIG.buttonSize, CONFIG.buttonSize)
	button.QualityIcon: SetPoint("CENTER", button, "CENTER", 0,0)
	button.QualityIcon: SetVertexColor(F.Color(C.Color.W3))

	return button
end

local function Create_BagButton(self, bag_id)
	local button = CreateFrame("Button", "Quafe_Bag"..bag_id, self)
	button: SetID(bag_id)

	return button
end

local function Check_BagNumSlots(self, bag_id)
	local num = GetContainerNumSlots(bag_id)
	if self.Num then
		if self.Num > num then
			for i = num,self.Num do
				if self["Slot"..i] then
					self["Slot"..i]:Hide()
				end
			end
		elseif self.Num < num then
			for i = self.Num,num do
				if self["Slot"..i] then
					self["Slot"..i]:Show()
				end
			end
		end
	end
	self.Num = num
end

local function Insert_BagItem(self)
	wipe(TBAG)
	wipe(TBAG_FREE)
	for bag_id = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		local BagType = GetBagType(bag_id) or 0
		if not self["Bag"..bag_id] then
			self["Bag"..bag_id] = Create_BagButton(self, bag_id)
		end
		if not TBAG[BagType] then
			TBAG[BagType] = {}
		end
		if not TBAG_FREE[BagType] then
			TBAG_FREE[BagType] = {}
		end
		Check_BagNumSlots(self["Bag"..bag_id], bag_id)
		for slot_id = 1, GetContainerNumSlots(bag_id) do
			if not self["Bag"..bag_id]["Slot"..slot_id] then
				self["Bag"..bag_id]["Slot"..slot_id] = Create_ItemButton(self["Bag"..bag_id], bag_id, slot_id)
			end
			--local itemLink = GetContainerItemLink(bag_id, slot)
			local slotInfo = GetContainerItemInfo(bag_id, slot_id)
			if slotInfo.itemID then
				insert(TBAG[BagType], slotInfo)
			else
				insert(TBAG_FREE[BagType], slotInfo)
			end
		end
	end
	NSLOT.Free = #TBAG_FREE[0]
	NSLOT.Toatal = NSLOT.Free + #TBAG[0]
end

local function BagFreeItem_Insert(self)
	wipe(TBAG_FREE_NEW)
	for bag_id = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		local BagType = GetBagType(bag_id) or 0
		if not self["Bag"..bag_id] then
			self["Bag"..bag_id] = Create_BagButton(self, bag_id)
		end
		if not TBAG[BagType] then
			TBAG[BagType] = {}
		end
		if not TBAG_FREE[BagType] then
			TBAG_FREE[BagType] = {}
		end
		Check_BagNumSlots(self["Bag"..bag_id], bag_id)
		for slot_id = 1, GetContainerNumSlots(bag_id) do
			if not self["Bag"..bag_id]["Slot"..slot_id] then
				self["Bag"..bag_id]["Slot"..slot_id] = Create_ItemButton(self["Bag"..bag_id], bag_id, slot_id)
				local slotInfo = GetContainerItemInfo(bag_id, slot_id)
				insert(TBAG_FREE[BagType], slotInfo)
			end
		end
	end
end

local function Refresh_SlotNumFree(self)
	NSLOT.Free = 0
	for bag_id = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		local BagType, FreeSlots = GetBagType(bag_id)
		if BagType == 0 then
			NSLOT.Free = NSLOT.Free + FreeSlots or 0
		end
	end
	self["BagIconFreeText"]: SetText(NSLOT.Free)
end

local function Refresh_BagItemInfo(self)
	for bagType, slots in pairs(TBAG) do
		for k, slotInfo in ipairs(slots) do
			GetContainerItemInfo(slotInfo.bagID, slotInfo.slotID, slotInfo)
		end
	end
	for bagType, slots in pairs(TBAG_FREE) do
		for k, slotInfo in ipairs(slots) do
			GetContainerItemInfo(slotInfo.bagID, slotInfo.slotID, slotInfo)
		end
	end
end

local function Remove_BagItem(self)
	for bag_id = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		Check_BagNumSlots(self["Bag"..bag_id], bag_id)
	end
	for bagType, slot in pairs(TBAG) do
		for k, slotInfo in ipairs(slot) do
			if not slotInfo.itemID then
				insert(TBAG_FREE, slotInfo)
				remove(TBAG, k)
			end
		end
	end
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
	elseif (ITEMCLASS[v1.itemType] and ITEMCLASS[v2.itemType]) then
		if (ITEMCLASS[v1.itemType] ~= ITEMCLASS[v2.itemType]) then
			return ITEMCLASS[v1.itemType].L < ITEMCLASS[v2.itemType].L
		elseif v1.itemType == "Hearthstone" then
			return ITEMCLASS.Hearthstone.itemID[v1.itemID].L < ITEMCLASS.Hearthstone.itemID[v2.itemID].L
		elseif (v1.subclassID and v2.subclassID) and (v1.subclassID ~= v2.subclassID) then
			if ITEMCLASS[v1.itemType].SubClass and ITEMCLASS[v2.itemType].SubClass then
				return ITEMCLASS[v1.itemType].SubClass[v1.subclassID].L < ITEMCLASS[v2.itemType].SubClass[v2.subclassID].L
			elseif ITEMCLASS[v1.itemType].SubClass then
				return true
			elseif ITEMCLASS[v2.itemType].SubClass then
				return false
			else
				return v1.subclassID < v2.subclassID
			end
		elseif (v1.itemID and v2.itemID) and (v1.itemID ~= v2.itemID) then
			return v1.itemID > v2.itemID
		else
			return v1.stackCount > v2.stackCount
		end
	elseif (v1.itemEquipLoc and v2.itemEquipLoc) and (v1.itemEquipLoc ~= v2.itemEquipLoc) then
		return v1.itemEquipLoc < v2.itemEquipLoc
	elseif (v1.itemLevel and v2.itemLevel) and (v1.itemLevel ~= v2.itemLevel) then
		return v1.itemLevel > v2.itemLevel
	elseif (v1.quality and v2.quality) and (v1.quality ~= v2.quality) then
		return v1.quality > v2.quality
	elseif (v1.itemID and v2.itemID) and (v1.itemID ~= v2.itemID) then
		return v1.itemID > v2.itemID
	else
		return v1.stackCount > v2.stackCount
	end
end

local function Sort_BagItem(ItemTable)
	for bagType, slots in pairs(ItemTable) do
		table.sort(slots, SortFunc)
	end
end

local function Update_CraftingQualityOverlay(slot, slotInfo)
	if slotInfo.itemID then
		SetItemButtonOverlay(slot, slotInfo.itemID, slotInfo.quality, slotInfo.isBound)
		--SetItemCraftingQualityOverlay(slot, slotInfo.itemID)
		--SetupCraftingQualityOverlay(button, quality)
	else
		ClearItemButtonOverlay(slot)
	end
end

local function Update_SlotItem(slot, slotInfo)
	SetItemButtonTexture(slot, slotInfo.iconFileID or F.Path("Bag_Slot"))
	SetItemButtonCount(slot, slotInfo.stackCount)
	SetItemButtonDesaturated(slot, slotInfo.isLocked)
	Update_CraftingQualityOverlay(slot, slotInfo)

	if not F.IsClassic then
		--ContainerFrameItemButton_UpdateItemUpgradeIcon(slot); --待改

		--local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(v.bagID, v.slotID)
		local QuestInfo = C_Container.GetContainerItemQuestInfo(slotInfo.bagID, slotInfo.slotID)
		if QuestInfo.isQuestItem then
			slot.QuestIcon: Show()
		else
			slot.QuestIcon: Hide()
		end
	else
		slot.QuestIcon: Hide()
	end

	if slotInfo.quality == Enum.ItemQuality.Poor and not slotInfo.hasNoValue then
		slot.JunkIcon: Show()
	else
		slot.JunkIcon: Hide()
	end

	if slotInfo.quality and (slotInfo.quality > 1) then
		local color = ITEM_QUALITY_COLORS[slotInfo.quality]
		slot.QualityIcon: SetVertexColor(color.r,color.g,color.b)
		slot.QualityIcon: Show()
		slot.Border: SetBackdropBorderColor(color.r,color.g,color.b, 0.9)
	else
		slot.QualityIcon: Hide()
		slot.Border: SetBackdropBorderColor(F.Color(C.Color.W4, 0.9))
	end

	local isNewItem = C_NewItems.IsNewItem(slotInfo.bagID, slotInfo.slotID)
	if isNewItem then
		slot.NewItemTexture: Show()
	else
		slot.NewItemTexture: Hide()
	end

	if (slotInfo.itemType == ITEMCLASS_NAME[Enum.ItemClass.Weapon]) or (slotInfo.itemType == ITEMCLASS_NAME[Enum.ItemClass.Armor]) then
		slot.Level: SetText(slotInfo.itemLevel)
	else
		slot.Level: SetText("")
	end

	local start, duration, enable = C_Container.GetContainerItemCooldown(slotInfo.bagID, slotInfo.slotID)
	CooldownFrame_Set(slot.cooldown, start, duration, enable)
	if duration > 0 and enable == 0 then
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
	else
		SetItemButtonTextureVertexColor(slot, 1, 1, 1)
	end

	--local isBattlePayItem = C_Container.IsBattlePayItem(slotInfo.bagID, slotInfo.slotID)
end

local function Update_BagItem(self)
	for bagType, slots in pairs(TBAG) do
		for k, slotInfo in ipairs(slots) do
			Update_SlotItem(self["Bag"..slotInfo.bagID]["Slot"..slotInfo.slotID], slotInfo)
		end
	end
	for bagType, slots in pairs(TBAG_FREE) do
		for k, slotInfo in ipairs(slots) do
			Update_SlotItem(self["Bag"..slotInfo.bagID]["Slot"..slotInfo.slotID], slotInfo)
		end
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

local function Sell_Junk()
	if F.IsRetail then
		C_MerchantFrame.SellAllJunkItems()
	else
		local JUNK_NUM = 0
		local JUNK_PRICE = 0
		for k,v in ipairs(TBAG[0]) do
			if v.itemType then
				if v.itemType == "Sale" then
					if JUNK_NUM < 12 then
						local currPrice = (select(11, C_Item.GetItemInfo(v.itemID)) or 0) * (v.stackCount or 1)
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
end

local function BagGap_Init(f, classtable, p, bank)
	local parent
	if p then
		parent = p
	else
		parent = f
	end
	for k, v in pairs(classtable) do
		local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
		frame: SetSize(CONFIG.buttonSize, CONFIG.buttonSize)

		local icon = frame:CreateTexture(nil, "ARTWORK")
		icon: SetSize(CONFIG.iconSize, CONFIG.iconSize)
		icon: SetPoint("CENTER", frame, "CENTER", 0,0)
		icon: SetTexture(F.Path(v.F))
		icon: SetVertexColor(F.Color(C.Color.Config.Exit))
		
		local shadow = frame:CreateTexture(nil, "BORDER")
		shadow: SetSize(CONFIG.iconSize, CONFIG.iconSize)
		shadow: SetPoint("CENTER", icon, "CENTER", 2,2)
		shadow: SetTexture(F.Path(v.F))
		shadow: SetVertexColor(F.Color(C.Color.W2))
		shadow: SetAlpha(0.5)

		local text = v.T or (v.sub and GetItemSubClassInfo(v.id, v.sub)) or (v.id and GetItemClassInfo(v.id))
		if text then
			frame: SetScript("OnEnter", function(self)
				GameTooltip: SetOwner(self, "ANCHOR_NONE", 0,0)
				GameTooltip: SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0,4)
				GameTooltip: SetText(text)
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
	NewItem: SetSize(CONFIG.buttonSize, CONFIG.buttonSize)

	local NewItemIcon = NewItem:CreateTexture(nil, "ARTWORK")
	NewItemIcon: SetSize(CONFIG.iconSize, CONFIG.iconSize)
	NewItemIcon: SetPoint("CENTER", NewItem, "CENTER", 0,0)
	NewItemIcon: SetTexture(F.Path("Bag_New"))
	NewItemIcon: SetVertexColor(F.Color(C.Color.Config.Exit))

	f["BagIconNew"] = NewItem
	f["BagIconNew"].Tex = NewItemIcon
	
	local numfree = CreateFrame("Button", nil, parent)
	numfree: SetSize(CONFIG.buttonSize, CONFIG.buttonSize)
	f["BagIconFree"] = numfree
	
	local freetext = F.Create.Font(numfree, "ARTWORK", C.Font.Num, 16, nil, C.Color.Config.Exit, 1, C.Color.W1, 0, {0,0}, "CENTER", "CENTER")
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
	ButtonHighLight_Create(f["BagIconNew"], C.Color.Config.Exit)

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
			--GameTooltip: SetText(L['SELL_JUNK'])
			GameTooltip: SetText(SELL_ALL_JUNK_ITEMS)
			GameTooltip: Show()
		end)
		f["BagIconSale"]: SetScript("OnLeave", function(self)
			GameTooltip: Hide()
		end)
		ButtonHighLight_Create(f["BagIconSale"], C.Color.Config.Exit)
	end
end

local function SetPoint_Init(self)
	self.BagHold.NumBag = self.BagHold.NumBag or 0
	self.BagHold.NumFree = self.BagHold.NumFree or 0
	self.BagHold.NumExtra = self.BagHold.NumExtra or 0
	self.BagHold.NumExtraT = self.BagHold.NumExtraT or 0
end

local function SetPoint_Slot(self, anchor, pos_x, pos_y)
	self: ClearAllPoints()
	self: SetPoint("TOPLEFT", anchor, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
	self: SetAlpha(1)
end

local function BagGap_Reset(self, classtable)
	for k, v in pairs(classtable) do
		self["BagIcon"..k]: ClearAllPoints()
		self["BagIcon"..k]: Hide()
	end
	self["BagIconNew"]: ClearAllPoints()
	self["BagIconNew"]: Hide()
	self["BagIconFree"]: ClearAllPoints()
	self["BagIconFree"]: Hide()
end

local function SetPoint_BagItem(self)
	local pos_x, pos_y
	local num = 0
	local item_type = ""
	BagGap_Reset(self, ITEMCLASS)
	for k, slot_info in ipairs(TBAG[0]) do
		num = num + 1
		if slot_info.itemType and item_type ~= slot_info.itemType then
			item_type = slot_info.itemType
			pos_y = floor((num+CONFIG.perLine-1)/CONFIG.perLine) - 1
			pos_x = num - pos_y * CONFIG.perLine - 1
			SetPoint_Slot(self["BagIcon"..item_type], self.BagHold, pos_x, pos_y)
			self["BagIcon"..item_type]: Show()
			num = num + 1
		end
		pos_y = floor((num+CONFIG.perLine-1)/CONFIG.perLine) - 1
		pos_x = num - pos_y * CONFIG.perLine - 1
		SetPoint_Slot(self["Bag"..slot_info.bagID]["Slot"..slot_info.slotID], self.BagHold, pos_x, pos_y)
	end
	self.BagHold.NumBag = num
end

local function SetPoint_BagFreeItem(self)
	local newgap = false
	local freegap = false
	local num = self.BagHold.NumBag
	local pos_x, pos_y
	for k, slot_info in ipairs(TBAG_FREE[0]) do
		num = num + 1
		if (not newgap) and slot_info.itemType then
			pos_y = floor((num + CONFIG.perLine - 1)/CONFIG.perLine) - 1
			pos_x = num - pos_y * CONFIG.perLine - 1
			SetPoint_Slot(self["BagIconNew"], self.BagHold, pos_x, pos_y)
			self["BagIconNew"]: Show()
			num = num + 1
			newgap = true
		end
		if (not freegap) and (not slot_info.itemType) then
			pos_y = floor((num + CONFIG.perLine - 1)/CONFIG.perLine) - 1
			pos_x = num - pos_y * CONFIG.perLine - 1
			SetPoint_Slot(self["BagIconFree"], self.BagHold, pos_x, pos_y)
			self["BagIconFreeText"]: SetText(NSLOT.Free)
			self["BagIconFree"]: Show()
			num = num + 1
			freegap = true
		end
		pos_y = floor((num + CONFIG.perLine - 1)/CONFIG.perLine) - 1
		pos_x = num - pos_y * CONFIG.perLine - 1
		SetPoint_Slot(self["Bag"..slot_info.bagID]["Slot"..slot_info.slotID], self.BagHold, pos_x, pos_y)
	end
	self.BagHold.NumFree = num - self.BagHold.NumBag
end

local function SetPoint_OtherBagItem(self)
	local pos_x, pos_y
	local e = 0
	local et = 0
	local num = self.BagHold.NumBag + self.BagHold.NumFree
	for t,s in pairs(TBAG) do
		if t ~= 0 then
			et = et + 1
			e = ceil(e/CONFIG.perLine)*CONFIG.perLine
			for k,v in ipairs(s) do
				e = e + 1
				pos_y = floor((num+CONFIG.perLine-1)/CONFIG.perLine)+floor((e+CONFIG.perLine-1)/CONFIG.perLine) - 1
				pos_x = e - (floor((e+CONFIG.perLine-1)/CONFIG.perLine)-1) * CONFIG.perLine - 1

				self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", self.BagHold, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border*(et+1)-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
			for k,v in ipairs(TBAG_FREE[t]) do
				e = e + 1
				pos_y = floor((num+CONFIG.perLine-1)/CONFIG.perLine)+floor((e+CONFIG.perLine-1)/CONFIG.perLine) - 1
				pos_x = e - (floor((e+CONFIG.perLine-1)/CONFIG.perLine)-1) * CONFIG.perLine - 1
				
				self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", self.BagHold, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border*(et+1)-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
		end
	end
	self.BagHold.NumExtra = e
	self.BagHold.NumExtraT = et
end

local function BagFrame_ReSize(self)
	height = (CONFIG.buttonSize+CONFIG.buttonGap*2)*(ceil((self.BagHold.NumBag + self.BagHold.NumFree)/CONFIG.perLine)+ceil(self.BagHold.NumExtra/CONFIG.perLine))+CONFIG.border*(2+self.BagHold.NumExtraT)
	self.BagHold: SetHeight(height)
	--frame: SetHeight(pos_y+48+2)
end

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

local function FullUpdate_BagItem(self)
	PlayerMoney_Update(self)
	if InCombatLockdown() then
		Refresh_BagItemInfo(self)
		Update_BagItem(self)
		self.NeedUpdate = true
	else
		Insert_BagItem(self)

		Sort_BagItem(TBAG)
		Update_BagItem(self)

		SetPoint_Init(self)
		SetPoint_BagItem(self)
		SetPoint_BagFreeItem(self)
		SetPoint_OtherBagItem(self)

		BagFrame_ReSize(self)
	end
end

local function LimitedUpdate_BagItem(self)
	PlayerMoney_Update(self)
	if InCombatLockdown() then
		Refresh_BagItemInfo(self)
		Update_BagItem(self)
		self.NeedUpdate = true
	else
		BagFreeItem_Insert(self)
		Refresh_BagItemInfo(self)
		Remove_BagItem(self)

		Sort_BagItem(TBAG)
		Sort_BagItem(TBAG_FREE)
		Refresh_SlotNumFree(self)
		Update_BagItem(self)

		SetPoint_Init(self)
		SetPoint_BagItem(self)
		SetPoint_BagFreeItem(self)
		SetPoint_OtherBagItem(self)

		BagFrame_ReSize(self)
	end
end

local function Update_ItemLock(self, ...)
	if (not (self and self:IsShown())) then return end
	local bagID, slotID = ...
	if bagID and slotID and self["Bag"..bagID] and self["Bag"..bagID]["Slot"..slotID] then
		local slotInfo = C_Container.GetContainerItemInfo(bagID, slotID)
		local button = self["Bag"..bagID]["Slot"..slotID]
		SetItemButtonDesaturated(button, slotInfo.isLocked, 0.5,0.5,0.5)
		if slotInfo.isLocked then
			if slotInfo.quality and (slotInfo.quality > 1) then
				button.QualityIcon: SetVertexColor(0.5,0.5,0.5)
				button.Border: SetBackdropBorderColor(0.5,0.5,0.5, 0.9)
			end
		else
			if slotInfo.quality and (slotInfo.quality > 1) then
				local color = ITEM_QUALITY_COLORS[slotInfo.quality]
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
			itemButton = frame["Bag"..bagID]["Slot"..slotID]
			if itemButton then
				ItemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
				if ItemInfo then
					if  ItemInfo.isFiltered then
						SetItemButtonDesaturated(item, 1)
						itemButton:SetAlpha(0.4)
						--itemButton.searchOverlay:Show();
						if ItemInfo.quality and (ItemInfo.quality > 1) then
							itemButton.QualityIcon: SetVertexColor(0.5,0.5,0.5)
							itemButton.Border: SetBackdropBorderColor(0.5,0.5,0.5, 0.9)
						end
					else
						SetItemButtonDesaturated(item)
						itemButton:SetAlpha(1)
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
--- Currency
--- ------------------------------------------------------------

local function RefreshButton_OnEnter(self)
	--self.Backdrop: SetBackdropColor(F.Color(C.Color.W3,1))
	--self.Backdrop: SetBackdropBorderColor(F.Color(C.Color.W3,1))
	self.Backdrop: SetAlpha(1)
	self.Icon: SetVertexColor(F.Color(C.Color.Config.Back))
	if self.tooltipText then
		GameTooltip: SetOwner(self, "ANCHOR_NONE", 0,0)
		GameTooltip: SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0,4)
		GameTooltip: SetText(self.tooltipText)
		GameTooltip: Show()
	end
end

local function RefreshButton_OnLeave(self)
	--self.Backdrop: SetBackdropColor(F.Color(C.Color.W3,0))
	--self.Backdrop: SetBackdropBorderColor(F.Color(C.Color.W3,0))
	self.Backdrop: SetAlpha(0)
	self.Icon: SetVertexColor(F.Color(C.Color.W3))
	GameTooltip: Hide()
end

local function RefreshButton_OnClick(self)
	self:GetParent():GetParent():FullUpdate_BagItem()
end

local function RefreshButton_UpdateVisible(self)
	local point, relativeTo, relativePoint = self.Currency.RefreshButton:GetPoint()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
		self.Currency.RefreshButton: SetPoint(point, relativeTo, relativePoint, 0, 0)
		self.Currency.RefreshButton: Hide()
	else
		self.Currency.RefreshButton: SetPoint(point, relativeTo, relativePoint, 40, 0)
		self.Currency.RefreshButton: Show()
	end
end

local function ExtraButton_Create(self)
	local DummyButton = CreateFrame("Button", nil, self)
	DummyButton: SetSize(26,26)
	DummyButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")

	DummyButton.Backdrop = F.Create.Backdrop(DummyButton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.W3, aBg = 1, cBd = C.Color.W3, aBd = 1})
	DummyButton.Backdrop: SetAlpha(0)
	
	--DummyButton.tooltipText = L['BAG_GROUP_REFRESH']

	local Icon = F.Create.Texture(DummyButton, "ARTWORK", 1, F.Path("Bag_Clean"), C.Color.W3, 1, {20,20})
	Icon: SetPoint("CENTER")
	DummyButton.Icon = Icon

	DummyButton: SetScript("OnEnter", RefreshButton_OnEnter)
	DummyButton: SetScript("OnLeave", RefreshButton_OnLeave)
	--DummyButton: SetScript("OnClick", RefreshButton_OnClick)

	return DummyButton
end

local function MoneyState_OnEnter(self)
	if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Gold then
		if not self.List then
			self.List = {}
		else
			wipe(self.List)
		end
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
end

local function MoneyState_OnLeave(self)
	GameTooltip: Hide()
end



local function Currency_Frame(f)
	local Currency = CreateFrame("Frame", nil, f)
	Currency: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.perLine+CONFIG.border*2, 44)
	Currency: SetPoint("TOP", f, "TOP", 0,0)
	f.Currency = Currency

	local money = F.Create.Font(f.Currency, "ARTWORK", C.Font.NumOW, 24, nil, C.Color.Y2, 1, C.Color.W1, 0, {0,0}, "RIGHT", "MIDDLE")
	money: SetPoint("RIGHT", f.Currency, "RIGHT", -42,-3)
	f.Currency.Money = money

	local MoneyHelp = CreateFrame("Button", nil, f.Currency)
	MoneyHelp: SetAllPoints(money)
	MoneyHelp.List = {}
	MoneyHelp.Total = 0
	MoneyHelp: SetScript("OnEnter", MoneyState_OnEnter)
	MoneyHelp: SetScript("OnLeave", MoneyState_OnLeave)
	f.Currency.MoneyHold = MoneyHelp

	PlayerMoney_Update(f)

	local CloseButton = CreateFrame("Button", nil, f.Currency)
	CloseButton: SetSize(24,30)
	CloseButton: SetPoint("RIGHT", f.Currency, "RIGHT", -6,0)
	CloseButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	--CloseButton.Bg = F.Create.Backdrop(CloseButton, {cBg = C.Color.Config.Exit, aBg = 0, cBd = C.Color.W1, aBd = 0})
	CloseButton.Bg = F.Create.Backdrop(CloseButton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.Config.Exit, aBg = 1, cBd = C.Color.Config.Exit, aBd = 1})
	CloseButton.Bg: SetAlpha(0)

	local closebuttonicon = F.Create.Font(CloseButton, "ARTWORK", C.Font.NumOW, 24, nil, C.Color.W3, 1, C.Color.W1, 0, {0,0}, "CENTER")
	closebuttonicon: SetPoint("CENTER", CloseButton, "CENTER", 0,-3)
	closebuttonicon: SetText("X")
	
	CloseButton: SetScript("OnClick", function(self, button)
		f:Hide()
	end)
	CloseButton: SetScript("OnEnter", function(self)
		--self.Bg: SetBackdropColor(F.Color(C.Color.Config.Exit,1))
		self.Bg: SetAlpha(1)
		closebuttonicon: SetTextColor(F.Color(C.Color.Config.Back))
	end)
	CloseButton: SetScript("OnLeave", function(self)
		--self.Bg: SetBackdropColor(F.Color(C.Color.Config.Exit,0))
		self.Bg: SetAlpha(0)
		closebuttonicon: SetTextColor(F.Color(C.Color.W3))
	end)
	
	local menubutton = CreateFrame("Button", nil, f.Currency)
	menubutton: SetSize(24,30)
	menubutton: SetPoint("LEFT", f.Currency, "LEFT", 6,0)
	--menubutton.Bg = F.Create.Backdrop(menubutton, 0, false, 0, 0, C.Color.Config.Exit,0, C.Color.W1,0)
	menubutton.Bg = F.Create.Backdrop(menubutton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.Config.Exit, aBg = 1, cBd = C.Color.Config.Exit, aBd = 1})
	menubutton.Bg: SetAlpha(0)
	
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
		self.Bg: SetAlpha(1)
		menubuttonicon: SetVertexColor(F.Color(C.Color.Config.Back))
	end)
	menubutton: SetScript("OnLeave", function(self)
		self.Bg: SetAlpha(0)
		menubuttonicon: SetVertexColor(F.Color(C.Color.W3))
	end)

	local RefreshButton = ExtraButton_Create(f.Currency)
	RefreshButton: SetPoint("CENTER", menubutton, "CENTER", 40, 0)
	RefreshButton.tooltipText = L['BAG_GROUP_REFRESH']
	RefreshButton: SetScript("OnClick", RefreshButton_OnClick)

	if F.IsClassic then
		local KeyRingFrame = KeyRing_Template(f.Currency)
		KeyRingFrame: SetPoint("CENTER", RefreshButton, "CENTER", 40, 0)
	end

	f.Currency.RefreshButton = RefreshButton
	RefreshButton_UpdateVisible(f)
end

local function BagExtra_Frame(f)
	local bagextra = CreateFrame("Frame", "Quafe_BagExtra", f)
	bagextra: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.perLine+CONFIG.border*2, 36)
	bagextra: SetPoint("BOTTOM", f, "TOP", 0,2)
	bagextra.Bg = F.Create.Backdrop(bagextra, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9,aBd = 0.9})
	bagextra: Hide()
	f.Extra = bagextra
	
	local editbox = CreateFrame("EditBox", "Quafe_BagEditBox", bagextra, "BagSearchBoxTemplate")
	editbox: SetSize(120,16)
	editbox: SetPoint("LEFT", bagextra, "LEFT", 35,0)
	editbox: SetAutoFocus(false)
	editbox.Left: Hide()
	editbox.Middle: Hide()
	editbox.Right: Hide()
	editbox.Bg = F.Create.Backdrop(editbox, {wide = 6, edge = 8, inset = 6, cBg = C.Color.W2, aBg = 0, cBd = C.Color.W4, aBd = 0.9})

	local AddSlotButton = ExtraButton_Create(bagextra)
	AddSlotButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	AddSlotButton.Icon: SetTexture(F.Path("Bag_Button3"))
	AddSlotButton.tooltipText = BACKPACK_AUTHENTICATOR_INCREASE_SIZE

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
	--for bagID = 0, NUM_BAG_SLOTS + 1 do
	for bag_id = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
		local button
		if F.IsClassic then
			if bag_id == 0 then
				button = CreateFrame("CheckButton", "Quafe_BagBackpack", bagextra, "Quafe_BackpackButtonClassicTemplate")
				
			else
				button = CreateFrame("CheckButton", "Quafe_BagBag"..(bag_id-1).."Slot", bagextra, "Quafe_BagSlotButtonClassicTemplate")
			end
		else
			if bag_id == 0 then
				button = CreateFrame("ItemButton", "Quafe_BagBackpack", bagextra, "Quafe_BackpackButtonTemplate")
				button.commandName = "TOGGLEBACKPACK"
			elseif bag_id == 5 then
				button = CreateFrame("ItemButton", "Quafe_BagReagentBag0Slot", bagextra, "Quafe_BagSlotButtonTemplate")
				button.commandName = "TOGGLEREAGENTBAG1"
			else
				button = CreateFrame("ItemButton", "Quafe_BagBag"..(bag_id-1).."Slot", bagextra, "Quafe_BagSlotButtonTemplate")
				button.commandName = "TOGGLEBAG"..(5-bag_id)
			end
		end
		button: SetSize(24,24)
		local invID
		if bag_id == 0 then
			invID = bag_id
			button: SetPoint("RIGHT", bagextra, "RIGHT", -33,0)
		else
			invID = C_Container.ContainerIDToInventoryID(bag_id)
			button: SetPoint("RIGHT", lastbutton, "LEFT", -4,0)
		end
		button.invID = invID
		button.bagID = bag_id
		button: SetID(invID)
		
		--button: SetNormalTexture("")
		--button: SetNormalTexture(0)
		button: ClearNormalTexture()
		button: SetPushedTexture(F.Path("Button\\Bag_Pushed"))
		button: SetHighlightTexture(F.Path("Button\\Bag_Hightlight"))

		button.icon: SetAllPoints(button)
		button.icon: SetTexCoord(0.1,0.9, 0.1,0.9)

		button.Border = F.Create.Backdrop(button, {border = true, wide = 0, edge = 1, inset = 0, cBg = C.Color.W1, aBg = 0, cBd = C.Color.W4, aBd = 0.9})

		if button.IconBorder then
			--button.IconBorder: SetTexture("")
			--button.IconBorder: Hide()
			button.IconBorder: SetAlpha(0)
		end
		
		button: RegisterForDrag("LeftButton", "RightButton")
		--button: RegisterForClicks("anyUp")
		--[[
		button: SetScript("OnClick", function(self, button)
			if (PutItemInBag(self.invID)) then return end
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
		f.Extra["Bag"..bag_id] = button
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
--- Bag Frame
--- ------------------------------------------------------------

local function BagFrame_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self: FullUpdate_BagItem()
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
	elseif event ==	"PLAYER_REGEN_ENABLED" then
		if self.NeedUpdate then
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
				LimitedUpdate_BagItem(self)
			elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
				LimitedUpdate_BagItem(self)
			elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
				FullUpdate_BagItem(self)
			end
			self.NeedUpdate = false
		end
	end
end

local function BagFrame_OnShow(self)
	self: RegisterEvent("BAG_UPDATE")
	--self: RegisterEvent("BAG_UPDATE_DELAYED")
	self: RegisterEvent("UNIT_INVENTORY_CHANGED")
	if F.IsRetail then
		self: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
	self: RegisterEvent("ITEM_LOCK_CHANGED")
	self: RegisterEvent("BAG_UPDATE_COOLDOWN")
	self: RegisterEvent("BAG_NEW_ITEMS_UPDATED")
	--self: RegisterEvent("DISPLAY_SIZE_CHANGED")
	self: RegisterEvent("INVENTORY_SEARCH_UPDATE")

	self: RegisterEvent("PLAYER_REGEN_ENABLED")
	self: RegisterEvent("PLAYER_MONEY")

	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
		if self.FullUpdate then
			LimitedUpdate_BagItem(self)
		else
			FullUpdate_BagItem(self)
			--C_Timer.After(2, function() FullUpdate_BagItem(self) end)
			self.FullUpdate = true
		end
	elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
		if self.FullUpdate then
			LimitedUpdate_BagItem(self)
		else
			FullUpdate_BagItem(self)
			--C_Timer.After(2, function() FullUpdate_BagItem(self) end)
			self.FullUpdate = true
		end
	elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
		if self.FullUpdate then
			FullUpdate_BagItem(self)
		else
			FullUpdate_BagItem(self)
			--C_Timer.After(2, function() FullUpdate_BagItem(self) end)
			self.FullUpdate = true
		end
	end
	--Quafe_UpdateAfter()
	PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
end

local function BagFrame_OnHide(self)
	self: UnregisterEvent("BAG_UPDATE")
	--self: UnregisterEvent("BAG_UPDATE_DELAYED")
	self: UnregisterEvent("UNIT_INVENTORY_CHANGED")
	if F.IsRetail then
		self: UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
	self: UnregisterEvent("ITEM_LOCK_CHANGED")
	self: UnregisterEvent("BAG_UPDATE_COOLDOWN")
	self: UnregisterEvent("BAG_NEW_ITEMS_UPDATED")
	--self: UnregisterEvent("DISPLAY_SIZE_CHANGED")
	self: UnregisterEvent("INVENTORY_SEARCH_UPDATE")

	self: UnregisterEvent("PLAYER_REGEN_ENABLED")
	self: UnregisterEvent("PLAYER_MONEY")

	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Manual" then
		LimitedUpdate_BagItem(self)
	elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Closing" then
		FullUpdate_BagItem(self)
	elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Container.RefreshRate == "Always" then
		FullUpdate_BagItem(self)
	end
	--PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
end

local function BagFrame_OnDragStart(self)
	self:StartMoving()
end

local function UpdatePostion(self, database)
	self: StopMovingOrSizing()
	database[1], database[2], database[3], database[4], database[5] = self:GetPoint()
end

local function BagFrame_OnDragStop(self)
	UpdatePostion(self, Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BagPos)
end

local function Bag_Frame(self)
	local BagFrame = CreateFrame("Frame", "Quafe_BagFrame", UIParent)
	BagFrame: SetFrameStrata("HIGH")
	BagFrame: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.perLine+CONFIG.border*2, 44)
	BagFrame: SetPoint("RIGHT", UIParent, "RIGHT", -80,0)
	BagFrame.Bg = F.Create.Backdrop(BagFrame, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9, aBd = 0.9})

	function BagFrame: FullUpdate_BagItem()
		FullUpdate_BagItem(self)
	end
	
	BagFrame: SetClampedToScreen(true)
	BagFrame: SetMovable(true)
	BagFrame: EnableMouse(true)
	BagFrame: RegisterForDrag("LeftButton","RightButton")
	BagFrame: SetScript("OnDragStart", BagFrame_OnDragStart)
	BagFrame: SetScript("OnDragStop", BagFrame_OnDragStop)

	Currency_Frame(BagFrame)
	BagExtra_Frame(BagFrame)

	local BagHold = CreateFrame("Frame", nil, BagFrame)
	BagHold: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.perLine+CONFIG.border*2, CONFIG.buttonSize+CONFIG.border*2)
	BagHold: SetPoint("TOP", BagFrame, "BOTTOM", 0,-2)
	--BagHold.Bg = F.Create.Backdrop(BagHold, {wide = 2, edge = 8, inset = 4, aBg = 0, aBd = 0})
	BagHold.Bg = F.Create.Backdrop(BagHold, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9, aBd = 0.9})
	BagFrame.BagHold = BagHold

	ItemClass_Init()
	BagGap_Init(BagFrame, ITEMCLASS)

	BagFrame: RegisterEvent("PLAYER_LOGIN")
	--BagFrame: RegisterEvent("PLAYER_ENTERING_WORLD")
	--[[
	BagFrame: RegisterEvent("UNIT_INVENTORY_CHANGED")
	if not F.IsClassic then
		BagFrame: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
	BagFrame: RegisterEvent("BAG_UPDATE")
	BagFrame: RegisterEvent("BAG_UPDATE_DELAYED")
	BagFrame: RegisterEvent("BAG_NEW_ITEMS_UPDATED")
	BagFrame: RegisterEvent("ITEM_LOCK_CHANGED")
	--BagFrame: RegisterEvent("ITEM_UNLOCKED")
	BagFrame: RegisterEvent("BAG_UPDATE_COOLDOWN")
	BagFrame: RegisterEvent("INVENTORY_SEARCH_UPDATE")
	BagFrame: RegisterEvent("PLAYER_MONEY")
	BagFrame: RegisterEvent("PLAYER_REGEN_ENABLED")
	--]]
	

	BagFrame: SetScript("OnEvent", BagFrame_OnEvent)

	BagFrame: SetScript("OnShow", BagFrame_OnShow)
	BagFrame: SetScript("OnHide", BagFrame_OnHide)

	self.BagFrame = BagFrame
end

--- ------------------------------------------------------------
--- Container Frame
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
--[[
function MyAddon: OpenAllBags(requesterFrame)
	--if requesterFrame then return end
	Bag_Open()
end

function MyAddon: CloseAllBags(requesterFrame)
	if requesterFrame then return end
	Bag_Close()
end

function MyAddon: ToggleAllBags(requesterFrame)
	if requesterFrame then return end
	Bag_Toggle()
end

function MyAddon: OpenBackpack()
	Bag_Open()
end

function MyAddon: CloseBackpack()
	Bag_Close()
end

function MyAddon: ToggleBackpack()
	Bag_Toggle()
end

function MyAddon: CloseSpecialWindows()
	return self:CloseAllBags()
end

local function Enable_Hooks()
	MyAddon: RawHook("OpenAllBags", true)
	--MyAddon: SecureHook("CloseAllBags") --esc问题
	MyAddon: RawHook("ToggleAllBags", true)
	MyAddon: RawHook("OpenBackpack", true)
	--MyAddon: SecureHook("CloseBackpack") --esc问题
	MyAddon: RawHook("ToggleBackpack", true)
	--MyAddon: SecureHook("CloseSpecialWindows")
end

local function Disable_Hooks()
	MyAddon: Unhook("OpenAllBags", true)
	--MyAddon: Unhook("CloseAllBags")
	MyAddon: Unhook("ToggleAllBags", true)
	MyAddon: Unhook("OpenBackpack", true)
	--MyAddon: Unhook("CloseBackpack")
	MyAddon: Unhook("ToggleBackpack", true)
	--MyAddon: Unhook("CloseSpecialWindows")
end
--]]
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

local function Bag_Show()
	if ContainerFrame_AllowedToOpenBags() and Quafe_Container.BagFrame then
		Quafe_Container.BagFrame:Show()
	end
	return Quafe_Container.BagFrame
end

local function Bag_Hide()
	if Quafe_Container.BagFrame then
		Quafe_Container.BagFrame:Hide()
	end
	return Quafe_Container.BagFrame
end

local function Bag_Toggle()
	if Quafe_Container.BagFrame and Quafe_Container.BagFrame: IsShown() then
		return Bag_Hide()
	else
		return Bag_Show()
	end
end

local function StopIf(domain, name, hook)
	local original = domain and domain[name]
	if original then
		domain[name] = function(...)
			--hook() 
			if not hook(...) then
				return original(...)
			end
		end
	end
end

local function Hook_Blizzard()
	StopIf(_G, "OpenAllBags", Bag_Show)
	StopIf(_G, "OpenBackpack", Bag_Show)

	StopIf(_G, "ToggleAllBags", Bag_Toggle)
	StopIf(_G, "ToggleBackpack", Bag_Toggle)

	--hooksecurefunc("CloseAllBags", Bag_Hide)
	--hooksecurefunc("CloseBackpack", Bag_Hide)
end

local function Quafe_Container_Load()
	if F.Avoid_Clash == 1 then
		Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable = false
		--return
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].Enable then
		Bag_Frame(Quafe_Container)
		Quafe_Container.BagFrame: ClearAllPoints()
		Quafe_Container.BagFrame: SetPoint(unpack(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Container"].BagPos))
		insert(UISpecialFrames, Quafe_Container.BagFrame:GetName())

		--BindingFrame_Init(Quafe_Container)
		--Enable_Hooks() --引起UseAction()问题
		Hook_Blizzard()

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

local Quafe_Container_Config = {}
Quafe_Container_Config.Database = {
	["Quafe_Container"] = {
		Enable = true,
		Gold = {},
		RefreshRate = "Closing", --Always, Closing, Manual
		Scale = 1,
		BagPos = {"RIGHT", nil, "RIGHT", -80,0}
	}
}
Quafe_Container_Config.Config = {
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
}

Quafe_Container.Load = Quafe_Container_Load
Quafe_Container.Config = Quafe_Container_Config
insert(E.Module, Quafe_Container)

--- ------------------------------------------------------------
--> Bank
--- ------------------------------------------------------------

--- ------------------------------------------------------------
--> Functions
--- ------------------------------------------------------------

local Bank_BagID = {-1,6,7,8,9,10,11,12}

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

local function Create_BankButton(self, bagID)
	local button = CreateFrame("Button", "Quafe_Bag"..bagID, self)
	button: SetFrameLevel(self:GetFrameLevel())
	button: SetID(bagID)
	button.isBag = 1

	return button
end

local function SortFunc_Reagent(v1, v2)
	if (v1.classID and v2.classID) and v1.classID ~= v2.classID then
		return v1.classID < v2.classID
	elseif (v1.subclassID and v2.subclassID) and v1.subclassID ~= v2.subclassID then
		return v1.subclassID < v2.subclassID
	elseif (v1.itemLevel and v2.itemLevel) and v1.itemLevel ~= v2.itemLevel then
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
		return v1.stackCount > v2.stackCount
	end
end

local function Sort_ReagentItem(ItemTable)
	table.sort(ItemTable, SortFunc_Reagent)
end

local function Update_BankItem(frame)
	for BagType, Slots in pairs(TBANK) do
		for k,v in ipairs(TBANK[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
		for k,v in ipairs(TBANK_FREE[BagType]) do
			Update_SlotItem(frame["Bag"..v.bagID]["Slot"..v.slotID], v)
		end
	end
end

local function Update_ReagentItem(f)
	for k,v in ipairs(TREAGENT) do
		Update_SlotItem(f["Bag"..v.bagID]["Slot"..v.slotID], v)
	end
	for k,v in ipairs(TREAGENT_FREE) do
		Update_SlotItem(f["Bag"..v.bagID]["Slot"..v.slotID], v)
	end
end

local function Pos_BankItem(self, pos)
	local pos_x,pos_y
	local num = 0
	local e = 0
	local et = 0
	local it = ""
	BagGap_Reset(self, ITEMCLASS)
	for k,v in ipairs(TBANK[0]) do
		num = num + 1
		if v.itemType and it ~= v.itemType then
			it = v.itemType
			pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
			pos_x = num - pos_y * CONFIG.bankperLine - 1
			self["BagIcon"..it]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
			self["BagIcon"..it]: Show()
			num = num + 1
		end
		pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
		pos_x = num - pos_y * CONFIG.bankperLine - 1
		
		self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end

	for k,v in ipairs(TBANK_FREE[0]) do
		num = num + 1
		if k == 1 then
			pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
			pos_x = num - pos_y * CONFIG.bankperLine - 1
			self["BagIconFree"]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
			self["BagIconFreeText"]: SetText(NSLOT.BankFree)
			self["BagIconFree"]: Show()
			num = num + 1
		end
		pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
		pos_x = num- pos_y * CONFIG.bankperLine - 1
		
		self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end

	for t,s in pairs(TBANK) do
		if t ~= 0 then
			et = et + 1
			e = ceil(e/CONFIG.bankperLine)*CONFIG.bankperLine
			for k,v in ipairs(s) do
				e = e + 1
				pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine)+floor((e+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
				pos_x = e - (floor((e+CONFIG.bankperLine-1)/CONFIG.bankperLine)-1) * CONFIG.bankperLine - 1
				
				self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border*(et+1)-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
			for k,v in ipairs(TBANK_FREE[t]) do
				e = e + 1
				pos_y = floor((num+CONFIG.bankperLine-1)/CONFIG.bankperLine)+floor((e+CONFIG.bankperLine-1)/CONFIG.bankperLine) - 1
				pos_x = e - (floor((e+CONFIG.bankperLine-1)/CONFIG.bankperLine)-1) * CONFIG.bankperLine - 1
				
				self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", pos, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border*(et+1)-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
				self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
			end
		end
	end

	pos_y = (CONFIG.buttonSize+CONFIG.buttonGap*2)*(ceil(num/CONFIG.bankperLine)+ceil(e/CONFIG.bankperLine))+CONFIG.border*(2+et)
	self.BagHold: SetHeight(pos_y)
	--self: SetHeight(pos_y+48+2)
end

local function Pos_ReagentItem(self)
	local pos_x,pos_y
	local num = 0
	for k,v in ipairs(TREAGENT) do
		num = num + 1
		pos_y = floor((num+CONFIG.reagentperLine-1)/CONFIG.reagentperLine) - 1
		pos_x = num - pos_y * CONFIG.reagentperLine - 1
		
		self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", self.Reagent, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end
	for k,v in ipairs(TREAGENT_FREE) do
		num = num + 1
		pos_y = floor((num+CONFIG.reagentperLine-1)/CONFIG.reagentperLine) - 1
		pos_x = num- pos_y * CONFIG.reagentperLine - 1
		
		self["Bag"..v.bagID]["Slot"..v.slotID]: ClearAllPoints()
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetPoint("TOPLEFT", self.Reagent, "TOPLEFT", CONFIG.border+CONFIG.buttonGap+pos_x*(CONFIG.buttonSize+CONFIG.buttonGap*2), -CONFIG.border-CONFIG.buttonGap-pos_y*(CONFIG.buttonSize+CONFIG.buttonGap*2))
		self["Bag"..v.bagID]["Slot"..v.slotID]: SetAlpha(1)
	end
	self.Reagent: SetHeight((CONFIG.buttonSize+CONFIG.buttonGap*2)*ceil(num/CONFIG.reagentperLine)+CONFIG.border*2)
end

local function Insert_BankItem(self)
	wipe(TBANK)
	wipe(TBANK_FREE)
	for _, bag_id in ipairs(Bank_BagID) do
		local BagType = GetBagType(bag_id) or 0
		if not self["Bag"..bag_id] then
			self["Bag"..bag_id] = Create_BankButton(self.BagHold, bag_id)
		end
		if not TBANK[BagType] then
			TBANK[BagType] = {}
		end
		if not TBANK_FREE[BagType] then
			TBANK_FREE[BagType] = {}
		end
		Check_BagNumSlots(self["Bag"..bag_id], bag_id)
		for slot_id = 1, GetContainerNumSlots(bag_id) do
			if not self["Bag"..bag_id]["Slot"..slot_id] then
				self["Bag"..bag_id]["Slot"..slot_id] = Create_ItemButton(self["Bag"..bag_id], bag_id, slot_id)
			end
			local slotInfo = GetContainerItemInfo(bag_id, slot_id)
			if slotInfo.itemID then
				insert(TBANK[BagType], slotInfo)
			else
				insert(TBANK_FREE[BagType], slotInfo)
			end
		end
	end
	NSLOT.BankFree = #TBANK_FREE[0]
	NSLOT.Bank = NSLOT.BankFree + #TBANK[0]
end

local function Insert_ReagentBankItem(self)
	wipe(TREAGENT)
	wipe(TREAGENT_FREE)
	local bag_id = Enum.BagIndex.Reagentbank
	if not self["Bag"..bag_id] then
		self["Bag"..bag_id] = Create_BankButton(self.Reagent, bag_id)
	end
	Check_BagNumSlots(self["Bag"..bag_id], bag_id)
	for slot_id = 1, GetContainerNumSlots(bag_id) do
		if not self["Bag"..bag_id]["Slot"..slot_id] then
			self["Bag"..bag_id]["Slot"..slot_id] = Create_ItemButton(self["Bag"..bag_id], bag_id, slot_id)
		end
		local slotInfo = GetContainerItemInfo(bag_id, slot_id)
		if slotInfo.itemID then
			insert(TREAGENT, slotInfo)
		else
			insert(TREAGENT_FREE, slotInfo)
		end
	end
	NSLOT.ReagentFree= #TREAGENT_FREE
	NSLOT.Reagent  = NSLOT.ReagentFree + #TREAGENT
end

local function FullUpdate_BankItem(self)
	Insert_BankItem(self)
	Sort_BagItem(TBANK)
	Update_BankItem(self)
	Pos_BankItem(self, self.BagHold)
end

local function FullUpdate_ReagentBankItem(self)
	if F.IsRetail then
		Insert_ReagentBankItem(self)
		Sort_ReagentItem(TREAGENT)
		Update_ReagentItem(self)
		Pos_ReagentItem(self, self.Reagent)
	end
end

local function Search_BankItem(frame, ...)
	if (not frame and frame:IsShown()) then return end
	local itemButton
	local ItemInfo
	for _, bagID in ipairs(Bank_BagID) do
		for slotID = 1, ContainerFrame_GetContainerNumSlots(bagID) do
			itemButton = frame["Bag"..bagID]["Slot"..slotID]
			if itemButton then
				ItemInfo = C_Container.GetContainerItemInfo(bagID, slotID)
				if ItemInfo then
					if ItemInfo.isFiltered then
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
	ReagentFrame: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.reagentperLine + CONFIG.border*2, 48)
	ReagentFrame: SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0,-2)
	ReagentFrame.Bg = F.Create.Backdrop(ReagentFrame, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9, aBd = 0.9})

	local RegentUnlockInfo = CreateFrame("Frame", "Quafe_BankReagent.UnlockInfo", ReagentFrame)
	RegentUnlockInfo: SetAllPoints(ReagentFrame)
	RegentUnlockInfo: SetFrameLevel(ReagentFrame:GetFrameLevel()+10)
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
				local hexcolor = F.Hex(C.Color.Config.Exit)
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
--> Bank Frames
--- ------------------------------------------------------------

local function TabButton_OnEnter(self)
	self.Glow: SetAlpha(1)
end

local function TabButton_OnLeave(self)
	self.Glow: SetAlpha(0)
end

local function TabButton_Templplate(self)
	local TabButton = CreateFrame("Button", nil, self)
	TabButton: SetFrameLevel(self:GetFrameLevel()+2)
	--TabButton.Backdrop = F.Create.Backdrop(TabButton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.Config.Exit, aBg = 1, cBd = C.Color.Config.Exit, aBd = 1})
	TabButton.Backdrop = F.Create.Backdrop(TabButton, {wide = 0, edge = 1, inset = 0, cBg = C.Color.W3, aBg = 1, cBd = C.Color.W3, aBd = 1})
	TabButton.Backdrop: SetAlpha(0)

	TabButton.Glow = F.Create.Backdrop(TabButton, {wide = 0, edge = 1, inset = 0, cBg = C.Color.W3, aBg = 0.25, cBd = C.Color.W3, aBd = 0})
	TabButton.Glow: SetAlpha(0)

	local Text = F.Create.Font(TabButton, {layer = "ARTWORK", fontname = C.Font.Txt, fontsize = 13,textcolor = C.Color.W3})
	Text: SetPoint("CENTER")
	TabButton.Text = Text

	local GapLine = F.Create.Texture(TabButton, {layer = "BORDER", texture = F.Path("White"), color = C.Color.W3, alpha = 0.1, size = {2,22},})
	GapLine: SetPoint("RIGHT", TabButton, "LEFT", 0,0)
	TabButton.GapLine = GapLine

	TabButton: SetScript("OnEnter", TabButton_OnEnter)
	TabButton: SetScript("OnLeave", TabButton_OnLeave)

	return TabButton
end

local function Update_TabButton(self)
	for i = 1, self.num_tabs do
		if i == self.active_id then
			self.TabButton[i].Backdrop: SetAlpha(1)
			self.TabButton[i].Text: SetTextColor(F.Color(C.Color.Config.Back))
		else
			self.TabButton[i].Backdrop: SetAlpha(0)
			self.TabButton[i].Text: SetTextColor(F.Color(C.Color.W3))
		end
	end
end

local function TabFrame_Template(self, tab_num, tab_size)
	local TabFrame = CreateFrame("Frame", nil, self)
	TabFrame: SetSize((tab_size+2)*tab_num+4, 30)
	TabFrame.active_id = 1
	TabFrame.num_tabs = tab_num

	TabFrame.Backdrop = F.Create.Backdrop(TabFrame, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.W2, aBg = 0.5, cBd = C.Color.W2, aBd = 0.5})

	local TabButton = {}
	for i = 1, TabFrame.num_tabs do
		TabButton[i] = TabButton_Templplate(TabFrame)
		TabButton[i]: SetSize(tab_size, 26)
		if i == 1 then
			TabButton[i]: SetPoint("LEFT", TabFrame, "LEFT", 2,0)
			TabButton[i].GapLine: Hide()
		else
			--TabButton[i]: SetPoint("LEFT", TabButton[i-1], "RIGHT", 2,0)
			TabButton[i]: SetPoint("LEFT", TabFrame, "LEFT", 2+(2+tab_size)*(i-1),0)
		end
		TabButton[i].ID = i
	end
	TabFrame.TabButton = TabButton
	Update_TabButton(TabFrame)

	return TabFrame
end

local function CloseButton_OnClick(self)
	self:GetParent():GetParent():Hide()
end

local function CloseButton_OnEnter(self)
	self.Bg: SetAlpha(1)
	self.Icon: SetTextColor(F.Color(C.Color.Config.Back))
end

local function CloseButton_OnLeave(self)
	self.Bg: SetAlpha(0)
	self.Icon: SetTextColor(F.Color(C.Color.W3))
end

local function MenuButton_OnClick(self)
	local Bank = self:GetParent():GetParent()
	if Bank.Extra then
		if Bank.Extra: IsShown() then
			Bank.Extra: Hide()
		else
			Bank.Extra: Show()
		end
	end
end

local function MenuButton_OnEnter(self)
	self.Bg: SetAlpha(1)
	self.Icon: SetVertexColor(F.Color(C.Color.Config.Back))
end

local function MenuButton_OnLeave(self)
	self.Bg: SetAlpha(0)
	self.Icon: SetVertexColor(F.Color(C.Color.W3))
end

local function BankTab_OnClick(self)
	local TabFrame = self:GetParent()
	local Bank = self:GetParent():GetParent():GetParent()
	if self.ID == 1 then
		Bank.BagHold: Show()
		Bank.Reagent: Hide()
	elseif self.ID == 2 then
		Bank.BagHold: Hide()
		Bank.Reagent: Show()
	elseif self.ID == 3 then
		Bank.BagHold: Hide()
		Bank.Reagent: Hide()
	end
	TabFrame.active_id = self.ID
	Update_TabButton(TabFrame)
end

local function BankTitle_Frame(self)
	local Title = CreateFrame("Frame", nil, self)
	Title: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.bankperLine+CONFIG.border*2, 44)
	Title: SetPoint("TOP", self, "TOP", 0,0)

	--> Close Button
	local CloseButton = CreateFrame("Button", nil, Title)
	CloseButton: SetSize(24,30)
	CloseButton: SetPoint("RIGHT", Title, "RIGHT", -6,0)
	CloseButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	CloseButton.Bg = F.Create.Backdrop(CloseButton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.Config.Exit, aBg = 1, cBd = C.Color.Config.Exit, aBd = 1})
	CloseButton.Bg: SetAlpha(0)
	
	CloseButton.Icon = F.Create.Font(CloseButton, "ARTWORK", C.Font.NumOW, 24, nil, C.Color.W3, 1, C.Color.W1, 0, {0,0}, "CENTER")
	CloseButton.Icon: SetPoint("CENTER", CloseButton, "CENTER", 0,-3)
	CloseButton.Icon: SetText("X")
	
	CloseButton: SetScript("OnClick", CloseButton_OnClick)
	CloseButton: SetScript("OnEnter", CloseButton_OnEnter)
	CloseButton: SetScript("OnLeave", CloseButton_OnLeave)

	--> Menu Button
	local MenuButton = CreateFrame("Button", nil, Title)
	MenuButton: SetSize(24,30)
	MenuButton: SetPoint("LEFT", Title, "LEFT", 6,0)
	MenuButton.Bg = F.Create.Backdrop(MenuButton, {wide = 0, round = true, edge = 3, inset = 3, cBg = C.Color.Config.Exit, aBg = 1, cBd = C.Color.Config.Exit, aBd = 1})
	MenuButton.Bg: SetAlpha(0)
	
	MenuButton.Icon = F.Create.Texture(MenuButton, "ARTWORK", 1, F.Path("Bag_Menu"), C.Color.W3, 1, {32,32})
	MenuButton.Icon: SetPoint("CENTER", MenuButton, "CENTER", 0,0)
	
	MenuButton: SetScript("OnClick", MenuButton_OnClick)
	MenuButton: SetScript("OnEnter", MenuButton_OnEnter)
	MenuButton: SetScript("OnLeave", MenuButton_OnLeave)

	local BankTab = TabFrame_Template(Title, 3, 90)
	BankTab: SetPoint("LEFT", MenuButton, "RIGHT", 16,0)
	Title.BankTab = BankTab

	local TAB_TEXT = {
		BANK,
		REAGENT_BANK,
		ACCOUNT_BANK_PANEL_TITLE,
	}
	for i = 1, BankTab.num_tabs do
		BankTab.TabButton[i]: SetScript("OnClick", BankTab_OnClick)
		BankTab.TabButton[i].Text: SetText(TAB_TEXT[i])
	end

	self.Title = Title
end

local function BankExtra_Frame(f)
	local bagextra = CreateFrame("Frame", "Quafe_BankExtra", f)
	bagextra: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.bankperLine+CONFIG.border*2, 44)
	bagextra: SetPoint("BOTTOM", f, "TOP", 0,2)
	bagextra.Bg = F.Create.Backdrop(bagextra, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9,aBd = 0.9})
	bagextra: Hide()
	f.Extra = bagextra
	
	local editbox = CreateFrame("EditBox", "Quafe_BankEditBox", bagextra, "BagSearchBoxTemplate")
	editbox: SetSize(120,16)
	editbox: SetPoint("LEFT", bagextra, "LEFT", 35,0)
	editbox: SetAutoFocus(false)
	editbox.Left: Hide()
	editbox.Middle: Hide()
	editbox.Right: Hide()
	F.create_Backdrop(editbox, 6, 8, 6, C.Color.W2,0, C.Color.W4,0.9)
	
	local ToggleButton = ExtraButton_Create(bagextra)
	ToggleButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	ToggleButton.Icon: SetTexture(F.Path("Bag_Button1"))

	local DepositButton = ExtraButton_Create(bagextra)
	DepositButton: SetPoint("LEFT", ToggleButton, "RIGHT", 4, 0)
	DepositButton.Icon: SetTexture(F.Path("Bag_Button2"))

	if F.IsRetail then
		ToggleButton.tooltipText = REAGENT_BANK
		ToggleButton: SetScript("OnClick", function(self)
			--PlaySound(852)
			PlaySoundFile(F.Path("Sound\\Show.ogg"), "Master")
			if f.BagHold:IsShown() then
				f.BagHold: Hide()
				f.Reagent: Show()
				self.tooltipText = BANK
			else
				f.BagHold: Show()
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
	local PurchaseButton = ExtraButton_Create(bagextra)
	if F.IsClassic then
		PurchaseButton: SetPoint("LEFT", editbox, "RIGHT", 16, 0)
	else
		PurchaseButton: SetPoint("LEFT", DepositButton, "RIGHT", 4, 0)
	end
	PurchaseButton.Icon: SetTexture(F.Path("Bag_Button3"))
	PurchaseButton.tooltipText = BANKSLOTPURCHASE_LABEL
	
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
	--StaticPopup_Show("CONFIRM_BUY_BANK_SLOT");
	--StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
	
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
			button: SetPoint("RIGHT", bagextra, "RIGHT", -42-30*6,0)
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

		button.Border = F.Create.Backdrop(button, {border = true, wide = 0, edge = 1, inset = 0, cBg = C.Color.W1, aBg = 0, cBd = C.Color.W4, aBd = 0.9})

		if button.IconBorder then
			--button.IconBorder: SetTexture("")
			--button.IconBorder: Hide()
			button.IconBorder: SetAlpha(0)
		end

		
		button: RegisterForDrag("LeftButton", "RightButton")
		--button: RegisterForClicks("anyUp")
		
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
	self:RegisterEvent("BAG_UPDATE");
	self:RegisterEvent("BAG_UPDATE_DELAYED")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN");
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE");

	FullUpdate_BankItem(self)
	FullUpdate_ReagentBankItem(self)

	for i=1, NUM_BANKGENERIC_SLOTS, 1 do

	end
end

local function BankFrame_OnHide(self)
	self:UnregisterEvent("ITEM_LOCK_CHANGED");
	self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED");
	self:UnregisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
	self:UnregisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	self:UnregisterEvent("PLAYER_MONEY");
	self:UnregisterEvent("BAG_UPDATE");
	self:UnregisterEvent("BAG_UPDATE_DELAYED")
	self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
	self:UnregisterEvent("INVENTORY_SEARCH_UPDATE");

	StaticPopup_Hide("CONFIRM_BUY_BANK_SLOT")
	--CloseBankFrame()
	C_Bank.CloseBankFrame()
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

local function BankFrame_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:Hide()
		self.BagHold:Show()
		if not F.IsClassic then
			self.Reagent:Hide()
		end
		BankFrame:UnregisterAllEvents()
		--Quafe_UpdateAfter()
	elseif event == "PLAYER_ENTERING_WORLD" then
		FullUpdate_BankItem(self)
		FullUpdate_ReagentBankItem(self)
	elseif event == "BANKFRAME_OPENED" then
		self: Show()
		self.BagHold:Show()
		self.Title.BankTab.active_id = 1
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
			FullUpdate_ReagentBankItem(self)
		end
	elseif event == "ITEM_LOCK_CHANGED" then
		Update_ItemLock(self, ...)
	elseif event == "BAG_UPDATE_COOLDOWN" then
		Update_ItemCooldown(self, ...)
	elseif event == "INVENTORY_SEARCH_UPDATE" then
		Search_BankItem(self, ...)
	end
end

local function BankFrame_OnDragStart(self)
	self:StartMoving()
end

local function BankFrame_OnDragStop(self)
	UpdatePostion(self, Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Pos)
end


local function Bank_Frame(self)
	local bank = CreateFrame("Frame", "Quafe_BankFrame", UIParent)
	bank: SetFrameStrata("HIGH")
	bank: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.bankperLine + CONFIG.border*2, 44)
	--bank: SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20,-200)
	bank: SetPoint("LEFT", UIParent, "LEFT", 20,0)
	bank.Bg = F.Create.Backdrop(bank, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9, aBd = 0.9})
	
	bank: SetClampedToScreen(true)
	bank: SetMovable(true)
	bank: EnableMouse(true)
	bank: RegisterForDrag("LeftButton","RightButton")
	bank: SetScript("OnDragStart", BankFrame_OnDragStart)
	bank: SetScript("OnDragStop", BankFrame_OnDragStop)
	
	BankTitle_Frame(bank)
	BankExtra_Frame(bank)
	if F.IsRetail then
		Reagent_Frame(bank)
		--AccountBank_Frame(bank)
	end
	
	local BagHold = CreateFrame("Frame", nil, bank)
	BagHold: SetFrameLevel(bank:GetFrameLevel())
	BagHold: SetSize((CONFIG.buttonSize+CONFIG.buttonGap*2)*CONFIG.bankperLine+CONFIG.border*2, CONFIG.buttonSize+CONFIG.border*2)
	BagHold: SetPoint("TOP", bank, "BOTTOM", 0,-2)
	BagHold.Bg = F.Create.Backdrop(BagHold, {wide = 0, round = true, edge = 4, inset = 4, aBg = 0.9, aBd = 0.9})
	bank.BagHold = BagHold
	
	ItemClass_Init()
	BagGap_Init(bank, ITEMCLASS, bank.BagHold, true)
	--Init_BankItemClass()
	--BagGap_Init(bank, BANKITEMCLASS, bank.BagHold, true)
	--Insert_BankItem(bank)

	bank: RegisterEvent("BANKFRAME_OPENED")
	bank: RegisterEvent("BANKFRAME_CLOSED")
	bank: RegisterEvent("PLAYER_LOGIN")
	--bank: RegisterEvent("PLAYER_ENTERING_WORLD")
	--bank: RegisterEvent("BAG_UPDATE")
	--bank: RegisterEvent("BAG_UPDATE_DELAYED")
	--bank: RegisterEvent("BAG_NEW_ITEMS_UPDATED") --不考虑新物品
	--bank: RegisterEvent("ITEM_LOCK_CHANGED")
	--bank: RegisterEvent("BAG_UPDATE_COOLDOWN")
	--bank: RegisterEvent("INVENTORY_SEARCH_UPDATE")
	bank: SetScript("OnEvent", BankFrame_OnEvent)
	bank: SetScript("OnShow", BankFrame_OnShow)
	bank: SetScript("OnHide", BankFrame_OnHide)

	self.Bank = bank
end

local Quafe_Bank = CreateFrame("Frame", "Quafe_Bank", E)
Quafe_Bank: SetFrameStrata("HIGH")
Quafe_Bank: SetSize(8,8)
Quafe_Bank.Init = false

local function Quafe_Bank_Load()
	if F.Avoid_Clash == 1 then
		Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable = false
		--return
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable then
		Bank_Frame(Quafe_Container)
		Quafe_Bank: ClearAllPoints()
		Quafe_Bank: SetPoint(unpack(Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Pos))
		
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Bank.Scale then
			Quafe_Bank: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Bank.Scale)
		end

		Quafe_Bank.Init = true
	end
end

local function Quafe_Bank_Toggle(arg1,arg2)
	if arg1 == "ON" then
		Quafe_NoticeReload()
	elseif arg1 == "OFF" then
		Quafe_NoticeReload()
	elseif arg1 == "SCALE" then
		Quafe_Bank: SetScale(arg2)
	end
end

local Quafe_Bank_Config = {
	Database = {
		["Quafe_Bank"] = {
			Enable = true,
			Scale = 1,
			Pos = {"LEFT", nil, "LEFT", 20,0},
		},
	},

	Config = {
		Name = "Quafe "..BANK,
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable = false
				self.Text:SetText(L["OFF"])
				Quafe_Bank_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable = true
				self.Text:SetText(L["ON"])
				Quafe_Bank_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["Quafe_Bank"].Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
                Name = L['SCALE'],
                Type = "Slider",
                State = "ALL",
				Click = nil,
                Load = function(self)
                    self.Slider: SetMinMaxValues(0.5, 2)
					self.Slider: SetValueStep(0.05)
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Bank.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
                        Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Bank.Scale = value
						Quafe_Bank_Toggle("SCALE", value)
					end)
                end,
                Show = nil,
            },
		},
	},
}

Quafe_Bank.Load = Quafe_Bank_Load
Quafe_Bank.Config = Quafe_Bank_Config
insert(E.Module, Quafe_Bank)