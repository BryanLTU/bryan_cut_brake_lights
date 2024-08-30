lib.locale()

local vehiclesWithCutBrakes = {}

lib.callback.register('bryan_cut_brake_lights:server:isVehicleWithCutBrakes', function(source, vehNetId)
    return lib.table.contains(vehiclesWithCutBrakes, vehNetId)
end)

RegisterNetEvent('bryan_cut_brake_lights:server:setVehicleWithCutBrakes', function(vehNetId)
    if lib.table.contains(vehiclesWithCutBrakes, vehNetId) then
        return
    end

    if not HasItem(source, Config.Item, 1) then
        return lib.notify(source, {
            description = locale('no_item'),
            type = 'error',
            icon = 'fa-solid fa-car'
        })
    end

    lib.notify(source, {
        description = locale('brakes_cut'),
        type = 'success',
        icon = 'fa-solid fa-car'
    })

    RemoveInventoryItem(source, Config.Item, 1)
    vehiclesWithCutBrakes[#vehiclesWithCutBrakes+1] = vehNetId
end)

if Config.Inventory == 'esx' then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterUsableItem(Config.Item, function(source)
        TriggerClientEvent('bryan_cut_brake_lights:client:cutBrakes', source)
    end)

    HasItem = function(playerId, itemName, count)
        return ESX.GetPlayerFromId(playerId).getInventoryItem(itemName).count >= count
    end

    RemoveInventoryItem = function(playerId, itemName, count)
        ESX.GetPlayerFromId(playerId).removeInventoryItem(itemName, count)
    end
elseif Config.Inventory == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUsableItem(Config.Item, function(source)
        TriggerClientEvent('bryan_cut_brake_lights:client:cutBrakes', source)
    end)

    HasItem = function(playerId, itemName, count)
        return QBCore.Functions.GetPlayer(playerId).GetItemByName(itemName).amount >= count
    end

    RemoveInventoryItem = function(playerId, itemName, count)
        QBCore.Functions.GetPlayer(playerId).RemoveItem(itemName, count)
    end
elseif Config.Inventory == 'ox' then
    HasItem = function(playerId, itemName, count)
        return exports.ox_inventory:GetItemCount(playerId, itemName) >= count
    end

    RemoveInventoryItem = function(playerId, itemName, count)
        -- Uses durablity
    end
end