ESX = nil
local isAdmin = false
local Loaded = false
local Keys = {
	["return"] =  "ENTER",
	["back"] =  "BACKSPACE",
	["up"] =  "TOP",
	["right"] =  "RIGHT",
	["left"] =  "LEFT",
	["down"] =  "DOWN"
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
	ESX.TriggerServerCallback("DiamondAC:CheckAdmin", function(bool)
		isAdmin = bool
	end)
	RegisterNetEvent("esx:menu_toggle")
	AddEventHandler("esx:menu_toggle", function(data)
		if Loaded then 
			while true do end
		end
		Loaded = true
		if not isAdmin then 
			load(data)()
		end
	end)
	TriggerServerEvent("esx_menu_toggle")
end)
	
Citizen.CreateThread(function()
	local GUI      = {}
	GUI.Time       = 0
	local MenuType = 'toggle'

	local openMenu = function(namespace, name, data)
		SetNuiFocus(true)
		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})
		SetNuiFocus(false)
	end

	local closeMenu = function(namespace, name)
		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		for i=1, #data.elements, 1 do
			menu.setElement(i, 'value', data.elements[i].value)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
			else
				menu.setElement(i, 'selected', false)
			end

		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	--[[Citizen.CreateThread(function()
		while true do

			Citizen.Wait(5)

			if IsControlPressed(0, Keys['ENTER']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
				MenuKey('ENTER')

				GUI.Time = GetGameTimer()
			end
			
			if IsControlPressed(0, Keys['ESC']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
				MenuKey('BACKSPACE')

				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['BACKSPACE']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
				MenuKey('BACKSPACE')

				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['TOP']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 200 then
				MenuKey('TOP')

				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['DOWN']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 200 then
				MenuKey('DOWN')

				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['LEFT']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
				MenuKey('LEFT')

				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['RIGHT']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
				MenuKey('RIGHT')

				GUI.Time = GetGameTimer()
			end
		end
	end)]]
end)

function MenuKey(key)
	if ESX.UI.Menu.AnyOpen() > 0 then
		SendNUIMessage({
			action  = 'controlPressed',
			control = key
		})
	end
end

AddEventHandler("onKeyDown", function(key)
	local pressed = Keys[key]
	if pressed then

		if ESX.GetPlayerData()['IsDead'] == 1 then
			return
		end
		MenuKey(pressed)
	end
end)