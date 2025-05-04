---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global, undefined-field, redundant-parameter
ESX = nil 
local plateModel = "ex_office_swag_guns04"
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
	RequestModel(GetHashKey(plateModel))
	while not HasModelLoaded(GetHashKey(plateModel)) do
		Citizen.Wait(100)
	end
	Citizen.Wait(25000)
	CreateBlip()
	ESX.TriggerServerCallback('bobcat:getCoolDown', function(ColdDown, door) 
		if not ColdDown then 
			ShowMarker()
		end 
		TriggerEvent('DBC:SetMode', door)
	end)
end)

local policealarm, alart = nil
local LObjects  , ObjectsID= {}
local PrivteId = 0 
local blipinfo ={
    { 
        Name = 'BobCat' ,
        Coord = vector3(879.811, -2262.818, 32.43079),
        Color =  60, 
        Sprite =  381, 
		Scale = 0.9 , 
    },	
}
local SpwanLoot = {
	{
	  	Coord = vector3(884.822, -2282.426, 32.43079),
		heading = 73.3,  
	},
	{
		Coord =	vector3(880.5494, -2282.558, 32.43079),
		heading = 171.5 
	},
	{
		Coord = vector3(882.7516, -2287.477, 32.43079),
		heading = 343.14 
	},
}

function CreateBlip()
	CreateThread(function()
		for k, v in pairs(blipinfo) do
		local blip = AddBlipForCoord(v.Coord)
		SetBlipSprite (blip,v.Sprite)
		SetBlipDisplay(blip, 2)
		SetBlipScale  (blip,0.6)
		SetBlipColour (blip,v.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Name)
		EndTextCommandSetBlipName(blip)
		end 
	end)	
end

function ShowMarker()
	exports.sr_main:RemoveByTag("bobcat_main")
	local Key
	local BFirstStartInteract
	local BStartPoint 
	BStartPoint = RegisterPoint( vector3(880.6286, -2264.4, 32.43079), 15, true)
	BStartPoint.set('Tag', 'bobcat_main')
	BStartPoint.set('InArea', function()
		DrawMarker(1,  vector3(880.6286, -2264.4, 31.43079), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
	end)
	BStartPoint.set('InAreaOnce', function()
		BFirstStartInteract = RegisterPoint(vector3(880.6286, -2264.4, 32.43079), 1.0, true)
		BFirstStartInteract.set("Tag", 'bobcat_main')
		BFirstStartInteract.set('InAreaOnce', function()
			Hint:Create('~INPUT_CONTEXT~ Start Robbery')
			Key = RegisterKey('E', false, function()	
				ESX.TriggerServerCallback('DBC:StartRobbery', function(Start) 
					if Start then 
						Key = UnregisterKey(Key)
						Hint:Delete()
						if BFirstStartInteract then
							BFirstStartInteract = BFirstStartInteract.remove()
						end
						if BStartPoint then
							BStartPoint = BStartPoint.remove()
						end
						exports.sr_main:RemoveByTag("BobCat")
						DBC()
					end 
				end)
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if BFirstStartInteract then
			BFirstStartInteract = BFirstStartInteract.remove()
		end
	end)	
end

function DBC()
	ESX.ShowNotification("...فعال کردن بمب")
    thermite(vector3(880.6286, -2264.4, 32.43079), true, 5000)
end 

function thermite(Coords , frist , time ) 
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
        Citizen.Wait(50)
    end
	TriggerEvent("mythic_progbar:client:progress", {name = "bombDBC",duration = 4000,label = 'Dar Hal Gozashtan Bomb...',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
    local ped = PlayerPedId()
	if frist then 
    	SetEntityHeading(ped, 170.52)
	else 
		SetEntityHeading(ped, 82.79)
	end 
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(Coords.x , Coords.y ,Coords.z, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x , Coords.y ,Coords.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)
	while not DoesEntityExist(bomba) do 
		Wait(500) 
		if not DoesEntityExist(bomba) then 
			bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)
		end 
	end  
    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
	DeleteObject(bomba)
	DeleteEntity(bomba)
    Citizen.Wait(time)
	local crd = vector3(880.6418, -2264.572, 32.43079)
	if frist then  
		crd = vector3(880.6418, -2264.572, 32.43079)
	else 
		crd = vector3(890.7956, -2284.826, 32.43079)
	end 
	AddExplosion(crd , 0, 0.5, 1, 0, 1065353216, 0)
    ClearPedTasks(ped)
    DeleteObject(bomba)
	DeleteEntity(bomba)
    StopParticleFxLooped(effect, 0)
	if frist then 
		ESX.ShowNotification("سیستم های امنیتی که باید هک کنید: 1/2 عدد")
		DBCHack()
	end 
end

function DBCHack()
	exports.sr_main:RemoveByTag("bobcat_hacking")
	local BStartPoint
	local Key
	local Interact
	BStartPoint = RegisterPoint(vector3(877.6879, -2264.598, 32.43079), 15, true)
	BStartPoint.set('Tag', 'bobcat_hacking')
	BStartPoint.set('InArea', function()
		DrawMarker(1, vector3(877.6879, -2264.598, 31.43079), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
	end)
	BStartPoint.set('InAreaOnce', function()
		Interact = RegisterPoint(vector3(877.6879, -2264.598, 32.43079), 1.0, true)
		Interact.set("Tag", 'bobcat_hacking')
		Interact.set('InAreaOnce', function()
			Hint:Create('~INPUT_CONTEXT~ To Hack ')
			Key = RegisterKey('E', false, function()	
				thermiteminigame(7, 3, 3, 7,function() -- success
					Key = UnregisterKey(Key)
					Hint:Delete()
					if BStartPoint then
						BStartPoint = BStartPoint.remove()
					end
					if Interact then
						Interact = Interact.remove()
					end
					exports.sr_main:RemoveByTag("bobcat_hacking")
					ESX.ShowNotification("سیستم های امنیتی که باید هک کنید: 2/2 عدد")
					ComputerHack()
				end,function() -- failure
					ESX.ShowNotification('مجدد تلاش کنید')
				end)
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if Interact then
			Interact = Interact.remove()
		end
	end)	
end 

function ComputerHack()
	exports.sr_main:RemoveByTag("bobcat_pc")
	local BStartPoint
	local Key
	local Interact
	local handler
	BStartPoint = RegisterPoint(vector3(874.9978, -2264.36, 32.43079), 15, true)
	BStartPoint.set('Tag', 'bobcat_pc')
	BStartPoint.set('InArea', function()
		DrawMarker(1, vector3(874.9978, -2264.36, 31.43079), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
	end)
	BStartPoint.set('InAreaOnce', function()
		Interact = RegisterPoint(vector3(874.9978, -2264.36, 32.43079), 1.0, true)
		Interact.set("Tag", "bobcat_pc")
		Interact.set('InAreaOnce', function()
			Hint:Create('~INPUT_CONTEXT~ To Hack')
			Key = RegisterKey('E', false, function()	
				Hint:Delete()
				Key = UnregisterKey(Key)
				TriggerEvent('datacrack:start')
			end)
			handler = AddEventHandler('datacrack', function(outcome)
				if outcome then 
					if BStartPoint then
						BStartPoint = BStartPoint.remove()
					end
					if Interact then
						Interact = Interact.remove()
					end
					exports.sr_main:RemoveByTag("bobcat_pc")
					ESX.ShowNotification('درب گاوصندوق را منفجر کنید')
					if handler then
						RemoveEventHandler(handler)
					end
					DBCGavSandoghBomb()
				else
					ESX.ShowNotification('هک موفقیت آمیز نبود')
				end 
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if handler then
			RemoveEventHandler(handler)
		end
		if Interact then
			Interact = Interact.remove()
		end
	end)	
end 

function DBCGavSandoghBomb()
	exports.sr_main:RemoveByTag("bobcat_bomb")
	local BStartPoint
	local Key
	local Interact
	BStartPoint = RegisterPoint(vector3(890.8088, -2284.8, 32.43079), 15, true)
	BStartPoint.set('Tag', 'bobcat_bomb')
	BStartPoint.set('InArea', function()
		DrawMarker(1, vector3(890.8088, -2284.8, 31.43079), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
	end)
	BStartPoint.set('InAreaOnce', function()
		Interact = RegisterPoint(vector3(890.8088, -2284.8, 32.43079), 1.0, true)
		Interact.set("Tag", "bobcat_bomb")
		Interact.set('InAreaOnce', function()
			Hint:Create('~INPUT_CONTEXT~ Start Robbery')
			Key = RegisterKey('E', false, function()	
				Key = UnregisterKey(Key)
				Hint:Delete()
				if BStartPoint then
					BStartPoint = BStartPoint.remove()
				end
				if Interact then
					Interact = Interact.remove()
				end
				TriggerServerEvent('DBC:SetOpenDoor')
				exports.sr_main:RemoveByTag("bobcat_bomb")
				SetTimeout(3000, function()
					TriggerServerEvent("DBC:SendAlarm", true)
					ShowTime(9)
    			end)   
				thermite(vector3(890.5088, -2284.8, 32.43079), false , (10 * 60 * 1000) - 4000) 
			end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
			ESX.UI.Menu.CloseAll()
		end)
	end, function()
		if Interact then
			Interact = Interact.remove()
		end
	end)	
end 

function ShowTime(min)
	local Show = true 
	local Min = min 
	local Sec = 59 
	Citizen.CreateThread(function()
		while Show do 
			Citizen.Wait(1000)
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
			if Sec <= 0 and Min ~= 0 then 
				Sec = 59 
				Min = Min - 1 
			elseif Sec <= 0  and Min == 0 then
				Show = false
				ESX.ShowNotification("درب گاوصندوق باز شد")
				ESX.ShowMissionText("")
			 	TriggerServerEvent("DBC:SendAlarm", false)
				TriggerServerEvent("DBC:SpwanForEveryOne")
			end 
		end 
	end)
end

RegisterNetEvent('DBC:SpwanLoot')
AddEventHandler('DBC:SpwanLoot',function()
	local ALoot
	local Key
	local ALootInteract
	for k,v in pairs(SpwanLoot) do 
		local coords = v.Coord
		ALoot = RegisterPoint(coords, 10, true)
		ALoot.set('Tag', "bobcat_loot_"..k)
		ALoot.set('InArea', function()
			DrawMarker(21, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
		end)
		ALoot.set('InAreaOnce', function()
			ALootInteract = RegisterPoint(coords , 1.0, true)
			ALootInteract.set('Tag', "bobcat_loot_"..k)
			ALootInteract.set('InAreaOnce', function()
				Hint:Create('~INPUT_CONTEXT~ Baray Bardashtan Loot')
				Key = RegisterKey('E', false, function()	
					Key = UnregisterKey(Key)
					Hint:Delete()
	 				if animation(k , "bobcat_loot_"..k) then 
						ClearPedSecondaryTask(PlayerPedId())
						ClearPedTasks(PlayerPedId())
	 				end 
				end)
			end, function()
				Hint:Delete()
				Key = UnregisterKey(Key)
				ESX.UI.Menu.CloseAll()
			end)
		end, function()
			if ALootInteract then
				ALootInteract = ALootInteract.remove()
			end
		end)
	end 
end)

RegisterNetEvent('bobcat:removeClientLoot')
AddEventHandler('bobcat:removeClientLoot',function(name)
	exports.sr_main:RemoveByTag(name)
end) 

function animation(Code, name)
	ESX.TriggerServerCallback('DBC:UseLoot', function(CanUse) 
		if CanUse then 		
			TriggerServerEvent('bobcat:removeLoot', name)
			LoadAnimDict('amb@medic@standing@kneel@base')
			LoadAnimDict('anim@gangops@facility@servers@bodysearch@') 
			ClearPedSecondaryTask(PlayerPedId())
			local playerPed = PlayerPedId()
			TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
			TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false)		
			TriggerEvent("mythic_progbar:client:progress", {name = "s",duration = 5000	,label = 'Bardashtan Loot...',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
			Wait(5 * 1000)
			ClearPedSecondaryTask(PlayerPedId())
			ClearPedTasks(PlayerPedId())
			ESX.SetEntityCoords(PlayerPedId() , GetEntityCoords(PlayerPedId()))
			Wait(1000)
			return true 
		else 
			return false  
		end 
	end, Code)
end 

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end	

RegisterNetEvent('DBC:Remove_Main')
AddEventHandler('DBC:Remove_Main',function()
	exports.sr_main:RemoveByTag("bobcat_main")
end)

RegisterNetEvent('DBC:PoliceAlarm')
AddEventHandler('DBC:PoliceAlarm', function()
	policealarm = AddBlipForCoord( vector3(879.811, -2262.818, 32.43079))
	SetBlipSprite(policealarm, 161)
	SetBlipScale(policealarm , 1.0)
	SetBlipColour(policealarm, 3)
	PulseBlip(policealarm)
end)

RegisterNetEvent('DBC:PoliceAlarmRemove')
AddEventHandler('DBC:PoliceAlarmRemove', function()
	RemoveBlip(policealarm)
end)

RegisterNetEvent('DBC:SetMode')
AddEventHandler('DBC:SetMode',function(Mode)
	if Mode then 
		local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
		ActivateInteriorEntitySet(interiorid, "np_prolog_broken")
		RemoveIpl(interiorid, "np_prolog_broken")
		DeactivateInteriorEntitySet(interiorid, "np_prolog_clean")
		RefreshInterior(interiorid)
	else 
		local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
		ActivateInteriorEntitySet(interiorid, "np_prolog_clean")
		RemoveIpl(interiorid, "np_prolog_clean")
		DeactivateInteriorEntitySet(interiorid, "np_prolog_broken")
		RefreshInterior(interiorid)
	end 
end)

RegisterNetEvent("bobcat:BackupThings")
AddEventHandler("bobcat:BackupThings", function()
	ShowMarker()
	TriggerEvent('DBC:SetMode', false)
end)