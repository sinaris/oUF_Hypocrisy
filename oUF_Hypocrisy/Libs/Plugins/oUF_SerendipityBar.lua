local _, Class = UnitClass( 'player' )

if( Class ~= 'PRIEST' ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF

local Colors = {
	[1] = { 1.0, 1.0, 0.74, 1 },
	[2] = { 1.0, 1.0, 0.74, 1 },
}

local Update = function( self, event, unit )
	local Bar = self.SerendipityBar
	local Serendipity = IsSpellKnown( 63733 )

	if( not Serendipity ) then
		return
	end

	local Count = select( 4, UnitBuff( "player", GetSpellInfo( 63735 ) ) ) or 0

	if( Bar.PreUpdate ) then
		Bar:PreUpdate( self, Count )
	end

	if( Count ) then
		for i = 1, 2 do
			if( i <= Count ) then
				Bar[i]:SetAlpha( 1 )
			else
				Bar[i]:SetAlpha( 0.2 )
			end
		end
	end

	if( Count > 0 ) then
		Bar:Show()
	else
		Bar:Hide()
	end

	if( Bar.PostUpdate ) then
		Bar:PostUpdate( self, Count )
	end
end

local Path = function( self, ... )
	return ( self.SerendipityBar.Override or Update ) ( self, ... )
end

local ForceUpdate = function( element )
	return Path( element.__owner, 'ForceUpdate', element.__owner.unit )
end

local Enable = function( self )
	local Bar = self.SerendipityBar

	if( Bar ) then
		Bar.__owner = self
		Bar.ForceUpdate = ForceUpdate

		self:RegisterEvent( 'UNIT_AURA', Path )

		for i = 1, 2 do
			local Point = Bar[i]

			if( not Point:GetStatusBarTexture() ) then
				Point:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			Point:SetStatusBarColor( unpack( Colors[i] ) )
			Point:SetFrameLevel( Bar:GetFrameLevel() + 1 )
			Point:GetStatusBarTexture():SetHorizTile( false )
		end

		Bar:Hide()

		return true
	end
end

local Disable = function( self )
	local Bar = self.SerendipityBar

	if( Bar ) then
		self:UnregisterEvent( 'UNIT_AURA', Path )
	end
end

oUF:AddElement( 'SerendipityBar', Path, Enable, Disable )
