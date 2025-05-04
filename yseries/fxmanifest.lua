lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

description 'YSeries Bundle'
author 'TeamsGG Development'
version '0.99.4'



games {
  'gta5',
}

ui_page 'ui/build/index.html'
nui_callback_strict_mode 'true'

shared_scripts {
  '@ox_lib/init.lua',
  'config/*.lua',
  'shared/**/*.lua'
}

client_script 'client/**/*.lua'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/**/*.lua',
}

files {
  'sql/migrations/*.sql',
  'ui/build/**/*',
  'config/*.json',
  'sql/*.sql',
}

escrow_ignore {
  'config/**/*',

  'client/apps/framework/**/*.lua',
  'client/apps/framework/**/*.lua',
  'server/apps/framework/**/*.lua',
  'shared/*.lua',

  'client/custom/**/*.lua',
  'server/custom/**/*.lua',
  'server/apiKeys.lua'
}

dependencies {
  '/server:9549',
  '/onesync',
  'oxmysql',
  'ox_lib',
}

dependency '/assetpacks'