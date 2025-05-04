lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"

description "Basic React (TypeScript) & Lua Game Scripts Boilerplate"
author "Project Error"
version '1.0.0'
repository 'https://github.com/project-error/fivem-react-boilerplate-lua'



games {
    "gta5",
    "rdr3"
}

ui_page 'web/build/index.html'

client_scripts {
    "config.lua",
    "client/**/*"
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/**/*"
}

files {
    'web/build/index.html',
    'web/build/**/*'
}