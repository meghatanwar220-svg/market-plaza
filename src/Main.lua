-- Main.lua
-- Entry point for Market Plaza server

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Load Services
local ItemService = require(script.Parent.Services.ItemService)
local InventoryService = require(script.Parent.Services.InventoryService)
local EconomyService = require(script.Parent.Services.EconomyService)
local MarketplaceService = require(script.Parent.Services.MarketplaceService)
local TradingService = require(script.Parent.Services.TradingService)
local ProfileService = require(script.Parent.Services.ProfileService)

-- Load Data
local StartupItems = require(script.Parent.Data.StartupItems)
local ItemData = require(script.Parent.Data.ItemData)

-- Load Utils
local ValidationUtils = require(script.Parent.Utils.ValidationUtils)

local GameManager = {}

-- Initialize a new player
function GameManager:PlayerJoined(player)
	print("[Market Plaza] Player joined: " .. player.Name)
	
	-- Initialize player systems
	local player_id = player.UserId
	
	-- Create profile
	ProfileService:InitializeProfile(player_id, player.Name)
	
	-- Initialize inventory and economy
	InventoryService:InitializeInventory(player_id)
	EconomyService:InitializeBalance(player_id)
	
	-- Give starter items
	for _, item_id in ipairs(StartupItems.STARTER_ITEMS) do
		InventoryService:AddItemToInventory(player_id, item_id)
	end
	
	-- Update collection score
	ProfileService:UpdateCollectionScore(player_id)
	
	print("[Market Plaza] Initialized player: " .. player.Name)
end

-- Handle player leaving
function GameManager:PlayerLeft(player)
	print("[Market Plaza] Player left: " .. player.Name)
	-- TODO: Save player data to DataStore
end

-- Test functions for development
function GameManager:TestCreateListing()
	print("\n=== TESTING MARKETPLACE ===")
	
	local test_player_id = 123456
	
	-- Setup
	InventoryService:InitializeInventory(test_player_id)
	EconomyService:InitializeBalance(test_player_id)
	InventoryService:AddItemToInventory(test_player_id, "item_001")
	
	-- Get item and create listing
	local inventory = InventoryService:GetInventory(test_player_id)
	print("Inventory items: " .. #inventory.items)
	
	if #inventory.items > 0 then
		local item = inventory.items[1]
		local listing_id = MarketplaceService:CreateListing(test_player_id, item.instance_id, 100)
		if listing_id then
			print("Created listing: " .. listing_id)
			local listing = MarketplaceService:GetListing(listing_id)
			print("Listing price: " .. listing.price)
		else
			print("Failed to create listing")
		end
	end
end

function GameManager:TestTrading()
	print("\n=== TESTING TRADING ===")
	
	local player1_id = 111111
	local player2_id = 222222
	
	-- Setup
	InventoryService:InitializeInventory(player1_id)
	InventoryService:InitializeInventory(player2_id)
	EconomyService:InitializeBalance(player1_id)
	EconomyService:InitializeBalance(player2_id)
	
	InventoryService:AddItemToInventory(player1_id, "item_001")
	InventoryService:AddItemToInventory(player2_id, "item_101")
	
	-- Create trade
	local trade_id = TradingService:CreateTradeRequest(player1_id, player2_id)
	print("Created trade: " .. trade_id)
	
	-- Add items
	local inv1 = InventoryService:GetInventory(player1_id)
	local inv2 = InventoryService:GetInventory(player2_id)
	
	if #inv1.items > 0 and #inv2.items > 0 then
		local added1 = TradingService:AddItemToTrade(trade_id, player1_id, inv1.items[1].instance_id)
		local added2 = TradingService:AddItemToTrade(trade_id, player2_id, inv2.items[1].instance_id)
		print("Items added: " .. tostring(added1) .. ", " .. tostring(added2))
		
		-- Accept trade
		TradingService:AcceptTrade(trade_id, player1_id)
		TradingService:AcceptTrade(trade_id, player2_id)
		
		print("Trade completed")
	end
end

function GameManager:TestCollectionScore()
	print("\n=== TESTING COLLECTION ===")
	
	local test_player_id = 333333
	
	-- Setup
	InventoryService:InitializeInventory(test_player_id)
	ProfileService:InitializeProfile(test_player_id, "TestCollector")
	
	-- Add items
	for i = 1, 5 do
		InventoryService:AddItemToInventory(test_player_id, "item_00" .. i)
	end
	
	-- Update and display score
	ProfileService:UpdateCollectionScore(test_player_id)
	local profile = ProfileService:GetCollectionProfile(test_player_id)
	
	print("Collection Score: " .. profile.collection_score)
	print("Items Owned: " .. profile.items_owned)
end

-- Start the game
function GameManager:Start()
	print("[Market Plaza] Starting game server...")
	
	-- Connect player events
	Players.PlayerAdded:Connect(function(player)
		self:PlayerJoined(player)
	end)
	
	Players.PlayerRemoving:Connect(function(player)
		self:PlayerLeft(player)
	end)
	
	-- Run tests
	if _G.MARKETPLACE_TEST then
		wait(1)
		self:TestCreateListing()
		self:TestTrading()
		self:TestCollectionScore()
	end
	
	print("[Market Plaza] Game server started successfully!")
end

return GameManager
