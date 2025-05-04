lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'Mechanic Job'
version '2.0.0'

client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
    'badges/badge_cl.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
    'badges/badge_sv.lua',
}

client_scripts {
	'notebook/client/*.lua'
}
server_scripts {
    'notebook/server/*.lua'
}

ui_page 'notebook/html/index.html'

files {
    'notebook/html/index.html',
    'notebook/html/script.js',
    'notebook/html/style.css',
    'notebook/html/*otf',
    'notebook/html/*png',
    'notebook/images/*.png',
    'notebook/images/*.jpg',
    'notebook/images/*.webp',
    'notebook/fonts/*.ttf',
    'notebook/fonts/*.otf'
}
