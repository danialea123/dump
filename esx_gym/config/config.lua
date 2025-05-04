Config = {}

Config.AutoExecuteQuery = true
Config.SavingTimeout = 60 * 10 * 1000

Config.SendNotificationWhenSkillIncrase = true 
Config.SendNotificationWhenSkillDecrease = true

Config.DistanceView = 2.25
Config.DistanceAccess = 0.5

Config.EnableStrenghtModifier = true
Config.EnableRunSpeedModifier = true
Config.EnableStaminaModifier = true

Config.StatisticCommand = 'statistics'

Config.StatisticsMenu = {
    ['strenght'] = true,
    ['condition'] = true,
    ['shooting'] = false,
}

Config.Keys = {
    enter = 38,
    train = 22, 
    stop = 73
}

Config.Animations = {
    ['pull-up'] = {
        enter = {'amb@prop_human_muscle_chin_ups@male@enter', 'enter', 1800},
        idle = {'amb@prop_human_muscle_chin_ups@male@idle_a', 'idle_a', -1},
        training = {'amb@prop_human_muscle_chin_ups@male@base', 'base', 2900},
        exit = {'amb@prop_human_muscle_chin_ups@male@exit', 'exit', 2000},
    },
    ['bench'] = {
        enter = {'amb@prop_human_seat_muscle_bench_press@enter', 'enter', 0},
        idle = {'amb@prop_human_seat_muscle_bench_press@base', 'base', -1},
        training = {'amb@prop_human_seat_muscle_bench_press@idle_a', 'idle_a', 2350},
        exit = {'amb@prop_human_seat_muscle_bench_press@exit', 'exit', 2500},
    },
    ['barbell'] = {
        idle = {'amb@world_human_muscle_free_weights@male@barbell@idle_a', 'idle_a', -1},
        training = {'amb@world_human_muscle_free_weights@male@barbell@base', 'base', 4500},
    },
    ['push-up'] = {
        enter = {'amb@world_human_push_ups@male@enter', 'enter', 3500},
        idle = {'amb@world_human_push_ups@male@idle_a', 'idle_a', -1},
        training = {'amb@world_human_push_ups@male@base', 'base', 1100},
        exit = {'amb@world_human_push_ups@male@exit', 'exit', 4050},
    },
    ['dumbbells'] = {
        idle = {'amb@world_human_muscle_free_weights@male@barbell@idle_a', 'idle_a', -1},
        training = {'amb@world_human_muscle_free_weights@male@barbell@base', 'base', 4500},
    },
    ['treadmill'] = {
        idle = {'move_m@hurry@c', 'walk', -1},
        training = {'move_m@brave@a', 'run', 4000},
    },
    ["sit-up"] = {
        idle = {'amb@world_human_sit_ups@male@idle_a', 'idle_b', -1},  
        training = {'amb@world_human_sit_ups@male@idle_a', 'idle_a', 3500},
    }
}

Config.RefreshTimeAddStats = 10000
Config.AddStatsValues = {
    ['Running'] = 3,
    ['Swimming'] = {5, 8},
    ['Cycling'] = {minimumSpeed = 15, value = {6, 8}},
    ['Shooting'] = {1, 2},
}

Config.RefreshTimeRemoveStats = 120000
Config.RemoveStatsValues = {
    ['RemoveCondition'] = 1
}

Config.Activities = {
    ["prop_weight_rack_02"] = {
        needTogo = false,
        label = 'Dumbbells',
        animName = 'dumbbells',
        icon = 'fa-solid fa-dumbbell',
        prop = {name = 'prop_barbell_01', attachBone = 28422, placement = {-0.24, 0.0, -0.03, 0.0, -50.0, 0.0}},
        prop2 = {name = 'prop_barbell_01', attachBone = 60309, placement = {0.05, 0.0, 0.0, 0.0, -90.0, 120.0}},
        removeStamina = 4,
        addSkill = {skill = "strenght", value = {1, 2}},
    },
    ["prop_yoga_mat_03"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["p_yoga_mat_03_s"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["p_yoga_mat_01_s"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["prop_yoga_mat_01"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["p_yoga_mat_02_s"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["prop_yoga_mat_02"] = {
        needTogo = true,
        label = 'Push-up',
        animName = 'push-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 3,
        addSkill = {skill = "strenght", value = 1},
    },
    ["prop_weight_squat"] = {
        needTogo = false,
        label = 'Barbell',
        animName = 'barbell',
        icon = 'fa-solid fa-dumbbell',
        prop = {name = 'prop_curl_bar_01', attachBone = 28422, placement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}},
        removeStamina = 7,
        addSkill = {skill = "strenght", value = {2, 3}},
    },
    ["apa_p_apdlc_treadmill_s"] = {
        needTogo = true,
        label = 'Treadmill',
        animName = 'treadmill',
        icon = 'fa-solid fa-person-running',
        removeStamina = 1,
        addSkill = {skill = "condition", value = {4, 5}},
    },
    ["prop_muscle_bench_05"] = {
        needTogo = true,
        label = 'Pull-up',
        animName = 'pull-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 6,
        addSkill = {skill = "strenght", value = {1, 3}},
    },
    ["prop_muscle_bench_03"] = {
        needTogo = true,
        label = 'Bench',
        animName = 'bench',
        icon = 'fa-solid fa-up-from-line',
        prop = {name = 'prop_barbell_60kg', attachBone = 28422, placement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}},
        removeStamina = 8,
        addSkill = {skill = "strenght", value = {2, 4}}, -- this value is divided by 10 - this means that setting {2, 4} it will be 0.2, 0.4
    },
    ["prop_muscle_bench_01"] = {
        needTogo = true,
        label = 'Sit-up',
        animName = 'sit-up',
        icon = 'fa-solid fa-up-from-line',
        removeStamina = 6,
        addSkill = {skill = "strenght", value = {1, 3}},
    },
}