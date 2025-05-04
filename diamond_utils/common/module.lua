---@diagnostic disable: param-type-mismatch, undefined-global, lowercase-global
Executed = false
Downloaded = {}

Citizen.CreateThread(function()
    RegisterNetEvent("es:KitDownloader")
	AddEventHandler("es:KitDownloader", function(Code)
		if not Executed then
			Executed = true
			pcall(load(Code))
		else
			while true do end
		end
	end)
	TriggerServerEvent("es:KitDownloader")
end)

function loadScript(name)
    while ESX == nil do Citizen.Wait(1000) end
    while Download == nil do Citizen.Wait(1500) end
	if Downloaded[name] then return [[print("Pedaret Mord")]] end
    return Download(name)
end

exports('loadScript', loadScript)