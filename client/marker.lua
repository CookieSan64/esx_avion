local HasAlreadyEnteredMarker = false
local LastZone                = nil

CurrentAction     = nil
CurrentActionMsg  = ''
CurrentActionData = {}

-- Key controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction then
			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'avion_shop' then
					if not Config.LicenseEnable then
						OpenAvionShop(Config.Zones.AvionShops[CurrentActionData.zoneNum])
					else -- check for license

						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasAvionLicense)
							if hasAvionLicense then
								OpenAvionShop(Config.Zones.AvionShops[CurrentActionData.zoneNum])
							else
								OpenLicenceMenu(Config.Zones.AvionShops[CurrentActionData.zoneNum])
							end
						end, GetPlayerServerId(PlayerId()), 'avion')
					end
				elseif CurrentAction == 'garage_out' then
					OpenAvionGarage(Config.Zones.Garages[CurrentActionData.zoneNum])
				elseif CurrentAction == 'garage_in' then
					StoreAvionInGarage(CurrentActionData.vehicle, Config.Zones.Garages[CurrentActionData.zoneNum].StoreTP)
				end

				CurrentAction = nil
				ESX.HideUI()
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('esx_avion:hasEnteredMarker', function(zone, zoneNum)
	if zone == 'avion_shop' then
		CurrentAction     = 'avion_shop'
		CurrentActionMsg  = TranslateCap('avion_shop_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_out' then
		CurrentAction     = 'garage_out'
		CurrentActionMsg  = TranslateCap('garage_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_in' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
	
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
	
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				CurrentAction     = 'garage_in'
				CurrentActionMsg  = TranslateCap('garage_store')
				CurrentActionData = { vehicle = vehicle, zoneNum = zoneNum }
			end
		end
	end
	ESX.TextUI(CurrentActionMsg)
end)

AddEventHandler('esx_avion:hasExitedMarker', function()
	if not isInShopMenu then
		ESX.CloseContext()
	end

	CurrentAction = nil
	ESX.HideUI()
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local isInMarker, hasExited, letSleep = false, false, true
		local currentZone, currentZoneNum

		for i=1, #Config.Zones.AvionShops, 1 do
			local distance = #(coords - Config.Zones.AvionShops[i].Outside)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Zones.AvionShops[i].Outside, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.Marker.x then
				isInMarker     = true
				currentZone    = 'avion_shop'
				currentZoneNum = i
			end
		end

		for i=1, #Config.Zones.Garages, 1 do
			local distance = #(coords - Config.Zones.Garages[i].GaragePos)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Zones.Garages[i].GaragePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.Marker.x then
				isInMarker     = true
				currentZone    = 'garage_out'
				currentZoneNum = i
			end

			distance = #(coords - Config.Zones.Garages[i].StorePos)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Zones.Garages[i].StorePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.StoreMarker.x, Config.StoreMarker.y, Config.StoreMarker.z, Config.StoreMarker.r, Config.StoreMarker.g, Config.StoreMarker.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.StoreMarker.x then
				isInMarker     = true
				currentZone    = 'garage_in'
				currentZoneNum = i
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)) then
			if
				(LastZone ~= nil and LastZoneNum ~= nil) and
				(LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)
			then
				TriggerEvent('esx_avion:hasExitedMarker', LastZone)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			LastZoneNum = currentZoneNum

			TriggerEvent('esx_avion:hasEnteredMarker', currentZone, currentZoneNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_avion:hasExitedMarker')
		end

		if letSleep then
			Wait(500)
		end
	end
end)

-- Blips
CreateThread(function()
	local blipList = {}

	for i=1, #Config.Zones.Garages, 1 do
		table.insert(blipList, {
			coords = Config.Zones.Garages[i].GaragePos,
			text   = TranslateCap('blip_garage'),
			sprite = 359,
			color  = 3,
			scale  = 0.6
		})
	end

	for i=1, #Config.Zones.AvionShops, 1 do
		table.insert(blipList, {
			coords = Config.Zones.AvionShops[i].Outside,
			text   = TranslateCap('blip_shop'),
			sprite = 575,
			color  = 3,
			scale  = 0.6
		})
	end

	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end
end)

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(coords.x, coords.y)

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)

	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end
