local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

oUF['Tags']['Events']['hyp:type'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
oUF['Tags']['Methods']['hyp:type'] = function( Unit )
	local String = ''
	local CreatureType = UnitCreatureType( Unit )

	if( UnitIsConnected( Unit ) == nil ) then
		String = ''
	else
		if( CreatureType == 'Humanoid' ) then
			String = '(H)'
		elseif( CreatureType == 'Beast' ) then
			String = '(B)'
		elseif( CreatureType == 'Mechanical' ) then
			String = '(M)'
		elseif( CreatureType == 'Elemental' ) then
			String = '(E)'
		elseif( CreatureType == 'Undead' ) then
			String = '(U)'
		elseif( CreatureType == 'Demon' ) then
			String = '(D)'
		elseif( CreatureType == 'Dragonkin' ) then
			String = '(Dr)'
		elseif( CreatureType == 'Giant' ) then
			String = '(G)'
		elseif( CreatureType == 'Not specified' ) then
			String = '(NA)'
		elseif( CreatureType == 'Wild Pet' ) then
			String = '(WP)'
		else
			String = CreatureType
		end
	end

	return String
end

oUF['Tags']['Events']['difficultycolor'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
oUF['Tags']['Methods']['difficultycolor'] = function( unit )
	local R, G, B = 0.55, 0.57, 0.61
	local Level

	if( UnitIsWildBattlePet( unit ) or UnitIsBattlePetCompanion( unit ) ) then
		Level = UnitBattlePetLevel( unit )

		local GetPetTeamAverageLevel = C_PetJournal.GetPetTeamAverageLevel()
		if( GetPetTeamAverageLevel < Level or GetPetTeamAverageLevel > Level ) then
			local DifficultyColor = GetRelativeDifficultyColor( GetPetTeamAverageLevel, Level )
			R, G, B = DifficultyColor['r'], DifficultyColor['g'], DifficultyColor['b']
		else
			local QuestDifficultyColors = QuestDifficultyColors['difficult']
			R, G, B = QuestDifficultyColors['r'], QuestDifficultyColors['g'], QuestDifficultyColors['b']
		end
	else
		local DiffColor = UnitLevel( unit ) - UnitLevel( 'player' )
		if( DiffColor >= 5 ) then
			R, G, B = 0.69, 0.31, 0.31
		elseif( DiffColor >= 3 ) then
			R, G, B = 0.71, 0.43, 0.27
		elseif( DiffColor >= -2 ) then
			R, G, B = 0.84, 0.75, 0.65
		elseif( -DiffColor <= GetQuestGreenRange() ) then
			R, G, B = 0.33, 0.59, 0.33
		else
			R, G, B = 0.55, 0.57, 0.61
		end
	end

	return Hex( R, G, B )
end
