lib.locale()

local currentVehicle

local walkPedToEngine = function(ped, vehicle)
    local engineCoords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'engine'))
    local heading, forward = GetEntityHeading(vehicle), GetEntityForwardVector(vehicle)
    local offsetCoords = vec3(engineCoords.x + forward.x, engineCoords.y + forward.y, engineCoords.z)

    if offsetCoords.x ~= 0.0 and offsetCoords.y ~= 0.0 and offsetCoords.z ~= 0.0 then
        TaskGoToCoordAnyMeans(ped, offsetCoords.x, offsetCoords.y, offsetCoords.z, 1.0, 0, false, 0, 0)

        local startTime = GetGameTimer()

        while #(GetEntityCoords(ped) - offsetCoords) > 0.5 do
            if GetGameTimer() - startTime > 5000 then
                SetEntityCoords(ped, offsetCoords.x, offsetCoords.y, offsetCoords.z, false, false, false, false)

                break
            end

            Citizen.Wait(0)
        end

        FreezeEntityPosition(ped, true)
        FreezeEntityPosition(ped, false)

        SetEntityHeading(ped, heading)
    end
end

local cutBrakes = function(vehicle)
    local vehNetId = VehToNet(vehicle)

    if not vehNetId then
        return
    end

    if lib.callback.await('bryan_cut_brake_lights:server:isVehicleWithCutBrakes', false, vehNetId) then
        return lib.notify({
            description = locale('already_cut_brakes'),
            type = 'error',
            icon = 'fa-solid fa-car'
        })
    end

    walkPedToEngine(PlayerPedId(), vehicle)

    if lib.progressBar({
        duration = 10000,
        label = locale('cut_progress'),
        canCancel = true,
        anim = {
            dict = 'amb@world_human_vehicle_mechanic@male@base',
            clip = 'base',
            flag = 4
        },
        prop = {
            model = `imp_prop_impexp_pliers_03`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        }
    }) then
        TriggerServerEvent('bryan_cut_brake_lights:server:setVehicleWithCutBrakes', vehNetId)
    end
end

exports('cutBrakes', cutBrakes)

lib.onCache('vehicle', function(value)
    if not value then
        currentVehicle = nil
        return
    end

    if GetPedInVehicleSeat(value, -1) ~= PlayerPedId() or not lib.callback.await('bryan_cut_brake_lights:server:isVehicleWithCutBrakes', false, VehToNet(value)) then
        return
    end

    currentVehicle = value
end)

Citizen.CreateThread(function()
    while true do
        local sleep = true

        if currentVehicle then
            sleep = false
            SetVehicleBrakeLights(currentVehicle, false)
        end

        if sleep then Citizen.Wait(500) end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('bryan_cut_brake_lights:client:cutBrakes', function(data)
    local vehicle = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()))

    if not vehicle then
        return lib.notify({
            description = locale('no_vehicle_nearby'),
            type = 'error',
            icon = 'fa-solid fa-car'
        })
    end

    if Config.Inventory == 'ox' then
        exports.ox_inventory:useItem(data, function(data)
            if data then
                cutBrakes(vehicle)
            end
        end)

        return
    end

    cutBrakes(vehicle)
end)