Config = {

OpenKey = '',
OpenCommand = 'credits',

UsingLimitSystem = false,

DefaultCategory = 'vehicles',
ShopCategories = {
	['vehicles'] = 'VEHICLES',
},

Shop = {
    ['viper'] = {type = 'car', model = 'viper', price = 1500, category = 'vehicles'},
    ['skyline'] = {type = 'car', model = 'skyline', price = 1400, category = 'vehicles'},
    ['z4'] = {type = 'car', model = 'z4', price = 1300, category = 'vehicles'},
    ['fgt'] = {type = 'car', model = 'fgt', price = 1700, category = 'vehicles'},
    ['q820'] = {type = 'car', model = 'q820', price = 2200, category = 'vehicles'},
    ['elegy'] = {type = 'car', model = 'elegy', price = 500, category = 'vehicles'},
    ['sultanrs'] = {type = 'car', model = 'sultanrs', price = 350, category = 'vehicles'},
    ---
    ['pride'] = {type = 'car', model = 'pride', price = 1400, category = 'vehicles'},
    ['peykan'] = {type = 'car', model = 'peykan', price = 3700, category = 'vehicles'},
    ['x6m'] = {type = 'car', model = 'x6m', price = 2500, category = 'vehicles'},
    ['amggtr'] = {type = 'car', model = 'amggtr', price = 2700, category = 'vehicles'},
    ['svjtt'] = {type = 'car', model = 'svjtt', price = 2800, category = 'vehicles'},
    ['pika01'] = {type = 'car', model = 'pika01', price = 1800, category = 'vehicles'},
    ['160montada'] = {type = 'car', model = '160montada', price = 1300, category = 'vehicles'},
    ['bmwm4'] = {type = 'car', model = 'bmwm4', price = 2400, category = 'vehicles'},
    ['4444'] = {type = 'car', model = '4444', price = 2200, category = 'vehicles'},
    ['nh2r'] = {type = 'car', model = 'nh2r', price = 1400, category = 'vehicles'},
    ['foxshelby'] = {type = 'car', model = 'foxshelby', price = 2000, category = 'vehicles'},
    ['p207'] = {type = 'car', model = 'p207', price = 1500, category = 'vehicles'},
    ['h2carb'] = {type = 'car', model = 'h2carb', price = 1900, category = 'vehicles'},
    ['s1000rr'] = {type = 'car', model = 's1000rr', price = 1400, category = 'vehicles'},
},

Tasks = {
    [1] = {reward = 8, type='FishingJob', value=100, description = ' Anjam Dadan Job Mahigiri'},
    [2] = {reward = 9, type='MinerJob', value=100, description = ' Anjam Dadan Job Minery'},
    [3] = {reward = 7, type='LumberjackJob', value=100, description = ' Anjam Dadan Job Najari(ChoobBory)'},
    [4] = {reward = 10, type='NaftKeshJob', value=100, description = ' Anjam Dadan Job Naftkesh'},
    [5] = {reward = 13, type='Deliveryjob', value=100, description = ' Anjdam Dadan Job Delivery'},
    [6] = {reward = 11, type='GhasabJob', value=100, description = ' Anjam Dadan Job Ghasab'},
    [7] = {reward = 12, type='HunterJob', value=100, description = ' Anjam Dadan Job Shekarchi'},
    [8] = {reward = 8, type='WineJob', value=100, description = ' Anjam Dadan Job Sharab Sazi'},
    [9] = {reward = 10, type='SellItemMarket', value=100, description = ' Forush Yek Item Dar MarketPlace'},
    [10] = {reward = 12, type='BuyItemMarket', value=100, description = ' Kharid Yek Item Az MarketPlace'},
    [11] = {reward = 5, type='SkyDiving', value=100, description = ' Anjam Dadan SkyDiving'},
    [12] = {reward = 9, type='PullPet', value=100, description = ' Gardesh Heyvan Khanegi Dar Shahr'},
    [13] = {reward = 7, type='Planting', value=100, description = ' Kasht Yeki Az Giah Haye (Toot Farangi, Dragon Fruit, Gharch)'},
    [14] = {reward = 6, type='RentVehicle', value=100, description = ' Rent Kardan Yek Mashin'},
    [15] = {reward = 12, type='sellDrugDealer', value=100, description = ' Forush Item Dar DrugDealer'},
    [16] = {reward = 8, type='otherPlanting', value=100, description = ' Kasht Giah Dar Makan Haye Kasht Giah'},
    [17] = {reward = 11, type='DriveBoat', value=100, description = ' Ghayghrani Dar Sahel'},
    [18] = {reward = 6, type='tattoo', value=100, description = ' Zadan Khalkoobi Rooye Poost Dar Tattoo Shop'},
    [19] = {reward = 12, type='Swimming', value=100, description = ' Shena Kardan Dar Darya Ya Estakhr'},
    [20] = {reward = 8, type='chop', value=100, description = ' Chop Kardan Yek Mashin Dar Chop Shop'},
    [21] = {reward = 11, type='Cinema', value=100, description = ' Raftan Be Cinema Va Tamashaye Film'},
    [22] = {reward = 10, type='CarDealer', value=100, description = ' Kharid Yeki Az Mashin Haye Mojud Dar Cardealer (Diamond CarDealer Ya Special CarDealer)'},
    [23] = {reward = 9, type='UsingItems', value=100, description = ' Khordan Mive Haye (Toot Farangi, Dragon Fruit, Ghaarch)'},
    [24] = {reward = 12, type='FlyLicense', value=100, description = ' Gereftan Govahiname Khalabani'},
    [25] = {reward = 9, type='Ghelion', value=100, description = ' Keshidan Ghelion Dar Cafe Artist'},
},

NewTasks = {
    [1] = {reward = 6, type='GetDriverLicense', value=100, description = ' Gereftan Govahiname Ranandegi (Anjam Dadan Ayin Name Va Azmoon Amali)'},
    [2] = {reward = 8, type='BuyClothes', value=100, description = ' Raftan Be Yeki Az Lebas Forushi Ha Va Kharid Yek Dast Lebas'},
    [3] = {reward = 6, type='BuyApartment', value=100, description = ' Kharid Yek Vahed Apartemani Dar Shahr'},
    [4] = {reward = 12, type='HireInOrgan', value=100, description = ' Estekhdam Shodan Dar Yeki Az Job Haye Dolati'},
    [5] = {reward = 13, type='GetGunLicense', value=100, description = ' Gereftan Mojavez Aslahe Az Yeki Az GunShop Ha'},
},

GangTasks = {
    [1] = {reward = 8, type='GetDrug', value=100, description = ' Jaam Kardan Ephedra'},
    [2] = {reward = 10, type='ConvertDrug', value=100, description = ' Tabdil Tokhm Cocaine Be Cocaine'},
    [3] = {reward = 9, type='gangPlant', value=100, description = ' Kasht Yeki Az Mavad Haye (Teryak Ya Marijuana)'},
    [4] = {reward = 8, type='ShopRobbery', value=100, description = ' Start Kardan Yeki Az Shop Robbery Ha'},
    [5] = {reward = 9, type='PaletoRobbery', value=100, description = ' Start Kardan Robbery Yeki Az Fleeca Bank Ha'},
    [6] = {reward = 10, type='CraftAslahe', value=100, description = ' Craft Kardan Yek Aslahe Dar Base Gang'},
    [7] = {reward = 8, type='SellJewel', value=100, description = ' Forush Javaher Dar Javaheri'},
    [8] = {reward = 11, type='GharbalMiner', value=100, description = ' Gharbal Kardan Sang Haye Jaam Avari Shode Dar Job Minery'},
},

policeTasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat Kharej Kardan Mashin Shahrvandan Az Impound'},
    [4] = {reward = 8, type='ImpoundJob', value=100, description = ' Impound Kardan Mashin Haye Bi Sarneshin Va Vel Shode'},
    [5] = {reward = 9, type='Tablet', value=100, description = ' Sakht Parvande Baraye Mojrem Dar Tablet'},
    [6] = {reward = 10, type='Security', value=100, description = ' Mohafezat Az Location Haye Moshakas Shode Be Manzoor Barresi Amniat'},
},

sheriffTasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat Kharej Kardan Mashin Shahrvandan Az Impound'},
    [4] = {reward = 8, type='ImpoundJob', value=100, description = ' Impound Kardan Mashin Haye Bi Sarneshin Va Vel Shode'},
    [5] = {reward = 9, type='Tablet', value=100, description = ' Sakht Parvande Baraye Mojrem Dar Tablet'},
    [6] = {reward = 10, type='Security', value=100, description = ' Mohafezat Az Location Haye Moshakas Shode Be Manzoor Barresi Amniat'},
},

forcesTasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat PasokhGooyi Be Shahrvandan'},
    [4] = {reward = 8, type='ImpoundJob', value=100, description = ' Impound Kardan Mashin Haye Bi Sarneshin Va Vel Shode'},
    [5] = {reward = 9, type='Tablet', value=100, description = ' Sakht Parvande Baraye Mojrem Dar Tablet'},
    [6] = {reward = 10, type='Security', value=100, description = ' Mohafezat Az Location Haye Moshakas Shode Be Manzoor Barresi Amniat'},
},

justiceTasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat PasokhGooyi Be Shahrvandan'},
},

fbiTasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 10, type='Security', value=100, description = ' Mohafezat Az Location Haye Moshakas Shode Be Manzoor Barresi Amniat'},
},

medictasks =  {
    [1] = {reward = 8, type='Revive', value=100, description = ' Ghabool Mogheiat Va Darman Kardan Majrooh Zakhmi Shode'}, 
    [2] = {reward = 6, type='Bandage', value=100, description = ' Darman Kardan Majroohin Dar Otagh Darman Bimarestan'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat PasokhGooyi Be Bimaran'},
    [4] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [5] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
},

ambulancetasks =  {
    [1] = {reward = 8, type='Revive', value=100, description = ' Ghabool Mogheiat Va Darman Kardan Majrooh Zakhmi Shode'}, 
    [2] = {reward = 6, type='Bandage', value=100, description = ' Darman Kardan Majroohin Dar Otagh Darman Bimarestan'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat PasokhGooyi Be Bimaran'},
    [4] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [5] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
},


taxitasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 9, type='NPC', value=100, description = ' Resandan 4 NPC Be Maghsad Ba Jobe Dakheli'},
    [4] = {reward = 7, type='NPC2', value=100, description = ' Resandan 2 NPC Be Maghsad Ba Jobe Dakheli'},
},

weazelTask = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    [3] = {reward = 11, type='Reception', value=100, description = ' Istadan Dar Reception Jahat PasokhGooyi Be Shahrvandan'},
    [4] = {reward = 12, type='News', value=100, description = ' Estefade Az /news Va Enteshar Khabar Haye Jadid'},
    [5] = {reward = 12, type='Camera', value=100, description = ' Estefade Az Doorbin FilmBardari Ya Microhpone Baraye Tahiye Kardan Gozaresh'},
},

adminTask = {
    [1] = {reward = 15, type='report', value=100, description = ' Accept Kardan Report'}, 
},

mechanotasks = {
    [1] = {reward = 10, type='GashtZani', value=100, description = ' Gasht Zani Dar Shahr Va Bazdid Az Manategh Por Hadese'},
    [2] = {reward = 12, type='GashtZaniOut', value=100, description = ' Gasht Zani Dar Biroon Shahr Va Bazdid Az Manategh Por Hadese'},
    --[3] = {reward = 9, type='GhabzMecano', value=100, description = ' Zadan Ghabz Baraye Afradi Ke Khadamat Az Shoma Daryaft Mikonand'},
    [3] = {reward = 8, type='Repair', value=100, description = ' Taamir Kardan Mashin Hayi Ke Niaz Be Service Darand'},
    --[5] = {reward = 10, type='IMPMecano', value=100, description = ' Zadan Ghabz Baraye Afradi Ke Khadamat Az Shoma Daryaft Mikonand'},
    [4] = {reward = 9, type='Clean', value=100, description = ' Taamiz Kardan Va Dastmal Keshidan Mashin Haye Kasif'},
},

LowestBet = 100, 
CaseOpeningItems = {
	['yusuf'] = {type = 'item', item = 'yusuf', exchange = 50.0, count = 1.0, rarity = 'common'},
    ['rccar'] = {type = 'item', item = 'rccar', exchange = 100.0, count = 1.0, rarity = 'rare'},
    ['WEAPON_REVOLVER'] = {type = 'weapon', weapon = 'WEAPON_REVOLVERL', ammo = 0.0, exchange = 5000.0,  rarity = 'supercommon'},
    ['elegy'] = {type = 'car', model = 'elegy', exchange = 10000.0, rarity = 'rare'},
    ['sultanrs'] = {type = 'car', model = 'sultanrs', exchange = 8000.0, rarity = 'superrare'},
    ['WEAPON_REVOLVER'] = {type = 'weapon', weapon = 'WEAPON_REVOLVERL', ammo = 0.0, exchange = 5000.0,  rarity = 'common'},
    ['WEAPON_KNUCKLE'] = {type = 'weapon', weapon = 'WEAPON_KNUCKLE', ammo = 0.0, exchange = 5000.0,  rarity = 'rare'},
    ['4000000'] = {type = 'money', money = 4000000, exchange = 2000.0, rarity = 'supercommon'},
    ['25'] = {type = 'dcoin', credits = 25, exchange = 20.0, rarity = 'common'},
    ['WEAPON_REVOLVER'] = {type = 'weapon', weapon = 'WEAPON_REVOLVERL', ammo = 0.0, exchange = 5000.0,  rarity = 'superrare'},
    ['WEAPON_KNUCKLE'] = {type = 'weapon', weapon = 'WEAPON_KNUCKLE', ammo = 0.0, exchange = 5000.0,  rarity = 'superrare'},
    ['WEAPON_BATTLEAXE'] = {type = 'weapon', weapon = 'WEAPON_BATTLEAXE', ammo = 0.0, exchange = 5000.0,  rarity = 'supercommon'},

    ['50'] = {type = 'dcoin', credits = 50, exchange = 20.0, rarity = 'rare'},
    ['100000'] = {type = 'money', money = 100000, exchange = 2000.0, rarity = 'superrare'},
    ['elegy'] = {type = 'car', model = 'elegy', exchange = 10000.0, rarity = 'rare'},
    ['sultanrs'] = {type = 'car', model = 'sultanrs', exchange = 8000.0, rarity = 'superrare'},
    ['4000000'] = {type = 'money', money = 4000000, exchange = 2000.0, rarity = 'common'},
    ['WEAPON_REVOLVER'] = {type = 'weapon', weapon = 'WEAPON_REVOLVERL', ammo = 0.0, exchange = 5000.0,  rarity = 'superrare'},
    ['WEAPON_KNUCKLE'] = {type = 'weapon', weapon = 'WEAPON_KNUCKLE', ammo = 0.0, exchange = 5000.0,  rarity = 'superrare'},
    ['1000000'] = {type = 'money', money = 1000000, exchange = 2000.0, rarity = 'rare'},
    ['4000000'] = {type = 'money', money = 4000000, exchange = 2000.0, rarity = 'supercommon'},
    ['yusuf'] = {type = 'item', item = 'yusuf', exchange = 50.0, count = 1.0, rarity = 'rare'},
    ['rccar'] = {type = 'item', item = 'rccar', exchange = 100.0, count = 1.0, rarity = 'rare'},
    ['WEAPON_REVOLVER'] = {type = 'weapon', weapon = 'WEAPON_REVOLVERL', ammo = 0.0, exchange = 5000.0,  rarity = 'common'},
    ['WEAPON_KNUCKLE'] = {type = 'weapon', weapon = 'WEAPON_KNUCKLE', ammo = 0.0, exchange = 5000.0,  rarity = 'rare'},
    ['4000000'] = {type = 'money', money = 4000000, exchange = 2000.0, rarity = 'common'},

    ['25'] = {type = 'dcoin', credits = 25, exchange = 20.0, rarity = 'common'},
    ['100'] = {type = 'dcoin', credits = 100, exchange = 20.0, rarity = 'superrare'},
    ['WEAPON_BATTLEAXE'] = {type = 'weapon', weapon = 'WEAPON_BATTLEAXE', ammo = 0.0, exchange = 5000.0,  rarity = 'rare'},
    ['4000000'] = {type = 'money', money = 4000000, exchange = 2000.0, rarity = 'common'},
    ['WEAPON_ASSAULTRIFLE_MK2'] = {type = 'weapon', weapon = 'WEAPON_ASSAULTRIFLE_MK2', ammo = 0.0, exchange = 5000.0,  rarity = 'superrare'},

},


BuyCreditsLink = 'core.tebex.io',
BuyCreditsDescription = 'Buying credits and other items helps to run this server :) Thanks!',

Text = {


    ['item_purschased'] = 'Item purschased',
    ['not_enough_credits'] = 'Not enough credits',
    ['wrong_usage'] = 'Wrong usage',
    ['item_redeemed'] = 'You have redeemed an item!',
    ['item_exchanged'] = 'Item exchanged for credits!',
    ['bet_limit'] = 'You have to bet atleast 100 credits!',
    ['task_completed'] = 'Task completed!'


}

}

function SendTextMessage(msg)
    exports['mythic_notify']:SendAlert('inform', msg)
end
