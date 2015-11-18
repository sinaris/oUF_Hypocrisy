local _, Class = UnitClass( "player" )

if( Class ~= "DRUID" ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF
assert( oUF, "oUF_WildMushroom was unable to locate oUF install" )

local Colors = {
	95 / 255,
	222 / 255,
	95 / 255
}

local function UpdateMushroomTimer( self, elapsed )
	if( not self.expirationTime ) then
		return
	end

	self.expirationTime = self.expirationTime - elapsed

	local timeLeft = self.expirationTime
	if( timeLeft > 0 ) then
		self:SetValue( timeLeft )
	else
		self:SetScript( "OnUpdate", nil )
	end
end

local function Visibility( self )
	if( not self[1].Enabled and not self[2].Enabled and not self[3].Enabled ) then
		self:Hide()
	else
		self:Show()
	end
end

local function UpdateMushroom( self, event, slot )
	local m = self.WildMushroom
	local bar = m[slot]

	if( not bar ) then
		return
	end

	if( m.PreUpdate ) then
		m:PreUpdate( slot )
	end

	local up, name, start, duration, icon = GetTotemInfo( slot )
	if( up ) then
		local timeLeft = ( start + duration ) - GetTime()

		bar.Enabled = true
		bar.duration = duration
		bar.expirationTime = timeLeft
		bar:SetMinMaxValues( 0, duration )
		bar:SetScript( "OnUpdate", UpdateMushroomTimer )
	else
		bar.Enabled = false
		bar:SetValue( 0 )
		bar:SetScript( "OnUpdate", nil )
	end

	Visibility( m )

	if( m.PostUpdate ) then
		return m:PostUpdate( slot, up, name, start, duration, icon )
	end
end

local function Path( self, ... )
	return ( self.WildMushroom.Override or UpdateMushroom ) ( self, ... )
end

local function Update( self, event )
	for i = 1, 3 do
		Path( self, event, i )
	end
end

local function ForceUpdate( element )
	return Update( element.__owner, "ForceUpdate" )
end

local function Enable( self, unit )
	local m = self.WildMushroom

	if( m and unit == "player" ) then
		m.__owner = self
		m.ForceUpdate = ForceUpdate

		self:RegisterEvent( "PLAYER_TOTEM_UPDATE", Path, true )

		for i = 1, 3 do
			local Point = m[i]

			if( not Point:GetStatusBarTexture() ) then
				Point:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			Point:SetStatusBarColor( unpack( Colors ) )
			Point:SetFrameLevel( m:GetFrameLevel() + 1 )
			Point:GetStatusBarTexture():SetHorizTile( false )
			Point:SetMinMaxValues( 0, 300 )
			Point:SetValue( 0 )

			if( Point.bg ) then
				Point.bg:SetAlpha( 0.15 )
				Point.bg:SetAllPoints()
				Point.bg:SetTexture( unpack( Colors ) )
			end
		end

		m:Hide()

		return true
	end
end

local function Disable( self )
	local m = self.WildMushroom

	if( m ) then
		self:UnregisterEvent( "PLAYER_TOTEM_UPDATE", Path )
		m.Visibility:UnregisterEvent( "PLAYER_TALENT_UPDATE" )
	end
end

oUF:AddElement( "WildMushroom", Update, Enable, Disable )