-- TradingService.lua
-- Handles player-to-player trading

local TradingService = {}
local InventoryService = require(script.Parent.InventoryService)
local EconomyService = require(script.Parent.EconomyService)

-- Active trades: {trade_id -> {initiator_id, responder_id, status, items_offered, coins_offered, accepted_by}}
local active_trades = {}
local trade_counter = 0

-- Create new trade request
function TradingService:CreateTradeRequest(initiator_id, responder_id)
	local Constants = require(script.Parent.Parent.Data.Constants)
	
	trade_counter = trade_counter + 1
	local trade_id = "trade_" .. trade_counter
	
	active_trades[trade_id] = {
		initiator_id = initiator_id,
		responder_id = responder_id,
		status = "pending",
		initiator_items = {},
		initiator_coins = 0,
		responder_items = {},
		responder_coins = 0,
		accepted_by = {},
		created_at = os.time(),
	}
	
	return trade_id
end

-- Get trade details
function TradingService:GetTrade(trade_id)
	return active_trades[trade_id]
end

-- Add item to trade offer (by trading participant)
function TradingService:AddItemToTrade(trade_id, player_id, item_instance_id)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	-- Verify player owns item
	if not InventoryService:OwnsItem(player_id, item_instance_id) then
		return false
	end
	
	local Constants = require(script.Parent.Parent.Data.Constants)
	
	if player_id == trade.initiator_id then
		if #trade.initiator_items >= Constants.MAX_TRADE_ITEMS then
			return false
		end
		table.insert(trade.initiator_items, item_instance_id)
	elseif player_id == trade.responder_id then
		if #trade.responder_items >= Constants.MAX_TRADE_ITEMS then
			return false
		end
		table.insert(trade.responder_items, item_instance_id)
	else
		return false
	end
	
	trade.accepted_by = {} -- Reset acceptance
	return true
end

-- Remove item from trade offer
function TradingService:RemoveItemFromTrade(trade_id, player_id, item_instance_id)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	if player_id == trade.initiator_id then
		for i, item_id in ipairs(trade.initiator_items) do
			if item_id == item_instance_id then
				table.remove(trade.initiator_items, i)
				return true
			end
		end
	elseif player_id == trade.responder_id then
		for i, item_id in ipairs(trade.responder_items) do
			if item_id == item_instance_id then
				table.remove(trade.responder_items, i)
				return true
			end
		end
	end
	
	return false
end

-- Add coins to trade offer
function TradingService:AddCoinsToTrade(trade_id, player_id, amount)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	-- Verify player has enough coins
	if EconomyService:GetBalance(player_id) < amount then
		return false
	end
	
	if player_id == trade.initiator_id then
		trade.initiator_coins = amount
	elseif player_id == trade.responder_id then
		trade.responder_coins = amount
	else
		return false
	end
	
	trade.accepted_by = {} -- Reset acceptance
	return true
end

-- Accept trade
function TradingService:AcceptTrade(trade_id, player_id)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	if player_id ~= trade.initiator_id and player_id ~= trade.responder_id then
		return false
	end
	
	table.insert(trade.accepted_by, player_id)
	
	-- Check if both players accepted
	if #trade.accepted_by == 2 then
		return self:CompleteTrade(trade_id)
	end
	
	return true
end

-- Complete trade (execute transaction)
function TradingService:CompleteTrade(trade_id)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	-- Verify ownership one more time (server-side validation)
	for _, item_id in ipairs(trade.initiator_items) do
		if not InventoryService:OwnsItem(trade.initiator_id, item_id) then
			return false
		end
	end
	
	for _, item_id in ipairs(trade.responder_items) do
		if not InventoryService:OwnsItem(trade.responder_id, item_id) then
			return false
		end
	end
	
	-- Transfer items from initiator to responder
	for _, item_id in ipairs(trade.initiator_items) do
		InventoryService:RemoveItemFromInventory(trade.initiator_id, item_id)
		-- Mark as transferred (in a real implementation, update ownership)
	end
	
	-- Transfer items from responder to initiator
	for _, item_id in ipairs(trade.responder_items) do
		InventoryService:RemoveItemFromInventory(trade.responder_id, item_id)
		-- Mark as transferred
	end
	
	-- Transfer coins
	if trade.initiator_coins > 0 then
		EconomyService:RemoveCoins(trade.initiator_id, trade.initiator_coins)
		EconomyService:AddCoins(trade.responder_id, trade.initiator_coins)
	end
	
	if trade.responder_coins > 0 then
		EconomyService:RemoveCoins(trade.responder_id, trade.responder_coins)
		EconomyService:AddCoins(trade.initiator_id, trade.responder_coins)
	end
	
	trade.status = "completed"
	
	return true
end

-- Decline trade
function TradingService:DeclineTrade(trade_id, player_id)
	local trade = self:GetTrade(trade_id)
	if not trade then return false end
	
	if player_id ~= trade.initiator_id and player_id ~= trade.responder_id then
		return false
	end
	
	trade.status = "declined"
	return true
end

return TradingService
