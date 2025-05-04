lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games {'gta5'}

version '1.1.0'


client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	"bahamas/bahamas_cl.lua",
}

server_scripts {
	'@essentialmode/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	"bahamas/bahamas.lua",
}

ui_page "zo_cars/nui/index.html"

client_scripts {
	"zo_cars/client/*",
	"zo_cars/cfg/*"
}

server_scripts {
	"zo_cars/server/*",
	"zo_cars/cfg/*"
}

files {
	"zo_cars/nui/*",
	"zo_cars/nui/imgs/*",
	"zo_cars/nui/sounds/*"
}              

dependency 'essentialmode'