lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'



author 'AJ'--amir jan sr_main et pub shod raf dadach, heyf, dige hata alan ammeye matin dark ham dare sr_main ro
version '2.1.1'

ui_page "html/index.html"

files {
    'client/modules/*.*',
    "html/*",
	"html/**/*",
}

client_scripts {
    --'client/exception.lua',
    "client/handler.lua",
    'client/def.lua',
    'boost/cl.lua',
}

server_script {
    'server/*.lua',
    'boost/sv.lua',
}

escrow_ignore {
    'client/modules/_v_12415.lua',
    'client/modules/_v_12191.lua',
    'client/exception.lua',
    'boost/cl.lua',
    'boost/sv.lua',
    'server/def.lua',
    'client/def.lua',
}