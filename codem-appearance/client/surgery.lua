---@diagnostic disable: param-type-mismatch, missing-parameter
local isTextUiOpen = false

-- RegisterCommand('test1', function()
--     OpenMenu("surgery")
-- end)

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

CreateThread(function()
    while true do
        local cooldown = 1500
        local coords = GetEntityCoords(PlayerPedId())
        local near = false
        local isInZone = false
        for _,v in pairs(Config.Surgery.coords) do
            local dist = #(coords - v)
            if dist < 3.0 and not menuOpen then
                cooldown = 0
                near = true
                isInZone = true
                if Config.Surgery.marker.enable then
                    local rgba = Config.Surgery.marker.rgba
                    local size = Config.Surgery.marker.size
                    local type = Config.Surgery.marker.type

                    DrawMarker(type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, size, rgba[1] or 255, rgba[2] or 255, rgba[3] or 0, rgba[4] or 255, false, false, 0, true, false, false, false)
                end
                if Config.Surgery.drawText.enable then
                    DrawText3D(v.x, v.y, v.z, Config.Surgery.drawText.text)
                end
                if Config.Surgery.textui.enable then                    
                    ShowHelpNotification(Config.Surgery.textui.text)
                end
                if not isTextUiOpen and Config.Surgery.codemtextui.enable then
                    isTextUiOpen = true
                    exports["codem-textui"]:OpenTextUI(Config.Surgery.codemtextui.text, Config.Surgery.codemtextui.keytext, Config.Surgery.codemtextui.theme)
                end
                if not isTextUiOpen and Config.Surgery.okoktextui.enable then
                    isTextUiOpen = true
                    exports['okokTextUI']:Open(Config.Surgery.okoktextui.text, Config.Surgery.okoktextui.color,Config.Surgery.okoktextui.position)
                end
                if not isTextUiOpen and Config.Surgery.ethTextUI.enable then
                    isTextUiOpen = true
                    exports['eth-textUi']:Show(Config.Surgery.ethTextUI.header, Config.Surgery.ethTextUI.text)
                end
                if IsControlJustPressed(0, Config.Surgery.openKey) and canPlay then
                    OpenMenu("surgery")
                end
            end
        end
        if isTextUiOpen and not isInZone and Config.Surgery.codemtextui.enable then
            exports["codem-textui"]:CloseTextUI()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Surgery.okoktextui.enable then
            exports['okokTextUI']:Close()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Surgery.ethTextUI.enable then
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
    for k,v in pairs(Config.Surgery.coords) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Surgery.blip.type)
        SetBlipColour(blip, Config.Surgery.blip.color)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Surgery.blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Surgery.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)