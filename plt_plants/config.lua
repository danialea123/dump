plt_plants = {} local PLT = plt_plants
---------------------------------------------------------------------------------------------------------------------------------------------------------
PLT.U = Lang["EN"]                                              -- SET = ("EN" or "TR" or "Custom"), Edit locale.lua to add more languages.
PLT.Water = {dbName = "water", label = "Water"}                 -- The "name" and "label" of the water in "your framework".
PLT.Fertilizer = {dbName = "fertilizer", label = "Kood"}  -- The "name" and "label" of the fertilizer in "your framework".
PLT.Burner = {dbName = "burner", label = "Atish Zane", delete = true} -- SET = (false or {dbName = "burner", label = "Burner", delete = true}), The "name" and "label" of the Burner in "your framework" if you set false it will not need item to burn.
PLT.HarvestShears = false                                     -- SET = (false or {dbName = "harvestshears", label = "Harvest Shears", delete = false}), The "name" and "label" of the Harvest Shears in "your framework" if you set false it will not need item to harvest.
PLT.MaxTotalPlants = false                                      -- SET = (false or number), How many plants one person should be able to plant. False value is unlimited.
PLT.GiveInfoWhenStart = true                                    -- SET = (true or false), Info will be given in server console when script is started.
PLT.PrintActionInfoToServerConsole = false                      -- SET = (true or false), Info will be given in server console when players do any action. For example: if there is a new plant, if someone is watering a plant etc.
PLT.MaxDifferentTypePlants = false                              -- SET = (false or number), If set to "false" players can plant every kind of seed. If set to a number, players will be able to plant limited different seeds according to given number.
PLT.MarkerDistance = 10.0                                       -- SET = (float number), Plant markers will be shown from given number of distance.
PLT.MinPropWidth = 1.0                                          -- SET = (float number), Dont touch this!!! This is for the small plant props to become bigger.
PLT.MarkerColour = {r = 0, g = 255, b = 0, alpha = 50}          -- https://www.w3schools.com/colors/colors_rgb.asp alpha = opacity(0 to 255)
PLT.PropUpdateDistance = 75                                     -- SET = (number) How close to the props will be loaded and updated. If you increase the number, the CPU usage may increase.
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- every time value is with second: "60 * 60 * 20" mean is 20 hours, "60 * 1 * 1" mean is 1 minute,  "60 * 60 * 1" mean is 1 hours,
PLT.Plants ={
    ["weed_seed"] = {
        prop = "prop_weed_01",                                       -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                       -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=0,max=1},                      -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=10,max=20},                -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 100,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=2},                                    -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "marijuana",                                    -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "weed_seed",                                     -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                             -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = true,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                      -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = nil,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = nil                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
    ["poppy_seed"] = {
        prop = "prop_bzzz_gardenpack_poppy001",                      -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                       -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=0,max=1},                      -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=10,max=20},                -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 100,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=5},                                    -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "opium",                                        -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "poppy_seed",                                    -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                            -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = true,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                      -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = nil,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = nil                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
    ["tobacco_seed"] = {
        prop = "prop_bzzz_gardenpack_tabacco001",                    -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                       -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=0,max=1},                      -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=10,max=20},                -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 100,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=4},                                   -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "tobacco_leaf",                                 -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "tobacco_seed",                                  -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                              -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = true,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                      -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = nil,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = nil                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
    ["dragonfruit_seed"] ={
        prop = "prop_plant_paradise",                                -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                       -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=0,max=1},                      -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=10,max=20},                -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 50,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=8},                                    -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "dragonfruit",                                  -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "dragonfruit_seed",                              -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                             -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = true,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                     -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        {coord = vector3(4666.0,-5100.0,15.0), distance = 1400},                 -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        notify ="this plant can only be planted on the island of Cayo Perico."   -- This is the error message when someone tries to plant this outside preset area.
        },
        height = 2.1,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = 2.0                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
    ["strawberry_seed"] ={
        prop = "prop_plant_fern_01b",                                -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                       -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=50,max=60},                    -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=0,max=0},                  -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 50,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=8},                                    -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "strawberry",                                   -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "strawberry_seed",                               -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                              -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = false,                -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                     -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                     -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        {coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                     -- You can add as many coordinates as you like.
        notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = 0.6,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = nil                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
    ["mushroom_seed"] ={
        prop = "bzzz_prop_garden_lysohlavky001",                      -- SET = ("PropName"), any props can be used as plant. https://gta-objects.xyz/objects
        plantDirtProp = "bzzz_prop_seeds_001",                        -- SET = ("PropName" or false) if you use "bzzz_prop_seeds_001" a sludge appears under the plant. if you dont want set it false
        aWaterHowManyPercent = 100,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 100,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 0.5,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 0.3,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 0.3,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 1,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 1,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 1,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 1, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 2,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 2,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=20,max=80},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=40,max=60},                     -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=0,max=0},                   -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 100,                                      -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=1,max=3},                                      -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "mushroom",                                      -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "mushroom_seed",                                  -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = 50,                                         -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=2},                               -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = false,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = false,                                      -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = nil,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = nil                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    },
--[[      ["weed_seedville"] = { --!!! If you want the plant not to grow from the ground, if you want it to evolve into different props as it grows., you can set the prop variable as follows.
        prop = { --growing in a sample ville
            {name ="bkr_prop_weed_01_small_01c", min = 0 , max = 16},
            {name ="bkr_prop_weed_01_small_01a", min = 16 , max = 32},
            {name ="bkr_prop_weed_01_small_01b", min = 32 , max = 48},
            {name ="bkr_prop_weed_med_01a",      min = 48 , max = 64},
            {name ="bkr_prop_weed_med_01b",      min = 64 , max = 80},
            {name ="bkr_prop_weed_lrg_01a",      min = 80 , max = 96},
            {name ="bkr_prop_weed_lrg_01b",      min = 96 , max = 100}
        },    
        aWaterHowManyPercent = 25,                                   -- SET = (Number), How much percentage should one watering fill.
        aFertilizerHowManyPercent = 50,                              -- SET = (Number), How much percentage should one fertilizing fill.
        timeToReadyForHarvest = 60 * 60 * 20,                        -- SET = (Second), How long should take for plant to be ready to harvest.
        secWillFullWaterRunOut = 60 * 60 * 10,                       -- SET = (Second), How long untill water drops from 100% to 0%
        secWillFullFertilizerRunOut = 60 * 60 * 5,                   -- SET = (Second), How long untill fertilize drops from 100% to 0%
        secWillWaterComplateFullQualityFromZero = 60 * 60 * 20,      -- SET = (Second), Water adds quality to Plants. How long should water take to increase plant quality from 0% to 100%.
        secWillWaterWillDropZeroQualityFromFull = 60 * 60 * 5,       -- SET = (Second), Fertilizing adds quality to Plants. How long should fertilize take to increase plant quality from 0% to 100%.
        secWillFertilizerComplateFullQualityFromZero = 60 * 60 * 5,  -- SET = (Second), Lack of water decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        secWillFertilizerWillDropZeroQualityFromFull = 60 * 60 * 20, -- SET = (Second), Lack of fertilize decreases the plant quality. How long should it take to decrease plant quality from 100% to 0%.
        decayTime =  60 * 60 * 40,                                   -- SET = (Second or false), Plant will start to decay after it's ready to harvest. How long should it take to decay. If set "false" the plant won't decay.
        aliveWithoutWaterTime =  60 * 60 * 10,                       -- SET = (Second or false), When plant is growing, it will start to decay if it has no water. How long should it take to decay. If set "false" the plant won't decay from lack of water.
        startingPercentOfQuality ={min=40,max=60},                   -- SET = (Number), Starting quality when the seed is planted, a random value between min and max.
        startingPercentOfWater = {min=0,max=1},                      -- SET = (Number), Starting water percentage when the seed is planted, a random value between min and max.
        startingPercentOfFertilizer ={min=10,max=20},                -- SET = (Number), Starting fertilize percentage when the seed is planted, a random value between min and max.
        maxPlantForthisType = 2,                                     -- SET = (Number), The max limit of this type of plant for one person to sow.
        Harvest = {min=5,max=30},                                    -- SET = (Number), How many items should harvesting give according to it's quality.
        exportItem = "weed_leaf",                                    -- SET = ("ItemName"), What item will be given after harvesting.
        extraItem = "weed_seed",                                     -- SET = ("ItemName" or false), Secondary item will be given after harvesting. (Could be seeds) No extra item will be given if set to "false"
        extraItemChange = true,                                      -- SET = (Number / true or false), If set to number, extra item will be given as written number percentage chance. If set to "true" extra item will always be given. If set to "false" extra item will be given if only the quality of the plant is over 50%
        extraItemAmount= {min=1,max=10},                             -- SET = (number), How many extra items will be given.
        extraItemAmountAccordingToTheQuality = true,                 -- SET = (true or false), If "false" the number of extra item will be given is totally random between max and min numbers. If "true" it will be given according to quality of the plant.
        everyOneCanFire = true,                                      -- SET = (true or false), If "true" everyone can burn the plant. If "false" only the owner of the plant can burn it.
        OnlyOutOfCity = true,                                        -- SET = (true or false), If "true" the seeds can only be planted outside of the city.
        OutsideTheAreas ={                                                       -- If you set extra coordinates below, this seed won't be able to planted on those coordinates.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can't be planted on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify = "You cannot plant this plant on the island of Cayo Perico."   -- This is the error notify when someone tries to plant on this coordinates.
        },
        InsideTheAreas ={                                                        -- If you add coords below, the seed can only be planted inside.
        --{coord = vector3(4666.0,-5100.0,15.0), distance = 1400},               -- For example; If you activate this line this seed can be planted only on island of Cayo Perico.
        --{coord = vector3(0.0,0.0,0.0), distance =  250},                       -- You can add as many coordinates as you like.
        --notify ="this plant can only be planted on the island of Cayo Perico." -- This is the error message when someone tries to plant this outside preset area.
        },
        height = nil,                                -- SET = (float number), Prop height. The script calculates the height of the prop. It can be too big, in these cases, you can determine it manually.
        width = 1.0                                  -- SET = (float number), prop width,. The script calculates the width of the prop. It can be too big, in these cases, you can determine it manually.
    }, ]]
}

