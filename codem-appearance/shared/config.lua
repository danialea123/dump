---@diagnostic disable: duplicate-set-field
Config = {}
Config.Framework = 'oldesx'      -- esx, oldesx, qb, oldqb or autodetect
Config.ClothesAsItem = false -- only supports new codem-inventory
Config.SQL = "oxmysql"       -- oxmysql, ghmattimysql, mysql-async
Config.PedPage = false        -- false disabled true enabled ped page
Config.DefaultImage = 'https://cdn.discordapp.com/attachments/858833601226080286/1108105906132103178/testpp.png'
Config.CamCoolDown = 350     -- 0.350 seconds (a cool down to prevent the game from crashing when changing camera)
Config.PedReloadCommand = 'reloadped'
Config.ReloadCommand = 'reload'
Config.MoneyType = 'bank' -- cash, bank
Config.DefaultBucket = 0  -- default routing bucket
Config.Blacklisted = {
    male = {
        torso_1  = {535, 558, 645, 55, 186, 228, 314, 315, 320, 455, 514, 560, 561, 562, 564, 565, 566 , 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 579, 580, 581, 583, 585, 586, 587, 590 , 591, 592, 593, 597, 598, 600, 601, 602, 603, 604, 605, 606, 608, 609, 610, 611, 612, 613, 616, 618, 619, 620, 621, 622, 623, 624, 626, 632, 636, 641, 643, 644},
        tshirt_1 = {242, 292, 58, 59, 97, 122, 123, 125, 126, 127, 128, 129, 130,  153, 154, 155, 156, 181, 182, 212, 243, 244, 245, 247, 248, 249, 250, 251, 253, 254, 255, 256, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 271, 273, 274, 275, 277, 278, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 293},
        pants_1  = {84, 86, 87, 89, 90, 97, 98, 120, 121, 125, 168, 194, 244, 249, 251, 264},
        helmet_1 = {17, 38, 46, 115, 116, 117,  118, 119, 122, 123, 124, 125, 126, 137, 138, 144, 147, 148, 150, 205, 214 , 219, 220, 221, 222, 224, 226, 232, 241, 242, 243, 244, 245, 246, 248, 249, 251, 254, 255, 259, 262, 266, 269, 270, 271, 272, 274, 277, 278, 279},
        bags_1   = {119, 120, 122, 123, 124, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187},
        bproof_1 = {79, 105, 122, 53, 54, 55, 58 , 61, 63, 64, 65, 66, 67, 68, 69, 70, 71, 74, 80, 81, 82, 83, 85, 86, 87, 88, 89, 90, 92, 93, 94, 95, 97, 98, 99, 102, 103, 104, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121},
        chain_1  = {221, 178, 206, 211, 41, 125, 126, 127, 128, 133, 146, 147, 148, 185, 200, 225, 228 ,233 , 234, 235, 236, 240, 242, 245, 248, 249, 251, 252, 254, 255, 257},
        decals_1 = {57, 58, 72, 77, 78, 109, 193, 194, 203, 204, 205, 208, 209, 210, 211, 213, 214, 215, 216, 217, 218, 219, 220, 222, 223, 224, 225, 226, 227, 231, 233, 234, 235, 236, 237, 238},
        mask_1   = {261, 132, 269, 275}
    },
    female = {
        torso_1  = {688, 680, 48, 188, 256, 259, 261, 325, 326, 331, 488, 553, 574, 602, 618, 620, 621, 622, 629, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 651, 660, 661, 662, 663, 664, 683},
        tshirt_1 = {321, 344, 311, 35, 36, 105, 152, 153, 155, 156, 157, 158, 159, 161, 187, 189, 190, 191, 192, 219, 220, 275, 322, 323, 335, 342, 343},
        pants_1  = {291, 86,92,93,100,101,126,127,131},
        helmet_1 = {17, 45, 114, 115, 116, 117, 118, 121,  122, 123, 124, 125, 136, 137, 140, 143, 144,  146, 147, 149, 204, 213, 214, 221,  232, 233, 235, 236, 237},
        bags_1   = {148,161,162,163, 164,165,166,167,168,172},
        bproof_1 = {94, 69, 129, 131, 17, 18, 53, 54, 55, 58, 60, 61, 62, 66, 71, 72, 109, 110, 120, 121, 122, 125, 126, 127, 130, },
        chain_1  = {208, 205},
        mask_1   = {246, 208, 192},
        decals_1 = {65,79,81,86,87,237,238}
    },
}

Config.OnCharacterCreated = function()

end

Config.OnMenuOpen = function()
    TriggerEvent("mHud:HideHud")
    HidePlayers()
end

Config.OnMenuClose = function()
    TriggerEvent("mHud:ShowHud")
end

Config.TextUIHandler = 'default' -- default, esx_textui, qb_default_textui, custom
Config.Surgery = {
    price       = 500,
    coords      = {
        vector3(-648.53,319.04,88.02),
        vector3(1750.71,3635.12,34.85),
    },
    blip        = {
        size = 0.0,
        type = 102,
        color = 51,
        label = "Surgery",
    },
    openKey     = 38, -- https://docs.fivem.net/docs/game-references/controls/
    marker      = {
        enable = true,
        type = 0,
        size = 0.6,
        rgba = { 255, 0, 0, 255 }
    },
    drawText    = {
        enable = false,
        text = "PRESS ~r~ [E] ~w~ to open surgery"
    },
    textui      = {
        enable = false,
        text = "PRESS [E] to open surgery"
    },
    codemtextui = {
        enable = false,
        text = "PRESS [E] to open surgery",
        keytext = "E",
        theme = "thema-6"
    },
    okoktextui  = {
        enable = false,
        text = "PRESS [E] to open surgery",
        position = "left", -- 'right' / 'left'
        color =
        "lightblue"        -- 'lightblue' / 'darkblue' / 'lightgreen' / 'darkgreen' / 'lightred' / 'darkred' / 'lightgrey' / 'darkgrey'
    },
    ethTextUI   = {
        enable = false,
        header = "PRESS [E] to",
        text = "open surgery",
    },
}

Config.Barber = {
    prices      = {
        hair = 50,
        beard = 50,
        eyebrows = 50,
        makeup = 50,
        blush = 50,
        lipstick = 50,
    },
    coords      = {
        vector3(-814.3, -183.8, 36.6),
        vector3(136.8, -1708.4, 28.3),
        vector3(-1282.6, -1116.8, 6.0),
        vector3(1931.5, 3729.7, 31.8),
        vector3(1212.8, -472.9, 65.2),
        vector3(-32.9, -152.3, 56.1),
        vector3(-278.1, 6228.5, 30.7)
    },
    blip        = {
        size = 0.7,
        type = 71,
        color = 51,
        label = "Barber",
    },
    openKey     = 38, -- https://docs.fivem.net/docs/game-references/controls/
    marker      = {
        enable = true,
        type = 0,
        size = 0.6,
        rgba = { 255, 0, 0, 255 }
    },
    drawText    = {
        enable = false,
        text = "PRESS ~r~ [E] ~w~ to open barber shop"
    },
    textui      = {
        enable = false,
        text = "PRESS [E] to open barber shop"
    },
    codemtextui = {
        enable = false,
        text = "PRESS [E] to open barber shop",
        keytext = "E",
        theme = "thema-6"
    },
    okoktextui  = {
        enable = false,
        text = "PRESS [E] to open barber shop",
        position = "left", -- 'right' / 'left'
        color =
        "lightblue"        -- 'lightblue' / 'darkblue' / 'lightgreen' / 'darkgreen' / 'lightred' / 'darkred' / 'lightgrey' / 'darkgrey'
    },
    ethTextUI   = {
        enable = false,
        header = "PRESS [E] to",
        text = "open barber shop",
    },
}
Config.Tattoo = {
    list        = json.decode(LoadResourceFile(GetCurrentResourceName(), '/shared/tattooList.json')),
    coords      = {
        vector3(1322.6, -1651.9, 51.2),
        vector3(-1153.6, -1425.6, 4.9),
        vector3(322.1, 180.4, 103.5),
        vector3(-3170.0, 1075.0, 20.8),
        vector3(1864.6, 3747.7, 33.0),
        vector3(-293.7, 6200.0, 31.4)
    },
    blip        = {
        size = 0.7,
        type = 75,
        color = 1,
        label = "Tattoo Shop",
    },
    openKey     = 38, -- https://docs.fivem.net/docs/game-references/controls/
    marker      = {
        enable = true,
        type = 0,
        size = 0.6,
        rgba = { 255, 0, 0, 255 }
    },
    drawText    = {
        enable = false,
        text = "PRESS ~r~ [E] ~w~ to open tattoo shop"
    },
    textui      = {
        enable = false,
        text = "PRESS [E] to open tattoo shop"
    },
    codemtextui = {
        enable = false,
        text = "PRESS [E] to open tattoo shop",
        keytext = "E",
        theme = "thema-6"
    },
    okoktextui  = {
        enable = false,
        text = "PRESS [E] to open tattoo shop",
        position = "left", -- 'right' / 'left'
        color =
        "lightblue"        -- 'lightblue' / 'darkblue' / 'lightgreen' / 'darkgreen' / 'lightred' / 'darkred' / 'lightgrey' / 'darkgrey'
    },
    ethTextUI   = {
        enable = false,
        header = "PRESS [E] to",
        text = "open tattoo shop",
    },
}

Config.Clothing = {
    price       = 500,
    coords      = {
        {
            vector3(73.47,-1397.79,29.38),
            "binco"
        },
        {
            vector3(-703.8, -152.3, 36.4),
            "ponsonbys"

        },
        {
            vector3(-167.9, -299.0, 38.7),
            "ponsonbys"

        },
        {
            vector3(427.39,-801.3,29.49),
            "binco"

        },
        {
            vector3(-827.61,-1074.05,11.33),
            "binco"

        },
        {
            vector3(-1447.8, -242.5, 48.8),
            "ponsonbys"

        },
        {
            vector3(9.51,6514.28,31.88),
            "binco"

        },
        {
            vector3(123.6, -219.4, 53.6),
            "suburban"

        },
        {
            vector3(1695.46,4827.89,42.06),
            "binco"

        },
        {
            vector3(618.1, 2759.6, 41.1),
            "suburban"

        },
        {
            vector3(1191.73,2712.26,38.22),
            "binco"

        },
        {
            vector3(-1193.4, -772.3, 16.3),
            "suburban"

        },
        {
            vector3(-3172.5, 1048.1, 19.9),
            "suburban"

        },
        {
            vector3(-1106.53,2708.73,19.11),
            "binco"

        }
    },
    blip        = {
        size = 0.4,
        type = 73,
        color = 47,
        label = "Clothing Shop",
    },
    openKey     = 38, -- https://docs.fivem.net/docs/game-references/controls/
    marker      = {
        enable = true,
        type = 0,
        size = 0.6,
        rgba = { 255, 0, 0, 255 }
    },
    drawText    = {
        enable = false,
        text = "PRESS ~r~ [E] ~w~ to open clothing shop"
    },
    textui      = {
        enable = false,
        text = "PRESS [E] to open clothing shop"
    },
    codemtextui = {
        enable = false,
        text = "PRESS [E] to open clothing shop",
        keytext = "E",
        theme = "thema-6"
    },
    okoktextui  = {
        enable = false,
        text = "PRESS [E] to open clothing shop",
        position = "left", -- 'right' / 'left'
        color =
        "lightblue"        -- 'lightblue' / 'darkblue' / 'lightgreen' / 'darkgreen' / 'lightred' / 'darkred' / 'lightgrey' / 'darkgrey'
    },
    ethTextUI   = {
        enable = false,
        header = "PRESS [E] to",
        text = "open clothing shop",
    },
}



Config.Locale = {
    -- CharacterCreation
    ['characterCreationTitle'] = "CHARACTER CREATION",
    ['characterConfirmationText'] = "Are you sure about your character ?",
    ['characterConfirmationButtonText'] = "Yes, lets go!.",
    -- Menu's
    ['menuTitleDNA'] = "DNA",
    ['menuTitleBody'] = "BODY",
    ['menuTitleClothes'] = "CLOTHES",
    ['accoseriesTitle'] = 'ACCOSERIES',
    ['menuTitlePeds'] = "PEDS",
    ['menuTitleFace'] = "FACE",
    -- CharacterCreation

    ['heightTitle'] = "Height(165cm)",
    ['parentsTitle'] = "Parents",
    ['fatherTitle'] = "Father",
    ['motherTitle'] = "Mother",
    ['inheritanceTitle'] = "Inheritance Mix",
    ['DNANote'] = "Note : You can skip this part and choose your face type on body options as well.",
    ['skinTypeTitle'] = "Skin Type",
    ['skinMixTitle'] = "Skin Mix",
    ['chestHairTitle'] = "Chest Hair",
    ['typeTitle'] = "Type",
    ['colorTitle'] = "Color",
    ['bodyBlemishesTitle'] = "Body Blemishes",
    ['faceTypeTitle'] = "Face Type",
    ['faceMixTitle'] = "Face Mix",
    ['faceNote'] = "Note : Please be aware that if you adjust the face type you will lose your DNA faces.",
    ['faceFeaturesTitle'] = "Face Feautures",
    ['detailsTitle'] = "Details",
    ['strainsTitle'] = "Strains",
    ['makeupTitle'] = "Makeup",
    ['hairTitle'] = "Hair",
    ['hightlightTitle'] = "Highlight",
    ['hightlightColorTitle'] = "Highlight Color",
    ['faceStrainsTitle'] = "Face Strains",
    ['blemishesTitle'] = "Blemishes",
    ['noseTitle'] = "Nose",
    ['noseWidth'] = "Nose Width - 0",
    ['noseHeight'] = "Nose Height - 0",
    ['noseSize'] = "Nose Size - 0",
    ['noseBoneHeight'] = "Nose Bone Height",
    ['nosePeakHeight'] = "Nose Peak Height",
    ['noseTwistHeight'] = "Nose Bone Twist",
    ['eyebrowsTitle'] = "Eyebrows",
    ['eyebrowsHeight'] = "Eyebrows Height",
    ['eyebrowsDepth'] = "Eyebrows Depth",
    ['ageingTitle'] = "Ageing",
    ['cheeksTitle'] = "Cheeks",
    ['cheeksHeight'] = "Cheeks Bone Height ",
    ['cheeksBoneWidth'] = "Cheeks Bone Width ",
    ['cheeksWidth'] = "Cheeks Width ",
    ['eyesMouthTitle'] = "Eyes & Mouth",
    ['eyeColor'] = "Eye Color",
    ['eyesOpening'] = "Eyes Opening ",
    ['lipThickness'] = "Lip Thickness",
    ['beardTitle'] = "Beard",
    ['jawTitle'] = "Jaw",
    ['jawWidth'] = "Jaw Width ",
    ['jawSize'] = "Jaw Size ",
    ['chinTitle'] = "Chin",
    ['chinWidth'] = "Chin Lowering ",
    ['chinLength'] = "Chin Length ",
    ['chinSize'] = "Chin Length ",
    ['chinHole'] = "Chin Hole Size ",
    ['neckTitle'] = "Neck",
    ['neckThickness'] = "Neck Thickness ",
    ['sunDamageTitle'] = "Sun Damage",
    ['complexionTitle'] = "Complexion",
    ['moleFrecklesTitle'] = "Mole & Freckles",
    ['intensityTitle'] = "Intensity",
    ['blushTitle'] = "Blush",
    ['lipstickTitle'] = "Lipstick",
    ['pedsLocked'] = "Peds are locked.",
    ['pedsDescription1'] = "To open the ped menu please put the tbx id to input.",
    ['pedsDescription2'] = "You can buy the ped menu access from codem.tebex.io.",
    ['ambientMalesTitle'] = "Ambient Males",
    ['animalsTitle'] = "Animals",
    ['malesTitle'] = "Males",
    ['femalesTitle'] = "Females",
    -- Clothing Title's
    ['bincoTitle'] = "BINCO CLOTHING STORE",
    ['ponsonbysTitle'] = "PONSONBYS CLOTHING STORE",
    ['suburbanTitle'] = "SUBURBAN CLOTHING STORE",
    ['bobmuletTitle'] = "BM HAIR & BEAUTY",
    ['blazingTitle'] = "BLAZING TATTOO",
    ['jobTitle'] = "WARDROBE",
    ['wardrobeTitle'] = "WARDROBE",
    -- Clothing Categorie's
    ['jacketsTitle'] = "Tops & Jackets",
    ['undershirtTitle'] = "Undershirt",
    ['legsTitle'] = "Legs",
    ['maskTitle'] = "Mask",
    ['chainsTitle'] = "Scarfs & Chains",
    ['decalsTitle'] = "Decals",
    ['hatsTitle'] = "Hats & Helmet",
    ['glassessTitle'] = "Glassess",
    ['earaccTitle'] = "Ear Accoseries",
    ['watchesTitle'] = "Watches",
    ['braceletsTitle'] = "Bracelets",
    -- Clothing Option's
    ['variationsTitle'] = "Variations",
    ['modelTitle'] = "Model",
    ['variationTitle'] = "Variation",
    ['modelNumberText'] = "Go to model by typing the number...",
    -- Summary
    ['summaryTitle'] = "Summary",
    -- Wear & Unwear
    ['unwearTitle'] = "Wear & Unwear",
    -- Clothing Popup
    ['thanksText'] = "Thanks for choosing",
    ['saveOutfitText'] = "Save this outfit after i buy",
    ['giveOutfitNameText'] = "Give your outfit a name",
    ['bincoText'] = "Binco",
    ['ponsonbysText'] = "Ponsonbys",
    ['suburbanText'] = "Suburban",
    ['bobmuletText'] = "Bob Mulet",
    ['blazingText'] = "Blazing",
    -- Outfit's
    ['savedOutfits'] = "Saved Outfits",
    ['unpaidOutfits'] = "Unpaid Outfits",
    ['favouritesTitle'] = "Favourites",
    ['dailyOutfits'] = "Daily Outfits",
    ['sharedOutfits'] = "Shared Outfits",
    ['heistsOutfits'] = "Heists",
    ['savedForLaterOutfits'] = "Unpaid Outfits That Saved For Later",
    ['likedClothes'] = "Liked Clothes",
    -- Share Outfit's
    ['shareOutfitTitle'] = "Share Outfit",
    ['nearbyPlayers'] = "Nearby Players",
    ['sharingRequestTitle'] = "Outfit Sharing Request!",
    ['sharingRequestText'] = " wants to share their outift with you!",
    -- Create New Collection
    ['createNewTitle'] = "Create New Collection",
    ['collectionNameInput'] = "Collection Name",
    -- Barbershop
    ['barbershopTitle'] = "Bob Mulet Hair & Beauty",
    ['fadeTitle'] = "Fade",
    ['generalMakeupTitle'] = "General Makeup",
    ['totalPrice'] = "Total Price",
    -- Tattooshop
    ['tattooshopTitle'] = "Blazing Tattoo",
    ['torsoTitle1'] = "Torso",
    ['torsoTitle2'] = "Back",
    ['torsoTitle3'] = "Head",
    ['torsoTitle4'] = "Neck",
    ['torsoTitle5'] = "Left Arm",
    ['torsoTitle6'] = "Right Arm",
    ['torsoTitle7'] = "Left Leg",
    ['torsoTitle8'] = "Right Leg",
    ['removeTattooTitle'] = "Remove Tattoo",
    ['tattoosTitle'] = "Tattoos",
    -- Button's
    ['createCharacterButton'] = "CREATE CHARACTER",
    ['randomizeButton'] = "Randomize",
    ['unlockButton'] = "UNLOCK",
    ['saveForLaterButton'] = "Save for later",
    ['savedForLaterButton'] = "Saved for later",
    ['savedButton'] = "Saved",
    ['savedOutfitButton'] = "Saved Outfit",
    ['wearNowButton'] = "WEAR NOW",
    ['buyNowButton'] = "BUY NOW",
    ['payNowButton'] = "PAY NOW",
    ['acceptButton'] = "Accept",
    ['declineButton'] = "Decline",
    ['deleteButton'] = "Delete",
    ['createButton'] = "Create",
    ['cancelButton'] = "Cancel",
    ['applyTattooButton'] = "Apply Tattoo",

    ['colectionName'] = "Collection Name",
    ['model'] = 'Model',
    ['Veriation'] = 'Veriation',
    ['uncategorized'] = 'Uncategorized',
    ['deleteOutButton'] = 'Delete Outfit',

    ['allponsonbysCloting'] = 'All Ponsonbys Clothing',

    ['fheaderText1'] = 'Tops & Jackets',
    ['fheaderText2'] = 'Undershirt',
    ['fheaderText3'] = 'Hands & Arms',
    ['fheaderText4'] = 'Legs',
    ['fheaderText5'] = 'Shoes',

    ['sheaderText1'] = 'Masks',
    ['sheaderText2'] = 'Scarfs & Chains',
    ['sheaderText3'] = 'Decals',
    ['sheaderText4'] = 'Hats & Helmets',

    ['fheaderText6'] = 'Body Armour',
    ['fheaderText7'] = 'Bags & Parachutes',

    ['theaderText1'] = 'Glassess',
    ['theaderText2'] = 'Ear Accessories',
    ['theaderText3'] = 'Watches',
    ['theaderText4'] = 'Bracelets',

    ['removeBasket'] = 'Remove',
    ['addBasket'] = 'Add',

    ['noMoney'] = "You don't have money",
    ['nameEmpty'] = "Name can't be empty",



}
