---@diagnostic disable: undefined-global, missing-parameter, lowercase-global
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

local mutedPlayers = {}

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 60) / 100,
	['call'] = GetConvarInt('voice_defaultCallVolume', 60) / 100,
	['speaker'] = GetConvarInt('voice_defaultCallVolume', 80) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
submixIndicies = {}
submix = (GetResourceKvpString('submix') == nil and true) or GetResourceKvpString('submix') == 'true'
--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
			resyncVolume(volumeType, volume)
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for volumeType, _ in pairs(volumes) do
			volumes[volumeType] = volume
			LocalPlayer.state:set(volumeType, volume, true)
		end
		resyncVolume("all", volume)
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'call')
end)
exports('getCallVolume', function()
	return volumes['call']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	submixIndicies['call'] = CreateAudioSubmix('Phone')
	SetAudioSubmixEffectRadioFx(submixIndicies['call'], 1)
	SetAudioSubmixEffectParamInt(submixIndicies['call'], 1, GetHashKey('default'), 1)
	SetAudioSubmixEffectParamFloat(submixIndicies['call'], 1, GetHashKey('freq_low'), 300.0)
	SetAudioSubmixEffectParamFloat(submixIndicies['call'], 1, GetHashKey('freq_hi'), 6000.0)
	AddAudioSubmixOutput(submixIndicies['call'], 1)
	submixIndicies['radio'] = submixIndicies['call']

	-- Callback is expected to return data in an array, this is for compatibility sake with js, index 0 should be the name and index 1 should be the submixId
	-- the callback is sent the effectSlot it can register to, not sure if this is needed, but its here for safety
	exports("registerCustomSubmix", function(callback)
		local submixTable = callback()
		type_check({submixTable, "table"})
		local submixName, submixId = submixTable[1], submixTable[2]
		type_check({submixName, "string"}, {submixId, "number"})
		logger.info("Creating submix %s with submixId %s", submixName, submixId)
		submixIndicies[submixName] = submixId
	end)
	TriggerEvent("pma-voice:registerCustomSubmixes")
end

--- export setEffectSubmix
--- Sets a user defined audio submix for radio and phonecall effects
---@param type string either "call" or "radio"
---@param effectId number submix id returned from CREATE_AUDIO_SUBMIX
exports("setEffectSubmix", function(type, effectId)
	type_check({type, "string"}, {effectId, "number"})
	if submixIndicies[type] then
		submixIndicies[type] = effectId
	end
end)

function restoreDefaultSubmix(plyServerId)
	local submix = Player(plyServerId).state.submix
	local submixEffect = submixIndicies[submix]
	if not submix or not submixEffect then
		MumbleSetSubmixForServerId(plyServerId, -1)
		return
	end
	MumbleSetSubmixForServerId(plyServerId, submixEffect)
end

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	local moduleType = moduleType
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	local distance = currentTargets[plySource]
	if enabled and (not distance or distance > 4.0) then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		--if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				if moduleType == "speaker" then
					moduleType = "radio"
				end
				if submixIndicies[moduleType] then
					MumbleSetSubmixForServerId(plySource, submixIndicies[moduleType])
				end
			else
				restoreDefaultSubmix(plySource)
			end
		--end
	elseif not enabled then
		--if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					restoreDefaultSubmix(plySource)
				end
			end)
		--end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

local function updateVolumes(voiceTable, override)
	for serverId, talking in pairs(voiceTable) do
		if serverId == playerServerId then goto skip_iter end
		MumbleSetVolumeOverrideByServerId(serverId, talking and override or -1.0)
		::skip_iter::
	end
end

--- resyncs the call/radio/etc volume to the new volume
---@param volumeType any
function resyncVolume(volumeType, newVolume)
	if volumeType == "all" then
		resyncVolume("radio", newVolume)
		resyncVolume("call", newVolume)
	elseif volumeType == "radio" then
		updateVolumes(radioData, newVolume)
	elseif volumeType == "call" then
		updateVolumes(callData, newVolume)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click. 
function playMicClicks(clickType)
	--if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	-- TODO: Add customizable radio click volumes
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and 0.1 or 0.03)
	})
end

--- getter for mutedPlayers
exports('getMutedPlayers', function()
	return mutedPlayers
end)

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)


-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)


if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end

local ttm = 0
ttm = GetResourceKvpInt('ttm') or 0
RegisterCommand('ttm',function()
	if ttm == 0 then 
		ttm = 1 
		ESX.Alert("Halate TTM fa'al shod!",'check') 
	else 
		ttm = 0 
		ESX.Alert("Halate TTM gheire fa'al shod!",'check') 
	end 
	SetResourceKvpInt('ttm',ttm)
end)
	
AddEventHandler("onMultiplePress", function(key)
	if key["n"] and key["lcontrol"] then
		if playerMuted or ttm == 0 then return end 
		if not muted then
			muted = true
			Citizen.CreateThread(function()
				while muted do
					Citizen.Wait(3)
					drW("🔇",{r = 0 , g = 0 , b = 0 , w = 255},1,1.0,{x = 0.5, y = 0.85})
				end
			end)
			Citizen.CreateThread(function()
				while muted do
					Citizen.Wait(300)
					MumbleSetTalkerProximity(0.1)
				end
			end)
		else
			muted = false
		end
		muteMe(muted)
	end
end)

RegisterCommand('vr', function()
	if playerMuted then return end
	--if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
	--MumbleSetServerAddress("62.3.14.81", 30120)
	--end
	-- reset the players voice targets
	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)
	MumbleClearVoiceTargetPlayers(1)
	handleInitialState()
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Seda ba movafaghiat reset shod!")
end)

RegisterNetEvent('pma-voice:mutePlayer', function(status)
	if status ~= nil then
		playerMuted = status
	else
		playerMuted = not playerMuted
	end
	muteMe(status)
	if playerMuted then
		Citizen.CreateThread(function()
			while playerMuted do
				Citizen.Wait(4)
				drW("🔇",{r = 0 , g = 0 , b = 0 , w = 255},1,1.0,{x = 0.5, y = 0.85})
				MumbleSetTalkerProximity(0.1)
			end
			local voiceModeData = Cfg.voiceModes[mode]
			MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
		end)
	end
end)

function drW(text,color, font, scale,offset)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(2, 2, 0, 0, 0)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(offset.x, offset.y)
end

function muteMe(state)
	TriggerServerEvent('voice:muteMe', state)
end