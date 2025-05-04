lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_scripts {
    '@chat/async.lua',
    '@oxmysql/lib/MySQL.lua',
    "config.lua",
    "server.lua",
}

client_scripts {
    "jaymenu.lua",
    "config.lua",
    "client.lua",
}

client_scripts {
    'gangscore/client/*.*',
}

server_scripts {
    'gangscore/server/*.*',
}

files {
    'gangscore/UI/**.*',
}

ui_page 'gangscore/UI/index.html'