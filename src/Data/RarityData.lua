-- RarityData.lua
-- Defines rarity system and color coding

local RarityData = {}

-- Rarity hierarchy (lower index = more common)
RarityData.RARITY_ORDER = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
}

-- Rarity properties
RarityData.RARITY_PROPERTIES = {
	Common = {
		display_name = "Common",
		drop_weight = 50,
		base_value = 10,
		color = Color3.fromRGB(200, 200, 200),
	},
	Uncommon = {
		display_name = "Uncommon",
		drop_weight = 30,
		base_value = 25,
		color = Color3.fromRGB(0, 200, 0),
	},
	Rare = {
		display_name = "Rare",
		drop_weight = 12,
		base_value = 75,
		color = Color3.fromRGB(0, 100, 255),
	},
	Epic = {
		display_name = "Epic",
		drop_weight = 5,
		base_value = 200,
		color = Color3.fromRGB(160, 32, 240),
	},
	Legendary = {
		display_name = "Legendary",
		drop_weight = 2,
		base_value = 500,
		color = Color3.fromRGB(255, 215, 0),
	},
	Mythic = {
		display_name = "Mythic",
		drop_weight = 1,
		base_value = 1500,
		color = Color3.fromRGB(255, 0, 0),
	},
}

function RarityData:GetRarityColor(rarity)
	local properties = self.RARITY_PROPERTIES[rarity]
	return properties and properties.color or Color3.fromRGB(128, 128, 128)
end

function RarityData:GetRarityWeight(rarity)
	local properties = self.RARITY_PROPERTIES[rarity]
	return properties and properties.drop_weight or 0
end

function RarityData:GetBaseValue(rarity)
	local properties = self.RARITY_PROPERTIES[rarity]
	return properties and properties.base_value or 0
end

return RarityData
