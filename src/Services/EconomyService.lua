-- EconomyService.lua
-- Manages player currency and economy

local EconomyService = {}
local Constants = require(script.Parent.Parent.Data.Constants)

-- Player balance cache: {player_id -> coins}
local player_balances = {}

-- Initialize player balance
function EconomyService:InitializeBalance(player_id)
	if not player_balances[player_id] then
		player_balances[player_id] = Constants.STARTING_COINS
	end
	return player_balances[player_id]
end

-- Get player balance
function EconomyService:GetBalance(player_id)
	return player_balances[player_id] or self:InitializeBalance(player_id)
end

-- Add coins to player
function EconomyService:AddCoins(player_id, amount)
	local current = self:GetBalance(player_id)
	player_balances[player_id] = current + amount
	return player_balances[player_id]
end

-- Remove coins from player
function EconomyService:RemoveCoins(player_id, amount)
	local current = self:GetBalance(player_id)
	if current < amount then
		return nil -- Insufficient funds
	end
	
	player_balances[player_id] = current - amount
	return player_balances[player_id]
end

-- Transfer coins between players (with tax)
function EconomyService:TransferCoins(from_player_id, to_player_id, amount)
	local from_balance = self:GetBalance(from_player_id)
	
	if from_balance < amount then
		return false -- Insufficient funds
	end
	
	local tax = math.floor(amount * Constants.TRANSACTION_FEE_PERCENTAGE)
	local net_amount = amount - tax
	
	self:RemoveCoins(from_player_id, amount)
	self:AddCoins(to_player_id, net_amount)
	
	return true
end

-- Give daily reward
function EconomyService:GiveDailyReward(player_id)
	self:AddCoins(player_id, Constants.DAILY_REWARD)
end

-- Calculate sell price with tax
function EconomyService:CalculateSellPrice(base_price)
	local tax = math.floor(base_price * Constants.SELL_TAX_PERCENTAGE)
	return base_price - tax
end

return EconomyService
