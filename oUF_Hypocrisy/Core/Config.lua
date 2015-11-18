SLASH_RELOADUI1 = '/rl'
SlashCmdList['RELOADUI'] = ReloadUI

local AddOn, NameSpace = ...

local Config = {}
NameSpace['Config'] = Config

Config['Scale'] = 1

Config['PlayerName'] = UnitName( 'player' )
Config['PlayerClass'] = select( 2, UnitClass( 'player' ) )
Config['PlayerColor'] = RAID_CLASS_COLORS[Config.PlayerClass]

Config['Colors'] = {
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
}

Config['Textures'] = {
	['Border'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\Border',
	['StatusBar'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\StatusBar',
	['Glow'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\Glow',
}

Config['Fonts'] = {
	['Font'] = 'Interface\\AddOns\\oUF_Hypocrisy\\Medias\\Font.ttf',
	['Size'] = 10,
	['Style'] = 'OUTLINE',
}

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

Config['FontString'] = function( Parent, Layer, Type, Size, Style, JustifyH, Shadow )
	local FontString = Parent:CreateFontString( nil, Layer or 'OVERLAY' )
	FontString:SetFont( Type, Size or 10, Style or nil )
	FontString:SetJustifyH( JustifyH or 'CENTER' )

	if( Shadow ) then
		FontString:SetShadowColor( 0, 0, 0 )
		FontString:SetShadowOffset( 1.25, -1.25 )
	end

	return FontString
end

Config['StatusBar'] = function( Name, Parent, Texture, Color )
	local StatusBar = CreateFrame( 'StatusBar', Name or nil, Parent or UIParent )
	StatusBar:SetStatusBarTexture( Texture or Config['Textures']['StatusBar'] )
	StatusBar:GetStatusBarTexture():SetHorizTile( false )

	if( Color ) then
		StatusBar:SetStatusBarColor( unpack( Color ) )
	end

	return StatusBar
end

Config['Units'] = {
	['Player'] = {
		['Height'] = 44,
		['Width'] = 182,

		['SwingTimer'] = true,
	},

	['Target'] = {
		['Height'] = 40,
		['Width'] = 182,
	}
}
