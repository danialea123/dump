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
        for _,v in pairs(Config.Clothing.coords) do
            local dist = #(coords - v[1])
            if dist < 3.0 and not menuOpen then
                cooldown = 0
                near = true
                isInZone = true
                if Config.Clothing.marker.enable then
                    local rgba = Config.Clothing.marker.rgba
                    local size = Config.Clothing.marker.size
                    local type = Config.Clothing.marker.type
                    DrawMarker(type, v[1].x, v[1].y, v[1].z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, size, rgba[1] or 255, rgba[2] or 255, rgba[3] or 0, rgba[4] or 255, false, false, 0, true, false, false, false)
                end
                if Config.Clothing.drawText.enable then
                    DrawText3D(v[1].x, v[1].y, v[1].z, Config.Clothing.drawText.text)
                end
                if Config.Clothing.textui.enable then                    
                    ShowHelpNotification(Config.Clothing.textui.text)
                end
                if not isTextUiOpen and Config.Clothing.codemtextui.enable then
                    isTextUiOpen = true
                    exports["codem-textui"]:OpenTextUI(Config.Clothing.codemtextui.text, Config.Clothing.codemtextui.keytext, Config.Clothing.codemtextui.theme)
                end
                if not isTextUiOpen and Config.Clothing.okoktextui.enable then
                    isTextUiOpen = true
                    exports['okokTextUI']:Open(Config.Clothing.okoktextui.text, Config.Clothing.okoktextui.color,Config.Clothing.okoktextui.position)
                end
                if not isTextUiOpen and Config.Clothing.ethTextUI.enable then
                    isTextUiOpen = true
                    exports['eth-textUi']:Show(Config.Clothing.ethTextUI.header, Config.Clothing.ethTextUI.text)
                end
                if IsControlJustPressed(0, Config.Clothing.openKey) and canPlay then
                    OpenMenu(v[2])
                end
            end
        end
        if isTextUiOpen and not isInZone and Config.Clothing.codemtextui.enable then
            exports["codem-textui"]:CloseTextUI()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Clothing.okoktextui.enable then
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
    for k,v in pairs(Config.Clothing.coords) do
        local blip = AddBlipForCoord(v[1])
        SetBlipSprite(blip, Config.Clothing.blip.type)
        SetBlipColour(blip, Config.Clothing.blip.color)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Clothing.blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Clothing.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)