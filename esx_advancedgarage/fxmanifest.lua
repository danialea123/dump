lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Advanced Garage'

version '1.0.0'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/WantedVehicle.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

client_scripts {
	'top/client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'top/server/*.lua'
}

files {
	'top/web/ui.html',
	'top/web/styles.css',
	'top/web/scripts.js',
	'top/web/sound.wav',
	'top/web/img/*.png',
}

ui_page 'top/web/ui.html'

dependencies {
	'essentialmode',
}

