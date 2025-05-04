RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
    local item = item
    if not item.name then return end
    if item.name:find("key_") then
        item.name = "key"
    end
    local img = (item.name:find("m_") and GetImage(item.name)) or (item.name:find("f_") and GetImage(item.name)) or item.name
    exports["esx_sheriffjob"]:ShowRequirements({
        ["Amount"] = count,
        ["Image"] = ESX.GetPlayerData().settings.."/"..img..".png",
        ["Label"] = item.label,
        ["Local"] = true,
    })
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
    local item = item
    if not item.name then return end
    if item.name:find("key_") then
        item.name = "key"
    end
    local img = (item.name:find("m_") and GetImage(item.name)) or (item.name:find("f_") and GetImage(item.name)) or item.name
    exports["esx_sheriffjob"]:ShowRequirements({
        ["Amount"] = count,
        ["Image"] = ESX.GetPlayerData().settings.."/"..img..".png",
        ["Label"] = item.label,
        ["Local"] = true,
    })
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
    exports["esx_sheriffjob"]:ShowRequirements({
        ["Amount"] = ammo,
        ["Image"] = ESX.GetPlayerData().settings.."/"..weaponName..".png",
        ["Label"] = ESX.GetWeaponLabel(weaponName),
        ["Local"] = true,
    })
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
    exports["esx_sheriffjob"]:ShowRequirements({
        ["Amount"] = 0,
        ["Image"] = ESX.GetPlayerData().settings.."/"..weaponName..".png",
        ["Label"] = ESX.GetWeaponLabel(weaponName),
        ["Local"] = true,
    })
end)

exports("ShowRequirements", function(Request) 
    local Reqs = { 
        {
            ["Amount"] = Request["Amount"],
            ["Image"] = Request["Image"],
            ["Label"] = Request["Label"],
            ["Local"] = Request["Local"],
        },
    }
  
    SendNUIMessage({
        Action = "SetRequirements", 
        Display = true,
        Requirements = Reqs
    })

    Citizen.SetTimeout(1000, function()
        SendNUIMessage({
            Action = "SetRequirements", 
            Display = false,
        })
    end)
end)        

exports("HideRequirements",function()
    SendNUIMessage({
        Action = "SetRequirements", 
        Display = false,
    })
end)

function GetImage(name)
    local p = promise.new()
    ESX.TriggerServerCallback("esx_clothes:GetClothID", function(data) 
        p:resolve(data)
    end, name)
    return Citizen.Await(p)
end
