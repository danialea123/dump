lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

version '1.0.0'
description 'lab-pet'
author 'zhonnz'

game 'gta5'


client_scripts {
    'client/functions.lua',
}

server_scripts {
	'sql.lua',
	'server/main.lua',
}

shared_scripts {
	'locales.lua',
	'config.lua',
}


ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/*.ttf',
    'nui/*.png',
    'nui/*.jpg',
    'nui/*.css',
	'stream/*.ytd',
    'nui/*.js',
    'nui/*.mp3',
    'nui/img/*.png',
    'nui/img/*.jpg',
    'nui/sounds/*.ogg',
    'nui/sounds/*.mp3',
}

escrow_ignore {
    'config.lua',
    'locales.lua',
    'sql.lua',
    'stream/*.ytd'
}


 