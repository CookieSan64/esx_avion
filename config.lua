Config               = {}

Config.Locale = GetConvar('esx:locale', 'fr')

Config.LicenseEnable = false -- enable avion license? Requires esx_license
Config.LicensePrice  = 50000

Config.MarkerType    = 1
Config.DrawDistance  = 10.0

Config.Marker = {
	r = 100, g = 204, b = 100, -- blue-ish color
	x = 1.5, y = 1.5, z = 1.0  -- standard size circle
}

Config.StoreMarker = {
	r = 255, g = 0, b = 0,     -- red color
	x = 5.0, y = 5.0, z = 1.0  -- big circle for storing avion
}

Config.Zones = {

	Garages = {
		{ -- Aéroport Sud
			GaragePos  = vector3(-1623.955, -3151.426, 12.99222),
			SpawnPoint = vector4(-1642.013, -3132.135, 13.99222, 333.1335),
			StorePos   = vector3(-1663.616, -3093.295, 12.94477), -- pour ranger
			StoreTP    = vector4(-1668.173, -3116.703, 13.99148, 305.551) -- TP après rangement
		},

		{ -- Aéroport Sandy Shores
			GaragePos  = vector3(1729.152, 3286.091, 40.1146),
			SpawnPoint = vector4(1737.966, 3285.48, 41.13203, 177.4646),
			StorePos   = vector3(1737.966, 3285.48, 40.13203), -- pour ranger
			StoreTP    = vector4(1726.324, 3282.888, 41.06685, 214.9034) -- TP après rangement
		},

		--[[{ -- Aéroport Cayo Public
			GaragePos  = vector3(-1623.955, -3151.426, 12.99222),
			SpawnPoint = vector4(-1642.013, -3132.135, 13.99222, 333.1335),
			StorePos   = vector3(-1663.616, -3093.295, 12.94477), -- pour ranger
			StoreTP    = vector4(-1668.173, -3116.703, 13.99148, 305.551) -- TP après rangement
		},]]

		--[[{ -- Aéroport Cayo Cartel
			GaragePos  = vector3(-1623.955, -3151.426, 12.99222),
			SpawnPoint = vector4(-1642.013, -3132.135, 13.99222, 333.1335),
			StorePos   = vector3(-1663.616, -3093.295, 12.94477), -- pour ranger
			StoreTP    = vector4(-1668.173, -3116.703, 13.99148, 305.551) -- TP après rangement
		},]]
	},

	AvionShops = {
		{ -- Aéroport
			Outside = vector3(-951.5298, -2947.198, 12.94508),
			Inside = vector4(-970.1992, -2960.059, 13.94507, 99.62955)
		}
	}

}

Config.Vehicles = {
	{model = 'luxor', label = 'Luxor', price = 1625000},
	{model = 'luxor2', label = 'Luxor Deluxe', price = 10000000},
	{model = 'shamal', label = 'Shamal', price = 1150000},
	{model = 'vestra', label = 'Vestra', price = 950000},
	{model = 'velum', label = 'Velum', price = 450000},
	{model = 'velum2', label = 'Velum 5-Seater', price = 9995000},
	{model = 'cuban800', label = 'Cuban', price = 240000},
	{model = 'dodo', label = 'Dodo', price = 500000},
	{model = 'duster', label = 'Duster', price = 275000},
	{model = 'mammatus', label = 'Mammatus', price = 300000},
	{model = 'microlight', label = 'ULM', price = 500000},

	{model = 'swift', label = 'Swift', price = 1500000},
	{model = 'swift2', label = 'Swift Deluxe', price = 5150000},
	{model = 'volatus', label = 'Volatus', price = 2295000},
	{model = 'frogger', label = 'Frogger', price = 1300000},
	{model = 'havok', label = 'Havok', price = 1730000},
	{model = 'seasparrow', label = 'Sea Sparrow', price = 1815000},
	{model = 'seasparrow2', label = 'Sparrow', price = 1815000},
	{model = 'supervolito', label = 'SuperVolito', price = 2113000},
	{model = 'supervolito2', label = 'SuperVolito Carbon', price = 3330000},
	{model = 'conada', label = 'Conada', price = 18375000},
	{model = 'maverick', label = 'Maverick', price = 780000}
}

exports('getGarages', function()
	return Config.Zones.Garages
end)