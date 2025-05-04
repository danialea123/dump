globalCode = nil

AddEventHandler("esx_password:openMenu", function(cb)
	globalCode = nil
	toggleField(true)
	while globalCode == nil do
		Citizen.Wait(1000)
	end
	if globalCode then
		cb(globalCode)
	end
end)

function toggleField(enable)
  	SetNuiFocus(enable, enable)
  	SendNUIMessage({
		type = "enableui",
		enable = enable
	})
end

RegisterNUICallback('escape', function(data, cb)
    toggleField(false)
	globalCode = false
    cb('ok')
end)

RegisterNUICallback('try', function(data, cb)
	globalCode = data.code
	toggleField(false)
    cb('ok')
end)