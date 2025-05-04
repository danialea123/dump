lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_script "@sr_main/client/def.lua"

client_scripts {
    "mapmanager_shared.lua",
    "mapmanager_client.lua",
}

server_scripts {
    "mapmanager_shared.lua",
    "mapmanager_server.lua",
}


server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"
