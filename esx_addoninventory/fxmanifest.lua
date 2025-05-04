lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX Addon Inventory'

version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/addoninventory.lua',
	'server/main.lua'
}

ui_page 'ui/index.html'

files {
    'ui/style.css',
    'ui/app.js',
    'ui/gift.png',
    'ui/index.html',
}

client_scripts {
    '@essentialmode/locale.lua',
    '/client/*.lua',
    "unit/client.lua",
    "onlyup/client.lua",
}

server_script {
    '@essentialmode/locale.lua',
    '/servers/*.lua',
    "unit/server.lua",
    "onlyup/server.lua",
}

dependency 'essentialmode'






