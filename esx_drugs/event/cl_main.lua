local Locations = {
    vector3(2597.196, -1717.094, 20.19775),
    vector3(2488.576, -672.9231, 61.81689),
    vector3(2057.367, 3378.501, 45.47253),
    vector3(184.6022, 3477.138, 29.51575),
    vector3(2164.945, 4721.525, 40.01318),
    vector3(1451.196, 4496.176, 50.35901),
    vector3(-2167.279, 5183.183, 15.59778),
}

local Point = {}
local Interact = {}
local Register = {}
local Blip = {}
local async = false
local played = false

RegisterNetEvent("esx_event:PedaretMord")
AddEventHandler("esx_event:PedaretMord", function()
    EventHandler()
end)

RegisterNetEvent("esx_event:CancelEv")
AddEventHandler("esx_event:CancelEv", function()
    exports.sr_main:RemoveByTag("event")
    for k, v in pairs(Blip) do
        RemoveBlip(v)
    end
end)

function EventHandler()
    for _, v in pairs(Locations) do
        if _ == 1 then
            Blip[_] = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(Blip[_], 659)
            SetBlipColour(Blip[_], 47)
        end
        Point[_] = RegisterPoint(v, 61, true)
        Point[_].set("Tag", "event")
        Point[_].set("InAreaOnce", function()
            Interact[_] = RegisterPoint(v, 20, true)
            Register[_] = RegisterPoint(v, 60, true)
            Register[_].set("InArea", function()
                if _ == 7 then
                    DrawMarker(1, v - vector3(0, 0, 0.9), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 20.0, 20.0, 2.0, 204, 153, 255, 185, false, true, 2, false, false, false, false)
                else
                    DrawMarker(1, v - vector3(0, 0, 0.9), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 40.0, 40.0, 2.0, 76, 233, 245, 185, false, true, 2, false, false, false, false)
                end
                if #(GetEntityCoords(PlayerPedId()) - v) < 50.0 then
                    if _ == 1 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🚗 Car Location 🚗", 7)
                    elseif _ == 2 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🚗 Car Location 🚗", 7)
                    elseif _ == 3 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🛵 Motor Location 🛵", 7)
                    elseif _ == 4 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🚢 Boat Location 🚢", 7)
                    elseif _ == 5 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🚲 Bicycle Location 🚲", 7)
                    elseif _ == 6 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "🚀 JetPack Location 🚀", 7)
                    elseif _ == 7 then
                        ESX.Game.Utils.DrawText3D(v + vector3(0, 0, 3.5), "⭐ Finish ⭐", 7)
                    end
                end
                if #(GetEntityCoords(PlayerPedId()).xy - v.xy) < 20.0 and _ ~= 7 then
                    if _ == 1 then
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Outlaw" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                            local has, z = GetGroundZFor_3dCoord(v.x, v.y, v.z)
                            local coord = GetEntityCoords(PlayerPedId())
                            if has then
                                ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, z)
                            end
                        end
                    elseif _ == 2 then
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Jester Classic" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                            local has, z = GetGroundZFor_3dCoord(v.x, v.y, v.z)
                            local coord = GetEntityCoords(PlayerPedId())
                            if has then
                                ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, z)
                            end
                        end
                    elseif _ == 3 then 
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "BF400" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        end
                    elseif _ == 4 then 
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Seashark" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        end
                    elseif _ == 5 then 
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Scorcher" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        end
                    elseif _ == 6 then 
                        if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Thruster" then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        end
                    end
                elseif #(GetEntityCoords(PlayerPedId()).xy - v.xy) < 10.0 and _ == 7 and not played then
                    played = true
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        local has, z = GetGroundZFor_3dCoord(v.x, v.y, v.z)
                        local coord = GetEntityCoords(PlayerPedId())
                        if has then
                            ESX.SetEntityCoords(PlayerPedId(), coord.x, coord.y, z)
                        end
                    end
                    TriggerEvent("InteractSound_CL:PlayOnOne", "omid", 1.0)
                    FreezeEntityPosition(PlayerPedId(), true)
                    ExecuteCommand("e dance4")
                    TriggerEvent("Emote:SetBan", true)
                    TriggerEvent("dpclothingAbuse", true)
                    exports.essentialmode:DisableControl(true)
                    SetTimeout(17000, function()
                        FreezeEntityPosition(PlayerPedId(), false)
                        ClearPedTasks(PlayerPedId())
                        TriggerEvent("Emote:SetBan", false)
                        TriggerEvent("dpclothingAbuse", false)
                        exports.essentialmode:DisableControl(false)
                        SetTimeout(2000, function()
                            TeleportThread(vector3(259.3582, -754.4572, 34.62122))
                        end)
                    end)
                    TriggerEvent("MpGameMessage:send", "Good Job", "Mission Passed", 3500, 'success')
                end
            end)
            Interact[_].set("InAreaOnce", function()
                if _ == 1 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Outlaw")
                elseif _ == 2 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Jester Classic")
                elseif _ == 3 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan BF400")
                elseif _ == 4 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Seashark")
                elseif _ == 5 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Scorcher")
                elseif _ == 6 then
                    Hint:Create("Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Thruster")
                end
                Pedaret = RegisterKey("E", false, function()
                    if _ == 1 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Outlaw" then
                            async = true
                            ESX.Game.SpawnVehicle("outlaw", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 595)
                                SetBlipColour(Blip[_+1], 83)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                SetVehicleOnGroundProperly(vehicle)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    elseif _ == 2 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Jester Classic" then
                            async = true
                            ESX.Game.SpawnVehicle("jester3", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 495)
                                SetBlipColour(Blip[_+1], 25)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                SetVehicleOnGroundProperly(vehicle)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    elseif _ == 3 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "BF400" then
                            async = true
                            ESX.Game.SpawnVehicle("bf400", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 471)
                                SetBlipColour(Blip[_+1], 77)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    elseif _ == 4 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Seashark" then
                            async = true
                            ESX.Game.SpawnVehicle("seashark3", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 376)
                                SetBlipColour(Blip[_+1], 59)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                SetVehicleOnGroundProperly(vehicle)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    elseif _ == 5 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Scorcher" then
                            async = true
                            ESX.Game.SpawnVehicle("scorcher", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 597)
                                SetBlipColour(Blip[_+1], 81)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                SetVehicleOnGroundProperly(vehicle)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    elseif _ == 6 then
                        if not async and not IsPedInAnyVehicle(PlayerPedId(), false) and ESX.GetVehicleLabelFromHash(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) ~= "Thruster" then
                            async = true
                            ESX.Game.SpawnVehicle("thruster", GetEntityCoords(PlayerPedId()), 200.0, function(vehicle)
                                RemoveBlip(Blip[_])
                                Blip[_+1] = AddBlipForCoord(Locations[_+1].x, Locations[_+1].y, Locations[_+1].z)
                                SetBlipSprite(Blip[_+1], 546)
                                SetBlipColour(Blip[_+1], 46)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                async = false
                                SetNewWaypoint(Locations[_+1].x, Locations[_+1].y)
                                SetVehicleOnGroundProperly(vehicle)
                                ESX.CreateVehicleKey(vehicle)
                            end)
                        end
                    end
                end)
            end, function()
                Hint:Delete()
                Pedaret = UnregisterKey(Pedaret)
            end)
        end, function()
            if Register[_] then
                Register[_] = Register[_].remove()
            end
            if Interact[_] then
                Interact[_] = Interact[_].remove()
            end
        end)
    end
end

function TeleportThread(crd)
	local coords = crd
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local timeout = 0
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(100)
	end
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	TriggerEvent("esx_inventoryhud:closeHud")
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) and timeout < 3000 do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
		Citizen.Wait(500)
		timeout = timeout + 500
	end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	ESX.SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
	TriggerEvent('es_admin:freezePlayer', true)
	SetEntityHeading(PlayerPedId(), 151.57)
	Wait(1500)
	TriggerEvent("esx_inventoryhud:closeHud")
	TriggerEvent('es_admin:freezePlayer', false)
	DoScreenFadeIn(500)
    TriggerEvent('esx_status:setirs', 'hunger', 1000000)
    TriggerEvent('esx_status:setirs', 'thirst', 1000000)
    TriggerEvent('esx_status:setirs', 'mental', 1000000)
    ESX.SetEntityHealth(PlayerPedId(), 200)
    exports.sr_main:RemoveByTag("event")
    for k, v in pairs(Blip) do
        RemoveBlip(v)
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if GetResourceState("sr_main") == "started" then
            exports.sr_main:RemoveByTag("event")
        end
    end
end)

AddEventHandler("onClientResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if GetResourceState("sr_main") == "started" then
            exports.sr_main:RemoveByTag("event")
        end
    end
end)