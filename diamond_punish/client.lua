---@diagnostic disable: undefined-field
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

-----------------------------------
local result = ""

local function IsMenuOpen()
	return JayMenu.IsMenuOpened('punish')
end

local function OpenMenu(target)
    if not IsMenuOpen() then
        Menu = {
            Target = target,
            PunishCats = {
                {"DM", false},
                {"VDM", false},
                {"NCZ", false},
                {"MIO", false},
                {"MGJ", false},
                {"RNP", false},
                {"RRD", false},
                {"RRC", false},
                {"FRP", false},
                {"CB", false},
                {"PG", false},
                {"NLR", false},
                {"HR", false},
                {"CL", false},
                {"SEARCH", false},
                {"STRP", false},
                {"MCA", false},
                {"HARAS", false},
                {"OI", false},
                {"ITS", false},
                {"FN", false},
                {"MGH", false},
                {"TR", false},
                {"MRC", false},
                {"EA", false},
                {"JAF", false},
                {"JAM", false},
                {"NRPP", false},
                {"RDM", false},
                {"TRP", false},
                {"K.O.S", false},
                {"BRP", false},
            }
        }
		JayMenu.OpenMenu('punish')
        RenderPunishMenu()
	end
end

RegisterNetEvent("esx_punish:showNote")
AddEventHandler("esx_punish:showNote", function(note)
    TriggerEvent('chat:addMessage', { args = { "^3Matn: ^0"..note } })
    ESX.UI.Menu.CloseAll()
    local elements = {
       {label = note, value = nil}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_punish_note',
    {
        title    = "Punish Note",
        align    = 'center',
        elements = elements
    }, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('esx_punish:openMenu')
AddEventHandler('esx_punish:openMenu', OpenMenu)

Citizen.CreateThread(function()
	JayMenu.CreateMenu("punish", "Diamond Punish Menu", function()
		result = ""
		return true
	end)
	JayMenu.SetTitleColor('punish', 0, 255, 255, 255)
	JayMenu.SetSubTitle('punish', 'Mark punishments')
end)

function RenderPunishMenu()
    if JayMenu.IsMenuOpened('punish') then
        for k, v in ipairs(Menu.PunishCats) do
            JayMenu.CheckBox(Config.UnminifyPunish[v[1]], v[3], function(bool)
                v[3] = bool
            end)
        end

        local clicked, hovered = JayMenu.Button("~HUD_COLOUR_RED~Confirm")
        if clicked then
            JayMenu.CloseMenu()
            result = ""
            local Punishez = {}
            for k,v in ipairs(Menu.PunishCats) do
                if v[3] then
                    table.insert(Punishez, v[1])
                end
            end
            if #Punishez > 0 then
                Citizen.Wait(1000)
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
                    title = 'Tozihat Dar Mored Punish',
                }, function(data, menu)
                    local concat = "Admin "..GetPlayerName(PlayerId())..": "
                    local description = data.value or "Hich Tozihi Baraye Akharin Punish Shoma Vared Nakarde"
                    concat = concat..description
                    menu.close()
                    TriggerServerEvent('esx_punish:PunishPlayer', Menu.Target, Punishez, concat)
                end, function(data, menu)
                    menu.close()
                end)
            end
        end

        JayMenu.Display()
        SetTimeout(0, RenderPunishMenu)
    end
end

local function IsPPMenuOpen()
	return JayMenu.IsMenuOpened('pp')
end

local function OpenPPMenu(target, data, change)
    if not IsPPMenuOpen() then
        PPMenu = {
            Target = target,
            Change = change,
            cats = {
                {"DM", 1},
                {"VDM", 1},
                {"NCZ", 1},
                {"MIO", 1},
                {"MGJ", 1},
                {"RNP", 1},
                {"RRD", 1},
                {"RRC", 1},
                {"FRP", 1},
                {"CB", 1},
                {"PG", 1},
                {"NLR", 1},
                {"HR", 1},
                {"CL", 1},
                {"SEARCH", 1},
                {"STRP", 1},
                {"MCA", 1},
                {"HARAS", 1},
                {"OI", 1},
                {"ITS", 1},
                {"FN", 1},
                {"MGH", 1},
                {"TR", 1},
                {"MRC", 1},
                {"EA", 1},
                {"JAF", 1},
                {"JAM", 1},
                {"NRPP", 1},
                {"RDM", 1},
                {"TRP", 1},
                {"K.O.S", 1},
                {"BRP", 1},
            }
        }
        for k,v in ipairs(PPMenu.cats) do
            v[2] = data[v[1]] + 1
        end
        JayMenu.OpenMenu('pp')
        RenderPPMenu()
	end
end

RegisterNetEvent('esx_punish:openPlayerPunishMenu')
AddEventHandler('esx_punish:openPlayerPunishMenu', OpenPPMenu)

Citizen.CreateThread(function()
	JayMenu.CreateMenu("pp", "Diamond Punish Menu", function()
		result = ""
		return true
	end)
    
	JayMenu.SetTitleColor('pp', 0, 255, 255, 255)
	JayMenu.SetSubTitle('pp', 'Player Punishments')
end)

local function GetPunishArray(punish)
    local count = #Config[punish]
    local array = {}
    for i=0, count do
        if i == 0 then
            table.insert(array, 'No Offence')
        else
            table.insert(array, Config[punish][i].resoan)
        end
    end
    return array
end


function RenderPPMenu()
    if JayMenu.IsMenuOpened('pp') then
        for k,v in ipairs(PPMenu.cats) do
            if 
                JayMenu.ComboBox(Config.UnminifyPunish[v[1]], GetPunishArray(v[1]), v[2], v[2], function(c)
                    if PPMenu.Change then
                        v[2] = c
                    end
                end)
            then
                if PPMenu.Change then
                    TriggerServerEvent('esx_punish:ChangePlayerPunishState', PPMenu.Target, v[1], v[2] - 1)
                end
            end
        end

        JayMenu.Display()
        SetTimeout(0, RenderPPMenu)
    end
end

function DisableKicking()
	timer = 500
	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(1)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 49, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(0, 145, true)
			DisableControlAction(0, 185, true)
			DisableControlAction(0, 251, true)
			timer = timer - 1
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if GetVehiclePedIsEntering(PlayerPedId()) ~= 0 then
			DisableKicking()
			Citizen.Wait(500)
			DisableControlAction(0, 23, false)
			DisableControlAction(0, 49, false)
			DisableControlAction(0, 75, false)
			DisableControlAction(0, 145, false)
			DisableControlAction(0, 185, false)
			DisableControlAction(0, 251, false)
			EnableControlAction(0, 23, true)
			EnableControlAction(0, 49, true)
			EnableControlAction(0, 75, true)
			EnableControlAction(0, 145, true)
			EnableControlAction(0, 185, true)
			EnableControlAction(0, 251, false)
		end
	end
end)

RegisterNetEvent("esx_punish:gangPunishes")
AddEventHandler("esx_punish:gangPunishes", function(list, date)
    OpenMenu(list, date)
end)

function OpenMenu(list, date)
	local elem = {}
    local sort = {}
    for k, v in pairs(list) do
		table.insert(sort,{
            name = k,
            count = v
        })
	end
    table.sort(sort, function(a,b)
        return a.count > b.count
    end)
	for k, v in pairs(sort) do
		table.insert(elem, {label = v.name..": "..v.count, value = nil})
	end
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'punish_show', {
		title = date,
		align = 'center',
		elements = elem
	}, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)
end