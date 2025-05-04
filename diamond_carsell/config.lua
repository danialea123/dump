Config = {
    MYSQL = "oxmysql", -- ghmattimysql, oxmysql, mysql-async
    Framework = 'oldesx', -- newesx, oldesx, newqb, oldqb, autodetect
    TestDriveCoords = vector4(-1546.7091, -3021.9956, 13.9520, 234.7390),
    Preview = {
        coords = vector4(1239.17,2715.12,38.01,299.3),
        CamCoords = vector4(1232.51,2720.88,40.36,217.46),
    },
    Fuel = 'qbus_fuel', -- exports['LegacyFuel']:SetFuel(veh, 100)
    AddMoneyAccount = 'bank', --bank, cash
    RemoveMoneyAccount = 'bank', --bank, cash
    UseTarget = true, 
    VehicleTable = 'owned_vehicles',
    VehicleTableOwnerRow = 'owner',
    useJob = false,
    JobName = {
        'police',
        'ambulance',
        'mechanic',
        'cardealer',
        'usedcar',
    },
}

Config.TargetLocations = {
    ["pdm"] = {
        ["label"] = "Used Cars Seller",
        ["coords"] = vector4(1224.69,2728.74,38.01,190.34),
        ["ped"] = 'a_m_m_soucent_02',
        ["scenario"] = "WORLD_HUMAN_STAND_MOBILE",
        ["radius"] = 1.5,
        ["targetIcon"] = "fas fa-car",
        ["targetLabel"] = "Car Seller",
        ["showblip"] = true,
        ["blipsprite"] = 523,
        ["blipscale"] = 0.8,
        ["blipcolor"] = 0,
    },
}

Config.Class = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains",
    [22] = "Open Wheel",
}

Config.lang = {
    used_car_market = 'Diamond Car Sell',
    vehicle = 'Vehicles',
    selected_ads = 'SELECTED ADVERTISEMENTS',
    place_an_add = 'Place an add',
    search_by_name = 'Search by name...',
    color = 'Color',
    description = 'Description',
    test_drive = 'Test Drive',
    buy_vehicle = 'Buy Vehicle',
    seat = 'Seat',
    expiration = 'EXPIRATION',
    days = 'Days',
    engine_status = 'Engine Status',
    drift_mode = 'Drift Mod',
    cost = 'Cost',
    car_name = 'Car Name...',
    image_url = 'Image URL...',
    my_vehicles = 'My Vehicles',
    choose_vehicle = 'Choose vehicle',
    rotate =  "Rotate vehicle with: A , D",
    close = "Close",
    profile = 'My Profile',
    overtestdrive = 'Test drive over',
    carinspectover = 'Car inspect over',
    buyveh = 'Car bought',
    notenoughmoney = 'Not enough money',
    notadd= 'Ad could not be added! The vehicle is outside!',
    blacklistcar = 'This vehicle blacklist',
    notvalidphoto = 'Not valid photo'
}

Config.BlacklistCar = { 
    "adder",
    "dominator",
    'drafter'
}

Config.ManuelCarNames = {
    [-114291515] = "Bati",
}

Config.ValidExtensions = {
    [".png"] = true,
    [".gif"] = true,
    [".jpg"] = true,
    ["jpeg"] = true
}


function notify(text, type)
    if Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        Core.ShowNotification(text, true) -- newesx, oldesx
    elseif Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        Core.Functions.Notify(text, type)  -- newqb, oldqb
    else
        --your notif 
    end
end