---@diagnostic disable: param-type-mismatch, undefined-global, undefined-field, lowercase-global
SR = nil
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

hacking_check, hacking_complete, virus_importing, virus_imported = false, false, false, false
local blipRobbery = nil
local NotifiText = ""
local secondsRemaining = -1

Citizen.CreateThread(function()
	while SR == nil do
		TriggerEvent('esx:getSharedObject', function(obj) SR = obj end)
		Citizen.Wait(0)
	end
	ESX = SR
end)

function DrawSubText(x, y, width, height, scale, text, r, g, b, a, outline)
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

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  	RequestAnimDict(dict)
	  	Wait(10)
	end
end

function Initialize(scale, text)
	local scaleform = RequestScaleformMovie(scale)

    while not HasScaleformMovieLoaded(scaleform) do
        Wait(1)
	end

    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(text)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

RegisterNetEvent('sr_lirobbery:setblip')
AddEventHandler('sr_lirobbery:setblip', function()
    blipRobbery = AddBlipForCoord(Config.Blip)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
	SetTimeout(12*60*1000, function()
		RemoveBlip(blipRobbery)
	end)
end)

AddEventHandler('sr:ShowBigWhisper', function(color, message, time)
	local KillWhisper = false
	local WhisperMessage = string.format("~%s~%s",  string.lower(color), message)
    local scaleform = Initialize("mp_big_message_freemode", WhisperMessage)
	PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)
	local function ShowBigWhisper()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		if not KillWhisper then
			SetTimeout(0, ShowBigWhisper)
		end
	end
	SetTimeout(time or (1000*10), function()
		KillWhisper = true
	end)
    ShowBigWhisper()
end)

RegisterNetEvent('sr_lirobbery:killblip')
AddEventHandler('sr_lirobbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Blip)

	SetBlipSprite(blip, 77)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 40)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Robbery.robbery_name)
	EndTextCommandSetBlipName(blip)
end)

function TimerT(cb, con)
	secondsRemaining = secondsRemaining - 1
	if secondsRemaining == 0 then
		cb()
	end
	if secondsRemaining > 0 and _G[con] then
		SetTimeout(1000, function()
			TimerT(cb, con)
		end)
	end
end

incircle = false

-- Importing Virus | Start Rob
CreateThread(function()
	local virus_coords = Config.Robbery.virus_position
	local Interact
	local Key
	local Point = RegisterPoint(virus_coords, 15, true)
	Point.set('InArea', function ()
		if not virus_importing and not virus_imported then
			DrawMarker(1, virus_coords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
		end
	end)
	Point.set('InAreaOnce', function ()
		Interact = RegisterPoint(virus_coords, 1.2, true)
		Interact.set('InAreaOnce', function ()
			if not virus_importing then
				Hint:Create(_U('press_to_importing'))
				Key = RegisterKey('E', false, function ()
					Key = UnregisterKey(Key)
					Hint:Delete()
					local PData = SR.GetPlayerData().job
					if not ((PData.name == 'police' or PData.name == 'sheriff' or PData.name == 'fbi' or PData.name == 'ambulance' or PData.name == 'justice') and PData.grade > 0) then
						--TriggerEvent("gangProp:GetInfo", "rank", function(rank)
							--if rank >= 0 then
								SR.TriggerServerCallback('sr_lirobbery:checkRobbery', function(robbery_status)
									if not robbery_status then
										local playerPos = GetEntityCoords(PlayerPedId())
										ESX.DoesHaveItem('net_cracker', 1, function()
											TriggerServerEvent('sr_lirobbery:check_importing', GetStreetNameFromHashKey(GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)))
										end, "Hacker Laptob")
									else
										SR.ShowHelpNotification(_U('robbery_in_progress'), false, true, 3000)
									end
								end)
							--[[else
								SR.Alert("Gang Shoma Be Level 3 Nareside Ast", "error")
							end]]
						--end)
					else
						SR.Alert(_U('onduty_warning'), "error")
					end
				end)
			end
		end, function ()
			Key = UnregisterKey(Key)
			Hint:Delete()
		end)
	end, function ()
		Interact = Interact.remove()
	end)
end)

function DisplayTimer(con)
	if _G[con] and (secondsRemaining > 0)then
		if con == 'virus_importing' then
			DrawSubText(0.66, 1.44, 1.0, 1.0, 0.4, _U('importing_timer', secondsRemaining), 255, 255, 255, 255)
		elseif con == 'hackholdingup' then
			DrawSubText(0.66, 1.44, 1.0, 1.0, 0.4, _U('importing_timer', secondsRemaining), 255, 255, 255, 255)
		elseif con == 'bombholdingup' then
			DrawSubText(0.66, 1.44, 1.0, 1.0, 0.4, _U('importing_timer', secondsRemaining), 255, 255, 255, 255)
		end

		SetTimeout(0, function()
			DisplayTimer(con)
		end)
	end
end

RegisterNetEvent('sr_lirobbery:importing')
AddEventHandler('sr_lirobbery:importing', function()
	SR.ShowHelpNotification(_U('starting_import'), false, true, 3000)
	SR.ShowAdvancedNotification(Config.Robbery.robbery_name, '~g~STARTED', _U('start_rob_notifi'), 'CHAR_LIFEINVADER', 8, false, false, 140)
	virus_importing = true
	local Point = RegisterPoint(vector3(-1076.55, -239.88, 38.57), 29, true)
	Point.set('OutAreaOnce', function ()
		if virus_importing then
			virus_importing = false
			virus_imported = false
			TriggerServerEvent('sr_lirobbery:toofarVirus')
			SR.Alert(_U('toofar_from_robbery'), "info")
		end
	end, function ()
		Point = Point.remove()
	end)

	secondsRemaining = Config.TimeImportVirus
	TimerT(function ()
		TriggerEvent('sr_lirobbery:importingComplete')
		TriggerEvent('sr:ShowBigWhisper', 'y', "VIRUS IMPORTED", 3000)
	end, 'virus_importing')
	DisplayTimer('virus_importing')
end)

function TimeToHack()
	DrawSubText(0.66, 1.44, 1.0, 1.0, 0.4, _U('time_to_hack', secondsRemaining), 255, 255, 255, 255)
	if not hacking_check and virus_imported and not hacking_complete then
		SetTimeout(0, TimeToHack)
	end
end

RegisterNetEvent('sr_lirobbery:importingComplete')
AddEventHandler('sr_lirobbery:importingComplete', function()
	secondsRemaining = -1
	incircle = false
	virus_importing = false
	virus_imported = true
	TimeToHack()
	secondsRemaining = Config.TimeToHack
	TimerT(function ()
		hacking_check = false
		hacking_complete = false
		virus_imported = false
		virus_importing = false
		TriggerServerEvent('sr_lirobbery:missionCancelled', true)
		TriggerEvent('sr:ShowBigWhisper', 'r', "MISSION FAILED", 3000)
	end, 'virus_imported')
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	SR.Alert(_U('virus_imported'), "check")
	TriggerServerEvent('sr_lirobbery:complete_importing')
end)

-- Hacking
Citizen.CreateThread(function()
	local hack_coords = Config.Robbery.hack_position
	local Interact
	local Key
	local Point = RegisterPoint(hack_coords, 15, true)
	Point.set('InArea', function()
		if not hacking_check and virus_imported and not hacking_complete then
			DrawMarker(1, hack_coords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
		end
	end)

	Point.set('InAreaOnce', function()
		Interact = RegisterPoint(hack_coords, 1.2, true)
		Interact.set('InAreaOnce', function()
			if not hacking_check and virus_imported and not hacking_complete then
				Hint:Create(_U('press_to_hack'))
				Key = RegisterKey('E', false, function()
					ESX.DoesHaveItem('net_cracker', 1, function()
						UnregisterKey(Key)
						Hint:Delete()
						ClearPedTasks(PlayerPedId())
						LoadAnim('mp_fbi_heist')
						ESX.SetEntityCoords(PlayerPedId(), -1053.77, -230.59, 43.02, false, false, false, false)
						SetEntityHeading(PlayerPedId(), 212.18)
						TaskPlayAnim(PlayerPedId(), 'mp_fbi_heist', 'loop', 2.0, 2.0, -1, 1, 0, false, false, false)
						TriggerServerEvent('sr_lirobbery:check_haking')
					end, "Hacker Laptob")
				end)
			end
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
		end)
	end, function()
		Interact = Interact.remove()
	end)
end)

RegisterNetEvent('sr_lirobbery:hacking')
AddEventHandler('sr_lirobbery:hacking', function()
	secondsRemaining = -1
	virus_imported = false
	hacking_check = true
	local Point = RegisterPoint(Config.Robbery.hack_position, 5, true)
	Point.set('OutAreaOnce', function()
		if hacking_check then
			virus_importing = false
			virus_imported = false
			hacking_check = false
			hacking_complete = false
			TriggerServerEvent('sr_lirobbery:toofarHack')
			SR.Alert(_U('toofar_from_robbery'), "info")
		end
		Point.remove()
	end)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", Config.CharHack, Config.TimeHack, hack_response)
	TriggerEvent("bur_nui_var:open")
	SR.Alert(_U('start_hack'), "check")
end)

AddEventHandler("esx_lirobbery:hackResult", function(status)
	hack_response(status)
end)

function hack_response(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(PlayerPedId())
		TriggerServerEvent('sr_lirobbery:hackComplete', true)
		hacking_complete = true
		local Point = RegisterPoint(Config.Robbery.lose_area, Config.LoseAreaDistance, false)
		Point.set('OutAreaOnce', function()
			if endrob then
				secondsRemaining = -1
				hacking_check = false
				hacking_complete = false
				virus_imported = false
				virus_importing = false
				incircle = false
				TriggerServerEvent('sr_lirobbery:missionCancelled', false)
				SR.Alert(_U('robbery_failed'), "check")
			end
			Point.remove()
		end, function()
			Point.remove()
		end)
		hacking_check = false
		TriggerServerEvent('sr_doorlock:updateStateWithScript', 'RobberyDoor', 1, false)
		SR.Alert(_U('hack_complete'), "check")
	else
		hacking_check = false
		hacking_complete = false
		virus_imported = false
		virus_importing = false
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(PlayerPedId())
		TriggerServerEvent('sr_lirobbery:missionCancelled', true)
		SR.Alert(_U('hack_failed'), "error")
		TriggerEvent('mhacking:hide')
		incircle = false
	end
end

-- Blowtorch | End Rob
Citizen.CreateThread(function()
	local blow_coords = Config.Robbery.blowtorch_position
	local Interact
	local Key
	local Point = RegisterPoint(blow_coords, 15, true)
	Point.set('InArea', function()
		if not endrob then
			DrawMarker(1, blow_coords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
		end
	end)
	Point.set('InAreaOnce', function()
		Interact = RegisterPoint(blow_coords, 1.2, true)
		Interact.set('InAreaOnce', function()
			if not endrob then
				Hint:Create(_U('press_to_blowtorch'))
				Key = RegisterKey('E', false, function()
					local PData = SR.GetPlayerData().job
					if not ((PData.name == 'police' or PData.name == 'sheriff' or PData.name == 'fbi' or PData.name == 'ambulance' or PData.name == 'justice') and PData.grade > 0) then
						SR.TriggerServerCallback('sr_lirobbery:checkRobbery', function(robbery_status)
							if robbery_status then
								SR.TriggerServerCallback('sr_lirobbery:checkHacking', function(hacking_status)
									if hacking_status then
										ESX.DoesHaveItem('blowtorch', 1, function()
											Hint:Delete()
											Key = UnregisterKey(Key)
											TriggerServerEvent('sr_lirobbery:check_blowtorching')
										end, "Blowtorch")
									else
										SR.Alert(_U('not_hacked_complete'), "error")
									end
								end)
							else
								SR.Alert(_U('robbery_not_in_progress'), "error")
							end
						end, true)
					else
						SR.Alert(_U('onduty_warning'), "info")
					end
				end)
			end
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
		end)
	end, function()
		Interact = Interact.remove()
	end)
end)

function EndRobThread()
	if endrob then
		DisableControlAction(0, Keys['F1'], true)
		DisableControlAction(0, Keys['F2'], true)
		DisableControlAction(0, Keys['F3'], true)
		DisableControlAction(0, Keys['F5'], true)
		DisableControlAction(0, Keys['R'], true)
		DisableControlAction(0, Keys['T'], true)
		DisableControlAction(0, Keys['W'], true)
		DisableControlAction(0, Keys['S'], true)
		DisableControlAction(0, Keys['A'], true)
		DisableControlAction(0, Keys['D'], true)
		DisableControlAction(0, Keys['X'], true)
		DisableControlAction(0, Keys['TAB'], true)
		DisableControlAction(0, Keys['SPACE'], true)
		DisableControlAction(0, 24, true)
		DisableControlAction(0, 257, true)
		DisableControlAction(0, 25, true)
		DisableControlAction(0, 47, true)
		DisableControlAction(0, 264, true)
		DisableControlAction(0, 257, true)
		DisableControlAction(0, 140, true)
		DisableControlAction(0, 141, true)
		DisableControlAction(0, 142, true)
		DisableControlAction(0, 143, true)
		DisableControlAction(0, 263, true)
		DisableControlAction(0, 27, true)
		FreezeEntityPosition(PlayerPedId(), true)
		DrawSubText(0.66, 1.44, 1.0, 1.0, 0.4, _U('blowtorching', secondsRemaining), 255, 255, 255, 255)
		SetTimeout(0, EndRobThread)
	end
end

RegisterNetEvent('sr_lirobbery:torching')
AddEventHandler('sr_lirobbery:torching', function()
	endrob = true
	EndRobThread()
	local Point = RegisterPoint(Config.Robbery.blowtorch_position, 29, true)
	Point.set('OutAreaOnce', function ()
		if endrob then
			virus_imported = false
			virus_importing = false
			hacking_check = false
			hacking_complete = false
			endrob = false
			TriggerEvent('esx_blowtorch:stopblowtorching')
			TriggerServerEvent('sr_lirobbery:toofarBlowtorch')
			SR.Alert(_U('toofar_from_robbery'), "error")
		end
		Point = Point.remove()
	end, function ()
		Point = Point.remove()
	end)
	secondsRemaining = Config.TimeTorching
	TimerT(function ()
		TriggerEvent('sr:ShowBigWhisper', 'g', "MISSION PASSED", 3000)
		TriggerEvent('esx_blowtorch:stopblowtorching')
		TriggerServerEvent('sr_lirobbery:missionComplete')
		hacking_check = false
		hacking_complete = false
		virus_imported = false
		virus_importing = false
		endrob = false
		ClearPedTasks(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(), false)
	end, 'endrob')
	TriggerEvent('esx_blowtorch:startblowtorch')
	SR.Alert(_U('blowtorch_start'), "check")
end)

AddEventHandler('esx:onPlayerDeath', function()
	if endrob then
		secondsRemaining = -1
		virus_imported = false
		virus_importing = false
		hacking_check = false
		hacking_complete = false
		endrob = false
		FreezeEntityPosition(PlayerPedId(), false)
		TriggerEvent('esx_blowtorch:stopblowtorching')
		TriggerServerEvent('sr_lirobbery:missionCancelled', false)
		SR.Alert(_U('robbery_failed'), "info")
	end

	if virus_importing then
		secondsRemaining = -1
		virus_importing = false
		virus_imported = false
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(PlayerPedId())
		TriggerServerEvent('sr_lirobbery:missionCancelled', false)
		SR.Alert(_U('robbery_failed'), "info")
	end

	if virus_imported then
		secondsRemaining = -1
		virus_imported = false
		virus_importing = false
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(PlayerPedId())
		TriggerServerEvent('sr_lirobbery:missionCancelled', false)
		SR.Alert(_U('robbery_failed'), "info")
		incircle = false
	end
end)