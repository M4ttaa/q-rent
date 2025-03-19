Config = {}

Config.Debug = false -- Set to true to enable debug mode

Config.RentalLocations = {
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
    },
    [2] = {
        name = "Paleto Boat Rent",
        pedModel = "a_m_y_surfer_01",
        pedCoords = vec4(-1799.9009, -1223.2548, 1.6024, 174.2673),
        spawnCoords = vec4(-1798.2294, -1231.0555, 0.0413, 145.7161),
        blipName = "Boat Rent",
        boats = {
            { label = "Tropic", model = "tropic", price = 1 },
            { label = "Seashark", model = "seashark", price = 1 }
        }
    }
}
