lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'client/marker.lua'
}

dependencies {
	'essentialmode',
}

--[[
ui_page 'loot/html/main.html'

files {
	'loot/html/main.html',
	'loot/html/app.js',
	'loot/html/style.css',
	'loot/html/jquery-3.4.1.min.js',
    'loot/html/img/*.png',
    'loot/html/img/*.jpg',
    'loot/html/img/*.webp',
}

client_scripts{
    'loot/config.lua',
    'loot/client/client.lua',
}

server_scripts{
    'loot/config.lua',
    'loot/server/server.lua',
}
]]