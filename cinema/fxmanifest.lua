lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'



shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua',
	"hostage/client.lua",
	"drug/client.lua",
	"engine/client.lua",
}

server_scripts {
	'server/*.lua',
	"hostage/server.lua",
	"drug/server.lua",
	"engine/server.lua",
}

ui_page 'lockpick/html/index.html'

client_scripts {
	'lockpick/client/main.lua',
}

shared_scripts {
    'lockpick/config.lua',
}

files {
	'lockpick/html/index.html',
	'lockpick/html/images/*.png',
	'lockpick/html/sounds/*.mp3',
	'lockpick/html/sounds/*.wav',
}

