---@diagnostic disable: lowercase-global
local lastSelected = {}
local lastSelectedCategory = false
for k,v in pairs(Configs.Weapons) do
    lastSelected[k] = 0
end

RegisterNetEvent("gfx-gunmenu:openMenu", function(money, timer, freeze)
    RemoveAllPedWeapons(PlayerPedId(), true)
    local time = timer or Configs.BuyTime
    setVisibility(true, {classes = Configs.Weapons, time = time, money = money, canClose = not freeze})
    if freeze then
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        Citizen.Wait(time * 1000)
        setVisibility(false)
        FreezeEntityPosition(ped, false)
    end
end)

RegisterNUICallback("exit", function(data, cb)
    setVisibility(false)
end)

RegisterNUICallback("buy", function(data, cb)
    local ped = PlayerPedId()
    if data.category ~= "grenades" then
        for i = 1, #Configs.Weapons[data.category].items do
            RemoveWeapon(ped, Configs.Weapons[data.category].items[i].name)
        end
        if data.category == "rifles" then
            for i = 1, #Configs.Weapons["midtier"].items do
                RemoveWeapon(ped, Configs.Weapons["midtier"].items[i].name)
            end
        end
        if data.category == "midtier" then
            for i = 1, #Configs.Weapons["rifles"].items do
                RemoveWeapon(ped, Configs.Weapons["rifles"].items[i].name)
            end
        end
    end
    data.lastSelected = lastSelected[data.category]
    data.lastSelectedCategory = lastSelectedCategory
    local result = Configs.Weapons[data.category].items[data.id]
    lastSelectedCategory = data.category
    lastSelected[data.category] = data.id
    if result and not Configs.UseWithItem then
        lastSelectedCategory = false
        lastSelected[data.category] = 0
        GiveWeapon(result)
    end
    cb(result)
end)

function RemoveWeapon(ped, weaponName)
    local hash = GetHashKey(weaponName)
    if HasPedGotWeapon(ped, hash, false) then
        RemoveWeaponFromPed(ped, hash)
    end
end

function setVisibility(bool, data)
    SendNUIMessage({
        type = "nui",
        display = bool,
        data = data
    })
    SetNuiFocus(bool, bool)
end

function GiveWeapon(itemData)
    local ped = PlayerPedId()
    if itemData.name:match("kevlar") then
        ESX.SetPedArmour(ped, 100)
    else
        local hash = GetHashKey(itemData.name)
        GiveWeaponToPed(ped, hash, 1000, false, true)
    end
end