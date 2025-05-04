lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

version '1.2.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'badge/badge_sv.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'badge/badge_cl.lua',
}

dependencies {
	'essentialmode',
	'esx_billing'
}



ui_page "rps/web/build/index.html"

shared_scripts {
	"@ox_lib/init.lua",
	"rps/config.lua",
	"rps/locales.lua",
	"rps/shared/*.lua",
}

client_scripts {
	"rps/client/client.lua",
	"rps/client/modules/*.lua",
}

server_scripts {
	"rps/server/server.lua",
}

files {
	"rps/web/build/index.html",
	"rps/web/build/**/*",
}