local AddOn, NameSpace = ...
local Config = {}

NameSpace['Config'] = Config

Config['PlayerName'] = UnitName( 'player' )
Config['PlayerClass'] = select( 2, UnitClass( 'player' ) )
Config['PlayerColor'] = RAID_CLASS_COLORS[Config.PlayerClass]

Config['Scale'] = 1

Config['Backdrop'] = {
	['bgFile'] = 'Interface\\ChatFrame\\ChatFrameBackground',
	['tile'] = true,
	['tileSize'] = 16,
	['insets'] = {
		['left'] = -2,
		['right'] = -2,
		['top'] = -2,
		['bottom'] = -2
	},
}

Config['Fonts'] = {
	['Font'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\Font.ttf',
	['Size'] = 10,
	['Style'] = 'OUTLINE',
}

Config['Textures'] = {
	['Border'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\Border',
	['StatusBar'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\StatusBar',
	['Glow'] = 'Interface\\Addons\\oUF_Hypocrisy\\Medias\\Glow',
}

Config['Colors'] = {
	['Smooth'] = {
		1, 0, 0, 1, 1, 0, 1, 1, 1
	},

	['Power'] = {
		['MANA'] = { 0.31, 0.45, 0.63 },
		['RAGE'] = { 0.69, 0.31, 0.31 },
		['FOCUS'] = { 0.71, 0.43, 0.27 },
		['ENERGY'] = { 0.65, 0.63, 0.35 },
		['CHI'] = { 0.71, 1, 0.92 },
		['RUNES'] = { 0.55, 0.57, 0.61 },
		['RUNIC_POWER'] = { 0, 0.82, 1 },
		['SOUL_SHARDS'] = { 0.50, 0.32, 0.55 },
		['HOLY_POWER'] = { 0.95, 0.90, 0.60 },
		['FUEL'] = { 0, 0.55, 0.5 },
	},

	['Class'] = {
		['DEATHKNIGHT'] = { 0.76, 0.11, 0.23 },
		['DRUID'] = { 1, 0.49, 0.03 },
		['HUNTER'] = { 0.67, 0.83, 0.45 },
		['MAGE'] = { 0.40, 0.80, 1 },
		['PALADIN'] = { 0.96, 0.54, 0.72 },
		['PRIEST'] = { 0.83, 0.83, 0.83 },
		['ROGUE'] = { 1, 0.95, 0.32 },
		['SHAMAN'] = { 0.16, 0.30, 0.60 },
		['WARLOCK'] = { 0.58, 0.50, 0.78 },
		['WARRIOR'] = { 0.78, 0.61, 0.43 },
		['MONK'] = { 0, 1, 0.58 },
	},

	['Reaction'] = {
		[1] = { 0.87, 0.37, 0.37 },
		[2] = { 0.87, 0.37, 0.37 },
		[3] = { 0.87, 0.37, 0.37 },
		[4] = { 0.87, 0.77, 0.36 },
		[5] = { 0.29, 0.68, 0.29 },
		[6] = { 0.29, 0.68, 0.29 },
		[7] = { 0.29, 0.68, 0.29 },
		[8] = { 0.29, 0.68, 0.29 },
	},
}

Config['Units'] = {
	['Player'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 44,
		['Width'] = 180,

		['CastBars'] = {
			['Enable'] = true,
			['Fixed'] = true,
			['Height'] = 20,
			['Width'] = 374,
			['Position'] = { 'CENTER', UIParent, 'CENTER', 0, -250 },
			['TextColor'] = { 1, 1, 1, 1 },
			['TimeColor'] = { 1, 1, 1, 1 },
			['Icon_Enable'] = true,
			['Icon_Size'] = 24,
		}
	},

	['Target'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 40,
		['Width'] = 180,

		['CastBar'] = {
			['Enable'] = true,
			['Fixed'] = true,
			['Height'] = 20,
			['Width'] = 374,
			['Position'] = { 'CENTER', UIParent, 'CENTER', 0, 750 },
			['TextColor'] = { 1, 1, 1, 1 },
			['TimeColor'] = { 1, 1, 1, 1 },
			['Icon_Enable'] = true,
			['Icon_Size'] = 24,
		}
	},

	['TargetOfTarget'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 16,
		['Width'] = 87,
	},

	['Focus'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 40,
		['Width'] = 180,
	},

	['FocusTarget'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 40,
		['Width'] = 180,
	},

	['Pet'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 16,
		['Width'] = 87,
	},

	['PetTarget'] = {
		['Enable'] = true,
		['Scale'] = 1,
		['Height'] = 16,
		['Width'] = 87,
	},
	
	['CastBars'] = {
		['SafeZone'] = true,
		['SafeZoneColor'] = { 0.8, 0.2, 0.2, 0.75 },
		['Spark'] = true,

		['ClassColor'] = false,
		['Color'] = { 0.4, 0.6, 0.8, 1 },
		['NoInterruptColor'] = { 1, 0, 0, 1 },
	}
}
