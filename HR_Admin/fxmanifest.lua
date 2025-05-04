lua54 'yes'


client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

client_script "@sr_main/client/def.lua"

client_scripts {
  'client/*.lua',
}

server_scripts{
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua'
}