local prevPos
local info = {
	warnings = 0,
	warned = false,
	timer = 0,
	maths = {
		result = 0
	},
	fail = 0
}

local cayo = {
	coords  = vector3(4994.65, -4842.86, 32.87),
	enabled = false
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		local ped = PlayerPedId()
		local position = GetEntityCoords(ped)

		if not ESX.GetPlayerData()['isSentenced'] and not ESX.GetPlayerData()['aduty'] then
			if prevPos then
				local distance = #(position - prevPos)
				if distance <= 1 and ESX.GetPlayerData()['IsDead'] ~= 1 then
					info.warnings = info.warnings + 1
					if info.warnings >= 1800 then
						if not info.warned then
							info.timer = 120
							info.maths.a = math.random(1, 10)
							info.maths.b = math.random(1, 10)
							info.maths.result = info.maths.a + info.maths.b
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. info.timer .. " ^0saniye digar be elaat ^1AFK ^0bodan kick mishavid, lotfan az makan feli khod ta hengami ke peygham afk ra daryaft konid jabeja shavid ya be soal robero javab dahid ^3/afkmath ^2" .. info.maths.a .. "^0+^4" .. info.maths.b .. "^0")
							info.warned = true
						else
							info.timer = info.timer - 1
							if info.timer <= 0 then
								TriggerServerEvent('kickForBeingAnAFKDouchebag')
							end

							if info.timer == 60 or info.timer == 30 or info.timer == 10 then
								TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. info.timer .. " ^0saniye digar be elaat ^1AFK ^0bodan kick mishavid, lotfan az makan feli khod ta hengami ke peygham afk ra daryaft konid jabeja shavid ya be soal robero javab dahid ^3/afkmath ^2" .. info.maths.a .. "^0+^4" .. info.maths.b .. "^0")
							end
						end
					end
				else
					if info.warned then
						resetAFK()
					else
						info = {warnings = 0, warned = false, timer = 0, maths = {result = 0}, fail = 0}
					end
				end
			end

		end
		prevPos = position

		-- local isCloseToCayo = #(position - cayo.coords) < 2500
		-- 	if isCloseToCayo and not cayo.enabled then 
		-- 		cayo.enabled = true

		-- 		Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', true)
		-- 		Citizen.InvokeNative(0x5E1460624D194A38, true) -- or use false to disable it
		-- 		Citizen.InvokeNative(0x5E1460624D194A38, true)
		-- 		Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
		-- 		Citizen.InvokeNative(0x53797676AD34A9AA, true)    
			
		-- 		-- audio stuff
		-- 		SetAudioFlag('PlayerOnDLCHeist4Island', true)
		-- 		SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
		-- 		SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
		-- 	elseif not isCloseToCayo and cayo.enabled then
		-- 		cayo.enabled = false

		-- 		Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', false)
		-- 		Citizen.InvokeNative(0x5E1460624D194A38, false) -- or use false to disable it
		-- 		Citizen.InvokeNative(0x5E1460624D194A38, false)
				
		-- 		Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
		-- 		Citizen.InvokeNative(0x53797676AD34A9AA, false)    
			
		-- 		-- audio stuff
		-- 		SetAudioFlag('PlayerOnDLCHeist4Island', false)
		-- 		SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
		-- 		SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, false)
		-- 	end
		
	end
end)

local failLimit = 3
RegisterCommand("afkmath", function(source, args)
	if info.warned then
		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab chizi vared nakardid!")
		end

		if not tonumber(args[1]) then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab faghat mitavanid adad vared konid!")
		end

		local input = tonumber(args[1])

		if input == info.maths.result then
			resetAFK()
		else
			info.fail = info.fail + 1
			if info.fail > 3 then
				TriggerServerEvent('kickForBeingAnAFKDouchebag')
				return
			end
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Javab vared shode eshtebah bod, shoma ^2" .. failLimit - info.fail .. "^0 bar digar ^3forsat^0 javab darid!")
		end
	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma hich afk math acitivi nadarid!")
	end
end, false)

function resetAFK()
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma digar be onvan karbar ^1AFK ^0hesab ^2nemishavid^0!")
	info = {warnings = 0, warned = false, timer = 0, maths = {result = 0}, fail = 0}
end