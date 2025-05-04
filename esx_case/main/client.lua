ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    while not ESX do Citizen.Wait(1000) end
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

local display = false
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
end

RegisterNUICallback("exit",function(data)
    SetDisplay(false)
end)

RegisterNUICallback('give', function(data) 
    ESX.TriggerServerCallback("SetCaseData", function()

    end, data)
end)

RegisterNUICallback('sell', function(data, cb) 
    ESX.TriggerServerCallback("GetSell", function(result, new)
        cb({
            variable = result,
            amount = new
        })
    end, data)
end)

RegisterNUICallback('GetCase', function(data, cb) 
    ESX.TriggerServerCallback("GetCaseData", function(result)
        cb({
            check = result
        })
    end, data)
end)

RegisterNUICallback("Check",function(data)
    ESX.TriggerServerCallback("Profile", function(gold, bank, name, avatar)
        SendNUIMessage({
            type = "purchase",
            gold =  PlayerData.Coin,
            bank =  PlayerData.Coin,
            name =  name,
            avatar = avatar,
        })
    end)
end)

AddEventHandler("opencase", function()
    ESX.TriggerServerCallback("Profile", function(gold, bank, name, avatar)
        SendNUIMessage(
            {
                type = "purchase",
                gold =  PlayerData.Coin,
                bank =  PlayerData.Coin,
                name =  name,
                avatar = avatar,
            }
        )
    end)
    SendNUIMessage(
        {
            type = "case",
            cases = Config.Live,
            standart =  Config.Standart,
            things = Config.System['Items that can be found in the safe'],
            gold = Config.System['Store Gold Section'],
            categories = Config.System['Case Categories']
        }
    )
    SetDisplay(true, true)
end)

local numbers = {
    ["premiumdiamond"] = 1,
    ["premiumitem"] = 2,
    ["premiumgun"] = 4,
    ["premiumcar"] = 3,
    ["standarditem"] = 7,
    ["standardgun"] = 6,
    ["standardcar"] = 8,
    ["standarddiamond"] = 5,
}

RegisterNetEvent("esx_case:OpenCaseWithItem", function(name)
    TriggerEvent("esx_inventoryhud:closeInventory")
    if not numbers[name] then return end
    ESX.TriggerServerCallback("esx_case:check", function(check)
        if check then
            SendNUIMessage(
                {
                    type = "purchase",
                    gold =  PlayerData.Coin,
                    bank =  PlayerData.Coin,
                    name =  name,
                    avatar = avatar,
                }
            )
            SendNUIMessage(
                {
                    type = "case",
                    cases = Config.Live,
                    standart =  Config.Standart,
                    things = Config.System['Items that can be found in the safe'],
                    gold = Config.System['Store Gold Section'],
                    categories = Config.System['Case Categories']
                }
            )
            SetDisplay(true, true)
            Citizen.Wait(2000)
            SendNUIMessage(
                {
                    type = "openCase",
                    caseData = Config.Live[numbers[name]],
                }
            )
        end
    end, name)
end)
