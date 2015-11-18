local _, Class = UnitClass( "player" )

if( Class ~= "ROGUE" ) then
	return
end

local AddOn, Plugin = ...
local oUF = Plugin.oUF
assert( oUF, "oUF_BanditsGuileBar was unable to locate oUF install" )

local Colors = {
	[1] = { 0.33, 0.59, 0.33 },
	[2] = { 0.65, 0.63, 0.35 },
	[3] = { 0.69, 0.31, 0.31 },
}

local function Update( self, event )
	local unit = self.unit or "player"
	local bandit = self.BanditsGuileBar

	if( unit ~= "player" ) then
		return
	end

	if( bandit.PreUpdate ) then
		bandit:PreUpdate( event )
	end

	local count = 0
	local shallow = select( 4, UnitBuff( "player", GetSpellInfo( 84745 ) ) )
	local moderate = select( 4, UnitBuff( "player", GetSpellInfo( 84746 ) ) )
	local deep = select( 4, UnitBuff( "player", GetSpellInfo( 84747 ) ) )

	if( shallow ) then
		count = 1
	elseif( moderate ) then
		count = 2
	elseif( deep ) then
		count = 3
	end

	if( count == 0 ) then
		bandit:Hide()
	else
		bandit:Show()
	end

	for i = 1, 3 do
		if( i <= count ) then
			bandit[i]:SetAlpha( 1 )
		else
			bandit[i]:SetAlpha( 0.15 )
		end
	end

	if( bandit.PostUpdate ) then
		return bandit:PostUpdate( count )
	end
end

local function Path( self, ... )
	return ( self.BanditsGuileBar.Override or Update ) ( self, ... )
end

local function ForceUpdate( element )
	return Path( element.__owner, "ForceUpdate", element.__owner.unit )
end

local function Enable( self, unit )
	local bandit = self.BanditsGuileBar

	if( bandit ) then
		bandit.__owner = self
		bandit.ForceUpdate = ForceUpdate

		self:RegisterEvent( "UNIT_AURA", Path )

		for i = 1, 3 do
			if( not bandit[i]:GetStatusBarTexture() ) then
				bandit[i]:SetStatusBarTexture( [=[Interface\TargetingFrame\UI-StatusBar]=] )
			end

			bandit[i]:SetFrameLevel( bandit:GetFrameLevel() + 1 )
			bandit[i]:GetStatusBarTexture():SetHorizTile( false )
			bandit[i]:SetStatusBarColor( unpack( Colors[i] ) )
			bandit[i]:SetMinMaxValues( 0, 1 )
			bandit[i]:SetValue( 0 )
		end

		bandit:Hide()

		return true
	end
end

local function Disable( self )
	if( self.BanditsGuileBar ) then
		self:UnregisterEvent( "UNIT_AURA", Path )
	end
end

oUF:AddElement( "BanditsGuileBar", Path, Enable, Disable )