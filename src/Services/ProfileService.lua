-- ProfileService.lua
-- Manages player profiles and collection data

local ProfileService = {}
local InventoryService = require(script.Parent.InventoryService)
local EconomyService = require(script.Parent.EconomyService)
local ItemService = require(script.Parent.ItemService)

-- Player profiles: {player_id -> {username, collection_score, trades_completed, sales_completed, favorite_item}}
local player_profiles = {}

-- Initialize player profile
function ProfileService:InitializeProfile(player_id, username)
	if not player_profiles[player_id] then
		player_profiles[player_id] = {
			username = username,
			collection_score = 0,
			trades_completed = 0,
			sales_completed = 0,
			favorite_item = nil,
			created_at = os.time(),
		}
	end
	return player_profiles[player_id]
end

-- Get player profile
function ProfileService:GetProfile(player_id)
	local profile = player_profiles[player_id]
	if not profile then
		return ProfileService:InitializeProfile(player_id, "Unknown")
	end
	return profile
end

-- Update collection score
function ProfileService:UpdateCollectionScore(player_id)
	local profile = self:GetProfile(player_id)
	local inventory = InventoryService:GetInventory(player_id)
	local score = 0
	
	-- Calculate score based on unique items and rarity
	local unique_items = {}
	for _, item in ipairs(inventory.items) do
		local item_data = ItemService:GetItemDetails(item.item_id)
		if item_data and not unique_items[item.item_id] then
			unique_items[item.item_id] = true
			-- Award points based on rarity (simplified)
			if item_data.rarity == "Common" then
				score = score + 1
			elseif item_data.rarity == "Uncommon" then
				score = score + 2
			elseif item_data.rarity == "Rare" then
				score = score + 5
			elseif item_data.rarity == "Epic" then
				score = score + 10
			elseif item_data.rarity == "Legendary" then
				score = score + 25
			elseif item_data.rarity == "Mythic" then
				score = score + 50
			end
		end
	end
	
	profile.collection_score = score
end

-- Set favorite item
function ProfileService:SetFavoriteItem(player_id, item_instance_id)
	local profile = self:GetProfile(player_id)
	if InventoryService:OwnsItem(player_id, item_instance_id) then
		profile.favorite_item = item_instance_id
		return true
	end
	return false
end

-- Increment trades completed
function ProfileService:IncrementTradesCompleted(player_id)
	local profile = self:GetProfile(player_id)
	profile.trades_completed = profile.trades_completed + 1
end

-- Increment sales completed
function ProfileService:IncrementSalesCompleted(player_id)
	local profile = self:GetProfile(player_id)
	profile.sales_completed = profile.sales_completed + 1
end

-- Get collection profile data for display
function ProfileService:GetCollectionProfile(player_id)
	local profile = self:GetProfile(player_id)
	local inventory = InventoryService:GetInventory(player_id)
	local balance = EconomyService:GetBalance(player_id)
	
	self:UpdateCollectionScore(player_id)
	
	return {
		username = profile.username,
		collection_score = profile.collection_score,
		items_owned = #inventory.items,
		currency = balance,
		trades_completed = profile.trades_completed,
		sales_completed = profile.sales_completed,
		favorite_item = profile.favorite_item,
	}
end

return ProfileService
