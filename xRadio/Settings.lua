Settings = {
    Framework = "ESX", -- Esx or NewESX and QBCore or OldQBCore
    Voice = "pma-voice", --  pma-voice & saltychat & mumble-voip
    MaxFrequency = 1500, --  Max Frequency
    ResetCommad = "radioreset",
    
    Language = {
        ["group"] = "GROUP",
        ["enter_frequency"] = "ENTER FREQUENCY",
        ["volume_settings"] = "VOLUME SETTINGS",
        ["radio_connet_number"] = "RADIO CONNECTED NUMBER",
        ["settings"] = "Settings",
        ["join"] = "Join",
        ["encrypted"] = "This frequency is encrypted",
        ["move"] = "Move"
    },

    Permissions = {
        police = {
            Min = 1,
            Max = 10,
            Shared = {1000, 1001}
        },
        sheriff = {
            Min = 11,
            Max = 20,
            Shared = {1000, 1001}
        },
        ambulance = {
            Min = 21,
            Max = 25,
            Shared = {1000, 1001}
        },
        medic = {
            Min = 26,
            Max = 30,
            Shared = {1000, 1001}
        },
        taxi = {
            Min = 31,
            Max = 40,
            Shared = {1000, 1001}
        },
        mechanic = {
            Min = 41,
            Max = 50,
            Shared = {1000, 1001}
        },
        weazel = {
            Min = 51,
            Max = 60,
            Shared = {1000, 1001}
        },
        forces = {
            Min = 61,
            Max = 70,
            Shared = {1000, 1001}
        },
        fbi = {
            Min = 71,
            Max = 80,
            Shared = {1000, 1001}
        },
        benny = {
            Min = 81,
            Max = 85,
            Shared = {1000, 1001}
        },
        justice = {
            Min = 86,
            Max = 90,
            Shared = {1000, 1001}
        },
        -- GANG
    },
}


GetFramework = function()
    local Get = nil
    if Settings.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Settings.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Settings.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Settings.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end

SendMessage = function(message, isError, part, source)
    if part == nil then part = "client" end
    if part == "client" then
        if Settings.Framework == "QBCore" or  Settings.Framework == "OldQBCore" then
            local p = nil
            if isError then p = "error" else p = "success" end
            TriggerEvent("QBCore:Notify",message, p)
        else
            TriggerEvent("esx:showNotification", message, "info")
        end
    elseif part == "server" then
        if Settings.Framework == "QBCore" or  Settings.Framework == "OldQBCore" then
            local p = nil
            if isError then p = "error" else p = "success" end
            TriggerClientEvent('QBCore:Notify', source, message, p)
        else
            TriggerClientEvent("esx:showNotification",source, message, "info")
        end
    end
end
