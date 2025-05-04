Allow = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
    ["justice"] = true,
}

RegisterNUICallback("hideFrame", function(_, cb)
    toggleGpsPanel()
    cb(true)
end)

RegisterNUICallback("checkPlayerJobToView", function(data, cb)
    if data.page == "vehicle_gps" then
        cb({
            status = true
        })
        return
    elseif data.page == "suspect_gps" then
        cb({
            status = Allow[PlayerData.job.name] or false
        })
        return
    end
end)

RegisterNUICallback("vehicle-gps/addGpsRouteFromPlate", function(plate, cb)
    if plate and Blips[plate] then
        local coord = GetBlipCoords(Blips[plate])
        SetNewWaypoint(coord.x, coord.y)
        ESX.Alert("Location GPS Mark Shod", "info")
    else
        ESX.Alert("Etelaati Az Mogheyiat In GPS Vojud Nadarad", "error")
    end
    cb({ status = true })
end)

RegisterNUICallback("vehicle-gps/detachGpsToVehicle", function(plate, cb)
    if plate then
        TriggerServerEvent("esx_gps:removeFromList", plate)
        RemoveBlip(Blips[plate])
        SendReactMessage("detachGpsToVehicle", plate)
        ESX.Alert("Radiaby Pelak Gheyr Faal Shode", "info")
    end
    cb({ status = true })
end)

RegisterNUICallback("player-gps/detachGpsToTarget", function(targetCID, cb)
    if targetCID then
        SendReactMessage("detachedGpsToTarget", targetCID)
        TriggerServerEvent("esx_gps:RemovePlayerGPS", targetCID)
        ESX.Alert("GPS Player Mored Nazar Ghaat Shod", "info")
    end
    cb({ status = true })
end)

RegisterNUICallback("player-gps/shockToTarget", function(targetCID, cb)
    if targetCID then
        ESX.Alert("Dar Hale Hazer In Emkan Vojud Nadarad", "error")
    end
    cb({ status = true })
end)