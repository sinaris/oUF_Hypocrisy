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
