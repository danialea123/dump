lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX Drugs'

version '2.0.0'



client_script "@sr_main/client/def.lua"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'event/sv_main.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/drugs.lua',
}

ui_page 'speed/html/index.html'

files {
    'speed/html/js/jquery.js',
    'speed/html/js/chart.js',
    'speed/html/fonts/FjallaOne.ttf',
    'speed/html/index.html',
}

client_scripts {
    'speed/config.lua',
    'speed/client/client.lua',
	'event/cl_main.lua',
}

dependencies {
	'essentialmode'
}