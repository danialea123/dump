---@diagnostic disable: undefined-global
local CheckBasketThread
local Delay = false

function Thread()
    for i=1, #Config.Locations do
        local shopCoord = Config.Locations[i]["blip"]
        for j=1, #Config.Locations[i]["shelfs"] do
            local pos = Config.Locations[i]["shelfs"][j]
            local Point = RegisterPoint(vector3(pos["x"], pos["y"], pos["z"]), 15, true)
            local Key
            local Interact
            Point.set('InArea', function ()
                if not Config.Locations[i].Disable then
                    Marker(pos)
                end
            end)
            Point.set('InAreaOnce', function ()
                if not Config.Locations[i].Disable then
                    Interact = RegisterPoint(vector3(pos["x"], pos["y"], pos["z"]), 0.40, true)
                    Interact.set('InArea', function ()
                        if not Config.Locations[i].Disable then
                            local text = "[E] " .. Config.Locales[pos["value"]]
                            DrawText3D(pos["x"], pos["y"], pos["z"], text)
                        end
                    end)
                    Interact.set('InAreaOnce', function ()
                        Key = UnregisterKey(Key)
                        Key = RegisterKey('E', function ()
                            if Key then
                                Key = UnregisterKey(Key)
                                if not Config.Locations[i].Disable then
                                    OpenAction(pos, Config.Items[pos["value"]], Config.Locales[pos["value"]], shopCoord)
                                end
                            end
                        end)
                    end, function ()
                        Key = UnregisterKey(Key)
                        ESX.UI.Menu.CloseAll()
                    end)
                else
                    if not Delay then
                        Delay = true
                        ESX.Alert('Az in shop Serghat Shode Va Mahsoli baraye Forosh Nadarad, Lotfan Inja ro Tark konid!', "info")
                        SetTimeout(5000, function()
                            Delay = false
                        end)
                    end
                end
            end, function ()
                if Interact then
                    Interact = Interact.remove()
                end
                Key = UnregisterKey(Key)
            end)
        end
    end
end

Thread()

OpenAction = function(action, shelf, text, shopCoord)
    if action["value"] == "checkout" then
        if payAmount > 0 and #Basket then
            CashRegister(text)
        else
            pNotify("Shoma Chizi Dar Sabad Khod Nadarid!", 'error', 1500)
        end
    else
        ShelfMenu(text, shelf, shopCoord)
    end
end

--[[ Cash register menu ]]--
CashRegister = function(titel)
        local elements = {
            {label = '<span style="color:lightgreen; border-bottom: 1px solid lightgreen;">Tayid Kharid</span>', value = "yes"},
            {label = 'Mablagh ghabel pardakht: <span style="color:green">$' .. payAmount ..'</span>'},
        }

        for i=1, #Basket do
            local item = Basket[i]
            table.insert(elements, {
                label = '<span style="color:red">*</span> ' .. item["label"] .. ': ' .. item["amount"] .. ' Adad',
                value = item["value"],
            })
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'penis',
            {
                title    = "Shop - " .. titel,
                align    = 'center',
                elements = elements
            },
            function(data, menu)
            
                if data.current.value == "yes" then
                    menu.close()
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'penis2',
                        {
                            title    = "Entekhab Pardakht",
                            align    = 'center',
                            elements = {
                                {label = "Pardakht naghdi", value = "cash"},
                                {label = "Pardakht ba cart banki", value = "bank"},
                            },
                        },
                        function(data2, menu2)
                            ESX.TriggerServerCallback('99kr-shops:CheckMoney', function(hasMoney)
                                if hasMoney then
                                    TriggerServerEvent('99kr-shops:Cashier', payAmount, Basket, data2.current["value"])
                                    payAmount = 0
                                    Basket = {}
                                    menu2.close()
                                else
                                    pNotify("Shoma pool kafi nadarid!", 'error', 1500)
                                end
                            end, payAmount, data2.current["value"])
                        end,
                    function(data2, menu2)
                        menu2.close()
                    end)
                end
            end,
        function(data, menu)
            menu.close()
    end) 
end

--[[ Open shelf menu ]]--
ShelfMenu = function(titel, shelf, shopCoord)
    local elements = {}

    for i=1, #shelf do
        local shelf = shelf[i]
        table.insert(elements, {
            realLabel = shelf["label"],
            label = shelf["label"] .. ' (<span style="color:green">$' .. shelf["price"] .. '</span>)',
            item = shelf["item"],
            price = shelf["price"],
            value = 1, type = 'slider', min = 1, max = 100,
        })
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'penis',
        {
            title    = "Shop - " .. titel,
            align    = 'center',
            elements = elements
        },
        function(data, menu)
        
            local alreadyHave, basketItem = CheckBasketItem(data.current.item)
            if alreadyHave then
                basketItem.amount = basketItem["amount"] + data.current.value
            else
                table.insert(Basket, {
                    label = data.current["realLabel"],
                    value = data.current["item"],
                    amount = data.current.value,
                    price = data.current["price"]
                })
            end
            payAmount = payAmount + data.current["price"] * data.current.value
            if not CheckBasketThread and payAmount > 0 then
                CheckBasketThread = RegisterPoint(shopCoord, 12, true)
                CheckBasketThread.set('InAreaOnce', function ()
                    BasKey = RegisterKey('L', function ()
                        OpenBasket()
                    end)
                end, function ()
                    if #Basket > 0 then
                        pNotify("Shoma maghaze ra tark kardid, Sabad shoma khali shod!", "error", 2500)
                        payAmount = 0
                        Basket = {}
                    end
                    BasKey = UnregisterKey(BasKey)
                    CheckBasketThread = CheckBasketThread.remove()
                end)
            end
            pNotify("Shoma " .. data.current.value .. " Adad " .. data.current["realLabel"] .. " dar sabad kharid khod gozashtid", 'alert', 1500)           
        end,
    function(data, menu)
        menu.close()
    end)
end

--[[ Check if item already in basket ]]--
CheckBasketItem = function(item)
    for i=1, #Basket do
        if item == Basket[i]["value"] then
            return true, Basket[i]
        end
    end
    return false, nil
end

-- [[ Opens basket menu ]]--
OpenBasket = function()
    if payAmount > 0 and #Basket then
        local elements = {
            {label = 'Mablagh Pardakhti: <span style="color:green">$' .. payAmount},
        }
        for i=1, #Basket do
            local item = Basket[i]
            table.insert(elements, {
                label = '<span style="color:red">*</span> ' .. item["label"] .. ': ' .. item["amount"] .. ' Adad (<span style="color:green">$' .. item["price"] * item["amount"] .. '</span>)',
                value = "item_menu",
                index = i
            })
        end
        table.insert(elements, {label = '<span style="color:red">Khali kardan sabad', value = "empty"})

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'basket',
            {
                title    = "Sabad Kharid",
                align    = 'center',
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'empty' then
                    Basket = {}
                    payAmount = 0
                    if CheckBasketThread then
                        BasKey = UnregisterKey(BasKey)
                        CheckBasketThread = CheckBasketThread.remove()
                    end
                    menu.close()
                    pNotify("Sabad kharid shoma be tor kamel khali shod.", "error", 2500)
                end
                if data.current.value == "item_menu" then
                    menu.close()
                    local index = data.current.index
                    local shopItem = Basket[index]

                    -- [[ Opens detailed (kinda) menu about item ]] --
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'basket_detailedmenu',
                        {
                            title    = "Sabad Kharid - " .. shopItem["label"] .. " - " .. shopItem["amount"] .. "Adad",
                            align    = 'center',
                            elements = {
                                {label = shopItem["label"] .. " - $" .. shopItem["price"] * shopItem["amount"]},
                                {label = '<span style="color:red">Hazf Kala</span>', value = "deleteItem"},
                            },
                        },
                        function(data2, menu2)
                            if data2.current["value"] == "deleteItem" then
                                pNotify("Shoma " .. Basket[index]["amount"] .." Adad ".. Basket[index]["label"] .. " az sabad kharid khod hazf kardid.", "alert", 2500)
                                payAmount = payAmount - (Basket[index]["amount"] * Basket[index]["price"])
                                if payAmount <= 0 then
                                    if CheckBasketThread then
                                        BasKey = UnregisterKey(BasKey)
                                        CheckBasketThread = CheckBasketThread.remove()
                                    end
                                end
                                table.remove(Basket, index)
                                OpenBasket()
                            end
                        end,
                        function(data2, menu2)
                            menu2.close()
                            OpenBasket()
                        end
                    )
                    
                    -- [[ Back to normal basket menu ]] --
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    else
        ESX.UI.Menu.CloseAll()
    end
end
