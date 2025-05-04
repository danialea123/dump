ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

function CodeMenu()
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = "CodeMenu"
    })
end

RegisterNUICallback("close", function ()
    SetNuiFocus(false,false)
end)

RegisterNUICallback("accept", function(data, cb)
    local data = data.code
    if not tonumber(data) and tostring(data) and string.len(data) >= 4 and string.len(data) <= 10 then
        ESX.TriggerServerCallback("esx_redeem:isCodeValid", function(state)
            if state then
                cb("Code Vared Shode Estefade Shod")
            else
                cb(false)
            end
        end, data)
    else
        cb(false)
    end
end)

RegisterCommand("redeem", function()
    CodeMenu()
end)

RegisterNetEvent("esx_redeem:OpenMenu", function(codes)
    ESX.UI.Menu.CloseAll()
    local element = {
        {label = "Create Code", value = "create"},
        {label = "Current Codes", value = "current"},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'code',
    {
        title    = "Redeem System",
        align    = 'center',
        elements = element
    }, function(data, menu)
        local data = data.current.value
        if data == "create" then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'code_1',
            {
                title    = "Redeem System",
                align    = 'center',
                elements = {
                    {label = "Code 1 Bar Masraf", value = "onetime"},
                    {label = "Code Timei", value = "timer"},
                }
            }, function(data2, menu2)
                local action2 = data2.current.value
                if action2 == "timer" then 
                    input = lib.inputDialog('Enter Number', {
                        {type = 'number', label = 'Moddat Code', description = 'time be daghighe...'},
                    })
                    if not input or not input[1] then return end
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'code_2',
                {
                    title    = "Redeem System",
                    align    = 'center',
                    elements = {
                        {label = "DCoin", value = "dcoin"},
                        {label = "Money", value = "money"},
                        {label = "Item", value = "item"},
                        {label = "Weapon", value = "weapon"},
                    }
                }, function(data3, menu3)
                    local action3 = data3.current.value
                    if action3 == "dcoin" or action == "money" then
                        input1 = lib.inputDialog('Enter Number', {
                            {type = 'number', label = 'reward amount', description = 'meghdar pul ya dcoin...'},
                        })
                        if not input1 or not input1[1] then return end
                    else
                        input1 = lib.inputDialog('Enter Name', {
                            {type = 'input', label = 'Reward Name', description = 'esm item ya aslahe...', required = true, min = 1, max = 16},
                        })
                        if not input1 or not input1[1] then return end
                    end
                    local a = GenerateCode(codes)
                    lib.setClipboard(a)
                    TriggerServerEvent("esx_redeem:AddCode", action2, input and input[1]or nil, action3, input1[1], a)
                    ESX.UI.Menu.CloseAll()
                end, function(data3, menu3)
                    menu3.close()
                end)
            end, function(data2, menu2)
                menu2.close()
            end)
        else
            local ele = {}
            for k, v in pairs(codes) do
                table.insert(ele, {label = "Code: "..k.." | Type: "..(v.type and "Timer" or "1 Bar Masraf")..(v.type and " | Expire: "..math.floor((v.type - exports.sr_main:GetTimeStampp())/60).." Minutes" or "").." | Reward Type: "..v.reward.." | Name: "..v.name, value = nil})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'code_6',
            {
                title    = "Redeem System",
                align    = 'center',
                elements = ele
            }, function(data3, menu3)

            end, function(data3, menu3)
                menu3.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GenerateCode(List)
	local generatedPlate
	repeat
		Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(3) .. GetRandomNumber(2) .. GetRandomLetter(2))
		if not List[generatedPlate] then
			break
		end
	until true
	return generatedPlate
end
