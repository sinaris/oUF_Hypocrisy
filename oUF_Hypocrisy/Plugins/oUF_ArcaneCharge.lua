local _, Class = UnitClass( 'player' )

if( Class ~= 'MAGE' ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF

local ARCANE_DEBUFF = GetSpellInfo( 36032 )

local Colors = { 0.41, 0.80, 1 }

local function UpdateBar( self, elapsed )
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

local function Update( self, event )
	local unit = self.unit or 'player'
	local ArcaneChargeBar = self.ArcaneChargeBar

	if( ArcaneChargeBar.PreUpdate ) then
		ArcaneChargeBar:PreUpdate( event )
	end

	local name, _, _, count, _, start, timeLeft = UnitDebuff( unit, ARCANE_DEBUFF )
	local charges, maxCharges = 0, 4

	if( name ) then
		charges = count or 0
		duration = start
		expirationTime = timeLeft
	end

	if( charges < 1 ) then
		ArcaneChargeBar:Hide()
	else
		ArcaneChargeBar:Show()
	end

	if( ArcaneChargeBar:IsShown() ) then
		for i = 1, maxCharges do
			if( start and timeLeft ) then
				ArcaneChargeBar[i]:SetMinMaxValues( 0, start )
				ArcaneChargeBar[i].duration = start
				ArcaneChargeBar[i].expirationTime = timeLeft
			end

			if( i <= charges ) then
				ArcaneChargeBar[i]:SetValue( start )
				ArcaneChargeBar[i]:SetScript( 'OnUpdate', UpdateBar )
			else
				ArcaneChargeBar[i]:SetValue( 0 )
				ArcaneChargeBar[i]:SetScript( 'OnUpdate', nil )
			end
		end
	end

	if( ArcaneChargeBar.PostUpdate ) then
		return ArcaneChargeBar:PostUpdate( event, charges, maxCharges )
	end
end

local function Path( self, ... )
	return ( self.ArcaneChargeBar.Override or Update ) ( self, ... )
end

local function ForceUpdate( element )
	return Path( element.__owner, 'ForceUpdate', element.__owner.unit )
end

local function Enable( self, unit )
	local ArcaneChargeBar = self.ArcaneChargeBar

	if( ArcaneChargeBar ) then
		self:RegisterEvent( 'UNIT_AURA', Path )
		self:RegisterEvent( 'PLAYER_ENTERING_WORLD', Path )
		ArcaneChargeBar.__owner = self
		ArcaneChargeBar.ForceUpdate = ForceUpdate

		for i = 1, 4 do
			if( not ArcaneChargeBar[i]:GetStatusBarTexture() ) then
				ArcaneChargeBar[i]:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			ArcaneChargeBar[i]:SetFrameLevel( ArcaneChargeBar:GetFrameLevel() + 1 )
			ArcaneChargeBar[i]:GetStatusBarTexture():SetHorizTile( false )

			if( ArcaneChargeBar[i].bg ) then
				ArcaneChargeBar[i]:SetMinMaxValues( 0, 1 )
				ArcaneChargeBar[i]:SetValue( 0 )
				ArcaneChargeBar[i].bg:SetAlpha( 0.2 )
				ArcaneChargeBar[i].bg:SetAllPoints()
				ArcaneChargeBar[i].bg:SetTexture( unpack( Colors ) )
			end
		end

		return true
	end
end

local function Disable( self,unit )
	local ArcaneChargeBar = self.ArcaneChargeBar

	if( ArcaneChargeBar ) then
		self:UnregisterEvent( 'UNIT_AURA', Path )
		self:UnregisterEvent( 'PLAYER_ENTERING_WORLD', Path )

		ArcaneChargeBar:Hide()
	end
end

oUF:AddElement( 'ArcaneChargeBar', Path, Enable, Disable )
