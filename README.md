# Boat Rental System

A customizable boat rental system for GTA V, allowing players to rent boats at specific locations. This system includes customizable rental locations, NPC interactions, and boat spawning mechanics.

## Features

- **Multiple Rental Locations**: Configure multiple boat rental spots across the map.
- **Customizable NPCs**: Set up NPCs at each rental location with different ped models.
- **Boat Selection**: Rent different types of boats with customizable prices and models.
- **Map Blips**: Show boat rental locations on the map with custom blip names.
- **Debug Mode**: Enable debug mode for easier troubleshooting and system monitoring.

## Installation

### Requirements

- A running GTA V server with a compatible framework (e.g., FiveM).
- The `boats` resource needs to be installed on your server.

### Steps

1. **Download the Script**:
   - Clone or download the repository containing the boat rental system.

2. **Place the Configuration File**:
   - Place the `config.lua` file in the appropriate `config` folder of the boat rental script.

3. **Configure Rental Locations**:
   - Modify the `Config.RentalLocations` in the `config.lua` file to set up your boat rental locations.
   - Add new rental spots by copying and modifying the existing structure.
   - Adjust coordinates for NPC and boat spawn points to match your server’s setup.

4. **Add to Server Resources**:
   - Ensure that the boat rental system is referenced in your server's `resource.lua` or equivalent manifest file.

5. **Customize Prices**:
   - Change the `price` for each boat available for rent in the configuration.

6. **Launch the Server**:
   - Start the server and test the boat rental system in-game.

## Configuration Breakdown

### Config.Debug

- `Config.Debug`: Set to `true` to enable debug mode, which provides additional logging for troubleshooting.
- Set to `false` to disable debug mode.

### Rental Locations

The `Config.RentalLocations` table contains multiple rental locations. Each rental location has its own unique configuration, including the NPC model, spawn coordinates, and available boats.

#### Example:

```lua
[1] = {
    name = "Paleto Boat Rent",
    pedModel = "a_m_m_fatlatin_01",
    pedCoords = vec4(-1610.3235, 5263.7202, 3.9741, 195.5244),
    spawnCoords = vec4(-1602.8237, 5259.0479, 0.1246, 25.5238),
    blipName = "Boat Rent",
    boats = {
        { label = "Dinghy", model = "dinghy", price = 1 },
        { label = "Seashark", model = "seashark", price = 1 }
    }
}
