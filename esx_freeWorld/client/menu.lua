---@diagnostic disable: undefined-field, undefined-global, lowercase-global, missing-parameter

local canopen = false

RegisterNetEvent('menu:break')
AddEventHandler('menu:break',function()
    canopen = false
    WarMenu.CloseMenu()
    RemoveAllPedWeapons(PlayerPedId(), true)
	TriggerEvent('esx:restoreLoadout')
    if lastHP then
        ESX.SetEntityHealth(PlayerPedId(), lastHP)
        lastHP = nil
    end
    if lastAr then
        ESX.SetPedArmour(PlayerPedId(), lastAr)
        lastAr = nil
    end
    ESX.SetPlayerData("inFreeWorld", false)
    print("bega")
    TriggerEvent('capture:inCapture', false)
end)

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        if exports.capture:CaptureIsActive() then return end
        TriggerEvent("menu:break")
    end
end)

RegisterNetEvent('menu:show')
AddEventHandler('menu:show',function()
    ESX.TriggerServerCallback('esx_world:canRunIt', function(can)
        if can then
            canopen = true
            start()
            TriggerEvent('capture:inCapture', true)
        end
    end)
end)

ShowMissionText = function(tx)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(tx)
    EndTextCommandPrint(8000, 1)
end

function start()
    CreateThread(function()
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < 20000 do
            Wait(0)
            ShowMissionText("Be Diamond Free World Khosh Omadi | ~g~[F7]~w~ Baraye Baz Kardan Free World Menu")
        end
    end)
    CreateThread(function()
        while canopen do
            local a = isActive()
            if not a then
                ESX.UI.Menu.CloseAll()
            end
            Citizen.Wait(10)
        end
    end)

    CreateThread(function()
        while canopen do
            SetTextFont(4)
            SetTextScale(0.0, 0.7)
            SetTextColour(33, 161, 255 , 255)
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(true)
            AddTextComponentString("Diamond FreeWorld")
            DrawText(0.5, 0.03)

            if IsControlJustPressed(0, 168) then
                WarMenu.OpenMenu("portal_menu")
            end
            Citizen.Wait(2)
        end
    end)
end

local lastVehicle = nil
Citizen.CreateThread(
    function()
        WarMenu.CreateMenu("portal_menu", "Diamond Free World", "Hi "..GetPlayerName(PlayerId()).." Welcome To Free World")
        WarMenu.CreateSubMenu("CloseMenu", "portal_menu", "Close")
        WarMenu.CreateSubMenu("self_options", "portal_menu", "Self Options")
        WarMenu.CreateSubMenu("veh_options", "portal_menu", "Vehicle Options")
        WarMenu.CreateSubMenu("weapon_options", "portal_menu", "Weapon Options")
        WarMenu.CreateSubMenu("spawn_vehicle", "veh_options", "Vehicle Spawn List")
        WarMenu.CreateSubMenu("spawn_weapon", "weapon_options", "Weapon Spawn List")
        WarMenu.CreateSubMenu("set_armor_option", "self_options", "Set Armor")

        while true do
            if WarMenu.IsMenuOpened("portal_menu") then
                if WarMenu.MenuButton("Self Options", "self_options") then
                elseif WarMenu.MenuButton("Vehicle Options", "veh_options") then
                elseif WarMenu.MenuButton("Weapon Options", "weapon_options") then
                elseif WarMenu.MenuButton("Close Menu", "CloseMenu") then
                end

                WarMenu.Display()
            elseif WarMenu.IsMenuOpened("self_options") then
                if WarMenu.MenuButton("Set Armor", "set_armor_option") then
                elseif WarMenu.Button("Self Revive") then
                    TriggerServerEvent("esx_skillPoint:removePointForRevive", 10)
                    TriggerEvent('esx_ambulancejob:revive')
                elseif WarMenu.Button("Teleport") then
                    local playerPed = PlayerPedId()
                    local waypoint = GetFirstBlipInfoId(8)
                    if DoesBlipExist(waypoint) then
                        local coord = GetBlipInfoIdCoord(waypoint)
                        local groundFound, coordZ = false, 0
                        local groundCheckHeights = { 0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0 }
                
                        for i, height in ipairs(groundCheckHeights) do
                        
                            ESX.Game.Teleport(playerPed, {
                                x = coord.x,
                                y = coord.y,
                                z = height
                            })
                
                            local foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
                            if foundGround then
                                coordZ = z + 3
                                groundFound = true
                                break
                            end
                        end
                    
                        if not groundFound then
                            coordZ = 100
                            ESX.ShowNotification('~g~Teleport Shodid')
                        end
                
                        ESX.Game.Teleport(playerPed, {
                            x = coord.x,
                            y = coord.y,
                            z = coordZ
                        })
                    else
                        ESX.ShowNotification("~r~ Shoma Jaii Ro Dar Naghshe Mark Nakardid")
                    end
                elseif WarMenu.Button("Teleport To Portal") then
                    local Portal = Config.Locations[1]
                
                    local x, y, z, h = table.unpack(Portal.Coord)
                
                    local playerPed = PlayerPedId()
                    ESX.SetEntityCoords(playerPed, x, y, z)
                    SetEntityHeading(playerPed, h)
                end
                WarMenu.Display()

            elseif WarMenu.IsMenuOpened("veh_options") then
                if WarMenu.MenuButton("Spawn Vehicle", "spawn_vehicle") then
                elseif WarMenu.Button("Repair Vehicle") then
                    local PlayerPed = PlayerPedId()
                    if IsPedInAnyVehicle(PlayerPed, false) then
                        Vehicle = GetVehiclePedIsIn(PlayerPed, false)
                        ESX.SetVehicleFixed(Vehicle)
                        SetVehicleDirtLevel(Vehicle, 0.0)
                        ESX.ShowNotification('~g~Mashin Shoma Repair Shod')
                    end
                elseif WarMenu.Button("Delete Vehicle") then
                    local playerPed = PlayerPedId()
                    if IsPedInAnyVehicle(playerPed, false) then
                        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
                        local carModel = GetEntityModel(currentVehicle)
                        local model = GetDisplayNameFromVehicleModel(carModel)
                        if Vehicles[string.lower(model)] then
                            ESX.Game.DeleteVehicle(currentVehicle)
                        end
                    end
                end
                WarMenu.Display()

            elseif WarMenu.IsMenuOpened("weapon_options") then
                if WarMenu.MenuButton("Give Weapon", "spawn_weapon") then
                elseif WarMenu.Button("Give All Weapon") then
                    for o, p in pairs(Weapons) do
                        TriggerEvent("esx:addWeapon", o, 200)
                    end
                elseif WarMenu.Button("Give Full Ammo") then
                    local ped = PlayerPedId()
                    local weaponHash = GetSelectedPedWeapon(ped)
                    if weaponHash ~= GetHashKey('weapon_unarmed') then
                        for weapon, weaponData in pairs(Weapons) do
                            if GetHashKey(weapon) == weaponHash then
                                SetPedAmmo(ped, weapon, 255)
                                ESX.ShowNotification("+~g~255~w~ Ammo For Weapon "..weaponData.label.."")
                                break
                            end
                        end    
                    else
                        ESX.ShowNotification("~r~Shoma Hich Aslahe Dar Dast Nadarid")
                    end
                end
                WarMenu.Display()

            elseif WarMenu.IsMenuOpened("spawn_weapon") then
                for o, p in pairs(Weapons) do
                    if WarMenu.Button("Give "..p.label) then
                        if Weapons[o] then
                            TriggerEvent("esx:addWeapon", o, 200)
                        end
                    end
                end
                WarMenu.Display()
            elseif WarMenu.IsMenuOpened("spawn_vehicle") then
                for o, p in pairs(Vehicles) do
                    if WarMenu.Button("Spawn "..p.label) then
                        local playerPed = PlayerPedId()
                        WarMenu.CloseMenu()
                        if lastVehicle and DoesEntityExist(lastVehicle) then
                            ESX.Game.DeleteVehicle(lastVehicle)
                            lastVehicle = nil
                        end
                        
                        if IsPedInAnyVehicle(playerPed, false) then
                            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
                            ESX.Game.DeleteVehicle(currentVehicle)
                        end
                
                        local coords = GetEntityCoords(playerPed)
                        local cameraRotation = GetGameplayCamRot(2)
                        local heading = cameraRotation.z

                        ESX.Game.SpawnVehicle(o, coords, heading, function(vehicle)
                            lastVehicle = vehicle
                            ESX.CreateVehicleKey(vehicle)
                            Citizen.Wait(350)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        end)
                    end
                end      
                WarMenu.Display()
            elseif WarMenu.IsMenuOpened("CloseMenu") then
                WarMenu.CloseMenu()
            elseif WarMenu.IsMenuOpened("set_armor_option") then
                if WarMenu.Button('Remove Armor') then
                    ESX.SetPedArmour(PlayerPedId(), 0)
                end
                if WarMenu.Button('Set Armor to 25%') then
                    ESX.SetPedArmour(PlayerPedId(), 25)
                end
                if WarMenu.Button('Set Armor to 50%') then
                    ESX.SetPedArmour(PlayerPedId(), 50)
                end
                if WarMenu.Button('Set Armor to 100%') then
                    ESX.SetPedArmour(PlayerPedId(), 100)
                end
                WarMenu.Display()
            end

            Citizen.Wait(0)
        end
    end
)