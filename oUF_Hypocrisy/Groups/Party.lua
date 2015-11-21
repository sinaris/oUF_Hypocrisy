local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Functions = NameSpace['Functions']

if( not Config['Units']['Party']['Enable'] ) then
	return
end

local ApplyStyle = function( self )
	--------------------------------------------------
	-- Defaults
	--------------------------------------------------
	self['Config'] = Config['Units']['Party']

	self:RegisterForClicks( 'AnyUp' )
	self:SetScript( 'OnEnter', UnitFrame_OnEnter )
	self:SetScript( 'OnLeave', UnitFrame_OnLeave )

	self:SetFrameStrata( 'BACKGROUND' )
	self:SetFrameLevel( 1 )

	Functions['ApplyBackdrop']( self )

	self['RaisedFrame'] = CreateFrame( 'Frame', '$parent_RaisedFrame', self )
	self['RaisedFrame']:SetAllPoints( self )
	self['RaisedFrame']:SetFrameLevel( self:GetFrameLevel() + 20 )

	--------------------------------------------------
	-- Power
	--------------------------------------------------
	self['Power'] = Config['StatusBar']( self:GetName() .. '_PowerBar', self )
	self['Power']:SetPoint( 'BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0 )
	self['Power']:SetSize( 137, 9 )

	self['Power']['bg'] = self['Power']:CreateTexture( nil, 'BORDER' )
	self['Power']['bg']:SetAllPoints( self['Power'] )
	self['Power']['bg']:SetTexture( Config['Textures']['StatusBar'] )
	self['Power']['bg']:SetAlpha( 0.30 )

	self['Power']['Value'] = Config['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Value']:SetPoint( 'LEFT', self['Power'], 'LEFT', 2, 0 )
	self['Power']['Value']:SetTextColor( 1, 1, 1 )

	self['Power']['Percent'] = Config['FontString']( self['Power'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] - 1, nil, 'CENTER', true )
	self['Power']['Percent']:SetPoint( 'RIGHT', self['Power'], 'RIGHT', -2, 0 )
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
	self['Health'] = Config['StatusBar']( self:GetName() .. '_HealthBar', self )
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
	self['Title'] = CreateFrame( 'Frame', self:GetName() .. '_TitleBar', self )
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
	self['Portrait'] = CreateFrame( 'PlayerModel', self:GetName() .. '_Portrait', self )
	self['Portrait']:SetPoint( 'BOTTOMRIGHT', self['Power'], 'BOTTOMLEFT', -2, 1 )
	self['Portrait']:SetSize( 43, 39 )

	--------------------------------------------------
	-- CastBar
	--------------------------------------------------
	if( self['Config']['CastBar'] ) then
		self['Castbar'] = Config['StatusBar']( self:GetName() .. '_CastBar', self, nil, { 0.4, 0.6, 0.8 } )
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

	--------------------------------------------------
	-- Buffs
	--------------------------------------------------
	if( self['Config']['Buffs'] ) then
		self['Buffs'] = CreateFrame( 'Frame', self:GetName() .. '_Buffs', self )
		self['Buffs']:SetPoint( 'TOPLEFT', self, 'BOTTOMLEFT', 0, -5 )
		self['Buffs']:SetHeight( 18.5 )
		self['Buffs']:SetWidth( 185 )

		self['Buffs']['initialAnchor'] = 'TOPLEFT'
		self['Buffs']['growth-y'] = 'DOWN'
		self['Buffs']['size'] = 18
		self['Buffs']['num'] = 36
		self['Buffs']['spacing'] = 5

		self['Buffs']['PostCreateIcon'] = Functions['PostCreateAura']
		self['Buffs']['PostUpdateIcon'] = Functions['PostUpdateAura']
	end

	--------------------------------------------------
	-- HealPredictionBar
	--------------------------------------------------
	if( self['Config']['HealPredictionBar_MyBar'] ) then
		local MyBar = Config['StatusBar']( self:GetName() .. '_HealPredictionBar_MyBar', self['Health'] )
		MyBar:SetPoint( 'TOPLEFT', self['Health']:GetStatusBarTexture(), 'TOPRIGHT', 0, 0 )
		MyBar:SetPoint( 'BOTTOMLEFT', self['Health']:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0 )
		MyBar:SetWidth( 137 )
		MyBar:SetStatusBarColor( 0, 0.3, 0.15, 1 )

		local OtherBar = Config['StatusBar']( self:GetName() .. '_HealPredictionBar_OtherBar', self['Health'] )
		OtherBar:SetPoint( 'TOPLEFT', self['Health']:GetStatusBarTexture(), 'TOPRIGHT', 0, 0 )
		OtherBar:SetPoint( 'BOTTOMLEFT', self['Health']:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0 )
		OtherBar:SetWidth( 137 )
		OtherBar:SetStatusBarColor( 0, 0.3, 0, 1 )

		local AbsorbBar = Config['StatusBar']( self:GetName() .. '_HealPredictionBar_AbsorbBar', self['Health'] )
		AbsorbBar:SetPoint( 'TOPLEFT', self['Health']:GetStatusBarTexture(), 'TOPRIGHT', 0, 0 )
		AbsorbBar:SetPoint( 'BOTTOMLEFT', self['Health']:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0 )
		AbsorbBar:SetWidth( 137 )
		AbsorbBar:SetStatusBarColor( 0.3, 0.3, 0, 1 )

		local HealAbsorbBar = Config['StatusBar']( self:GetName() .. '_HealPredictionBar_HealAbsorbBar', self['Health'] )
		HealAbsorbBar:SetPoint( 'TOPLEFT', self['Health']:GetStatusBarTexture(), 'TOPRIGHT', 0, 0 )
		HealAbsorbBar:SetPoint( 'BOTTOMLEFT', self['Health']:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0 )
		HealAbsorbBar:SetWidth( 137 )

		self['HealPrediction'] = {
			myBar = MyBar,
			otherBar = OtherBar,
			absorbBar = AbsorbBar,
			healAbsorbBar = HealAbsorbBar,
			maxOverflow = 1,
			frequentUpdates = true,
		}
	end

	--------------------------------------------------
	-- Indicators
	--------------------------------------------------
	if( self['Config']['Indicators'] ) then
		self['Leader'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		self['Leader']:SetPoint( 'CENTER', self['Title'], 'CENTER', 0, 4 )
		self['Leader']:SetSize( 12, 12 )

		self['Assistant'] = self.Health:CreateTexture( nil, 'OVERLAY' )
		self['Assistant']:SetPoint( 'CENTER', self['Title'], 'CENTER', 14, 5 )
		self['Assistant']:SetSize( 12, 12 )

		self['MasterLooter'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		self['MasterLooter']:SetPoint( 'CENTER', self['Title'], 'CENTER', -14, 5 )
		self['MasterLooter']:SetSize( 12, 12 )

		self['LFDRole'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		self['LFDRole']:SetPoint( 'BOTTOMLEFT', self['RaisedFrame'], 'BOTTOMLEFT', 2, 2 )
		self['LFDRole']:SetSize( 12, 12 )

		self['RaidIcon'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		self['RaidIcon']:SetPoint( 'TOP', self['Title'], 'CENTER', 0, 10 )
		self['RaidIcon']:SetSize( 18, 18 )

		self['ReadyCheck'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
		self['ReadyCheck']:SetPoint( 'BOTTOMLEFT', self, 'BOTTOMLEFT', 10, 2 )
		self['ReadyCheck']:SetSize( 18, 18 )
	end

	--------------------------------------------------
	-- Threat
	--------------------------------------------------
	if( self['Config']['ThreatBorder'] ) then
		table.insert( self.__elements, Functions['UpdateThreat'] )
		self:RegisterEvent( 'PLAYER_TARGET_CHANGED', Functions['UpdateThreat'] )
		self:RegisterEvent( 'UNIT_THREAT_LIST_UPDATE', Functions['UpdateThreat'] )
		self:RegisterEvent( 'UNIT_THREAT_SITUATION_UPDATE', Functions['UpdateThreat'] )
	end

	--------------------------------------------------
	-- Range
	--------------------------------------------------
	if( self['Config']['Range'] ) then
		local Range = {
			insideAlpha = 1.0,
			outsideAlpha = 0.5,
		}

		self['Range'] = Range
	end

end

oUF:RegisterStyle( 'hypocrisy:party', ApplyStyle )
oUF:SetActiveStyle( 'hypocrisy:party' )
local PartyFrames = oUF:SpawnHeader( 'PartyFrames', nil, 'custom [@raid6,exists] hide;show',
	'oUF-initialConfigFunction', ( [[
		self:SetWidth(%d)
		self:SetHeight(%d)
	]] ):format( 182, 40 ),
	'showPlayer', true,
	'showSolo', false,
	'showParty', true,
	'showRaid', false,
	'yOffset', -50,
	'point', 'TOP',
	'groupingOrder', 'TANK,HEALER,DAMAGER,NONE',
	'groupBy', 'ASSIGNEDROLE',
	'sortMethod', 'NAME'
)
PartyFrames:ClearAllPoints()
PartyFrames:SetPoint( 'TOPLEFT', UIParent, 'TOPLEFT', 15, -40)