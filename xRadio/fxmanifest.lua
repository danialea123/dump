lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"

description "codem store"
author "canrow#8946"
version "1.4.0"



game "gta5"

ui_page "resources/build/index.html"


client_script "@sr_main/client/def.lua"

shared_script "Settings.lua"

client_script "client.lua"

server_script "@oxmysql/lib/MySQL.lua"
server_script "server.lua"

files {
    "resources/build/index.html",
    "resources/build/**/*"
}

escrow_ignore { 
    "Settings.lua",
    "client.lua",
    "server.lua",
}

dependency '/assetpacks'