---@diagnostic disable: undefined-global
function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end

function PlayAnim(anim, freeze)
	if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then
		return
	end
	if not DoesEntityExist(PlayerPedId()) then
		return false
	end
	if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	end
	exports.essentialmode:DisableControl(true)
	TriggerEvent("dpemote:enable", false)
	TriggerEvent("dpclothingAbuse", true)
	local ChosenDict, ChosenAnim = table.unpack(Configs.Emotes[anim])

	LoadAnim(ChosenDict)
	
	local duration = GetAnimDuration(ChosenDict, ChosenAnim)
	if duration > 5 then
		duration = 4
	end
	TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnim, 2.0, 2.0, duration * 1000 + 1000, 2, 0, false, false, false)
	FreezeEntityPosition(PlayerPedId(), freeze)
	Wait(duration * 1000 + 1000)
	FreezeEntityPosition(PlayerPedId(), false)
	exports.essentialmode:DisableControl(false)
	TriggerEvent("dpemote:enable", true)
	TriggerEvent("dpclothingAbuse", false)
	return true
end

RegisterNetEvent("vrs-rps:client:PlayAnim", function(emote)
	if emote == "tie" then
		Notify(Localess[Configs.Locale].notify.Tie)
	elseif emote == "win" then
		Notify(Localess[Configs.Locale].notify.Won)
	elseif emote == "lose" then
		Notify(Localess[Configs.Locale].notify.Lost)
	end
	ClearPedTasksImmediately(PlayerPedId())
	Wait(300)
	-- wait a little to make sure animation shows up right on both clients after canceling any previous emote
	if emote == "rock" or emote == "paper" or emote == "scissors" then
		if PlayAnim(emote, true) then
		end
	else
		if PlayAnim(emote, false) then
		end
	end
	return
end)