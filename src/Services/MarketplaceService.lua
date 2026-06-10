-- MarketplaceService.lua
-- Manages marketplace listings and purchases

local MarketplaceService = {}
local InventoryService = require(script.Parent.InventoryService)
local EconomyService = require(script.Parent.EconomyService)
local ItemService = require(script.Parent.ItemService)

-- Active listings: {listing_id -> {seller_id, item_instance_id, price, created_at}}
local active_listings = {}
local listing_counter = 0

-- Create a new listing
function MarketplaceService:CreateListing(seller_id, item_instance_id, price)
	local Constants = require(script.Parent.Parent.Data.Constants)
	
	-- Validate price
	if price < Constants.MIN_ITEM_PRICE or price > Constants.MAX_ITEM_PRICE then
		return nil
	end
	
	-- Verify seller owns item
	if not InventoryService:OwnsItem(seller_id, item_instance_id) then
		return nil
	end
	
	listing_counter = listing_counter + 1
	local listing_id = "listing_" .. listing_counter
	
	active_listings[listing_id] = {
		seller_id = seller_id,
		item_instance_id = item_instance_id,
		price = price,
		created_at = os.time(),
	}
	
	return listing_id
end

-- Get listing details
function MarketplaceService:GetListing(listing_id)
	return active_listings[listing_id]
end

-- Get all active listings
function MarketplaceService:GetAllListings()
	local listings = {}
	for listing_id, listing in pairs(active_listings) do
		table.insert(listings, {
			id = listing_id,
			seller_id = listing.seller_id,
			item_instance_id = listing.item_instance_id,
			price = listing.price,
			created_at = listing.created_at,
		})
	end
	return listings
end

-- Get listings by seller
function MarketplaceService:GetSellerListings(seller_id)
	local listings = {}
	for listing_id, listing in pairs(active_listings) do
		if listing.seller_id == seller_id then
			table.insert(listings, {
				id = listing_id,
				seller_id = listing.seller_id,
				item_instance_id = listing.item_instance_id,
				price = listing.price,
				created_at = listing.created_at,
			})
		end
	end
	return listings
end

-- Purchase item from marketplace
function MarketplaceService:PurchaseItem(buyer_id, listing_id)
	local listing = self:GetListing(listing_id)
	if not listing then
		return false
	end
	
	-- Check buyer has enough coins
	if EconomyService:GetBalance(buyer_id) < listing.price then
		return false
	end
	
	-- Calculate seller payout (after tax)
	local seller_payout = EconomyService:CalculateSellPrice(listing.price)
	
	-- Remove item from seller's inventory
	if not InventoryService:RemoveItemFromInventory(listing.seller_id, listing.item_instance_id) then
		return false
	end
	
	-- Add item to buyer's inventory
	local new_item = InventoryService:AddItemToInventory(buyer_id, "item_placeholder")
	if not new_item then
		-- Revert if something goes wrong
		InventoryService:AddItemToInventory(listing.seller_id, "item_placeholder")
		return false
	end
	
	-- Transfer coins
	EconomyService:RemoveCoins(buyer_id, listing.price)
	EconomyService:AddCoins(listing.seller_id, seller_payout)
	
	-- Remove listing
	active_listings[listing_id] = nil
	
	return true
end

-- Cancel listing
function MarketplaceService:CancelListing(seller_id, listing_id)
	local listing = self:GetListing(listing_id)
	if not listing or listing.seller_id ~= seller_id then
		return false
	end
	
	active_listings[listing_id] = nil
	return true
end

return MarketplaceService
