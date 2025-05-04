lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'


client_script "@sr_main/client/def.lua"

shared_scripts {
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	"streetclub/streetclub_sv.lua",
}

client_scripts {
	'client/*.lua',
    "cow/client.lua",
	"streetclub/streetclub_cl.lua",
}

client_script {
	'gasoline/main.lua',
}

ui_page "gasoline/nui/index.html"

files {
	'gasoline/nui/index.html',
	'gasoline/nui/script.js',
	'gasoline/nui/style.css',
	'gasoline/nui/img/*.png'
}