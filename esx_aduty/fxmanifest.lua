lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

server_scripts {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

client_script "client.lua"


