lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

client_scripts {
    'vs_client.lua',
}

server_scripts {
    'vs_server.lua',
}

server_exports  {
    'getHour'
}

exports {
    'GetTime'
}

client_script "NKvqf.lua"