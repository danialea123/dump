lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'


shared_script {
    "@essentialmode/locale.lua",
    "locales/*.lua",
    "config.lua"
}

client_script { 
    "client/*.lua"
}

server_script { 
    "server/*.lua",
}

ui_page "html/index.html"

files {
    'html/**/**.**',
    'stream/unobox_diamondrp.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/unobox_diamondrp.ytyp'

