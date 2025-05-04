DWR = {
    duration = 7000, -- Duration of the deathcam in ms
    resetDamageTime = 15000, -- Time in ms after which the damage is reset
    WeaponNames = {
        [-1569615261] = "Unarmed",
        [-1716189206] = "Knife",
        [1737195953] = "Nightstick",
        [1317494643] = "Hammer",
        [-1786099057] = "Bat",
        [-2067956739] = "Crowbar",
        [1141786504] = "Golfclub",
        [-102323637] = "Bottle",
        [-1834847097] = "Dagger",
        [-102973651] = "Hatchet",
        [-656458692] = "KnuckleDuster",
        [-581044007] = "Machete",
        [-1951375401] = "Flashlight",
        [-538741184] = "SwitchBlade",
        [-1810795771] = "Poolcue",
        [419712736] = "Wrench",
        [-853065399] = "Battleaxe",
        [453432689] = "Pistol",
        [3219281620] = "PistolMk2",
        [1593441988] = "CombatPistol",
        [-1716589765] = "Pistol50",
        [-1076751822] = "SNSPistol",
        [-771403250] = "HeavyPistol",
        [137902532] = "VintagePistol",
        [-598887786] = "MarksmanPistol",
        [-1045183535] = "Revolver",
        [584646201] = "APPistol",
        [911657153] = "StunGun",
        [1198879012] = "FlareGun",
        [324215364] = "MicroSMG",
        [-619010992] = "MachinePistol",
        [736523883] = "SMG",
        [2024373456] = "SMGMk2",
        [-270015777] = "AssaultSMG",
        [171789620] = "CombatPDW",
        [-1660422300] = "MG",
        [2144741730] = "CombatMG",
        [3686625920] = "CombatMGMk2",
        [1627465347] = "Gusenberg",
        [-1121678507] = "MiniSMG",
        [-1074790547] = "AssaultRifle",
        [961495388] = "AssaultRifleMk2",
        [-2084633992] = "CarbineRifle",
        [4208062921] = "CarbineRifleMk2",
        [-1357824103] = "AdvancedRifle",
        [-1063057011] = "SpecialCarbine",
        [2132975508] = "BullpupRifle",
        [1649403952] = "CompactRifle",
        [100416529] = "SniperRifle",
        [205991906] = "HeavySniper",
        [177293209] = "HeavySniperMk2",
        [-952879014] = "MarksmanRifle",
        [487013001] = "PumpShotgun",
        [2017895192] = "SawnoffShotgun",
        [-1654528753] = "BullpupShotgun",
        [-494615257] = "AssaultShotgun",
        [-1466123874] = "Musket",
        [984333226] = "HeavyShotgun",
        [-275439685] = "DoubleBarrelShotgun",
        [317205821] = "Autoshotgun",
        [-1568386805] = "GrenadeLauncher",
        [-1312131151] = "RPG",
        [1119849093] = "Minigun",
        [2138347493] = "Firework",
        [1834241177] = "Railgun",
        [1672152130] = "HomingLauncher",
        [1305664598] = "GrenadeLauncherSmoke",
        [125959754] = "CompactLauncher",
        [-1813897027] = "Grenade",
        [741814745] = "StickyBomb",
        [-1420407917] = "ProximityMine",
        [-1600701090] = "BZGas",
        [615608432] = "Molotov",
        [101631238] = "FireExtinguisher",
        [883325847] = "PetrolCan",
        [1233104067] = "Flare",
        [600439132] = "Ball",
        [126349499] = "Snowball",
        [-37975472] = "SmokeGrenade",
        [-1169823560] = "Pipebomb",
    },
}

--[[AddEventHandler("capture:inCapture", function(toggle)
    if GetInvokingResource() ~= "capture" then return end
    capture = toggle
end)]]

local damages = {}
RegisterNetEvent("gameEventTriggered", function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" then
        if not capture then return end
        local victimEntity, attackEntity, isFatal, damage, weaponUsed, isMelee = args[1], args[2], args[6] == 1, args[3], args[7], args[10]
        damage=string.pack("i4",damage)
        damage=string.unpack("f",damage)
        if victimEntity ~= PlayerPedId() then return end
        if not DoesEntityExist(attackEntity) or not IsEntityAPed(attackEntity) then return end
        damages.hit = damages.hit and (damages.hit + 1) or 1
        if GetPedArmour(victimEntity) > 0 then
            damages.apdamage = damages.apdamage and (damages.apdamage + damage) or damage
        else
            damages.hpdamage = damages.hpdamage and (damages.hpdamage + damage) or damage
        end
        if isFatal then
            showDeathCam(attackEntity, weaponUsed)
            damages = {}
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(DWR.resetDamageTime)
        if damages.hit then
            damages = {}
        end
    end
end)

function showDeathCam(attackEntity, weaponUsed)
    local deathCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local startTime = GetGameTimer()
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local targetPlayer = NetworkGetPlayerIndexFromPed(attackEntity)
    local targetId = GetPlayerServerId(targetPlayer)
    local targetName = GetPlayerName(targetPlayer)
    local targetHp = rangePercent(100, GetPedMaxHealth(targetPlayer), GetEntityHealth(targetPlayer))
    local targetArmor = GetPedArmour(attackEntity)
    CreateThread(function()
        local targetAvatar = GetPlayerPP(targetId)
        SendNUIMessage({
            type = "setavatar",
            avatar = targetAvatar,
        })
    end)
    local DWRWep = DWR.WeaponNames[weaponUsed]
    SendNUIMessage({
        type = "show",
        weaponName = DWRWep or weaponUsed,
        name = targetName,
        avatar = targetAvatar,
        health = targetHp,
        armor = targetArmor,
        hpDamage = damages.hpdamage or 0,
        apDamage = damages.apdamage or 0,
        hit = damages.hit or 0,
    })


    AttachCamToEntity(cam, attackEntity, 0.0, 2.8, 0.6, true)
    SetCamFov(cam, 50.0)
    PointCamAtEntity(cam, attackEntity, 0.0, 0.0, 0.0, true)

    CreateThread(function()
        while cam do
            if not DoesEntityExist(attackEntity) then
                DestroyCam(cam, false)
                cam = nil
                RenderScriptCams(false, false, 0, true, true)
                return
            end

            Wait(100)
        end
    end)
    
    RenderScriptCams(true, true, 350, true, true)

    Wait(DWR.duration)

    SendNUIMessage({
        type = "hide",
    })    
    DestroyCam(cam, false)
    cam = nil
    RenderScriptCams(false, false, 0, true, true)
end

function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min))
end

function GetPlayerPP(id)
    local callback = promise:new()
    ESX.TriggerServerCallback("esx:GetProfilePic", function(pp) 
        print(pp)
        callback:resolve(pp)
    end, id)
    return Citizen.Await(callback)
end