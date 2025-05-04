lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

ui_page "web/darkside.html"


client_script "@sr_main/client/def.lua"

client_scripts {
	"src/uf_coins_cl.lua",
	"config/config.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"src/uf_coins_sv.lua",
	"config/config.lua"
}

files {
	"web/*",
	"web/**/*"
}