local _, Class = UnitClass( 'player' )

if( Class ~= 'ROGUE' ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF

local ANTICIPATION = GetSpellInfo( 115189 )

local Colors = { 
	[1] = { 0.69, 0.31, 0.31, 1 },
	[2] = { 0.65, 0.42, 0.31, 1 },
	[3] = { 0.65, 0.63, 0.35, 1 },
	[4] = { 0.46, 0.63, 0.35, 1 },
	[5] = { 0.33, 0.63, 0.33, 1 },
}

local UpdateBar = function( self, elapsed )
	if( not self.expirationTime ) then
		return
	end

	self.elapsed = ( self.elapsed or 0 ) + elapsed

	if( self.elapsed >= 0.5 ) then
		local timeLeft = self.expirationTime - GetTime()

		if( timeLeft > 0 ) then
			self:SetValue( timeLeft )
		else
			self:SetScript( 'OnUpdate', nil )
		end
	end
end

local Update = function( self, event )
	local unit = self.unit or 'player'
	local AnticipationBar = self.AnticipationBar

	if( AnticipationBar.PreUpdate ) then
		AnticipationBar:PreUpdate( event )
	end

	local name, _, _, count, _, start, timeLeft = UnitBuff( unit, ANTICIPATION )
	local charges, maxCharges = 0, 5

	if( name ) then
		charges = count or 0
		duration = start
		expirationTime = timeLeft
	end

	if( charges < 1 ) then
		AnticipationBar:Hide()
	else
		AnticipationBar:Show()
	end

	if( AnticipationBar:IsShown() ) then
		for i = 1, maxCharges do
			if( start and timeLeft ) then
				AnticipationBar[i]:SetMinMaxValues( 0, start )
				AnticipationBar[i].duration = start
				AnticipationBar[i].expirationTime = timeLeft
			end

			if( i <= charges ) then
				AnticipationBar[i]:SetValue( start )
				AnticipationBar[i]:SetScript( 'OnUpdate', UpdateBar )
			else
				AnticipationBar[i]:SetValue( 0 )
				AnticipationBar[i]:SetScript( 'OnUpdate', nil )
			end
		end
	end

	if( AnticipationBar.PostUpdate ) then
		return AnticipationBar:PostUpdate( event, charges, maxCharges )
	end
end

local Path = function( self, ... )
	return ( self.AnticipationBar.Override or Update ) ( self, ... )
end

local ForceUpdate = function( element )
	return Path( element.__owner, 'ForceUpdate', element.__owner.unit )
end

local Enable = function( self, unit )
	local AnticipationBar = self.AnticipationBar

	if( AnticipationBar ) then
		self:RegisterEvent( 'UNIT_AURA', Path )
		self:RegisterEvent( 'PLAYER_ENTERING_WORLD', Path )
		AnticipationBar.__owner = self
		AnticipationBar.ForceUpdate = ForceUpdate

		for i = 1, 5 do
			if( not AnticipationBar[i]:GetStatusBarTexture() ) then
				AnticipationBar[i]:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			AnticipationBar[i]:SetFrameLevel( AnticipationBar:GetFrameLevel() + 1 )
			AnticipationBar[i]:GetStatusBarTexture():SetHorizTile( false )
			AnticipationBar[i]:SetStatusBarColor( unpack( Colors[i] ) )

			if( AnticipationBar[i].bg ) then
				AnticipationBar[i]:SetMinMaxValues( 0, 1 )
				AnticipationBar[i]:SetValue( 0 )
				AnticipationBar[i].bg:SetAlpha( 0.2 )
				AnticipationBar[i].bg:SetAllPoints()
				AnticipationBar[i].bg:SetTexture( unpack( Colors[i] ) )
			end
		end

		return true
	end
end

local Disable = function( self, unit )
	local AnticipationBar = self.AnticipationBar

	if( AnticipationBar ) then
		self:UnregisterEvent( 'UNIT_AURA', Path )
		self:UnregisterEvent( 'PLAYER_ENTERING_WORLD', Path )

		AnticipationBar:Hide()
	end
end

oUF:AddElement( 'AnticipationBar', Path, Enable, Disable )
