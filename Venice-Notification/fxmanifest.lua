lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'
author 'Lucid#3604'
description 'codem'


client_scripts {
    'config.lua',
    'client.lua',

}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/*.mp3',

    'html/img/*.png',
}

export "Notify"



shared_script 'config.lua'




escrow_ignore {
	'config.lua',

}
dependency '/assetpacks'