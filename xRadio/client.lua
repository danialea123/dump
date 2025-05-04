---@diagnostic disable: param-type-mismatch, undefined-field, missing-parameter, lowercase-global
-- Citizen.CreateThread(function()
--     pcall(load(exports['diamond_utils']:loadScript('Radio')))
-- end)
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

local JobOrgan = {
    ["police"] = true,
    ["sheriff"] = true,
    ["fbi"] = true,
    ["justice"] = true,
    ["forces"] = true,
}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    Close()
    ConnectRadio(0)
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
    Close()
    ConnectRadio(0)
end)

AddEventHandler('onClientMapStart', function()
    NetworkSetTalkerProximity(2.5)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
            exports["pma-voice"]:setVoiceProperty("radioClickMaxChannel", 1500) -- Set radio clicks enabled for all radio frequencies
            --exports["pma-voice"]:setVoiceProperty("radioEnabled", false) -- Disable radio control
			return
		end
	end
end)

SendReactMessage = function(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

Close = function()
    SetNuiFocus(false, false)
    toggleRadioAnimation(false)
    SendReactMessage('setOpen', {
        OpenClose = false,
        PlayerID = GetPlayerServerId(PlayerId()),
        Language = Settings.Language, 
    })
end

Open = function()
    SetNuiFocus(true, true)
    toggleRadioAnimation(true)
    SendReactMessage('setOpen', {
        OpenClose = true,
        PlayerID = GetPlayerServerId(PlayerId()),
        Language = Settings.Language, 
    })
end

LoadAnimDic = function(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

toggleRadioAnimation = function(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 0, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

RegisterNetEvent("xRadio:OpenClose", function(data)
    if data then 
        Open()
    else 
        Close()
    end
end)

RegisterNetEvent("GetRadioPlayer", function(data)
    SendReactMessage('setPlayerID', data) 
end)

RegisterCommand(Settings.ResetCommad, function()
    SendReactMessage('setRadioReset') 
end)

RegisterNuiCallback("Close", function()
    TriggerEvent("xRadio:OpenClose", false)
end)

RegisterNuiCallback("RadioLeave", function()
    RadioLeave()
end)

RegisterNuiCallback("setVolume", function(data)
    local volume = tonumber(data)
    if data <= 20 then
        volume = 20
    elseif data >= 100 then
        volume = 100
    end
    ExecuteCommand("vol "..volume)
end)

RegisterNUICallback('setRadio', function(data)
    if DoesHaveAccess(data) then
        ConnectRadio(data)
    else
        InformAvailableFrequency(data)
    end
end)

function InformAvailableFrequency(code)
    local String = "Shoma Faghat Be Ferequency Haye: "
    local job = PlayerData.job.name
    local gang = PlayerData.gang.name
    local jobTable = Settings.Permissions[job]
    local gangTable = Settings.Permissions[gang]
    if jobTable then
        String = String.." ["..jobTable.Min.." Ta "..jobTable.Max.."] Va "
    end
    if gangTable then
        String = String.."["..gangTable.Min.." Ta "..gangTable.Max.."] Va "
    end
    local HighestFreq = GetLastFreq()
    String = String.."["..HighestFreq.." Ta 1500] Dastresi Darid!"
    if code >= 1000 and code <= 1005 then
        if not JobOrgan[PlayerData.job.name] then
            String = "Frequency Haye 1000 Ta 1005 Dar Dastres Nist"
        end
    end
    TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0"..String)
end

function GetLastFreq()
    local last = 0
    for k, v in pairs(Settings.Permissions) do
        if v.Max >= last then
            last = v.Max
        end
    end
    return last + 1
end

function DoesHaveAccess(code)
    if not code then return false end
    if code >= 1500 then return false end
    local Has = false
    local job = PlayerData.job.name
    local gang = PlayerData.gang.name
    local jobTable = Settings.Permissions[job]
    local gangTable = Settings.Permissions[gang]
    if jobTable then
        if code >= jobTable.Min and code <= jobTable.Max then
            Has = true
        end
        for k, v in pairs(jobTable.Shared) do
            if v == code then
                Has = true
                break
            end
        end
    end
    if gangTable then
        if code >= gangTable.Min and code <= gangTable.Max then
            Has = true
        end
        for k, v in pairs(gangTable.Shared) do
            if v == code then
                Has = true
                break
            end
        end
    end
    if not Has then
        Has = true
        for k, v in pairs(Settings.Permissions) do
            if code >= v.Min and code <= v.Max then
                Has = false
                break
            end
        end
    end
    if code >= 1000 and code <= 1005 then
        if not JobOrgan[PlayerData.job.name] then
            Has = false
        end
    end
    return Has
end

RegisterNetEvent("xRadio:setupGangFrequency")
AddEventHandler("xRadio:setupGangFrequency", function(list)
    for k, v in pairs(list) do
        Settings.Permissions[k] = v
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    if exports.esx_ambulancejob:inCapture() then return end
    Close()
    ConnectRadio(0)
end)

RegisterKey("OEM_3", function()
    if ESX.DoesHaveItem2("radio", 1) then
        if not ESX.GetPlayerData()['IsDead'] and not ESX.GetPlayerData()['isSentenced'] then
            Open()
        end
    else
        ESX.Alert("Shoma Radio Nadarid", "info")
    end
end)

RegisterNetEvent('esx:removeInventoryItem',function(label)
    if label.name == "radio" and label.count <= 0 then
        Close()
        ConnectRadio(0)
    end
end)

exports("getConfig", function()
    return Settings.Permissions
end)

ConnectRadio = function(data)
    local data = data
    TriggerServerEvent("setRadioChannel", data)
    if Settings.Voice == "pma-voice" then 
        if exports["pma-voice"]:getRadioChannel() == data then data = 0 end
        if data ~= 0 then
            --exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
            exports.wine_props:playRadioSound(true)
            TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. GetPlayerName(PlayerId()) .. "(".. GetPlayerServerId(PlayerId()) ..") be frq radio ^2join^0 shod!")
        else
            --exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
            exports.wine_props:playRadioSound(false)
            TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. GetPlayerName(PlayerId()) .. "(".. GetPlayerServerId(PlayerId()) ..") az frq radio ^1kharej^0 shod!")
        end
        if data ~= 0 then
            ExecuteCommand('me Dastesho be samte radio mibare va freq set mikone')
        end
        exports["pma-voice"]:setRadioChannel(data)
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:SetRadioChannel(0, true)
        exports["saltychat"]:SetRadioChannel(data, true)
    elseif Settings.Voice == "mumble-voip" then
        exports["mumble-voip"]:SetRadioChannel(0)
        exports["mumble-voip"]:SetRadioChannel(data)
    end 
end

exports("ConnectRadio", ConnectRadio)

RadioLeave = function()
    TriggerServerEvent("setRadioChannel", 0)
    TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. GetPlayerName(PlayerId()) .. "(".. GetPlayerServerId(PlayerId()) ..") az frq radio ^1kharej^0 shod!")
    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:removePlayerFromRadio()
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:RemovePlayerRadioChannel()
    elseif Settings.Voice == "mumble-voip" then
        exports["mumble-voip"]:removePlayerFromRadio()
    end 
end

setVolume = function(data)
    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:setRadioVolume(tonumber(data)) 
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:SetRadioVolume(tonumber(data)) 
    end 
end

RegisterNetEvent("esx_paintball:SetRadioSettings")
AddEventHandler("esx_paintball:SetRadioSettings", function(state, LobbyID, TeamID)
	if state then
        ConnectRadio(500 + LobbyID + TeamID)
	else
        ConnectRadio(0)
	end
end)

RegisterCommand("fr", function(source, args)
    local data = tonumber(args[1])
    if not args[1] or not tonumber(args[1]) then return ESX.Alert("Shoma Hich Freuency Vared Nakardid", "info") end
    if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == 1 then return end
    if not ESX.GetPlayerData()['IsDead'] and not ESX.GetPlayerData()['isSentenced'] then
        if ESX.DoesHaveItem2("radio", 1) then
            if DoesHaveAccess(data) then
                ConnectRadio(data)
            else
                InformAvailableFrequency(data)
            end
        else
            ESX.Alert("Shoma Radio Nadarid", "info")
        end
    end
end)