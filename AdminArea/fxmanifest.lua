lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

client_script "@sr_main/client/def.lua"

client_script "client.lua"
server_script "server.lua"

--ui_page 'pet/html/ui.html'

client_scripts {
	'pet/config.lua',
	--'pet/client.lua',
	"skate/config.lua",
	"skate/client/main.lua",
	"triad/triad_cl.lua",
}

server_script "skate/server/server.lua"

server_script "triad/triad.lua"

--[[files {
	'pet/html/ui.html',
	'pet/html/*.css',
	'pet/html/fonts/*.woff',
	'pet/html/*.js',
	'pet/html/img/*.png',
	'pet/html/img/*.jpg',
	'pet/html/img/*.gif',
}]]

