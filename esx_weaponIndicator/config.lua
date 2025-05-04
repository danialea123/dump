Config = {
	DrawDistance				= 15,
	AttachmentStoreShowBlip 	= true,
	AttachmentStoreBlip 		= 175,
	AttachmentStoreBlipColor 	= 49,
	AttachmentStoreBlipName 	= 'Attachment Store',

	AttachmentStoreMarker 		= 27,
	AttachmentStoreMarkerSize 	= 1.2,
	AttachmentStoreMarkerColor 	= {252, 20, 20},

	AttachmentStoreItems = { -- Attachment Store Prices
		['weapon_clips'] = {
			{label = 'Pistol Bullet', 		 value = 'pistol_clip',	  price = 4000},
			{label = 'SMG Bullet', 			 value = 'smg_clip', 	  price = 4000},
			{label = 'Rifle Bullet', 		 value = 'rifle_clip', 	  price = 4000},
			{label = 'Shotgun Bullet', 		 value = 'shotgun_clip',  price = 4000},
			{label = 'Light Machine Bullet', value = 'lightsmg_clip', price = 4000}
		},
		['weapon_attachments'] = {
			{label = "Weapon Flashlight", 	value = "flashlight", 	price = 25000},
			{label = "Weapon Silencer",   	value = "weapon_suppressor", 	price = 50000},
			{label = "Weapon Extended Clip",value = "weapon_clip_extended", price = 100000},
			{label = "Grip", 			  	value = "grip", 			   	price = 60000}
		},
		['others'] = {
			{label = "Pich Gushti (LockPick)",  value = "lockpick", 	price = 40000},
		},
	},

	AttachmentStores = {
		vector3(247.8,-49.45,69.94),
		vector3(814.85,-2153.23,29.62),
		vector3(1696.35,3756.35,34.71),
		vector3(-327.9,6079.97,31.45),
		vector3(17.12,-1109.68,29.8),
		vector3(2566.63,298.68,108.73),
		vector3(-1114.15,2696.03,18.55),
		vector3(843.27,-1029.01,28.19),
		vector3(-1312.71,-394.07,36.7),
		vector3(-3165.03,1086.59,20.84),
		vector3(-658.65,-941.79,21.83),
	},

	Text = {
		['attachment_store_clip_category'] 			= 'Weapon Clips',
		['attachment_store_misc_category'] 			= 'Misc',
		['attachment_store_attachments_category']	= 'Weapon Attachments',
		['open_attachment_store'] 					= '[~r~E~w~] Open Attachment Store',
		['attachment_store_name'] 					= 'Attachment Store',
		['unsuccessful_purchase'] 					= 'You dont have enough money or available space',
		['successful_purchase'] 					= 'You bought {item}',
		['clip_full'] 								= 'Clip is full',
		['wrong_clip'] 								= 'Wrong clip for gun',
		['full_armor'] 								= 'Your armor is already full',
		['attachment_equipped'] 					= 'Attachment already equipped',
		['attachment_not_taken'] 					= 'Attachment cant be applied'
	}
}