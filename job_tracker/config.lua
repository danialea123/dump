Config = {}

Config.selfBlip = true 
Config.useRflxMulti = false 
Config.useBaseEvents = false
Config.prints = false 

Config.font = {
    useCustom = false, 
    name = 'Russo One', 
}
Config.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'Shoma On-Duty Shodid', 
    offDutyText = 'Shoma Off-Duty Shodid'
}
Config.blipGroup = {
    renameGroup = false,
    groupName = '~b~Other Units'
}
Config.bigmapTags = true 
Config.blipCone = true 
Config.useCharacterName = true 
Config.usePrefix = true
Config.namePrefix = { 
}
Config.emergencyJobs = {
    ['police'] = {
        ignoreDuty = true,
        blip = {
            sprite = 60,
            color = 29,
            flashColors = {
                59,
                29
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['justice'] = true,
            ['artesh'] = true,
            ['medic'] = true,
        },
        gradePrefix = {
        [0] = 'Cadet',
        [1] = 'Police Officer I',
        [2] = 'Police Officer II',
        [3] = 'Police Officer III',
        [4] = 'Senior Lead Officer',
        [5] = 'Sergeant',
        [6] = 'Commander',
        [7] = 'Deputy Chief',
        [8] = 'Chief'
        }
    },
    ['sheriff'] = {
        ignoreDuty = true,
        blip = {
            sprite = 58,
            color = 28,
            flashColors = {
                59,
                28
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 28
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['justice'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['artesh'] = true,
            ['medic'] = true,
        },
        gradePrefix = {
        [0] = 'Cadet',
        [1] = 'Police Officer I',
        [2] = 'Police Officer II',
        [3] = 'Police Officer III',
        [4] = 'Senior Lead Officer',
        [5] = 'Sergeant',
        [6] = 'Commander',
        [7] = 'Division Chief',
        [8] = 'Chief'
        }
    },
    ['fbi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 484,
            color = 40,
            flashColors = {
                59,
                40
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 40
            }
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = false,
            ['sheriff'] = false,
            ['justice'] = true,
            ['artesh'] = false,
            ['forces'] = false,
            ['fbi'] = true,
        },
        gradePrefix = {
        [0] = 'Cadet',
        [1] = 'Police Officer I',
        [2] = 'Police Officer II',
        [3] = 'Police Officer III',
        [4] = 'Senior Lead Officer',
        [5] = 'Sergeant',
        [6] = 'Commander',
        [7] = 'Division Chief',
        [8] = 'Chief'
        }
    },
    ['artesh'] = {
        ignoreDuty = true,
        blip = {
            sprite = 480,
            color = 25,
            flashColors = {
                59,
                25
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 25
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['justice'] = true,
            ['artesh'] = true,
            ['forces'] = true
        },
        gradePrefix = {
        [0] = 'Cadet',
        [1] = 'Police Officer I',
        [2] = 'Police Officer II',
        [3] = 'Police Officer III',
        [4] = 'Senior Lead Officer',
        [5] = 'Sergeant',
        [6] = 'Commander',
        [7] = 'Division Chief',
        [8] = 'Chief'
        }
    },
    ['ambulance'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 75,
            flashColors = {
                75,
                75
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 75
            }
        },
        canSee = {
            ['police'] = true,
            ['justice'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['artesh'] = true,
            ['medic'] = true,
            ["ambulance"] = true,
        }
    },
    ['taxi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 198,
            color = 46,
            flashColors = {
                46,
                46
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 198,
                color = 46
            }
        },
        canSee = {
            ['taxi'] = true,
            ['justice'] = true,
            ["fbi"] = true,
            ['medic'] = true,
        }
    },
    ['mechanic'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 56,
            flashColors = {
                56,
                56
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 56
            }
        },
        canSee = {
            ['mechanic'] = true,
            ['justice'] = true,
            ["fbi"] = true,
            ['medic'] = true,
        }
    },
    ['benny'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 56,
            flashColors = {
                56,
                56
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 56
            }
        },
        canSee = {
            ['benny'] = true,
            ['justice'] = true,
            ["fbi"] = true,
            ['medic'] = true,
        }
    },
    ['justice'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 25,
            flashColors = {
                25,
                25
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 25
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['mechanic'] = false,
            ['justice'] = true,
            ['taxi'] = false,
            ['artesh'] = true,
            ['medic'] = true,
        }
    },
    ['weazel'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 56,
            flashColors = {
                56,
                56
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 56
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['justice'] = true,
            ['fbi'] = true,
            ["weazel"] = true,
            ['forces'] = true,
            ['medic'] = true,
        }
    },
    ['forces'] = {
        ignoreDuty = true,
        blip = {
            sprite = 468,
            color = 27,
            flashColors = {
                27,
                27
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 27
            }
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['justice'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['artesh'] = true,
            ['medic'] = true,
        }
    },
    ['medic'] = {
        ignoreDuty = true,
        blip = {
            sprite = 468,
            color = 57,
            flashColors = {
                57,
                57
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 57
            }
        },
        canSee = {
            ['police'] = true,
            ['justice'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['forces'] = true,
            ['artesh'] = true,
            ['medic'] = true,
            ["ambulance"] = true,
        }
    }
}