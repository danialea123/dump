ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local petting = false
local soundplaying = false
local CatLoc =  Config.Cats  
local Pedsloction = {}
pedaret = {}
function DrawText3D(x, y, z, text, scale)
    SetTextScale(0.35, 0.35)
	SetTextFont(8)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 300
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 155)
	ClearDrawOrigin()
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function catsound()
	if soundplaying == false then
		soundplaying = true
		SendNUIMessage({
			command = "play",
			file = 'cat',
		})
	end
end

function pet(k)
	if pedaret[k] then
		TriggerEvent("onKeyDown", "lcontrol")
	end
	ESX.SetPlayerData('isSentenced', true)
	TriggerEvent("Emote:SetBan", true)
	TriggerEvent("dpclothingAbuse", true)
	exports.essentialmode:DisableControl(true)
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local animation = "machinic_loop_mechandplayer"
	loadAnimDict(animDict)
	local animLength = GetAnimDuration(animDict, animation)
	Wait(1500)
	petting = true
	FreezeEntityPosition(PlayerPedId(), true)
	TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 49, 0, 0, 0, 0)
	Wait(1500)
	catsound()
	Wait(Config.PetCatDuration)
	IncrStress()
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	petting = false
	soundplaying = false
	ESX.SetPlayerData('isSentenced', false)
	TriggerEvent("Emote:SetBan", false)
	TriggerEvent("dpclothingAbuse", false)
	exports.essentialmode:DisableControl(false)
end

function IncrStress() 
	TriggerEvent('esx_status:add', 'mental', 50000)
end 

--[[Citizen.CreateThread(function()
    while true do
		local sleep = 100
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
		for k,v in pairs(Pedsloction) do 
			local EntityCoords = GetEntityCoords(v)
			local distance = GetDistanceBetweenCoords(EntityCoords, playerCoords, true)
			if distance <= 1.2 and petting == false then
				sleep = 0
				DrawText3D(EntityCoords.x , EntityCoords.y , EntityCoords.z ,'[~g~E~w~] - Pet the cat')
				if IsControlJustPressed(1, 38) then
					TaskTurnPedToFaceEntity(player, v, 5000)
					pet(k)
				end
			end
		end 
		Citizen.Wait(sleep)
    end
end)]]

Citizen.CreateThread(function()
	for k,v in pairs(CatLoc) do
		RequestModel(v[7])
		while not HasModelLoaded(v[7]) do
			Wait(500)
		end
		RequestAnimDict("amb@lo_res_idles@")
		while not HasAnimDictLoaded("amb@lo_res_idles@") do
			Wait(500)
		end
		Pedsloction[k] = CreatePed(4, v[7],v[1],v[2],v[3]-1, 3374176, false, true)
		exports['diamond_target']:AddTargetEntity({Pedsloction[k]}, {
			options = {
                {
                    icon = "fa-solid fa-cat",
                    label = "نوازش کردن",
                    action = function(_)
						pet(k)
                    end,
                },
			},
            distance = 2.0
        })
		SetEntityHeading(Pedsloction[k], v[5])
		FreezeEntityPosition(Pedsloction[k], true)
		SetEntityInvincible(Pedsloction[k], true)
		SetBlockingOfNonTemporaryEvents(Pedsloction[k], true)
		TaskPlayAnim(Pedsloction[k],"amb@lo_res_idles@","creatures_world_cat_ground_sleep_lo_res_base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		if v[8] then
			pedaret[k] = true
		end
	end
end)