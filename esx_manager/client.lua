---@diagnostic disable: undefined-global, missing-parameter, lowercase-global, param-type-mismatch, undefined-field
----------------------------------
--In Anti Cheat Az Tarkib Chand Anti Cheat Sakhte Shode Ast.
----HR_KoobsSystem  By: ^HoRam----
--Credit: Suncore, HotSun, RubyAC, VB-AC, Choco-Hax And ...
----------------------------------

ESX = nil
isAdmin = false
local OrginalPed = nil
local NewCommands = 0
local AlreadyCommands = 0
local AlreadyResources = 0
local Resources = 0
PlayerLoaded = false
WhiteListed = false
isWhitelisted = false
setExp = false
PlayerData = {}
Triggered = false
local hasVehTraced = nil
local hasObjTraced = nil
local oldVehicle, oldVehicleModel
local WeaponList = {}
local expectedDamage = {}
local Jobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
    ["ambulance"] = true,
}
local Divisions = {
    ["heli"] = true,
    ["xray"] = true,
}
local contextTable = {
    [0] = 18.0,
    [1] = 28.0,
    [2] = 20.0,
    [3] = 30.0,
    [4] = 30.0,
    [5] = 30.0,
    [6] = 30.0,
    [7] = 20.0
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(50)
    end
    while ESX.GetPlayerData().gang == nil do 
        Citizen.Wait(50)
    end
    ESX.TriggerServerCallback("DiamondAC:CheckAdmin", function(boolean, data)
        isAdmin = boolean
        expectedDamage = data
        ESX.SetPlayerData("aduty", boolean)
        PlayerData = ESX.GetPlayerData()
    end)
    WeaponList = exports.essentialmode:getWeaponList()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler("skinchanger:modelLoaded", function()
    if modelTriggered then return end
    SetTimeout(5000, function()
        OrginalPed = GetEntityModel(PlayerPedId())
        if not isAdmin then
            SetTimeout(5000, OtherStuff)
        end
        TriggerServerEvent("backme")
        modelTriggered = true
    end)
end)

function DamageHandler()
	Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BZGAS"), 0.1)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMOKEGRENADE"), 0.5)
            N_0x4757f00bc6323cfe(3204302209, 0)
            N_0x4757f00bc6323cfe(375527679, 0)
            N_0x4757f00bc6323cfe(324506233, 0)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.15)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.001)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.001)
            N_0x4757f00bc6323cfe(-1553120962, 0.0) 
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MUSKET"), 0.2)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"), 0.4)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), 0.4)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSHOTGUN"), 0.25)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPSHOTGUN"), 0.7)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"), 0.2)
            N_0x4757f00bc6323cfe(GetHashKey("weapon_doubleaction"), 0.70)
            N_0x4757f00bc6323cfe(`weapon_flashlight`, 0.15)
            N_0x4757f00bc6323cfe(`weapon_poolcue`, 0.20)
            N_0x4757f00bc6323cfe(`weapon_knuckle`, 0.68)
            N_0x4757f00bc6323cfe(`weapon_revolver`, 0.35)
            N_0x4757f00bc6323cfe(`weapon_snowball`, 0)
            N_0x4757f00bc6323cfe(`WEAPON_pistolgold`, 0.88)
            N_0x4757f00bc6323cfe(`WEAPON_ADVANCEDRIFLE`, 0.94)
            N_0x4757f00bc6323cfe(`WEAPON_PISTOL_MK2`, 0.81)
            N_0x4757f00bc6323cfe(`WEAPON_DiamondChrome`, 1.06)
            N_0x4757f00bc6323cfe(`WEAPON_ASSAULTSMG`, 0.95)
            N_0x4757f00bc6323cfe(`WEAPON_MINISMG`, 0.9)
            N_0x4757f00bc6323cfe(`WEAPON_SPECIALCARBINE`, 0.93)
            N_0x4757f00bc6323cfe(`WEAPON_HEAVYPISTOL`, 0.8)
            N_0x4757f00bc6323cfe(`WEAPON_CARBINERIFLE`, 0.96)
            N_0x4757f00bc6323cfe(`WEAPON_AKVALO1`, 1.1)
            N_0x4757f00bc6323cfe(`WEAPON_ASSAULTRIFLE`, 1.06)
            N_0x4757f00bc6323cfe(`WEAPON_SMG`, 0.9)
            N_0x4757f00bc6323cfe(`WEAPON_SNSPISTOL_MK2`, 0.9)
            N_0x4757f00bc6323cfe(`WEAPON_BULLPUPRIFLE`, 0.96)
            N_0x4757f00bc6323cfe(`WEAPON_MILITARYRIFLE`, 0.93)
            N_0x4757f00bc6323cfe(`WEAPON_AKDIAMOND`, 1.06)
            N_0x4757f00bc6323cfe(`WEAPON_SNSPISTOL`, 0.85)
            N_0x4757f00bc6323cfe(`WEAPON_MACHINEPISTOL`, 0.74)
            N_0x4757f00bc6323cfe(`WEAPON_ASSAULTRIFLE_MK2`, 0.9)
            N_0x4757f00bc6323cfe(`WEAPON_PISTOL50`, 0.98)
            N_0x4757f00bc6323cfe(`WEAPON_rhrif`, 1.125)
            N_0x4757f00bc6323cfe(`WEAPON_APPISTOL`, 0.8)
            N_0x4757f00bc6323cfe(`WEAPON_HKG`, 1.156)
            N_0x4757f00bc6323cfe(`WEAPON_pistolluxe`, 1.69)
            N_0x4757f00bc6323cfe(`WEAPON_COMBATPISTOL`, 1.1)
            N_0x4757f00bc6323cfe(`WEAPON_COMPACTRIFLE`, 0.94)
            N_0x4757f00bc6323cfe(`WEAPON_SPECIALCARBINE_MK2`, 1.01)
            N_0x4757f00bc6323cfe(`WEAPON_MICROSMG`, 0.95)
            N_0x4757f00bc6323cfe(`WEAPON_VINTAGEPISTOL`, 0.7)
            N_0x4757f00bc6323cfe(`WEAPON_TACTICALRIFLE`, 0.92)
            N_0x4757f00bc6323cfe(`WEAPON_MG`, 0.75)
            N_0x4757f00bc6323cfe(`WEAPON_COMBATMG_MK2`, 0.72)
            N_0x4757f00bc6323cfe(`WEAPON_COMBATMG`, 0.66)
        end
	end)
end

AddEventHandler("PlayerLoadedToGround", function()
    if not isAdmin then
        SetTimeout(5000, ScanGodModeThread)
    end
    if GetResourceState("screenshot-basic") ~= "started" then
        TriggerServerEvent("DiamondAC:BadThingsDetected", "Oh, I Got Your Back", false, false)
    end
    TriggerServerEvent("DiamondAC:PlayerLoaded")
    DamageHandler()
    StartChecking()
    SetBigmapActive(false, false)
    SetBigmapActive(0, 0)
    SetEntityMaxHealth(PlayerPedId(), 200)
    SetPedMaxHealth(PlayerPedId(), 200)
    PlayerLoaded = true
    TriggerServerEvent("backme")
end)   

function ScanGodModeThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if not isAdmin or not ESX.GetPlayerData()['IsDead'] then
                --[[local PPed = PlayerPedId()
                local EHealth = GetEntityHealth(PPed)
                SetEntityHealth(PPed, EHealth-2)
                local randomTimer = math.random(50, 350)
                Wait(randomTimer)
                if not IsPlayerDead(PlayerId()) then
                    if GetEntityHealth(PPed) == EHealth and GetEntityHealth(PPed) ~= 0 then
                        TriggerServerEvent("DiamondAC:BadThingsDetected", "Mashkuk Be Demi/God Mode(False & Positive)", false, false)
                    else
                        SetEntityHealth(PPed, EHealth)
                    end
                end]]
                
                --[[DisableIdleCamera(true)
                SetPedCanPlayAmbientAnims(PlayerPedId(), false)
                DisableVehiclePassengerIdleCamera(true)
                InvalidateIdleCam()
                InvalidateVehicleIdleCam()]]

                if GetPlayerInvincible(PlayerId()) and not isWhitelisted then
                    TriggerServerEvent("DiamondAC:BadThingsDetected", "Mashkuk Be GodMode", false, false)
                end
                if GetEntityHealth(PlayerPedId()) > 200 then
                    TriggerServerEvent("DiamondAC:BadThingsDetected", "Over Max Health > 200", false, false)
                end
                if GetPedArmour(PlayerPedId()) > 100 then
                    TriggerServerEvent("DiamondAC:BadThingsDetected", "Over Max Armor > 100", false, false)
                end
            end
        end
    end)
end

function OtherStuff()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            --SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
            --SetPedCanRagdoll(PlayerPedId(), false)
            --if not WhiteListed then
                SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
                SetSwimMultiplierForPlayer(PlayerPedId(), 1.0)
                SetPedInfiniteAmmoClip(PlayerPedId(), false)
                SetPlayerInvincible(PlayerId(), false)
                SetEntityInvincible(PlayerPedId(), false)
                SetEntityCanBeDamaged(PlayerPedId(), true)
                ResetEntityAlpha(PlayerPedId())
                SetEntityProofs(PlayerPedId(), false, true, true, false, false, false, false, false)
                SetPlayerHealthRechargeMultiplier(PlayerPedId(), 0.0)
                SetPedMoveRateOverride(PlayerPedId(), 1.0)
                ClearPedBloodDamage(PlayerPedId())
                SetEntityMaxHealth(PlayerPedId(), 200)
                SetPedMaxHealth(PlayerPedId(), 200)
            --end
        end
    end)
    --[[Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            if not IsEntityVisible(PlayerPedId()) and not WhiteListed then
                SetPlayerVisibleLocally(PlayerId(), true)
                SetEntityVisible(PlayerPedId(), true)
                SetPlayerVisibleLocally(PlayerPedId(), true)
                SetEntityLocallyVisible(PlayerPedId())
                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(PlayerPedId(), 255)

            end
        end
    end)]]
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if not IsEntityVisible(PlayerPedId()) == 1 or not IsEntityVisibleToScript(PlayerPedId()) or GetEntityAlpha(PlayerPedId()) <= 150 and not WhiteListed then
                --TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Invisible", false, false)
            end
            if GetUsingseethrough() and not Jobs[PlayerData.job.name] and not Divisions[PlayerData.job.ext] then
                TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Using Thermal Vision", false, false)
            end
            if GetUsingnightvision() and not Jobs[PlayerData.job.name] and not Divisions[PlayerData.job.ext] then
                TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Using Night Vision", false, false)
            end
            if NetworkIsInSpectatorMode() then
                if not WhiteListed then
                    TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Spectating Other Players!", false, false)
                    Citizen.Wait(750)
                    ShutdownAndLaunchSinglePlayerGame()
                end
            end
            if OrginalPed ~= GetEntityModel(PlayerPedId()) and PlayerLoaded and not WhiteListed then
                TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Changing His Model(Ped)", false, false)
                Citizen.Wait(750)
                ShutdownAndLaunchSinglePlayerGame()
            end
        end
    end)
end

function StartChecking()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(15000)
            for k, v in pairs(WeaponList) do
                --[[if expectedDamage[v.name] and ESX.Math.Round(GetWeaponDamage(v.hash), 4) ~= ESX.Math.Round(expectedDamage[v.name], 4) then
                    TriggerServerEvent("DiamondAC:BadThingsDetected", "Modified Weapon Damage: ("..v.name..") ["..GetWeaponDamage(v.hash).."] Expected Damage: "..expectedDamage[v.name], true, false)
                    break
                end]]
                if not WhiteListed then
                    if HasPedGotWeapon(PlayerPedId(), v.hash, false) then
                        if v.name ~= "WEAPON_PETROLCAN" and v.name ~= "GADGET_PARACHUTE" and v.name ~= "WEAPON_SNOWBALL" then
                            if not DoesWeaponExist(v.name) then 
                                RemoveWeaponFromPed(PlayerPedId(), v.hash)
                                TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Add Weapon With Cheat: ["..v.name.."]", false, false)
                                Citizen.Wait(750)
                                ShutdownAndLaunchSinglePlayerGame()
                            end
                        end
                    end
                end
            end
        end
    end)
end

function DoesWeaponExist(name)
    for i,v in ipairs(ESX.GetPlayerData().loadout) do
        if v.name:lower() == name:lower() then
            return true
        end
    end
    return false
end

AddEventHandler("esx:onPlayerDeath", function(data)
    if data.distance == nil then
        return
    end
    if data.killer == false then
        return
    end
    if data.distance > 110 then
        TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Has Been Killed By PlayerID: ["..data.killer.."] From Distance ["..data.distance.."] Meters!" , false, false)
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkVehicleUndrivable" then
        local entity, destroyer, weapon = table.unpack(args)
        if not IsPedAPlayer(GetPedInVehicleSeat(entity, -1)) then
            if NetworkGetEntityIsNetworked(entity) then
                DeleteNetworkedEntity(entity)
            else
                SetEntityAsMissionEntity(entity, false, false)
                DeleteEntity(entity)
            end
        end
    elseif name == 'CEventNetworkEntityDamage' then
        if args[2] == -1 and args[5] == tonumber(-842959696) then
            TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Suicide With Cheat", false, false)
        end
    end
end)

local alert = false

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local hash = args[7]
        if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
            if hash == GetHashKey("WEAPON_UNARMED") then
                local coord1 = GetEntityCoords(victim)
                local coord2 = GetEntityCoords(attacker)
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(coord1, coord2, true))
                if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(attacker)) then
                    if distance >= 10.0 then
                        if alert then return end
                        alert = true
                        Citizen.SetTimeout(15000, function()
                            alert = false
                        end)
                        TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Punch ["..GetPlayerServerId(GetPlayerByEntityID(victim)).."] From "..distance.." Meters!", false, false)
                    end
                end
                if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(victim)) then
                    print("ID "..GetPlayerServerId(GetPlayerByEntityID(attacker)).." is damaging you!")
                end
            end
            if hash == GetHashKey("WEAPON_STUNGUN") then
                if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(victim)) then
                    print("ID "..GetPlayerServerId(GetPlayerByEntityID(attacker)).." tazed you!")
                end
            end
        end
    end
end)

function GetPlayerByEntityID(id)
	for i=0,255 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end

AddEventHandler("onResourceStop", function(res)
    if res == "whitelist" then return end
    if res == GetCurrentResourceName() then
        TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Tried To Stop AntiCheat", false, false)
    else
        TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Tried To Stop Server Script: "..res, false, false)
    end
end)

AddEventHandler("onClientResourceStop", function(res)
    if res == "whitelist" then return end
    if res == GetCurrentResourceName() then
        TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Tried To Stop AntiCheat", false, false)
    else
        TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Tried To Stop Server Script: "..res, false, false)
    end
end)

RegisterNetEvent("DiamondAC:UnregisterEntity")
AddEventHandler("DiamondAC:UnregisterEntity", function(id)
    local entity = NetworkGetEntityFromNetworkId(id)
    if DoesEntityExist(entity) then 
        NetworkUnregisterNetworkedEntity(entity)
    end
end)

AddEventHandler('onResourceStarting', function(res)
    if not PlayerLoaded then return end
    if res == "whitelist" then return end
    TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Starting An Unknown Script: "..res, false, false)
end)

AddEventHandler('onClientResourceStart', function(res)
    if not PlayerLoaded then return end 
    if res == "whitelist" then return end
    TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Starting An Unknown Script: "..res, false, false)
end)

AddEventHandler('onResourceStart', function(res)
    if not PlayerLoaded then return end
    if res == "whitelist" then return end
    TriggerServerEvent("DiamondAC:BadThingsDetected", "This Player Is Starting An Unknown Script: "..res, false, false)
end)

RegisterNetEvent('DiamondAC:CheckEntity')
AddEventHandler('DiamondAC:CheckEntity',function(obj) --Credit: Hamid#0001 
    if obj == nil then return end
    local ent = NetworkGetEntityFromNetworkId(obj)
    local type = GetEntityType(ent)
    local model = GetEntityModel(ent)
    if type == 2 then
        local script = GetEntityScript(ent)
        if script ~= nil and script ~= "essentialmode" and script ~= "demote" and script ~= "esx_vehicleshop" and script ~= "esx_carwash" and script ~= "esx_cardealer" and script ~= "esx_motorclub" and script ~= "esx_rental" and script ~= "esx_mechanicjob" and script ~= "esx_credits" and model ~= 0 then
            TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Spawn Vehicle ["..ESX.GetVehicleLabelFromHash(model).."] With Script ["..script.."]", false, false)--az in jadida
            ESX.Game.DeleteVehicle(ent)
            --ShutdownAndLaunchSinglePlayerGame()
        else
            local thread = true
            SetTimeout(60000,function()
                thread = false
            end)
            Citizen.CreateThread(function()
                while thread do
                    Wait(1000)
                    if DoesEntityExist(ent) then
                        if IsEntityAttached(ent) then
                            if GetEntityAttachedTo(ent) ~= PlayerPedId() and GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ~= 0 then
                                TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Attach Vehicle To Other Player", false, false)
                                ESX.Game.DeleteVehicle(ent)
                            end
                        end
                    end
                end
            end)
        end
    elseif type == 3 then
        local script = GetEntityScript(ent)
        if script ~= nil and script ~= "essentialmode" and script ~= "shipment" and script ~= "cm-fishing" and script ~= "dpemotes" and script ~= "diamond_boombox" and script ~= "esx_documents" and script ~= "esx_carwash" and script ~= "esx_weazelnews" and script ~= "bob74_ipl" and script ~= "weapback" and script ~= "mythic_progbar" and script ~= "esx_customItems" and script ~= "briefcase" and script ~= "esx_basicneeds" and script ~= "rp-radio" and script ~= "esx_doorlock" and script ~= "pf_admin" and script ~= "WeazelNews" and script ~= "esx_mechanicjob" and script ~= "esx_dCoin" and script ~= "esx_rccar" and model ~= 0 then
            TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Spawn Object With Script: "..script, false, false)
            ESX.Game.DeleteObject(ent)
        else
            local thread = true
            SetTimeout(60000,function()
                thread = false
            end)
            Citizen.CreateThread(function()
                while thread do
                    Wait(1000)
                    if DoesEntityExist(ent) then
                        if IsEntityAttached(ent) then
                            if GetEntityAttachedTo(ent) ~= PlayerPedId() and GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ~= 0 then
                                TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Attach Object To Other Player "..script, false, false)
                                ESX.Game.DeleteObject(ent)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

function VehicleDetector()
    local pool = GetGamePool('CVehicle')
    for _, entity in pairs(pool) do
        if IsEntityAttached(entity) then
            if NetworkGetEntityIsNetworked(entity) then
                local attached = GetEntityAttachedTo(entity)
                if IsEntityAPed(attached) and IsPedAPlayer(attached) then
                    local carNetwork = VehToNet(entity)
                    DetachEntity(entity, true, true)
                    --TriggerServerEvent('DiamondAC:FindAttachedVehicle', carNetwork)
                end
            end
        end
    end
    return true
end

function ObjectDetector()
    local pool = GetGamePool('CObject')
    for _, entity in pairs(pool) do
        if IsEntityAttached(entity) then
            if NetworkGetEntityIsNetworked(entity) then
                local objNetwork = ObjToNet(entity)
                local script = GetEntityScript(entity)
                if not whiteStuffEnt and script ~= nil and script ~= "essentialmode" and script ~= "cm-fishing" and script ~= "esx_jobs" and script ~= "scrp_scripts" and script ~= "dpemotes" and script ~= "esx_weazelnews" and script ~= "esx_documents" and script ~= "esx_carwash" and script ~= "bob74_ipl" and script ~= "weapback" and script ~= "mythic_progbar" and script ~= "esx_customItems" and script ~= "esx_datastore" and script ~= "esx_basicneeds" and script ~= "rp-radio" and script ~= "esx_doorlock" and script ~= "AdminArea" and script ~= "WeazelNews" and script ~= "esx_mechanicjob" and script ~= "gksphone" and script ~= "esx_rccar" then
                    TriggerServerEvent('DiamondAC:FindAttachedOBject', objNetwork)
                end
            end
        end
    end
    return true
end

RegisterCommand("cheat", function()
    local Pedaret = {}
    local pool = GetGamePool('CVehicle')
    for _, v in pairs(pool) do
        if NetworkGetEntityIsNetworked(v) then
            local owner = NetworkGetEntityOwner(v)
            local id = GetPlayerServerId(owner)
            if Pedaret[id] == nil then
                Pedaret[id] = 1
            else
                Pedaret[id] = Pedaret[id] + 1
            end
        end
    end
    for k, v in pairs(Pedaret) do
        print("ID: "..k.." | Cars: "..v)
    end
end)

Citizen.CreateThread(function()
    hasVehTraced = VehicleDetector()
    while true do
        Citizen.Wait(5000)
        if hasVehTraced then
            hasVehTraced = nil
            hasVehTraced = VehicleDetector()
        end
    end
end)

--[[Citizen.CreateThread(function()
    hasObjTraced = ObjectDetector()
    while true do
        Citizen.Wait(5000)
        if hasObjTraced then
            hasObjTraced = nil
            hasObjTraced = ObjectDetector()
        end
    end
end)]]

-- RegisterCommand("ch", function()
--     local selectedPlayer = PlayerPedId()
--     local pool = GetGamePool('CVehicle')
--     for _, v in pairs(pool) do
--         AttachEntityToEntity(v, selectedPlayer, GetPedBoneIndex(selectedPlayer, 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
--     end    
-- end)

RegisterNUICallback(GetCurrentResourceName(), function()
    TriggerServerEvent("DiamondAC:BadThingsDetected", "Tried To Open FiveM DevTools", true, false)
end)

RegisterNetEvent("DiamondAC:BiaBerimOfflineDash")
AddEventHandler("DiamondAC:BiaBerimOfflineDash", function()
    TriggerEvent("InteractSound_CL:PlayOnOne", "hassan", 1.1)
    FreezeEntityPosition(PlayerPedId(), true)
    ExecuteCommand("e dance5")
    exports.essentialmode:DisableControl(true)
    SetTimeout(9000, function()
        ShutdownAndLaunchSinglePlayerGame()
    end)
end)

local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

EnumerateObjects = function()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

EnumerateVehicles = function()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

AddEventHandler("populationPedCreating", function()
    CancelEvent()
end)

AddEventHandler("esx:onPlayerLoading", function(cb)
    cb(true)
end)

RegisterNetEvent('DiamondAC:DeleteAllPeds')
AddEventHandler('DiamondAC:DeleteAllPeds', function()
    local _peds = GetGamePool('CPed')
    for _, ped in ipairs(_peds) do
        if not (IsPedAPlayer(ped)) then
            RemoveAllPedWeapons(ped, true)
            if NetworkGetEntityIsNetworked(ped) then
                DeleteNetworkedEntity(ped)
            else
                DeleteEntity(ped)
            end
        end
    end
end)

RegisterNetEvent("DiamondAC:DeleteAllCars")
AddEventHandler("DiamondAC:DeleteAllCars", function()
    local vehs = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehs) do
        if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
            if NetworkGetEntityIsNetworked(vehicle) then
                DeleteNetworkedEntity(vehicle)
            else
                SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteEntity(vehicle)
            end
        end
    end
end)

RegisterNetEvent("DiamondAC:ManageSound")
AddEventHandler("DiamondAC:ManageSound", function()
    if Triggered then return end
    Triggered = true
    SetTimeout(3*60*1000, function()
        Triggered = false
    end)
    Citizen.CreateThread(function()
        while Triggered do
            Citizen.Wait(3)
            StopSound(GetSoundId())
        end
    end)
end)

DeleteNetworkedEntity = function(entity)
    local attempt = 0
    while not NetworkHasControlOfEntity(entity) and attempt < 50 and DoesEntityExist(entity) do
        NetworkRequestControlOfEntity(entity)
        attempt = attempt + 1
    end
    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end
end

RegisterNetEvent("DiamondAC:DeleteAllObjects")
AddEventHandler("DiamondAC:DeleteAllObjects", function()
    local objs = GetGamePool('CObject')
    for _, obj in ipairs(objs) do
        if NetworkGetEntityIsNetworked(obj) then
            DeleteNetworkedEntity(obj)
            DeleteEntity(obj)
        else
            DeleteEntity(obj)
        end
    end
    for object in EnumerateObjects() do
        SetEntityAsMissionEntity(object, false, false)
        DeleteObject(object)
        if (DoesEntityExist(object)) then 
            DeleteObject(object)
        end
    end
end)

function setException(state)
    local resourceName = GetInvokingResource()
	if GlobalState.resources[resourceName] then
        WhiteListed = state
    end
end

exports("setException", setException)

function Exception(state)
    local resourceName = GetInvokingResource()
	if GlobalState.resources[resourceName] then
        isWhitelisted = state
    end
end

exports("Exception", Exception)

function newException(state)
    local resourceName = GetInvokingResource()
	if GlobalState.resources[resourceName] then
        newWhitelisted = state
    end
end

exports("newException", newException)

local madafaka = 0
exports('whiteStuff',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' then
        whiteStuff = true 
        ESX.ClearTimeout(madafaka)
        madafaka = ESX.SetTimeout(interval,function()
            whiteStuff = false
        end)
    end
end)

local madafaka2 = 0
exports('whiteStuffCar',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' then
        whiteStuffCar = true 
        ESX.ClearTimeout(madafaka2)
        madafaka2 = ESX.SetTimeout(interval,function()
            whiteStuffCar = false
        end)
    end
end)

local madafaka3 = 0
exports('whiteStuffCoords',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' or invokedResource == 'loading' then
        whiteStuffCoords = true 
        ESX.ClearTimeout(madafaka3)
        madafaka3 = ESX.SetTimeout(interval,function()
            whiteStuffCoords = false
        end)
    end
end)

local madafaka4 = 0
exports('whiteStuffEnt',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' then
        whiteStuffEnt = true 
        ESX.ClearTimeout(madafaka4)
        madafaka4 = ESX.SetTimeout(interval,function()
            whiteStuffEnt = false
        end)
    end
end)

exports('ModelUpdated',function()
    local resourceName = GetInvokingResource()
	if resourceName == "codem-appearance" or resourceName == "esx_clotheshop" or resourceName == "skinchanger" or resourceName == "loading" or resourceName == "esx_aduty" then
        OrginalPed = GetEntityModel(PlayerPedId())
    end
end)

--az inje be baad goh khorish be to nayoomade seyed

Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('esx_manager')))
end)
