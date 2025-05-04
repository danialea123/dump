Config = {}

Config.Key = 38 -- [E] Key to open the interaction

Config.AutoCamPosition = false -- If true it'll set the camera position automatically

Config.AutoCamRotation = false -- If true it'll set the camera rotation automatically

Config.HideMinimap = true -- If true it'll hide the minimap when interacting with an NPC

Config.CameraAnimationTime = 3000 -- Camera animation time: 1000 = 1 second


Config.TalkToNPC = {
	{
		npc = 'ig_lestercrest', 										-- Website too see peds name: https://wiki.rage.mp/index.php?title=Peds
		header = '', 								-- Text over the name
		name = '', 										-- Text under the header
		dialog = '',						-- Text showm on the message bubble 
		coordinates = vector3(705.62,-964.13,29.4), 				-- coordinates of NPC
		heading = 215.2,											-- Heading of NPC (needs decimals, 0.0 for example)
		camOffset = vector3(0.0, 0.0, 0.0), 						-- Camera position relative to NPC 	| (only works if Config.AutoCamPosition = false)
		camRotation = vector3(0.0, 0.0, 0.0),						-- Camera rotation 					| (only works if Config.AutoCamRotation = false)
		interactionRange = 2.5, 									-- From how far the player can interact with the NPC
	},
}