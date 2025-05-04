---@diagnostic disable: undefined-global, undefined-field, missing-parameter, lowercase-global
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local playerLoaded = false

---- SKILLS INFO
local SkillPoints
local xp
local ownedskills
---
local ResetAvailable = true

---- DATABASE
local HaveAddHealth = false
local AddHP = 0

local HaveAddArmor = false
local AddArmor = 0

local HaveHealthRegen = false
local StartHPRegeneration = 0
local StopHPRegeneration = 0
local HealthRegenTime = 0

local HaveArmorRegen = false
local StartArmorRegeneration = 0
local StopArmorRegeneration = 0
local ArmorRegenTime = 0

local HaveAddSpeed = false
local HaveAddSwimSpeed = false

local HaveAddDrivingSpeed = false
local AddCarSpeed = 0
local CarSpeedModified = false

local HaveAddFlyingSpeed = false
local AddFlyingSpeed = 0
local FlyingSpeedModified = false

local HaveAddBoatSpeed = false
local AddBoatSpeed = 0
local BoatSpeedModified = false
----

local HaveShieldWall = false
local WallRechargeTime = 0
local WallStandingTime = 0
local wallwasplaced = false
local wallstanding = false
local wall
local shield_net

local HaveAddStaminaSprintTime = false
local AddStamina = 0
local RestoreStaminaPoint = 100.0

local HaveAddStaminaRecoveryTime = false
local AddStaminaRecovery = 0
local RecoveryStaminaPoint = 1.0

--- Timers for threads
local StartAddHPTimer = false
local StartAddArmorTimer = false
local StartHealthRegenTimer = false
local StartArmorRegenTimer = false
--

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    playerLoaded = true

    Citizen.Wait(1000)
    ResetAvailable = true

    ESX.TriggerServerCallback("D-skills:getAbilities", function(data)

        local ped = PlayerPedId()
        local pedId = PlayerId()

        for k, v in pairs(data) do

            if v.skill_name == "AddHealth" then

                AddHP = v.value1
                HaveAddHealth = true

            end
            if v.skill_name == "AddArmor" then

                AddArmor = v.value1
                HaveAddArmor = true

            end
            if v.skill_name == "AddHealthRegen" then

                StartHPRegeneration = v.value1
                StopHPRegeneration = v.value2
                HealthRegenTime = v.value3
                HaveHealthRegen = true

            end
            if v.skill_name == "AddArmorRegen" then

                StartArmorRegeneration = v.value1
                StopArmorRegeneration = v.value2
                ArmorRegenTime = v.value3
                HaveArmorRegen = true

            end
            if v.skill_name == "AddSpeed" then

                AddRunningSpeed(v.value1)
                HaveAddSpeed = true

            end
            if v.skill_name == "AddSwimmingSpeed" then

                AddSwimmingSpeed(v.value1)
                HaveAddSwimSpeed = true

            end
            if v.skill_name == "AddUnderWaterTime" then

                AddUnderWater(v.value1)
                HaveAddUnderWaterTime = true

            end
            if v.skill_name == "AddDrivingSpeed" then

                AddCarSpeed = v.value1
                HaveAddDrivingSpeed = true

            end
            if v.skill_name == "AddBoatSpeed" then

                AddBoatSpeed = v.value1
                HaveAddBoatSpeed = true

            end
            if v.skill_name == "AddShieldWall" then

                HaveShieldWall = true
                WallStandingTime = v.value1
                WallRechargeTime = v.value2

            end
            if v.skill_name == "AddStaminaSprint" then

                HaveAddStaminaSprintTime = true
                AddStamina = v.value1

            end
            if v.skill_name == "AddStaminaRecovery" then

                HaveAddStaminaRecoveryTime = true
                AddStaminaRecovery = v.value1

            end
        end
    end)
end)

RegisterNUICallback('RestoreDefault', function(data)
    local ped = PlayerPedId()

    TriggerServerEvent('D-skills:resetall')

    HaveAddHealth = false
    AddHP = 0
    HaveAddArmor = false
    AddArmor = 0
    HaveHealthRegen = false
    StartHPRegeneration = 0
    StopHPRegeneration = 0
    HealthRegenTime = 0
    HaveArmorRegen = false
    StartArmorRegeneration = 0
    StopArmorRegeneration = 0
    ArmorRegenTime = 0
    HaveAddSpeed = false
    HaveAddSwimSpeed = false
    HaveAddDrivingSpeed = false
    AddCarSpeed = 0
    CarSpeedModified = false
    HaveAddFlyingSpeed = false
    AddFlyingSpeed = 0
    FlyingSpeedModified = false
    HaveAddBoatSpeed = false
    AddBoatSpeed = 0
    BoatSpeedModified = false
    HaveShieldWall = false
    WallRechargeTime = 0
    WallStandingTime = 0
    wallwasplaced = false
    HaveAddStaminaSprintTime = false
    AddStamina = 0
    RestoreStaminaPoint = 100.0
    HaveAddStaminaRecoveryTime = false
    AddStaminaRecovery = 0
    RecoveryStaminaPoint = 1.0
    AddUnderWater(10)
    AddRunningSpeed(1.0)
    AddSwimmingSpeed(1.0)

    local Player = ESX.GetPlayerData()

    ResetAvailable = false

end)

--- Main Menu
local display = false
function SetDisplay(bool)
    local Player = ESX.GetPlayerData()

    display = bool
    SetNuiFocus(bool, bool)
    TriggerScreenblurFadeIn(500)

    ESX.TriggerServerCallback("D-skills:getSkillsinfo", function(data)
        SkillPoints = data["skillpoints"]
        xp = data["skillxp"]
        Level = data["currentlevel"]
        needxp = data["nextlevel"]

        ESX.TriggerServerCallback("D-skills:getSkills", function(skills, firstname, lastname)
            local playerData = ESX.GetPlayerData()
            print(firstname, lastname)
            SendNUIMessage({
                firstname = firstname,
                lastname = lastname,
                job = playerData.job.name,
                type = "show",
                config = Config,
                level = Level,
                totalxp = xp,
                needxp = needxp,
                oldpoints = SkillPoints,
                ownedskills = skills,
                Ravailable = ResetAvailable
            })
        end)
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local playerPed = GetPlayerPed(-1)
    if playerPed ~= nil then
        playerLoaded = true
    end
end)

RegisterCommand('skill', function()
    if display == false and playerLoaded then
        SetDisplay(true)
    end
end)

RegisterKeyMapping('skill', 'Open skills menu', 'keyboard', Config.KeyToOpenSkillMenu)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        if display == true and playerLoaded then
            Citizen.Wait(500)
            ESX.TriggerServerCallback("D-skills:getSkills", function(skills)
                SendNUIMessage({

                    type = "newownedskill",
                    newownedskill = skills,
                    Ravailable = ResetAvailable

                })
            end)

        else
            Citizen.Wait(900)
        end
    end
end)

RegisterNetEvent('D-skills:earnedxp')
AddEventHandler('D-skills:earnedxp', function(earned)
    ESX.TriggerServerCallback("D-skills:getSkillsinfo", function(data)
        level = data["currentlevel"]
        ESX.ShowNotification('You have earned: ' .. earned .. ' Skill Experience!')

        if data["skillxp"] >= 100 then
            level = level + 1

            TriggerServerEvent('D-skills:addSkillsInfo')

            SendNUIMessage({
                type = "shownotification",
                NotificationTimer = Config.NotificationTimeInSeconds * 1000,
                lvl = level,
                addedpoints = Config.SkillPointsPerLevel,
                experience = earned
            })
        end
    end)
end)


RegisterNUICallback('buySkill', function(data)

    local Skill = data["Skill"]
    local Purchase = data["Purchase"]
    local Player = ESX.GetPlayerData()
    ESX.TriggerServerCallback("D-skills:getSkillsinfo", function(data)
        SkillPoints = data["skillpoints"]
        if SkillPoints >= tonumber(Purchase) then
            for k, v in pairs(Config.Skills) do
                if Skill == k then
                    for e, q in pairs(v.SkillAbilities) do
                        local ped = PlayerPedId()
                        local pedId = PlayerId()

                        if e == "AddHealth" then

                            AddHP = q
                            HaveAddHealth = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddArmor" then

                            AddArmor = q
                            HaveAddArmor = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddHealthRegen" then
                            if HaveHealthRegen == true then
                                ESX.TriggerServerCallback("D-skills:getAbilities", function(data)
                                    for k, v in pairs(data) do
                                        if v.skill_name == "AddHealthRegen" then

                                            if q.StartRegeneration == nil then
                                                StartHPRegeneration = v.value1
                                            else
                                                StartHPRegeneration = q.StartRegeneration
                                            end
                                            if q.StopRegeneration == nil then
                                                StopHPRegeneration = v.value2
                                            else
                                                StopHPRegeneration = q.StopRegeneration
                                            end
                                            if q.SpeedOfRegenerationInSeconds == nil then
                                                HealthRegenTime = v.value3
                                            else
                                                HealthRegenTime = q.SpeedOfRegenerationInSeconds * 1000
                                            end

                                            TriggerServerEvent('D-skills:saveAbilities', e, StartHPRegeneration,
                                                StopHPRegeneration, HealthRegenTime)
                                        end
                                    end
                                end)
                            else
                                StartHPRegeneration = q.StartRegeneration
                                StopHPRegeneration = q.StopRegeneration
                                HealthRegenTime = q.SpeedOfRegenerationInSeconds * 1000

                                HaveHealthRegen = true
                                TriggerServerEvent('D-skills:saveAbilities', e, StartHPRegeneration,
                                    StopHPRegeneration, HealthRegenTime)
                            end
                        end
                        if e == "AddArmorRegen" then

                            if HaveArmorRegen == true then
                                ESX.TriggerServerCallback("D-skills:getAbilities", function(data)
                                    for k, v in pairs(data) do
                                        if v.skill_name == "AddArmorRegen" then

                                            if q.StartRegeneration == nil then
                                                StartArmorRegeneration = v.value1
                                            else
                                                StartArmorRegeneration = q.StartRegeneration
                                            end
                                            if q.StopRegeneration == nil then
                                                StopArmorRegeneration = v.value2
                                            else
                                                StopArmorRegeneration = q.StopRegeneration
                                            end
                                            if q.SpeedOfRegenerationInSeconds == nil then
                                                ArmorRegenTime = v.value3
                                            else
                                                ArmorRegenTime = q.SpeedOfRegenerationInSeconds * 1000
                                            end

                                            TriggerServerEvent('D-skills:saveAbilities', e, StartArmorRegeneration,
                                                StopArmorRegeneration, ArmorRegenTime)
                                        end
                                    end
                                end)
                            else
                                StartArmorRegeneration = q.StartRegeneration
                                StopArmorRegeneration = q.StopRegeneration
                                ArmorRegenTime = q.SpeedOfRegenerationInSeconds * 1000
                                HaveArmorRegen = true
                                TriggerServerEvent('D-skills:saveAbilities', e, StartArmorRegeneration,
                                    StopArmorRegeneration, ArmorRegenTime)
                            end

                        end
                        if e == "AddSpeed" then

                            AddRunningSpeed(q)
                            HaveAddSpeed = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddSwimmingSpeed" then

                            AddSwimmingSpeed(q)
                            HaveAddSwimSpeed = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddUnderWaterTime" then

                            AddUnderWater(q)
                            HaveAddUnderWaterTime = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddDrivingSpeed" then

                            AddCarSpeed = q
                            HaveAddDrivingSpeed = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddBoatSpeed" then

                            AddBoatSpeed = q
                            HaveAddBoatSpeed = true
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddShieldWall" then

                            if HaveShieldWall == true then
                                ESX.TriggerServerCallback("D-skills:getAbilities", function(data)
                                    for k, v in pairs(data) do
                                        if v.skill_name == "AddShieldWall" then

                                            if q.WallStandingTimeInSeconds == nil then
                                                WallStandingTime = v.value1
                                            else
                                                WallStandingTime = q.WallStandingTimeInSeconds
                                            end
                                            if q.WallRechargeTimeInSeconds == nil then
                                                WallRechargeTime = v.value2
                                            else
                                                WallRechargeTime = q.WallRechargeTimeInSeconds
                                            end

                                            TriggerServerEvent('D-skills:saveAbilities', e, WallStandingTime,
                                                WallRechargeTime)
                                        end
                                    end
                                end)
                            else
                                WallStandingTime = q.WallStandingTimeInSeconds
                                WallRechargeTime = q.WallRechargeTimeInSeconds
                                HaveShieldWall = true
                                TriggerServerEvent('D-skills:saveAbilities', e, WallStandingTime, WallRechargeTime)
                            end

                        end
                        if e == "AddStaminaSprint" then

                            HaveAddStaminaSprintTime = true
                            AddStamina = q
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                        if e == "AddStaminaRecovery" then

                            HaveAddStaminaRecoveryTime = true
                            AddStaminaRecovery = q
                            TriggerServerEvent('D-skills:saveAbilities', e, q)

                        end
                    end
                end
            end
            ESX.ShowNotification(Config.Text['enough'])
            TriggerServerEvent('D-skills:removepoints', Purchase)
            TriggerServerEvent('D-skills:saveSkills', Skill)

        else
            ESX.ShowNotification(Config.Text['notenough'])
        end
    end)
end)

-------- ADD HP START
RegisterCommand('addhp', function()
    if StartAddHPTimer == false then
        if HaveAddHealth == true then
            local ped = PlayerPedId()
            local maxhp = GetEntityMaxHealth(ped)
            local nowhp = GetEntityHealth(ped)
            if maxhp ~= nowhp then
                ESX.SetEntityHealth(ped, nowhp + AddHP)
                StartAddHPTimer = true
            else
                ESX.ShowNotification(Config.Text['fullhealth'])
            end
        else
            ESX.ShowNotification(Config.Text['notallowed'])
        end
    else
        ESX.ShowNotification(Config.Text['wait5minutes'])
    end
end)
local AddHPTimer = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if StartAddHPTimer == true and playerLoaded then

            Citizen.Wait(1000)

            AddHPTimer = AddHPTimer + 1
            if AddHPTimer == 300 then
                StartAddHPTimer = false
                AddHPTimer = 0
                ESX.ShowNotification(Config.Text['canuseaddhp'])
            end
        end
    end
end)
-- END

-------- ADD ARMOR START
RegisterCommand('addarmor', function()
    if StartAddArmorTimer == false then
        if HaveAddArmor == true then
            local ped = PlayerPedId()
            local nowarmor = GetPedArmour(ped)
            if nowarmor < 100 then
                ESX.SetPedArmour(ped, nowarmor + AddArmor)
                StartAddArmorTimer = true
            else
                ESX.ShowNotification(Config.Text['fullarmor'])
            end
        else
            ESX.ShowNotification(Config.Text['notallowed'])
        end
    else
        ESX.ShowNotification(Config.Text['wait5minutes'])
    end
end)
local AddArmorTimer = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if StartAddArmorTimer == true and playerLoaded then

            Citizen.Wait(1000)

            AddArmorTimer = AddArmorTimer + 1
            if AddArmorTimer == 300 then
                StartAddArmorTimer = false
                AddArmorTimer = 0
                ESX.ShowNotification(Config.Text['canuseaddarmor'])
            end
        end
    end
end)
-- END

--- HEALTH REGENERATION
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if HaveHealthRegen == true and playerLoaded then
            local ped = PlayerPedId()
            local nowhp = GetEntityHealth(ped)
            if nowhp < StartHPRegeneration + 100 then
                StartHealthRegenTimer = true
            end
            if StartHealthRegenTimer == true then

                Citizen.Wait(HealthRegenTime)
                nowhp = GetEntityHealth(ped)
                if nowhp <= GetEntityMaxHealth(ped) then
                    ESX.ShowNotification("Be Shoma 1% Health Ezafe Shod")
                    ESX.SetEntityHealth(ped, nowhp + 1)
                end

                if nowhp >= StopHPRegeneration + 100 then
                    StartHealthRegenTimer = false
                end
            end
        else
            Citizen.Wait(1400)
        end
    end
end)
-- END

--- ARMOR REGENERATION
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if HaveArmorRegen == true and playerLoaded then
            local ped = PlayerPedId()
            local nowarmor = GetPedArmour(ped)
            if nowarmor < StartArmorRegeneration then
                StartArmorRegenTimer = true
            end
            if StartArmorRegenTimer == true then

                Citizen.Wait(ArmorRegenTime)
                nowarmor = GetPedArmour(ped)
                if nowarmor < 100 then
                    ESX.ShowNotification("Be Shoma 1% Armor Ezafe Shod")
                    ESX.SetPedArmour(ped, nowarmor + 1)
                end

                if nowarmor >= StopArmorRegeneration then
                    StartArmorRegenTimer = false
                end
            end
        else
            Citizen.Wait(1300)
        end
    end
end)
-- END

--- CAR DRIVING SPEED
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if HaveAddDrivingSpeed == true and playerLoaded then
            local ped = PlayerPedId()
            if GetVehiclePedIsIn(ped, false) ~= 0 then
                if IsThisModelACar(GetEntityModel(GetVehiclePedIsIn(ped, false))) == 1 then
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
                        if CarSpeedModified ~= true then
                            AddCarSpeed = math.floor(AddCarSpeed) + .0
                            ModifyVehicleTopSpeed(GetVehiclePedIsIn(ped, false), AddCarSpeed)
                            CarSpeedModified = true
                        end
                    end
                end
            elseif GetVehiclePedIsIn(ped, false) == 0 then
                if CarSpeedModified == true then
                    ModifyVehicleTopSpeed(GetVehiclePedIsIn(ped, true), 0.0)
                    CarSpeedModified = false
                end
            end
        else
            Citizen.Wait(1200)
        end
    end
end)
--- END

--- BOAT SPEED
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if HaveAddBoatSpeed == true and playerLoaded then
            local ped = PlayerPedId()
            if GetVehiclePedIsIn(ped, false) ~= 0 then
                if IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(ped, false))) == 1 then
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
                        if BoatSpeedModified ~= true then
                            AddBoatSpeed = math.floor(AddBoatSpeed) + .0
                            ModifyVehicleTopSpeed(GetVehiclePedIsIn(ped, false), AddBoatSpeed)
                            BoatSpeedModified = true
                        end
                    end
                end
            elseif GetVehiclePedIsIn(ped, false) == 0 then
                if BoatSpeedModified == true then
                    ModifyVehicleTopSpeed(GetVehiclePedIsIn(ped, true), 0.0)
                    BoatSpeedModified = false
                end
            end
        else
            Citizen.Wait(1100)
        end
    end
end)
--- END

function AddRunningSpeed(speed)
    local pedId = PlayerId()

    SetRunSprintMultiplierForPlayer(pedId, tonumber(speed))
end

function AddSwimmingSpeed(speed)
    local pedId = PlayerId()

    SetSwimMultiplierForPlayer(pedId, tonumber(speed))
end

function AddUnderWater(underwater)
    local ped = PlayerPedId()
    SetPedMaxTimeUnderwater(ped, (underwater + .0))
end

--- Place defense wall
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if HaveShieldWall == true and playerLoaded then
            if wallstanding == false then
                if wallwasplaced == false then

                    if IsControlPressed(0, 21) and IsControlJustReleased(0, 137) then
                        local ped = PlayerPedId()
                        if GetVehiclePedIsIn(ped, false) == 0 then
                            if not IsPedSwimming(ped) then
                                local propName = "diamond_shield"
                                local coords = GetEntityCoords(ped)
                                local prop = GetHashKey(propName)
                          
                                local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
                                local name = "wall_block_low"
                          
                                while not HasAnimDictLoaded(dict) do
                                  Citizen.Wait(10)
                                  RequestAnimDict(dict)
                                end
                          
                                RequestModel(prop)
                                while not HasModelLoaded(prop) do
                                  Citizen.Wait(100)
                                end
                          
                                local wall = CreateObject(prop, coords,  true,  false,  false)
                                local netid = ObjToNet(wall)
                          
                                TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
                                AttachEntityToEntity(wall,ped,GetPedBoneIndex(ped, 57005),0.21,0.01,0.11,-72.0,85.0,80.0, false, false, false, true, 2, true)
                          



                                shield_net = netid

                                wallwasplaced = true
                                wallstanding = true
                            end
                        end
                    end
                else
                    ESX.ShowNotification(Config.Text['wallrecharging'])
                    Citizen.Wait(WallRechargeTime * 1000)
                    wallwasplaced = false
                    ESX.ShowNotification(Config.Text['wallactive'])
                end
            else
                Citizen.Wait(10 * 1000)
                ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
                SetModelAsNoLongerNeeded(wall)
                SetEntityAsMissionEntity(wall, true, false)
                DetachEntity(NetToObj(shield_net), 1, 1)
                DeleteEntity(NetToObj(shield_net))
                shield_net = nil
                wallstanding = false
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
--- END

--- MORE STAMINA
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if HaveAddStaminaSprintTime == true and playerLoaded then
            local ped = PlayerPedId()
            local pedId = PlayerId()
            local Stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(pedId))

            if IsPedSprinting(ped) then

                if Stamina < RestoreStaminaPoint then

                    RestoreStaminaPoint = RestoreStaminaPoint - 10.0
                    SetPlayerStamina(pedId, Stamina + (AddStamina + .0))

                end
            end
        else
            Citizen.Wait(1400)
        end
    end
end)
--- END

--- STAMINA RECOVERY
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(700)

        if HaveAddStaminaRecoveryTime == true and playerLoaded then
            local ped = PlayerPedId()
            local pedId = PlayerId()
            local Stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(pedId))

            if not IsPedSprinting(ped) then

                if Stamina > RestoreStaminaPoint then

                    RestoreStaminaPoint = RestoreStaminaPoint + 10.0
                    SetPlayerStamina(pedId, Stamina + (AddStaminaRecovery + .0))

                end
            end
        else
            Citizen.Wait(600)
        end
    end
end)
--- END

local Set = false

RegisterNUICallback('StartingSkill', function(data)
    local StartingSkillPoints = data["StartingSkillPoints"]
    local StartingSkillId = data["StartingSkillId"]
    Citizen.Wait(math.random(100, 1000))
    if Set then return end
    Set = true
    TriggerServerEvent('D-skills:addpoints', StartingSkillPoints)
    TriggerServerEvent('D-skills:saveSkills', StartingSkillId)

end)

exports('AddExperienceClient', function(PlayerId, earned)
    TriggerServerEvent('D-skills:addExperianceEvent', PlayerId, earned)
end)

function closeMenuFull()
    display = false
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
    SendNUIMessage({
        type = "hide"
    })
end

RegisterNUICallback("close", function(data)
    display = false
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
end)

function notify(str)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandThefeedPostTicker(true, false)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100
    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.7 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)
        SetTextDropshadow(1, 1, 1, 1, 255)
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function EnsureAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end
local previousAnim = nil
function StopAnim(ped)
    if previousAnim then
        StopEntityAnim(ped, previousAnim[2], previousAnim[1], true)
        previousAnim = nil
    end
end
function PlayAnimFlags(ped, dict, anim, flags)
    StopAnim(ped)
    EnsureAnimDict(dict)
    local len = GetAnimDuration(dict, anim)
    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, len, flags, 1, 0, 0, 0)
    previousAnim = {dict, anim}
end

function PlayAnimUpper(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 49)
end
function PlayAnim(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 0)
end

local playersSwimming = false
local playersBoating = false
local playersDriving = false
local playersRunning = false
local playerPlayTime = 0
local isAfk = false

local afkCheckInterval = 10000
local lastPosition = nil
local afkThreshold = 300

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerId = PlayerId()
        local playerPos = GetEntityCoords(playerPed)

        if lastPosition and #(playerPos - lastPosition) < 0.5 then
            isAfk = true
        else
            isAfk = false
        end

        lastPosition = playerPos
        
        if not isAfk then

            if IsPedSwimming(playerPed) then
                if not playersSwimming then
                    playersSwimming = true
                    StartSwimmingTimer(playerId)
                end
            else
                if playersSwimming then
                    playersSwimming = false
                    Citizen.Wait(1500)
                end
            end
    
            if IsPedInAnyBoat(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    if not playersBoating then
                        playersBoating = true
                        StartBoatingTimer(playerId)
                    end
                else
                    if playersBoating then
                        playersBoating = false
                        Citizen.Wait(1500)
                    end
                end
            else
                if playersBoating then
                    playersBoating = false
                    Citizen.Wait(1500)
                end
            end
    
            if IsPedInAnyVehicle(playerPed, false) and not IsPedInAnyBoat(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    if not playersDriving then
                        playersDriving = true
                        StartDrivingTimer(playerId)
                    end
                else
                    if playersDriving then
                        playersDriving = false
                        Citizen.Wait(1500)
                    end
                end
            else
                if playersDriving then
                    playersDriving = false
                    Citizen.Wait(1500)
                end
            end
        end

        if IsPedRunning(playerPed) then
            if not playersRunning then
                playersRunning = true
                StartRunningTimer(playerId)
            end
        else
            if playersRunning then
                playersRunning = false
                Citizen.Wait(1500)
            end
        end

        Wait(afkCheckInterval)
    end
end)

function StartSwimmingTimer(playerId)
    local timer = 0
    playersRunning = false
    CreateThread(function()
        while playersSwimming do
            Wait(1000)
            timer = timer + 1
            if playersSwimming and timer >= 1200 then
                TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
                timer = 0
            end
        end
    end)
    CreateThread(function()
        while playersSwimming do
            Wait(2)
            ShowMissionText('~w~Skill System Swimming Task: ~w~'..timer.."~g~/1200")
        end
    end)
end

function StartBoatingTimer(playerId)
    local timer = 0
    CreateThread(function()
        while playersBoating do
            Wait(1000)
            timer = timer + 1
            if playersBoating and timer >= 900 then
                TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
                timer = 0
            end
        end
    end)
    CreateThread(function()
        while playersBoating do
            Wait(2)
            ShowMissionText('~w~Skill System Boat Driving Task: ~w~'..timer.."~g~/900")
        end
    end)
end

function StartDrivingTimer(playerId)
    local timer = 0
    CreateThread(function()
        while playersDriving do
            Wait(1000)
            timer = timer + 1
            if playersDriving and timer >= 1800 then
                TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
                timer = 0
            end
        end
    end)
    CreateThread(function()
        while playersDriving do
            Wait(2)
            ShowMissionText('~w~Skill System Driving Task: ~w~'..timer.."~g~/1800")
        end
    end)
end

function StartRunningTimer(playerId)
    local timer = 0
    playersSwimming = false
    CreateThread(function()
        while playersRunning do
            Wait(1000)
            timer = timer + 1
            if playersRunning and timer >= 600 then
                TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
                timer = 0
            end
        end
    end)
    CreateThread(function()
        while playersRunning do
            Wait(2)
            ShowMissionText('~w~Skill System Running Task: ~w~'..timer.."~g~/600")
        end
    end)
end

local allllo = {
	["police"] = true,
	["sheriff"] = true,
	["ambulance"] = true,
	["mechanic"] = true,
	["forces"] = true,
	["taxi"] = true,
	["benny"] = true,
	["fbi"] = true,
	["justice"] = true,
	["weazel"] = true,
	["medic"] = true,
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100 * 60 * 1000)
        if allllo[PlayerData.job.name] then
            TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200 * 60 * 1000)
        TriggerServerEvent('D-skills:addExperianceEvent', playerId, 20)
    end
end)

function ShowMissionText(text)
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.93)
end