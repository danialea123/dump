---@diagnostic disable: param-type-mismatch, lowercase-global, undefined-global, missing-parameter
local wasProximityDisabledFromOverride = false
disableProximityCycle = false
RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)

-- TODO: Better implementation of this?
RegisterCommand('vol',function(src,args)
	local vol = tonumber(args[1])
	if vol then
		if vol < 20 or vol > 100 then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Volume bayad bein 20 ta 100 bashad!")
		else
			setVolume(vol, 'radio')
			setVolume(vol, 'call')
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Volume ruye ".. vol .. " tanzim shod!")
		end
	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Volumi ra vared nakardid!")
	end
end)

exports('setAllowProximityCycleState', function(state)
	type_check({state, "boolean"})
	disableProximityCycle = state
end)

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(proximityRange + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	sendUIMessage({
		-- JS expects this value to be - 1, "custom" voice is on the last index
		voiceMode = isCustom and #Cfg.voiceModes or mode - 1
	})
end

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if Cfg.voiceModes and mode then
			if Cfg.voiceModes[mode][1] ~= NetworkGetTalkerProximity() then
				mode = 1
				setProximityState(Cfg.voiceModes[mode][1], false)
				TriggerEvent('pma-voice:setTalkingMode', mode)
			else
				Citizen.Wait(500)
			end
		end
	end
end)]]

exports("overrideProximityRange", function(range, disableCycle)
	type_check({range, "number"})
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "f11" and ESX.GetPlayerData()['IsDead'] ~= 1 then
		if playerMuted then return end

		if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
		if exports.gangprop:isOpen() then return end
		local newMode = mode + 1

		-- If we're within the range of our voice modes, allow the increase, otherwise reset to the first state
		if newMode <= 3 then
			mode = newMode
		else
			mode = 1
		end

		setProximityState(Cfg.voiceModes[mode][1], false)
		TriggerEvent('pma-voice:setTalkingMode', mode)
	end
end)

exports('setCustomProximity', function(range)
	customRange = range
	if customRange then
		MumbleSetTalkerProximity(customRange + 0.0)
	end
end)

Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('speaker')))
end)

--[[RegisterCommand('submix', function(_, args)
	submix = not submix
	SetResourceKvp('submix', submix and 'true' or 'false')
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, string.format("^0Submix effect be ^3%s ^0taghir kard", submix))
end)]]

--[[RegisterCommand('vreg', function(_, args)
	eu = not eu
	SetResourceKvpInt('vreg', eu)
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, 'Region voice be ^2'.. (eu and 'europe' or 'iran') ..'^0 Taghir kard!')
	ExecuteCommand('vr')
end)]]
