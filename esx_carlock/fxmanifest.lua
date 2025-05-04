lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'cerulean'
game 'gta5'


shared_script '@ox_lib/init.lua'

client_script "@sr_main/client/def.lua"

shared_script {
	'config.lua',
}

escrow_ignore 'config.lua'

client_scripts {
	'@essentialmode/locale.lua',
	'client.lua',
	"kharchangi/kharchang_cl.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	"kharchangi/kharchang.lua",
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/*.css',
	'html/index.js',
    'html/files/*.png',
    'html/files/*.jpg',
	'html/fonts/*.otf',
	'html/fonts/*.ttf'
}