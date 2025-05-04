lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'

author "GENER4L#0547"

description 'Clothing Script for Pentagon Roleplay'

ui_page 'html/index.html'

files {
    'html/**/**.**',
    'qua_steamdeck.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'qua_steamdeck.ytyp'

client_script {
    "config.lua",
    "main/client.lua",
}

server_script { 
    '@mysql-async/lib/MySQL.lua',
    'settings.lua',
    "config.lua",
    "main/server.lua",
}

resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

escrow_ignore {
    'config.lua',
    'settings.lua'
}


dependency '/assetpacks'