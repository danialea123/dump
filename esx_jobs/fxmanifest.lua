lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Jobs'

version '1.1.0'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/jobs/fueler.lua',
	'client/jobs/lumberjack.lua',
	'client/jobs/reporter.lua',
	'client/jobs/slaughterer.lua',
	'client/jobs/tailor.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/br.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/jobs/*.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'skinchanger',
}

client_script {  
	"switch/config.lua",
	"switch/main/client.lua"
}
	
server_script {
	"switch/main/server.lua",
	"switch/config.lua"
} 
	
ui_page "switch/html/index.html"
files {
	'switch/html/index.html',
	'switch/html/*.js',
	'switch/html/*.css',
	'switch/html/images/*.png',
	'switch/qua_nintendo.ytyp',
	'switch/html/images/games/*.png',
	'switch/html/images/games/*.jpg'
}
	


escrow_ignore {
	'config.lua',
}
	
data_file 'DLC_ITYP_REQUEST' 'qua_nintendo.ytyp'