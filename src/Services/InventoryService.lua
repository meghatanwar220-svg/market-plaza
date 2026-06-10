-- InventoryService.lua
-- Handles player inventories and item ownership

local InventoryService = {}
local ItemService = require(script.Parent.ItemService)

-- Player inventory cache: {player_id -> {item_instances}}
local player_inventories = {}

-- Initialize a new player inventory
function InventoryService:InitializeInventory(player_id)
	if not player_inventories[player_id] then
		player_inventories[player_id] = {
			items = {},
			last_updated = os.time(),
		}
	end
	return player_inventories[player_id]
end

-- Add item to inventory
function InventoryService:AddItemToInventory(player_id, item_id)
	local inventory = self:InitializeInventory(player_id)
	local item_instance = ItemService:CreateItemInstance(player_id, item_id)
	
	if item_instance then
		table.insert(inventory.items, item_instance)
		inventory.last_updated = os.time()
		return item_instance
	end
	
	return nil
end

-- Remove item from inventory
function InventoryService:RemoveItemFromInventory(player_id, instance_id)
	local inventory = player_inventories[player_id]
	if not inventory then return false end
	
	for i, item in ipairs(inventory.items) do
		if item.instance_id == instance_id then
			table.remove(inventory.items, i)
			inventory.last_updated = os.time()
			return true
		end
	end
	
	return false
end

-- Get entire inventory
function InventoryService:GetInventory(player_id)
	local inventory = player_inventories[player_id]
	if not inventory then
		return self:InitializeInventory(player_id)
	end
	return inventory
end

-- Get item count in inventory
function InventoryService:GetItemCount(player_id)
	local inventory = self:GetInventory(player_id)
	return #inventory.items
end

-- Check if player owns specific item instance
function InventoryService:OwnsItem(player_id, instance_id)
	local inventory = self:GetInventory(player_id)
	
	for _, item in ipairs(inventory.items) do
		if item.instance_id == instance_id then
			return true
		end
	end
	
	return false
end

-- Get item by instance ID from a player's inventory
function InventoryService:GetItemByInstanceID(player_id, instance_id)
	local inventory = self:GetInventory(player_id)
	
	for _, item in ipairs(inventory.items) do
		if item.instance_id == instance_id then
			return item
		end
	end
	
	return nil
end

return InventoryService
