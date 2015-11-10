local AddOn, Plugin = ...
local oUF = Plugin.oUF

local OnDurationUpdate = function( self )
	self:SetMinMaxValues( self.min, self.max )

	local Elapsed = GetTime()

	if( Elapsed > self.max ) then
		self:Hide()
		self:SetScript( 'OnUpdate', nil )
	else
		self:SetValue( self.min + ( Elapsed - self.min ) )

		if( self.Text ) then
			if( self.OverrideText ) then
				self:OverrideText( Elapsed )
			else
				self.Text:SetFormattedText( '%.1f', self.max - Elapsed )
			end
		end
	end
end

local Melee = function( self, _, _, event, _, GUID, _, _, _, tarGUID, _, _, _, missType, spellName )
	local Swing = self.Swing

	if( UnitGUID( self.unit ) == tarGUID ) then
		if( string.find( event, 'MISSED' ) ) then
			if( missType == 'PARRY' ) then
				Swing.max = Swing.min + ( ( Swing.max - Swing.min ) * 0.6 )
				Swing:SetMinMaxValues( Swing.min, Swing.max )
			end
		end
	elseif( UnitGUID( self.unit ) == GUID ) then
		if( not string.find( event, 'SWING' ) ) then
			return
		end

		Swing.min = GetTime()
		Swing.max = Swing.min + UnitAttackSpeed( self.unit )

		local itemId = GetInventoryItemID( 'player', 17 )

		if( itemId ~= nil ) then
			local _, _, _, _, _, itemType = GetItemInfo( itemId )
			local _, _, _, _, _, weaponType = GetItemInfo( 25 )

			if( itemType ~= weaponType ) then
				Swing:Show()
				Swing:SetMinMaxValues( Swing.min, Swing.max )
				Swing:SetScript( 'OnUpdate', OnDurationUpdate )
			else
				Swing:Hide()
				Swing:SetScript( 'OnUpdate', nil )
			end
		else
			Swing:Show()
			Swing:SetMinMaxValues( Swing.min, Swing.max )
			Swing:SetScript( 'OnUpdate', OnDurationUpdate )
		end
	end
end

local Ranged = function( self, event, unit, spellName )
	if( spellName ~= GetSpellInfo( 75 ) and spellName ~= GetSpellInfo( 5019 ) ) then
		return
	end

	local Swing = self.Swing

	Swing.min = GetTime()
	Swing.max = Swing.min + UnitRangedDamage( unit )

	Swing:Show()
	Swing:SetMinMaxValues( Swing.min, Swing.max )
	Swing:SetScript( 'OnUpdate', OnDurationUpdate )
end

local Ooc = function( self )
	local bar = self.Swing

	bar:Hide()
end

local Enable = function( self, unit )
	local Swing = self.Swing

	if( Swing and unit == 'player' ) then

		if( not Swing.disableRanged ) then
			self:RegisterEvent( 'UNIT_SPELLCAST_SUCCEEDED', Ranged )
		end

		if( not Swing.disableMelee ) then
			self:RegisterEvent( 'COMBAT_LOG_EVENT_UNFILTERED', Melee )
		end

		if( not Swing.disableOoc ) then
			self:RegisterEvent( 'PLAYER_REGEN_ENABLED', Ooc )
		end

		Swing:Hide()

		return true
	end
end

local Disable = function( self )
	local Swing = self['Swing']

	if( Swing ) then
		if( not Swing.disableRanged ) then
			self:UnregisterEvent( 'UNIT_SPELLCAST_SUCCEEDED', Ranged )
		end

		if( not Swing.disableMelee ) then
			self:UnregisterEvent( 'COMBAT_LOG_EVENT_UNFILTERED', Melee )
		end

		if( not Swing.disableOoc ) then
			self:UnregisterEvent( 'PLAYER_REGEN_ENABLED', Ooc )
		end
	end
end

oUF:AddElement( 'Swing', nil, Enable, Disable )
