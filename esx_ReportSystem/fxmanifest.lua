lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }


--
client_script "@sr_main/client/def.lua"

client_scripts {
	'config.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua',
}

ui_page 'crosshair/ui/ui.html'

files {
	'crosshair/ui/ui.html',
	'crosshair/ui/common/**.**'
}


client_scripts {
	"crosshair/config.lua",
	"crosshair/client/main.lua",
}