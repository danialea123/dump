lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Vangelico Robbery'


client_script "@sr_main/client/def.lua"

version '2.0.0'

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/*.lua'
}

dependencies {
	'essentialmode'
}

client_scripts {
	"chat/client/*",
}

server_scripts {
	"chat/server/*",
}

ui_page 'chat/html/index.html'

files {
	'chat/html/index.html',
	'chat/html/style.css',
	'chat/html/app.js',
	'chat/html/sounds/select.wav'
}