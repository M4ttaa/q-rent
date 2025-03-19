local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('CheckLocMoney', function(source, cb, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerMoney = Player.PlayerData.money['cash']
    print(playerMoney)
    cb(playerMoney >= amount)
    if playerMoney < amount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Boat Rent.',
            description = 'Nemas dovoljno novca!',
            type = 'error'
        })
    end
end)

RegisterServerEvent('RemoveLocMoney')
AddEventHandler('RemoveLocMoney', function(amount, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerMoney = Player.PlayerData.money['cash']

    print("event: " .. playerMoney)
    if playerMoney >= amount then
        Player.Functions.RemoveMoney('cash', amount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Boat Rent.',
            description = 'Iznajmili ste brod.',
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Boat Rent.',
            description = 'Nemas dovoljno novca!.',
            type = 'error'
        })
    end
end)




QBCore.Functions.CreateCallback('keysmanage', function(source, cb, action, plate)
    local success = exports.mVehicle:ItemCarKeys(source, action, plate)

    if success then
        cb(true)
    else
        cb(false)
    end
end)

