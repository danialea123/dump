---@diagnostic disable: undefined-global
local ChangeName = vector3(-551.64,-190.08,38.22)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    ESX.SetPlayerData("name", name)
    PlayerData.name = name
end)

local Times = {
    [1] = "Free",
    [2] = "100,000$",
    [3] = "500,000$",
}

local Money = {
    [1] = 0,
    [2] = 100000,
    [3] = 500000,
}

CreateThread(function()
	local DInMarker
	local Key
	local DMarker = RegisterPoint(ChangeName, 5, true)
	DMarker.set('InArea', function()
		DrawMarker(20, ChangeName.x, ChangeName.y, ChangeName.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 100, true, true, 2, false, false, false, false)
        ShowFloatingHelpNotification("Dokme   ~INPUT_CONTEXT~Baraye Taghir Esm" ,ChangeName)
	end)
	DMarker.set('InAreaOnce', function()
		DInMarker = RegisterPoint(ChangeName, 1, true)
		DInMarker.set('InAreaOnce', function()
			Hint:Create('Dokme ~INPUT_CONTEXT~ Baraye Taghir Name Khod')
			Key = RegisterKey('E', false, function()
                ESX.TriggerServerCallback("esx_name:CheckChangeCount", function(result)
                    if result then
                        local fee = Times[result]
                        local money = Money[result]
                        if not fee then 
                            fee = "500,000$"
                        end
                        if not money then 
                            money = 500000
                        end
                        local Timer = GetGameTimer()
                        Key = UnregisterKey(Key)
                        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'front_desk',
                        {
                            title 	 = 'از تغییر نام و نام خانوادگی خود مطمعنید؟',
                            align    = 'center',
                            question = "Naam Fe`eli: ["..string.gsub(ESX.GetPlayerData().name, "_", " ").."], \n Hazine Taghir Naam "..fee.." Mibashad Va Be Moddat 1 Hafte Taaghir Esm Momken Nakhahad Bood",
                            elements = {
                                {label = 'Bale', value = 'yes'},
                                {label = 'Kheir', value = 'no'},
                            }
                        }, function(data3, menu3)
                            if data3.current.value == "yes" then
                                if GetGameTimer() - Timer > 5000 then
                                    if ESX.GetPlayerData().money >= money then
                                        if GetResourceKvpInt("cooldown") <= exports.sr_main:GetTimeStampp() then
                                            menu3.close()
                                            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'first_name', {
                                                title = 'لطفا اسم کوچک خودتون رو وارد کنید',
                                            }, function(data, menu)
                                                if data.value then
                                                    data.value = tostring(data.value)
                                                    if not data.value then
                                                        ESX.Alert("~h~Hade aghal esm bayad ~g~7~w~ character bashad!", "error")
                                                        return
                                                    end
                                
                                                    if data.value:match("[^%w%s%_]") or data.value:match("%d") or string.find(data.value, "_") or string.find(data.value, "-") then
                                                        ESX.Alert("~h~Shoma mojaz be vared kardan ~r~Special character ~w~ya ~r~adad ~w~nistid!", "error")
                                                        return
                                                    end
                                                    if string.len(trim1(data.value)) < 3 then 
                                                        ESX.Alert("Hade Aghal Bayad 3 Character Vared Konid", "error")
                                                        return 
                                                    end
                                                    menu.close()
                                                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'last__name', {
                                                        title = 'لطفا نام خانوادگی خودتون رو وارد کنید',
                                                    }, function(data2, menu2)
                                                        data2.value = tostring(data2.value)
                                                        if data2.value then
                                                            if not data2.value then
                                                                ESX.Alert("~h~Hade aghal esm bayad ~g~7~w~ character bashad!", "error")
                                                                return
                                                            end
                                        
                                                            if data2.value:match("[^%w%s%_]") or data2.value:match("%d") or string.find(data2.value, "_") or string.find(data2.value, "-") then
                                                                ESX.Alert("~h~Shoma mojaz be vared kardan ~r~Special character ~w~ya ~r~adad ~w~nistid!", "error")
                                                                return
                                                            end

                                                            if string.len(trim1(data2.value)) < 4 then 
                                                                ESX.Alert("Hade Aghal Bayad 4 Character Vared Konid", "error")
                                                                return 
                                                            end
                                                            TriggerServerEvent('Diamond:changeNickname', firstToUpper(string.lower(trim1(data.value))).."_"..firstToUpper(string.lower(trim1(data2.value))))
                                                            print(firstToUpper(string.lower(trim1(data.value))).."_"..firstToUpper(string.lower(trim1(data2.value))))
                                                            ESX.Alert("Taghir Esm Movafaghiat Amiz Bood", "check")
                                                            SetResourceKvpInt("cooldown", exports.sr_main:GetTimeStampp()+604800)
                                                            menu2.close()
                                                        else
                                                            ESX.Alert('Meghdar sahih vared ~r~nashod~s~!', "error")
                                                        end
                                                    end, function(data2, menu2)
                                                        menu2.close()
                                                    end)
                                                else
                                                    ESX.Alert('Meghdar sahih vared ~r~nashod~s~!', "error")
                                                end
                                            end, function(data, menu)
                                                menu.close()
                                            end)
                                        else
                                            ESX.Alert("Shoma Be Tazegi Taghir Naam Dade id, Bayad 1 Hafte Montazer Bashid", "info")
                                        end
                                    else
                                        ESX.Alert("Shoma Pool Kafi Nadarid", "error")
                                    end
                                end
                            else
                                menu3.close()
                            end
                        end, function (data3, menu3)
                            menu3.close()
                        end)
                    end
                end)
            end)
		end, function()
			Hint:Delete()
			Key = UnregisterKey(Key)
            ESX.UI.Menu.Close("question", GetCurrentResourceName(), "front_desk")
            ESX.UI.Menu.Close("dialog", GetCurrentResourceName(), "first_name")
            ESX.UI.Menu.Close("dialog", GetCurrentResourceName(), "last__name")
		end)
	end, function()
		if DInMarker then
			DInMarker = DInMarker.remove()
		end
	end)
end)

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end