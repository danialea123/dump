---@diagnostic disable: trailing-space, undefined-field, missing-parameter
ESX = nil
local object = "prop_vend_snak_01"
local Objects = {}
local created = false
local open = false
local JobData = {}
local Jobs = {
    ["bahamas"] = "Bahamas Club",
    ["triad"] = "Triad Club",
    --["fightclub"] = "Fight Club",
    ["catcafe"] = "Cat Cafe",
    --["streetclub"] = "StreetClub",
    ["kharchang"] = "Cafe Kharchang",
    ["artist"] = "Cafe Artist",
}
local Sticker = {
    ["bahamas"] = "🍷",
    ["triad"] = "🍸",
    --["fightclub"] = "💪",
    ["catcafe"] = "🐱",
    --["streetclub"] = "👠",
    ["kharchang"] = "🦀",
    ["artist"] = "🍺",
}
local text_ui = {
    help = {
        ('[←] - Rotate the object left  \n'),
        ('[→] - Rotate the object right  \n'),
        ('[ ↑ ] - Rotate the object up  \n'),
        ('[ ↓ ] - Rotate the object down  \n'),
        ('[ENTER] - Finish \n'),
    },
    open_vending = '[E] - Open Vending',
}
local JobItems = {
    ["bahamas"] = {
        ["sini"] = {
            label = "Sini Maze",
            price = 8000,
        },
        ["moohito"] = {
            label = "Mohito",
            price = 7000,
        },
        ["bloodymerry"] = {
            label = "Bloody Merry",
            price = 6000,
        },
        ["margarita"] = {
            label = "Margarita",
            price = 6000,
        },
        ["pinacolada"] = {
            label = "PinaColada",
            price = 9000,
        },
        ["vodkaredbull"] = {
            label = "Vodka Redbull",
            price = 5000,
        },
        ["whiskeycola"] = {
            label = "Whiskey Cola",
            price = 5000,
        },
        ["hypeenergy"] = {
            label = "Hype Energy",
            price = 10000,
        },
    },
    ["triad"] = {
        ["espressomartini"] = {
            label = "Espresso Martini",
            price = 8000,
        },
        ["magicdrink"] = {
            label = "Magic Drink",
            price = 10000,
        },
        ["bubbletea"] = {
            label = "Bubble Tea",
            price = 6000,
        },
        ["majon"] = {
            label = "Majun",
            price = 9000,
        },
        ["whiskeycola"] = {
            label = "Whiskey Cola",
            price = 7000,
        },
    },
    --[[["fightclub"] = {
        ["sini"] = {
            label = "Sini Maze",
            price = 8000,
        },
        ["moohito"] = {
            label = "Mohito",
            price = 7000,
        },
        ["bloodymerry"] = {
            label = "Bloody Merry",
            price = 6000,
        },
        ["margarita"] = {
            label = "Margarita",
            price = 6000,
        },
        ["pinacolada"] = {
            label = "PinaColada",
            price = 9000,
        },
        ["vodkaredbull"] = {
            label = "Vodka Redbull",
            price = 5000,
        },
        ["whiskeycola"] = {
            label = "Whiskey Cola",
            price = 5000,
        },
        ["whiskeycola"] = {
            label = "Whiskey Cola",
            price = 5000,
        },
        ["omlet"] = {
            label = "Omlet",
            price = 9000,
        },
    },]]
    ["catcafe"] = {
        ["catrice"] = {
            label = "Cat Rice",
            price = 5000,
        },
        ["catpizza"] = {
            label = "Cat Pizza",
            price = 5000,
        },
        ["catapplejuice"] = {
            label = "Cat Apple Juice",
            price = 5000,
        },
        ["catgrapejuice"] = {
            label = "Cat Grape Juice",
            price = 5000,
        },
        ["catdonut"] = {
            label = "Cat Donut",
            price = 6000,
        },
        ["catlemonade"] = {
            label = "Cat Lemonade",
            price = 6000,
        },
        ["icecreamcat1"] = {
            label = "Ice Cream Cat 1",
            price = 5000,
        },
        ["icecreamcat2"] = {
            label = "Ice Cream Cat 2",
            price = 5000,
        },
        ["icecreamcat3"] = {
            label = "Ice Cream Cat 3",
            price = 5000,
        },
        ["catlatte"] = {
            label = "Cat Latte",
            price = 8000,
        },
        ["moochi"] = {
            label = "Moochi",
            price = 10000,
        },
    },
    --[[["streetclub"] = {
        ["espresso"] = {
            label = "Espresso",
            price = 6000,
        },
        ["milkshake"] = {
            label = "Milkshake",
            price = 5000,
        },
        ["mohito"] = {
            label = "Mohito",
            price = 7000,
        },
        ["vodkaredbull"] = {
            label = "Vodka Redbull",
            price = 5000,
        },
        ["vodkaenergy"] = {
            label = "Vodka Energy",
            price = 5000,
        },
        ["vodka"] = {
            label = "Vodka",
            price = 4000,
        },
        ["poolcocktail"] = {
            label = "Pool Cocktail",
            price = 6000,
        },
        ["cakechoc"] = {
            label = "Chocolate Cake",
            price = 5000,
        },
        ["crossan"] = {
            label = "Croissant",
            price = 5000,
        },
        ["cupcake"] = {
            label = "Cup Cake",
            price = 5000,
        },
        ["donut"] = {
            label = "Donut",
            price = 5000,
        },
        ["kalbas"] = {
            label = "Kalbas",
            price = 6000,
        },
    },]]
    ["kharchang"] = {
        ["caviar"] = {
            label = "Khaviar",
            price = 8000,
        },
        ["hamburgerkh"] = {
            label = "Hamburger Kharchangi",
            price = 5000,
        },
        ["chumbucket"] = {
            label = "Chumbucket",
            price = 6000,
        },
        ["sausagepa"] = {
            label = "Sausage Patricki",
            price = 5000,
        },
        ["friedshrimp"] = {
            label = "Meygoo Sokhari",
            price = 6000,
        },
        ["pizza"] = {
            label = "Pizza",
            price = 5000,
        },
        ["stronzo"] = {
            label = "Stronzo+",
            price = 10000,
        },
        ["pepsi"] = {
            label = "Pepsi",
            price = 4000,
        },
        ["cocacola"] = {
            label = "CocaCola",
            price = 4000,
        },
        ["fanta"] = {
            label = "Fanta",
            price = 4000,
        },
        ["dough"] = {
            label = "Dough Ab Ali",
            price = 4000,
        },
        ["water"] = {
            label = "Ab",
            price = 2000,
        },
        ["whiskey"] = {
            label = "Whiskey",
            price = 3000,
        },
        ["vodka"] = {
            label = "Vodka",
            price = 3000,
        },
    },
    ["artist"] = {
        ["2sib"] = {
            label = "Tanbacoo 2 Sib",
            price = 4000,
        },
        ["blueberry"] = {
            label = "Tanbacoo BlueBerry",
            price = 4000,
        },
        ["lemon"] = {
            label = "Tanbacoo Limoo",
            price = 4000,
        },
        ["porteghal"] = {
            label = "Tanbacoo Porteghal",
            price = 4000,
        },
        ["ember"] = {
            label = "Zoghal",
            price = 2000,
        },
        ["hookah"] = {
            label = "Ghelyion",
            price = 50000,
        },
        ["abporteghal"] = {
            label = "Ab Porteghal",
            price = 4000,
        },
        ["milkshake"] = {
            label = "Milkshake",
            price = 5000,
        },
        ["cigarett"] = {
            label = "Cigar Captain",
            price = 3000,
        },
        ["bastani"] = {
            label = "Bastani",
            price = 4000,
        },
        ["mohito"] = {
            label = "Mohito",
            price = 5000,
        },
        ["waffle"] = {
            label = "Waffle",
            price = 5000,
        },
    }
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

    while not ESX.GetPlayerData().job do 
        Citizen.Wait(10000)
    end

    local iu = {
        "prop_vend_snak_01",
    }

    exports['diamond_target']:AddTargetModel(iu, {
        options = {
            {
                icon = "fa-solid fa-shop",
                label = "خرید کردن",
                action = function(_)
                    if Objects[_] then
                        OpenMenu(Objects[_])
                    else
                        ESX.Alert("In Dastgah Mahsooli Baraye Forush Nadarad", "info")
                    end
                end,
            },
        },
        job = {"all"},
        distance = 1.5
    })
end)

---@diagnostic disable-next-line: missing-parameter
RegisterCommand("vending", function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            if created then return end
            local data = {}
            for k, v in pairs(Jobs) do
                table.insert(data, {label = v, value = k})
            end
            local input = lib.inputDialog("Add Vending Machine", {
                { 
                    type = 'select', 
                    label = "Select Job", 
                    options = data,
                    clearable = true, required = true 
                },
            })

            if not input or not input[1] then return end

            local name = input[1]

            --ESX.TriggerServerCallback("esx_vending:GetLockerOrderList", function(result)
                local list = {}
                local last = {}
                local info = {}

                --for k, v in pairs(result) do
                    for i, p in pairs(JobItems[name]) do
                --        if i == v.name then
                            table.insert(list, { type = 'checkbox', label = p.label..": "..ESX.Math.GroupDigits(p.price), checked = false })
                            table.insert(last, i)
                --        end
                    end
                --end

                if #list == 0 then return end

                local input = lib.inputDialog('Select Items', list)

                if not input then return end

                for k, v in pairs(input) do
                    if v then 
                        table.insert(info, last[k])
                    end
                end

                if #info == 0 then return end

                lib.showTextUI(table.concat(text_ui.help))

                local heading = 0
                local obj
                created = false

                lib.requestModel(object)

                Citizen.CreateThread(function()
                    while true do
                        local hit, coords, entity = RayCastGamePlayCamera(100.0)
                
                        if not created then
                            created = true
                            obj = CreateObject(object , coords.x, coords.y, coords.z, false, false, false)
                        end

                        if IsControlPressed(0, 172) then
                            local loc = GetEntityCoords(obj)
                            SetEntityCoords(obj, loc.x, loc.y, loc.z + 0.01)
                        end

                        if IsControlPressed(0, 173) then
                            local loc = GetEntityCoords(obj)
                            SetEntityCoords(obj, loc.x, loc.y, loc.z - 0.01)
                        end
                
                        if IsControlPressed(0, 175) then
                            heading += 1.5
                        end
                
                        if IsControlPressed(0, 174) then
                            heading -= 1.5
                        end

                        if IsControlPressed(0, 176) then
                            lib.hideTextUI()
                            local loc = GetEntityCoords(obj)
                            local heading = GetEntityHeading(obj)
                            TriggerServerEvent("esx_vending:AddVending", name, vector4(loc.x, loc.y, loc.z, heading), info)
                            created = false
                            DeleteEntity(obj)
                            obj = nil
                            break
                        end

                        local pedPos = GetEntityCoords(PlayerPedId())
                        local distance = #(coords - pedPos)
                        if distance >= 3.5 then
                            SetEntityCoords(obj, coords.x, coords.y, coords.z)
                        end

                        SetEntityHeading(obj, heading)

                        Citizen.Wait(3)
                    end
                end)
            --end, name)
        end
    end)
end)

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
    
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot(0)
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, cache.ped, 0))

	return b, c, e
end

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("esx_vending:updateJobs", function(data)
    JobData = data
    for k, v in pairs(Objects) do
        DeleteEntity(k)
    end
    for k, v in pairs(JobData) do
        for i, p in pairs(v) do
            local i = CreateObject(object , p.coords.x, p.coords.y, p.coords.z-0.9, false, false, false)
            FreezeEntityPosition(i, true)
            SetEntityHeading(i, p.coords.w)
            Objects[i] = {
                name = k,
                items = p.items
            }
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local coord = GetEntityCoords(PlayerPedId())
		local Pause = true
		for k, v in pairs(JobData) do
            for i, p in pairs(v) do
                if #(vector3(p.coords.x, p.coords.y, p.coords.z) - coord) <= 5.0 then
                    Pause = false
                    DrawText3D(p.coords.x, p.coords.y, p.coords.z+1.4, Sticker[k].." "..Jobs[k])
                end
            end
		end
		if Pause then 
            Citizen.Wait(1000)
            if open then
                ESX.UI.Menu.CloseAll()
                open = false
            end
        end
    end
end)

function OpenMenu(result)
    open = true
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback("esx_vending:GetLockerList", function(info) 
        local elements = {}
        for k, v in pairs(info) do
            for i, p in pairs(result.items) do
                if p == v.name then
                    if v.count > 0 then
                        table.insert(elements, {name = v.name, type = "slider", min = 1, max = v.count, label = v.label..": "..ESX.Math.GroupDigits(JobItems[result.name][v.name].price).."$ | Mojudi: "..v.count.."x", value = 1, count = v.count})
                    else
                        table.insert(elements, {label = v.label..": "..ESX.Math.GroupDigits(JobItems[result.name][v.name].price).."$ | Mojudi: "..v.count.."x", value = v.name, count = v.count})
                    end
                end
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mvendingnu',{
            title    = "Kharid Az "..Jobs[result.name],
            align    = 'center',
            elements = elements
        }, function(data, menu)
            local action = data.current
            if action.count > 0 then
                if action.value <= 10 then
                    menu.close()
                    TriggerServerEvent("esx_vending:buyItem", result.name, action.name, action.value)
                else
                    ESX.Alert("Dar Har Kharid Bishtar Az 10 Item Ghabel Kharidari Nist", "info")
                end
            else
                ESX.Alert("Mojudi In Item Be Payan Reside Ast", "info")
            end
        end, function(data, menu)
            menu.close()
        end)
    end, result.name)
end

function GetID()
    local coord = GetEntityCoords(PlayerPedId())
    local result = false
    for k, v in pairs(JobData) do
        for i, p in pairs(v) do
            if #(vector3(p.coords.x, p.coords.y, p.coords.z) - coord) <= 1.5 then
                result = {name = k, id = i}
                break
            end
        end
    end
    return result
end

RegisterCommand("delvending", function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            local near = GetID()
            if near then
                TriggerServerEvent("esx_vending:Delete", near)
            else
                ESX.Alert("Shoma Nazdik Hich Yakhchali Nistid", "info")
            end
        end
    end)
end)