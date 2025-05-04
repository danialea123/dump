lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'

description 'Diamond Vehicle Shop'
version '1.0.0'

shared_scripts {
    'config.lua',
    'utils.lua',
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

files {
    'html/*',
    'html/assets/*',
    'html/assets/carbrands/*'
}

ui_page 'html/index.html'

export 'GeneratePlate'
export 'GenerateDefaultPlate'
server_export 'GeneratePlate'
server_export 'GenerateDefaultPlate'