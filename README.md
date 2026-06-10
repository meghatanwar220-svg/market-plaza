# Market Plaza - Roblox Game

A social player-to-player marketplace game where players buy, sell, and trade collectible in-game items.

## Core Features

- **Marketplace System**: Browse and purchase items from other players
- **Trading System**: Trade items and currency with other players
- **Collection System**: Build and showcase your collection
- **Economy**: Earn coins through selling and quests
- **Leaderboards**: Compete as top collectors, traders, and sellers
- **Player Stalls**: Claim and customize your shop

## Project Structure

```
market-plaza/
├── src/
│   ├── Services/
│   │   ├── InventoryService.lua
│   │   ├── MarketplaceService.lua
│   │   ├── TradingService.lua
│   │   ├── EconomyService.lua
│   │   ├── ItemService.lua
│   │   └── ProfileService.lua
│   ├── Controllers/
│   │   ├── InventoryController.lua
│   │   ├── MarketplaceController.lua
│   │   ├── TradingController.lua
│   │   ├── ProfileController.lua
│   │   └── UIController.lua
│   ├── Data/
│   │   ├── ItemData.lua
│   │   ├── RarityData.lua
│   │   └── StartupItems.lua
│   ├── Utils/
│   │   ├── TableUtils.lua
│   │   ├── ValidationUtils.lua
│   │   └── Constants.lua
│   └── Main.lua
├── game/
│   ├── ServerScriptService/
│   ├── StarterPlayer/
│   └── StarterGui/
└── README.md
```

## Setup

1. Copy the `src/` folder contents into your Roblox game
2. Follow the module loading order in `Main.lua`
3. Configure DataStores for persistence

## MVP Goals

- [x] Basic project structure
- [x] Service architecture
- [ ] Inventory system
- [ ] Marketplace listing/buying
- [ ] Trading mechanics
- [ ] Collection scoring
- [ ] Persistence
- [ ] UI
- [ ] Leaderboards

## Requirements

- Roblox Studio
- Lua 5.1 knowledge
- Understanding of Roblox services
