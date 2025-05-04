---@diagnostic disable: param-type-mismatch, undefined-field, missing-parameter, lowercase-global, lowercase-global
Config={}
Config.UseBlipToAccessMarket=true
Config.MarketCommand="market"
Config.OpenMarketKey=38
Config.ShowFloorBlips=true
Config.UseOkokTextUI=false
Config.ShowBlipsOnMap=true
Config.BlipCoords={
	{x= 137.73, y = -1782.96, z = 28.73,radius=2,blipId=78,blipColor=3,blipScale=0.9,blipText="Marketplace",showMarkerRadius=20,MarkerID=29},
	{x= 1698.91, y = 3780.77, z = 33.71,radius=2,blipId=78,blipColor=3,blipScale=0.9,blipText="Marketplace",showMarkerRadius=20,MarkerID=29},
}
Config.BlackmarketAllowedJobs={{job="police",grade={"boss","rookie"}},{job="ballas",grade={}}}
Config.UseDirtyMoneyOnBlackmarket=false;
Config.Blackmarket={
	{'WEAPON_PISTOL',true},
	{'WEAPON_PISTOL50',true},
	{'WEAPON_HEAVYPISTOL',true},
	{'WEAPON_SWITCHBLADE',true},
	{'WEAPON_ASSAULTRIFLE',true},
	{'WEAPON_ADVANCEDRIFLE',true},
	{'WEAPON_BULLPUPRIFLE',true},
	{'WEAPON_ASSAULTSMG',true},
	{'WEAPON_SMG',true},
}
Config.BlacklistItems={}
Config.BlacklistVehicles={}

ESX=nil
local a=nil
local b=false
local c=false
Citizen.CreateThread(function()
	while ESX==nil do 
		TriggerEvent("esx:getSharedObject",function(d) ESX=d end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job==nil do 
		Citizen.Wait(10)
	end
	PlayerData=ESX.GetPlayerData()
	a=PlayerData.job 
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(e)
	a=e 
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	for f,g in ipairs(Config.BlipCoords)do 
		local h=AddBlipForCoord(g.x,g.y,g.z)
		SetBlipSprite(h,g.blipId)
		SetBlipDisplay(h,4)
		SetBlipScale(h,0.6)
		SetBlipColour(h,g.blipColor)
		SetBlipAsShortRange(h,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(g.blipText)
		EndTextCommandSetBlipName(h)
	end 
end)

local poss = {
	vector3(137.73,-1782.96,29.73),
	vector3(1698.91,3780.77,34.71),

	vector3(4435.18,-4483.94,4.3),
	vector3(5590.33,-5226.3,14.37),
	vector3(4910.07,-5829.51,28.13),
}

local i=false
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(2)
		local j = true
		local coord = GetEntityCoords(PlayerPedId())
		for k, v in pairs(poss) do
			if #(coord - v) < 10 then 
				j=false
				DrawMarker(29, v,0,0,0,0,0,0,0.75,0.75,0.75,31,94,255,155,0,0,2,1,0,0,0)
				if #(coord - v) < 1 then 
					i=true
					ESX.ShowHelpNotification('~INPUT_CONTEXT~ To open the marketplace')
				end 
			end
		end
		if j then 
			i=false
			Citizen.Wait(710)
		end 
	end 	
end)

local spam = false

AddEventHandler("onKeyDown",function(k)
	if k=="e"then 
		if i then 
			if GetVehiclePedIsUsing(PlayerPedId())==0 then 
				if spam then return end
				TriggerEvent('okokMarketplace:open')
				spam = true
				Citizen.SetTimeout(3000, function()
					spam = false
				end)
			else 
				exports['okokNotify']:Alert("CRAFTING","You can't access the marketplace inside a vehicle",5000,'error')
			end 
		end 
	end 
end)

function isNear()
    local data = exports.gangprop:GetInfoData()
    local now = GetEntityCoords(PlayerPedId())
	local near = false
    if data and data.armory then
        if data.market then
            local coord = vector3(data.market.x, data.market.y, data.market.z)
            if #(now.xy - coord.xy) >= 10 then
				for k, v in pairs(poss) do
					if #(v.xy - now.xy) <= 10 then
						near = true
						break
					end
				end
            else
                return true
            end
        end
    end
    for k, v in pairs(poss) do
        if #(v.xy - now.xy) <= 10 then
            near = true
            break
        end
    end
    return near
end

RegisterNetEvent("okokMarketplace:open")
AddEventHandler("okokMarketplace:open",function()
	if not isNear() then
        
        return
    end
	local l={}
	local m={}
	local n={}
	local o=false
	if not b then 
		ESX.TriggerServerCallback("okokMarketplace:getItems",function(p,q,r)
			for f,g in ipairs(p)do 
				local s=true
				for t,u in ipairs(Config.BlacklistVehicles)do 
					if GetDisplayNameFromVehicleModel(g.vehicle.model)==u then 
						s=false
						break 
					end 
				end
				if s then 
					table.insert(l,{vehicle=g.vehicle,plate=g.plate,name=GetDisplayNameFromVehicleModel(g.vehicle.model)})
				end 	
			end
			for f,g in ipairs(q)do 
				local s=true
				local v=false
				if g.count>0 then 
					for t,u in ipairs(Config.BlacklistItems)do 
						if g.name==u then s=false
							break 
						end 
					end
					if s then 
						table.insert(m,{id=g.name,label=g.label,count=g.count})
					else 
						for t,u in ipairs(Config.Blackmarket)do 
							if g.name==u[1]and not u[2]then 
								v=true
								break 
							end 
						end
						if v then 
							table.insert(n,{id=g.name,label=g.label,count=g.count,type="item"})
						end 
					end 
				end 
			end
			for f,g in ipairs(r)do 
				for t,u in ipairs(Config.Blackmarket)do 
					if g.name==u[1]and u[2]then 
						table.insert(n,{id=g.name,label=g.label,count=1,type="weapon"})
					end 	
				end 
			end
			ESX.TriggerServerCallback("okokMarketplace:getAds",function(w,x,y,z)
				local A={}
				local B={}
				local C={}
				local D={}
				for f,g in ipairs(w)do
					if g.author_identifier~=z then 
						if not g.sold then 
							table.insert(A,g)end else table.insert(D,g)
						end 
					end
					for f,g in ipairs(x)do 
						if g.author_identifier~=z then 
							if not g.sold then 
								table.insert(B,g)
							end 
						else 
							table.insert(D,g)
						end 
					end
					for f,g in ipairs(y)do
						if g.author_identifier~=z then 
							if not g.sold then 
								table.insert(C,g)
							end 
						else 
							table.insert(D,g)
						end 
					end
					for f,g in ipairs(Config.BlackmarketAllowedJobs)do 
						if g.job==a.name then 
							if g.grade[1]==nil then 
								o=true
								break 
							else 
								for t,u in ipairs(g.grade)do 
									if u==a.grade_name then 
									o=true
									break 
								end 
							end
							break 
						end
					end 
				end
				b=true
				SetNuiFocus(true,true)
				SendNUIMessage({action='openVehicleMarket',vehicles=l,vehAds=A,items=m,itemsAds=B,blackmarket=n,blackmarketAds=C,myAds=D,accessBlackmarket=o})
			end)
		end)
	end 
end)

-- RegisterNetEvent("okokMarketplace:updateItems")
-- AddEventHandler("okokMarketplace:updateItems",function()
-- 	Citizen.Wait(100)
-- 	ESX.TriggerServerCallback("okokMarketplace:getAds",function(w,x,y,z)
-- 		local B={}
-- 		for f,g in ipairs(x)do 
-- 			if g.author_identifier~=z and not g.sold then 
-- 				table.insert(B,g)
-- 			end 
-- 		end
-- 		SendNUIMessage({action='updateItems',itemsAds=B})
-- 	end)
-- end)

-- RegisterNetEvent("okokMarketplace:updateBlackmarket")
-- AddEventHandler("okokMarketplace:updateBlackmarket",function()
-- 	Citizen.Wait(100)
-- 	ESX.TriggerServerCallback("okokMarketplace:getAds",function(w,x,y,z)
-- 		local C={}
-- 		for f,g in ipairs(y)do 
-- 			if g.author_identifier~=z and not g.sold then 
-- 				table.insert(C,g)
-- 			end 
-- 		end
-- 		SendNUIMessage({action='updateBlackmarket',blackmarketAds=C})
-- 	end)
-- end)

RegisterNetEvent("okokMarketplace:updateMyAds")
AddEventHandler("okokMarketplace:updateMyAds",function()
	Citizen.Wait(100)
	ESX.TriggerServerCallback("okokMarketplace:getAds",function(w,x,y,z)
		local D={}
		for f,g in ipairs(w)do 
			if g.author_identifier==z then 
				table.insert(D,g)
			end 
		end
		for f,g in ipairs(x)do 
			if g.author_identifier==z then 
				table.insert(D,g)
			end 
		end
		for f,g in ipairs(y)do 
			if g.author_identifier==z then 
				table.insert(D,g)
			end 
		end
		SendNUIMessage({action='updateMyAds',myAds=D})
	end)
end)

RegisterNetEvent("okokMarketplace:updateMyAdsTable")
AddEventHandler("okokMarketplace:updateMyAdsTable",function()
	Citizen.Wait(100)
	ESX.TriggerServerCallback("okokMarketplace:getAds",function(w,x,y,z)
		local D={}
		for f,g in ipairs(w)do 
			if g.author_identifier==z then 
				table.insert(D,g)
			end 
		end
		for f,g in ipairs(x)do 
			if g.author_identifier==z then 
				table.insert(D,g)
			end 
		end
		for f,g in ipairs(y)do 
			if g.author_identifier==z then 
				table.insert(D,g)

			end 
		end
		SendNUIMessage({action='updateMyAdsTable',myAds=D})
	end)
end)

RegisterNetEvent("okokMarketplace:updateItemsDropdown")
AddEventHandler("okokMarketplace:updateItemsDropdown",function()
	Citizen.Wait(100)
	local m={}
	ESX.TriggerServerCallback("okokMarketplace:getItems",function(p,q,r)
		for f,g in ipairs(q)do 
			local s=true
			if g.count>0 then 
				for t,u in ipairs(Config.BlacklistItems)do 
					if g.name==u then 
						s=false
						break 
					end 
				end
				if s then 
					table.insert(m,{id=g.name,label=g.label,count=g.count})
				end 
			end 
		end
		SendNUIMessage({action='updateItemsDropdown',items=m})
	end)
end)

RegisterNetEvent("okokMarketplace:updateBlackmarketDropdown")
AddEventHandler("okokMarketplace:updateBlackmarketDropdown",function()
	Citizen.Wait(100)
	local n={}
	ESX.TriggerServerCallback("okokMarketplace:getItems",function(p,q,r)
		for f,g in ipairs(q)do 
			local s=true
			local v=false
			if g.count>0 then 
				for t,u in ipairs(Config.BlacklistItems)do 
					if g.name==u then 
						s=false
						break 
					end 
				end
				if not s then 
					for t,u in ipairs(Config.Blackmarket)do 
						if g.name==u[1]and not u[2]then 
							v=true
							break
						end 
					end
					if v then 
						table.insert(n,{id=g.name,label=g.label,count=g.count,type="item"})
					end 
				end 
			end 
		end
		for f,g in ipairs(r)do 
			for t,u in ipairs(Config.Blackmarket)do 
				if g.name==u[1]and u[2]then 
					table.insert(n,{id=g.name,label=g.label,count=1,type="weapon"})
				end 
			end 
		end
		SendNUIMessage({action='updateBlackmarketDropdown',blackmarket=n})
	end)
end)

RegisterNUICallback("action",function(E,F)
	if E.action=="close"then 
		b=false
		SetNuiFocus(false,false)
	elseif E.action=="placeAd"then 
		if E.window=="vehicles"then 
			ESX.TriggerServerCallback("okokMarketplace:phone",function(G)
				if E.desc==""then 
					local H="Nothing to add"
					TriggerServerEvent('okokMarketplace:addVehicle',E.item,E.price,H,G)
				else 
					TriggerServerEvent('okokMarketplace:addVehicle',E.item,E.price,E.desc,G)
				end 
			end)
		elseif E.window=="items"then 
			ESX.TriggerServerCallback("okokMarketplace:phone",function(G)
				if E.desc==""then 
					local H="Nothing to add"
					TriggerServerEvent('okokMarketplace:addItem',E.item,tonumber(E.amount),E.price,H,G)
				else 
					TriggerServerEvent('okokMarketplace:addItem',E.item,tonumber(E.amount),E.price,E.desc,G)	
				end 
			end)
		elseif E.window=="blackmarket"then 
			ESX.TriggerServerCallback("okokMarketplace:phone",function(G)
				if E.desc==""then 
					local H="Nothing to add"
					TriggerServerEvent('okokMarketplace:addBlackmarket',E.item,E.price,H,G,tonumber(E.amount))
				else 
					TriggerServerEvent('okokMarketplace:addBlackmarket',E.item,E.price,E.desc,G,tonumber(E.amount))
				end 
			end)
		end 
	elseif E.action=="missing"then 
		exports['okokNotify']:Alert("MARKETPLACE","Please fill in all the required fields",5000,'error')
	elseif E.action=="missingSearch"then 
		exports['okokNotify']:Alert("MARKETPLACE","Search field empty",5000,'error')
	elseif E.action=="high"then 
		exports['okokNotify']:Alert("MARKETPLACE","You don't have enough items to sell",5000,'error')
	elseif E.action=="buyVehicle"then 
		ESX.TriggerServerCallback("okokMarketplace:getVehicle",function(I)
			TriggerServerEvent('okokMarketplace:buyVehicle',I)
		end,E.id)
	elseif E.action=="buyItem"then 
		ESX.TriggerServerCallback("okokMarketplace:getItem",function(J)
			TriggerServerEvent('okokMarketplace:buyItem',J)
		end,E.id,E.item)
	elseif E.action=="buyBlackmarket"then 
		ESX.TriggerServerCallback("okokMarketplace:getBlackmarket",function(K)
			TriggerServerEvent('okokMarketplace:buyBlackmarket',K)
		end,E.id,E.blackmarket)
	elseif E.action=="myAd"then 
		TriggerServerEvent('okokMarketplace:removeMyAd',E.item)
	elseif E.action=="refresh"then 
		if E.window=="vehicles"then 
			TriggerEvent('okokMarketplace:updateVehicles')
		elseif E.window=="items"then 
			TriggerEvent('okokMarketplace:updateItems')
		elseif E.window=="blackmarket"then 
			TriggerEvent('okokMarketplace:updateBlackmarket')
		end 
	end 
end)