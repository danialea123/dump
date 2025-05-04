---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local holdingup = false
local hackholdingup = false
local bombholdingup = false
local bank = ""
local hacked = false
local planted = false
local savedbank = {}
local secondsRemaining = 0
local platingbomb = false
local platingbombtime = 20
local blipRobbery = nil

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function CountTime(con)
	if _G[con] and (secondsRemaining > 0)then
		secondsRemaining = secondsRemaining - 1
		if secondsRemaining == 0 then
			CancelKey = UnregisterKey(CancelKey)
		end
		SetTimeout(1000, function ()
			CountTime(con)
		end)
	end
end

function DisplayTimer(con)
	if _G[con] and (secondsRemaining > 0)then
		if con == 'holdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('robbery_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		elseif con == 'hackholdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('hack_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		elseif con == 'bombholdingup' then
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('bomb_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)
		end

		SetTimeout(0, function ()
			DisplayTimer(con)
		end)
	end
end

RegisterNetEvent('esx_mazebank:currentlyrobbing')
AddEventHandler('esx_mazebank:currentlyrobbing', function(robb)
    holdingup = true
    bank = robb
    secondsRemaining = 600
    CountTime('holdingup')
    DisplayTimer('holdingup')
    Hint:Create(_U('press_to_cancel'))
    CancelKey = RegisterKey('E', false, function ()
        CancelKey = UnregisterKey(CancelKey)
        Hint:Delete()
        TriggerServerEvent('esx_mazebank:toofar', bank)
        TriggerEvent('esx_blowtorch:stopblowtorching')
    end)
    TriggerEvent('esx_blowtorch:startblowtorch')
end)

RegisterNetEvent('esx_mazebank:currentlyhacking')
AddEventHandler('esx_mazebank:currentlyhacking', function(robb, thisbank)
	hackholdingup = true
	ExecuteCommand("e type4")
	SetEntityHeading(PlayerPedId(), 10.23)
	local success = exports['dz-chimpminigame']:StartMinigame(10 --[[solutions]], 90 --[[time in second]])
	opendoors(success)
	savedbank = thisbank
	bank = robb
	secondsRemaining = 600
	CountTime('hackholdingup')
	DisplayTimer('hackholdingup')
end)

RegisterNetEvent('esx_mazebank:plantingbomb')
AddEventHandler('esx_mazebank:plantingbomb', function(robb, thisbank)
	bombholdingup = true
	savedbank = thisbank
	bank = robb
	secondsRemaining = 10
	plantBombAnimation(secondsRemaining)
	CountTime('bombholdingup')
	DisplayTimer('bombholdingup')
	planted = true
end)

function opendoors(success)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerEvent('esx_mazebank:hackcomplete')
	else
		hackholdingup = false
		ESX.ShowNotification(_U('hack_failed'))
		TriggerEvent('mhacking:hide')
		secondsRemaining = 0
		incircle = false
		TriggerServerEvent("esx_mazebank:toofar")
	end
	ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('esx_mazebank:killblip')
AddEventHandler('esx_mazebank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_mazebank:setblip')
AddEventHandler('esx_mazebank:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
	SetTimeout(12*1000*60, function()
		RemoveBlip(blipRobbery)
	end)
end)

RegisterNetEvent('esx_mazebank:toofarlocal')
AddEventHandler('esx_mazebank:toofarlocal', function(robb)
	holdingup = false
	bombholdingup = false
	hacked = false
	planted = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_mazebank:toofarlocalhack')
AddEventHandler('esx_mazebank:toofarlocalhack', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_mazebank:robberycomplete')
AddEventHandler('esx_mazebank:robberycomplete', function(reward)
	holdingup = false
	Hint:Delete()
	CancelKey = UnregisterKey(CancelKey)
	ESX.ShowNotification(_U('robbery_complete', reward))
	TriggerServerEvent('esx_mazebank:closedoor', bank)
	TriggerEvent('esx_blowtorch:stopblowtorching')
	bank = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_mazebank:hackcomplete')
AddEventHandler('esx_mazebank:hackcomplete', function()
	hackholdingup = false
	ESX.ShowNotification(_U('hack_complete'))

	--[[for i=1, Banks[bank].doors do
		TriggerServerEvent('sr_doorlock:updateStateWithScript', bank, i, false)
	end]]

	bank = ""
	hacked = true
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('esx_mazebank:plantbombcomplete')
AddEventHandler('esx_mazebank:plantbombcomplete', function(bank)
	bombholdingup = false


	ESX.ShowNotification(_U('bombplanted_run'))
	TriggerServerEvent('esx_mazebank:plantbombtoall', bank.bombposition.x,  bank.bombposition.y, bank.bombposition.z, bank.bombdoortype)
	incircle = false
end)

RegisterNetEvent('esx_mazebank:plantedbomb')
AddEventHandler('esx_mazebank:plantedbomb', function(x,y,z)
	local coords = {x,y,z}
	local obs, distance = ESX.Game.GetClosestObject('v_ilev_bk_vaultdoor', coords)
    AddExplosion( x,  y, z , 0, 0.5, 1, 0, 1065353216, 0)
    AddExplosion( x,  y, z , 0, 0.5, 1, 0, 1065353216, 0)
	TriggerServerEvent('sr_doorlock:updateStateWithScript', 'PrincipalBank', 2, false)
	local rotation = GetEntityHeading(obs) + 47.2869
	SetEntityHeading(obs,rotation)
	globalbombcoords = coords
	globalbombrotation = rotation
	globalbombDoortype = 'v_ilev_bk_vaultdoor'
	local timer = 900
	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(2000)
			local obs, distance = ESX.Game.GetClosestObject(globalbombDoortype, globalbombcoords)
			SetEntityHeading(obs, globalbombrotation)
			Citizen.Wait(0)
			timer = timer - 2
		end
	end)
end)

Citizen.CreateThread(function()
	--[[for k,v in pairs(Banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 255)--156
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 75)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_robbery'))
		EndTextCommandSetBlipName(blip)
	end]]
	local salam = AddBlipForCoord(-1290.171, -829.7538, 17.14795)
	SetBlipSprite(salam, 500)--156
	SetBlipScale(salam, 0.6)
	SetBlipColour(salam, 25)
	SetBlipAsShortRange(salam, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Maze Bank")
	EndTextCommandSetBlipName(salam)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Banks)do
		local Interact
		local Key
		local Point = RegisterPoint(v.position, 15, true)
		local HInteract
		local HPoint = RegisterPoint(v.hackposition, 15, true)

		Point.set('InArea', function()
			if not holdingup and hacked then
				DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
			end
		end)
	
		Point.set('InAreaOnce', function ()
			Interact = RegisterPoint(v.position, 1, true)
			Interact.set('InAreaOnce', function ()
				if hacked then
					Hint:Create(_U('press_to_rob') .. v.nameofbank)
				end
				Key = RegisterKey('E', false, function ()
					if hacked then
						ESX.DoesHaveItem('blowtorch', 1, function()
							Key = UnregisterKey(Key)
							Hint:Delete()
							TriggerServerEvent('esx_mazebank:rob', k, v.position)
						end, "Blowtorch")
					end
				end)
			end, function ()
				Key = UnregisterKey(Key)
				Hint:Delete()
			end)
		end, function ()
			if holdingup then
				TriggerServerEvent('esx_mazebank:toofar', bank)
			end
			Interact = Interact.remove()
		end)

		HPoint.set('InArea', function()
			if not hackholdingup and not hacked then
				DrawMarker(1, v.hackposition.x, v.hackposition.y, v.hackposition.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
			end
		end)

		HPoint.set('InAreaOnce', function ()
			HInteract = RegisterPoint(v.hackposition, 1, true)
			HInteract.set('InAreaOnce', function ()
				if not hacked then 
					Hint:Create(_U('press_to_hack') .. v.nameofbank)
				end
				Key = RegisterKey('E', false, function ()
					TriggerEvent("gangProp:GetInfo", "rank", function(rank)
						if rank >= 0 then
							if not hacked then
								ESX.DoesHaveItem('net_cracker', 1, function()
									Key = UnregisterKey(Key)
									Hint:Delete()
									TriggerServerEvent('esx_mazebank:hack', k)
								end, "Hacker Laptob")
							end
						else
							ESX.Alert("Gang Shoma Be Level 5 Nareside Ast", "error")
						end
					end)
				end)
			end, function ()
				Key = UnregisterKey(Key)
				Hint:Delete()
			end)
		end, function ()
			HInteract = HInteract.remove()
		end)

		if v.bombposition then
			local BInteract
			local BPoint = RegisterPoint(v.bombposition, 15, true)
			BPoint.set('InArea', function()
				if not bombholdingup and hacked and not planted then
					DrawMarker(1, v.bombposition.x, v.bombposition.y, v.bombposition.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
				end
			end)
			
			BPoint.set('InAreaOnce', function ()
				BInteract = RegisterPoint(v.bombposition, 1, true)
				BInteract.set('InAreaOnce', function ()
					if hacked and not planted then
						Hint:Create(_U('press_to_bomb') .. v.nameofbank)
					end
					Key = RegisterKey('E', false, function ()
						if hacked then
							Key = UnregisterKey(Key)
							Hint:Delete()
							TriggerServerEvent('esx_mazebank:plantbomb', k)
						end
					end)
				end, function ()
					Key = UnregisterKey(Key)
					Hint:Delete()
				end)
			end, function ()
				BInteract = BInteract.remove()
			end)
		end
	end
end)

function plantBombAnimation(timer)
	local playerPed = PlayerPedId()
	TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)

	SetTimeout(timer * 1000, function()
		ClearPedTasksImmediately(playerPed)
	end)
end
