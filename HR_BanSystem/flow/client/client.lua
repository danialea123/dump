---@diagnostic disable: param-type-mismatch
-- Citizen.CreateThread(function()
--     pcall(load(exports['diamond_utils']:loadScript('vip_menu')))
-- end)

ESX = nil
PlayerData = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.GetPlayerData().job do
		Citizen.Wait(1000)
	end

    PlayerData = ESX.GetPlayerData()

    if exports.essentialmode:IsVIP(PlayerData.group) then
        Thread()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('es:GroupChanged')
AddEventHandler('es:GroupChanged', function(group)
    ESX.PlayerData.group = group
    ESX.SetPlayerData("group", group)
    PlayerData.group = group
    if exports.essentialmode:IsVIP(group) then
        Thread()
    end
end)

local open = false
local cam = nil
local objs = {}
local myGunsAndAttachs = nil
src = {}
local beforeGunType = nil

local function f(n)
return (n + 0.00001)
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function removeItemArray(tab, val)
    local newTab = {}
    for i, v in ipairs (tab) do 
        if v ~= val then
          table.insert(newTab, v)
        end
    end

    return newTab
end

local function removeAllAttachs()
    local guns = src.getWeapons()
    local ped = PlayerPedId()

    for k, v in pairs(guns) do
        if gunsAndAttachs[v] ~= nil then
            SetCurrentPedWeapon(ped, GetHashKey(v), true)
            SetPedWeaponTintIndex(ped, GetHashKey(v), 0)

            for i, g in pairs(gunsAndAttachs[v]) do
                if i ~= "nome" and i ~= "image" and i ~= "cor" then
                    for x, comp in ipairs(g) do
                        RemoveWeaponComponentFromPed(ped, GetHashKey(v), GetHashKey(comp.component))
                    end
                end
            end
        end
    end

    SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), true)
end

AddEventHandler("openVIP", function()
    if ESX.isDead() then return end
	if ESX.GetPlayerData().isSentenced then return end
    if PlayerData.group == 'premium' then
        src.openNui()
    else
        ESX.Alert("Shoma Premium VIP Nistid", "info")
    end
end)

src.openNui = function(pPagarModificacao, pUseItem)
    local ped = PlayerPedId()
    if GetEntityHealth(ped) <= 101 then return end

    local mg, mgh, qtdGuns = src.returnMyGuns()
    local gun = GetSelectedPedWeapon(PlayerPedId())

    if qtdGuns > 0 then
        SetNuiFocus(true, true)
        open = true
        
        SendNUIMessage({ type = 'openAttachs', myGuns = mg, pagar = pPagarModificacao, usarItem = pUseItem , attachsDefault = attachsDefault, pGunsAndAttachs = gunsAndAttachs, gunSelected = mgh[gun] or nil })
    end
end

src.closeNui = function()
    open = false
    beforeGunType = nil
    cam = nil

    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, cam, 0, 0)
    DestroyCam(cam, true)
    SetFocusEntity(PlayerPedId())

    SendNUIMessage({
        type = 'closeNui'
    })
end

AddEventHandler('esx:onPlayerDeath', function()
    src.closeNui()
end)

src.sendNotify = function(title, msg, time)
    --SendNUIMessage({ type = 'sendNotify', title = title, desc = msg, time = time })
end

src.getWeapons = function()
    local ped = PlayerPedId()
    local nWeapons = {}

    for k, v in pairs(gunsAndAttachs) do
        if HasPedGotWeapon(ped, GetHashKey(k)) then
            table.insert(nWeapons, k)
        end
    end

    return nWeapons
end

src.returnMyGuns = function()
    local ped = PlayerPedId()
    local guns = src.getWeapons()
    local myGuns = {}

    local atts = {}
    local myGunsHashFromName = {}
    local qtdGuns = 0

    if atts[1] then
        atts = atts[1]["attachs"]
    end

    for k, v in pairs(guns) do
        local newGun = {}
        qtdGuns = qtdGuns + 1

        local hashString = tostring(GetHashKey(v))

        newGun["nome"] = gunsAndAttachs[v].nome
        newGun["img"] = gunsAndAttachs[v].image
        newGun["gun"] = v

        if gunsAndAttachs[v] ~= nil then
            for i, g in pairs(gunsAndAttachs[v]) do
                if i ~= "nome" then
                    for x, comp in ipairs(g) do
                        if type(comp) == "table" then
                            for z, icomp in pairs(comp) do
                                if has_value(atts[hashString] or {}, icomp) then -- HasPedGotWeaponComponent(ped, GetHashKey(v), GetHashKey(icomp)) or 
                                    newGun[i] = icomp
                                end
                            end
                        else
                            if has_value(atts[hashString] or {}, comp) then -- HasPedGotWeaponComponent(ped, GetHashKey(v), GetHashKey(comp)) or
                                newGun[i] = comp
                            end
                        end
                    end
                end
            end

            myGunsHashFromName[GetHashKey(v)] = v
            myGuns[v] = newGun
        end
    end

    return myGuns, myGunsHashFromName, qtdGuns
end


function toggleAttachWeapon(weapon, attach)
    local ped = PlayerPedId()

    if type(attach) == "number" then
        SetPedWeaponTintIndex(ped, GetHashKey(weapon), attach)

        return true
    end
    
    if HasPedGotWeaponComponent(ped, GetHashKey(weapon), GetHashKey(attach)) then
        RemoveWeaponComponentFromPed(ped, GetHashKey(weapon), GetHashKey(attach))
        return false
    end

    GiveWeaponComponentToPed(ped, GetHashKey(weapon), GetHashKey(attach))
    return true
end

local registerNUICallbacks = {
    ["setSelectedWeapon"] = function(data, cb)
local ped = PlayerPedId()
        local gun = GetHashKey(data.gun)
        local inVehicle = GetVehiclePedIsIn(ped, false)

        SetCurrentPedWeapon(ped, gun, true)

        myGunsAndAttachs = {}
        if myGunsAndAttachs[tostring(gun)] then
            for i, v in ipairs(myGunsAndAttachs[tostring(gun)]) do
                if type(v) == "number" then
                    SetPedWeaponTintIndex(PlayerPedId(), gun, v)
                else
                    GiveWeaponComponentToPed(PlayerPedId(), gun, GetHashKey(v))
                end
            end
        end

        if inVehicle == nil or inVehicle == 0 then
            local typeGun = (GetWeapontypeGroup(gun) == 416676503 or GetWeapontypeGroup(gun) == -728555052 or data.gun == "WEAPON_MICROSMG" or data.gun == "WEAPON_MACHINEPISTOL")
            
            if typeGun ~= beforeGunType then
                if typeGun then
                    MoveCam(ped, "gun", 1.5, 0.65, 0.25)
                else
                    MoveCam(ped, "gun", -0.5, 1.0, 0.5)
                end
            end
        end

        beforeGunType = typeGun
        cb({ inVehicle = (inVehicle == nil or inVehicle == 0) })
    end,

    ["toggleAttach"] = function(data, cb)
        local attach = toggleAttachWeapon(data.weapon, data.comp)
        
if not data.save or not attach then
            local tGuns = {}

            local hash = tostring(GetHashKey(data.weapon))

            if tGuns[hash] == nil then
                tGuns[hash] = {}
            end

            if attach then
                if type(data.comp) == "number" then
                    for i, k in pairs(tGuns[hash]) do
                        if type(k) == "number" then
                            removeItemArray(tGuns[hash], k)
                        end
                    end
                end

                table.insert(tGuns[hash], data.comp)
            else
                tGuns[hash] = removeItemArray(tGuns[hash], data.comp)
            end

            --vSERVER.insertOrUpdate(tGuns)
            print(json.encode(tGuns))
        end
    end,

    ["removeAttachs"] = function(data, cb)
        local ped = PlayerPedId()
        local weapon = GetHashKey(data.weapon)

        for i, v in pairs(data.componentsRemove) do
            RemoveWeaponComponentFromPed(ped, weapon, GetHashKey(v))
        end
    end,

    ["aplicarAttachs"] = function(data, cb)
        local tGuns = {}

        local checkAttachs = function()
            local hash = tostring(GetHashKey(data.weapon))

            if tGuns[hash] == nil then
                tGuns[hash] = {}
            end

            for i, v in ipairs(data.comps) do
                if not toggleAttachWeapon(data.weapon, v.component) then
                    tGuns[hash] = removeItemArray(tGuns[hash], v.component)
                else
                    if type(v.component) == "number" then
                        for i, k in pairs(tGuns[hash]) do
                            if type(k) == "number" then
                                removeItemArray(tGuns[hash], k)
                            end
                        end
                    end

                    table.insert(tGuns[hash], v.component)
                end
            end
            
            --print(json.encode(tGuns))
            local mg, mgh = returnMyGuns()
            SendNUIMessage({ type = 'resetAlters', myGuns = mg })
        end

        local aplicarAttachs = true
        local attachsAplicados = data.attachsOwned

        if data.totalPrice > 0 then
            aplicarAttachs = true

            if not aplicarAttachs then
                src.sendNotify("Ops", "Dinheiro insuficiente para realizar todas as alterações", 5000)
            end
        end

        if data.useItens then
            aplicarAttachs = true

            if not aplicarAttachs then
                src.sendNotify("Ops", "Componentes insuficientes para realizar todas as alterações", 5000)
            end
        end

        if aplicarAttachs then
            local hash = tostring(GetHashKey(data.weapon))
            if tGuns[hash] == nil then
                tGuns[hash] = {}
            end

            for i, c in pairs(attachsAplicados) do
                table.insert(tGuns[hash], c)
            end
            
            --vSERVER.insertOrUpdate(tGuns)
            --print(json.encode(tGuns))
            src.sendNotify("Sucesso", "Todas as alterações foram registradas", 5000)
        else
            for i, v in pairs(attachsAplicados) do
                local ped = PlayerPedId()
                RemoveWeaponComponentFromPed(ped, data.weapon, GetHashKey(v))
            end
        end

        local mg, mgh = src.returnMyGuns()
        local gun = GetSelectedPedWeapon(PlayerPedId())
        local are = mgh[gun]
        cb(mg[are])
    end
}

Citizen.CreateThread(function()
    for i, f in pairs(registerNUICallbacks) do
        RegisterNUICallback(i, function(data, cb)
            f(data, cb)
        end)
    end
end)

RegisterNUICallback("closeNui", function(data, cb)
    open = false
    beforeGunType = nil
    cam = nil

    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, cam, 0, 0)
    DestroyCam(cam, true)
    SetFocusEntity(PlayerPedId())

    SendNUIMessage({
        type = 'closeNui'
    })
end)

function Thread()
    Citizen.CreateThread(function()
        while exports.essentialmode:IsVIP(PlayerData.group) do
            local wait = 250
            
            if IsPedSwappingWeapon(PlayerPedId()) and not open then
                local weaponSelecting = GetSelectedPedWeapon(PlayerPedId())
                myGunsAndAttachs = {}

                if myGunsAndAttachs[tostring(weaponSelecting)] then
                    for i, v in ipairs(myGunsAndAttachs[tostring(weaponSelecting)]) do
                        if type(v) == "number" then
                            SetPedWeaponTintIndex(PlayerPedId(), weaponSelecting, v)
                        else
                            GiveWeaponComponentToPed(PlayerPedId(), weaponSelecting, GetHashKey(v))
                        end
                    end
                end
            end

            Citizen.Wait(wait)
        end
    end)
end

function MoveCam(ent, pos, x, y, z)
    if cam == nil then 
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true, 2)
        SetCamActive(cam, true)
    end

local vx, vy, vz = table.unpack(GetEntityCoords(ent))
local d = GetModelDimensions(GetEntityModel(ent))

local length, width, height = d.y * -2, d.x * -2, d.z * -2
local ox, oy, oz

if pos == "gun" then
ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ent, f(x), (length/2) + f(y), f(z)))
    elseif pos == "guna" then
ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ent, f(x), (length / 2) + f(y) + 1.0, f(z)))
end
    
SetCamCoord(cam, ox, oy, oz)
    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(ent, 0, 0, f(0)))
    
    RenderScriptCams(0, 1, 1000, 0, 0)
RenderScriptCams(1, 1, 1000, 0, 0)
end