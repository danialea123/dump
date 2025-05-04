---@diagnostic disable: param-type-mismatch, missing-parameter
ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false
local near = {active = false}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback('esx_weaponshop:getShop', function(shopItems)
        for k,v in pairs(shopItems) do
            Config.Zones[k].Items = v
        end
    end)
end)

RegisterNetEvent('esx_weaponshop:sendShop')
AddEventHandler('esx_weaponshop:sendShop', function(shopItems)
    for k,v in pairs(shopItems) do
        Config.Zones[k].Items = v
    end
end)

function OpenBuyLicenseMenu(zone)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license', {
        title = _U('buy_license'),
        align = 'top-left',
        elements = {
            { label = _U('no'), value = 'no' },
            { label = _U('yes', ('<span style="color: green;">%s</span>'):format((_U('shop_menu_item', ESX.Math.GroupDigits(Config.LicensePrice))))), value = 'yes' },
        }
    }, function(data, menu)
        if data.current.value == 'yes' then
            ESX.TriggerServerCallback('esx_weaponshop:buyLicense', function(bought)
                if bought then
                    menu.close()
                    OpenShopMenu(zone)
                end
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenShopMenu(zone)
    local elements = {}
    ShopOpen = true

    if Config.Blur then
    SetTimecycleModifier('hud_def_blur') -- blur
    end

    SendNUIMessage({
        display = true,
        clear = true
    })

    SetNuiFocus(true, true)

    for i=1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]
        SendNUIMessage({
            itemLabel = item.label,
            item = item.item,
            price = ESX.Math.GroupDigits(item.price),
            desc = '',
            imglink = item.imglink,
            zone = zone,
            type = item.type
        })
    end

    ESX.UI.Menu.CloseAll()
   -- PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.25, 0.25)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DisplayBoughtScaleform(weaponName, price)
    local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
    local sec = 4

    BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

    PushScaleformMovieMethodParameterString(_U('weapon_bought', ESX.Math.GroupDigits(price)))
    PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))
    PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
    PushScaleformMovieMethodParameterString('')
    PushScaleformMovieMethodParameterInt(100)

    EndScaleformMovieMethod()

   -- PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

    Citizen.CreateThread(function()
        while sec > 0 do
            Citizen.Wait(0)
            sec = sec - 0.01
    
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end

AddEventHandler('esx_weaponshop:hasEnteredMarker', function(zone)
    if zone == 'GunShop' or zone == 'BlackWeashop' then
        CurrentAction     = 'shop_menu'
        CurrentActionMsg  = _U('shop_menu_prompt')
        CurrentActionData = { zone = zone }
    end
    if zone == 'Club' then
        CurrentAction     = 'shop_club'
        CurrentActionMsg  = _U('shop_menu_prompt')
        CurrentActionData = { zone = zone }
    end
end)

AddEventHandler('esx_weaponshop:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if ShopOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        if v.Legal then
            for i = 1, #v.Locations, 1 do
                local blip = AddBlipForCoord(v.Locations[i])

                SetBlipSprite (blip, 110)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, 0.6)
                SetBlipColour (blip, 4)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(_U('map_blip'))
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

-- Display markers
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if near.active then
			DrawMarker(-1, near.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
            DrawText3Ds(near.coords.x, near.coords.y, near.coords.z + 1.0, '~g~E~w~ - Open Shop')
		else
			Citizen.Wait(500)
		end
	end
end)]]

function NearAny()
    local coords = GetEntityCoords(PlayerPedId())

    for k,v in pairs(Config.Zones) do
        for i=1, #v.Locations, 1 do
            if Vdist(v.Locations[i].x, v.Locations[i].y, v.Locations[i].z, coords) < Config.DrawDistance then
                near = {active = true, coords = vector3(v.Locations[i].x, v.Locations[i].y, v.Locations[i].z) }
                return
            end
        end
    end

    near = {active = false}
end

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        NearAny()
    end
end)]]

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- Enter / Exit marker events
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone = false, nil

		for k,v in pairs(Config.Zones) do
			for i=1, #v.Locations, 1 do
				if GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.Size.x then
					isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_weaponshop:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_weaponshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('onKeyDown',function(key)
	if key == "e" then
			if CurrentAction == 'shop_menu' then
				if Config.LicenseEnable and Config.Zones[CurrentActionData.zone].Legal then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
						if hasWeaponLicense then
							OpenShopMenu(CurrentActionData.zone)
						else
							OpenBuyLicenseMenu(CurrentActionData.zone)
						end
					end, GetPlayerServerId(PlayerId()), 'weapon')
				else
					OpenShopMenu(CurrentActionData.zone)
				end
                CurrentAction = nil
            elseif CurrentAction == 'shop_club' then
                OpenShopMenu(CurrentActionData.zone)
			end
	end
end)]]

local Spam = false

RegisterNUICallback('buyItem', function(data, cb)
    Citizen.Wait(math.random(100, 500))
    if Spam then return end
    Spam = true
    Citizen.SetTimeout(2000, function()
        Spam = false
    end)
    ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function()

    end, data.item, data.zone, data.horam)
end)

RegisterNetEvent('esx_customItems:useArmor')
AddEventHandler('esx_customItems:useArmor', function()
	local ped = PlayerPedId()
    ESX.TriggerServerCallback("esx_weaponshop:doesHaveArmour", function(has)
        if has then
            TriggerEvent("mythic_progbar:client:progress", {
                name = "armor_putin",
                duration = 5000,
                label = "Dar hale poshidan armor...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "rcmfanatic3",
                    anim = "kneel_idle_a",
                },
                prop = {
                    model = "prop_bodyarmour_03",
                }
            },function(status)
                if not status then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 27,  ['bproof_2'] = 5})
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 6,  ['bproof_2'] = 3})
                        end
                    end)
                    ESX.SetPedArmour(ped, 50)
                    ESX.Alert("Shoma ba movafaghiat Armor use kardid!", "check")
                    TriggerServerEvent("esx_weaponshop:usedArmour")
                elseif status then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                end
            end)
        end
    end)
end)

RegisterNUICallback('focusOff', function(data, cb)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if Config.Blur then 
        SetTimecycleModifier('default') -- remove blur
    end
end) 

RegisterNetEvent("esx_admin:muteState")
AddEventHandler("esx_admin:muteState", function(state)
    TriggerEvent("pma-voice:mutePlayer")
end)

Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_y_ammucity_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_ammucity_01")) do
        Citizen.Wait(10)
    end
    for k,v in pairs(Config.Zones["GunShop"].Locations) do
        local entity = CreatePed(4, "s_m_y_ammucity_01", v.x, v.y, v.z-1, false, false)
        SetEntityHeading(entity, v.w or v.h)
        SetEntityAsMissionEntity(entity, true, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
        Wait(100)
        FreezeEntityPosition(entity, true)
        SetEntityInvincible(entity, true)
        exports['diamond_target']:AddTargetEntity(entity, {
            options = {
                {
                    entity = entity,
                    canInteract = function()
                        return true
                    end,
                    action = function()
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                            if hasWeaponLicense then
                                OpenShopMenu("GunShop")
                            else
                                OpenBuyLicenseMenu("GunShop")
                            end
                        end, GetPlayerServerId(PlayerId()), 'weapon')
                    end,
                    icon = "fa fa-hand",
                    label = "Open Weaponshop"
                }
            },
            distance = 3.0
        })
    end
end)