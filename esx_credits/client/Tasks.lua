---@diagnostic disable: param-type-mismatch, lowercase-global, redundant-parameter, undefined-field, undefined-global, need-check-nil
local ESX = nil
local PlayerData = {}
local Thread = false
local InMenu = false
local CanPressKey = false
local Config = {}
local QuestName = nil
local OnQuest = false 
local Nitem = 0 
local item = nil 
local Medrandom = math.random(5,10) 
local minirandom = math.random(1,5) 
local highrandom = math.random(50,100) 
local tenrandmon = math.random(10,20) 
local Max = 0
local shans = math.random(1,2)
local recep = {
	["police"] = vector3(-1094.06,-832.66,19.32),
	["sheriff"] = vector3(1830.79,3682.41,34.33),
	["forces"] = vector3(620.43,8.3,83.64),
	["justice"] = vector3(-552.42,-202.76,38.24),
	["ambulance"] = vector3(-675.33,330.7,83.08),
    ["medic"] = vector3(1741.91,3638.98,34.85),
}
local Security = {
    ["Mechanic"] = vector3(-362.25,-132.5,38.68),
    ["Benny"] =  vector3(-583.42,-1801.76,23.17),
    ["Taxi Rani"] = vector3(907.88,-177.4,74.14),
    ["Cafe Artist"] = vector3(105.86,217.47,107.76),
    ["Special CarDealer"] = vector3(-115.88,-2021.53,18.02),
    ["Diamond CarDealer"] = vector3(-1678.41,-873.87,8.69),
    ["Resturan Kharchang"] = vector3(-1401.01,-1266.82,4.47),
    ["Club Bahamas"] = vector3(-1436.75,-583.76,30.59),
}
local Security2 = {
    ["Furudgah Birun Shahr"] = vector3(1729.75,3266.25,41.15),
    ["GameCenter"] = vector3(1459.13,6546.91,14.65),
    ["Ist Bazresi"] = vector3(1491.75,818.75,76.89),
    ["Mechanic Birun Shahr"] = vector3(1189.08,2659.79,37.81),
}
local NameToCoord = {
    "Mechanic",
    "Benny",
    "Taxi Rani",
    "Cafe Artist",
    "Special CarDealer",
    "Diamond CarDealer",
    "Resturan Kharchang",
    "Club Bahamas",
}
local NameToCoord2 = {
    "Furudgah Birun Shahr",
    "GameCenter",
    "Ist Bazresi",
    "Mechanic Birun Shahr",
}
local Inside = {
    vector3(339.22,-1309.25,32.0),
    vector3(1021.99,-2041.92,30.84),
    vector3(1365.5,-577.38,74.38),
    vector3(217.42,1222.38,225.46),
    vector3(-394.02,1207.27,325.64),
    vector3(-2295.95,403.39,174.47),
    vector3(-3026.24,108.96,11.62),
    vector3(-1196.5,-2819.9,13.95),
    vector3(-1033.23,-1063.49,3.28),
    vector3(1474.61,751.28,77.46),
    vector3(1261.79,-3282.31,5.84),
    vector3(457.83,-2.65,83.94),
    vector3(-66.91,892.81,235.55),
    vector3(-1980.82,546.62,111.17),
    vector3(331.99,-2044.37,20.83),
    vector3(-223.83,-1517.99,31.53),
    vector3(1537.83,-2075.63,77.21),
    vector3(-676.59,291.02,81.95),
    vector3(723.49,-285.99,58.34),
    vector3(789.33,-814.93,26.31),
    vector3(2517.97,-285.84,92.99),
    vector3(-394.68,401.34,109.16),
    vector3(-1501.58,1501.66,115.57),
    vector3(-331.01,-1007.12,30.38),
    vector3(901.81,2158.9,49.54),
    vector3(1676.64,-70.4,173.85),
    vector3(377.03,770.21,184.13),
    vector3(-484.3,-620.46,31.17),
    vector3(-558.1,-1110.86,22.1),
    vector3(-1637.83,-204.96,55.13),
}
local Outside = {
    vector3(2693.98,1467.14,24.54),
    vector3(2941.52,2790.68,40.26),
    vector3(3557.71,3766.19,29.92),
    vector3(1935.08,5150.88,44.16),
    vector3(1380.26,4369.18,43.81),
    vector3(1615.55,3814.88,34.93),
    vector3(89.43,3734.14,39.72),
    vector3(-1575.65,5143.79,20.4),
    vector3(-801.01,5429.03,34.66),
    vector3(-123.86,6425.38,31.33),
    vector3(1567.8,6456.01,24.28),
    vector3(2496.69,4088.79,38.03),
    vector3(2188.32,3005.62,45.47),
    vector3(2073.43,2317.67,94.07),
    vector3(838.13,2408.65,53.93),
    vector3(1729.47,3270.39,41.14),
    vector3(-1864.96,3212.12,32.93),
    vector3(-259.74,2869.52,46.51),
    vector3(-515.19,2007.16,205.39),
    vector3(408.55,2609.8,43.68),
    vector3(-3146.91,1299.76,17.08),
    vector3(2247.04,5568.45,52.64),
    vector3(3329.84,5462.24,18.75),
    vector3(2447.88,3768.2,41.15),
    vector3(-1805.31,1906.63,147.46),
    vector3(156.71,3086.36,42.59),
    vector3(1907.69,1320.77,153.41),
    vector3(840.19,1285.08,359.87),
    vector3(-867.94,4403.14,20.87),
    vector3(-1627.97,4743.45,52.92), 
}
local Roads = {
    vector3(-230.5582, -972.4484, 29.12817),
    vector3(226.655, 201.6659, 105.3231),
    vector3(-850.3781, -1191.705, 5.622681),
    vector3(921.2703, -182.9275, 74.06665),
    vector3(-1083.547, -268.2066, 37.58679),
    vector3(-665.7758, -228.1451, 37.26672),
    vector3(-367.0154, -159.9824, 38.21021),
    vector3(817.0945, -1955.064, 29.16187),
    vector3(-620.2681, -923.9868, 23.04541),
    vector3(-613.3714, 3.745055, 42.10254),
}
local ShRoads =  {
    vector3(-138.5011, 6458.268, 31.45349),
    vector3(1703.499, 6419.183, 32.63293),
    vector3(2772.409, 3407.486, 55.88574),
    vector3(1457.169, 758.189, 77.38611),
    vector3(1201.556, 2677.305, 37.72156),
    vector3(-2973.508, 481.6879, 15.2439),
    vector3(-1805.881, 801.9561, 138.5004),
    vector3(2327.037, 5066.716, 45.72522),
    vector3(1907.116, 2609.71, 45.74219),
    vector3(2577.349, 364.589, 108.4572),
}
local Dir1 = 0 
local Dir2 = 0
local Dir3 = 0
local Market = {
    'iron',
    'diamond',
    'gold',
    'wine',
    'vodka',
    'mushroom',
    'jewels',
    'copper',
    'wood',
    'heroine',
    'proplus',
    'cocaine',
    'wine',
    'vodka',
    'marijuana',
    'desomorphine',
    'modafinil',
}

local Items = {
    'proplus',
    'cocaine',
    'vodka',
    'marijuana',
    'desomorphine',
    'modafinil',
    'heroine',
    'whiskey',
}

local drug = {
    'ephedra',
    'cannabis',
    'coca',
    'mushroom',
    "poppy",
}

local Craft = {
    'WEAPON_PISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_SWITCHBLADE',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_ASSAULTSMG',
    'WEAPON_SMG',
}

local robs = {
    'Shop',
    --'BankSheriff',
    'Mythic',
    'BankMarkzi',
}
local RevivePlayerJob = {
    'police',
    'mechanic',
    'sheriff',
    'taxi',
}

local PoliceScurity = 
{
    vector3(194.189, -946.5626, 30.08862),
    vector3(-371.1824, -130.6286, 38.68201),
    vector3(-838.7736, -1211.38, 6.751709),
    vector3(918.633, -178.6549, 74.25208),
    vector3(-625.0549, -937.0549, 22.05127)
}
local SheirffScurity = {
    vector3(1453.2, 761.2088, 77.23438),
    vector3(1421.802, 6505.147, 19.67542),
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do 
        Citizen.Wait(100)
    end
   PlayerData = ESX.GetPlayerData()
end)

function StartQuest(data)
    if data == "FishingJob" then
        SetNewWaypoint(-1836.03,-1260.94)
        RunQuest('FishingJob','number',nil,nil,highrandom,highrandom.." Adad Mahi Dar Sahel Seyd Konid")
    elseif data == "MinerJob" then
        SetNewWaypoint(910.98,-2201.74)
        RunQuest('MinerJob','number',nil,nil,highrandom,highrandom.." Adad Sang Dar Kamioon Shoghl Minery Jam Avari Konid")
    elseif data == "LumberjackJob" then
        SetNewWaypoint(1205.59,-1266.93)
        RunQuest('LumberjackJob','number',nil,nil,highrandom,highrandom.." Adad Choob Baste Bandi Shode Dar Shoghl Choob Bori Tahvil Bedahid")
    elseif data == "NaftKeshJob" then
        SetNewWaypoint(577.82,-2284.1)
        RunQuest('NaftKeshJob','number',nil,nil,highrandom,highrandom.." Adad Esans Dar Shoghl Sherkat Naft Tahvil Bedahid")
    elseif data == "Deliveryjob" then
        SetNewWaypoint(131.93,94.06)
        RunQuest('Deliveryjob','number',nil,nil,7," 7 Adad Baste Ra Be Location Ha Dar Shoghl Delivery Beresanid")
    elseif data == "GhasabJob" then
        SetNewWaypoint(-1065.07,-2079.41)
        RunQuest('GhasabJob','number',nil,nil,highrandom,highrandom.." Adad Morgh Baste Bandi Shode Dar Shoghl Ghasabi Tahvil Dahid")
    elseif data == "HunterJob" then
        SetNewWaypoint(-86.28,1882.1)
        RunQuest('HunterJob','number',nil,nil,Medrandom,Medrandom.." Adad Poost Ya Gusht Dar Job Shekarchi Befrushid")
    elseif data == "WineJob" then 
        SetNewWaypoint(-1862.37,2086.64)
        RunQuest('WineJob','number',nil,nil,1," Shoghl Sharab Sazi Ra Az Aval Ta Akharin Marhale Anjam Bedahid")
    elseif data == "SellItemMarket" then
        SetNewWaypoint(137.73,-1782.96)
        RunQuest('SellItemMarket','number',nil,nil,tenrandmon," Be Tedade "..tenrandmon.." Adad Item Dar MarketPlace Befrushid")
    elseif data == "BuyItemMarket" then
        SetNewWaypoint(137.73,-1782.96)
        RunQuest('BuyItemMarket','number',nil,nil,tenrandmon," Be Tedade "..tenrandmon.." Adad Item Az MarketPlace Bekharid")
    elseif data == "SkyDiving" then
        SetNewWaypoint(2130.04,4790.82)
        RunQuest('SkyDiving','number',nil,nil,1," Be Mahal Skydiving Beravid Va Ba Chatr Az Havapeyma Beparid")
    elseif data == "PullPet" then 
        RunQuest('PullPet','number',nil,nil,Medrandom," Be Moddate "..Medrandom.." Daghighe Heyvan Khanegi Khod Ra Be Gardesh Bebarid")
    elseif data == "Planting" then
        SetNewWaypoint(1874.81,5063.57)
        RunQuest('Planting','number',nil,nil,Medrandom," Be Tedade "..Medrandom.." Adad Giah, Faghat Az Mive Haye(Toot Farangi, Dragon Fruit, Ghaarch) Bekarid")
    elseif data == "RentVehicle" then
        SetNewWaypoint(-82.74,97.25)
        RunQuest('RentVehicle','number',nil,nil,tenrandmon," Be Moddate "..tenrandmon.. " Daghighe Yek Mashin Ejare Konid")
    elseif data == "sellDrugDealer" then
        SetNewWaypoint(-1225.94,-1490.47)
        RunQuest('sellDrugDealer','number',nil,nil,Medrandom," Be Tedade "..Medrandom.. " Adad Item Dar Drug Dealer Befrushid")
    elseif data == "otherPlanting" then
        SetNewWaypoint(1874.81,5063.57)
        RunQuest('otherPlanting','number',nil,nil,minirandom," Be Tedade "..minirandom.." Adad Giah Dar Makan Haye Planting Bekarid")
    elseif data == "DriveBoat" then
        SetNewWaypoint(-766.37,-1490.42)
        RunQuest('DriveBoat','number',nil,nil,Medrandom, " Be Moddate "..Medrandom.." Daghighe Ghayegh Savari Konid")
    elseif data == "tattoo" then
        SetNewWaypoint(320.82,175.9)
        RunQuest('tattoo','number',nil,nil,1," Dar Tattoo Shop Yek Tattoo Rooye Badan Khod Bezanid")
    elseif data == "Swimming" then
        SetNewWaypoint(-1575.2,-1230.64)
        RunQuest('Swimming','number',nil,nil,Medrandom," Be Moddate "..Medrandom.." Daghighe Dar Darya Ya Estakhr Shena Konid")
    elseif data == "chop" then
        SetNewWaypoint(-551.48,-1698.88)
        RunQuest('chop','number',nil,nil,1," 1 Mashin Dar Chop Shop Shahr Chop Konid")
    elseif data == "Cinema" then
        SetNewWaypoint(320.82,175.9)
        RunQuest('Cinema','number',nil,nil,Medrandom," Be Moddate "..Medrandom.." Daghighe Dar Cinema Film Tamasha Konid")
    elseif data == "CarDealer" then
        RunQuest('CarDealer','number',nil,nil,1," Yek Mashin Az Masool Cardealer Kharidari Konid (Special Cardealer, Diamond Cardealer)")
    elseif data == "UsingItems" then
        RunQuest('UsingItems','number',nil,nil,minirandom," Be Tedade "..minirandom.." Adad Yeki Az Mive Haye (Toot Farangi, Dragon Fruit, Ghaarch) Ra Bokhorid")
    elseif data == "FlyLicense" then
        SetNewWaypoint(-942.84,-2958.86)
        RunQuest('FlyLicense','number',nil,nil,2," Ayinnaame Va Govahinameye Khalabani(Helicopter, Havapeyma) Ra Begirid")
    elseif data == "GetGunLicense" then
        SetNewWaypoint(18.2,-1112.93)
        RunQuest('GetGunLicense','number',nil,nil,1," Az Yeki Az Aslahe Forushi Haye Shahr Mojavez Aslahe Begirid")
    elseif data == "HireInOrgan" then
        RunQuest('HireInOrgan','number',nil,nil,1," Dar Yeki Az Organ Haye Dolati Estekhdam Shavid")
    elseif data == "BuyApartment" then
        SetNewWaypoint(-777.2,310.18)
        RunQuest('BuyApartment','number',nil,nil,1," Yek Vahed Apartemani Dar Shahr Ejare Konid")
    elseif data == "BuyClothes" then
        SetNewWaypoint(421.13,-813.31)
        RunQuest('BuyClothes','number',nil,nil,1," 1 Dast Lebas Az Lebas Forushi Kharidari Konid Va Bepushid")
    elseif data == "GetDriverLicense" then
        SetNewWaypoint(235.07,-1382.3)
        RunQuest('GetDriverLicense','number', nil, nil, 2, " Ayinnaame Va Govahiname Marboot Be (Motor Ya Kamioon Ya Mashin) Ra Begirid")
    elseif data == "GetDrug" then
        SetNewWaypoint(1585.38,-1981.88)
        RunQuest('GetDrug','number', nil, nil, highrandom, " Be Tedade "..highrandom.." Ephedra Dar Zamin Ephedra Jaam Konid")
    elseif data == "ConvertDrug" then
        SetNewWaypoint(1850.06,4917.11)
        RunQuest('ConvertDrug','number', nil, nil, Medrandom, " Az Tabdil Kardan Tokhm Cocaine Be Cocaine "..Medrandom.." Adad Cocaine Be Dast Biavarid")
    elseif data == "gangPlant" then
        SetNewWaypoint(1874.81,5063.57)
        RunQuest('gangPlant','number', nil, nil, Medrandom, " Be Tedade "..Medrandom.." Teryak Ya Marijuana Bekarid")
    elseif data == "ShopRobbery" then
        SetNewWaypoint(717.19,-977.78)
        RunQuest('ShopRobbery','number', nil, nil, 1, " Yek ShopRobbery Start Konid")
    elseif data == "PaletoRobbery" then
        RunQuest('PaletoRobbery','number', nil, nil, 1, " Yeki Az Bank Haye Fleeca Ra Be Hamrah Ham Gangi Haye Khod Va Ba Raayat Kardan Ghavanin Server Start Konid")
    elseif data == "CraftAslahe" then
        RunQuest('CraftAslahe','number', nil, nil, 1, " Yek Aslahe Dar Base Gang Khod Ba Dastgah Gun Sazi Craft Konid")
    elseif data == "SellJewel" then
        SetNewWaypoint(717.19,-977.78)
        RunQuest('SellJewel','number', nil, nil, highrandom, " Be Tedade "..highrandom.." Adad Javaher Befrushid")
    elseif data == "GharbalMiner" then
        SetNewWaypoint(313.09,2870.08)
        RunQuest('GharbalMiner','number', nil, nil, 300, " 300 Sang Ba Mashin Minery Dar Shoghl Mineri Beshoorid")
    elseif data == "Revive" then
        RunQuest('Revive','number', nil, nil, minirandom, minirandom.." Nafar Ra Ba Medkit Revive Konid")
    elseif data == "Bandage" then
        RunQuest('Bandage','number', nil, nil, minirandom, " Az Bandage Baraye Modava Kardan "..minirandom.." Nafar Estefade Konid (Faghat Dar Otagh Darman Bimarestan)")
    elseif data == "GhabzMecano" then
        RunQuest('GhabzMecano','number', nil, nil, Medrandom, " Be Tedade "..Medrandom.." Adad Ghabz Baraye Moshtarian Khod Sader Konid")
    elseif data == "Repair" then
        RunQuest('Repair','number', nil, nil, Medrandom, " Be Tedade "..Medrandom.." Adad Mashini Ke Niaz Be Taamir Darand Residegi Konid")
    elseif data == "IMPMecano" then
        RunQuest('IMPMecano','number', nil, nil, Medrandom, " Be Tedade "..Medrandom.." Adad Mashin Bi Sarneshin Ra Impound Konid")
    elseif data == "Clean" then
        RunQuest('Clean','number', nil, nil, Medrandom, " Be Tedade "..Medrandom.." Adad Mashin Ra Ba Dastmal Taamiz Konid")
    elseif data == "NPC" then
        RunQuest('NPC','number', nil, nil, 4, " Tedade 4 Adad NPC Ra Dar Job Dakheli Taxi Be Maghsad Beresanid")
    elseif data == "NPC2" then
        RunQuest('NPC2','number', nil, nil, 2, " Tedade 2 Adad NPC Ra Dar Job Dakheli Taxi Be Maghsad Beresanid")
    elseif data == "News" then
        RunQuest('News','number', nil, nil, minirandom, " Be Tedade "..minirandom.." Adad /news Bezanid Va Khabar Haye Jadid Elaam Konid")
    elseif data == "Camera" then
        RunQuest('Camera','number', nil, nil, Medrandom, " Be Moddate "..Medrandom.." Daghighe Ba Doorbin Ya Microphone Gozaresh Tahie Konid")
    elseif data == "Tablet" then
        RunQuest('Tablet','number', nil, nil, minirandom, " Tedade "..minirandom.." Parvande Baraye Mojrem Ha Dar Tablet Dorost Konid")
    elseif data == "ImpoundJob" then
        RunQuest('ImpoundJob','number', nil, nil, minirandom, " Tedade "..minirandom.." Mashin Bi Sar Neshin Va Vel Shode Ra Impound Konid")
    elseif data == "Reception" then
        RunQuest('Reception','number', nil, nil, Medrandom, " Be Moddate "..Medrandom.." Daghighe Dar Reception Edare Khod Hozur Dashte Bashid")
        SetNewWaypoint(recep[ESX.GetPlayerData().job.name].x, recep[ESX.GetPlayerData().job.name].y)
    elseif data == "Ghelion" then
        RunQuest('Ghelion','number', nil, nil, 1, " 1 Adad Ghelion Dar Makane Cafe Artist Bekshid")
        SetNewWaypoint(105.99,203.77)
    elseif data == "GashtZani" then 
        RunQuest('GashtZani','number', nil, nil, 6, " Be 6 Location Mark Shode Dar Naghshe Khod Beravid Va Gasht Zani Konid")
        local Points = {}
        local counter = 0
        while counter < 6 do
            Citizen.Wait(100)
            math.randomseed(GetGameTimer()*246810)
            local random = math.random(#Inside)
            if not Points[random] then
                Points[random] = true
                counter = counter + 1
            end
        end
        StartGashtThread(Points)
    elseif data == "GashtZaniOut" then 
        RunQuest('GashtZaniOut','number', nil, nil, 6, " Be 6 Location Mark Shode Dar Naghshe Khod Beravid Va Gasht Zani Konid")
        local Points = {}
        local counter = 0
        while counter < 6 do
            Citizen.Wait(100)
            math.randomseed(GetGameTimer()*246810)
            local random = math.random(#Inside)
            if not Points[random] then
                Points[random] = true
                counter = counter + 1
            end
        end
        BStartGashtThread(Points)
    elseif data == "Security" then
        math.randomseed(GetGameTimer()*246810)
        local random
        local name
        local coord
        if PlayerData.job.name == "sheriff" then
            random = math.random(#NameToCoord2)
            name = NameToCoord2[random]
            coord = Security2[name]
        else
            random = math.random(#NameToCoord)
            name = NameToCoord[random]
            coord = Security[name]
        end
        RunQuest('Security','number', nil, nil, tenrandmon, " Be Moddate "..tenrandmon.." Daghighe Az "..name.." Mohafezat Konid")
        SecurityThread(name, coord)
    end
end

function TimeThread(crd)
    local Seceonds = 59
    local Minutes  = Max - 1
    Citizen.CreateThread(function()
        while true do
            local coord = GetEntityCoords(PlayerPedId())
            local distance = ESX.GetDistance(coord, crd)
            if distance > 50.0 or not OnQuest then
                Nitem = 0
                break
            end
            if Seceonds < 10 then
                if Minutes < 10 then
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":0"..Seceonds)
                else
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":0"..Seceonds)
                end
                if Seceonds == 0 then
                    if Minutes == 0 and Seceonds == 0 then
                        ESX.ShowMissionText("~g~Zaman Baghi Mande : ~g~0"..Minutes..":"..Seceonds)
                        TriggerEvent('esx_Quest:point', 'Security', nil, 1)
                        break
                    else
                        TriggerEvent('esx_Quest:point', 'Security', nil, 1)
                        Minutes = Minutes - 1
                        Seceonds = 60
                    end
                end
            else
                if Minutes < 10 then
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":"..Seceonds)
                else
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":"..Seceonds)
                end
            end
            Seceonds = Seceonds - 1
            Citizen.Wait(1000)
        end
    end)
end

function SecurityThread(name, crd)
    local Inside = false
    Citizen.CreateThread(function()
        while OnQuest do
            Citizen.Wait(3000)
            local coord = GetEntityCoords(PlayerPedId())
            local distance = ESX.GetDistance(coord, crd)
            SetNewWaypoint(Security[name].x, Security[name].y)
            if distance <= 50.0 then
                if not Inside then
                    Inside = true
                    TimeThread(crd)
                    ESX.Alert("Shoma Vared Mantaghe Security Shodid, Dar Soorati Ke Ghabl Az Payan Timer Az Mantaghe Kharej Shavid Timer Reset Khahad Shod", "lspd")
                end
            else
                if Inside then
                    Inside = false
                    ESX.Alert("Shoma Az Mantaghe Security Kharej Shodid", "lspd")
                end
            end
        end
    end)
end

function StartGashtThread(Points)
    local locations = {}
    for k, v in pairs(Points) do
        table.insert(locations, {coord = Inside[k], av = false})
    end
    locations = SetOnline(locations)
    Citizen.CreateThread(function()
        while OnQuest do
            Citizen.Wait(2000)
            for k, v in pairs(locations) do
                if v.av then
                    SetNewWaypoint(v.coord.x, v.coord.y)
                    local my = GetEntityCoords(PlayerPedId())
                    local dis = #(my - v.coord)
                    if dis <= 30.0 then
                        locations = SetOnline(locations)
                        TriggerEvent('esx_Quest:point', 'GashtZani', nil, 1)
                    end
                end
            end
        end
    end)
end

function SetOnline(locations)
    local locations = locations
    for k, v in pairs(locations) do
        if v.av then
            table.remove(locations, k)
        end
    end
    for k, v in pairs(locations) do
        if not v.av then
            v.av = true
            break
        end
    end
    return locations
end

function BStartGashtThread(Points)
    local locations = {}
    for k, v in pairs(Points) do
        table.insert(locations, {coord = Inside[k], av = false})
    end
    locations = BSetOnline(locations)
    Citizen.CreateThread(function()
        while OnQuest do
            Citizen.Wait(2000)
            for k, v in pairs(locations) do
                if v.av then
                    SetNewWaypoint(v.coord.x, v.coord.y)
                    local my = GetEntityCoords(PlayerPedId())
                    local dis = #(my - v.coord)
                    if dis <= 30.0 then
                        locations = BSetOnline(locations)
                        TriggerEvent('esx_Quest:point', 'GashtZaniOut', nil, 1)
                    end
                end
            end
        end
    end)
end

function BSetOnline(locations)
    local locations = locations
    for k, v in pairs(locations) do
        if v.av then
            table.remove(locations, k)
        end
    end
    for k, v in pairs(locations) do
        if not v.av then
            v.av = true
            break
        end
    end
    return locations
end

function RunQuest(name,model,table,key,NuMbeR,txt)
    taskLabel = txt
    OnQuest = true
    onTheQuest = true
    QuestName = name 
    Max = NuMbeR 
    if model == 'number' then
        print("Quest : "..txt)
        exports['esx_dNotify']:Alert("INFO", "<span style='color:#c7c7c7'>[New Task] "..txt.." ", 60000, 'info')
        CreateThread(function()
            while OnQuest == true do
                Wait(5000)
                if Nitem >= NuMbeR then 
                    exports['esx_dNotify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>Task Done <span style='color:#069a19'><b>Jayze Darayft Shod</b></span>!", 5000, 'success')
                    QuestEnd(5)
                    return 
                end
            end
        end)
    elseif model == 'item' then 
        for k,v in pairs(table) do 
            if key == k then 
                item = v 
                break
            end
        end
        Wait(710)
        print("Quest : "..txt..item)
        exports['esx_dNotify']:Alert("INFO", "<span style='color:#c7c7c7'>"..txt..item.." ", 60000, 'info')
        CreateThread(function()
            while OnQuest == true do
                Wait(5000)
                if Nitem >= NuMbeR  then 
                    exports['esx_dNotify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>Task Done <span style='color:#069a19'><b>Jayze Darayft Shod</b></span>!", 5000, 'success')
                    QuestEnd(5)
                    return 
                end
            end
        end)
    end
end

RegisterNetEvent("esx_Quest:RollBackQuest")
AddEventHandler("esx_Quest:RollBackQuest", function()
    OnQuest = false 
    Nitem = 0 
    item = nil 
    Medrandom  = math.random(10,20)
    minirandom = math.random(1,3) 
    highrandom = math.random(50,80) 
    QuestName = nil
    Max = 0
    onTheQuest = false
    QuestNames = nil
    taskLabel = nil
    ESX.UI.Menu.CloseAll()
    taxes = math.random(20000, 30000)
    ESX.Alert("Shoma Task Khod Ra Cancel Kardid", "check")
end)

function QuestEnd()
    Citizen.Wait(math.random(1,555))
    if not OnQuest then return end
    OnQuest = false 
    TriggerServerEvent("Quest:done")
    Nitem = 0 
    item = nil 
    Medrandom = math.random(5,10) 
    minirandom = math.random(1,5) 
    highrandom = math.random(50,100) 
    tenrandmon = math.random(10,20) 
    QuestName = nil
    taskLabel = nil
    Max = 0
    onTheQuest = false
    QuestNames = nil
    ESX.UI.Menu.CloseAll()
    taxes = math.random(20000, 30000)
end

RegisterNetEvent("esx_Quest:point") 
AddEventHandler("esx_Quest:point",function(name,nameitem,number)
    local resourceName = GetInvokingResource()
	if resourceName and not GlobalState.resources[resourceName] then return end
    print(name,nameitem,number,QuestName,item,Nitem)
    if name ~= QuestName then return end
    if item and nameitem then 
        if nameitem == item then 
            Nitem = Nitem + number
        else
            return
        end 
    else
        Nitem = Nitem + number 
    end 
    Wait(710)
    exports['esx_dNotify']:Alert("Quest", "<span style='color:#c7c7c7'>Task Dar Hale Anjam!  <span style='color:#069a19'><b>+"..Nitem.."</b></span></span><b>/ "..Max.."</b>!", 3000, 'long')
end)
