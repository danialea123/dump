---@diagnostic disable: undefined-global, missing-parameter
RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent("es:lastAnnounceUpdate")
AddEventHandler("es:lastAnnounceUpdate", function(msg)
	ESX.SetPlayerData("announce", msg)
end)

RegisterNetEvent("esx_tasks:CountTasks")
AddEventHandler("esx_tasks:CountTasks", function(task)
	ESX.SetPlayerData("tasks", task)
end)

RegisterNUICallback("playSound", function(data,cb) 
    if data.action == "buy" then 
      PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif data.action == "error" then 
      if data.error then 
        TriggerEvent("Notify","negado",data.error)
      end
      PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    elseif data.action == "click" then 
      PlaySoundFrontend(-1, "TENNIS_POINT_WON", "HUD_AWARDS",true)      
      PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
    elseif data.action == "select" then 
      PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    end
end)

AddEventHandler("PlayerLoadedToGround", function()
	AddEventHandler("onKeyUP", function(key)
		if key == "f2" then
			SendNUIMessage({
				action = 'show',
				data = {
					battlepass = {Level = ESX.GetPlayerData().Level},
					achievements = false,
					hasPremium = exports.essentialmode:IsVIP(ESX.GetPlayerData().group),
					VIPType = string.upper(ESX.GetPlayerData().group),
					Job = firstToUpper(PlayerData.job.name),
					Gang = firstToUpper(PlayerData.gang.name),
					gXP = PlayerData.gang.name == "nogang" and 0 or exports.XPSystem:ESXT_GetXP(),
					announce = ESX.GetPlayerData().announce,
					tasks = ESX.GetPlayerData().tasks
				}
			})
			setFocus(true)
		end
	end)
end)

function setFocus(action)
	if not IsNuiFocused() then
		SetNuiFocus(action, action)
	end
end

function closeMainMenu()
	if IsNuiFocused() then
		SetNuiFocus(false, false)
	end
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

local wh = {
	["cancelquest"] = true,
	["crosshair"] = true,
	["taskOpen"] = true,
	["captureActivity"] = true,
	["openTopGangs"] = true,
	["openInventoryHud"] = true,
	["openRewardMenu"] = true,
	["openDocs"] = true,
	['fastMenu'] = true,
	["opencase"] = true,
}

RegisterNUICallback('execute', function(data, cb)
	local actionType, action in data
	closeMainMenu()
	if not wh[action] then return end
	if actionType == 'command' then
		ExecuteCommand(action)
	elseif actionType == 'client_event' then
		TriggerEvent(action)
	elseif actionType == 'notification' then
		ESX.Alert(action, "info")
	end
	cb('ok')
end)

RegisterNUICallback('closeNUI', function(_, cb)
	closeMainMenu()
	cb('ok')
end)

RegisterNUICallback('openvmenu', function(_, cb)
	TriggerEvent("openVIP")
end)

RegisterNUICallback('openBusinessMenu', function(_, cb)
	TriggerEvent("openBills")
end)

RegisterNUICallback('opendonate', function(_, cb)
	SetNuiFocus(false, false)
	exports.esx_coins:openCoins()
end)

RegisterNUICallback('buypremium', function(_, cb)
	TriggerEvent("esx_donate:buypremium")
end)

RegisterCommand("ranking", function()
	exports.esx_billing:OpenRankingMenu()
end)

AddEventHandler("captureActivity", function()
	SetNuiFocus(false, false)
	exports.esx_billing:OpenRankingMenu()
end)

AddEventHandler("openTopGangs", function()
	SetNuiFocus(false, false)
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'gangcup_xp',
    {
        title    = "Select Menu",
        align    = 'center',
        elements = {
			{label = "Gang XP", value = "xp"},
			{label = "Gang Cup", value = "cup"},
		}
    }, function(data, menu)
		local action = data.current.value
		menu.close()
		if action == "xp" then
			exports.esx_advancedgarage:Leaderboard()
		else
			ExecuteCommand("leaderboard")
		end
	end, function(data, menu)
        menu.close()
    end)
end)

RegisterNUICallback('openInstructions', function(_, cb)
	TriggerEvent("loading:displayHelpMenu")
end)