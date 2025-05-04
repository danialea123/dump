---@diagnostic disable: param-type-mismatch

function Alert(title, message, time, type)
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('pNotify:Alert')
AddEventHandler('pNotify:Alert', function(title, message, time, type)
	print(GetInvokingResource())
	if GetInvokingResource() then return end
	Alert(title, message, time, type)
end)
--[[
RegisterCommand('1', function()
	TriggerEvent("pNotify:Alert","ERROR","<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>LeveL</span>!",5000,"error")
end)]]
--[[
RegisterCommand('allnoty', function()
	exports['pNotify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>You have widthdrawn <span style='color:#069a19'><b>100$</b></span>!", 5000, 'success')
	exports['pNotify']:Alert("INFORMATION", "<span style='color:#c7c7c7'>Server restart in <span style='color:#fff'>5 minutes</span>!", 5000, 'info')
	exports['pNotify']:Alert("ERROR", "<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>permissions</span>!", 5000, 'error')
	exports['pNotify']:Alert("NEW SMS", "<span style='color:#ffc107'>695-2713: </span><span style='color:#c7c7c7'> How are you?", 5000, 'warning')
	exports['pNotify']:Alert("TWITTER", "<span style='color:#01a2dc'>@USER69: </span><span style='color:#c7c7c7'> Hello everyone!", 5000, 'sms')
	exports['pNotify']:Alert("SAVED", "<span style='color:#c7c7c7'>Clothes saved successfully!", 5000, 'long')

end)]]------------
RegisterCommand('sl', function(source, args, user)
	
		--load unloaded ipl's
		  LoadMpDlcMaps()
		  EnableMpDlcMaps(true)
		  RequestIpl("FIBlobbyfake")
		  RequestIpl("DT1_03_Gr_Closed")
		  RequestIpl("v_tunnel_hole")
		  RequestIpl("TrevorsMP")
		  RequestIpl("TrevorsTrailer")
		  RequestIpl("farm")
		  RequestIpl("farmint")
		  RequestIpl("farmint_cap")
		  RequestIpl("farm_props")
		  RequestIpl("CS1_02_cf_offmission")
		  RequestIpl("prologue01")
		  RequestIpl("prologue01c")
		  RequestIpl("prologue01d")
		  RequestIpl("prologue01e")
		  RequestIpl("prologue01f")
		  RequestIpl("prologue01g")
		  RequestIpl("prologue01h")
		  RequestIpl("prologue01i")
		  RequestIpl("prologue01j")
		  RequestIpl("prologue01k")
		  RequestIpl("prologue01z")
		  RequestIpl("prologue02")
		  RequestIpl("prologue03")
		  RequestIpl("prologue03b")
		  RequestIpl("prologue04")
		  RequestIpl("prologue04b")
		  RequestIpl("prologue05")
		  RequestIpl("prologue05b")
		  RequestIpl("prologue06")
		  RequestIpl("prologue06b")
		  RequestIpl("prologue06_int")
		  RequestIpl("prologuerd")
		  RequestIpl("prologuerdb ")
		  RequestIpl("prologue_DistantLights")
		  RequestIpl("prologue_LODLights")
		  RequestIpl("prologue_m2_door")  
	
		
end, false)