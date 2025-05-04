---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global
local canPlay = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canPlay = true
    else
        canPlay = false
    end
end)

local isTextUiOpen = false
CreateThread(function()
    while true do
        local cooldown = 1500
        local coords = GetEntityCoords(PlayerPedId())
        local near = false
        local isInZone = false
        for _,v in pairs(Config.Barber.coords) do
            local dist = #(coords - v)
            if dist < 3.0 and not menuOpen then
                near = true
                isInZone = true
                cooldown = 0
                if Config.Barber.marker.enable then
                    local rgba = Config.Barber.marker.rgba
                    local size = Config.Barber.marker.size
                    local type = Config.Barber.marker.type

                    DrawMarker(type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, size, rgba[1] or 255, rgba[2] or 255, rgba[3] or 0, rgba[4] or 255, false, false, 0, true, false, false, false)
                end
                if Config.Barber.drawText.enable then
                    DrawText3D(v.x, v.y, v.z, Config.Barber.drawText.text)
                end
                if Config.Barber.textui.enable then                    
                    ShowHelpNotification(Config.Barber.textui.text)
                end
                if not isTextUiOpen and Config.Barber.codemtextui.enable then
                    isTextUiOpen = true
                    exports["codem-textui"]:OpenTextUI(Config.Barber.codemtextui.text, Config.Barber.codemtextui.keytext, Config.Barber.codemtextui.theme)
                end
                if not isTextUiOpen and Config.Barber.okoktextui.enable then
                    isTextUiOpen = true
                    exports['okokTextUI']:Open(Config.Barber.okoktextui.text, Config.Barber.okoktextui.color,Config.Barber.okoktextui.position)
                end
                if not isTextUiOpen and Config.Barber.ethTextUI.enable then
                    isTextUiOpen = true
                    exports['eth-textUi']:Show(Config.Barber.ethTextUI.header, Config.Barber.ethTextUI.text)
                end
                if IsControlJustPressed(0, Config.Barber.openKey) and canPlay then
                    OpenMenu("barber")
                end
            end
        end
        if isTextUiOpen and not isInZone and Config.Barber.codemtextui.enable then
            exports["codem-textui"]:CloseTextUI()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Barber.okoktextui.enable then
            exports['okokTextUI']:Close()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Clothing.ethTextUI.enable then
            exports['eth-textUi']:Close()
            isTextUiOpen = false
        end
        if not near then
            HideHelpNotification()
        end
        Wait(cooldown)
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Barber.coords) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Barber.blip.type)
        SetBlipColour(blip, Config.Barber.blip.color)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Barber.blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Barber.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)