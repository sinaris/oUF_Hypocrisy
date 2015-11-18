local _, Class = UnitClass( 'player' )

if( Class ~= 'MONK' ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF

local SPELL_POWER_CHI = SPELL_POWER_CHI

local Colors = {
	[1] = { 0.69, 0.31, 0.31, 1 },
	[2] = { 0.65, 0.42, 0.31, 1 },
	[3] = { 0.65, 0.63, 0.35, 1 },
	[4] = { 0.46, 0.63, 0.35, 1 },
	[5] = { 0.33, 0.63, 0.33, 1 },
	[6] = { 0.20, 0.63, 0.33, 1 },
}

local UpdateEnergy = function( Bar, Max )
	local Width = floor( Bar:GetWidth() / Max )

	for i = 1, Max do
		Bar[i]:ClearAllPoints()

		if( i == Max ) then
			Bar[i]:SetPoint( "RIGHT", Bar, "RIGHT", 0, 0 )
			Bar[i]:SetPoint( "LEFT", Bar[i-1], "RIGHT", 1, 0 )
		else
			Bar[i]:SetWidth( Width )
			Bar[i]:SetPoint( "LEFT", Bar[i-1], "RIGHT", 1, 0 )
		end
	end
end

local Update = function( self, event, unit, powerType )
	if( self.unit ~= unit and ( powerType and ( powerType ~= 'CHI' and powerType ~= 'DARK_FORCE' ) ) ) then
		return
	end

	local Bar = self.HarmonyBar

	if( Bar.PreUpdate ) then
		Bar:PreUpdate( unit )
	end

	local Current = UnitPower( "player", SPELL_POWER_CHI )
	local Max = UnitPowerMax( "player", SPELL_POWER_CHI )

	if( Bar.MaxChi ~= Max ) then
		if( Max == 4 ) then
			Bar[6]:Hide()
			Bar[5]:Hide()
		elseif( Max == 5 ) then
			Bar[5]:Show()
			Bar[6]:Hide()
		else
			Bar[6]:Show()
			Bar[5]:Show()
		end

		UpdateEnergy( Bar, Max )

		Bar.MaxChi = Max
	end

	for i = 1, Max do
		if( i <= Current ) then
			Bar[i]:SetAlpha( 1 )
		else
			Bar[i]:SetAlpha( 0.2 )
		end
	end

	if( Bar.PostUpdate ) then
		return Bar:PostUpdate( Current )
	end
end

local Path = function( self, ... )
	return ( self.HarmonyBar.Override or Update ) ( self, ... )
end

local ForceUpdate = function( element )
	return Path( element.__owner, 'ForceUpdate', element.__owner.unit, 'CHI' )
end

local Enable = function( self, unit )
	local hb = self.HarmonyBar

	if( hb and unit == "player" ) then
		hb.__owner = self
		hb.ForceUpdate = ForceUpdate

		self:RegisterEvent( "UNIT_POWER", Path )
		self:RegisterEvent( "UNIT_DISPLAYPOWER", Path )
		self:RegisterEvent( "UNIT_MAXPOWER", Path )

		for i = 1, 6 do
			local Point = hb[i]

			if( not Point:GetStatusBarTexture() ) then
				Point:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			Point:SetStatusBarColor( unpack( Colors[i] ) )
			Point:SetFrameLevel( hb:GetFrameLevel() + 1 )
			Point:GetStatusBarTexture():SetHorizTile( false )
			Point.OriginalWidth = Point:GetWidth()
		end

		hb.MaxChi = 0

		return true
	end
end

local Disable = function( self )
	if( self.HarmonyBar ) then
		self:UnregisterEvent( "UNIT_POWER", Path )
		self:UnregisterEvent( "UNIT_DISPLAYPOWER", Path )
	end
end

oUF:AddElement( 'HarmonyBar', Update, Enable, Disable )
