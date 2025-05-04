---@diagnostic disable: undefined-field
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local Sellable = {
	[GetHashKey('mp_m_freemode_01')] = {
		["tshirt_1"] = {
			[213] = true,
			[225] = true,
			[245] = true,
		},
		["bags_1"] = {
			[124] = true,
			[125] = true,
		},
		["bproof_1"] = {
			[72] = true,
		},
		["chain_1"] = {
			[167] = true,
			[197] = true,
			[202] = true,
			[203] = true,
			[214] = true,
		},
	},
	[GetHashKey('mp_f_freemode_01')] = {
		["tshirt_1"] = {
			[325] = true,
		},
		["bags_1"] = {
			[151] = true,
		},
		["bproof_1"] = {
			[59] = true,
			[114]= true,
		},
		["chain_1"] = {
			[199] = true,
			[202] = true,
			[203] = true,
		},
	},
}

local Naked = {
    [GetHashKey('mp_m_freemode_01')] = {
		shoes_1 = 34,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 0,
        ears_1 = -1,
    },
    [GetHashKey('mp_f_freemode_01')] = {
		shoes_1 = 35,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 5,
        ears_1 = -1,
    }
}

RegisterNetEvent("codem-apperance:OpenWardrobe")
AddEventHandler("codem-apperance:OpenWardrobe", function()
    OpenSavedClothes()
    --OpenMenu("wardrobe")
end)

RegisterNetEvent("qb-clothing:client:openOutfitMenu")
AddEventHandler("qb-clothing:client:openOutfitMenu", function()
    --OpenMenu("wardrobe")
end)

function OpenSavedClothes()
    ESX.TriggerServerCallback("appearence:getData", function(result) 
        local elements = {
            {label = "Zakhire Kardan Lebas Fe`li", value = "save"},
            {label = "=========List Lebas Haye Save Shode==========", value = nil},
        }
        for k, v in pairs(result) do
            table.insert(elements, {label = "Lebase "..v.name, id = v.id, skin = v.skin, value = v.skin})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clothe_ask_question', {
            title = "Entekhab Lebas",
            align = 'center',
            elements = elements
        }, function(data, menu)
            local action = data.current.value
            if action then
                if action == "save" then
                    CheckNaked(function(is)
                        if not is then
                            menu.close()
                            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
                                title = 'Esm Lebas',
                            }, function(data1, menu1)
                                if not ESX.IsPlateValid(data1.value) then return ESX.ShowNotification("شما فقط از اعداد و حروف انگلیسی میتوانید استفاده بکنید") end
                                menu1.close()
                                local save = {}
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    for k, v in pairs(skin) do
                                        if k ~= 'sex' and k ~= 'mom' and k ~= 'dad' and k ~= 'skin_color' and k ~= 'skin_opacity' and k ~= 'face_md_weight' and k ~= 'skin_md_weight' and k ~=
                                        'nose_1' and k ~= 'nose_2' and k ~= 'nose_3' and k ~= 'nose_4' and k ~= 'nose_5' and k ~= 'nose_6' and k ~=
                                        'cheeks_1' and k ~= 'cheeks_2' and k ~= 'cheeks_3' and k ~= 'lip_thickness' and k ~= 'jaw_1' and k ~=
                                        'jaw_2' and k ~= 'chin_1' and k ~= 'chin_2' and k ~= 'chin_3' and k ~= 'chin_4' and k ~=
                                        'neck_thickness' and k ~= 'age_1' and k ~= 'age_2' and k ~= 'eye_color' and k ~= 'eye_squint' and k ~=
                                        'beard_1' and k ~= 'beard_2' and k ~= 'beard_3' and k ~= 'beard_4' and k ~= 'hair_1' and k ~= 'hair_2' and
                                        k ~= 'hair_color_1' and k ~= 'hair_color_2' and k ~= 'eyebrows_1' and k ~= 'eyebrows_2' and k ~=
                                        'eyebrows_3' and k ~= 'eyebrows_4' and k ~= 'eyebrows_5' and k ~= 'eyebrows_6' and k ~= 'makeup_1' and k ~=
                                        'makeup_2' and k ~= 'makeup_3' and k ~= 'makeup_4' and k ~= 'lipstick_1' and k ~= 'lipstick_2' and k ~=
                                        'lipstick_3' and k ~= 'lipstick_4' and k ~= 'blemishes_1' and k ~= 'blemishes_2' and k ~= 'blemishes_3' and
                                        k ~= 'blush_1' and k ~= 'blush_2' and k ~= 'blush_3' and k ~= 'complexion_1' and k ~= 'complexion_2' and
                                        k ~= 'sun_1' and k ~= 'sun_2' and k ~= 'moles_1' and k ~= 'moles_2' and k ~= 'chest_1' and k ~=
                                        'chest_2' and k ~= 'chest_3' and k ~= 'bodyb_1' and k ~= 'bodyb_2' and k ~= 'bodyb_3' and k ~= 'bodyb_4' then
                                            if Sellable[GetEntityModel(PlayerPedId())][k] and Sellable[GetEntityModel(PlayerPedId())][k][v] then 
                                                save[k] = Naked[GetEntityModel(PlayerPedId())][k]
                                            else
                                                save[k] = v
                                            end
                                        end
                                    end
                                    ESX.TriggerServerCallback("clothes:addtohouse", function()
                                        OpenSavedClothes()
                                    end, save, data1.value)
                                    GetNaked2()
                                    Citizen.Wait(500)
                                    TriggerEvent('skinchanger:getSkin', function(sskin)
                                        TriggerServerEvent('esx_skin:save', sskin)
                                    end)
                                end)
                            end)
                        else
                            ESX.Alert("Shoma Nemitavanid Hengami Ke Lebasi Nadarid, Chizi Save Konid", "info")
                        end
                    end)
                else
                    CheckNaked(function(is)
                        if is then
                            menu.close()
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerEvent('skinchanger:loadClothes', skin, json.decode(data.current.skin))
                                Citizen.Wait(500)
                                TriggerEvent('skinchanger:getSkin', function(sskin)
                                    TriggerServerEvent('esx_skin:save', sskin)
                                end)
                            end)
                            ESX.TriggerServerCallback("appearence:deleteData", function()
                                OpenSavedClothes()
                            end, data.current.id)
                        else
                            ESX.Alert("Baraye Pooshidan Lebas Haye Save Shode, Shoma Ebteda Bayad Lebas Haye Fe`li Khod Ra Dar Biarid Ya Save Konid", "info")
                        end
                    end)
                end
            end
        end, function(data,menu)
            menu.close()
        end)
    end)
end

function CheckNaked(cb)
    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
        local isNaked = true
        local cl = {
            shoes_1 = 34,
            pants_1 = 14,
            torso_1 = 15,
            arms = 15,
            tshirt_1 = 15,
            mask_1 = 0,
            helmet_1 = -1,
            bproof_1 = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1 = 0,
            bags_1 = 0,
            chain_1 = 0,
            glasses_1 = 0,
            ears_1 = -1,
        }
        TriggerEvent('skinchanger:getSkin', function(skin)
            for k, v in pairs(cl) do 
                if skin[k] ~= v then 
                    isNaked = false
                    break
                end
            end
            cb(isNaked)
        end)
    else
        local isNaked = true
        local cl = {
            shoes_1 = 35,
            pants_1 = 14,
            torso_1 = 15,
            arms = 15,
            tshirt_1 = 15,
            mask_1 = 0,
            helmet_1 = -1,
            bproof_1 = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1 = 0,
            bags_1 = 0,
            chain_1 = 0,
            glasses_1 = 5,
            ears_1 = -1,
        }
        TriggerEvent('skinchanger:getSkin', function(skin)
            for k, v in pairs(cl) do 
                if skin[k] ~= v then 
                    isNaked = false
                    break
                end
            end
            cb(isNaked)
        end)
    end
end

function GetNaked2()
    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
        local list = {
            shoes_1 = 34,
            pants_1 = 14,
            torso_1 = 15,
            arms = 15,
            tshirt_1 = 15,
            mask_1 = 0,
            helmet_1 = -1,
            bproof_1 = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1 = 0,
            bags_1 = 0,
            chain_1 = 0,
            glasses_1 = 0,
            ears_1 = -1,
        }
        for k, v in pairs(list) do
            local name1 = k
            local name2 = string.gsub(name1, "_1", "_2")
            if name2 == "arms" then
                name2 = "arms_2"
            end
            TriggerEvent("skinchanger:change", name1, v, function()
                Citizen.Wait(10)
                TriggerEvent("skinchanger:change", name2, 0, function()

                end)
            end)
        end
    else
        local list = {
            shoes_1 = 35,
            pants_1 = 14,
            torso_1 = 15,
            arms = 15,
            tshirt_1 = 15,
            mask_1 = 0,
            helmet_1 = -1,
            bproof_1 = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1 = 0,
            bags_1 = 0,
            chain_1 = 0,
            glasses_1 = 5,
            ears_1 = -1,
        }
        for k, v in pairs(list) do
            local name1 = k
            local name2 = string.gsub(name1, "_1", "_2")
            if name2 == "arms" then
                name2 = "arms_2"
            end
            TriggerEvent("skinchanger:change", name1, v, function()
                Citizen.Wait(10)
                TriggerEvent("skinchanger:change", name2, 0, function()

                end)
            end)
        end
    end
end