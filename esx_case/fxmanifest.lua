lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "adamant"

game "gta5"



shared_script { 
    'main/shared.lua'
}

client_script { 
    "main/client.lua"
}

server_script {
    "main/server.lua",
} 

ui_page "index.html"

files {
    'index.html',
    'web/*.*',
    'assets/**/*.*'
}
