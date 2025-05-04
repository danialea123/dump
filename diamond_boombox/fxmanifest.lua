lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "cerulean"
game "gta5"

description 'Boombox'
version '2.1.5'

data_file 'DLC_ITYP_REQUEST' 'stream/qua_jblspeaker.ytyp'



shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_scripts {
  'client/**.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/**.lua'
}

dependencies {
  'xsound',
  'ox_lib'
}

ui_page "gangCup/html/index.html"

files {
    "gangCup/html/*.js",
    "gangCup/html/*.css",
    "gangCup/html/index.html",
    "gangCup/html/img/*.png",
    'stream/qua_jblspeaker.ytyp',
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "gangCup/config.lua",
    "gangCup/server/*.lua",
    "dice/server.lua",
}

client_scripts {
    "gangCup/client/*.lua",
    "dice/client.lua",
}
