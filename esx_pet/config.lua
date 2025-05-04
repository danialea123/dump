PET = {
    ManualMode = false, -- If this is true, you can access your ped from the menu at any time by typing "/mypets".

    SellingPersonalPets = true, -- If this is true, you can sell your personal pets
    -- "/petinfo" to turn off the part that comes up when you approach pets.
    debugMode = false, -- Certain prints are turned on, if you don't understand this you don't need to turn it on at all, it's here to help us understand where the error is when the script has problems.
    -- 
    petInfoCommand = "petinfo", -- Command used to turn off the pet's on-screen infos
    showPetCommand = "showmyPets", -- Blip showing the location of the pet
    -- 
    DefaultPetIMG = "https://cdn.discordapp.com/attachments/919180635388653618/1035353250242777138/pet-logo-design-paw-vector-animal-shop-business_53876-136741.webp",
    DefaultPetName = "Amazing Pets", -- if the name is "", the system will automatically fill it with the one here.
    -- Pet Shop area
    petBuyCoords = vector3(-1368.35, 56.31, 53.7), -- purchase marker part of the pet
    petShowCoords = vector4(-1366.09,56.68,54.1,119.19),-- Where to spawn when in the pet purchase menu
    -- SQL 
    Mysql = "oxmysql",
    --NEEDS SYSETM
    petHealFillItem = "pethealth", -- the pad's full of health, hunger and thirst remain as they are.
    petHealFillAmount = 97, -- How much to fill when used --max 97

    petHungryFillItem = "petfood", -- item to fill pet's hunger
    petHungryFillAmount = 97,  -- How much to fill when used --max 97

    petThirstFillItem = "petthirst", -- item to fill pet's thirst
    petThirstFillAmount = 50, -- How much to fill when used --max 97
    -- DEADTH SIDE
    PermanentlyDie = false, -- if "true", the pet will be directly deleted when it dies and will never come back.
    -- UPTADES
    UpdateAnimInterval = 0, -- If the pad is going into animation, like dying, etc., how many seconds will it be checked?
    UpdateInterval = 1, -- "1minutes" will update all pets' death, hunger, thirst, location and many other updates every 1 minute (it will be good to do this in a short time to live without problems).
    UpdateXPInterval = 10, -- "1minutes" Every 1 minute all pets will gain a set amount of xp.
    LevelingDifficulty = 20,--% Indicates the health starvation value that the pet will have directly when you buy it the difficulty to level up in [ % ]  
    --
    lossOfLife_hungry = 3, -- Selects how many lives to take when Hunger drops to 0.
    lossOfLife_thirst = 1, -- Selects how many lives to take when Thirst drops to 0.
    --
    earnXPAmount = 10, -- "UpdateXPInterval" time during which all pets will gain +1 xp for the specified amount of time
    --
    NotificationInScript = true, -- If this is "true" you will use the script's own notify system.
    Notification = function(text, inform) -- You can put your own notify text here
        
    end,
    PetMiniMap = { showblip = true, sprite = 442, colour = 2, shortRange = false },
    -- ROPE SIDE
    ropeLength = 4, -- How long the towing rope should be (in meters) I highly recommend keeping it between 6 and 10 meters
    ropeItem = "petrope",
    -- Ball
    petBallItem = "petball",

    --Pet Attack
    chaseDistance = 50.0,
    chaseIndicator = true, -- huge marker on hunted target head
    petAttackKeyCode = 49, --https://docs.fivem.net/docs/game-references/controls/
    petAttackKeyCodeDisplay = "PRESS ~g~F~w~ TO ATTACK TARGET", --Displaying Text
    -- PET Interact
    petInteractKeyCode = 38, -- [ E ] https://docs.fivem.net/docs/game-references/controls/
    -- Random animations
    RandomAnim = {
        ["dog"] = {
            -- {
            --     animName = "creatures@rottweiler@amb@",
            --     animID = "hump_loop_chop" 
            -- },
            {
                animName = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                animID = "idle_b" 
            },
            {
                animName = "creatures@rottweiler@amb@world_dog_barking@idle_a",
                animID = "idle_a" 
            },
            {
                animName = "creatures@rottweiler@amb@sleep_in_kennel@",
                animID = "sleep_in_kennel" 
            }, 
            
        },
        ["cat"] = {
            {
                animName = "creatures@cat@amb@world_cat_sleeping_ground@base",
                animID = "base" 
            }, 
            {
                animName = "creatures@cat@amb@world_cat_sleeping_ledge@base",
                animID = "base" 
            }, 
            -- {
            --     animName = "creatures@cat@step",
            --     animID = "step_lft" 
            -- }, 
            
        },
        ["bird"] = {
            {
                animName = "creatures@chickenhawk@amb@world_chickenhawk_feeding@base",
                animID = "base" 
            }, 
            {
                animName = "creatures@cormorant@amb@world_cormorant_standing@base",
                animID = "base" 
            },   
        },
        ["coguar"] = {
            { -- rest
                animName = "creatures@cougar@amb@world_cougar_rest@idle_a",
                animID = "idle_a" 
            }, 
            { -- getup
                animName = "creatures@cougar@getup",
                animID = "idle_a" 
            },   
        }  
    },
    --

    --[[ 
        petTexureID  => {
            Rottweiler => Hiç Rengi yok
            Shepherd => {
                [0] : Basic,
                [1] : White and black,
                [2] : Brown,
            } 
            Husky => {
                [0] : Basic,
                [1] : Gold Brown,
                [2] : White, 
            }
            Retriever => {
                [0] : Basic,
                [1] : Black,
                [2] : White Gold, 
                [3] : Brown, 
            }
            Cat => {
                [0] : Basic,
                [1] :  White And Black,
                [2] : Brown- like a redhead :D, 
            }
        }

    ]]
    
    AvailablePets = {
        {
            price = 11500000,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet. 
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Rottweiler",
            petLabel = "The Rottweiler is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the herds of the Roman armies crossing the alpine mountains and protected the people in the caravan.",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946161032708158/dog2.png?ex=65868b76&is=65741676&hm=2dc44632e0a328e7696f7b96f7021cce91cceac226df89247522d67a77e895ef&",
            pedHash = "a_c_chop",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "F", -- Pet'in cinsiyeti "M ya da F" tarzında olacaktır M = male   F = female
            petLevel = 5, -- Pet'i satın aldığınız zaman otomatik olarak olacak olan leveli
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },    
        {
            price = 12000000,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Popu",
            petLabel = "The Rottweiler is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the herds of the Roman armies crossing the alpine mountains and protected the people in the caravan..",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946159912812576/dog8.png?ex=65868b76&is=65741676&hm=b26931b4ed863e1a5d989ba7f223f1f6ae0769106907288ad6eb9c04fddab4ed&",
            pedHash = "a_c_westy",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "F",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        }, 
        {
            price = 13000000,
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 5, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 5, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            
            petName = "Retriever",
            petLabel = "Golden Retriever, dog breed. It originated in Scotland around the 19th century and was used as an aid in hunting activities at that time.",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946159480803378/dog5.png?ex=65868b76&is=65741676&hm=8bd4cc7332a9a3d66f1de6631bc6ade82fd637c402e4db7aed76e9220d0de314&",
            pedHash = "a_c_retriever",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.s
            petGender = "M",
            petBoughtAnim = true, -- With or without a purchase animation?
            petLevel = 10,
            listOf = "dog", -- which list to be on
        },  
        {
            price = 11000000,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Pug",
            petLabel = "The Rottweiler is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the herds of the Roman armies crossing the alpine mountains and protected the people in the caravan..",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946158553874472/dog4.png?ex=65868b76&is=65741676&hm=72eba7dbb7d0dc6b56b94bef696ef657efe332d0c20653f133fb46d5a5c1fd6e&",
            pedHash = "a_c_pug",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "F",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },       
        {
            price = 14000000,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Poodle",
            petLabel = "The Rottweiler is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the herds of the Roman armies crossing the alpine mountains and protected the people in the caravan..",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946158994260038/dog3.png?ex=65868b76&is=65741676&hm=134f04e6e152c1ff85b205902a6b6bb62c320870570dea0faa5c32d1457f1cfb&",
            pedHash = "a_c_poodle",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "F",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },     
        
        {
            price = 8000000,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "shepherd",
            petLabel = "The shepherd dog breed is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the flocks of the Roman armies crossing the Alpine mountains and protected the people in the caravan.",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946157442383993/dog7.png?ex=65868b76&is=65741676&hm=ef4881cc1092efd379c7f22edd355e89c04e81ed8b3a308c6ec2ca591dc68efc&",
            pedHash = "a_c_shepherd",
            petTexureID = 2, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "F",
            petLevel = 5,
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },
        {
            price = 15000000,
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 5, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 5, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            
            petName = "Rootti",
            petLabel = "Canis is a genus of mammals in the canine family, which includes dogs, coyotes and most wolves. Species in this genus are characterized by their medium to large size, large and well-developed skulls and dentition, long legs, and relatively short ears and wings..",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946161032708158/dog2.png?ex=65868b76&is=65741676&hm=2dc44632e0a328e7696f7b96f7021cce91cceac226df89247522d67a77e895ef&",
            pedHash = "a_c_husky",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "M",
            petLevel = 10,
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },    
        {
            price = 10000000,
            -- ped'i satın aldığınız zaman otomatik olarak gelecek olan değerler
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20

            petName = "Catty",
            petLabel = "Domestic cat, small, usually hairy, domesticated, carnivorous mammal. Usually kept as pets, they are called house cats, or simply cats if it is not necessary to distinguish them from other felines and small cats. People value the companionship of cats and their ability to hunt vermin and household pests.",
            petIMG = "https://cdn.discordapp.com/attachments/1003011594327957575/1182946161338875926/cat1.png?ex=65868b76&is=65741676&hm=7869408f9ca8e542846d3540c2c12044190728a28b3a5358def7c15dfbc4a70f&",
            pedHash = "a_c_cat_01",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.s
            petGender = "M",
            petBoughtAnim = true, -- With or without a purchase animation?
            petLevel = 10,
            listOf = "cat", -- which list to be on
        },  
    },
    --ORDER
    Orders = { -- In this section you can edit the orders that come directly to the pet, you can add different commands if you want.

        -- DOG
        {
            label = "Go Back",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:backPet", -- In the 1st list of arguments that come with the content of the pet system, there is "Animal Type", i.e. cat or dog, and the 2nd argument is the networkID of the animal, so the first two functions will be filled with whatever you type here.
            level = 1, -- at what level it can be applied
        },
        {
            label = "FOLLOW",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:followOwner", -- In the 1st list of arguments that come with the content of the pet system, there is "Animal Type", i.e. cat or dog, and the 2nd argument is the networkID of the animal, so the first two functions will be filled with whatever you type here.
            level = 1, -- at what level it can be applied
        },
        {
            label = "SIT",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:sit",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET UP",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:getup",
            level = 1, -- at what level it can be applied
        },
        {
            label = "SLEEP",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:sleep",
            level = 1, -- at what level it can be applied
        },

        --Cat 
        {
            label = "Go Back",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:backPet", -- In the 1st list of arguments that come with the content of the pet system, there is "Animal Type", i.e. cat or dog, and the 2nd argument is the networkID of the animal, so the first two functions will be filled with whatever you type here.
            level = 1, -- at what level it can be applied
        },
        {
            label = "FOLLOW",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:followOwner",
            level = 1, -- at what level it can be applied
        },
        {
            label = "SIT",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:sit",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET UP",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getup",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET INTO CAR",
            listOf = "dog", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getIntoCar",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET OFF THE CAR",
            listOf = "dog", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getOutCar",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET INTO CAR",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getIntoCar",
            level = 1, -- at what level it can be applied
        },
        {
            label = "GET OFF THE CAR",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getOutCar",
            level = 1, -- at what level it can be applied
        },
    },
    OrderAnim = {
        ["dog"] = {
            ["sex"] = {
                animName = "creatures@rottweiler@amb@",
                animID = "hump_loop_chop" 
            },
            ["sit"] = {
                animName = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                animID = "idle_b" 
            },
            ["bark"] = {
                animName = "creatures@rottweiler@amb@world_dog_barking@idle_a",
                animID = "idle_a" 
            },
            ["sleep"] = {
                animName = "creatures@rottweiler@amb@sleep_in_kennel@",
                animID = "sleep_in_kennel" 
            }, 
            ["getup"] = {
                animName = "creatures@rottweiler@amb@world_dog_sitting@exit",
                animID = "exit"
            }
            
        },
        ["cat"] = {
            ["sleep"] = {
                animName = "creatures@cat@amb@world_cat_sleeping_ground@base",
                animID = "base" 
            }, 
            ["getup"] = {
                animName = "creatures@cat@getup",
                animID = "getup_l" 
            },     
            ["sit"] = {
                animName = "creatures@cat@amb@world_cat_sleeping_ledge@base",
                animID = "base" 
            },       
        },
        -- ["bird"] = {
        --     {
        --         animName = "creatures@chickenhawk@amb@world_chickenhawk_feeding@base",
        --         animID = "base" 
        --     }, 
        --     {
        --         animName = "creatures@cormorant@amb@world_cormorant_standing@base",
        --         animID = "base" 
        --     },   
        -- }
    },
    
}
