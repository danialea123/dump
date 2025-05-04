lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

ui_page "nui/index.html"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/*.lua",
}

files {
	"nui/index.html",
	"nui/vue.js",
	"nui/style.css",
	"nui/css/*.css",
	"nui/fonts/*.*",
	"nui/images/*.png",
	"nui/images/**/*.png",
}