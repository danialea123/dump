---@diagnostic disable: unused-local, undefined-field, missing-parameter
ESX = nil 
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

end)

local plateModel = "prop_fib_badge"
local plateModel2 = "prop_fib_badge"
local animDict = "missfbi_s4mop"
local animName = "swipe_card"
local plate_net = nil
local block = false

RegisterNetEvent('idcard:ShowCard')
AddEventHandler('idcard:ShowCard',function(userData, id, Hex)
	if not ESX.Game.DoesPlayerExistInArea(id) then return end
  	SendNUIMessage({
		action = 'sendIdentity',
		userData = userData,
	})
	SetTimeout(5000,function()
		SendNUIMessage({
			action = 'close'
		})
	end)
	TriggerEvent("playernames:AddUser", Hex)
end)

function startAnim()
    RequestModel(GetHashKey(plateModel))
    while not HasModelLoaded(GetHashKey(plateModel)) do
        Citizen.Wait(100)
    end
	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
	ESX.Game.SpawnObject(plateModel,vector3(plyCoords.x, plyCoords.y, plyCoords.z),function(obj)
		local platespawned = obj
		Citizen.Wait(1000)
		local netid = ObjToNet(platespawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		TaskPlayAnim(playerPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
		TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		Citizen.Wait(800)
		AttachEntityToEntity(platespawned, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		plate_net = netid
		Citizen.Wait(3000)
		ClearPedSecondaryTask(playerPed)
		DetachEntity(NetToObj(plate_net), 1, 1)
		ESX.Game.DeleteObject(platespawned)
		plate_net = nil
		Wait(1000)
		block = false
	end)
end

---@diagnostic disable-next-line: undefined-field
RegisterCommand('idcard', function(source, args)
	local target = tonumber(args[1])
	if not target then return end
	if ESX.GetPlayerData().isSentenced or ESX.GetPlayerData().isDead then return end
	if block then return ESX.Alert('Lotan spam nakonid','error') end
	block = true
	SetTimeout(5000, function()
		block = false
	end)
	local fake = false
	if ESX.GetPlayerData().job.name == "fbi" and args[2] == "true" then
		fake = true
	end
	--if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'forces' then
		if GetVehiclePedIsIn(PlayerPedId()) == 0 then
			startAnim()
			TriggerServerEvent('idcard:show', target, fake)
		else
			ESX.ShowNotification('Shoma nemitavanid savar mashin in cmd ra estefade konid')
		end
	--[[else
		ESX.Alert('Shoma nemitavanid az in cmd estefade konid','error')
		block = false
	end]]
end)

TriggerEvent('chat:addSuggestion', '/idcard', 'Show idcard', {
})