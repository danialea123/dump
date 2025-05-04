lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

dependency 'essentialmode'
dependency 'esx_blowtorch'


client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/client.lua'
}

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts { 'minigame/client/main.lua' }

ui_page 'minigame/html/index.html'
files { 'minigame/html/index.html', 'minigame/html/style.css', 'minigame/html/script.js' }
