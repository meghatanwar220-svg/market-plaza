-- ValidationUtils.lua
-- Utility functions for validation

local ValidationUtils = {}

-- Validate player ID
function ValidationUtils:ValidatePlayerID(player_id)
	return type(player_id) == "number" and player_id > 0
end

-- Validate amount (currency)
function ValidationUtils:ValidateAmount(amount)
	return type(amount) == "number" and amount > 0 and amount == math.floor(amount)
end

-- Validate price
function ValidationUtils:ValidatePrice(price)
	local Constants = require(script.Parent.Parent.Data.Constants)
	return self:ValidateAmount(price) and price >= Constants.MIN_ITEM_PRICE and price <= Constants.MAX_ITEM_PRICE
end

-- Validate username
function ValidationUtils:ValidateUsername(username)
	if type(username) ~= "string" then return false end
	local length = #username
	return length > 0 and length <= 32
end

-- Validate item ID
function ValidationUtils:ValidateItemID(item_id)
	return type(item_id) == "string" and #item_id > 0
end

return ValidationUtils
