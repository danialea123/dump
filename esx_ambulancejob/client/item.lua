---@diagnostic disable: undefined-field, lowercase-global, lowercase-global
local usingItem = false
local usingAdr = false
local stuffOut = 0
local blackListLocation = {
    vec(881.03,-2274.51,32.44, 60),
    vec(841.01,-1976.87,29.34, 50),
    vec(-622.02,-230.73,38.06, 50),
    vec(2739.5,3476.34,55.69, 50),
    vec(253.25,221.11,106.29, 60),
    vec(-769.49,258.83,75.64, 50),
    vec(-1061.1,-238.84,39.73, 60),
    vec(-1298.78,-825.87,17.15, 60),
    vec(2440.1,4971.98,46.81, 70),
    vec(-1121.1,4925.07,218.51, 110),
    vec(-104.47,6469.29,31.63, 50),
    vec(314.3796, -277.005, 54.17448, 40),
    vec(150.0218, -1039.106, 29.36794, 40),
    vec(-1214.004, -329.6872, 37.78094, 40),
    vec(-2964.122, 482.0504, 15.69694, 40),
    vec(-350.4414, -48.3444, 49.04592, 40),
    vec(1175.336, 2705.246, 38.0893, 40),
    vec(-107.06, 6474.80, 31.62, 40),
    vec(831.71,-2027.42,29.33, 50),
    vec(-1041.57,-2146.67,13.59, 50),
    vec(570.43,-3126.36,6.07, 200),
}

RegisterNetEvent('medic:useItem',function(name)
    if usingItem then return end
    if name == 'adr' and (not ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == -1 or usingAdr) then
        return ESX.Alert('Shoma nemitavanid in item ra use konid!', "info")
    end
    local coords = GetEntityCoords(PlayerPedId())
    local canUse = true
    for k , v in pairs(blackListLocation) do
        if ESX.GetDistance(coords,v.xyz) <= v.w then
            canUse = false
            break
        end
    end
    if canUse then
        TriggerServerEvent('medic:useItem',name)
    else
        ESX.Alert('Shoma nemitavanid in item ra dar in makan use konid!', "info")
    end
end)

RegisterNetEvent('medic:useItem2',function(name)
    if name == 'adr' and (not ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == -1 or usingAdr) then
        return ESX.Alert('Shoma nemitavanid in item ra use konid!', "info")
    end
    usingItem = true
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
    local playerPed = PlayerPedId()
    exports.essentialmode:DisableControl(true)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        Citizen.Wait(500)
        Citizen.CreateThread(function()
            while usingItem do
                Citizen.Wait(0)
                DisableAllControlActions(0)
                if not IsEntityPlayingAnim(playerPed, lib, anim, 3) then
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end
            end
            ClearPedTasks(PlayerPedId())
        end)
    end)
    if name == 'adr' then
        ESX.SetPlayerState('adrenaline',true)
        usingAdr = true
        TriggerEvent("mythic_progbar:client:progress", {
            name = "pp",
            duration = 60000,
            label = "Using Adrenaline...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            },
        }, function(status)
        end)
        Citizen.Wait(60000)
        if ESX.GetPlayerData().IsDead == true then
            exports.essentialmode:DisableControl(false)
            adrenalineThread()
        end
    end
    usingItem = false
end)

function medicResetADR()
    usingAdr = false
    ESX.ClearTimeout(stuffOut)
    exports['TextUI']:Close()
end

function adrenalineThread()
    ESX.ClearTimeout(stuffOut)
    TriggerEvent('esx_ambulancejob:revive', 150)
    Wait(2000)
    stuffOut = ESX.SetTimeout(15 * 60 * 1000,function()
        if usingAdr then
            usingAdr = false
            ESX.SetPlayerState('adrenaline',false)
        end
    end)
    if ESX.GetPlayerData().IsDead then
        return
    end
    Wait(2500)
    CreateThread(function()
        while usingAdr do
            Citizen.Wait(0)
            disableFiring()
        end
    end)
    CreateThread(function()
        while usingAdr do
            Citizen.Wait(2000)
            ExecuteCommand("walk drunk")
        end
        ExecuteCommand("walk reset")
    end)
    local timer = 15 * 60
    CreateThread(function()
        while timer > 0 and usingAdr do
            exports['TextUI']:Open('Adrenaline Timer<br>'.. timer .. 's', 'lightgreen', 'left')
            timer = timer - 1
            Citizen.Wait(1000)
        end
        usingAdr = false
        exports['TextUI']:Close()
        ESX.SetPlayerState('adrenaline',false)
    end)
end

function disableFiring()
	DisablePlayerFiring(PlayerId(),true)
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisableControlAction(0,263,true) -- disable melee
	DisableControlAction(0,264,true) -- disable melee
	DisableControlAction(0,257,true) -- disable melee
	DisableControlAction(0,140,true) -- disable melee
	DisableControlAction(0,141,true) -- disable melee
	DisableControlAction(0,142,true) -- disable melee
	DisableControlAction(0,143,true) -- disable melee
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 69, true) -- Melee Attack 1
	DisableControlAction(0, 70, true)
	DisableControlAction(0, 92, true)
    DisableControlAction(0, 21, true)
    DisableControlAction(0,22,true)
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
    end
end