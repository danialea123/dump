lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

games { 'gta5' }


client_scripts {
    "client.lua"
}

server_scripts {
    "server.lua",
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/styles.css",
    "html/script.js",
}