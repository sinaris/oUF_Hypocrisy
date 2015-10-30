local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Functions = NameSpace['Functions']
local Constructors = NameSpace['Constructors']
local Resource = NameSpace['Resource']

if( not Config['Units']['Player']['Enable'] ) then
	return
end

local CreatePowerBar = function( self )
	self['Power'] = Constructors['StatusBar']( self:GetName() .. '_PowerBar', self )
	self['Power']:SetPoint( 'BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0 )
	self['Power']:SetSize( 137, 10 )

	self['Power']['bg'] = self['Power']:CreateTexture( nil, 'BORDER' )
	self['Power']['bg']:SetAllPoints( self['Power'] )
	self['Power']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Power']['bg']:SetAlpha( 0.30 )

	self['Power']['Value'] = Constructors['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Value']:SetPoint( 'LEFT', self['Power'], 'LEFT', 2, 0 )
	self['Power']['Value']:SetTextColor( 1, 1, 1 )

	self['Power']['Percent'] = Constructors['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Percent']:SetPoint( 'RIGHT', self['Power'], 'RIGHT', -1, 0 )
	self['Power']['Percent']:SetTextColor( 1, 1, 1 )

	self['Power']['Smooth'] = true
	self['Power']['colorClass'] = true
	self['Power']['colorReaction'] = true
	self['Power']['colorDisconnected'] = true
	self['Power']['colorTapping'] = true

	self['Power']['PreUpdate'] = Functions['PreUpdatePower']
	self['Power']['PostUpdate'] = Functions['PostUpdatePower']
end

local CreateHealthBar = function( self )
	self['Health'] = Constructors['StatusBar']( self:GetName() .. '_HealthBar', self )
	self['Health']:SetPoint( 'BOTTOM', self['Power'], 'TOP', 0, 2 )
	self['Health']:SetSize( 137, 16 )

	self['Health']['bg'] = self['Health']:CreateTexture( nil, 'BORDER' )
	self['Health']['bg']:SetAllPoints( self['Health'] )
	self['Health']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Health']['bg']:SetAlpha( 0.30 )

	self['Health']['Value'] = Constructors['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
	self['Health']['Value']:SetPoint( 'LEFT', self['Health'], 'LEFT', 2, 0 )
	self['Health']['Value']:SetTextColor( 1, 1, 1 )

	self['Health']['Percent'] = Constructors['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
	self['Health']['Percent']:SetPoint( 'RIGHT', self['Health'], 'RIGHT', -1, 0 )
	self['Health']['Percent']:SetTextColor( 1, 1, 1 )

	self['Health']['Smooth'] = true
	self['Health']['colorClass'] = true
	self['Health']['colorReaction'] = true
	self['Health']['colorDisconnected'] = true
	self['Health']['colorTapping'] = true

	self['Health']['PostUpdate'] = Functions['PostUpdateHealth']
end

local CreateTitleBar = function( self )
	self['Title'] = CreateFrame( 'Frame', self:GetName() .. '_TitleBar', self )
	self['Title']:SetPoint( 'BOTTOM', self['Health'], 'TOP', 0, 2 )
	self['Title']:SetSize( 137, 14 )

	self['Title']['Texture'] = self['Title']:CreateTexture( nil, 'ARTWORK' )
	self['Title']['Texture']:SetTexture( Config['Textures']['StatusBar'] )
	self['Title']['Texture']:SetVertexColor( 0.1, 0.1, 0.1, 1 )
	self['Title']['Texture']:SetAllPoints( self['Title'] )
end

local CreatePortrait = function( self )
	self['Portrait'] = CreateFrame( 'PlayerModel', self:GetName() .. '_Portrait', self )
	self['Portrait']:SetPoint( 'BOTTOMRIGHT', self['Power'], 'BOTTOMLEFT', -2, 1 )
	self['Portrait']:SetSize( 41, 43 )
end

local CreateLevel = function( self )
	self['Level'] = Constructors['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 1, nil, 'LEFT', true )
	self['Level']:SetPoint( 'LEFT', self['Title'], 'LEFT', 2, -1 )
	self['Level']:SetTextColor( 1, 1, 1 )
	self:Tag( self['Level'], '[difficulty][level][hyp:type]' )
end

local CreateName = function( self )
	self['Name'] = Constructors['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 1, nil, 'RIGHT', true )
	self['Name']:SetPoint( 'RIGHT', self['Title'], 'RIGHT', -2, -1 )
	self['Name']:SetTextColor( 1, 1, 1 )
	self:Tag( self['Name'], '[name]' )
end

local CreateCombatIcon = function( self )
	self['Combat'] = self['Portrait']:CreateTexture( nil, "OVERLAY" )
	self['Combat']:SetPoint("CENTER", self['Portrait'], "BOTTOMLEFT", 0, 0)
	self['Combat']:SetSize( 14, 14 )
	self['Combat']:SetTexture( "Interface\\CharacterFrame\\UI-StateIcon" )
	self['Combat']:SetTexCoord( 0.58, 0.90, 0.08, 0.41 )
end

local CreateRestingIcon = function( self )
	self['Resting'] = self['Portrait']:CreateTexture( nil, "OVERLAY" )
	self['Resting']:SetPoint( "CENTER", self['Portrait'], "BOTTOMLEFT", 0, 0 )
	self['Resting']:SetSize( 18, 18 )
	self['Resting']:SetTexture( "Interface\\CharacterFrame\\UI-StateIcon" )
	self['Resting']:SetTexCoord( 0, 0.5, 0, 0.421875 )
end

local CreateCastBar = function( self )
	self['Castbar'] = Constructors['StatusBar']( self:GetName() .. '_CastBar', self, nil, { 0.4, 0.6, 0.8 } )
	self['Castbar']:SetPoint( 'CENTER', UIParent, 'CENTER', 0, -250 )
	self['Castbar']:SetSize( 370, 25 )

	Functions['ApplyBackdrop']( self['Castbar'] )

	self['Castbar']['bg'] = self['Castbar']:CreateTexture( nil, "BORDER" )
	self['Castbar']['bg']:SetAllPoints( self['Castbar'] )
	self['Castbar']['bg']:SetTexture( 0.15, 0.15, 0.15, 1 )

	self['Castbar']['Text'] = Constructors['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 4, 'THINOUTLINE', 'CENTER', true )
	self['Castbar']['Text']:SetPoint( "LEFT", self['Castbar'], 'LEFT', 8, 0 )
	self['Castbar']['Text']:SetTextColor( 1, 1, 1 )

	self['Castbar']['Time'] = Constructors['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 4, 'THINOUTLINE', 'CENTER', true )
	self['Castbar']['Time']:SetPoint( "RIGHT", self['Castbar'], 'RIGHT', -5, 0 )
	self['Castbar']['Time']:SetTextColor( 1, 1, 1 )

	self['Castbar']['Button'] = CreateFrame( 'Frame', nil, self['Castbar'] )
	self['Castbar']['Button']:SetPoint( 'BOTTOM', self['Castbar'], 'TOP', 0, 6 )
	self['Castbar']['Button']:SetSize( 35, 35 )
	Functions['ApplyBackdrop']( self['Castbar']['Button'] )

	self['Castbar']['Icon'] = self['Castbar']['Button']:CreateTexture( nil, 'ARTWORK' )
	self['Castbar']['Icon']:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )
	Functions['SetInside']( self['Castbar']['Icon'], 0, 0 )

	self['Castbar']['SafeZone'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
	self['Castbar']['SafeZone']:SetTexture( Config['Textures']['StatusBar'] )
	self['Castbar']['SafeZone']:SetVertexColor( 0.8, 0.2, 0.2, 0.75 )

	self['Castbar']['Spark'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
	self['Castbar']['Spark']:SetSize( 15, 31 )
	self['Castbar']['Spark']:SetBlendMode( 'ADD' )
end

local CreateStyle = function( self )
	self['Config'] = Config['Units']['Player']

	Functions['ApplyBackdrop']( self )

	self:RegisterForClicks( 'AnyUp' )
	self:SetScript( 'OnEnter', UnitFrame_OnEnter )
	self:SetScript( 'OnLeave', UnitFrame_OnLeave )

	self:SetSize( self['Config']['Width'], self['Config']['Height'] )
	self:SetScale( self['Config']['Scale'] )
	self:SetPoint( 'CENTER', UIParent, 'CENTER', -320, -126 )

	self:SetFrameStrata( 'BACKGROUND' )
	self:SetFrameLevel( 1 )

	CreatePowerBar( self )
	CreateHealthBar( self )
	CreateTitleBar( self )
	CreatePortrait( self )
	CreateLevel( self )
	CreateName( self )
	CreateCastBar( self )
end

oUF:RegisterStyle( 'hypocrisy:player', CreateStyle )
oUF:SetActiveStyle( 'hypocrisy:player' )
oUF:Spawn( 'player', 'oUF_HypocrisyPlayer' )
