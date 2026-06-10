-- ItemService.lua
-- Manages item data and item creation

local ItemService = {}
local ItemData = require(script.Parent.Parent.Data.ItemData)
local RarityData = require(script.Parent.Parent.Data.RarityData)

-- Create a new item instance for a player
function ItemService:CreateItemInstance(player_id, item_id)
	if not ItemData:GetItemByID(item_id) then
		return nil
	end
	
	return {
		instance_id = game:GetService("HttpService"):GenerateGUID(false),
		item_id = item_id,
		owner_id = player_id,
		created_at = os.time(),
		trade_history = {},
	}
end

-- Get item details
function ItemService:GetItemDetails(item_id)
	return ItemData:GetItemByID(item_id)
end

-- Get item rarity color
function ItemService:GetRarityColor(rarity)
	return RarityData:GetRarityColor(rarity)
end

-- Calculate item value based on rarity and base value
function ItemService:CalculateItemValue(item_id)
	local item = ItemData:GetItemByID(item_id)
	if not item then return 0 end
	
	return item.base_value
end

-- Validate if item exists
function ItemService:ItemExists(item_id)
	return ItemData:GetItemByID(item_id) ~= nil
end

-- Get all items by type
function ItemService:GetItemsByType(item_type)
	return ItemData:GetItemsByType(item_type)
end

-- Get all items by rarity
function ItemService:GetItemsByRarity(rarity)
	return ItemData:GetItemsByRarity(rarity)
end

return ItemService
