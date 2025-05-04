lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description "Jail Script With Working Job"

server_scripts {
	'@chat/async.lua',
	'@oxmysql/lib/MySQL.lua',
	"config.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}

ui_page('helpmenu/helpmenu.html')

files({
  'helpmenu/helpmenu.html',
  'helpmenu/libraries/*.*',
  'helpmenu/images/*.*',
  'helpmenu/css/*.*',
})

client_script {
    "client.lua",
    'helpmenu/handler.lua'
} 