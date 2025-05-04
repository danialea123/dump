ESX = nil 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(1000)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(5000)
	end

	local coords = vector3(235.76,-897.34,29.69)
	local obj = "prop_pier_kiosk_02"
	local iu = {
		"prop_pier_kiosk_02",
	}

	exports['diamond_target']:AddTargetModel(iu, {
        options = {
            {
                icon = "fa-solid fa-newspaper",
                label = "خرید روزنامه",
                action = function(_)
					TriggerServerEvent("esx_news:buyNewsPaper")
                end,
            },
        },
        job = {"all"},
        distance = 2.0
    })

	local i = CreateObject(obj , coords.x, coords.y, coords.z, false, false, false)
	SetEntityHeading(i, 235.0)
	FreezeEntityPosition(i, true)
end)

function Open()
	ESX.TriggerServerCallback('newspaper:getdata', function(data) 
		if next(data) then 
			SendNUIMessage({message	= "getnews", news = data})
		end 
		SetNuiFocus(true, true)
		SendNUIMessage({message	= "opennews",})
	end)
end

RegisterNetEvent('newspaper:Opennews')
AddEventHandler('newspaper:Opennews',function()
	TriggerEvent("esx_inventoryhud:closeInventory")
	Open()
end)

RegisterNetEvent('newspaper:Setnews')
AddEventHandler('newspaper:Setnews',function()
	SetNewsPaper()
end)

function SetNewsPaper()
	SetNuiFocus(true, true)
	SendNUIMessage({message	= "setnews",})
end

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('notify', function(data, cb)
	ESX.Alert(data, "info")
end)

RegisterNUICallback('SaveData', function(data, cb)
	SetNuiFocus(false, false)
	ESX.TriggerServerCallback('newspaper:savedata', function(done) 
		if done then 
			ESX.Alert('Roozname Update Shod', "check")
		else 
			ESX.Alert('Baraye Taghir Roozname Bayad 10 Daghighe Sabr Konid', "check")
		end 
	end, data)
end)