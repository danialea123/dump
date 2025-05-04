lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }
author 'tizzy'

ui_page "web/Index.html"


shared_scripts {
    "config.lua"
}

client_scripts {
    "cl_gunGame.lua",
}

server_scripts {
    "sv_gunGame.lua",
}

files {
    "web/*",
    "web/callingcards/*",
    "web/sounds/*",
    "peds.meta",
}

data_file "PED_METADATA_FILE" "peds.meta"