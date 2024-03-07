function ParkAvion()
	MySQL.update('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = false AND type = @type', {
		['@type'] = 'avion'
	}, function (rowsChanged)
		if rowsChanged > 0 then
			print(('[^2INFO^7] Stored ^5%s^7 %s !'):format(rowsChanged, rowsChanged > 1 and 'avions' or 'avion'))
		end
	end)
end

MySQL.ready(function()
	ParkAvion()
end)

ESX.RegisterServerCallback('esx_avion:buyAvion', function(source, cb, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price   = getPriceFromModel(vehicleProps.model)

	-- vehicle model not found
	if price == 0 then
		print(('[^2INFO^7] Player ^5%s^7 Attempted To Exploit Shop'):format(xPlayer.source))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price, "Avion Purchase")

			MySQL.update('INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (@owner, @plate, @vehicle, @type, @stored)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@type']    = 'avion',
				['@stored']  = true
			}, function(rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

RegisterServerEvent('esx_avion:takeOutVehicle')
AddEventHandler('esx_avion:takeOutVehicle', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = false,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[^2INFO^7] Player ^5%s^7 Attempted To Exploit Garage'):format(xPlayer.source))
		end
	end)
end)

ESX.RegisterServerCallback('esx_avion:storeVehicle', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = true,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		cb(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('esx_avion:getGarage', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND type = @type AND `stored` = @stored', {
		['@owner']  = xPlayer.identifier,
		['@type']   = 'avion',
		['@stored'] = true
	}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, result[i].vehicle)
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_avion:buyAvionLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice, "Avion License Purchase")

		TriggerEvent('esx_license:addLicense', source, 'avion', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

function getPriceFromModel(model)
	for k,v in ipairs(Config.Vehicles) do
		if joaat(v.model) == model then
			return v.price
		end
	end

	return 0
end
