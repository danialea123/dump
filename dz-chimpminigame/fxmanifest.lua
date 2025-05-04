lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

author 'Danzo - https://discord.gg/8nFqCR4xVC'
description 'dz-chimpminigame'
version '1.0.0'

client_script 'client.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/js/*.js',
	'html/css/style.css',
	'html/img/bg.gif',
}


dependency '/assetpacks'