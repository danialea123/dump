function testdrive(name, properties)
    local eskicoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('test-gir')
    ESX.SetEntityCoords(PlayerPedId(), Config.TestDriveCoords)
    CloseMenu()
    Citizen.Wait(1500)
    
    ESX.Game.SpawnLocalVehicle(name, Config.TestDriveCoords, Config.TestDriveCoords.w, function(vehicle)
        ontestdrive = true
        exports["LegacyFuel"]:SetFuel(vehicle, 100)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        if properties then
            ESX.Game.SetVehicleProperties(vehicle, properties)
        end
        Citizen.Wait(2500)
        local sayi = 30
        while sayi > 0 do
            Wait(1000)
            if IsPedInAnyVehicle(PlayerPedId()) then
                sayi = sayi - 1
            else
                sayi = 0
            end
            testdrivetext = "Last " .. sayi .. " second"
        end
        ontestdrive = false
        DeleteVehicle(vehicle)
        ESX.SetEntityCoords(PlayerPedId(), eskicoords)
        notify(Config.lang.overtestdrive, true)
        TriggerServerEvent('test-cik')
    end)
end