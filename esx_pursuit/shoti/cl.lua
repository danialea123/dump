---@diagnostic disable: undefined-global
local Car = "shooti"
local check = false
local last = vector3(1429.45,6346.89,22.38)
local colors = {a = 112, b = 112, c = 0}
local GlobalVehicle = nil
local GlobalID = nil

Citizen.CreateThread(function()
    while not ESX do
        Citizen.Wait(1000)
    end
    RequestModel(GetHashKey(Car))
    local coords = {
        vector4(853.4,-2437.47,28.0,170.23),
        vector4(48.87,-2566.77,6.0,357.22)
    }
    local Interact = RegisterPoint(vector3(last.x,last.y,last.z), 15, true)
    Interact.set('Tag', 'shoti')
    Interact.set("InArea", function()
        if Are == false then
            DrawMarker(1, last.x,last.y,last.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 10.0, 10.0, 5.0, 3, 119, 252, 200, false, true, 2, false, false, false, false)	
            if IsControlJustReleased(0, 38) then
                Are = true
            end
        end
    end)
    for k, p in pairs(coords) do
		local v = p
		local Key
		local Point = RegisterPoint(vector3(v.x,v.y,v.z), 60, true)
		Point.set('Tag', 'shoti')
		Point.set("InAreaOnce", function()
            GlobalID = k
            ShotitInteract = RegisterPoint(vector3(v.x,v.y,v.z), 2.0, true)
            ShotitInteract.set('Tag', 'shotii')
            ShotitInteract.set("InAreaOnce", function()
				Hint:Delete()
				Hint:Create("Dokme ~INPUT_CONTEXT~ Baraye Shoru Job Shoti")
				Key = UnregisterKey(Key)
				Key = RegisterKey("E", false, function()
                    if GlobalVehicle and not check then 
                        if GetClockHours() >= 1 and GetClockHours() <= 4 then 
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'shoti',
                            {
                                title 	 = 'Start Job Shoti',
                                align    = 'center',
                                question = "Aya Ghasd Start Kardan Job Ra Darid?",
                                elements = {
                                    {label = 'Kheyr', value = nil},
                                    {label = 'Bale', value = true},
                                }
                            }, function(data, menu)
                                if data.current.value then
                                    check = true
                                    menu.close()
                                    Citizen.Wait(math.random(500, 2000))
                                    ESX.TriggerServerCallback("esx_shoti:cooldown", function(cool)
                                        if not cool then
                                            Key = UnregisterKey(Key)
                                            TriggerServerEvent("esx_shoti:Start", k)
                                            DeleteEntity(GlobalVehicle)
                                            GlobalVehicle = nil
                                            ESX.Game.SpawnVehicle(Car, vector3(v.x,v.y,v.z), v.w, function(vehicle) 
                                                ESX.CreateVehicleKey(vehicle)
                                                SetVehicleDirtLevel(vehicle, 0.0)
                                                SetVehicleMaxMods(vehicle, true, colors)
                                                SetVehicleXenonLightsColor(vehicle, 0)
                                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                                SetVehicleSuspensionHeight(vehicle, -0.07)
                                                Are = false
                                                CheackInCars(vehicle, k)
                                                ESX.Alert("Be Maghsad Moshakhas Shode Beravid", "info")
                                                blip = AddBlipForCoord(last.x, last.y, last.z)
                                                SetBlipColour(blip, 46)
                                                SetBlipRoute(blip, true)
                                                SetBlipRouteColour(blip, 46)
                                            end)
                                        else
                                            ESX.Alert("CoolDown Ast", "check")
                                            menu.close()
                                        end
                                        check = false
                                    end, k)
                                else
                                    menu.close()
                                end
                            end)
                        end
                    end
                end)
            end, function()
                Key = UnregisterKey(Key)
                ESX.UI.Menu.CloseAll()
                Hint:Delete()
            end)
            if GetClockHours() >= 1 and GetClockHours() <= 4 then 
                RequestCollisionAtCoord(v.x,v.y,v.z)
                Citizen.Wait(math.random(500, 2000))
                ESX.TriggerServerCallback("esx_shoti:cooldown", function(cool)
                    if not cool then
                        if not DoesCar() then
                            ESX.Game.SpawnLocalVehicle(Car, vector3(v.x,v.y,v.z), v.w, function(vehicle) 
                                RequestCollisionAtCoord(v.x,v.y,v.z)
                                --SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                                SetVehicleDoorsLocked(vehicle, 2)
                                SetVehicleDirtLevel(vehicle, 0.0)
                                SetVehicleMaxMods(vehicle, true, colors)
                                SetVehicleSuspensionHeight(vehicle, -0.07)
                                GlobalVehicle = vehicle
                                GlobalID = k
                                Citizen.Wait(500)
                                FreezeEntityPosition(vehicle, true)
                            end)
                        end
                    end
                end, k)
            end
        end, function()
            Key = UnregisterKey(Key)
			Hint:Delete()
			if ShotiInteract then
				ShotiInteract = ShotiInteract.remove()
			end
            DeleteEntity(GlobalVehicle)
            GlobalVehicle = nil
            GlobalID = nil
		end)
    end
end)

function DoesCar()
    local is = false
    for k, v in pairs(GetGamePool("CVehicle")) do
        local coord = GetEntityCoords(v)
        if #(coord - vector3(853.4,-2437.47,28.0)) <= 3.0 and GetEntityModel(v) == GetHashKey(Car) then
            is = v
            break
        end
        if #(coord - vector3(48.87,-2566.77,6.0)) <= 3.0 and GetEntityModel(v) == GetHashKey(Car) then
            is = v
            break
        end
    end
    return is
end

function CheackInCars(vehicle, k)
	local CancelWarn = 0 
	local Min = 9
	local Sec = 59 
	CreateThread(function()
		while true do 
			Citizen.Wait(1000)
            if Are then
				Sec = 0
				Min = 0
				ESX.ShowMissionText("~g~Remaining Time~g~  ~g~"..Min.."0~g~ : ~g~"..Sec.."0")
				ESX.Alert('~y~ Job Tamam Shod va Padash Ra Daryaft Kardid ', "check")
				TriggerServerEvent('esx_shoti:Success', k)
                DeleteEntity(vehicle)
                GlobalVehicle = nil
                RemoveBlip(blip)
                break
            end
			if GetVehiclePedIsIn(PlayerPedId(),false) ~= vehicle then 
				CancelWarn = CancelWarn  + 1 
				ESX.Alert('Savar Mashin Shavid: Ekhtar ~r~'..CancelWarn , "info")
				if CancelWarn > 9  then 
                    TriggerServerEvent("esx_shoti:Cancel", k)
					ESX.Alert('Job Cancel Shod', "error")
					ESX.ShowMissionText('')
					DeleteEntity(vehicle)
                    GlobalVehicle = nil
                    RemoveBlip(blip)
					break
				end
			else
				CancelWarn = 0 
			end 
			if Min > 9  and Sec > 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~"..Sec)
			elseif Min <= 9  and Sec > 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~0"..Min.."~w~ : ~y~"..Sec)
			elseif Min <= 9  and Sec <= 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~0"..Min.."~w~ : ~y~0"..Sec)
			elseif Min > 9  and Sec <= 9  then 
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~0"..Sec)
			else  
				ESX.ShowMissionText("~r~Remaining Time~w~  ~y~"..Min.."~w~ : ~y~"..Sec)
			end
			Sec = Sec - 1 
			if Sec <= 0  and Min ~= 0 then 
				Sec = 59 
				Min = Min - 1 
			elseif Sec <= 0  and Min == 0 then
                TriggerServerEvent("esx_shoti:Fail", k)
                ESX.Alert('Job Failed Shod', "error")
                ESX.ShowMissionText('')
                DeleteEntity(vehicle)
                GlobalVehicle = nil
                RemoveBlip(blip)
				break
			end
		end 
	end)
end

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

RegisterNetEvent("esx_shoti:started")
AddEventHandler("esx_shoti:started", function(ID)
    if GlobalID and GlobalID == ID then
        exports.sr_main:RemoveByTag("shotii")
        Hint:Delete()
        if GlobalVehicle then
            DeleteEntity(GlobalVehicle)
            GlobalVehicle = nil
        end
    end
end)