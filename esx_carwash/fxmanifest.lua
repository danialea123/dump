lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Car Wash'

version '1.0.0'


client_script "@sr_main/client/def.lua"

client_scripts {
    'hookah/config.lua',
    'hookah/client.lua',
}

server_scripts {
    'hookah/config.lua',
    'hookah/server.lua',
	'rccar/server.lua',
}

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'rccar/client.lua',
}

ui_page "./ui/index.html"

files{
    "./ui/index.html",
    "./ui/main.css",
    "./ui/main.js",
}

client_script "client.lua"

dependency 'essentialmode'