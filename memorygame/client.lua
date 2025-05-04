local ui = false;
local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

RegisterNetEvent('bur_nui_var:open')
AddEventHandler('bur_nui_var:open', function()
    SendNUIMessage({showUI = true; })
    SetNuiFocus(true,true)
    ToggleTablet(not tablet)
end)

RegisterNetEvent('bur_nui_var:close')
AddEventHandler('bur_nui_var:close', function()
    SendNUIMessage({showUI = false; })
    SetNuiFocus(false,false)
    ToggleTablet(tablet)
    DeleteEntity(tabletProp)
    tablet = false
end)

RegisterNUICallback('bur_exit_var', function(data)
    TriggerEvent('bur_nui_var:close')
    FreezeEntityPosition(PlayerPedId(), false)
    ToggleTablet(tablet)
    DeleteEntity(tabletProp)
    TriggerEvent("esx_lirobbery:hackResult", false)
    tablet = false
end)

RegisterNUICallback('bur_enter_var', function(data)
    TriggerEvent('bur_nui_var:close')
    FreezeEntityPosition(PlayerPedId(), false)
    print("You win!")
    ToggleTablet(tablet)
    DeleteEntity(tabletProp)
    TriggerEvent("esx_lirobbery:hackResult", true)
    tablet = false
end)


Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 106, display)
    end
end)

Citizen.CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
        Citizen.Wait(10000)
	end
end)

function ToggleTablet(toggle)
    if toggle and not tablet then
        tablet = true

        Citizen.CreateThread(function()
            RequestAnimDict(tabletDict)

            while not HasAnimDictLoaded(tabletDict) do
                Citizen.Wait(150)
            end

            RequestModel(tabletProp)

            while not HasModelLoaded(tabletProp) do
                Citizen.Wait(150)
            end

            local playerPed = PlayerPedId()
            local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
            local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

            SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
            SetModelAsNoLongerNeeded(tabletProp)

            while tablet do
                Citizen.Wait(100)
                playerPed = PlayerPedId()

                if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end
            end

            ClearPedSecondaryTask(playerPed)

            Citizen.Wait(450)
            ClearPedTasks(PlayerPedId())
            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
        end)
    elseif not toggle and tablet then
        tablet = false
    end
end