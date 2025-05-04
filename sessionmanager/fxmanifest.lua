lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_script 'server/host_lock.lua'
client_scripts{
  'client/empty.lua'
}
