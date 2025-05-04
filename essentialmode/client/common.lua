sec = 0

function addsec()
	sec = sec + 1
	SetTimeout(1000,addsec)
end

Citizen.SetTimeout(1000,addsec)

AddEventHandler('esx:getSharedObject', function(cb)
	local resourceName = GetInvokingResource()
	if GlobalState.resources[resourceName] then
		cb(ESX)
	else
		TriggerServerEvent("DiamondAC:BadThingsDetected", 'This Player Triggered ESX Event From An Unknown Resource: '.. resourceName, false, false)
	end
	if sec > 100 then
		TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Triggered ESX Event After ".. sec .. ' Seconds, Resource Name: '.. resourceName, false, false)
	end
end)

function getSharedObject()
	return ESX
end