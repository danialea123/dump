ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	local Keys = {
		["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
		["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
		["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 191,
		["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
		["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
		["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
		["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
		["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
		["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

	local GUI      = {}
	GUI.Time       = 0
	local MenuType = 'default'

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
		if menu then
			if menu.submit ~= nil then
				menu.submit(data, menu)
			end
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu then
			if menu.cancel ~= nil then
				menu.cancel(data, menu)
			end
		end
		cb('OK')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		for i=1, #data.elements, 1 do
			if menu then
				menu.setElement(i, 'value', data.elements[i].value)
				if data.elements[i].selected then
					menu.setElement(i, 'selected', true)
				else
					menu.setElement(i, 'selected', false)
				end
			end
		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	local function MenuKey(key)
		if ESX.UI.Menu.AnyOpen() > 0 then
			SendNUIMessage({
				action  = 'controlPressed',
				control = key
			})
		end
	end

	RegisterKey('RETURN', function () MenuKey('ENTER') end)
	RegisterKey('BACK', function () MenuKey('BACKSPACE') end)
	RegisterKey('ESCAPE', function () MenuKey('BACKSPACE') end)
	RegisterKey('MOUSE_RIGHT', function () MenuKey('BACKSPACE') end)
	RegisterKey('UP', function () MenuKey('TOP') end)
	RegisterKey('DOWN', function () MenuKey('DOWN') end)
	RegisterKey('RIGHT', function () MenuKey('RIGHT') end)
	RegisterKey('LEFT', function () MenuKey('LEFT') end)
end)
