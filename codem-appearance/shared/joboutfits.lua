Config = Config or {}

Config.JobOutfitsInteraction = {
    data = {
        {
            coords = {
                vector3(438.0425, -991.7719, 29.68959)
            },
            allowedJobs = {"police"},
        },
        {
            coords = {
                vector3(300.26, -598.66, 43.28),
            },
            allowedJobs = {"ambulance"},
        },
		{
            coords = {
                vector3(-256.76, 6326.86, 32.41),
            },
            allowedJobs = {"ambulance"},
        },
		{
            coords = {
                vector3(-341.31, -162.09, 44.57),
            },
            allowedJobs = {"mechanic"},
        }
    },
    openKey = 38, -- https://docs.fivem.net/docs/game-references/controls/
    -- do not enable marker and drawText at the same time make sure only one of these is set to true
    marker = {
        enable = true,
        type = 0,
        size = 0.6,
        rgba = {255, 0, 0, 255}
    },
    drawText = {
        enable = false,
        text = "PRESS ~r~ [E] ~w~ to job wardrobe"
    },
	codemtextui  = {
        enable = false,
        text = "Para cambiarte de ropa",
        keytext = "E",
        theme = "thema-6"
    },
    textui = {
        enable = false,
        text = "Presiona [E] Para cambiarte de ropa"
    },
	okoktextui  = {
        enable = false,
        text = "PRESS [E] to open job wardrobe",
        position = "left", -- 'right' / 'left'
        color = "lightblue" -- 'lightblue' / 'darkblue' / 'lightgreen' / 'darkgreen' / 'lightred' / 'darkred' / 'lightgrey' / 'darkgrey'
    },
    ethTextUI  = {
        enable = false,
        header = "PRESS [E] to",
        text = "open job wardrobe",
    }
}




Config.JobOutfits = {
    ['police'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 19,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 55,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                    }
                },
                [2] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 3,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 19,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 55,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 3,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 19,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 55,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {

                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {


                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 3,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 8,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 3,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 19,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 55,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 3,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 8,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 3,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [5] = {
                    outfitLabel = 'SWAT',
                    outfitData = {
                        pants_1 = 130,
                        pants_2 = 0,
                        arms = 172,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 15,
                        bproof_2 = 0,
                        torso_1 = 336,
                        torso_2 = 3,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        chain_1 = 133,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 150,
                        helmet_2 = 3,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 52,
                        mask_2 = 0,


                    }
                }
            },
			-- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 19,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 55,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 0,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 3,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 24,
                        pants_2 = 0,
                        arms = 20,
                        arms_2 = 0,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 317,
                        torso_2 = 8,
                        shoes_1 = 51,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 58,
                        helmet_2 = 3,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [5] = {
                    outfitLabel = 'SWAT',
                    outfitData = {
                        pants_1 = 130,
                        pants_2 = 1,
                        arms = 172,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 15,
                        bproof_2 = 2,
                        torso_1 = 336,
                        torso_2 = 3,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        chain_1 = 133,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 150,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 52,
                        mask_2 = 0,

                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Female Short Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 48,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {

                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 3,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 48,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                    }

                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 3,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,



                    }
                }
            },
			-- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 48,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 3,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 8,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 48,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {

                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 3,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 8,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [5] = {
                    outfitLabel = 'Swat',
                    outfitData = {
                        pants_1 = 135,
                        pants_2 = 0,
                        arms = 213,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 17,
                        bproof_2 = 2,
                        torso_1 = 327,
                        torso_2 = 8,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 102,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 149,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 35,
                        mask_2 = 0,


                    }
                }
            },
			-- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 48,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 0,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 3,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        pants_1 = 133,
                        pants_2 = 0,
                        arms = 31,
                        arms_2 = 0,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        bproof_1 = 34,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 8,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                },
                [5] = {
                    outfitLabel = 'Swat',
                    outfitData = {
                        pants_1 = 135,
                        pants_2 = 1,
                        arms = 213,
                        arms_2 = 0,
                        tshirt_1 = 0,
                        tshirt_2 = 0,
                        bproof_1 = 17,
                        bproof_2 = 0,
                        torso_1 = 327,
                        torso_2 = 8,
                        shoes_1 = 52,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 149,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 35,
                        mask_2 = 0,

                    }
                }
            }
        }
    },
    ['mechanic'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Mecanico en Pruebas',
                    outfitData = {
                        pants_1 = 3,
                        pants_2 = 0,
                        arms = 56,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 128,
                        torso_2 = 0,
                        shoes_1 = 135,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 145,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                }
            },
			-- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Mecanico',
                    outfitData = {
                        pants_1 = 3,
                        pants_2 = 0,
                        arms = 56,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 128,
                        torso_2 = 0,
                        shoes_1 = 135,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 145,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Supervisor',
                    outfitData = {
                        pants_1 = 3,
                        pants_2 = 0,
                        arms = 56,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 128,
                        torso_2 = 0,
                        shoes_1 = 135,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 145,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                }
            },
			-- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Sub-Jefe',
                    outfitData = {
                        pants_1 = 3,
                        pants_2 = 0,
                        arms = 56,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 128,
                        torso_2 = 0,
                        shoes_1 = 135,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 145,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Jefe',
                    outfitData = {
                        pants_1 = 3,
                        pants_2 = 0,
                        arms = 56,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 128,
                        torso_2 = 0,
                        shoes_1 = 135,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = 145,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Mecanica en Pruebas',
                    outfitData = {
                        pants_1 = 58,
                        pants_2 = 0,
                        arms = 53,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 433,
                        torso_2 = 0,
                        shoes_1 = 141,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Mecanica',
                    outfitData = {
                        pants_1 = 58,
                        pants_2 = 0,
                        arms = 53,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 433,
                        torso_2 = 0,
                        shoes_1 = 141,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,


                    }
                }
            },
			-- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Supervisora',
                    outfitData = {
                        pants_1 = 58,
                        pants_2 = 0,
                        arms = 53,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 433,
                        torso_2 = 0,
                        shoes_1 = 141,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Sub-Jefa',
                    outfitData = {
                       pants_1 = 58,
                        pants_2 = 0,
                        arms = 53,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 433,
                        torso_2 = 0,
                        shoes_1 = 141,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            },
			-- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Jefa',
                    outfitData = {
                        pants_1 = 58,
                        pants_2 = 0,
                        arms = 53,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 433,
                        torso_2 = 0,
                        shoes_1 = 141,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,

                    }
                }
            }
        }
    },
    ['ambulance'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 89,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 353,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 89,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 353,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 89,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 353,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,


                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 89,
                        arms_2 = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 353,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 92,
                        arms_2 = 0,
                        tshirt_1 = 46,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 105,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,

                 }
             }
        },
		[5] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 92,
                        arms_2 = 0,
                        tshirt_1 = 46,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 105,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,

                 }
             }
        },
		[6] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 92,
                        arms_2 = 0,
                        tshirt_1 = 46,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 105,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,

                 }
             }
        },
		[7] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 92,
                        arms_2 = 0,
                        tshirt_1 = 46,
                        tshirt_2 = 0,
                        bproof_1 = 29,
                        bproof_2 = 0,
                        torso_1 = 105,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 157,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,

                 }
             }
        },
		[8] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {

                        pants_1 = 10,
                        pants_2 = 0,
                        arms = 81,
                        arms_2 = 0,
                        tshirt_1 = 46,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 105,
                        torso_2 = 0,
                        shoes_1 = 15,
                        shoes_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,

                 }
             }
        },
		},
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 120,
                        arms_2 = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 12,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 120,
                        arms_2 = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 12,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 120,
                        arms_2 = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 12,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 120,
                        arms_2 = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 12,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,

                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 119,
                        arms_2 = 0,
                        tshirt_1 = 94,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 9,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 =0,
                        decals_2 = 0,


                    }
                }
            },
			[5] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 119,
                        arms_2 = 0,
                        tshirt_1 = 94,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 9,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 =0,
                        decals_2 = 0,


                    }
                }
            },
			[6] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 119,
                        arms_2 = 0,
                        tshirt_1 = 94,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 9,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 =0,
                        decals_2 = 0,


                    }
                }
            },
			[7] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 119,
                        arms_2 = 0,
                        tshirt_1 = 94,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 9,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 =0,
                        decals_2 = 0,


                    }
                }
            },
			[8] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Uniforme',
                    outfitData = {
                        pants_1 = 67,
                        pants_2 = 0,
                        arms = 119,
                        arms_2 = 0,
                        tshirt_1 = 94,
                        tshirt_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        torso_1 = 9,
                        torso_2 = 0,
                        shoes_1 = 6,
                        shoes_2 = 0,
                        chain_1 = 141,
                        chain_2 = 0,
                        bags_1 = 0,
                        bags_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = -1,
                        glasses_1 = 12,
                        glasses_2 = 0,
                        mask_1 = 0,
                        mask_2 = 0,
                        decals_1 =0,
                        decals_2 = 0,


                    }
                }
            }
        }
    }
}