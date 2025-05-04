lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "adamant"

description "EyesStore"
author "Raider#0101"
version '1.0.0'
repository 'https://discord.com/invite/EkwWvFS'

game "gta5"

client_script { 
"main/client.lua"
}

server_script {
"main/server.lua"
} 

shared_script { 
    'main/shared.lua'
}

ui_page "index.html"

files {
    'index.html',
    'vue.js',
    'assets/**/*.*',
    'assets/font/*.otf', 
}

escrow_ignore { 'main/shared.lua' }


-- dependency '/assetpacks'