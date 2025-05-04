lua54 'yes'


fx_version 'cerulean'
game 'gta5'

version '4.0.0'
author 'ayznnn#0667'
description 'WaveShield, the best Anti-Cheat that protects you from all cheaters.'
discord 'https://discord.com/invite/CXZwrZx'
website 'https://waveshield.xyz'



ui_page "web/index.html"

client_scripts {
    "resource/waveshield.lua",
    "resource/waveshield.js",
    "resource/client/main.lua",
}

server_scripts {
    "resource/waveshield.lua",
    "resource/waveshield.js",
    "resource/server/exports.lua",
    "resource/server/auth.lua",
    "resource/server/server.js",
}

files {
    "web/index.html"
}

data_file 'DLC_ITYP_REQUEST' 'stream/mads_no_exp_pumps.ytyp'

dependencies {
    "/server:7290",
    "/onesync",
}


-- client_script 'dist/client.js'
-- server_script 'dist/server.js'
-- ui_page 'dist/index.html'
-- files {
--     'dist/index.html',
--     'dist/ui.js'
-- }