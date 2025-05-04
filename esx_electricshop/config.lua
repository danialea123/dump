Config = {
    RequiredPolice = 5,
    Reward       = function()
        return math.random(100000, 150000)
    end,
    xp           = 100,
    SecToNextRob = 2*60*60*1000,
    ShopDisableTime = 20*1000*60,
    SecToRob     = 300,
    DrawDistance = 15,
    AddtionalRewardCount = 2,
    SafeBox = { c = vector3(245.037369, -265.885712, 54.032227), h = 331.35},
    Cashier = { c = vector3(247.0945, -269.3275, 53.13223), h = 248.32},
    blip = vector3(-1212.84,-1501.21,4.37),
    Prices = {
        radiocar    = 1100000,
        phone       = 50000,
        gps         = 25000,
        radio       = 200000,
        powerbank   = 15000,
    },
    Items = {
        { c = vector3(-1243.7,-1450.64,4.38), h = 252.4, name = 'radiocar', label = 'Zabt Mashin'},
        { c = vector3(-1245.94,-1449.17,4.38), h = 158.8, name = 'phone', label = 'Goshi'},
        { c = vector3(-1242.77,-1446.4,4.38), h =  248.4, name = 'gps',   label = 'GPS'},
        { c = vector3(-1246.48,-1452.54,4.38), h = 29.23, name = 'radio', label = 'Radio'},
    },
}
