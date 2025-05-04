AddEventHandler("enable:gas", function(vehicleFuel)
    SendNUIMessage({
        type = "display",
        value = vehicleFuel,
        bool = true
    })
end)

AddEventHandler("disable:gas", function()
    SendNUIMessage({
        type = "display",
        bool = false
    })
end)