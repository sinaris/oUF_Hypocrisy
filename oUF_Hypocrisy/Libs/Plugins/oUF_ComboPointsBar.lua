local AddOn, Plugin = ...
local oUF = Plugin.oUF

local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Colors = { 
	[1] = { 0.69, 0.31, 0.31, 1 },
	[2] = { 0.65, 0.42, 0.31, 1 },
	[3] = { 0.65, 0.63, 0.35, 1 },
	[4] = { 0.46, 0.63, 0.35, 1 },
	[5] = { 0.33, 0.63, 0.33, 1 },
}

local Update = function( self, event, unit )
	if( unit == 'pet' ) then
		return
	end

	local cpb = self.ComboPointsBar
	local points

	if( UnitHasVehicleUI( 'player' ) ) then
		points = GetComboPoints( 'vehicle', 'target' )
	else
		points = GetComboPoints( 'player', 'target' )
	end

	if( points ) then
		for i = 1, MAX_COMBO_POINTS do
			if( i <= points ) then
				cpb[i]:SetAlpha( 1 )
			else
				cpb[i]:SetAlpha( 0.2 )
			end
		end
	end

	if( points > 0 ) then
		cpb:Show()
	else
		cpb:Hide()
	end

	if( cpb.PostUpdate ) then
		cpb:PostUpdate( self, points )
	end
end

local Path = function( self, ... )
	return ( self.ComboPointsBar.Override or Update ) ( self, ... )
end

local ForceUpdate = function( element )
	return Path( element.__owner, 'ForceUpdate', element.__owner.unit )
end

local Enable = function( self )
	local cpb = self.ComboPointsBar

	if( cpb ) then
		cpb.__owner = self
		cpb.ForceUpdate = ForceUpdate

		self:RegisterEvent( 'UNIT_COMBO_POINTS', Path, true )
		self:RegisterEvent( 'PLAYER_TARGET_CHANGED', Path, true )

		for i = 1, MAX_COMBO_POINTS do
			local Point = cpb[i]

			if( not Point:GetStatusBarTexture() ) then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			Point:SetStatusBarColor( unpack( Colors[i] ) )
			Point:SetFrameLevel( cpb:GetFrameLevel() + 1 )
			Point:GetStatusBarTexture():SetHorizTile( false )

			if( Point.bg ) then
				Point.bg:SetAlpha( 0.2 )
				Point.bg:SetAllPoints()
				Point.bg:SetTexture( unpack( Colors[i] ) )
			end
		end

		return true
	end
end

local Disable = function( self )
	local cpb = self.ComboPointsBar

	if( cpb ) then
		self:UnregisterEvent( 'UNIT_COMBO_POINTS', Path )
		self:UnregisterEvent( 'PLAYER_TARGET_CHANGED', Path )
	end
end

oUF:AddElement( 'ComboPointsBar', Path, Enable, Disable )
