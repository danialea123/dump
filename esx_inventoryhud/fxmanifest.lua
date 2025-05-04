lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
shared_script "@sr_main/shared/interference.lua"
fx_version "bodacious"
game "gta5"

ui_page "nui/index.html"

client_scripts {
	"client/client.lua",
	--"craft.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/Config_server.lua",
	"server/weight.lua",
	"server/drop.lua",
	"craft.lua"
}

files {
	"nui/*.*",
	"nui/app/*",
}