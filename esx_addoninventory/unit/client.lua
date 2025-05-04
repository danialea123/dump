---@diagnostic disable: trailing-space, missing-parameter
ESX = nil 
local PlayerData              = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterCommand('unitsystem',function() 
	TriggerEvent('Unit:OpenMenu')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	TriggerServerEvent('Unit:ChangeJob')	
	Citizen.Wait(5000)
	PlayerData.job = job 
end)

local allow = {
	["police"] = true,
	["sheriff"] = true,
	["forces"] = true,
	["ambulance"] = true,
	["medic"] = true,
}

RegisterNetEvent('Unit:OpenMenu')
AddEventHandler('Unit:OpenMenu',function()
	if allow[PlayerData.job.name] then
		OpenUnitMenu() 
	end
end)

function OpenUnitMenu() 
	ESX.TriggerServerCallback('Unit:GetUnits', function(UnitList) 
		local elements = {}
		table.insert(elements, {label = ("My Unit"), value = true})
		table.insert(elements, {label = ("Create Unit"), value = 1})
		table.insert(elements, {label = ("[------- UNIT -------]"), value = false})
			for k,v in pairs(UnitList) do 
				if type(UnitList[k].Members) == 'table' then 
					table.insert(elements, {label = UnitList[k].Name, value = UnitList[k].Owner})
				end 
			end 
		table.insert(elements, {label = ("[------- UNIT -------]"), value = false })
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'unt',
		{
			title    = "Units",
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local action = data.current.value
			if action == true then 
				ESX.TriggerServerCallback('Unit:OpenUnit', function(Unit ,AllUnit , MyUnit ) 
					if type(Unit) == 'table' then 
						menu.close()
						ShowUnit(Unit , MyUnit)
					elseif Unit == false then 
						menu.close()
						ESX.ShowNotification('Shoma Ozve Uniti Nistid ')
						OpenUnitMenu() 
					end 
				end, action )
			elseif action == 1 then 
				ESX.TriggerServerCallback('Unit:CreateUnit', function(Unit ,AllUnit ) 
					if type(Unit) == 'table' then 
						menu.close()
						ShowUnit(Unit , true )
					elseif Unit == false then 
						menu.close()
						ESX.ShowNotification('Shoma Yek Unit Darid ')
						OpenUnitMenu() 
					else 
						ESX.ShowNotification('Shoma Nmitavnid Unit Besazid')
					end 
				end, action )
			elseif action == 1 then 
				MangeUnit()
			elseif type(action) == 'string'  then 
				ESX.TriggerServerCallback('Unit:OpenUnit', function(Unit ,AllUnit , MyUnit ) 
					menu.close()
					if type(Unit) == 'table' then 
						ShowUnit(Unit , MyUnit)
					else 
						OpenUnitMenu() 
					end 
				end, action )
			end 
		end, function(data, menu)
		menu.close()
		end)
	end)
end 
function ShowUnit(Unit , MyUnit )
	local elements = {}
    table.insert(elements, {label = ("[------- UNIT -------]"), value = false})
	if type(Unit.Members) == 'table' then 
		table.insert(elements, {label = 'Name :' .. Unit.Name, value = Unit.Name})
		table.insert(elements, {label = ("------- MAX : 5 -------"), value = false})
		for k,v in pairs(Unit.Members) do 
			ESX.TriggerServerCallback('Unit:GetName', function(Name) 
			table.insert(elements, {label = Name, value = v})
			end , v) 
		end 
	end 
	Wait(200)
	if MyUnit then 
		table.insert(elements, {label = ("Exit Unit [❌] "), value = 'exit'})
	else  
		table.insert(elements, {label = ("Join Unit [✔️] "), value = 'join'})
	end 
	table.insert(elements, {label = ("[------- UNIT -------]"), value = false })
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'unt',
	{
		title    = "Units",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local action = data.current.value
		if action == Unit.Name then 
            if PlayerData.identifier == Unit.Owner then 
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'setname',
                    {
                        title = 'Esm jadid unit Ra Vared Konid',
                    },
                    function(data3, menu3)
                        menu3.close()
                         ESX.TriggerServerCallback('Unit:SetUnitName', function(done )
                            if done then 
                                ESX.ShowNotification('Esm Jadid Zakhire shod') 
                                OpenUnitMenu() 
                            end 
                         end, data3.value)
                    end,
                    function(data3, menu3)
                        menu3.close()
                    end
                )
            end 
        end 
		if action == 'join' then 
			ESX.TriggerServerCallback('Unit:JoinUnit', function(Unit ,AllUnit ) 
				menu.close()
				if type(Unit) == 'table' then 
					ShowUnit(Unit , true)
				else 
					ESX.ShowNotification('Shoma Nmitvanid Ozv In Unit Shavid')
					OpenUnitMenu() 
				end 
			end, Unit.Key )
		elseif action == 'exit' then 
			ESX.TriggerServerCallback('Unit:ExitUnit', function(Unit ,AllUnit ) 
				menu.close() 
				OpenUnitMenu() 
			end, Unit.Key )
	    end 
	end, function(data, menu)
		OpenUnitMenu()
    end)
end 
--