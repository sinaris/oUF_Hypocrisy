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
	elseif( Type == 'Leader' ) then
		local Leader = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		Leader:SetSize( 12, 12 )

		return Leader
	elseif( Type == 'MasterLooter' ) then
		local MasterLooter = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		MasterLooter:SetSize( 12, 12 )

		return MasterLooter
	end
end

Constructors['SwingTimer'] = function( self )
	self['Swing'] = CreateFrame( 'StatusBar', self:GetName() .. '_Swing', self )
	self['Swing']:SetStatusBarTexture( Config['Textures']['StatusBar'] )
	self['Swing']:GetStatusBarTexture():SetHorizTile( false )
	self['Swing']:SetStatusBarColor( 0.2, 0.7, 0.1 )
	self['Swing']:SetPoint( 'BOTTOMLEFT', self, 'TOPLEFT', 0, 34 )
	self['Swing']:SetHeight( 9 )
	self['Swing']:SetWidth( self:GetWidth() )

	self['Swing']['bg'] = self['Swing']:CreateTexture( nil, 'BORDER' )
	self['Swing']['bg']:SetAllPoints( self['Swing'] )
	self['Swing']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Swing']['bg']:SetAlpha( 0.30 )

	self['Swing']['Text'] = self['Swing']:CreateFontString( nil, 'OVERLAY' )
	self['Swing']['Text']:SetPoint( 'CENTER', self['Swing'], 'CENTER', 0, 0 )
	self['Swing']['Text']:SetFont( Config['Fonts']['Font'], Config['Fonts']['Size'] - 1 )
	self['Swing']['Text']:SetTextColor( 1, 1, 1 )
	self['Swing']['Text']:SetShadowOffset( 1, -1 )

	self['Swing']:SetBackdrop( Config['Backdrop'] )
	self['Swing']:SetBackdropColor( 0, 0, 0, 1 )
end
