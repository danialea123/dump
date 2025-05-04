---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field, need-check-nil
local ESX = nil
local PlayerData = {}
local AdminPerks = false
local ShowID = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject",function(obj) ESX = obj end)    
		Citizen.Wait(0)
    end
    ESX.SetPlayerData('admin',0)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)
    PlayerData = xPlayer      
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
    PlayerData.job = job   
end)

RegisterNetEvent('irs_admin:setEventCoords')
AddEventHandler('irs_admin:setEventCoords', function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if coords ~= nil then
                TriggerServerEvent('irs_admin:setEventCoords', coords)
            else
                print("Theere was a problem with getting coords")
            end
        end

    end)
end)


RegisterNetEvent('irs:ncz')
AddEventHandler('irs:ncz', function(active)
	activencz = active
	if activencz then
		Citizen.CreateThread(function()
			while activencz do
				Wait(0)
				DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 263, true) -- Melee Attack 1
			end
		end)
	end
end)

RegisterNetEvent("GhostModeiorhroe")
AddEventHandler("GhostModeiorhroe",function(toggleafe)
    SetEntityVisible(GetPlayerPed(-1), toggleafe, false)
    --SetEntityCompletelyDisableCollision(GetPlayerPed(-1), toggleafe, true)
end)

local noclip2 = false

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
    local pitch = GetGameplayCamRelativePitch()
  
    local x = -math.sin(heading*math.pi/180.0)
    local y = math.cos(heading*math.pi/180.0)
    local z = math.sin(pitch*math.pi/180.0)
  
    local len = math.sqrt(x*x+y*y+z*z)
    if len ~= 0 then
      x = x/len
      y = y/len
      z = z/len
    end
  
    return x,y,z
  end


RegisterNetEvent("Noclip2iorhroe")
AddEventHandler("Noclip2iorhroe",function()
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 5 then
            local eqfj30f = GetPlayerPed(-1)
            if noclip2 then
                TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " ^0Noclip ^2Off!!")
                noclip2 = false

            else
                TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " ^0Noclip ^2On!!")
                noclip2 = true
                Citizen.CreateThread(function()
                    x,y,z = table.unpack(GetEntityCoords(eqfj30f, true))
                    while noclip2 do
                        Citizen.Wait(0)
                        local dx,dy,dz = getCamDirection()
                        local speed = 1.0
                
                        -- aller vers le haut
                        if IsControlPressed(0,32) then -- MOVE UP
                        x = x+speed*dx
                        y = y+speed*dy
                        z = z+speed*dz
                        end
                
                        -- aller vers le bas
                        if IsControlPressed(0,269) then -- MOVE DOWN
                        x = x-speed*dx
                        y = y-speed*dy
                        z = z-speed*dz
                        end
                
                        ESX.SetEntityCoordsNoOffset(eqfj30f,x,y,z,true,true,true)
                    end
                end)
            end
            SetEntityVisible(eqfj30f, not noclip2, false)
            SetEntityCompletelyDisableCollision(eqfj30f, not noclip2, true)
        else
            TriggerServerEvent("HR_BanSystem:BanMe", "Ay Baba Nashod Ke :(", 700)
        end
    end)
end)

RegisterNetEvent("changepedHandler")
AddEventHandler("changepedHandler",function(skin)
    if GetInvokingResource() then return end
    exports.esx_manager:setException(skin ~= "mp_m_freemode_01")
    local model = GetHashKey(skin)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    for i = 0, 13 do
        ClearPedProp(PlayerPedId(), i)
    end
    for i = 0, 12 do
        SetPedComponentVariation(PlayerPedId(), i, 0, 0, 2)
    end
    SetPlayerModel(PlayerId(), model)
    for i = 0, 13 do
        ClearPedProp(PlayerPedId(), i)
    end
    for i = 0, 12 do
        SetPedComponentVariation(PlayerPedId(), i, 0, 0, 2)
    end
    Citizen.Wait(2000)
    TriggerEvent('esx:restoreLoadout')
end)


RegisterNetEvent("aduty:deleteVehicle")
AddEventHandler("aduty:deleteVehicle", function()
  
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection(4)
    local entity = vehicle
    carModel = GetEntityModel(entity)
    carName = GetDisplayNameFromVehicleModel(carModel)
    NetworkRequestControlOfEntity(entity)
    
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    SetEntityAsMissionEntity(entity, true, true)
    
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    if IsVehicleSeatFree(entity, -1) then
        if DoesEntityExist(entity) then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[SYSTEM]", "^2 " .. carName .. "^0 ba movafaghiat hazf shod!"}
            })
        end
        
        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
        
        if (DoesEntityExist(entity)) then 
            DeleteEntity(entity)
        end
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "^2 " .. carName .. "^0 dar hale hazer yek ranande dare"}
        })
    end

end)

RegisterNetEvent("aduty:getplateVehicle")
AddEventHandler("aduty:getplateVehicle", function()
  
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection(10)
	
    local entity = vehicle
    
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "^2 Pelak : ".. GetVehicleNumberPlateText(vehicle)}
        })


end)

RegisterCommand('flip', function(source)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            if ESX.GetPlayerData()['admin'] == 1 then

                TriggerEvent("aduty:flip")
                
            else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})

            end

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

        end)
end, false)



function visibility()

    Citizen.CreateThread( function()
        while true do
            Citizen.Wait(1000)
            
            if ForceToVisible then
                SetEntityVisible(GetPlayerPed(-1), true, false)
            end

        end
        
    end)

end

--[[Citizen.CreateThread(function()

	while true do
        Wait(10)
            
            if (IsControlPressed(1, 21) and IsControlPressed(1, 38)) then
                
                if time == 0 then

                    time = 3

                    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

                        if isAdmin then

                            if ESX.GetPlayerData()['admin'] == 1 then
                                local playerPed = GetPlayerPed(-1)
                                local WaypointHandle = GetFirstBlipInfoId(8)
                                if DoesBlipExist(WaypointHandle) then
                                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    x,y,z = waypointCoords["x"], waypointCoords["y"], height + 0.0
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        x,y,z = waypointCoords["x"], waypointCoords["y"], height + 0.0
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end
                Citizen.CreateThread(function()
	            Citizen.Wait(1000)
	            end)
                            ESX.Alert("Shoma Teleport Shodid.")
                                else
                                    ESX.Alert("Markeri baraye teleport shodan vojoud nadarad!")
                                end

                            else

                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0be marker roye map teleport konid!"}
                                })

                            end

                            end

                        end)

             end


        end
        
        while time > 0 do

            Citizen.Wait(1000)

            time = time -1
            
        end
       
		
    end

end)]]

RegisterCommand('dobject', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            if args[1] then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                local object = GetClosestObjectOfType(coords, 10000.0, GetHashKey(args[1]), false, false, false)
                
                if DoesEntityExist(object) then
                    ESX.Game.DeleteObject(object)
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "Shoma yek ^2" .. args[1] .. "^0 delete kardid!"}
                    })
                else
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "Hich objecti peyda nashod"}
                    })
                end

            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Shoma dar ghesmat esm object chizi varred nakardid"}
                })
            end
           

        end

     end)
end, false)
    
RegisterCommand('mcar', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 4 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if not args[1] then 

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat model mashin chizi vared nakardid!"}
                        })

                        return
                    end

                    if not args[2] then 

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat turbo chizi vared nakardid!"}
                        })

                        return
                    end

                    local turbo = args[2]
                    local model = args[1]
                    local colors = {a = 0, b = 0, c = 0}

                    if args[3] then 

                        colors.a = tonumber(args[3])

                    end

                    if args[4] then 

                        colors.b = tonumber(args[4])

                    end

                    if args[5] then 

                        colors.c = tonumber(args[5])

                    end

                    if turbo == "true" then

                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)
                
                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, true, colors)
                        
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 ba ^3turbo ^0spawn shod!"}
                                })
                
                        end)
                
                    elseif turbo == "false" then
                
                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)
                
                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, false, colors)
                                local carModel = GetEntityModel(vehicle)
                                local carName = GetDisplayNameFromVehicleModel(vehicle)
                        
                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 spawn shod!"}
                                })
                
                        end)

                    else

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "^2 Shoma dar ghesmat turbo statement eshtebahi vared kardid!"}
                        })
                
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

        end)
end, false)

RegisterCommand('alock', function(source)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then
                    
                    --[[if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if lock == 1 or lock == 0 then
                            SetVehicleDoorShut(vehicle, 0, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            SetVehicleDoorsLocked(vehicle, 2)
                            PlayVehicleDoorCloseSound(vehicle, 1)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                            ESX.Alert('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                        elseif lock == 2 then
                            SetVehicleDoorsLocked(vehicle, 1)
                            PlayVehicleDoorOpenSound(vehicle, 0)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                            ESX.Alert('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                        end
                        
                    else
        
                        local vehicle = ESX.Game.GetVehicleInDirection(4)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if vehicle ~= 0 then
        
                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                            vehicleLabel = GetLabelText(vehicleLabel)
        
                            if lock == 1 or lock == 0 then
                                SetVehicleDoorShut(vehicle, 0, false)
                                SetVehicleDoorShut(vehicle, 1, false)
                                SetVehicleDoorShut(vehicle, 2, false)
                                SetVehicleDoorShut(vehicle, 3, false)
                                SetVehicleDoorsLocked(vehicle, 2)
                                PlayVehicleDoorCloseSound(vehicle, 1)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                                ESX.Alert('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                            elseif lock == 2 then
                                SetVehicleDoorsLocked(vehicle, 1)
                                PlayVehicleDoorOpenSound(vehicle, 0)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                                TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                                ESX.Alert('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                            end
        
                        else
        
                            ESX.Alert("~r~~h~Hich mashini nazdik shoma nist!")
        
                        end
                        
                    end]]
                    local ped = GetPlayerPed(-1)
                    local coords = GetEntityCoords(ped)
                    local vehicle, distance = GetVehiclePedIsIn(ped, false), 0
                    if vehicle < 1 then
                        vehicle, distance = ESX.Game.GetClosestVehicle(coords)
                    end
                    if vehicle > 0 and distance < 10 then
                        NetworkRequestControlOfEntity(vehicle)
                        local timeout = 1000
                        while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
                            Citizen.Wait(100)
                            timeout = timeout - 100
                        end
                        local prop = CreateObject(GetHashKey('lr_prop_carkey_fob'), coords, true, true, true)
                        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                        TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click_fp', 8.0, 8.0, 1000, 48, 1, false, false, false)
                        Citizen.Wait(300)
                        if GetVehicleDoorLockStatus(vehicle) == 2 then
                            --SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                            SetVehicleDoorsLocked(vehicle, 0)
                            PlayVehicleDoorOpenSound(vehicle, 1)
                            ESX.Alert('~y~[Vehicle Lock] ~w~Vehicle ~g~Unlocked.')
                        else
                            --SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                            SetVehicleDoorsLocked(vehicle, 2)
                            SetVehicleDoorsShut(vehicle, false)
                            PlayVehicleDoorCloseSound(vehicle, 0)
                            ESX.Alert('~y~[Vehicle Lock] ~w~Vehicle ~r~Locked.')
                        end
                        Citizen.CreateThread(function()
                            local vehicle = vehicle
                            local prop = prop
                            SetVehicleLights(vehicle, 2)
                            Citizen.Wait(200)
                            SetVehicleLights(vehicle, 0)
                            Citizen.Wait(200)
                            SetVehicleLights(vehicle, 2)
                            Citizen.Wait(200)
                            SetVehicleLights(vehicle, 0)
                            DeleteEntity(prop)
                        end)
                    else
                        ESX.Alert('~y~[Vehicle Lock] ~w~Hich ~r~mashini ~w~dar nazdiki shoma nist.')
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterNetEvent("aduty:addSuggestions")
AddEventHandler("aduty:addSuggestions",function()

        TriggerEvent('chat:addSuggestion', '/aduty', 'Jahat on/off duty shodan admini', {
        })

        TriggerEvent('chat:addSuggestion', '/changeped', 'Jahat avaz kardan ped', {
            { name="EsmPed", help="Esm ped mored nazar" }
        })
		
		TriggerEvent('chat:addSuggestion', '/deletecar', 'Haz Kardan Yek Mashin Az Database', {
            { name="Pelak", help="Pelak Mashin" }
        })

        TriggerEvent('chat:addSuggestion', '/resetped', 'Jahat reset kardan ped be halat admini', {
        })

        TriggerEvent('chat:addSuggestion', '/w', 'Jahat ferestadan whisper admini', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/livery', 'Jahat avaz kardan livery mashin', {
            { name="ID", help="ID livery mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/alock', 'Jahat baz ya baste kardan dare mashini ke darid be an negah mikonid', {
        })

        TriggerEvent('chat:addSuggestion', '/getin', 'Jahat raftan be dakhel mashin', {
        })

        TriggerEvent('chat:addSuggestion', '/setarmor', 'Jahat avaz kardan armor player', {
            { name="ID", help="ID player mored nazar" },
            { name="Armor", help="Meghdar armor beyn 0-100" }
        })

        TriggerEvent('chat:addSuggestion', '/fineoffline', 'Jarime kardan player be sorat offline', {
            { name="Esm", help="Esm daghigh player ba horof bozorg va kochik" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })


        TriggerEvent('chat:addSuggestion', '/fine', 'Jarime kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })

        TriggerEvent('chat:addSuggestion', '/ajailoffline', 'Admin jail kardan player be sorat offline', {
            { name="Esm", help="Steam HEX" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/ajail', 'Admin jail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/aunjail', 'Admin unjail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/money', 'Taghir dadan pol player', {
            { name="ID", help="ID player mored nazar" },
            { name="NoePool", help="Noe pool ebarat ast az cash/bank/black" },
            { name="Meghdar", help="Meghdar pool mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/plate', 'Avaz kardan shomare pelak mashin', {
            { name="Pelak", help="Pelak mored nazar" },
            { name="db", help="Tanzim dar database : 0, 1" }
        })

        TriggerEvent('chat:addSuggestion', '/a', 'Ferestadan adminchat', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/kick', 'Kick kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil kick shodan" }
        })

        TriggerEvent('chat:addSuggestion', '/mute', 'Jahat mute kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil mute shodan player" }
        })

        TriggerEvent('chat:addSuggestion', '/unmute', 'Jahat unmute kardan player', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/toggleid', 'Jahat toggle kardan halat didan ID playerha', {
        })

        TriggerEvent('chat:addSuggestion', '/resetaccount', 'Jahat reset kardan account player', {
            { name="HEX", help="Hex Player Mored Nazar" },
            { name="Dalil", help="Dalil reset kardan account" }
        })

        TriggerEvent('chat:addSuggestion', '/disband', 'Jahat disband kardan family', {
            { name="ESM", help="Esm family mored nazar" },
            { name="Dalil", help="Dalil disband kardan gang" }
        })

        TriggerEvent('chat:addSuggestion', '/charmenu', 'Reload player skin', {
            { name="Player", help="Player ID" },
        })

        TriggerEvent('chat:addSuggestion', '/vanish', 'baraye avaz kardan vaziat dide shodan', {
        })  

        TriggerEvent('chat:addSuggestion', '/atoggle', 'toggle kardan tag admini baraye hame', {
        })

        TriggerEvent('chat:addSuggestion', '/owntoggle', 'toggle kardan tag admini baraye khod', {
        })

        TriggerEvent('chat:addSuggestion', '/spect', 'Jahat spect kardan player mored nazar', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/togglenotify', 'Jahat toggle kardan notification haye anticheat', {
        })

        TriggerEvent('chat:addSuggestion', '/noclip2', 'Noclip pishrafte', {
            {}
        })
        
        TriggerEvent('chat:addSuggestion', '/changeworld', 'Change World dadan player', {
            { name="ID", help="ID player mored nazar" },
            { name="World", help="ID world mored nazar" }
        })
end)

RegisterNetEvent("aduty:removeSuggestions")
AddEventHandler("aduty:removeSuggestions",function()

        TriggerEvent('chat:removeSuggestion', '/aduty')

        TriggerEvent('chat:removeSuggestion', '/livery')

        TriggerEvent('chat:removeSuggestion', '/changeped')

        TriggerEvent('chat:removeSuggestion', '/resetped')

        TriggerEvent('chat:removeSuggestion', '/w')

        TriggerEvent('chat:removeSuggestion', '/setarmor')

        TriggerEvent('chat:removeSuggestion', '/fineoffline')

        TriggerEvent('chat:removeSuggestion', '/fine')

        TriggerEvent('chat:removeSuggestion', '/ajailoffline')

        TriggerEvent('chat:removeSuggestion', '/ajail')

        TriggerEvent('chat:removeSuggestion', '/aunjail')

        TriggerEvent('chat:removeSuggestion', '/money')

        TriggerEvent('chat:removeSuggestion', '/plate')

        TriggerEvent('chat:removeSuggestion', '/a')

        TriggerEvent('chat:removeSuggestion', '/kick')

        TriggerEvent('chat:removeSuggestion', '/mute')

        TriggerEvent('chat:removeSuggestion', '/unmute')

        TriggerEvent('chat:removeSuggestion', '/toggleid')

        TriggerEvent('chat:removeSuggestion', '/resetaccount')

        TriggerEvent('chat:removeSuggestion', '/disband')

        TriggerEvent('chat:removeSuggestion', '/vanish')

        TriggerEvent('chat:removeSuggestion', '/dv2')

        TriggerEvent('chat:removeSuggestion', '/charmenu')


        TriggerEvent('chat:removeSuggestion', '/alock')

        TriggerEvent('chat:removeSuggestion', '/getin')

        TriggerEvent('chat:removeSuggestion', '/owntoggle')

        TriggerEvent('chat:removeSuggestion', '/spect')
        
        TriggerEvent('chat:removeSuggestion', '/togglenotify')

        TriggerEvent('chat:removeSuggestion', '/ban')

        TriggerEvent('chat:removeSuggestion', '/banoffline')

        TriggerEvent('chat:removeSuggestion', '/unban')
        
        TriggerEvent('chat:removeSuggestion', '/noclip2')
        
        TriggerEvent('chat:removeSuggestion', '/changeworld')

end)

function SetVehicleMaxMods(vehicle, turbo, colors)

        local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   -1,
            modTurbo        =   turbo,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c
        }
            
    ESX.Game.SetVehicleProperties(vehicle, props)

end

RegisterNetEvent("es:AdminOnDuty")
AddEventHandler("es:AdminOnDuty",function()
	AdminPerks = true
	ShowID = true
	AdminPerksFunc()
	ShowPlayerNames()
    ESX.SetPlayerData('admin',1)
end)

RegisterNetEvent("es:AdminOffDuty")
AddEventHandler("es:AdminOffDuty",function()
    AdminPerks = false
    ShowID = false
    ESX.SetPlayerData('admin',0)
    TriggerEvent("esx_aduty:OnOffDuty")
end)

function ShowPlayerNames()
    Citizen.CreateThread(function()
        while ShowID do
            DoESP()
            Citizen.Wait(2)
        end
    end)
end

function AdminPerksFunc()
    Citizen.CreateThread( function()
        while AdminPerks do
            Citizen.Wait(2000)
			ResetPlayerStamina(PlayerId())
			SetEntityInvincible(PlayerPedId(), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(PlayerPedId(), false)
			ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(PlayerPedId(), false)
        end
		SetEntityInvincible(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), false)
		SetPedCanRagdoll(PlayerPedId(), true)
		ClearPedLastWeaponDamage(PlayerPedId())
		SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
    end)
end

RegisterCommand("toggleid", function()
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 12 then
            ShowID = not ShowID
            ShowPlayerNames()
            ESX.Alert("id ha toggle shodand", "info")
        end
    end)
end)

RegisterNetEvent('esx:ActiveAdminPerks')
AddEventHandler('esx:ActiveAdminPerks', function(toggle)
	if toggle then
		AdminPerks = true
		ShowID = true
		AdminPerksFunc()
		ShowPlayerNames()
	else
		ShowID = false
		AdminPerks = false
	end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local invehicle = IsPedInAnyVehicle(ped, false)

    if invehicle then
        for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
            if (GetPedInVehicleSeat(vehicle, i) == ped) then return i end
        end
    end

    return -2
end

function DoESP()
    local spot = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
    local vector_origin = vector3(0, 0, 0)
     for id, src in pairs(GetActivePlayers()) do
        src = tonumber(src)
        local ped = GetPlayerPed(src)

        if DoesEntityExist(ped) and ped ~= PlayerPedId() then
            local _id = tonumber(GetPlayerServerId(src))
            local coords = GetOffsetFromEntityInWorldCoords(ped, vector_origin.x, vector_origin.y, vector_origin.z)
            local dist = GetDistanceBetweenCoords(spot.x, spot.y, spot.z, coords.x, coords.y, coords.z)
            local seat = tonumber(GetPedVehicleSeat(ped))
            if seat ~= -2 then
                seat = seat + 0.25
            end

            if dist <= 300.0 then
                local pos_z = coords.z + 1.2

                if seat ~= -2 then
                    pos_z = pos_z + seat
                end

                local _on_screen, _, _ = GetScreenCoordFromWorldCoord(coords.x, coords.y, pos_z)

                if _on_screen then
                    Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. GetPlayerName(src) .. " [" .. ESX.Math.Round(dist) .. "M" .. "]", 255, 255, 255)
                end
            end
        end
    end
end

function Draw3DText(x, y, z, text, r, g, b)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.20)
    SetTextColour(r, g, b, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(1)
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("irsadmin:skin")
AddEventHandler("irsadmin:skin",function()

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin == nil then
          TriggerEvent('skinchanger:loadSkin', {sex = 0})
        --  TriggerServerEvent("bms:tattoo:activateTattooShop2")
        else
          TriggerEvent('skinchanger:loadSkin', skin)
         -- TriggerServerEvent("bms:tattoo:activateTattooShop2")
        end

      end)
        
    end)

RegisterCommand('reviverange', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            if not tonumber(args[1]) then return end
            local players       = ESX.Game.GetPlayers()
            local coords = GetEntityCoords(PlayerPedId())
            for i=1, #players, 1 do
                local target       = GetPlayerPed(players[i])
                local targetCoords = GetEntityCoords(target)
                local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
                if distance <= tonumber(args[1]) + 10 then
                    Wait(100)
                    ExecuteCommand("revive ".. GetPlayerServerId(players[i]))
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "reviveing Player With ID: "..GetPlayerServerId(players[i])}})
                end
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})
        end
    end)
end, false)

RegisterCommand('healrange', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            if not tonumber(args[1]) then return end
            local players       = ESX.Game.GetPlayers()
            local coords = GetEntityCoords(PlayerPedId())
            for i=1, #players, 1 do
                local target       = GetPlayerPed(players[i])
                local targetCoords = GetEntityCoords(target)
                local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
                if distance <= tonumber(args[1]) + 10 then
                    Wait(100)
                    ExecuteCommand("heal ".. GetPlayerServerId(players[i]))
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "healing Player With ID: "..GetPlayerServerId(players[i])}})
                end
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})
        end
    end)
end, false)


