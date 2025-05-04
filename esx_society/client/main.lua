---@diagnostic disable: undefined-field, unused-local, missing-parameter, lowercase-global, undefined-global
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	PlayerData = ESX.GetPlayerData()
end)

local Morgans = {
	["police"] = true,
	["sheriff"] = true,
	["fbi"] = true,
	["forces"] = true,
}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	PlayerData.job = job
end)

function OpenBossMenu(society, close, options)
	if ESX.GetPlayerData().job.name ~= society then return end
	local isBoss = ESX.GetPlayerData().job.grade_name == 'boss'
	local employeeAccess = ESX.GetPlayerData().job.grade_name == 'chimp'
	local options  = options or {}
	local elements = {}

	--[[ESX.TriggerServerCallback('esx_society:isBoss', function(result)
		isBoss = result
	end, society)]]
		local defaultOptions = {
			withdraw  = true,
			deposit   = true,
			employees = true,
			grades    = true
		}

		for k,v in pairs(defaultOptions) do
			if options[k] == nil then
				options[k] = v
			end
		end

		local nakon = false
		if ESX.GetPlayerData().job.name == "benny" and ESX.GetPlayerData().job.grade == 7 then
			nakon = true
		end

		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money, black_money)
			table.insert(elements ,{label = 'Society Money: <span style="color:green;">$'.. ESX.Math.GroupDigits(money) .. '</span>', value = nil})
			table.insert(elements ,{label = 'Society Black Money: <span style="color:yellow;">$'.. ESX.Math.GroupDigits(black_money) .. '</span>', value = nil})
			if isBoss and options.withdraw and not nakon then
				table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
			end

			if options.deposit or isBoss then
				table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
			end

			if isBoss then
				table.insert(elements, {label = "Withdraw Black Money", value = 'withdraw_black_money'})
			end

			table.insert(elements, {label = "Deposit Black Money", value = 'deposit_black_money'})

			if isBoss or employeeAccess then
				table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
			end

			if isBoss and options.grades then
				table.insert(elements, {label = 'Manage Grades', value = 'manage_grades'})
			end

			if isBoss and Morgans[society] then
				table.insert(elements, {label = 'Taghir Lebas Swat', value = 'swat_clothes'})
			end

			if isBoss and (society == "ambulance" or society == "medic") then
				table.insert(elements, {label = 'Taghir Lebas Jarah', value = 'Surgeon_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Security', value = 'Security_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Psychology', value = 'Psychology_clothes'})
			end
			
			if isBoss then
				table.insert(elements, {label = 'Taghir Lebas Heli', value = 'heli_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Dispatch', value = 'dispatch_clothes'})
			end

			if isBoss and Morgans[society] then
				table.insert(elements, {label = 'Taghir Lebas Xray', value = 'xray_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Riot', value = 'riot_clothes'})
			end

			if isBoss and Morgans[society] then
				table.insert(elements, {label = 'Taghir Lebas D.E.A', value = 'dea_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Traffic Enforcement', value = 'tre_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Detective', value = 'detective_clothes'})
			end

			if isBoss and society == "justice" then
				table.insert(elements, {label = 'Taghir Lebas Lawyer', value = 'lawyer_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Judge', value = 'judge_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Prosecutor', value = 'prosecutor_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Marshal', value = 'marshal_clothes'})
			end

			if isBoss and society == "forces" then
				table.insert(elements, {label = 'Taghir Lebas K9', value = 'k9_clothes'})
				table.insert(elements, {label = 'Taghir Lebas DEAT', value = 'deat_clothes'})
				table.insert(elements, {label = 'Taghir Lebas NOOSE', value = 'noose_clothes'})
				table.insert(elements, {label = 'Taghir Lebas MT', value = 'mt_clothes'})
				table.insert(elements, {label = 'Taghir Lebas GTF', value = 'gtf_clothes'})
				table.insert(elements, {label = 'Taghir Lebas Air', value = 'air_clothes'})
			end

			if isBoss and society == "fbi" then
				table.insert(elements, {label = 'Taghir Lebas HR', value = 'hr'})
				table.insert(elements, {label = 'Taghir Lebas FA', value = 'fa'})
				table.insert(elements, {label = 'Taghir Lebas ASD', value = 'asd'})
				table.insert(elements, {label = 'Taghir Lebas CID', value = 'cid'})
				table.insert(elements, {label = 'Taghir Lebas CD', value = 'cd'})
				table.insert(elements, {label = 'Taghir Lebas IO', value = 'io'})
				table.insert(elements, {label = 'Taghir Lebas VSD', value = 'vsd'})
				table.insert(elements, {label = 'Taghir Lebas CIRG', value = 'cirg'})
				table.insert(elements, {label = 'Taghir Lebas HRT', value = 'hrt'})
				table.insert(elements, {label = 'Taghir Lebas BAU', value = 'bau'})
				table.insert(elements, {label = 'Taghir Lebas NCAVC', value = 'ncavc'})
				table.insert(elements, {label = 'Taghir Lebas TOC', value = 'toc'})
				table.insert(elements, {label = 'Taghir Lebas CNU', value = 'cnu'})
			end

			if isBoss then
				table.insert(elements, {label = 'Taghir Lebas (Custom)', value = 'custom'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
				title    = _U('boss_menu'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'withdraw_society_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
						title = _U('withdraw_amount')
					}, function(data, menu2)
						local amount = tonumber(data.value)

						if amount == nil then
							ESX.Alert(_U('invalid_amount'), "error")
						else
							menu.close()
							menu2.close()
							TriggerServerEvent('esx_society:withdrawMoney', society, amount)
						end
					end, function(data, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'deposit_money' then
					menu.close()
					OpenDepositMoney(society, close, options)
				elseif data.current.value == 'withdraw_black_money' then
					menu.close()
					OpenWithdrawBlackMoney(society, close, options)
				elseif data.current.value == 'deposit_black_money' then
					menu.close()
					OpenDepositBlackMoney(society, close, options)
				elseif data.current.value == 'wash_money' then

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society, {
						title = _U('wash_money_amount')
					}, function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil then
							ESX.Alert(_U('invalid_amount'), "error")
						else
							menu.close()
							TriggerServerEvent('esx_society:washMoney', society, amount)
						end

					end, function(data, menu)
						menu.close()
					end)

				elseif data.current.value == 'manage_employees' then
					OpenManageEmployeesMenu(society)
				elseif data.current.value == 'manage_grades' then
					OpenManageGradesMenu(society)
				elseif data.current.value == "swat_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleSWATClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "xray_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleXrayClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "dea_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleDeaClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "tre_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleTreClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "detective_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleDetectiveClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "lawyer_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleLawyerClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "judge_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleJudgeClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "prosecutor_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleProsecutorClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "marshal_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleMarshalClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "heli_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleHeliClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "dispatch_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleDispatchClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "hr" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleHRClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "fa" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleFAClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "asd" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleASDClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "cid" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleCIDClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "cd" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleCDClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "riot_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleRiotClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "io" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleIOClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "vsd" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleVSDClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "cirg" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleCIRGClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "hrt" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleHRTClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "bau" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleBAUClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "ncavc" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleNCAVCClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "toc" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleTOCClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "Surgeon_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleSurgeonClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "Security_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleSecurityClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "cnu" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleCNUClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "custom" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleCustomClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "k9_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleK9Clothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "mt_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleMTClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "gtf_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleGTFClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "noose_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleNOOSEClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "air_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleAirClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "deat_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandleDEATClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == "Psychology_clothes" then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value, "esx_society:HandlePSYClothe")
					end, function(data2, menu2)
						menu2.close()
					end)
				end

			end, function(data, menu)
				if close then
					close(data, menu)
				end
			end)
		end, ESX.PlayerData.job.name)
end

function OpenWithdrawBlackMoney(society, close, options)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
		title = _U('deposit_amount')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil then
			ESX.Alert(_U('invalid_amount'), "error")
		else
			menu.close()
			TriggerServerEvent('esx_society:withdrawBlackMoney', society, amount)
			OpenBossMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenDepositMoney(society, close, options)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
		title = _U('deposit_amount')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil then
			ESX.Alert(_U('invalid_amount'), "error")
		else
			menu.close()
			TriggerServerEvent('esx_society:depositMoney', society, amount)
			OpenBossMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenDepositBlackMoney(society, close, options)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
		title = _U('deposit_amount')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil then
			ESX.Alert(_U('invalid_amount'), "error")
		else
			menu.close()
			TriggerServerEvent('esx_society:depositBlackMoney', society, amount)
			OpenBossMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenManageEmployeesMenu(society)
	local isBoss = ESX.GetPlayerData().job.grade_name == 'boss'
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('employee_list'), value = 'employee_list'},
			{label = _U('recruit'),       value = 'recruit'},
			{label = "Employee Divisions",       value = 'division'},
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end

		if data.current.value == 'division' and (Morgans[society] or society == "ambulance" or society == "medic" or society == "benny" or society == "mechanic" or society == "weazel") then
			if isBoss then
				OpenDivisionMenu(society)
			end
		end

	end, function(data, menu)
		menu.close()
	end)
end

local spProtect = false

function OpenDivisionMenu(society)
	if spProtect then return ESX.Alert("Spam Nakonid", "error") end
	Citizen.SetTimeout(10000, function()
		spProtect = false
	end)
	ESX.TriggerServerCallback("esx_society:getEmployees", function(data) 
		local element = {}
		local employees = data
		for i=1, #employees, 1 do
			if employees[i].division ~= "police" then
				table.insert(element, {label = employees[i].name.." | "..employees[i].job.grade_label.." | Division: "..employees[i].division, value = employees[i].identifier})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_pedaret', {
			title    = "Division List",
			align    = 'top-left',
			elements = element,
		}, function(data, menu)
			local data = data
			local eleme = {
				{label = "Swat", value = "swat"},
				{label = "Traffic Enforcement", value = "tre"},
				{label = "Drug Enforcement Administration(D.E.A)", value = "dea"},
				{label = "Detective", value = "detective"},
				{label = "Xray", value = "xray"},
				{label = "Riot", value = "riot"},
				{label = "Dispatch", value = "dispatch"},
				{label = "Heli", value = "heli"},
				{label = "No Division", value = "police"},
			}
			if society == "ambulance" then
				eleme = {
					{label = "Surgeon", value = "surgeon"},
					{label = "Security", value = "security"},
					{label = "Dispatch", value = "dispatch"},
					{label = "DarooSaz", value = "drs"},
					{label = "Heli", value = "heli"},
					{label = "No Division", value = "police"},
				}
			end
			if society == "medic" then
				eleme = {
					{label = "Surgeon", value = "surgeon"},
					{label = "Security", value = "security"},
					{label = "Dispatch", value = "dispatch"},
					{label = "DarooSaz", value = "drs"},
					{label = "Heli", value = "heli"},
					{label = "No Division", value = "police"},
				}
			end
			if society == "mechanic" then
				eleme = {
					{label = "Dispatch", value = "dispatch"},
					{label = "Heli", value = "heli"},
					{label = "No Division", value = "police"},
				}
			end
			if society == "weazel" then
				eleme = {
					{label = "Dispatch", value = "dispatch"},
					{label = "Heli", value = "heli"},
					{label = "No Division", value = "police"},
				}
			end
			if society == "benny" then
				eleme = {
					{label = "Dispatch", value = "dispatch"},
					{label = "Heli", value = "heli"},
					{label = "No Division", value = "police"},
				}
			end
			if society == "fbi" then
				eleme = {
					{label = "HR", value = "hr"},
					{label = "FA", value = "fa"},
					{label = "ASD", value = "asd"},
					{label = "CID", value = "cid"},
					{label = "CD", value = "cd"},
					{label = "IO", value = "io"},
					{label = "VSD", value = "vsd"},
					{label = "CIRG", value = "cirg"},
					{label = "HRT", value = "hrt"},
					{label = "BAU", value = "bau"},
					{label = "NCAVC", value = "ncavc"},
					{label = "TOC", value = "toc"},
					{label = "CNU", value = "cnu"},
					{label = "Heli", value = "heli"},
					{label = "Dispatch", value = "dispatch"},
					{label = "SWAT", value = "swat"},
					{label = "X-Ray", value = "xray"},
					{label = "No Division", value = "police"},
				}
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_babaye_pedaret', {
				title    = "Taghir Division",
				align    = 'top-left',
				elements = eleme
			}, function(data2, menu2)
				menu2.close()
				print(data.current.value, data2.current.value)
				TriggerServerEvent("esx:setPlayerDivision", data.current.value, data2.current.value)
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

local SpamProtection = false 

function OpenEmployeeList(society)
	local isBoss = ESX.GetPlayerData().job.grade_name == 'boss'
	if not SpamProtection then
		Citizen.CreateThread(function()
			SpamProtection = true
			Citizen.SetTimeout(15000, function()
				SpamProtection = false
			end)
			ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
				local elements = {
					head = {_U('employee'), _U('grade'), _U('actions')},
					rows = {}
				}
				for i=1, #employees, 1 do
					local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)
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
							(society:find('police')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or (society:find('sheriff')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or (society:find('forces')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or (society:find('fbi')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or (society:find('benny')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or (society:find('justice')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or '{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}' or (society:find('mechanic')) and '{{' .. _U('promote') .. '|promote}} {{Swap|swap}} {{' .. _U('fire') .. '|fire}}' or '{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}',
							employees[i].profilePicture
						}
					})
					if i == #employees then
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employeelist_' .. society, elements, function(data, menu)
							local employee = data.data
							if data.value == 'promote' then
								--if not isBoss then return end
								SpamProtection = false
								if employee.job.grade >= ESX.GetPlayerData().job.grade then
									return ESX.Alert("Shoma Ejaze Nadarid High Rank Ya Ham Rank Khod Ra Promote Konid", "error")
								end
								menu.close()
								OpenPromoteMenu(society, employee)
							elseif data.value == 'swap' then
								SpamProtection = false
								if not isBoss then return end
								menu.close()
								OpenSwapMenu(society, employee)
							elseif data.value == 'fire' then
								SpamProtection = false
								if employee.job.grade < ESX.GetPlayerData().job.grade or ESX.GetPlayerData().aduty then
									ESX.ShowNotification(_U('you_have_fired', employee.name))
									ESX.TriggerServerCallback('esx_society:setJob', function()
										OpenEmployeeList(society)
									end, employee.identifier, 'unemployed', 0, 'fire')
								else
									ESX.Alert("Shoma Ejaze Nadarid High Rank Ya Ham Rank Khod Ra Fire Konid", "error")
								end
							end
						end, function(data, menu)
							menu.close()
							SpamProtection = false
							OpenManageEmployeesMenu(society)
						end)
					end
				end
			end, society)
		end)
	else
		ESX.Alert("~y~Spam Nakon Dawsh", "error")
	end
end

function OpenSwapMenu(society, employee)
	local elements = {}
	if society == "police" then
		elements = {
			{label = 'Special Forces', value ='forces'},
			{label = 'FBI', value ='fbi'},
			{label = 'Sheriff', value ='sheriff'},
			{label = 'Justice', value ='justice'},
		}
	elseif society == "justice" then
		elements = {
			{label = 'Special Forces', value ='forces'},
			{label = 'FBI', value ='fbi'},
			{label = 'Sheriff', value ='sheriff'},
			{label = 'Police', value ='police'},
		}
	elseif society == "sheriff" then
		elements = {
			{label = 'Special Forces', value ='forces'},
			{label = 'FBI', value ='fbi'},
			{label = 'Police', value ='police'},
			{label = 'Justice', value ='justice'},
		}
	elseif society == "fbi" then
		elements = {
			{label = 'Special Forces', value ='forces'},
			{label = 'Sheriff', value ='sheriff'},
			{label = 'Police', value ='police'},
			{label = 'Justice', value ='justice'},
		}
	elseif society == "forces" then
		elements = {
			{label = 'FBI', value ='fbi'},
			{label = 'Sheriff', value ='sheriff'},
			{label = 'Police', value ='police'},
			{label = 'Justice', value ='justice'},
		}
	elseif society == "benny" then
		elements = {
			{label = 'Mechanic', value ='mechanic'},
		}
	elseif society == "mechanic" then
		elements = {
			{label = 'Benny', value ='benny'},
		}
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'swape', {
		title    ='Be koja swap she?',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_society:getJob', function(job)
			local elements = {}

			for i=1, #job.grades-2, 1 do
				local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
	
				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.job.grade == job.grades[i].grade)
				})
			end
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promotee_employee_' .. society, {
				title    = _U('promote_employee', employee.name),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				menu.close()
				menu2.close()
				ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))
	
				ESX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, data.current.value, data2.current.value, 'promote')
			end, function(data2, menu2)
				menu2.close()
			end)
		end, data.current.value)
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
		OpenEmployeeList(society)
	end)
end

function OpenRecruitMenu(society)

	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				if ESX.Game.PlayerExist(players[i].source) then
					local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(players[i].source))))
					if distance <= 20 then
						table.insert(elements, {
							label = players[i].name:gsub('_',' '),
							value = players[i].source,
							name = players[i].name,
							identifier = players[i].identifier
						})
					end
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.Alert(_U('you_have_hired', data.current.name), "check")

					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, 1, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPromoteMenu(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i=1, #job.grades, 1 do
			if ESX.PlayerData.job.grade > job.grades[i].grade then
				local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.job.grade == job.grades[i].grade)
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.Alert(_U('you_have_promoted', employee.name, data.current.label), "check")

			ESX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)
	end, society)
end

function ChooseClothes(society, grade, gender, event)
	local LastSkin
	local LastGender
	local Armor = GetPedArmour(PlayerPedId())
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
		LastGender = skin['sex']
	end)
	LastSkin['sex'] = gender

	if not (Armor > 0) then
		ESX.SetPedArmour(PlayerPedId(), 1)
	end
	ESX.TriggerServerCallback(event or 'esx_society:GetJobGradeClothe', function(clothe)
		TriggerEvent('skinchanger:loadClothes', LastSkin, json.decode(clothe))
		TriggerEvent("esx_skin:openRestrictedMenu",
			function(data, menu)
				menu.close()
		
				ESX.UI.Menu.Open(
					"default",
					GetCurrentResourceName(),
					"shop_confirm",
					{
						title = 'Aya Motmaenid Mikhayd in lebas ro zakhire konid?',
						align = "top-right",
						elements = {
							{label = _U("yes"), value = "yes"},
							{label = _U("no"), value = "no"}
						}
					},
					function(data2, menu2)
						menu2.close()
		
						if data2.current.value == "yes" then
							TriggerEvent(
								"skinchanger:getSkin",
								function(skin)
									local clothe = skin
									local sex = skin.sex
									for k,v in pairs(clothe) do
										if 
											not 
											(
												k == "tshirt_1" or
												k == "tshirt_2" or
												k == "torso_1" or
												k == "torso_2" or
												k == "decals_1" or
												k == "decals_2" or
												k == "arms" or
												k == "mask_1" or
												k == "mask_2" or
												k == "pants_1" or
												k == "pants_2" or
												k == "shoes_1" or
												k == "shoes_2" or
												k == "chain_1" or
												k == "chain_2" or
												k == "helmet_1" or
												k == "helmet_2" or
												k == "glasses_1" or
												k == "glasses_2" or
												k == "bags_1" or
												k == "bags_2" or
												k == "bproof_1" or
												k == "bproof_2"
											)
										then
											clothe[k] = nil
										end
									end
									TriggerServerEvent(event or "esx_society:ChangeGradeSkin", skin, society, grade, tonumber(sex))
								end
							)
						end
						ESX.SetPedArmour(PlayerPedId(), Armor)
						LastSkin['sex'] = LastGender
						TriggerEvent("skinchanger:loadSkin", LastSkin)
					end
				)
			end,
			function(data, menu)
				ESX.SetPedArmour(PlayerPedId(), Armor)
				LastSkin['sex'] = LastGender
				TriggerEvent("skinchanger:loadSkin", LastSkin)
			end,
			{
				"tshirt_1",
				"tshirt_2",
				"torso_1",
				"torso_2",
				"decals_1",
				"decals_2",
				"arms",
				"mask_1",
				"mask_2",
				"pants_1",
				"pants_2",
				"shoes_1",
				"shoes_2",
				"chain_1",
				"chain_2",
				"helmet_1",
				"helmet_2",
				"glasses_1",
				"glasses_2",
				"bags_1",
				"bags_2",
				"bproof_1",
				"bproof_2",
			}, function(name, value)
				if name == 'bproof_1' then
					ESX.SetPedArmour(PlayerPedId(), (Armor > 0) and Armor or 1)
				end
			end
		)
	end, society, grade, gender)
end

function WeaponPermission(weapons, grade_label, society, grade)
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
			TriggerServerEvent('esx_society:ChangeAvailiableWeapon', society, grade, allow)
		elseif all then
			TriggerServerEvent('esx_society:ChangeAvailiableWeapon', society, grade, "all")
		end
		menu3.close()
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
		local vehicleName = ESX.GetVehicleLabelFromName(cars[i].model)
		local car = vehicleName
		table.insert(elements, {
			label = car,
			value = i,
			toggle = cars[i].toggle and 'ON' or 'OFF'
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
					table.insert(allow, v.model)
				end
			end
			TriggerServerEvent('esx_society:ChangeAvailiableVehicles', society, grade, allow)
		elseif all then
			TriggerServerEvent('esx_society:ChangeAvailiableVehicles', society, grade, "all")
		end
		menu3.close()
	end)
end

function ItemPermission(cars, grade_label, society, grade, change)
	ESX.UI.Menu.CloseAll()
	local cars = cars
	local elements = {}
	local change = change or false
	local FalseAccess = true
	local TrueAccess = true

	table.insert(elements, {
		label = 'Access to all Items',
		value = 'all',
		toggle = 'ON'
	})

	for i=1, #cars do
		if cars[i].count > 0 then
			if not cars[i].name:find("m_") and not cars[i].name:find("f_") then
				local vehicleName = cars[i].label
				local car = vehicleName
				table.insert(elements, {
					label = car,
					value = i,
					toggle = cars[i].toggle and 'ON' or 'OFF'
				})
				if cars[i].toggle then
					FalseAccess = false
				else
					TrueAccess = false 
					elements[1].toggle = "OFF"
				end
			end
		end
	end

	local all = FalseAccess or TrueAccess

	ESX.UI.Menu.Open('toggle', GetCurrentResourceName(), 'item_permission_' .. string.gsub(grade_label, " ", "_"), {
		title    = 'Item Access for ' .. grade_label,
		align    = 'top-left',
		elements = elements
	}, function(data3, menu3)
		if data3.current.value == 'all' then
			for k,v in pairs(cars) do
				v.toggle = data3.current.toggle == 'ON' and true or false
			end
			ItemPermission(cars, grade_label, society, grade, data3.current.toggle == 'ON' and false or true)
		else
			change = true
			cars[data3.current.value].toggle = data3.current.toggle == 'ON' and true or false
		end

	end, function(data3, menu3)
		if change then
			local allow = {}
			for k,v in pairs(cars) do
				if v.toggle then
					table.insert(allow, v.name)
				end
			end
			TriggerServerEvent('esx_society:ChangeAvailiableItems', society, grade, allow)
		elseif all then
			TriggerServerEvent('esx_society:ChangeAvailiableItems', society, grade, "all")
		end
		menu3.close()
	end)
end

function OpenManageGradesMenu(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = 'Manage Grades',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local grade = data.current.value
			local grade_label = data.current.label
			local elements = {
				{label = 'Change Name', value = 'name'},
				--{label = 'Change Salary', value = 'salary'},
				{label = 'Change Outfit', value = 'outfit'},
				{label = 'Vehicle Permission', value = 'vehicle'},
				{label = 'Item Permission', value = 'item'},
			}
			if Morgans[PlayerData.job.name] or PlayerData.job.name == "justice" then
				table.insert(elements, {label = 'Weapon Permission', value = 'weapon'})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_' .. string.gsub(grade_label, " ", "_"), {
				title    = 'Manage ' .. grade_label,
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local choose = data2.current.value
				if choose == 'name' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_name_' .. society, {
						title = 'Esme Jadid Rank Ra Vared Konid'
					}, function(data3, menu3)
			   
						local name = data3.value

						if name == nil or string.find(name, "|") or string.len(name) > 16 then
							ESX.Alert('Esme Rank Nabyad Khali Bashad Va Bayad Az Horof Englisi Esefade Konid, Kamtar Az 15 Character', "error")
						else
							ESX.UI.Menu.CloseAll()
							ESX.TriggerServerCallback('esx_society:setRankName', function()
								OpenManageGradesMenu(society)
							end, society, grade, name)
						end
			   
					end, function(data3, menu3)
						menu3.close()
					end)
				elseif choose == "salary" then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
						title = _U('salary_amount')
					}, function(data2, menu2)
		
						local amount = tonumber(data2.value)
		
						if amount == nil or amount > Config.MaxSalary then
							ESX.Alert(_U('invalid_amount'), "error")
						else
							menu2.close()
		
							ESX.TriggerServerCallback('esx_society:setJobSalary', function()
								OpenManageGradesMenu(society)
							end, society, grade, amount)
						end
		
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif choose == 'outfit' then
					local elements = {
						{label = 'Male', 	value = 0},
						{label = 'FeMale', 	value = 1},
					}
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ChooseSex", {
						title    = 'Choose Sex',
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						ChooseClothes(society, grade, data3.current.value)
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif choose == 'weapon' then
					ESX.TriggerServerCallback('esx_society:getArmoryWeapons', function(weapons)
						ESX.TriggerServerCallback("esx_society:GetWeaponsByPermission", function(hagh, t)
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
							WeaponPermission(weapons, grade_label, society, grade, hagh)
						end, society, grade)
					end, society, grade)
				elseif choose == 'vehicle' then
					ESX.TriggerServerCallback('esx_society:GetSocietyCars', function(cars)
						ESX.TriggerServerCallback("esx_society:GetVehiclesByPermission", function(hagh, t) 
							if t then
								for j=1, #cars, 1 do
									cars[j].toggle = true
								end
							else
								for i=1, #cars, 1 do
									for _ , v in pairs(hagh) do
										if cars[i].model == v then
											cars[i].toggle = true
										end
									end
								end
							end
							VehiclePermission(cars, grade_label, society, grade)
						end, society, grade)
					end, society, grade)
				elseif choose == 'item' then
					ESX.TriggerServerCallback('esx_society:GetSocietyInventory', function(item)
						ESX.TriggerServerCallback("esx_society:GetItemsByPermission", function(hagh, t) 
							if t then
								for j=1, #item, 1 do
									item[j].toggle = true
								end
							else
								for i=1, #item, 1 do
									for _ , v in pairs(hagh) do
										if item[i].name == v then
											item[i].toggle = true
										end
									end
								end
							end
							ItemPermission(item, grade_label, society, grade)
						end, society, grade)
					end, society, grade)
				end
	
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

RegisterCommand("coord", function(source, args)
	local str = ESX.GetCoordsString(args[1] or false)
	exports.esx_shoprobbery:SetClipboard(str)
end)

function getSocietyConfig()
	return Config.AvailableCars
end

exports("getSocietyConfig", getSocietyConfig)