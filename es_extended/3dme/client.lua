---@diagnostic disable: missing-parameter
--[[ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)]]

local color = { r = 255, g = 255, b = 255, alpha = 255 }
local font = 0
local time = 7000
local background = {
    enable = true,
    color = { r = 0, g = 0, b = 0, alpha = 80 },
}
local dropShadow = false
local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
    if args[1] then
        text = table.concat(args, ' ')
        TriggerServerEvent('3dme:shareDisplay', text, true)
        TriggerServerEvent('DiscordBot:ToDiscord', 'medo', 'CHAT LOG', '```css\n('..GetPlayerServerId(PlayerId())..') ['..GetPlayerName(PlayerId())..']: /me '..text..'\n```', 'user', GetPlayerServerId(PlayerId()), true, false)
    else
        xPlayer.showNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
    end
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, sendMessage)
    if ESX then
        if ESX.Game.DoesPlayerExistInArea(source) then
            local offset = 1 + (nbrDisplaying*0.14)
            Display(GetPlayerFromServerId(source), text, offset, sendMessage)
        end
    end
end)

function Display(mePlayer, text, offset, chatMessage)
    local displaying = true

    -- Chat message
    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
        if dist < 2500 then
            TriggerEvent('chat:addMessage', {
                color = { color.r, color.g, color.b },
                multiline = true,
                args = { text}
            })
        end
    end

    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 2500 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
 
    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        if background.enable then
            DrawRect(_x, _y+scale/45, width, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
        end
    end
end

AddEventHandler("onKeyDown", function(key)
    if key == "e" then
        if ESX.GetPlayerData().gang.name == "Smoke" then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(315.0989, 233.8418, 104.3627), true) <= 2.0 then
                ESX.SetEntityCoords(PlayerPedId(), vector3(312.2637, 230.2681, 104.3627))
            elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(312.2637, 230.2681, 104.3627), true) <= 2.0 then
                ESX.SetEntityCoords(PlayerPedId(), vector3(315.0989, 233.8418, 104.3627))
            end
        end
    end
end)

local Spam = false

RegisterCommand('glist',function(source)
    if Spam then return ESX.Alert("Spam Nakonid", "error") end
    Spam = true
    SetTimeout(7000, function()
        Spam = false
    end)
    ESX.TriggerServerCallback('GetGangMembers', function(a, info, cc, ngang)
        if a then
            local elements = {}
            for i=1, #info, 1 do
                table.insert(elements, {
                label = info[i].name.."("..info[i].source..")"})
            end
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'test',
            {
                title = 'Afrade Online [ '..ngang..' ]  : ('..cc..') Nafar',
                align    = 'center',
                elements = elements
            },function(data2, menu2)
            end,
            function(data2, menu2) 
                menu2.close() 
            end)
        else
            ESX.Alert("~h~~r~Shoma Dar Gangi Hozur Nadarid.")
        end
    end)
  end)

