local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Functions = NameSpace['Functions']

oUF['Tags']['Events']['hyp:level'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
oUF['Tags']['Methods']['hyp:level'] = function( unit )
	local String = ''

	local Level = UnitLevel( unit )
	local Classification = UnitClassification( unit )
	local CreatureType = UnitCreatureType( unit )
	local DifficultyColor = GetQuestDifficultyColor( Level )

	if( Classification == "worldboss" ) then
		String = "|cffff0000" .. Level .. "|rb"
	elseif( Classification == "rareelite" ) then
		String = Hex( DifficultyColor.r, DifficultyColor.g, DifficultyColor.b ) .. Level .. 'r+'
	elseif( Classification == "elite" ) then
		String = Hex( DifficultyColor.r, DifficultyColor.g, DifficultyColor.b ) .. Level .. '+'
	elseif( Classification == "rare" ) then
		String = Hex( DifficultyColor.r, DifficultyColor.g, DifficultyColor.b ) .. Level .. 'r'
	else
		if( UnitIsConnected( unit ) == nil ) then
			String = Hex( DifficultyColor.r, DifficultyColor.g, DifficultyColor.b ) .. "??|r"
		else
			String = Hex( DifficultyColor.r, DifficultyColor.g, DifficultyColor.b ) .. Level .. "|r"
		end
	end

	return String
end

oUF['Tags']['Events']['hyp:type'] = 'PLAYER_TARGET_CHANGED'
oUF['Tags']['Methods']['hyp:type'] = function( Unit )
	local String = ''
	local CreatureType = UnitCreatureType( Unit )

	if( UnitIsConnected( Unit ) == nil ) then
		String = ''
	else
		if( CreatureType == 'Humanoid' ) then
			String = ' (H)'
		elseif( CreatureType == 'Beast' ) then
			String = ' (B)'
		elseif( CreatureType == 'Mechanical' ) then
			String = ' (M)'
		elseif( CreatureType == 'Elemental' ) then
			String = ' (E)'
		elseif( CreatureType == 'Undead' ) then
			String = ' (U)'
		elseif( CreatureType == 'Demon' ) then
			String = ' (D)'
		elseif( CreatureType == 'Dragonkin' ) then
			String = ' (Dr)'
		elseif( CreatureType == 'Giant' ) then
			String = ' (G)'
		elseif( CreatureType == 'Not specified' ) then
			String = ' (NA)'
		elseif( CreatureType == 'Wild Pet' ) then
			String = ' (WP)'
		else
			String = CreatureType
		end
	end

	return String
end

oUF['Tags']['Events']['name:veryshort'] = 'UNIT_NAME_UPDATE'
oUF['Tags']['Methods']['name:veryshort'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and Functions['ShortenString'](name, 5, true) or ''
end

oUF['Tags']['Events']['name:short'] = 'UNIT_NAME_UPDATE'
oUF['Tags']['Methods']['name:short'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and Functions['ShortenString'](name, 10, true) or ''
end

oUF['Tags']['Events']['name:medium'] = 'UNIT_NAME_UPDATE'
oUF['Tags']['Methods']['name:medium'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and Functions['ShortenString'](name, 15, true) or ''
end

oUF['Tags']['Events']['name:long'] = 'UNIT_NAME_UPDATE'
oUF['Tags']['Methods']['name:long'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and Functions['ShortenString'](name, 20, true) or ''
end
