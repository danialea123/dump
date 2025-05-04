--RAINMAD SCRIPTS - discord.gg/sJG56ZsGrr - rainmad.com
Config = {}
    
Config['PetsSettings'] = {
    ['framework'] = {
        name = 'ESX', -- Only ESX, QB or STANDALONE.
        scriptName = 'es_ex', -- Only for QB users.
        eventName = 'esx:getSharedObject', -- Only for ESX users.
        standaloneCommand = 'spawnpet' -- For standlone servers, can change this command. Example: /spawnpet shark_boi
    },
    ['effectDelay'] = 2500, -- Milisecond
    ['refreshDelay'] = 5000, -- Milisecond
    ['startPosition'] = 'left', -- Default pet spawn position (left-right)
    ['menuCommand'] = 'pet', -- Open pet settings menu command (/pet)
    ['menuAlign'] = 'left', -- Menu align (left-center-right)
    ['locale'] = 'en', -- Locale on locales table (Example you can change this with test and you will test words in-game)
    ['locales'] = {
        ['en'] = {
            ['refresh'] = 'Refresh',
            ['effect'] = 'Effect',
            ['left'] = 'Left',
            ['right'] = 'Right',
            ['cooldown'] = 'You have to wait cooldown time',
            ['no_pet'] = 'You dont have pet',
            ['already_have'] = 'You already have pet'
        },
        ['test'] = {
            ['refresh'] = 'RefreshX',
            ['effect'] = 'EffectX',
            ['left'] = 'LeftX',
            ['right'] = 'RightX',
            ['cooldown'] = 'You have to wait cooldown timeX',
            ['no_pet'] = 'You dont have petX',
            ['already_have'] = 'You already have petX'
        },
    }
}

Config['Pets'] = {
    ['shark_boi'] = { -- Item name
        objectName = 'shark_boi',
        settings = {
            ['left'] = {
                attachPos = vector3(0.285, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.28, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_carwash',
                particleName = 'ent_amb_car_wash_jet_soap',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.2 -- Particle scale
            }
        }
    },
    ['monk_punk'] = { -- Item name
        objectName = 'monkey_punk',
        settings = {
            ['left'] = {
                attachPos = vector3(0.3, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.3, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_sm_counter',
                particleName = 'scr_sm_counter_chaff',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['monky'] = { -- Item name
        objectName = 'monky',
        settings = {
            ['left'] = {
                attachPos = vector3(0.3, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.3, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_armenian3',
                particleName = 'ent_anim_leaf_blower',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['fox'] = { -- Item name
        objectName = 'fox',
        settings = {
            ['left'] = {
                attachPos = vector3(0.32, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.32, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_rcbarry2',
                particleName = 'scr_exp_clown',
                particlePos = vector3(0.0, -0.1, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.05 -- Particle scale
            }
        }
    },
    ['questing_mouse'] = { -- Item name
        objectName = 'questing_mouse',
        settings = {
            ['left'] = {
                attachPos = vector3(0.32, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.32, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'core',
                particleName = 'ent_dst_gen_gobstop',
                particlePos = vector3(0.0, -0.1, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['armored_cat'] = { -- Item name
        objectName = 'armored_cat',
        settings = {
            ['left'] = {
                attachPos = vector3(0.30, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.30, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_bike_adversary',
                particleName = 'scr_adversary_foot_flames',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.75 -- Particle scale
            }
        }
    },
    ['hollow_knight'] = { -- Item name
        objectName = 'hollow_knight',
        settings = {
            ['left'] = {
                attachPos = vector3(0.30, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.30, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_bike_adversary',
                particleName = 'scr_adversary_foot_flames',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.75 -- Particle scale
            }
        }
    },
    ['knight_cat'] = { -- Item name
        objectName = 'knight_cat',
        settings = {
            ['left'] = {
                attachPos = vector3(0.30, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.30, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'core',
                particleName = 'sp_foundry_sparks',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['dino'] = { -- Item name
        objectName = 'dino',
        settings = {
            ['left'] = {
                attachPos = vector3(0.30, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.30, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'core',
                particleName = 'ent_dst_concrete_large',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['dino_student'] = { -- Item name
        objectName = 'dino_student',
        settings = {
            ['left'] = {
                attachPos = vector3(0.31, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.31, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_bike_adversary',
                particleName = 'scr_adversary_gunsmith_weap_change',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.3 -- Particle scale
            }
        }
    },
    ['pig_angel'] = { -- Item name
        objectName = 'pig_angel',
        settings = {
            ['left'] = {
                attachPos = vector3(0.31, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 154.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.31, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 154.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_rcbarry2',
                particleName = 'scr_clown_death',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.2 -- Particle scale
            }
        }
    },
    ['mick_mouse'] = { -- Item name
        objectName = 'mickey_mouse',
        settings = {
            ['left'] = {
                attachPos = vector3(0.30, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.30, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 174.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_bike_adversary',
                particleName = 'scr_adversary_gunsmith_weap_change',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.4 -- Particle scale
            }
        }
    },
    ['blossom'] = { -- Item name
        objectName = 'blossom',
        settings = {
            ['left'] = {
                attachPos = vector3(0.29, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.29, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 184.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_rcbarry2',
                particleName = 'scr_clown_bul',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['buttercup'] = { -- Item name
        objectName = 'buttercup',
        settings = {
            ['left'] = {
                attachPos = vector3(0.29, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.29, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 184.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_armenian3',
                particleName = 'ent_anim_leaf_blower',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.5 -- Particle scale
            }
        }
    },
    ['bubbles'] = { -- Item name
        objectName = 'bubbles',
        settings = {
            ['left'] = {
                attachPos = vector3(0.29, 0.0, 0.15), -- Object attach offset
                attachRot = vector3(18.0, 76.0, 184.0), -- Object attach rotation
            },
            ['right'] = {
                attachPos = vector3(0.29, 0.0, -0.15), -- Object attach offset
                attachRot = vector3(18.0, 100.0, 184.0), -- Object attach rotation
            },
            ['particle'] = {
                particleDict = 'scr_xs_dr',
                particleName = 'scr_xs_dr_emp',
                particlePos = vector3(0.0, 0.0, -0.05), -- Particle offset
                particleRot = vector3(0.0, 0.0, 0.0), -- Particle rotation
                particleScale = 0.3 -- Particle scale
            }
        }
    }
}