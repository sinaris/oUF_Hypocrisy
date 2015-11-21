local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Functions = NameSpace['Functions']

if( not Config['Units']['Focus']['Enable'] ) then
	return
end

local ApplyStyle = function( self )
	--------------------------------------------------
	-- Defaults
	--------------------------------------------------
	self['Config'] = Config['Units']['Target']

	self:RegisterForClicks( 'AnyUp' )
	self:SetScript( 'OnEnter', UnitFrame_OnEnter )
	self:SetScript( 'OnLeave', UnitFrame_OnLeave )

	self:SetSize( self['Config']['Width'], self['Config']['Height'] )
	self:SetScale( Config['Scale'] )
	self:SetPoint( 'TOPLEFT', UIParent, 'CENTER', 284, -200 )

	self:SetFrameStrata( 'BACKGROUND' )
	self:SetFrameLevel( 1 )

	Functions['ApplyBackdrop']( self )

	self['RaisedFrame'] = CreateFrame( 'Frame', '$parent_RaisedFrame', self )
	self['RaisedFrame']:SetAllPoints( self )
	self['RaisedFrame']:SetFrameLevel( self:GetFrameLevel() + 20 )

	--------------------------------------------------
	-- Power
	--------------------------------------------------
	self['Power'] = Config['StatusBar']( '$parent_PowerBar', self )
	self['Power']:SetPoint( 'BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0 )
	self['Power']:SetSize( 137, 9 )

	self['Power']['bg'] = self['Power']:CreateTexture( nil, 'BORDER' )
	self['Power']['bg']:SetAllPoints( self['Power'] )
	self['Power']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Power']['bg']:SetAlpha( 0.30 )

	self['Power']['Value'] = Config['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Value']:SetPoint( 'LEFT', self['Power'], 'LEFT', 2, 1 )
	self['Power']['Value']:SetTextColor( 1, 1, 1 )

	self['Power']['Percent'] = Config['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Percent']:SetPoint( 'RIGHT', self['Power'], 'RIGHT', -2, 1 )
	self['Power']['Percent']:SetTextColor( 1, 1, 1 )

	self['Power']['frequentUpdates'] = true
	self['Power']['Smooth'] = true
	self['Power']['colorClass'] = true
	self['Power']['colorReaction'] = true
	self['Power']['colorDisconnected'] = true
	self['Power']['colorTapping'] = true

	self['Power']['PreUpdate'] = Functions['PreUpdatePower']
	self['Power']['PostUpdate'] = Functions['PostUpdatePower']

	--------------------------------------------------
	-- Health
	--------------------------------------------------
	self['Health'] = Config['StatusBar']( '$parent_HealthBar', self )
	self['Health']:SetPoint( 'BOTTOM', self['Power'], 'TOP', 0, 2 )
	self['Health']:SetSize( 137, 15 )

	self['Health']['bg'] = self['Health']:CreateTexture( nil, 'BORDER' )
	self['Health']['bg']:SetAllPoints( self['Health'] )
	self['Health']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Health']['bg']:SetAlpha( 0.30 )

	self['Health']['Value'] = Config['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
	self['Health']['Value']:SetPoint( 'LEFT', self['Health'], 'LEFT', 2, 0 )
	self['Health']['Value']:SetTextColor( 1, 1, 1 )

	self['Health']['Percent'] = Config['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
	self['Health']['Percent']:SetPoint( 'RIGHT', self['Health'], 'RIGHT', -2, 0 )
	self['Health']['Percent']:SetTextColor( 1, 1, 1 )

	self['Health']['frequentUpdates'] = true
	self['Health']['Smooth'] = true
	self['Health']['colorClass'] = true
	self['Health']['colorReaction'] = true
	self['Health']['colorDisconnected'] = true
	self['Health']['colorTapping'] = true

	self['Health']['PostUpdate'] = Functions['PostUpdateHealth'] 

	--------------------------------------------------
	-- Title
	--------------------------------------------------
	self['Title'] = CreateFrame( 'Frame', '$parent_TitleBar', self )
	self['Title']:SetPoint( 'BOTTOM', self['Health'], 'TOP', 0, 2 )
	self['Title']:SetSize( 137, 12 )

	self['Title']['Texture'] = self['Title']:CreateTexture( nil, 'ARTWORK' )
	self['Title']['Texture']:SetTexture( Config['Textures']['StatusBar'] )
	self['Title']['Texture']:SetVertexColor( 0.1, 0.1, 0.1, 1 )
	self['Title']['Texture']:SetAllPoints( self['Title'] )

	self['Level'] = Config['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 1, nil, 'LEFT', true )
	self['Level']:SetPoint( 'LEFT', self['Title'], 'LEFT', 2, -1 )
	self['Level']:SetTextColor( 1, 1, 1 )
	self:Tag( self['Level'], '[difficulty][hyp:level]' )

	self['Type'] = Config['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'LEFT', true )
	self['Type']:SetPoint( 'LEFT', self['Level'], 'RIGHT', 0, 0 )
	self['Type']:SetTextColor( 1, 1, 1 )
	self:Tag( self['Type'], '[hyp:type]' )

	self['Name'] = Config['FontString']( self['Health'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 1, nil, 'RIGHT', true )
	self['Name']:SetPoint( 'RIGHT', self['Title'], 'RIGHT', -2, -1 )
	self['Name']:SetTextColor( 1, 1, 1 )
	self:Tag( self['Name'], '[name:medium]' )

	--------------------------------------------------
	-- Portrait
	--------------------------------------------------
	self['Portrait'] = CreateFrame( 'PlayerModel', '$parent_Portrait', self )
	self['Portrait']:SetPoint( 'BOTTOMRIGHT', self['Power'], 'BOTTOMLEFT', -2, 1 )
	self['Portrait']:SetSize( 43, 39 )

	--------------------------------------------------
	-- CastBar
	--------------------------------------------------
	if( self['Config']['CastBar'] ) then
		self['Castbar'] = Config['StatusBar']( '$parent_CastBar', self, nil, { 0.4, 0.6, 0.8 } )
		self['Castbar']:SetPoint( 'LEFT', self:GetName() .. '_TitleBar', 'LEFT', 0, 0 )
		self['Castbar']:SetSize( self['Title']:GetWidth(), self['Title']:GetHeight() )

		self['Castbar']:SetFrameStrata( 'BACKGROUND' )
		self['Castbar']:SetFrameLevel( 3 )

		Functions['ApplyBackdrop']( self['Castbar'] )

		self['Castbar']['bg'] = self['Castbar']:CreateTexture( nil, 'BORDER' )
		self['Castbar']['bg']:SetAllPoints( self['Castbar'] )
		self['Castbar']['bg']:SetTexture( 0.15, 0.15, 0.15, 1 )

		self['Castbar']['Text'] = Config['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
		self['Castbar']['Text']:SetPoint( 'LEFT', self['Castbar'], 'LEFT', 2, 0 )
		self['Castbar']['Text']:SetTextColor( 1, 1, 1 )

		self['Castbar']['Time'] = Config['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
		self['Castbar']['Time']:SetPoint( 'RIGHT', self['Castbar'], 'RIGHT', -2, 0 )
		self['Castbar']['Time']:SetTextColor( 1, 1, 1 )

		if( self['Config']['CastBar']['Icons'] ) then
			self['Castbar']['Button'] = CreateFrame( 'Frame', nil, self['Castbar'] )
			self['Castbar']['Button']:SetPoint( 'TOPLEFT', self, 'TOPLEFT', 0, 0 )
			self['Castbar']['Button']:SetSize( 43, 40 )

			Functions['ApplyBackdrop']( self['Castbar']['Button'] )

			self['Castbar']['Icon'] = self['Castbar']['Button']:CreateTexture( nil, 'ARTWORK' )
			self['Castbar']['Icon']:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )

			Functions['SetInside']( self['Castbar']['Icon'], 0, 0 )
		end
	end
end

oUF:RegisterStyle( 'hypocrisy:focus', ApplyStyle )
oUF:SetActiveStyle( 'hypocrisy:focus' )
oUF:Spawn( 'focus', 'oUF_Focus' )
