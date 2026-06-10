-- ItemData.lua
-- Database of all available items in the game

local ItemData = {}

-- Item catalog
ItemData.ITEMS = {
	-- Common Items
	{
		id = "item_001",
		name = "Blue Trail",
		description = "A simple blue trail effect",
		type = "Trail",
		rarity = "Common",
		base_value = 10,
	},
	{
		id = "item_002",
		name = "Basic Title",
		description = "Standard player title",
		type = "Title",
		rarity = "Common",
		base_value = 15,
	},
	{
		id = "item_003",
		name = "Wave Emote",
		description = "Friendly wave gesture",
		type = "Emote",
		rarity = "Common",
		base_value = 20,
	},
	
	-- Uncommon Items
	{
		id = "item_101",
		name = "Gold Trail",
		description = "Shimmering gold trail effect",
		type = "Trail",
		rarity = "Uncommon",
		base_value = 40,
	},
	{
		id = "item_102",
		name = "Diamond Skin",
		description = "Diamond-patterned booth skin",
		type = "BoothSkin",
		rarity = "Uncommon",
		base_value = 50,
	},
	{
		id = "item_103",
		name = "Cat Pet",
		description = "Adorable cat companion",
		type = "Pet",
		rarity = "Uncommon",
		base_value = 60,
	},
	
	-- Rare Items
	{
		id = "item_201",
		name = "Rainbow Trail",
		description = "Multicolor shifting trail",
		type = "Trail",
		rarity = "Rare",
		base_value = 150,
	},
	{
		id = "item_202",
		name = "Dragon Pet",
		description = "Legendary dragon companion",
		type = "Pet",
		rarity = "Rare",
		base_value = 200,
	},
	{
		id = "item_203",
		name = "Royal Title",
		description = "Crown-adorned player title",
		type = "Title",
		rarity = "Rare",
		base_value = 175,
	},
	
	-- Epic Items
	{
		id = "item_301",
		name = "Cosmic Trail",
		description = "Space-themed particle trail",
		type = "Trail",
		rarity = "Epic",
		base_value = 400,
	},
	{
		id = "item_302",
		name = "Phoenix Pet",
		description = "Mythical phoenix with fire aura",
		type = "Pet",
		rarity = "Epic",
		base_value = 500,
	},
	
	-- Legendary Items
	{
		id = "item_401",
		name = "Infinity Trail",
		description = "Infinite energy trail effect",
		type = "Trail",
		rarity = "Legendary",
		base_value = 1000,
	},
	{
		id = "item_402",
		name = "Golden Throne Skin",
		description = "Luxurious golden booth stall",
		type = "BoothSkin",
		rarity = "Legendary",
		base_value = 1200,
	},
	
	-- Mythic Items
	{
		id = "item_501",
		name = "Eternal Void Trail",
		description = "Reality-bending trail of darkness",
		type = "Trail",
		rarity = "Mythic",
		base_value = 3000,
	},
	{
		id = "item_502",
		name = "Supreme Crown Title",
		description = "The rarest title in existence",
		type = "Title",
		rarity = "Mythic",
		base_value = 2500,
	},
}

function ItemData:GetItemByID(item_id)
	for _, item in ipairs(self.ITEMS) do
		if item.id == item_id then
			return item
		end
	end
	return nil
end

function ItemData:GetItemsByRarity(rarity)
	local items = {}
	for _, item in ipairs(self.ITEMS) do
		if item.rarity == rarity then
			table.insert(items, item)
		end
	end
	return items
end

function ItemData:GetItemsByType(item_type)
	local items = {}
	for _, item in ipairs(self.ITEMS) do
		if item.type == item_type then
			table.insert(items, item)
		end
	end
	return items
end

return ItemData
