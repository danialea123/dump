local Data = {}
local era = nil
local isShowing = nil 

RegisterNetEvent("qb:updateTextData")
AddEventHandler("qb:updateTextData", function(data)
    era = false
    isShowing = nil
    exports['pa-textui-2']:hideTextUI()
    Data = data
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        isShowing = nil
        for k, v in pairs(Data) do
            local coord = GetEntityCoords(PlayerPedId())
            if #(coord.xyz - v.coords.xyz) <= 5.0 then
                isShowing = v
            end
        end
        if isShowing and not era then
            era = true
            exports['pa-textui-2']:displayTextUI(isShowing.text, isShowing.key, not isShowing.key)
        end
        if era and not isShowing then
            era = false
            exports['pa-textui-2']:hideTextUI()
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(5500)
    TriggerServerEvent("qb:sendTextData")
end)