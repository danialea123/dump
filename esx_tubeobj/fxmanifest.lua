lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'

description 'RTX HOTTUB OBJECT'

version '1.0'



this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_modern.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_modern_stairs.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_stairs.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_dark.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_dark_stairs.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_water_jets.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_water_calm.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_cover_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_cover_2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_darkblue.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_green.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_lightblue.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_lime.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_morepink.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_orange.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_pink.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_purple.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_red.ytyp'
data_file 'DLC_ITYP_REQUEST' 'sempre_rtxdev_jacuzzi_light_yellow.ytyp'


client_script "@sr_main/client/def.lua"

ui_page "coldre/html/index.html"

files {
	"coldre/html/index.html",
	"coldre/html/js/jquery-3.6.0.min.js",
	"coldre/html/img/Aim-Default.png",
	"coldre/html/img/Aim-Gangster.png",
	"coldre/html/img/Aim-HillBilly.png",
	"coldre/html/img/Holster-Back.png",
	"coldre/html/img/Holster-Cop.png",
	"coldre/html/img/Holster-Default.png",
	"coldre/html/img/Holster-Front.png",
	"coldre/html/img/Holster-FrontAgressive.png",
	"coldre/html/img/Holster-Leg.png",
	"coldre/html/js/listener.js",
	"coldre/html/style.css",
}

shared_script "coldre/config.lua"
server_script "coldre/server.lua"
client_script "coldre/client.lua"

















dependency '/assetpacks'