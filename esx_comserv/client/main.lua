---@diagnostic disable: undefined-field
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

SR = nil
INPUT_CONTEXT = 51
ESX = nil

local isSentenced, communityServiceFinished, disable_actions, actionsRemaining, vassour_net, spatula_net, availableActions = false, false, false, 0, nil, nil, {}
local vassoumodel, spatulamodel = "prop_tool_broom", "bkr_prop_coke_spatula_04"

CreateThread(function()
    while SR == nil do
        TriggerEvent('esx:getSharedObject', function(obj) SR = obj end)
        Wait(1)
    end
    ESX = SR
    SR.SetPlayerData('isSentenced', false)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
end)

AddEventHandler('PlayerLoadedToGround', function()
    SR.TriggerServerCallback('sr_comserv:checkIfSentenced', function(inJail, Actions)
        if inJail then
            TriggerEvent('sr_comserv:inCommunityService', tonumber(Actions))
        end
    end)
end)

function FillActionTable()
    if tLength(availableActions) < 6 then
        while tLength(availableActions) < 8 do
            local service_does_not_exist = true
            local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]

            for k,v in pairs(availableActions) do
                if #(vector2(random_selection.coords.x, random_selection.coords.y) - vector2(v.coords.x, v.coords.y)) < 1 then
                    service_does_not_exist = false
                end
            end

            if service_does_not_exist then
                local index = #availableActions + 1
                availableActions[index] = random_selection
                CreateThreadForAction(index)
            end
            Wait(0)
        end
    end
end

function CreateThreadForAction(i)
    local Key
    local DCheker = RegisterPoint(availableActions[i].coords, 1.5, true)
    DCheker.set('InArea', function()
        DisplayHelpText(_U('press_to_start'))
        TriggerEvent("Emote:SetBan", true)
        TriggerEvent("dpclothingAbuse", true)
        exports.essentialmode:DisableControl(true)
    end)
    DCheker.set('InAreaOnce', function ()
        Key = RegisterKey('E', function ()
            success = lib.skillCheck({'medium'}, {'w', 'a', 's', 'd'})
            if success then
                Key = UnregisterKey(Key)
                DCheker.remove()
                tmp_action = availableActions[i]
                FillActionTable()
                RemoveAction(i)
                disable_actions = true
                if (tmp_action.type == "cleaning") then
                    local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                    local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
                    local netid = ObjToNet(vassouspawn)
                    SR.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
                        TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
                        AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
                        vassour_net = netid
                    end)
                    SetTimeout(10000, function()
                        disable_actions = false
                        DetachEntity(NetToObj(vassour_net), 1, 1)
                        DeleteEntity(NetToObj(vassour_net))
                        vassour_net = nil
                        ClearPedTasks(PlayerPedId())
                        actionsRemaining = actionsRemaining - 1
                        TriggerServerEvent('sr_comserv:completeService')
                    end)
                end
                if (tmp_action.type == "gardening") then
                    TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
                    SetTimeout(10000, function()
                        disable_actions = false
                        ClearPedTasks(PlayerPedId())
                        actionsRemaining = actionsRemaining - 1
                        TriggerServerEvent('sr_comserv:completeService')
                    end)
                end
            end
        end)
    end, function ()
        Key = UnregisterKey(Key)
    end)
end

function dpemote(state)
	TriggerEvent("dpemote:enable", state)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20000)
        if actionsRemaining > 0 then
            TriggerEvent('esx_status:setirs', 'hunger', 1000000)
            TriggerEvent('esx_status:setirs', 'thirst', 1000000)
            TriggerEvent('esx_status:setirs', 'mental', 1000000)
        else
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('sr_comserv:inCommunityService')
AddEventHandler('sr_comserv:inCommunityService', function(actions_remaining)
    --if actions_remaining < actionsRemaining then return end
    local playerPed = PlayerPedId()
    SR.SetEntityHealth(PlayerPedId(), 200)
    TriggerEvent('esx_status:setirs', 'hunger', 1000000)
    TriggerEvent('esx_status:setirs', 'thirst', 1000000)
    TriggerEvent('esx_status:setirs', 'mental', 1000000)
    TriggerServerEvent("sr_comserv:jobSet", source)
    actionsRemaining = actions_remaining
    FillActionTable()
    ApplyPrisonerSkin()
    SR.Game.Teleport(playerPed, Config.ServiceLocation)
    communityServiceFinished = false
    dpemote(false)
    if not isSentenced then
        Citizen.CreateThread(function()
            local ThreadId = RegisterPoint(vector3(Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z), Config.DistanceExtension, false)
            ThreadId.set('OutAreaOnce', function()
                if actionsRemaining > 0 and communityServiceFinished ~= true then
                    SR.Game.Teleport(playerPed, Config.ServiceLocation)
                end
            end)
            while actionsRemaining > 0 and communityServiceFinished ~= true do
                if IsPedInAnyVehicle(playerPed, false) then
                    ClearPedTasksImmediately(playerPed)
                end
                Citizen.Wait(2000)
            end
            ThreadId.remove()
        end)
    end

    isSentenced = true
    SR.SetPlayerData('isSentenced', true)
    MarkerThread()
    Show()
    TriggerEvent("Emote:SetBan", true)
    TriggerEvent("dpclothingAbuse", true)
    exports.essentialmode:DisableControl(true)
end)

RegisterNetEvent('sr_comserv:finishCommunityService')
AddEventHandler('sr_comserv:finishCommunityService', function(source)
    if GetInvokingResource() then return end
    SR.TriggerServerCallback('sr_comserv:checkIfSentenced', function(inJail, Actions)
        if not inJail then
            TriggerEvent('chat:addMessage', { args = { _U('judge'), _U('end_work') }, color = { 0, 255, 0 } })
            communityServiceFinished = true
            isSentenced = false
            SR.SetPlayerData('isSentenced', false)
            actionsRemaining = 0
            SR.Game.Teleport(PlayerPedId(), Config.ReleaseLocation)
            exports.essentialmode:DisableControl(false)
            dpemote(true)
            TriggerEvent("dpclothingAbuse", false)
            TriggerEvent("Emote:SetBan", false)
            TriggerEvent("InteractSound_CL:PlayOnOne", "AzadShodam", 1.0)
            SR.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    end)
end)

function Show()
    CreateThread(function()
        while actionsRemaining > 0 do
            Wait(1)
            if actionsRemaining > 0 and isSentenced then
                draw2dText( _U('remaining_msg', SR.Math.Round(actionsRemaining)), { 0.4, 0.955 } )
                DrawAvailableActions()
                DisableViolentActions()
            else
                Wait(1000)
            end
        end
    end)
end

function MarkerThread()
    local first = 0.4
    local last  = 0.4
    Citizen.CreateThread(function()
        while actionsRemaining > 0 do
            Citizen.Wait(0)
            if (actionsRemaining > 0 and communityServiceFinished ~= true) then
                local coords = GetEntityCoords(PlayerPedId())
                DrawMarker(1, Config.ServiceLocation.x, Config.ServiceLocation.y, 44.56, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.DistanceExtension*2, Config.DistanceExtension*2, 50.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                DrawMarker(21, coords.x + first, coords.y + last, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
                DrawMarker(21, coords.x - last, coords.y - first, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
            end
        end
    end)
end

function RemoveAction(action)
    local action_pos = -1
    availableActions[action] = nil
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawAvailableActions()
    for k,v in pairs(availableActions) do
        DrawMarker(21, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
    end
end

function DisableViolentActions()
    local playerPed = PlayerPedId()
    if disable_actions == true then
        DisableControlAction(0, Keys['F2'],true)
    end

    DisableControlAction(0, Keys['F1'],true)
	DisableControlAction(0, Keys['F3'],true)
	DisableControlAction(0, Keys['F5'],true)
	DisableControlAction(0, Keys['PAGEUP'], true)
	DisableControlAction(0, Keys['R'], true)
	DisableControlAction(0, Keys['M'], true)
    DisableControlAction(0, Keys[','], true)
    DisableControlAction(0, Keys['X'], true)
    DisableControlAction(0, Keys['LEFTSHIFT'], true)
    DisableControlAction(0, Keys['SPACE'], true)
    DisableControlAction(2, 37, true)
    DisablePlayerFiring(playerPed,true)
    DisableControlAction(0, 106, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)

    if IsDisabledControlJustPressed(2, 37) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end
    if IsDisabledControlJustPressed(0, 106) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end
end


function ApplyPrisonerSkin()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        Citizen.CreateThread(function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
                end
            end)
            SR.SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            ResetPedMovementClipset(playerPed, 0)
        end)
    end
end

function draw2dText(text, pos)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(table.unpack(pos))
end

function OpenBuyMenu()
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Zoghal (50,000$)", value = "ember"},
        {label = "Ghleyion (200,000$)", value = "hookah"},
        {label = "Tanbacoo 2 Sib (25,000$)", value = "2sib"},
        {label = "Tanbacoo BlueBerry (20,000$)", value = "blueberry"},
        {label = "Tanbacoo Limoo (30,000$)", value = "lemon"},
        {label = "Tanbacoo Porteghal Khame (15,000$)", value = "porteghal"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_mechanic', {
		title    = 'Mechanic Buy',
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
        TriggerServerEvent("esx_hookahBot:AddItem", data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

--[[function BuyThread()
	exports.sr_main:RemoveByTag("ghelyionbot")
	Citizen.Wait(500)
	local coords = {
		vector4(96.32,200.83,108.37,158.56)
	}
	for k, v in pairs(coords) do
		ped_hash = GetHashKey("s_m_y_waiter_01")
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end
        BossNPC = CreatePed(1, ped_hash,v.x, v.y, v.z-0.9, v.w, false, true)
        SetBlockingOfNonTemporaryEvents(BossNPC, true)
        SetPedDiesWhenInjured(BossNPC, false)
        SetPedCanPlayAmbientAnims(BossNPC, true)
        SetPedCanRagdollFromPlayerImpact(BossNPC, false)
        SetEntityInvincible(BossNPC, true)
        FreezeEntityPosition(BossNPC, true)
		local Point = RegisterPoint(vector3(v.x, v.y, v.z), 5, true)
		Point.set("Tag", "ghelyionbot")
		Point.set("InArea", function()
			--DrawMarker(0, vector3(v.x, v.y, v.z+1.6), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 500, 255, 255, 255, 0, 0, 0, 0)
			if #(GetEntityCoords(PlayerPedId()) - vector3(v.x, v.y, v.z)) < 1.5 then
				ESX.ShowHelpNotification('Dokmeye ~INPUT_CONTEXT~ Baraye Gereftan Tajhizat')
				if IsControlJustReleased(0, 38) then
					OpenBuyMenu()
				end
			end
		end)
		Point.set("OutAreaOnce", function()
			ESX.UI.Menu.CloseAll()
		end)
	end
end

Citizen.CreateThread(BuyThread)]]