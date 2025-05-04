RegisterNetEvent(GetCurrentResourceName() .. ":client:notify", function(title, text, length, type)
	Notify(title, text, length, type)
end)

function Notify(title, text, type, src)
	local length = 5000
	if IsDuplicityVersion() then
		TriggerClientEvent(GetCurrentResourceName() .. ":client:notify", src, title, text, length, type)
	else
		lib.notify({
			title = title,
			description = text,
			type = type,
			duration = length,
		})
	end
end
