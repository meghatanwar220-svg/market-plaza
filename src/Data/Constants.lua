-- Constants.lua
-- Central configuration for Market Plaza

local Constants = {}

-- Rarities
Constants.RARITIES = {
	COMMON = {
		name = "Common",
		value_multiplier = 1,
		color = Color3.fromRGB(200, 200, 200),
		collection_points = 1,
	},
	UNCOMMON = {
		name = "Uncommon",
		value_multiplier = 1.5,
		color = Color3.fromRGB(0, 200, 0),
		collection_points = 2,
	},
	RARE = {
		name = "Rare",
		value_multiplier = 2.5,
		color = Color3.fromRGB(0, 100, 255),
		collection_points = 5,
	},
	EPIC = {
		name = "Epic",
		value_multiplier = 4,
		color = Color3.fromRGB(160, 32, 240),
		collection_points = 10,
	},
	LEGENDARY = {
		name = "Legendary",
		value_multiplier = 7,
		color = Color3.fromRGB(255, 215, 0),
		collection_points = 25,
	},
	MYTHIC = {
		name = "Mythic",
		value_multiplier = 15,
		color = Color3.fromRGB(255, 0, 0),
		collection_points = 50,
	},
}

-- Item Types
Constants.ITEM_TYPES = {
	"BoothSkin",
	"Trail",
	"Title",
	"NameEffect",
	"Pet",
	"Emote",
	"Crate",
	"Collectible",
	"SeasonalItem",
}

-- Economy
Constants.STARTING_COINS = 500
Constants.DAILY_REWARD = 100
Constants.SELL_TAX_PERCENTAGE = 0.05 -- 5% tax on sales
Constants.TRANSACTION_FEE_PERCENTAGE = 0.03 -- 3% fee on trades

-- Stall
Constants.STALL_CLAIM_COST = 0 -- Free to claim
Constants.MAX_STALL_ITEMS = 50

-- Trading
Constants.TRADE_TIMEOUT = 60 -- seconds
Constants.MAX_TRADE_ITEMS = 10

-- Collection
Constants.MAX_COLLECTION_ITEMS = 500

-- Limits
Constants.MAX_ITEM_PRICE = 999999
Constants.MIN_ITEM_PRICE = 1

return Constants
