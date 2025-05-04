lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
games { 'rdr3', 'gta5' }

mod 'allhousing'
version '1.0.7'

ui_page 'furni/nui/furniture.html'


client_script "@sr_main/client/def.lua"

client_scripts {
  'furni/config.lua',
  'furni/src/utils.lua',
  'furni/src/client/disablecontrols.lua',
  'furni/src/client/main.lua',
  'apartment/main.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'furni/config.lua',
  'furni/credentials.lua',
  'furni/src/utils.lua',
  'furni/src/server/main.lua',
}

files {
  'furni/nui/furniture.html',
  'furni/nui/aim.png',
  'furni/nui/back.png',
  'furni/nui/cancel.png',
  'furni/nui/dec.png',
  'furni/nui/down.png',
  'furni/nui/edit.png',
  'furni/nui/exit.png',
  'furni/nui/forward.png',
  'furni/nui/icon1.png',
  'furni/nui/inc.png',
  'furni/nui/left.png',
  'furni/nui/remove.png',
  'furni/nui/right.png',
  'furni/nui/slide.png',
  'furni/nui/test.png',
  'furni/nui/up.png',

  'furni/nui/affirm-detuned.wav',
  'furni/nui/affirm-melodic2.wav',
  'furni/nui/affirm-melodic3.wav',
  'furni/nui/alert-echo.wav',
  'furni/nui/camera_click.wav',
  'furni/nui/click-analogue-1.wav',
  'furni/nui/click-round-pop-1.wav',
  'furni/nui/click-round-pop-2.wav',
  'furni/nui/click-round-pop-3.wav',
}

client_scripts {
  -- NATIVE UI DEPENDENCY
  -- COMMENT OUT IF NOT USING NATIVEUI
  --'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',

  -- SOURCE
  'config.lua',
  'houses.lua', 
  'labels.lua', 

  'src/utils.lua',  

  'src/client/framework/framework_functions.lua',
  'src/client/menus/menus.lua',
  'src/client/menus/menus_native.lua',
  'src/client/menus/menus_esx.lua',

  'src/client/functions.lua',
  'src/client/main.lua',
  'src/client/commands.lua',
  "pet/client.lua",
}

server_scripts {
  -- MYSQL DEPENDENCY
  '@oxmysql/lib/MySQL.lua',

  -- SOURCE
  'config.lua',
  'credentials.lua',
  'houses.lua',  
  'labels.lua', 

  'src/utils.lua',
  
  'src/server/framework/framework_functions.lua',

  'src/server/functions.lua',
  'src/server/main.lua',
  'src/server/commands.lua',
  "pet/server.lua",
}

exports {
  'getClosestHome'
}

server_exports {
  "GetHouse",
  "resetHouses"
}

files {
	"stream/shellpropsv3.ytyp",
	"stream/shellpropsv4.ytyp",
	"stream/shellpropv2s.ytyp",
	"stream/shellpropsv5.ytyp",
	"stream/shellprops.ytyp",
	"stream/shellpropsv7.ytyp",
	"stream/shellpropsv8.ytyp",
	"stream/shellpropsv10.ytyp",
	"stream/shellpropsv9.ytyp"
}

data_file 'DLC_ITYP_REQUEST' 'shellprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv5.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv7.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv8.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv10.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv9.ytyp'

this_is_a_map 'yes'

fx_version 'adamant'
games {'gta5'}

