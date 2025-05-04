NCHub = {}

NCHub.Framework = "esx" -- qb / oldqb | qb = export system | oldqb = triggerevent system
NCHub.Mysql = "oxmysql" -- Check fxmanifest.lua when you change it! | ghmattimysql / oxmysql / mysql-async
NCHub.OpenCommand = "TMP"
NCHub.DefaultGarage = "altaparking" -- purchased vehicles will be sent to this garage
NCHub.RewardCoin = 25
NCHub.NeededPlayTime = 30 -- Minutes

NCHub.Language = {
    title1 = "Diamond",
    title2 = "Playtime",
    coin = "COIN",
    nextReward = "FOR THE NEXT COIN REWARD",
    exit = "EXIT",
    reward = "REWARD :",
    title3 = "TOP",
    title4 = "PLAYERS",
    title5 = "PLAYTIME",
    title6 = "SHOP",
    cancel = "CANCEL",
    buy = "BUY",
    accept = "ACCEPT",
    realCurrency = "$",
    nextPage = "NEXT PAGE",
    previousPage = "PRIVIOUS PAGE",
    succesfully = "SUCCESSFULLY",
    purchased = "PURCHASED",
    invalidCode = "INVALID CODE!",
    thxForPurch = "Thanks for purchasing!",
    top = "TOP",
    youDntHvEngMoney = "YOU DONT HAVE ENOUGH MONEY!",
    text6 = "6",
}

NCHub.Categories = {
    { category = "items", icon = "fa-solid fa-cookie-bite", items = {} }, -- do not touch items section..
    { category = "weapons", icon = "fa-solid fa-gun", items = {} }, -- do not touch items section..
    { category = "vehicles", icon = "fa-solid fa-car", items = {} }, -- do not touch items section..
}

-- itemType : vehicle, weapon, item, money
NCHub.Items = {
    { id = 1, itemName = "weapon_pistol", label = "PISTOL", price = 1200, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_pistol.png" },
    { id = 2, itemName = "weapon_smg", label = "SMG", price = 1400, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_smg.png" },
    { id = 3, itemName = "weapon_assaultsmg", label = "Assault SMG", price = 1750, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_assaultsmg.png" },
    { id = 4, itemName = "WEAPON_SNSPISTOL_MK2", label = "SNS Pistol MK2", price = 1100, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/WEAPON_SNSPISTOL_MK2.png" },
    { id = 5, itemName = "weapon_heavypistol", label = "Heavy Pistol", price = 1050, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_heavypistol.png" },
    { id = 6, itemName = "weapon_golfclub", label = "Golf Club", price = 400, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_golfclub.png" },
    { id = 7, itemName = "weapon_snspistol", label = "SNS Pistol", price = 550, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_snspistol.png" },
    { id = 7, itemName = "weapon_battleaxe", label = "Battle Axe", price = 400, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_battleaxe.png" },
    { id = 7, itemName = "WEAPON_ADVANCEDRIFLE", label = "Advanced Rifle", price = 1650, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/WEAPON_ADVANCEDRIFLE.png" },
    { id = 7, itemName = "weapon_hammer", label = "Hammer", price = 400, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/weapon_hammer.png" },
    { id = 7, itemName = "WEAPON_DAGGER", label = "Dagger", price = 400, count = 1, itemType = "weapon", category = "weapons", image = "http://gd.diamondrp.ir/imgs/WEAPON_DAGGER.png" },

    { id = 8, itemName = "m_chain_1_221_0", label = "Tabar Ghermez (Male)", price = 10000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/m_chain_1_221_0.png" },
    { id = 8, itemName = "f_chain_1_205_0", label = "Tabar Ghermez (Female)", price = 10000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/f_chain_1_205_0.png" },
    { id = 8, itemName = "f_torso_1_688_2", label = "Lebas Tarhdar (Female)", price = 25000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/f_torso_1_688_2.png" },
    { id = 8, itemName = "m_torso_1_645_5", label = "Lebas Tarhdar (Male)", price = 25000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/m_torso_1_645_5.png" },
    { id = 8, itemName = "notebook", label = "Daftarche", price = 35, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/notebook.png" },
    --{ id = 8, itemName = "rc", label = "Robbery Card", price = 5000, count = 50, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/rc.png" },
    { id = 9, itemName = "marijuana", label = "Marijuana", price = 55, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/marijuana.png" },
    { id = 10, itemName = "armour", label = "Armor 50", price = 100, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/armour.png" },
    { id = 11, itemName = "lockpick", label = "LockPick", price = 150, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/lockpick.png" },
    { id = 12, itemName = "fixkit", label = "Fix Kit", price = 200, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/fixkit.png" },
    { id = 13, itemName = "skate", label = "SkateBoard", price = 800, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/skateboard.png" },
    { id = 14, itemName = "gamepad", label = "GamePad", price = 2000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/gamepad.png" },
    --{ id = 15, itemName = "contract", label = "Ghol Name", price = 450, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/contract.png" },
    { id = 16, itemName = "radio", label = "Radio", price = 200, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/radio.png" },
    { id = 17, itemName = "highrim", label = "Laastik", price = 240, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/highrim.png" },
    { id = 19, itemName = "bread", label = "Noon", price = 50, count = 5, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/bread.png" },
    { id = 20, itemName = "water", label = "Water", price = 50, count = 5, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/water.png" },
    { id = 21, itemName = "wine", label = "Sharab", price = 100, count = 5, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/wine.png" },
    { id = 22, itemName = "dcoin", label = "DCoin", price = 1500, count = 25, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/25.png" },
    { id = 23, itemName = "dogball", label = "Dog Ball", price = 100, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/dogball.png" },
    { id = 24, itemName = "dogrope", label = "Dog Rope", price = 100, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/dogrope.png" },
    { id = 25, itemName = "gpspanel", label = "GPS Panel", price = 500, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/gpspanel.png" },
    { id = 26, itemName = "cargps", label = "Vehicle GPS", price = 50, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/cargps.png" },
    { id = 27, itemName = "gpsdetector", label = "GPS Detector", price = 15, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/gpsdetector.png" },
    { id = 27, itemName = "adr", label = "Adrenaline", price = 1000, count = 1, itemType = "item", category = "items", image = "http://gd.diamondrp.ir/imgs/adr.png" },
    
    { id = 28, itemName = "buccaneer2", label = "buccaneer2", price = 3500, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/buccaneer2.png" },
    { id = 29, itemName = "sanctus", label = "sanctus", price = 1200, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/sanctus.png" },
    { id = 30, itemName = "virgo", label = "virgo", price = 2300, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/virgo.png" },
    { id = 32, itemName = "tahoma", label = "tahoma", price = 3700, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/tahoma.png" },
    { id = 34, itemName = "taipan", label = "taipan", price = 9000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/taipan.png" },
    { id = 35, itemName = "blazer4", label = "blazer4", price = 4200, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/blazer4.png" },
    { id = 36, itemName = "enduro", label = "enduro", price = 1000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/enduro.png" },
    { id = 37, itemName = "cruiser", label = "cruiser", price = 700, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/cruiser.png" },
    { id = 38, itemName = "banshee", label = "banshee", price = 4200, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/banshee.png" },
    { id = 39, itemName = "bison", label = "bison", price = 3000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/bison.png" },
    { id = 40, itemName = "astron", label = "astron", price = 6000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/astron.png" },
    { id = 41, itemName = "diablous", label = "diablous", price = 1900, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/diablous.png" },
    { id = 42, itemName = "turismor", label = "turismor", price = 10000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/turismor.png" },
    { id = 42, itemName = "gauntlet4", label = "gauntlet4", price = 7000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/gauntlet4.png" },
    { id = 42, itemName = "krieger", label = "krieger", price = 14000, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/krieger.png" },
    { id = 42, itemName = "rocoto", label = "rocoto", price = 3200, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/rocoto.png" },
    { id = 42, itemName = "buffalo", label = "buffalo", price = 4700, count = 1, itemType = "vehicle", category = "vehicles", image = "https://media.diamondrp.ir/garage/buffalo.png" },

    { id = 42, itemName = "tropic", label = "tropic", price = 3500, count = 1, itemType = "boat", category = "vehicles", image = "https://media.diamondrp.ir/garage/tropic.png" },
    { id = 42, itemName = "seashark", label = "seashark", price = 1200, count = 1, itemType = "boat", category = "vehicles", image = "https://media.diamondrp.ir/garage/seashark.png" },
    { id = 42, itemName = "jetmax", label = "jetmax", price = 5000, count = 1, itemType = "boat", category = "vehicles", image = "https://media.diamondrp.ir/garage/jetmax.png" },
}

NCHub.List = {}
for k, v in pairs(NCHub.Items) do
    NCHub.List[v.itemName] = v.price
end

for k, v in pairs(NCHub.Items) do
    NCHub.Items[k].id = k
end

NCHub.CoinList = {
    { coinCount = 300, realPrice = 30, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
    { coinCount = 100, realPrice = 50, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
    { coinCount = 700, realPrice = 70, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
    { coinCount = 900, realPrice = 90, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
    { coinCount = 1200, realPrice = 120, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
    { coinCount = 1500, realPrice = 150, link = "https://www.yourTebexLink.com/crediAmountPage.html", image = "http://gd.diamondrp.ir/imgs/coin.png" },
}