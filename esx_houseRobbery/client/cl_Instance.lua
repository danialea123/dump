local currentInstance = ""

RegisterNetEvent("d-houserobbery_instance:onEnter")
AddEventHandler("d-houserobbery_instance:onEnter", function(instance)
    currentInstance = instance
end)

RegisterNetEvent("d-houserobbery_instance:onLeave")
AddEventHandler("d-houserobbery_instance:onLeave", function()
    currentInstance = ""
end)

function getPlayerInstance()
    return currentInstance
end