lua54 'yes'
client_script 'validation.lua'

-- shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "adamant"
 game "gta5"
client_scripts {
   "client/*.lua",

}
server_scripts {
   'Server/*.lua',
}
shared_scripts {
   '@essentialmode/locale.lua',
   'locales/en.lua',
   'Config.lua',
}
files {
   "ui/**/*",
}
ui_page "ui/index.html"
exports {
   'Alert'
}
escrow_ignore {
   'Config.lua',
   'Client/MiniMap.lua',
   'locales/*.lua',
}