local QBCore = exports['qb-core']:GetCoreObject()
local peds = {}
local spawnedVehicles = {} -- Table to keep track of spawned vehicles

Citizen.CreateThread(function()
    for rentalId, location in pairs(Config.RentalLocations) do
        local pedModel = GetHashKey(location.pedModel)

        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end

        -- Create Ped
        local ped = CreatePed(4, pedModel, location.pedCoords.x, location.pedCoords.y, location.pedCoords.z - 1, location.pedCoords.w, true, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        table.insert(peds, ped)

        -- Add Target Interaction
        exports.ox_target:addBoxZone({
            coords = vec3(location.pedCoords.x, location.pedCoords.y, location.pedCoords.z),
            size = vec3(1, 1, 1),
            rotation = 45,
            debug = Config.Debug,
            options = {
                {
                    name = 'boat_rental_' .. rentalId,
                    icon = 'fa-solid fa-ship',
                    label = 'Iznajmi Brod',
                    canInteract = function()
                        return not IsPedInAnyVehicle(PlayerPedId(), true) -- Ensure player is not in a vehicle
                    end,
                    onSelect = function()
                        TriggerEvent('q-rent:openmenu', rentalId) -- Ensure rentalId is passed
                    end
                },
                {
                    name = 'retrieve_boat_' .. rentalId,
                    icon = 'fa-solid fa-ship',
                    label = 'Vrati Brod',
                    canInteract = function()
                        return IsPedInAnyVehicle(PlayerPedId(), false) -- Ensure player is not in a vehicle
                    end,
                    onSelect = function()
                        TriggerEvent('q-rent:retrieveBoat', rentalId) -- Trigger event to retrieve the boat
                    end
                }
            }
        })

        -- Add Blip
        local blip = AddBlipForCoord(location.pedCoords.x, location.pedCoords.y, location.pedCoords.z)
        SetBlipSprite(blip, 455)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.blipName)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Open Rental Menu based on rental ID
RegisterNetEvent('q-rent:openmenu', function(rentalId)
    local location = Config.RentalLocations[rentalId]
    if not location then return end -- Safety check
    local options = {}
    for _, boat in ipairs(location.boats) do
        table.insert(options, {
            title = boat.label .. " - $" .. boat.price,
            onSelect = function()
                QBCore.Functions.TriggerCallback('CheckLocMoney', function(hasEnoughMoney)
                    if hasEnoughMoney then
                        TriggerServerEvent('RemoveLocMoney', boat.price)
                        SpawnVehicle(boat.model, location.spawnCoords, rentalId)
                    else
                        TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Nemas dovoljno novca!", type = "success" })
                    end
                end, boat.price)
            end
        })
    end

    lib.registerContext({
        id = "location_menu_" .. rentalId, -- Unique menu ID
        title = location.name,
        options = options
    })
    lib.showContext("location_menu_" .. rentalId)
end)

-- Vehicle Spawning Function
function SpawnVehicle(model, coords, rentalId)
    local vehicleModel = GetHashKey(model)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(1)
    end

    local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.w, true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    -- Store spawned vehicle for retrieval later
    spawnedVehicles[rentalId] = vehicle

    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Give keys to the player
    QBCore.Functions.TriggerCallback('keysmanage', function(success)
        if success then
            TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Dobio si kljuceve", type = "success" })
        else
            TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Nemoguce dobiti kljuceve", type = "error" })
        end
    end, "add", plate)
end

-- Retrieve Boat (Delete the spawned vehicle & remove keys)
RegisterNetEvent('q-rent:retrieveBoat', function(rentalId)
    local vehicle = spawnedVehicles[rentalId]
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)

        -- Remove keys
        QBCore.Functions.TriggerCallback('keysmanage', function(success)
            if success then
                TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Kljucevi oduzeti", type = "success" })
            else
                TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Kljucevi oduzeti", type = "success" })
            end
        end, "delete", plate)

        -- Delete the vehicle
        DeleteEntity(vehicle)
        spawnedVehicles[rentalId] = nil -- Remove from tracked spawned vehicles
    else
        TriggerEvent('ox_lib:notify', { title = 'Boat Rent.', description = "Nema broda", type = "error" })
    end
end)
