local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']

local Constructors = CreateFrame( 'Frame' )
NameSpace['Constructors'] = Constructors

Constructors['FontString'] = function( Parent, Layer, Type, Size, Style, JustifyH, Shadow )
	local FontString = Parent:CreateFontString( nil, Layer or 'OVERLAY' )
	FontString:SetFont( Type, Size or 10, Style or nil )
	FontString:SetJustifyH( JustifyH or 'CENTER' )

	if( Shadow ) then
		FontString:SetShadowColor( 0, 0, 0 )
		FontString:SetShadowOffset( 1.25, -1.25 )
	end

	return FontString
end

Constructors['StatusBar'] = function( Name, Parent, Texture, Color )
	local StatusBar = CreateFrame( 'StatusBar', Name or nil, Parent or UIParent )
	StatusBar:SetStatusBarTexture( Texture or Config['Textures']['StatusBar'] )
	StatusBar:GetStatusBarTexture():SetHorizTile( false )

	if( Color ) then
		StatusBar:SetStatusBarColor( unpack( Color ) )
	end

	return StatusBar
end

Constructors['Indicators'] = function( self, Unit, Type )
	if( Type == 'Combat' ) then
		local Combat = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		Combat:SetSize( 20, 20 )
		Combat:SetTexCoord( 0.58, 0.90, 0.08, 0.41 )

		return Combat
	elseif( Type == 'Resting' ) then
		local Resting = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		Resting:SetSize( 20, 20 )
		Resting:SetTexCoord( 0, 0.5, 0, 0.421875 )

		return Resting
	end
end
