lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

description 'ESX CustomItems'

version '1.0.0'

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

client_script 'heli/heli_client.lua'

files {
    'heli/custom_ui.html',
    'heli/ui.css',
    'heli/noise.png'
}

ui_page 'heli/custom_ui.html'

dependencies {
	'essentialmode'
}

