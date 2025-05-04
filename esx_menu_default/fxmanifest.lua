lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Menu Default'

version '1.0.4'


client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/client/wrapper.lua',
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/*.otf',
	'html/img/*.png',

	'html/fonts/bankgothic.ttf'
}

dependencies {
	'essentialmode'
}