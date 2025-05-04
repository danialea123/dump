---@diagnostic disable: undefined-field, undefined-global, lowercase-global
ESX = nil
local PlayerData = {}
local base64MoneyIcon = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

 	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

 	ESX.PlayerData = ESX.GetPlayerData()
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
	PlayerData.gang = gang
	TriggerServerEvent("gangs:playerGangChanged")
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    ESX.PlayerData.black_money = money
    PlayerData.black_money = money
end)

RegisterNetEvent('gangs:inv')
AddEventHandler('gangs:inv', function(gang)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Join',
	{
		title 	 = 'Voroud Be Gang',
		align    = 'center',
		question = 'Aya Shoma Mikhahid Vared Gang ('.. gang ..') Shavid?',
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheir', value = 'no'},
		}
	}, function(data, menu)
		if PlayerData.gang.grade == 13 then
			menu.close()
			ESX.UI.Menu.CloseAll()		
			return
		end
		if data.current.value == 'yes' then
			TriggerServerEvent("gangs:acceptinv")
			ESX.UI.Menu.CloseAll()		
		elseif data.current.value == 'no' then
			menu.close()
			ESX.UI.Menu.CloseAll()													
		end
	end)
end)

function OpenBossMenu(gang, close, options)
	local isBoss = PlayerData.gang.grade >= 12
	local options  = options or {}
	local elements = {}
	local gangMoney = nil
	local black_money = nil
	local dcash = nil
	local coins = 0
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('gangs:getGangData', function(gangsdata, ghore)

		ESX.TriggerServerCallback('gangs:isBoss', function(result)
			isBoss = result
		end, gang)

		--[[while isBoss == nil do
			Citizen.Wait(100)
		end]]

		--[[if not isBoss then
			return
		end]]

		ESX.TriggerServerCallback('gangs:getGangMoney', function(money, xc, bc, cash)
			gangMoney = money
			coins = xc or 0
			black_money = bc
			dcash = cash
		end, ESX.PlayerData.gang.name)

		while gangMoney == nil do
			Citizen.Wait(50)
		end

		--[[while gangMoney == nil do
			Citizen.Wait(1)
			ESX.TriggerServerCallback('gangs:getGangMoney', function(money)
				gangMoney = money
			end, ESX.PlayerData.gang.name)
		end]] 

		--sath developeri dar had boz, khak bar saret

		local defaultOptions = {
			withdraw   = true,
			deposit    = true,
			wash       = false,
			employees  = true,
			grades     = true,
			gradesname = true,
			garage     = true,
			armory     = true,
			vest       = true,
			logo       = true,
			invite     = true,
			logpower   = true,
			blip       = true,
			gps_color  = true,
			blip_color = true,
			vehbuy     = true,
			heli       = true,
			craft      = true,
			lockpick   = true,
		}

		for k,v in pairs(defaultOptions) do
			if options[k] == nil then
				options[k] = v
			end
		end

		table.insert(elements, {label = 'Diamond Cash: '..dcash, value = nil})

		--table.insert(elements, {label = "Gang Coins: "..coins, value = 'gc'})
		if ghore then
			table.insert(elements, {label = '<span style="color:orange; border-bottom: 1px solid orange;"> Ghore Keshi Robbery </span>', value = 'ghore'})
		end

		if isBoss then
			table.insert(elements, {label = '<span style="color:cyan; border-bottom: 1px solid cyan;"> GangWar </span>', value = 'gangwar'})
		end

		table.insert(elements, {label = "Modiriat Bodje", value = 'bodje'})
		if isBoss then 
			table.insert(elements, {label = "Dastresi Ha", value = 'asli'})
			table.insert(elements, {label = "Tanzimat Gang", value = 'setting'})
		end

		if options.employees and isBoss then
			table.insert(elements, {label = "Modiriyat MemberHa", value = 'manage_employees'})
		end

		if PlayerData.gang.grade < 13 then
			table.insert(elements, {label = '<span style="color:red; border-bottom: 1px solid red;"> Leave From Gang </span>', value = "nogang"})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_', {
			title    = _U('boss_menu'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
				if data.current.value == 'nogang' then
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'confirm_leave_gang', {
						title    = 'آیا مطمعن هستید که میخواهید از گنگ خارج شوید؟ در این صورت جان خود را از دست خواهید داد',
						align    = 'center',
						elements = {
							{label = 'خیر',  value = false},
							{label = 'بله', value = true}
						}
					}, function(data3, menu3)
						if data3.current.value then
							TriggerServerEvent("gangs:leaveFromGang")
							exports.esx_ambulancejob:RemoveItemsAfterRPDeath()
							menu3.close()
						else
							menu3.close()
						end
					end, function(data3, menu3)
						menu3.close()
					end)
				elseif data.current.value == 'withdraw_society_money' then
					OpenMoneyMenu(gang, isBoss)
				elseif data.current.value == 'withdraw_society_black' then
					OpenblackMoneyMenu(gang, isBoss)
				elseif data.current.value == 'manage_employees' then
					OpenManageEmployeesMenu(gang, gangsdata)
				elseif data.current.value == 'manage_grades' then
					OpenManageGradesMenu(gang)
				elseif data.current.value == 'manage_gradesname' then
					if gangsdata.rank >= 2 then
						OpenRenameGrade() -- Version Jadid
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Esm Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_garage' then
					--if gangsdata.rank >= 2 then
						OpenGarageAccess(gang)
					--else
						--ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Garage Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
					--end
				elseif data.current.value == 'manage_lockpick' then
					if gangsdata.rank >= 7 then
						OpenLockPickAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank LockPick Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~7 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_armory' then
					if gangsdata.rank >= 1 then
						OpenArmoryAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Armory Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~1 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_craft' then
					if gangsdata.rank >= 1 then
						OpenCraftAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Craft Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~1 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_vest' then
					if gangsdata.rank >= 2 then
						OpenVestAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Vest Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
					end
				elseif data.current.value == 'set_webhook' then
					if ESX.GetPlayerData()['CanGangLog'] == 1 or gangsdata.rank >= 7 then
						SetWebhook(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Log Nadarad, Jahat Kharid Be Shop Morajee Konid Ya Be Rank 7 Beresid")
					end
				elseif data.current.value == 'manage_heli' then
					if gangsdata.rank >= 2 then
						OpenHeliAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Heli Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_vehbuy' then
					if gangsdata.rank >= 5 then
						OpenVehBuyAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Kharid Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
					end
				elseif data.current.value == 'set_blip' then
					if gangsdata.rank >= 5 then
						SetBlip(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Blip Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
					end
				elseif data.current.value == 'set_blip_color' then
					if gangsdata.rank >= 5 then
						SetBlipColor(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Blip Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
					end
				elseif data.current.value == 'set_gps_color' then
					if gangsdata.rank >= 3 then
						SetGpsColor(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank GPS Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~3 ~s~ Beresanid")
					end
				elseif data.current.value == 'set_logo' then
					if gangsdata.rank >= 10 then
						SetLogo(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Logo Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~10 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_invite' then
					if gangsdata.rank >= 5 then
						OpenInviteAccess(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Invite Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
					end
				elseif data.current.value == 'manage_item' then
					OpenItemAccess(gang)
				elseif data.current.value == 'wash' then
					if gangsdata.rank >= 6 then
						WashMoney(gang)
					else
						ESX.Alert("Gang Shoma Ghabeliyat Wash Money Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~6 ~s~ Beresanid")
					end
				elseif data.current.value == 'password' then
					TriggerEvent("esx_password:openMenu", function(result)
						local result = tostring(result)
						if string.len(result) >= 4 and string.len(result) <= 6 then
							ESX.TriggerServerCallback('gangs:setGangAccess', function()
								ESX.Alert("Ramz Anbari Be ("..result..") Taghir Yaft", "check")
							end, gang, result, 'password')
						else
							ESX.Alert("Ramz Bayad Beyn 4 Ta 6 Adad Bashad", "error")
						end
					end, menu.close())
				elseif data.current.value == 'ghore' then
					OpenGhoreKeshi()
					menu.close()
				elseif data.current.value == 'gangwar' then
					OpenGangWar()
					menu.close()
				elseif data.current.value == 'bodje' then
					menu.close()
					OpenBodje(gang, gangsdata)
				elseif data.current.value == "asli" then
					menu.close()
					PrimaryPerms(gang, gangsdata)
				elseif data.current.value == "setting" then
					menu.close()
					Settings(gang, gangsdata)
				end
		end, function(data, menu)
			if close then
				close(data, menu)
			end
		end)

	end, ESX.PlayerData.gang.name)
end

function Settings(gang, gangsdata)
	local elements = {}
	table.insert(elements, {label = "Set Webhook Log", value = 'set_webhook'})
	table.insert(elements, {label = "Set Kardan Tarh Blip (Roye Map)", value = 'set_blip'})
	table.insert(elements, {label = "Set Kardan Rang Blip", value = 'set_blip_color'})
	table.insert(elements, {label = "Set Kardan Logo Gang", value = 'set_logo'})
	table.insert(elements, {label = "Set Kardan Password Anbari", value = 'password'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_', {
		title    = "Tanzmiat Gang",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'set_blip' then
			if gangsdata.rank >= 5 then
				SetBlip(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Blip Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
			end
		elseif data.current.value == 'set_blip_color' then
			if gangsdata.rank >= 5 then
				SetBlipColor(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Blip Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
			end
		elseif data.current.value == 'set_gps_color' then
			if gangsdata.rank >= 3 then
				SetGpsColor(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank GPS Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~3 ~s~ Beresanid")
			end
		elseif data.current.value == 'set_logo' then
			if gangsdata.rank >= 10 then
				SetLogo(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Logo Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~10 ~s~ Beresanid")
			end
		elseif data.current.value == 'password' then
			TriggerEvent("esx_password:openMenu", function(result)
				local result = tostring(result)
				if string.len(result) >= 4 and string.len(result) <= 6 then
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						ESX.Alert("Ramz Anbari Be ("..result..") Taghir Yaft", "check")
					end, gang, result, 'password')
				else
					ESX.Alert("Ramz Bayad Beyn 4 Ta 6 Adad Bashad", "error")
				end
			end, menu.close())
		elseif data.current.value == 'set_webhook' then
			if ESX.GetPlayerData()['CanGangLog'] == 1 or gangsdata.rank >= 7 then
				SetWebhook(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Log Nadarad, Jahat Kharid Be Shop Morajee Konid Ya Be Rank 7 Beresid")
			end
		end
	end, function(data, menu)
		OpenBossMenu(gang)
	end)
end

function PrimaryPerms(gang, gangsdata)
	local isBoss = PlayerData.gang.grade >= 12
	local elements = {}
	table.insert(elements, {label = "Dastresi Mashin", value = 'manage_garage'})
	table.insert(elements, {label = "Dastresi Item", value = 'manage_item'})
	table.insert(elements, {label = "Dastresi Gun", value = 'manage_armory'})
	table.insert(elements, {label = "Dastresi Craft Aslahe", value = 'manage_craft'})
	table.insert(elements, {label = "Dastresi Vest", value = 'manage_vest'})
	table.insert(elements, {label = "Dastresi Kharid Mashin", value = 'manage_vehbuy'})
	table.insert(elements, {label = "Dastresi Helicopter", value = 'manage_heli'})
	table.insert(elements, {label = "Dastresi Invite", value = 'manage_invite'})
	table.insert(elements, {label = "Dastresi LockPick", value = 'manage_lockpick'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_', {
		title    = "Dastresi Haye Asli",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'manage_item' then
			OpenItemAccess(gang)
		elseif data.current.value == 'manage_armory' then
			OpenArmoryAccess(gang)
		elseif data.current.value == 'manage_garage' then
			OpenGarageAccess(gang)
		elseif data.current.value == 'manage_lockpick' then
			if gangsdata.rank >= 7 then
				OpenLockPickAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank LockPick Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~7 ~s~ Beresanid")
			end
		elseif data.current.value == 'manage_craft' then
			if gangsdata.rank >= 1 then
				OpenCraftAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Craft Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~1 ~s~ Beresanid")
			end
		elseif data.current.value == 'manage_vest' then
			if gangsdata.rank >= 2 then
				OpenVestAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Vest Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
			end
		elseif data.current.value == 'manage_invite' then
			if gangsdata.rank >= 5 then
				OpenInviteAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Invite Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
			end
		elseif data.current.value == 'manage_heli' then
			if gangsdata.rank >= 2 then
				OpenHeliAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Heli Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid")
			end
		elseif data.current.value == 'manage_vehbuy' then
			if gangsdata.rank >= 5 then
				OpenVehBuyAccess(gang)
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Rank Kharid Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~5 ~s~ Beresanid")
			end
		end
	end, function(data, menu)
		OpenBossMenu(gang)
	end)
end

function OpenBodje(gang, gangsdata)
	ESX.TriggerServerCallback('gangs:getGangMoney', function(money, xc, bc)
		local isBoss = PlayerData.gang.grade >= 12
		local gangMoney = money
		local coins = xc or 0
		local black_money = bc
		local elements = {}
		local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(math.floor(gangMoney)))
		table.insert(elements, {label = ('%s: <span style="color:green;">%s</span>'):format("Pool Tamiz: ", formattedMoney), value = 'withdraw_society_money'})
		local iformattedMoney = _U('locale_currency', ESX.Math.GroupDigits(math.floor(black_money)))
		table.insert(elements, {label = ('%s: <span style="color:yellow;">%s</span>'):format("Pool Kasif: ", iformattedMoney), value = 'withdraw_society_black'})
		if isBoss then
			table.insert(elements, {label = "Wash Money", value = 'wash'})
			table.insert(elements, {label = "Modiriyat Hoghogh", value = 'manage_grades'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_', {
			title    = "Modiriat Bodje",
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'withdraw_society_money' then
				OpenMoneyMenu(gang, isBoss)
			elseif data.current.value == 'withdraw_society_black' then
				OpenblackMoneyMenu(gang, isBoss)
			elseif data.current.value == 'wash' then
				if gangsdata.rank >= 6 then
					WashMoney(gang)
				else
					ESX.Alert("Gang Shoma Ghabeliyat Wash Money Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~6 ~s~ Beresanid")
				end
			elseif data.current.value == 'manage_grades' then
				OpenManageGradesMenu(gang)
			end
		end, function(data, menu)
			OpenBossMenu(gang)
		end)
	end)
end

function WashMoney(gang)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('gang:WashMoney', function(data)
		local elements = {}
		local ostime = exports.sr_main:GetTimeStampp()
		table.insert(elements, {label = "Pool Kasif Haye Zakhire Shode: "..ESX.Math.GroupDigits(data.money).."$", value = nil})
		if data.stampp == 0 then
			table.insert(elements, {label = "Deposit Money", value = "deposit"})
			table.insert(elements, {label = "Auto Wash", value = "wash"})
		else
			table.insert(elements, {label = "Poole Tamiz Ghabel Darayaft: "..ESX.Math.GroupDigits(math.floor(data.money*0.60)).."$", value = nil})
			table.insert(elements, {label = "[✔️]Pool Haye Kasif Ta "..math.floor(((tonumber(data.stampp) - ostime)/3600)).." Saat Digar Wash Mishavand[✔️]", value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wash_money', {
			title    = 'Wash Menu',
			align    = 'center',
			elements = elements
		}, function(datas, menu)
			if datas.current.value == "wash" then
				if data.money > 0 then 
					if data.money > 100000 then
						menu.close()
						ESX.TriggerServerCallback("gang:setWash", function() 
							WashMoney(gang)
						end)
					else
						ESX.Alert("Hadeaghal Pool Baraye Wash 100k mibashad", "error")
					end
				else
					ESX.Alert("Pool Kafi Baraye Wash Vojud Nadarad", "error")
				end
			elseif datas.current.value == "deposit" then
				if PlayerData.black_money > 0 then
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_money', {
						title    = "meghadr Pool Ra Vared Konid",
					}, function(data2, menu2)
						if data2.value then
							if tonumber(data2.value) then
								if data2.value <= PlayerData.black_money then
									if data.money + tonumber(data2.value) <= 5000000 then
										menu.close()
										ESX.TriggerServerCallback("gang:depositMoney", function() 
											WashMoney(gang)
										end, data2.value)
									else
										ESX.Alert("bishtarin pool ghabel wash 5 mil ast", "error")
									end
								else
									ESX.Alert("pool vared shode bishtar az pool kasif shoma ast", "error")
								end
							else
								ESX.Alert("Shoma dar ghesmat pool faghat bayad adad vared konid", "error")
							end
						else
							ESX.Alert("Shoma dar ghesmat pool chizi vared nakardid!", "error")
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.Alert("Shoma Pool kasif Kafi Nadarid", "error")
				end
			end
		end, function(datas, menu)
			menu.close()
		end)
	end)
end

function OpenRenameGrade()
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		  local elements = {}
		  
			for k,v in pairs(grades) do
				table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
			title    = 'Gang Grades',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_grade', {
                title    = "Esm jadid rank ra vared konid",

			}, function(data2, menu2)
				
				if not data2.value then
					ESX.Alert("Shoma dar ghesmat esm jadid chizi vared nakardid!")
					return
				end
	
				if data2.value:match("[^%w%s]") or data2.value:match("%d") then
					ESX.Alert("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!")
					return
				end

				if string.len(ESX.Math.Trim(data2.value)) >= 3 and string.len(ESX.Math.Trim(data2.value)) <= 11 then
					ESX.TriggerServerCallback('gangs:renameGrade', function(refresh)
						menu2.close()
						if refresh then
							menu.close()
							OpenRenameGrade()
						end
					end, data.current.grade, data2.value)
				else
					ESX.Alert("Tedad character esm grade bayad bishtar az ~g~3 ~w~0 va kamtar az ~g~11 ~o~character ~w~bashad!")
				end

            end, function (data2, menu2)
                menu2.close()
            end)
			
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGarageAccess(gangname)
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		local elements = {}
		for k,v in pairs(grades) do
			table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		end

	  	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
		  	title    = 'Gang Grades',
		  	align    = 'top-left',
		  	elements = elements
	  	}, function(data, menu)
			ESX.TriggerServerCallback('gangs:getSortedCars', function(cars)
				if #cars == 0 then return ESX.Alert("Gang Shoma Hich Mashini Nadarad", "error") end
				ESX.TriggerServerCallback("gangs:GetVehiclesByPermission", function(hagh, t)
					if t then
						for j=1, #cars, 1 do
							cars[j].toggle = true
						end
					else
						for i=1, #cars, 1 do
							for _ , v in pairs(hagh) do
								if cars[i].model == v.model then
									cars[i].toggle = true
								end
							end
						end
					end
					VehiclePermission(cars, data.current.grade, gangname, data.current.grade)
				end, data.current.grade)
			end)
	  	end, function(data, menu)
			menu.close()
			OpenBossMenu(gangname)
	  	end)
  	end)
end

function VehiclePermission(cars, grade_label, society, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local change = false
	local FalseAccess = true
	local TrueAccess = true

	table.insert(elements, {
		label = 'Access to all vehicles',
		value = 'all',
		toggle = 'ON'
	})

	for i=1, #cars do
		local vehicleName = ESX.GetVehicleLabelFromHash(cars[i].model)
		local car = vehicleName
		table.insert(elements, {
			label = car.." | "..ESX.Math.Trim(cars[i].plate),
			value = i,
			toggle = cars[i].toggle and 'ON' or 'OFF',
			plate = ESX.Math.Trim(cars[i].plate),
		})
		if cars[i].toggle then
			FalseAccess = false
		else
			TrueAccess = false 
			elements[1].toggle = "OFF"
		end	
	end

	local all = FalseAccess or TrueAccess

	ESX.UI.Menu.Open('toggle', GetCurrentResourceName(), 'vehicle_permission_' .. string.gsub(grade_label, " ", "_"), {
		title    = 'Vehicle Access for ' .. grade_label,
		align    = 'top-left',
		elements = elements
	}, function(data3, menu3)
		if data3.current.value == 'all' then
			for k,v in pairs(cars) do
				v.toggle = data3.current.toggle == 'ON' and true or false
			end
			VehiclePermission(cars, grade_label, society, grade)
		else
			change = true
			cars[data3.current.value].toggle = data3.current.toggle == 'ON' and true or false
		end

	end, function(data3, menu3)
		if change then
			local allow = {}
			for k,v in pairs(cars) do
				if v.toggle then
					table.insert(allow, {model = v.model, plate = v.plate})
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableVehicles', society, grade, allow)
		elseif all then
			local pedaret
			for k,v in pairs(cars) do
				if v.toggle then
					pedaret = true
				else
					pedaret = false
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableVehicles', society, grade, pedaret == true and "all" or {})
		end
		menu3.close()
		OpenGarageAccess(society)
	end)
end

function OpenItemAccess(gangname)
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		local elements = {}
		for k,v in pairs(grades) do
			table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
				title    = 'Gang Grades',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
			ESX.TriggerServerCallback('gangs:getGangInventory', function(cars)
				local cars = cars
				cars = cars.items
				if #cars == 0 then return ESX.Alert("Gang Shoma Hich Itemei Nadarad", "error") end
				ESX.TriggerServerCallback("gangs:GetItemsByPermission", function(hagh, t)
					if t then
						for j=1, #cars, 1 do
							cars[j].toggle = true
						end
					else
						for i=1, #cars, 1 do
							for _ , v in pairs(hagh) do
								if cars[i].name == v then
									cars[i].toggle = true
								end
							end
						end
					end
					ItemPermission(cars, data.current.grade, gangname, data.current.grade)
				end, data.current.grade)
			end)
		end, function(data, menu)
			menu.close()
			OpenBossMenu(gangname)
		end)
	end)
end

function OpenArmoryAccess(gangname)
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		local elements = {}
		for k,v in pairs(grades) do
			table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		end

	  	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
		  	title    = 'Gang Grades',
		  	align    = 'top-left',
		  	elements = elements
	  	}, function(data, menu)
			ESX.TriggerServerCallback('gangs:getGangInventory', function(result)
				local result = result
				result = result.weapons
				local selected = {}
				local weapons = {}
				for i=1, #result, 1 do
					if not selected[result[i].name] then
						selected[result[i].name] = true
						table.insert(weapons, result[i])
					end
				end
				if #result == 0 then return ESX.Alert("Gang Shoma Hich Aslahei Nadarad", "error") end
				ESX.TriggerServerCallback("gangs:GetWeaponsByPermission", function(hagh, t)
					if t then
						for j=1, #weapons, 1 do
							weapons[j].toggle = true
						end
					else
						for i=1, #weapons, 1 do
							for _ , v in pairs(hagh) do
								if weapons[i].name == v then
									weapons[i].toggle = true
								end
							end
						end
					end
					WeaponPermission(weapons, data.current.grade, gangname, data.current.grade)
				end, data.current.grade)
			end)
	  	end, function(data, menu)
			menu.close()
			OpenBossMenu(gangname)
	  	end)
  	end)
end

function ItemPermission(weapons, grade_label, society, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local change = false
	local FalseAccess = true
	local TrueAccess = true

	table.insert(elements, {
		label = 'Access to all weapons',
		value = 'all',
		toggle = 'ON'
	})
	for i=1, #weapons, 1 do
		if weapons[i].count > 0 then
			local wep = string.upper(weapons[i].name)
			local label = weapons[i].label
			table.insert(elements, {
				label = label,
				value = i,
				toggle = weapons[i].toggle and 'ON' or 'OFF'
			})
			if weapons[i].toggle then
				FalseAccess = false
			else
				TrueAccess = false 
				elements[1].toggle = "OFF"
			end
		end
	end

	local all = FalseAccess or TrueAccess

	ESX.UI.Menu.Open('toggle', GetCurrentResourceName(), 'weapon_permission_' .. string.gsub(grade_label, " ", "_"), {
		title    = 'Item Access for ' .. grade_label,
		align    = 'top-left',
		elements = elements
	}, function(data3, menu3)
		if data3.current.value == 'all' then
			for k,v in pairs(weapons) do
				v.toggle = data3.current.toggle == 'ON' and true or false
			end
			ItemPermission(weapons, grade_label, society, grade)
		else
			change = true
			weapons[data3.current.value].toggle = data3.current.toggle == 'ON' and true or false
		end
	end, function(data3, menu3)
		if change then
			local allow = {}
			for k, v in pairs(weapons) do
				if v.toggle then
					table.insert(allow, v.name)
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableItems', society, grade, allow)
		elseif all then
			local pedaret
			for k,v in pairs(weapons) do
				if v.toggle then
					pedaret = true
				else
					pedaret = false
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableItems', society, grade, pedaret == true and "all" or {})
		end
		menu3.close()
		OpenItemAccess(society)
	end)
end

function WeaponPermission(weapons, grade_label, society, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local change = false
	local FalseAccess = true
	local TrueAccess = true
	local duplicate = {}

	table.insert(elements, {
		label = 'Access to all weapons',
		value = 'all',
		toggle = 'ON'
	})
	for i=1, #weapons, 1 do
		if not duplicate[weapons[i].name] then
			duplicate[weapons[i].name] = true
			local wep = string.upper(weapons[i].name)
			local label = string.gsub(string.gsub(wep, 'WEAPON', ''), '_', ' ')
			table.insert(elements, {
				label = label,
				value = i,
				toggle = weapons[i].toggle and 'ON' or 'OFF'
			})
			if weapons[i].toggle then
				FalseAccess = false
			else
				TrueAccess = false 
				elements[1].toggle = "OFF"
			end	
		end
	end

	local all = FalseAccess or TrueAccess

	ESX.UI.Menu.Open('toggle', GetCurrentResourceName(), 'weapon_permission_' .. string.gsub(grade_label, " ", "_"), {
		title    = 'Weapon Access for ' .. grade_label,
		align    = 'top-left',
		elements = elements
	}, function(data3, menu3)
		if data3.current.value == 'all' then
			for k,v in pairs(weapons) do
				v.toggle = data3.current.toggle == 'ON' and true or false
			end
			WeaponPermission(weapons, grade_label, society, grade)
		else
			change = true
			weapons[data3.current.value].toggle = data3.current.toggle == 'ON' and true or false
		end
	end, function(data3, menu3)
		if change then
			local allow = {}
			for k, v in pairs(weapons) do
				if v.toggle then
					table.insert(allow, v.name)
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableWeapons', society, grade, allow)
		elseif all then
			local pedaret
			for k,v in pairs(weapons) do
				if v.toggle then
					pedaret = true
				else
					pedaret = false
				end
			end
			TriggerServerEvent('gangs:ChangeAvailiableWeapons', society, grade, pedaret == true and "all" or {})
		end
		menu3.close()
		OpenArmoryAccess(society)
	end)
end

function OpenLockPickAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_lockpick_', {
		title    = "Rank Dastresi LockPick Mashin",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.lockpick_access .. " | Baraye Taghir Feshar Dahid", value = data.lockpick_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_lockpick_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi LockPick Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenLockPickAccesss(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'lockpick')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function OpenCraftAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_craft_', {
		title    = "Rank Dastresi Be Craft Aslahe",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.craft_access .. " | Baraye Taghir Feshar Dahid", value = data.craft_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_craft_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi Craft Aslahe Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenCraftAccess(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'craft')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function OpenVestAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_vest_', {
		title    = "Rank Dastresi Be Vest",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.vest_access .. " | Baraye Taghir Feshar Dahid", value = data.vest_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_vest_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi Be Vest Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenArmoryAccess(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'vest')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function SetWebhook(gangname)
	local elems = {
		{label = "Item Webhook", value = "item_webhook"},
		{label = "Weapon Webhook", value = "weapon_webhook"},
		{label = "Car Webhook", value = "vehicle_webhook"},
		{label = "Money Webhook", value = "money_webhook"},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'webhook', {
		title    = "Webhook",
		align    = 'top-right',
		elements = elems
	}, function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_webhook', {
			title = 'WebHook Discord Ro Vared Konid'
		}, function(data2, menu2)
			local webhook = data2.value
			if string.find(webhook, "/api/webhooks/") then
				local id = string.gsub(webhook, "", "")
				ESX.TriggerServerCallback('gangs:setGangAccess', function()
					ESX.Alert("Web Hook Ba Movafaghiat Sabt Shod!", "info")
				end, gangname, webhook, data.current.value)
			else
				ESX.ShowNotification('Link Vared Shode Baraye Discord Nist')
			end
			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenHeliAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_heli_', {
		title    = "Rank Dastresi Be Helicopter",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.heli_access .. " | Baraye Taghir Feshar Dahid", value = data.heli_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_heli_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi Be Helicopter Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenHeliAccess(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'heli')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function OpenVehBuyAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_buy_', {
		title    = "Rank Dastresi Kharid Mashin",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.buy_access .. " | Baraye Taghir Feshar Dahid", value = data.buy_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_buy_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi Kharid Mashin Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenVehBuyAccess(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'vehbuy')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function SetBlip(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_blip_sprite_', {
		title    = "Taghir Tarh Blip Map",
		align    = 'top-right',
		elements = {
			{label = "Tarh Alan: " .. data.blip_sprite .. " | Baraye Taghir Feshar Dahid", value = data.blip_sprite}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_heli_amount_', {
			   title = "Jahat Didan List Blip Ha Bakhsh Amoozesh Discord Server Ra Moshahede Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'), "info")
				elseif amount > 899 then
					ESX.Alert("Tedad Blip Ha 899 Ta Mibashad", "info")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						SetBlip(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod", "info")
					end, gangname, amount, 'blip_sprite')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function SetBlipColor(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_blip_color_', {
		title    = "Taghir Rang Blip",
		align    = 'top-right',
		elements = {
			{label = "Rang Blip Alan: " .. data.blip_color .. " | Baraye Taghir Feshar Dahid", value = data.blip_color}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_blip_color_amount_', {
			   title = "Jahat Didan List Rang Ha Bakhsh Amoozesh Discord Server Ra Moshahede Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				elseif amount > 86 then
					ESX.Alert("Kolan 85 Ta Rang Darim :||")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						SetBlipColor(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'blip_color')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function SetGpsColor(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_gps_', {
		title    = "Taghir Rang GPS",
		align    = 'top-right',
		elements = {
			{label = "Rang GPS Alan: " .. data.gps_color .. " | Baraye Taghir Feshar Dahid", value = data.gps_color}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_gps_amount_', {
			   title = "Jahat Didan List Rang Ha Bakhsh Amoozesh Discord Server Ra Moshahede Konid"
		    }, function(data2, menu2)
				
				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				elseif amount > 86 then
					ESX.Alert("Kolan 85 Ta Rang Darim :||")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						SetGpsColor(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'gps_color')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

function SetLogo(gangname)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_logo', {
        title    = "Link Axs Ra Vared Konid",
	}, function(data2, menu2)
		if not data2.value then
			ESX.Alert("Shoma Chizi Vared Nakardid!")
			return
		end
		local link = data2.value
		if link:find('http') then
		ESX.TriggerServerCallback('gangs:setGangAccess', function()
			ESX.Alert("Web Hook Ba Movafaghiat Sabt Shod!")
		end, gangname, link, 'logo')
		menu2.close()
		 else
		  	ESX.Alert("Link Vared Shode Eshtebah Ast!")
			return
		end
    end, function (data2, menu2)
        menu2.close()
    end)
end

function OpenInviteAccess(gangname)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_invite_', {
		title    = "Rank Dastresi Be Menu Invite",
		align    = 'top-right',
		elements = {
			   {label = "Rank Dastresi Alan: " .. data.invite_access .. " | Baraye Taghir Feshar Dahid", value = data.invite_access}
		}
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_invite_amount_', {
			   title = "Ranki Ke Mikhayd Dastresi Menu Invite Az Oon Be Bad Bashad Ra Vared Konid"
		    }, function(data2, menu2)

				local amount = tonumber(data2.value)
				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
			   	elseif amount > 12 then
				   	ESX.Alert("Rank Vared Shode Az Tedad Rank Haye Gang Bishtar Ast")
			   	else
				   	menu2.close()
					ESX.TriggerServerCallback('gangs:setGangAccess', function()
						OpenInviteAccess(gangname)
						ESX.Alert("Taghirat Ba Movafaghiyat Anjam Shod")
					end, gangname, amount, 'invite')
			   	end
			end, function(data2, menu2)
				menu2.close()
		   	end)
		end, function(data, menu)
			menu.close()
		end)
	end, gangname)
end

local spam3 = false

function OpenManageEmployeesMenu(gang, gangsdata)
	if spam3 then return end
	spam3 = true
	Citizen.SetTimeout(2000, function()
		spam3 = false
	end)
	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
	
	local tedadmember = 0
	for i=1, #employees, 1 do
		tedadmember = tedadmember + 1
	end
	
	local elements = {
		{label = "List MemberHa", value = 'employee_list'},
		{label = _U('recruit'),       value = 'recruit'},
		{label = "Slot: " .. tedadmember.."/"..data.slot,       value = 'slotsize'},
		{label = "Vest: " .. data.bulletproof.."%",       value = 'vest'},
		{label = "Limit Garage: " .. data.garage_limit.." Mashin",  value = 'garagelimit'},
		{label = "XP: " .. data.xp .." - Rank: " .. data.rank, value = 'xp_rank'},
	}
	table.insert(elements, {label = "Taghir Esm Rank Ha", value = 'manage_gradesname'})
	if data.helicopter == 1 then
		table.insert(elements, {label = "Helicopter: Gang Shoma Heli Darad", value = 'y_heli'})
	else
		table.insert(elements, {label = "Helicopter: Gang Shoma Heli Nadarad", value = 'n_heli'})
	end
	if data.craft == 1 then
		table.insert(elements, {label = "Craft: Gang Shoma Ghabeliyat Craft Darad", value = 'y_craft'})
	else
		table.insert(elements, {label = "Craft: Gang Shoma Ghabeliyat Craft Nadarad", value = 'n_craft'})
	end
	if data.lockpick == 1 then
		table.insert(elements, {label = "LockPick: Gang Shoma Ghabeliyat LockPick Darad", value = 'y_lockpick'})
	else
		table.insert(elements, {label = "LockPick: Gang Shoma Ghabeliyat LockPick Nadarad", value = 'n_lockpick'})
	end

 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_', {
		title    = _U('employee_management'),
		align    = 'top-right',
		elements = elements
	}, function(data1, menu)
	
	
 		if data1.current.value == 'employee_list' then
			OpenEmployeeList(gang)
		end
		
 		if data1.current.value == 'recruit' then
			if tedadmember <= data.slot then
				OpenRecruitMenu(gang)
			else
			ESX.Alert('Slot Gang Shoma Poor Shode Ast, Jahat Afzayesh Be Shop Server Morajee Konid Ya Rank Up Shid')
			end
		end
		if data1.current.value == 'manage_gradesname' then
			if gangsdata.rank >= 2 then
				OpenRenameGrade() -- Version Jadid
			else
				ESX.Alert("Gang Shoma Ghabeliyat Taghir Esm Nadarad, Jahat Daryaft Rank Gang Khod Ra Be ~g~2 ~s~ Beresanid", "info")
			end
		end

 	end, function(data1, menu)
		menu.close()
	end)
	end, gang)
	end, gang)
end

local spam1 = false

function OpenManageEmployeesMenuF5(gang)
	if spam1 then return end
	spam1 = true
	Citizen.SetTimeout(2000, function()
		spam1 = false
	end)
	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)
		ESX.TriggerServerCallback('gangs:getGangData', function(data)
		
		local tedadmember = 0
		for i=1, #employees, 1 do
			tedadmember = tedadmember + 1
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_f5_', {
			title    = _U('employee_management'),
			align    = 'top-right',
			elements = {
				{label = _U('recruit'),       value = 'recruit'},
				{label = "Slot: " .. tedadmember.."/"..data.slot,       value = 'slotsize'}
			}
		}, function(data1, menu)
		
			
			if data1.current.value == 'recruit' then
				if tedadmember <= data.slot then
					OpenRecruitMenu(gang)
				else
					ESX.Alert('Slot Gang Shoma Poor Shode Ast, Jahat Afzayesh Be Shop Server Morajee Konid Ya Rank Up Shid', "info")
				end
			end

		end, function(data1, menu)
			menu.close()
		end)
		end, gang)
	end, gang)
end

function OpenblackMoneyMenu(gang, b)
	local elem = {}
	if b then
		table.insert(elem, {label = "Bardasht Bodje", 	value = 'withdraw_money'})
	end
	table.insert(elem, {label = "Gozashtan Bodje"	,  	value = 'deposit_money'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'money_manage_', {
	   title    = _U('money_management'),
	   align    = 'top-right',
	   elements = elem,
   	}, function(data, menu)

		if data.current.value == 'withdraw_money' then
			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_', {
				title = _U('withdraw_money')
			}, function(data, menu)

 				local amount = tonumber(data.value)

 				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:withdrawblackMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end

 			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_', {
				title = _U('deposit_money')
			}, function(data, menu)
 
				 local amount = tonumber(data.value)
 
				 if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:depositblackMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end
 
			 end, function(data, menu)
				menu.close()
			end)

	   	end

	end, function(data, menu)
	   menu.close()
   end)
end

function OpenMoneyMenu(gang, b)
	local elem = {}
	if b then
		table.insert(elem, {label = "Bardasht Bodje", 	value = 'withdraw_money'})
	end
	table.insert(elem, {label = "Gozashtan Bodje"	,  	value = 'deposit_money'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'money_manage_', {
	   title    = _U('money_management'),
	   align    = 'top-right',
	   elements = elem,
   	}, function(data, menu)

		if data.current.value == 'withdraw_money' then
			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_', {
				title = _U('withdraw_money')
			}, function(data, menu)

 				local amount = tonumber(data.value)

 				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:withdrawMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end

 			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_', {
				title = _U('deposit_money')
			}, function(data, menu)
 
				 local amount = tonumber(data.value)
 
				 if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:depositMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end
 
			 end, function(data, menu)
				menu.close()
			end)

	   	end

	end, function(data, menu)
	   menu.close()
   end)
end

local spam2 = false

function OpenEmployeeList(gang, admin)
	if spam2 then return end
	spam2 = true
	Citizen.SetTimeout(2000, function()
		spam2 = false
	end)
 	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)

 		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

 		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].gang.grade_label == '' and employees[i].gang.label or employees[i].gang.grade_label)
			local statusEmoji = '⚫'
			if employees[i].status == 'onduty' then
				statusEmoji = '🔵'
			elseif employees[i].status == 'offduty' then
				statusEmoji = '🔴'
			else
				statusEmoji = '⚫'
			end
			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name.." "..employees[i].lastLogin,
					gradeLabel.." "..statusEmoji,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}',
					employees[i].profilePicture
				}
			})
		end

 		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_', elements, function(data, menu)
			local employee = data.data

 			if data.value == 'promote' then
				if employee.gang.grade == 13 and PlayerData.gang.grade < 13 then
					return ESX.Alert("Shoma Ejaze Promote Kardan Rank 13 Ra Nadarid", "info")
				end
				menu.close()
				OpenPromoteMenu(gang, employee)
			elseif data.value == 'fire' then
				if employee.gang.grade == 13 and PlayerData.gang.grade < 13 then
					return ESX.Alert("Shoma Ejaze Fire Kardan Rank 13 Ra Nadarid", "info")
				end
				if employee.identifier == PlayerData.identifier then return end
				ESX.Alert(_U('you_have_fired', employee.name), "info")

 				ESX.TriggerServerCallback('gangs:setGang', function()
					if not admin then
						OpenEmployeeList(gang)
					end
				end, employee.identifier, 'nogang', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			if not admin then
				OpenManageEmployeesMenu(gang)
			end
		end)

 	end, gang)

end

exports("OpenEmployeeList", OpenEmployeeList) 

function OpenRecruitMenu(gang)

 	ESX.TriggerServerCallback('gangs:getOnlinePlayers', function(players)

 		local elements = {}

 		for i=1, #players, 1 do
			if players[i].gang.name ~= gang then
				if ESX.Game.PlayerExist(players[i].source) then
					local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(players[i].source))))
					if distance <= 20 then
						table.insert(elements, {
							label = players[i].name:gsub('_',' '),
							value = players[i].source,
							name = players[i].name,
							identifier = players[i].identifier,
							id = players[i].source,
						})
					end
				end
			end
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_', {
			title    = _U('recruiting'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_', {
				title    = _U('do_you_want_to_recruit', data.current.id),
				align    = 'top-right',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

 				if data2.current.value == 'yes' then
					ESX.Alert(_U('you_have_hired', data.current.id), "info")

 					ESX.TriggerServerCallback('gangs:setGang', function()
						OpenRecruitMenu(gang)
					end, data.current.identifier, gang, 1, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end)

end

function OpenPromoteMenu(gangname, employee)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)
		local gang = gang
		local counter = #gang.grades
		counter = 12
 		local elements = {}

 		for i=1, counter, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

 			table.insert(elements, {
				label = gradeLabel,
				value = gang.grades[i].grade,
				selected = (employee.gang.grade == gang.grades[i].grade)
			})
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_', {
			title    = _U('promote_employee', employee.name),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.Alert(_U('you_have_promoted', employee.name, data.current.label))

 			ESX.TriggerServerCallback('gangs:setGang', function()
				OpenEmployeeList(gangname)
			end, employee.identifier, gangname, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(gangname)
		end)

 	end, gangname)

end


function OpenManageGradesMenu(gangname)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)

 		local elements = {}

 		for i=1, #gang.grades, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

 			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(gang.grades[i].salary))),
				value = gang.grades[i].grade
			})
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_', {
			title    = _U('salary_management'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_', {
				title = _U('salary_amount')
			}, function(data2, menu2)

 				local amount = tonumber(data2.value)

 				if amount == nil then
					ESX.Alert(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.Alert(_U('invalid_amount_max'))
				else
					menu2.close()

 					ESX.TriggerServerCallback('gangs:setGangSalary', function()
						OpenManageGradesMenu(gangname)
					end, gang, data.current.value, amount)
				end

 			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end, gangname)

end

AddEventHandler('gangs:openBossMenu', function(gang, close, options)
	OpenBossMenu(gang, close, options)
end)

AddEventHandler('gangs:openInviteF5', function(gang, close, options)
	OpenManageEmployeesMenuF5(gang)
	close()
end)

local Tr = {
    liberty = "Liberty",
    MazeBank = "Maze Bank",
    LifeInsurance = "Bime",
    Bobcat = "Bobcat",
    CBank = "Central Bank",
	ShBank = "Paleto Bank",
	--Shipment = "Shipment"
}

RegisterNetEvent("esx_ghore:AnnounceRob")
AddEventHandler("esx_ghore:AnnounceRob", function(time, otherWorld)
	while not PlayerData.gang do Citizen.Wait(1000) end
	if PlayerData.gang.name ~= "nogang" and PlayerData.gang.name ~= "Military" then
		if time == 5 then
			if not otherWorld then
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
					args = { GetPlayerServerId(PlayerId()), "قرعه کشی ورلد اول رابری 5 دقیقه دیگر آغاز میشود" }
				})
			else
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
					args = { GetPlayerServerId(PlayerId()), "قرعه کشی ورلد دوم رابری 5 دقیقه دیگر آغاز میشود" }
				})
			end
		elseif time == 10 then
			if not otherWorld then
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
					args = { GetPlayerServerId(PlayerId()), "قرعه کشی ورلد اول رابری 10 دقیقه دیگر آغاز میشود" }
				})
			else
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
					args = { GetPlayerServerId(PlayerId()), "قرعه کشی ورلد دوم رابری 10 دقیقه دیگر آغاز میشود" }
				})
			end
		end
	end
end)

RegisterNetEvent("esx_ghore:robCoolDown")
AddEventHandler("esx_ghore:robCoolDown", function(rob)
	while not PlayerData.gang do Citizen.Wait(1000) end
	if PlayerData.gang.name ~= "nogang" then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Robbery "..Tr[rob].." Az CoolDown Kharej Shod" }
		})
	end
end)

RegisterNetEvent("esx_ghore:RobWinner")
AddEventHandler("esx_ghore:RobWinner", function(name, rob, time, World)
	while not PlayerData.gang do Citizen.Wait(1000) end
	if PlayerData.gang.name ~= "nogang" and PlayerData.gang.name ~= "Military" then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [Robbery System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Gange "..name.." Barande Ghore Keshi "..World.." Robbery "..Tr[rob].." Shod!" }
		})
		if PlayerData.gang.name == name then
			TimerThread(time)
		end
	end
end)

RegisterNetEvent("esx_ghore:forceCloseUI")
AddEventHandler("esx_ghore:forceCloseUI", function()
	while not ESX do Citizen.Wait(100) end
	ESX.UI.Menu.CloseAll()
end)

function TimerThread(time)
	local diff = time - exports.sr_main:GetTimeStampp()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			if diff <= 0 then
				break
			end
			diff = diff - 1
			ESX.ShowMissionText("~g~Robbery Time:~w~ "..diff.."s")
		end
	end)
end

RegisterNetEvent("gangwar:announceCancelWar")
AddEventHandler("gangwar:announceCancelWar", function(requested, requester)
	while not PlayerData.gang do Citizen.Wait(1000) end
	if PlayerData.gang.name == requester then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(34, 186, 100, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [GangWar System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Darkhast Gangwar Shoma Be Gang "..requested.." Ghabool Nashod" }
		})
	end
	if PlayerData.gang.name == requested then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(34, 186, 100, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [GangWar System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Gang Shoma Darkhast GangWar Az Gang "..requester.." Ra Ghabool Nakard"}
		})
	end
end)

RegisterNetEvent("gangwar:announceWar")
AddEventHandler("gangwar:announceWar", function(requested, requester)
	while not PlayerData.gang do Citizen.Wait(1000) end
	if PlayerData.gang.name == requester then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(34, 186, 100, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [GangWar System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Gang Shoma Be Gang "..requested.." Darkhast GangWar Dad!" }
		})
	end
	if PlayerData.gang.name == requested then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(34, 186, 100, 0.9);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> [GangWar System]: <br> {1}</div>',
			args = { GetPlayerServerId(PlayerId()), "Gang "..requester.." Be Gang Shoma Darkhast GangWar Dade Ast, Baraye Javab Dadan 10 Daghighe Forsat Darid"}
		})
	end
end)

function OpenGangWar()
	local gangname = PlayerData.gang.name
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("gangwar:GetData", function(datas, limit, ongoing, request, capture) 
		if capture then return ESX.Alert("Gangwar Be Dalil Capture Dar Dastres Nist") end
		local datas = datas
		local limit = limit 
		local ongoing = ongoing
		local request = request
		local elem = {}
		if request then
			table.insert(elem, {label = "Darkhast GangWar Az Taraf "..request, value = nil})
			table.insert(elem, {label = "=================================", value = nil})
			table.insert(elem, {label = "❌- Rad Kardan", value = "no"})
			table.insert(elem, {label = "✅- Ghabool Kardan", value = "yes"})
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_gangwar',
			{
				title = 'GangWar',
				align = 'center',
				elements = elem,
			},
			function(data, menu)
				if PlayerData.gang.grade < 12 then return ESX.Alert("Faghat Rank Haye 12 Va 13 Mitavanand Tayid Ya Rad Konand", "info") end
				local action = data.current.value
				if action then
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent("gangwar:submitRequest", action)
				end
			end, function(data, menu)
				OpenBossMenu(gangname)
			end)
		else
			for k, v in pairs(datas) do
				if v >= 5 and k ~= gangname then
					table.insert(elem, {label = k..", Online: "..v, value = k})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_gangwar',
			{
				title = 'Darkhast GangWar',
				align = 'center',
				elements = elem,
			},
			function(data, menu)
				if PlayerData.gang.grade < 12 then return ESX.Alert("Faghat Rank Haye 12 Va 13 Mitavanand Darkhast Bedahand", "info") end
				if limit then return ESX.Alert("Har Gang Dar Har Restart Faghat Yekbar Mitavand Dar GangWar Sherkat Konad", "info") end
				if ongoing then return ESX.Alert("Shoma Dar Hale Hazer Yek Darkhast GangWar Dadid", "info") end
				local action = data.current.value
				if action then
					Citizen.Wait(750)
					menu.close()
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
					{
						title 	 = 'Darkhast Gangwar Be '..action,
						align    = 'center',
						question = "Aya Mikhahid Be Gange "..action.." Darkhast Bedahid?",
						elements = {
							{label = 'Kheyr', value = 'no'},
							{label = 'Bale', value = 'yes'},
						}
					}, function(data2, menu2)
						ESX.UI.Menu.CloseAll()
						if data2.current.value == "yes" then
							TriggerServerEvent("gangwar:requestToGang", action)
						end
					end)
				end
			end, function(data, menu)
				OpenBossMenu(gangname)
			end)
		end
	end)
end

function OpenGhoreKeshi()
	local gangname = PlayerData.gang.name
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("esx_ghore:GetRobData", function(data, count, ban, members, world) 
		local elem = {
			{label = "Your Gang Robbery Cards: "..data[gangname].Cards.."x", value = true},
			{label = "Entekhab Kardan Robbery", value = false},
			{label = "Tedad Member Haye Online: "..members, value = nil},
			{label = "=====Gang Haye Hazer Dar Ghore=====", value = nil}
		}
		for k, v in pairs(data) do
			local text = nil
			if tLength(v.Rob) > 0 then
				text = ""
				local counter = 0
				for s, i in pairs(v.Rob) do
					if i then
						if counter == 0 then
							text = Tr[s]..","
							counter = counter + 1
						else
							text = text..""..Tr[s]
						end
					end
				end
			end
			if v.Cards > 0 then 
				table.insert(elem, {label = k..": "..v.Cards.."x"..(text and ", ["..text.."]" or ""), value = nil})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_rob',
		{
			title = 'GhoreKeshi Robbery',
			align = 'center',
			elements = elem,
		},
		function(data, menu)
			local action = data.current.value
			if action then
				if members < 5 then return ESX.Alert("Shoma Baraye Sherkat Dar Ghorekeshi Bayad Hadeaghal 5 nafar bashid", "info") end
				if ban then return ESX.Alert("Gang Shoma Be Tazegi Dar Ghore Keshi Barande Shode!", "info") end
				if count > 0 then
					menu.close()
					Citizen.Wait(500)
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
					{
						title 	 = 'Gozashtan Robbery Card',
						align    = 'center',
						question = "Aya Mikhahid Meghdar "..count.."x RC Ra Bezarid??",
						elements = {
							{label = 'Kheyr', value = 'no'},
							{label = 'Bale', value = 'yes'},
						}
					}, function(data2, menu2)
						ESX.UI.Menu.CloseAll()
						if data2.current.value == "yes" then
							TriggerServerEvent("esx_ghore:AddRC")
							Citizen.Wait(2000)
							OpenGhoreKeshi()
						elseif data2.current.value == "no" then
							OpenGhoreKeshi()
						end
					end)
				else
					ESX.Alert("Shoma Hich Robbery Card ei Nadarid", "info")
				end
			elseif action == false then
				if members < 5 then return ESX.Alert("Shoma Baraye Sherkat Dar Ghorekeshi Bayad Hadeaghal 5 nafar bashid", "info") end
				if ban then return ESX.Alert("Gang Shoma Be Tazegi Dar Ghore Keshi Barande Shode!", "info") end
				menu.close()
				ESX.TriggerServerCallback("esx_ghore:GetRobStats", function(info)
					if tLength(info) == 0 then
						ESX.TriggerServerCallback("esx_ghore:GetNotCoolDown", function(db)
							shellUpgrades(db)
						end, world)
					else
						shellUpgrades(info)
					end
				end)
			end
		end, function(data, menu)
			OpenBossMenu(gangname)
		end)
	end)
end

local CartNeed = {
    liberty = 5,
    MazeBank = 6,
    LifeInsurance = 6,
    Bobcat = 5,
    CBank = 6,
	ShBank = 4,
	Shipment = 7
}

function shellUpgrades(datas)
	local gangname = PlayerData.gang.name
	ESX.TriggerServerCallback("esx_ghore:GetRobData", function(dataz, count, ban, members) 
		local cards = dataz[gangname].Cards
		local datas = datas
		ESX.UI.Menu.CloseAll()
		local elements = {}
		for k,v in pairs(datas) do
			local condition = "❌"
			if v then
				condition = "✔️"
			end
			if Tr[k] then
				table.insert(elements, {label = Tr[k] .. " " .. condition, value = k, status = v})
			end
		end
	
		table.insert(elements, {label = " Confirm", value = "confirm"})
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade_rob',
		{
			title    = "Entekhab Kardan Robbery",
			align    = 'center',
			elements = elements,
		}, function(data, menu)
			if data.current.value == "confirm" then
				if CheckTrue(datas) then
					menu.close()
					TriggerServerEvent("esx_ghore:AddRobs", datas)
					Citizen.Wait(2000)
					OpenGhoreKeshi()
				else
					ESX.Alert("Shoma Bayad 2 Robbery Entekhab Kardid", "info")
				end
			else
				if data.current.status == false and CheckTrue(datas) then
					ESX.Alert("Shoma Bishtar Az 2 Robbery Nemitavanid Entekhab Konid", "info")
				elseif data.current.status == false and cards < CartNeed[data.current.value] then
					ESX.Alert("Baraye Entekhab In Robbery Bayad Hadeaghal "..CartNeed[data.current.value].."x Robbery Cart Bezarid", "info")
				else
					datas[data.current.value] = not data.current.status
					shellUpgrades(datas)
				end
			end 
		end, function(data, menu)
			OpenGhoreKeshi()
		end)
	end)
end

function CheckTrue(data)
	local check = false
	local count = 0
	for k, v in pairs(data) do
		if v then
			count = count + 1
			if count >= 2 then
				check = true
			end
		end
	end
	return check
end

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end