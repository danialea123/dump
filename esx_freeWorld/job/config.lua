Configs = {}

Configs.DisplayTime = 5000

-- Job Configsuration, ranks, and texts for the UI
Configs.Jobs = {
    ['catcafe'] = {
        label = "Cat Cafe",
        ranks = {2, 3, 4, 5},
        openText = "The Cat Cafe is OPEN",
        closeText = "The Cat Cafe is CLOSED"
    },
    ['triad'] = {
        label = "Triad Bar",
        ranks = {2, 3, 4, 5},
        openText = "The Triad Bar is OPEN",
        closeText = "The Triad Bar is CLOSED"
    },
    ['bahamas'] = {
        label = "Bahamas Club",
        ranks = {2, 3, 4, 5},
        openText = "The Bahamas Club is OPEN",
        closeText = "The Bahamas Club is CLOSED"
    },  
    ['artist'] = {
        label = "Cafe Artist",
        ranks = {2, 3, 4, 5},
        openText = "The Cafe Artist is OPEN",
        closeText = "The Cafe Artist is CLOSED"
    },
    ['kharchang'] = {
        label = "Restaurant Kharchang",
        ranks = {2, 3, 4, 5},
        openText = "The Restaurant Kharchang is OPEN",
        closeText = "The Restaurant Kharchang is CLOSED"
    },
    ['scardealer'] = {
        label = "CarDealer",
        ranks = {2, 3, 4, 5},
        openText = "The CarDealer is OPEN",
        closeText = "The CarDealer is CLOSED"
    },
    ['blackmarket'] = {
        label = "Semsari",
        ranks = {2, 3, 4, 5},
        openText = "The Semsari is OPEN",
        closeText = "The Semsari is CLOSED"
    },
-- Add more jobs here
}

-- Configsurable commands
Configs.OpenCommand = 'openjob'
Configs.CloseCommand = 'closejob'

-- Cooldown time for commands (in seconds)
Configs.CooldownTime = 300