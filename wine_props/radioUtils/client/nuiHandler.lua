local PlayerServerID = GetPlayerServerId(PlayerId())
local PlayersInRadio = {}
local firstTimeEventGetsTriggered = true
local RadioChannelsName = {}

RegisterNetEvent('esx_rp-radio:Client:SyncRadioChannelPlayers')
AddEventHandler('esx_rp-radio:Client:SyncRadioChannelPlayers', function(src, RadioChannelToJoin, PlayersInRadioChannel)
	if firstTimeEventGetsTriggered then
		for i, v in pairs(exports.xRadio:getConfig()) do
			local frequency = tonumber(v.Min)
			local minFrequency, maxFrequency = v.Min, v.Max
			for index = minFrequency, maxFrequency, 1 do
				RadioChannelsName[tostring(index)] = tostring(firstToUpper(i))
			end
			if frequency ~= 0 then
				RadioChannelsName[tostring(frequency)] = tostring(firstToUpper(i))
			end
		end	
		firstTimeEventGetsTriggered = false
	end
	PlayersInRadio = PlayersInRadioChannel
	if src == PlayerServerID then
		if RadioChannelToJoin > 0 then
			local radioChannelToJoin = tostring(RadioChannelToJoin)
			if RadioChannelsName[radioChannelToJoin] and RadioChannelsName[radioChannelToJoin] ~= nil then 
				HideTheRadioList() 
				for index, player in pairs(PlayersInRadio) do
					if player.Source ~= src then
						SendNUIMessage({ radioId = player.Source, radioName = player.Name, channel = RadioChannelsName[radioChannelToJoin] }) 
					else
						SendNUIMessage({ radioId = src, radioName = player.Name, channel = RadioChannelsName[radioChannelToJoin], self = true  })
					end
					
				end
				ResetTheRadioList()
			else
				HideTheRadioList()
				for index, player in pairs(PlayersInRadio) do
					if player.Source ~= src then
						SendNUIMessage({ radioId = player.Source, radioName = player.Name, channel = exports["pma-voice"]:getRadioChannel() })
					else
						SendNUIMessage({ radioId = src, radioName = player.Name, channel = exports["pma-voice"]:getRadioChannel(), self = true  })
					end
				end
				ResetTheRadioList()
			end
		else
			ResetTheRadioList() 
			HideTheRadioList() 	
		end
	elseif src ~= PlayerServerID then
		if RadioChannelToJoin > 0 then
			local radioChannelToJoin = tostring(RadioChannelToJoin)
			if RadioChannelsName[radioChannelToJoin] and RadioChannelsName[radioChannelToJoin] ~= nil then 
				SendNUIMessage({ radioId = src, radioName = PlayersInRadio[src].Name, channel = RadioChannelsName[radioChannelToJoin] })
				ResetTheRadioList() 
			else
				SendNUIMessage({ radioId = src, radioName = PlayersInRadio[src].Name, channel = radioChannelToJoin })
			end
		else
			SendNUIMessage({ radioId = src })
		end
	end
	
end)

RegisterNetEvent('pma-voice:setTalkingOnRadio')
AddEventHandler('pma-voice:setTalkingOnRadio', function(src, talkingState)
	SendNUIMessage({ radioId = src, radioTalking = talkingState }) 
end)

RegisterNetEvent('pma-voice:radioActive')
AddEventHandler('pma-voice:radioActive', function(talkingState)
	SendNUIMessage({ radioId = PlayerServerID, radioTalking = talkingState })
end)

RegisterNetEvent('esx_rp-radio:Client:DisconnectPlayerCurrentChannel')
AddEventHandler('esx_rp-radio:Client:DisconnectPlayerCurrentChannel', function()
	ResetTheRadioList() 
	HideTheRadioList()
end)

function ResetTheRadioList()
	PlayersInRadio = {}
end

function HideTheRadioList()
	SendNUIMessage({ clearRadioList = true }) 
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

exports("playRadioSound", function(state)
	if state then 
		SendNUIMessage({ sound = "audio_on", volume = 0.3})
	else
		SendNUIMessage({ sound = "audio_off", volume = 0.5})
	end
end)
