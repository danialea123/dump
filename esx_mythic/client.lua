---@diagnostic disable: lowercase-global, undefined-global, param-type-mismatch, missing-parameter, undefined-field
ESX = nil
PlayerData = {}
local pedList = {}
local cam = nil
local name = ''
local inMenu = false
local hasEntered = false
local lester
local Missionhack = false
local inGameh = false
local DoorM = false
local inlockgame = false
local inrob = false
local cancel = false 
local Device  = false
CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(1)
	end
	
end)

CreateThread(function()
local pedInfo = {}
local camCoords = nil
local camRotation = nil
for k, v in pairs(Config.TalkToNPC) do
		RequestModel(GetHashKey(v.npc))
		while not HasModelLoaded(GetHashKey(v.npc)) do
			Wait(1)
		end
		lester =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.heading, false, true)
		SetEntityHeading(lester, v.heading)
		FreezeEntityPosition(lester, true)
		SetEntityInvincible(lester, true)
		SetBlockingOfNonTemporaryEvents(lester, true)
		TaskStartScenarioInPlace(lester, "WORLD_HUMAN_MUSICIAN", 0, true)
		pedInfo = {
			name = v.name,
			model = v.npc,
			pedCoords = v.coordinates,
			entity = lester,
			camCoords = camCoords,
			camRotation = camRotation,
		}

		table.insert(pedList, pedInfo)
	end
	
local blip = AddBlipForCoord(vector3(2435.13,4965.15,40.35))
SetBlipSprite (blip,78)
SetBlipDisplay(blip, 2)
SetBlipScale  (blip,0.6)
SetBlipColour (blip,1)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Mythic")
EndTextCommandSetBlipName(blip)
Wait(1)
end)
RegisterKey("E", false, function()
		for k,v in pairs(Config.TalkToNPC) do
			inMenu = true
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),v.coordinates,true) > 3.0 then
            return 
			end
		
			Wait(500)
			if Config.HideMinimap then
				DisplayRadar(false)
			end
		
	     	TriggerServerEvent("ESXMythic:StartRob")

	end
end)
RegisterNUICallback('start', function(data, cb)
	DisplayRadar(true)
	SetNuiFocus(false, false)
	TriggerServerEvent("ESXMythic:Remove")
	intro()
	
end) --ESCAPE
RegisterKey("ESCAPE", false, function()
	SendNUIMessage({
		message	= "close"
	})
	DisplayRadar(true)
	SetNuiFocus(false, false)

	
end)
------------------------
-------functions
------------------------



function RemainingTime(min,mission,pos,distance,ve2,loot)
local Seceonds = 59
local inroad = true 
local Minutes  = tonumber(min)
local Mission = tostring(mission)
local Pos = pos
local dis = tonumber(distance)
local Vector2 = ve2
CreateThread(function()
while inroad  == true do
if cancel == true then 
	inroead = false
	ESX.ShowMissionText("~r~Remaining Time : ~y~ Cancel Shod")
	cancel = false
	return 
end 
if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Pos,true) < dis then
	ESX.Alert("~g~Shoma Be Mahal Mored Nazar Residid")
    inroad  = false 
	if Mission == "one" then 
		Missionhack = true
	
	elseif Mission == "lock" then 
		DoorM = true
		TriggerServerEvent("ESXMythic:SyncDoors",true)
	elseif Mission == "last" then 
		Device = true 
	end
	break
		   else
if Seceonds < 10 then
	ESX.ShowMissionText("~r~Remaining Time : ~y~"..Minutes.."~w~:~y~0"..Seceonds)
	if Seceonds == 0 then
	if Minutes == 0 and Seceonds == 0 then
	if loot == nil then 
	ESX.ShowMissionText("~r~Zaman Be Payan Resid ")
	else 
		ESX.ShowMissionText("~g~Robbery Completed")
	end
	 inroad  = false 
	break
	        else
	Minutes = Minutes - 1
	Seceonds = 60
	    end
	end 
			else
	if Vector2 ~= nil then 
	SetNewWaypoint(Vector2)
	end 
    ESX.ShowMissionText("~r~Remaining Time~w~ : ~y~"..Minutes.."~w~:~y~"..Seceonds)
	end
	Seceonds = Seceonds - 1
	Wait(1000)
		    end
		end
	end)

end

function setCoords(visbale,ve3,heading)
	SetEntityVisible(GetPlayerPed(-1), visbale,visbale)
	ESX.SetEntityCoords(GetPlayerPed(-1),ve3,false,false)
	SetEntityHeading(GetPlayerPed(-1),heading)
end 
function PlayerLoad()
RequestAnimDict("cellphone@") while (not HasAnimDictLoaded("cellphone@")) do Wait(1) end
RequestAnimDict("mp_prison_break") while (not HasAnimDictLoaded("mp_prison_break")) do Wait(1) end
end 
function ShowScreenMsg(MsgText, setCounter)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString(MsgText)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()	
	local counter = 0
	local maxCounter = (setCounter or 200)
	while counter < maxCounter do
		counter = counter + 1
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(0)
	end
end

function intro()
	DeleteEntity(lester)
inrob = true 
incamra = true
local ped = PlayerPedId()
    RequestCutscene("heist_int", 8)
    while not (HasCutsceneLoaded()) do
        Wait(0)
        RequestCutscene("heist_int", 8)
    end
	TriggerEvent('esx_ShopRobbery:SaveCutsceneClothes') 
    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_1', 0, 0, 64)
    StartCutscene(0)
	while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
	end
	SetCutscenePedComponentVariationFromPed(PlayerPedId(), GetPlayerPed(-1), 1885233650)
	SetPedComponentVariation(GetPlayerPed(-1), 11, jacket_old, jacket_tex, jacket_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 8, shirt_old, shirt_tex, shirt_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 3, arms_old, arms_tex, arms_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 4, pants_old,pants_tex,pants_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 6, feet_old,feet_tex,feet_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 1, mask_old,mask_tex,mask_pal)
	SetPedComponentVariation(GetPlayerPed(-1), 9, vest_old,vest_tex,vest_pal)
	SetPedPropIndex(GetPlayerPed(-1), 0, hat_prop, hat_tex, 0)
	SetPedPropIndex(GetPlayerPed(-1), 1, glass_prop, glass_tex, 0)
    while (IsCutscenePlaying()) do
        Wait(0)
    end
ClearPedTasks(PlayerPedId())
DoScreenFadeIn(1000)
DoScreenFadeOut(1000)
Wait(2000)
setCoords(false,vector3(717.49,-977.86,24.12),189.11)
Wait(3000)
incamra = false
DoScreenFadeIn(1000)				
SetEntityVisible(GetPlayerPed(-1), true,true)
Wait(1000)
TaskStartScenarioInPlace(lester, "WORLD_HUMAN_MUSICIAN", 0, true)
HackMision()
for k, v in pairs(Config.TalkToNPC) do
	RequestModel(GetHashKey(v.npc))
	while not HasModelLoaded(GetHashKey(v.npc)) do
		Wait(1)
	end
	lester =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.heading, false, true)
	SetEntityHeading(lester, v.heading)
	FreezeEntityPosition(lester, true)
	SetEntityInvincible(lester, true)
	SetBlockingOfNonTemporaryEvents(lester, true)
	TaskStartScenarioInPlace(lester, "WORLD_HUMAN_MUSICIAN", 0, true)
	pedInfo = {
		name = v.name,
		model = v.npc,
		pedCoords = v.coordinates,
		entity = lester,
		camCoords = camCoords,
		camRotation = camRotation,
	}

	table.insert(pedList, pedInfo)
end
end 

function HackMision()
	ShowHelps()
	ShowScreenMsg("~y~ be Makan ~r~Mark~y~ Shode Beravid",200)
	RemainingTime(9,"one",vector3(1275.89,-1710.64,54.77),5.0,vector2(1275.89,-1710.64),nil)
end 

RegisterKey("E", false, function()
	if Missionhack == true then  
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),vector3(1275.89,-1710.64,54.77),true) > 2.0 then return end 
		if inGameh == false then 
			inGameh = true 
			ActivateHackCitizenMythic(true)
	    end
    end
end)

function ActivateHackCitizenMythic(mtwo)
 	if mtwo == true then 
		TaskPlayAnim(PlayerPedId(),"mp_prison_break","hack_loop", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		SetEntityHeading(GetPlayerPed(-1),298.58)
		TriggerEvent("utk_fingerprint:Start", 4, 3, 3, function(outcome)
			if outcome == true then 
				inGameh = false
				ClearPedTasks(PlayerPedId())
				Wait(5000)
				ESX.ShowMissionText('Ertbat Radio Matnghe ~r~Mamnoe ~w~ Ghate Shod')
				ShowScreenMsg("~y~ Hack Completed",100)
				Missionhack = false
				Wait(3000)
				DoScreenFadeIn(1000)
				DoScreenFadeOut(1000)
				Wait(1000)
				setCoords(false,vector3(1276.76,-1724.76,54.65),196.76)
				Wait(3000)
				DoScreenFadeIn(1000)
				SetEntityVisible(GetPlayerPed(-1), true,true)
				Wait(1000)
				LockMissionTwo()
				Missionhack = false 
			elseif outcome == false then 
				inGameh = false
				ClearPedTasks(PlayerPedId())
				ESX.ShowMissionText('~r~ Mojadad Talash Konid')
			end 
		end)
 	end 
end 

function LockMissionTwo()
	ShowScreenMsg("~y~ Be Khone ~r~M~y~ Beravid",100)
	TriggerServerEvent("ESXMythic:SyncDoors",true)
	RemainingTime(9,"lock",vector3(2435.6,4975.99,46.57),5.0,vector2(2435.6,4975.99),nil)
end

RegisterKey("E", false, function()
	if DoorM == true then 
		if inlockgame == true then return end 
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),vector3(2435.6,4975.99,46.57),true) > 2.0 then return end 
		DoorRobMisiontwo(true)
	end 
end)

function DoorRobMisiontwo(mdoor)
	if mdoor == true then 
		local res = exports['esx_mythic']:creategh({math.random(1,2),math.random(3,4),math.random(5,6),math.random(7,8)})
		if res == true then
			TriggerServerEvent("ESXMythic:SyncDoors",false)
			DoorM = false	
			inlockgame = false
			ShowScreenMsg("~y~ mission ~r~UnLock~y~ Door completed",100)
			foundConsole()
		elseif res == false then
			inlockgame = false
			ESX.ShowMissionText("~r~ RAMZ Eshtbah Ast")
		end
	end
end 

function foundConsole()
	ShowScreenMsg("~y~ Dastgah Ro Peyda Konid",200)
    RemainingTime(5,"last",vector3(2432.558, 4963.358, 42.62488),3.0,nil,nil)
end 

inDevice = false

AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if Device  == true then 
			if inDevice  == true then return end 
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),vector3(2432.426, 4963.385, 42.62488),true) > 2.0 then return end 
			RunDiv(true)
		end 
	end 
end)

function RunDiv(mt)
	if mt == true then 
		StartComputer()
		inDevice = true
	end
end 

RobberyDevice = function()
    inhouse = true  
	inrob = false
	TriggerServerEvent("ESXMythic:Alarm",true)
	RemainingTime(14,nil,vector3(1.1,1.1,1.1),1,nil,true)
	exports.sr_main:RemoveByTag("MythicShowHelps")
	CreateThread(function()
		while inhouse == true  do
			Wait(5000)
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),vector3(2435.13,4965.15,40.35),true)  >  20.0 then 
				inhouse = false
				TriggerServerEvent("ESXMythic:Alarm",nil)
				ESX.Alert("~r~ Mythic Cancel Shod")
				cancel = true 
				return
			end
		end 
	end)
	SetTimeout(15*60000,function()
		if inhouse == true then
			TriggerServerEvent("ESXMythic:Alarm",false)
			TriggerServerEvent("ESXMythic:giveloot")
			inhouse = false 
		end 
	end)
end 

RegisterNetEvent("ESXMythic:PlayIntro")
AddEventHandler("ESXMythic:PlayIntro",function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		message	= "open"
	})
end)

local blipmythic 

RegisterNetEvent('ESXMythic:PoliceAlarm')
AddEventHandler('ESXMythic:PoliceAlarm', function()
	blipmythic = AddBlipForCoord(vector3(2435.13,4965.15,40.35))
	SetBlipSprite(blipmythic, 161)
	SetBlipScale(blipmythic , 1.0)
	SetBlipColour(blipmythic, 3)
	PulseBlip(blipmythic)
end)

RegisterNetEvent('ESXMythic:PoliceAlarmRemove')
AddEventHandler('ESXMythic:PoliceAlarmRemove', function()
	RemoveBlip(blipmythic)
end)

RegisterNetEvent("Sync:Doors")
AddEventHandler("Sync:Doors",function(Doorss)
	local doortype = GetHashKey("v_ilev_fh_frntdoor")
	local coords = vector3(2435.429,4975.025,46.90218)
	local obs = GetClosestObjectOfType(coords, 10.0, doortype)
	local rotation = GetEntityHeading(obs) --+ 47.0
	local rotationnum = 0.0
	local OpenDoorHeading = 100.0
	local Doorss = Doorss
	CreateThread(function()
		Wait(0)
		if Doorss == true then --- true = close
			SetEntityHeading(obs,230.0)
			FreezeEntityPosition(obs,true)
		elseif Doorss == false then
			FreezeEntityPosition(obs,false)
		end
	end)
end)

AddEventHandler("playerSpawned",function()
	Wait(30000)
	PlayerLoad()
end)

AddEventHandler('onClientResourceStart', function (resourceName)
	if(GetCurrentResourceName() ~= resourceName) then
	  	return
	end
	Wait(3000)
	PlayerLoad()
end)

local AllHelpPos = { 
	vector3(1275.89,-1710.64,54.77),
	vector3(2435.789, 4975.991, 46.56775),
	vector3(2432.387, 4963.583, 42.62488),
}

function ShowHelps()
	local Point
	local Interact
	local Key
	for k,v in pairs(AllHelpPos) do 
		Point = RegisterPoint(v, 5, false)
		Point.set("Tag", "MythicShowHelps")
		Point.set("InArea", function()
			DrawMarker(21,v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 50, false, true, 2,true, nil, false)
		end)
	end 
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)