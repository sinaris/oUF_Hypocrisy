local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Functions = NameSpace['Functions']

if( not Config['Units']['Player']['Enable'] ) then
	return
end

local ApplyStyle = function( self )
	--------------------------------------------------
	-- Defaults
	--------------------------------------------------
	self['Config'] = Config['Units']['Player']

	self:RegisterForClicks( 'AnyUp' )
	self:SetScript( 'OnEnter', UnitFrame_OnEnter )
	self:SetScript( 'OnLeave', UnitFrame_OnLeave )

	self:SetSize( self['Config']['Width'], self['Config']['Height'] )
	self:SetScale( Config['Scale'] )
	self:SetPoint( 'CENTER', UIParent, 'CENTER', -320, -126 )

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
	self['Power']:SetSize( 137, 10 )

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
	self['Health']:SetSize( 137, 16 )

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

	self['Power']['frequentUpdates'] = true
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
	self['Title']:SetSize( 137, 14 )

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
	self:Tag( self['Name'], '[name]' )

	--------------------------------------------------
	-- Portrait
	--------------------------------------------------
	self['Portrait'] = CreateFrame( 'PlayerModel', '$parent_Portrait', self )
	self['Portrait']:SetPoint( 'BOTTOMRIGHT', self['Power'], 'BOTTOMLEFT', -2, 1 )
	self['Portrait']:SetSize( 43, 43 )

	--------------------------------------------------
	-- CastBar
	--------------------------------------------------
	if( self['Config']['CastBar'] ) then
		if( self['Config']['CastBar']['Fixed'] ) then
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
			self['Castbar']['Text']:SetPoint( 'LEFT', self['Castbar'], 'LEFT', 2, 1 )
			self['Castbar']['Text']:SetTextColor( 1, 1, 1 )

			self['Castbar']['Time'] = Config['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
			self['Castbar']['Time']:SetPoint( 'RIGHT', self['Castbar'], 'RIGHT', -2, 1 )
			self['Castbar']['Time']:SetTextColor( 1, 1, 1 )

			if( self['Config']['CastBar']['SafeZone'] ) then
				self['Castbar']['SafeZone'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
				self['Castbar']['SafeZone']:SetTexture( Config['Textures']['StatusBar'] )
				self['Castbar']['SafeZone']:SetVertexColor( 0.8, 0.2, 0.2, 0.75 )
			end

			self['Castbar']['Spark'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
			self['Castbar']['Spark']:SetSize( 15, self['Castbar']:GetHeight() * 2 )
			self['Castbar']['Spark']:SetBlendMode( 'ADD' )

			if( self['Config']['CastBar']['Icons'] ) then
				self['Castbar']['Button'] = CreateFrame( 'Frame', nil, self['Castbar'] )
				self['Castbar']['Button']:SetPoint( 'TOPLEFT', self, 'TOPLEFT', 0, 0 )
				self['Castbar']['Button']:SetSize( 43, 44 )

				Functions['ApplyBackdrop']( self['Castbar']['Button'] )

				self['Castbar']['Icon'] = self['Castbar']['Button']:CreateTexture( nil, 'ARTWORK' )
				self['Castbar']['Icon']:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )

				Functions['SetInside']( self['Castbar']['Icon'], 0, 0 )
			end
		else
			self['Castbar'] = Config['StatusBar']( '$parent_CastBar', self, nil, { 0.4, 0.6, 0.8 } )
			self['Castbar']:SetPoint( 'CENTER', UIParent, 'CENTER', 0, -250 )
			self['Castbar']:SetSize( self['Config']['CastBar']['Width'], self['Config']['CastBar']['Height'] )

			self['Castbar']:SetFrameStrata( 'BACKGROUND' )
			self['Castbar']:SetFrameLevel( 3 )

			Functions['ApplyBackdrop']( self['Castbar'] )

			self['Castbar']['bg'] = self['Castbar']:CreateTexture( nil, 'BORDER' )
			self['Castbar']['bg']:SetAllPoints( self['Castbar'] )
			self['Castbar']['bg']:SetTexture( 0.15, 0.15, 0.15, 1 )

			self['Castbar']['Text'] = Config['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 3, nil, 'CENTER', true )
			self['Castbar']['Text']:SetPoint( 'LEFT', self['Castbar'], 'LEFT', 5, 0 )
			self['Castbar']['Text']:SetTextColor( 1, 1, 1 )

			self['Castbar']['Time'] = Config['FontString']( self['Castbar'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'] + 3, nil, 'CENTER', true )
			self['Castbar']['Time']:SetPoint( 'RIGHT', self['Castbar'], 'RIGHT', -5, 0 )
			self['Castbar']['Time']:SetTextColor( 1, 1, 1 )

			if( self['Config']['CastBar']['SafeZone'] ) then
				self['Castbar']['SafeZone'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
				self['Castbar']['SafeZone']:SetTexture( Config['Textures']['StatusBar'] )
				self['Castbar']['SafeZone']:SetVertexColor( 0.8, 0.2, 0.2, 0.75 )
			end

			self['Castbar']['Spark'] = self['Castbar']:CreateTexture( nil, 'ARTWORK' )
			self['Castbar']['Spark']:SetSize( 15, self['Castbar']:GetHeight() * 2 )
			self['Castbar']['Spark']:SetBlendMode( 'ADD' )

			if( self['Config']['CastBar']['Icons'] ) then
				self['Castbar']['Button'] = CreateFrame( 'Frame', nil, self['Castbar'] )
				self['Castbar']['Button']:SetPoint( 'RIGHT', self['Castbar'], 'LEFT', -5, 0 )
				self['Castbar']['Button']:SetSize( self['Config']['CastBar']['Height'], self['Config']['CastBar']['Height'] )

				Functions['ApplyBackdrop']( self['Castbar']['Button'] )

				self['Castbar']['Icon'] = self['Castbar']['Button']:CreateTexture( nil, 'ARTWORK' )
				self['Castbar']['Icon']:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )

				Functions['SetInside']( self['Castbar']['Icon'], 0, 0 )
			end
		end

		self['Castbar']['CustomTimeText'] = Functions['CastBars_CustomCastTimeText']
		self['Castbar']['CustomDelayText'] = Functions['CastBars_CustomCastDelayText']
		self['Castbar']['PostCastStart'] = Functions['CastBars_PostCastStart']
		self['Castbar']['PostChannelStart'] = Functions['CastBars_PostCastStart']
	end

	--------------------------------------------------
	-- Swing-Timer
	--------------------------------------------------
	if( self['Config']['SwingTimer'] ) then
		self['Swing'] = Config['StatusBar']( '$parent_SwingTimer', self, Config['Textures']['StatusBar'], { 0.2, 0.7, 0.1 } )
		self['Swing']:SetPoint( 'BOTTOMLEFT', self, 'TOPLEFT', 0, 34 )
		self['Swing']:SetSize( self:GetWidth(), 5 )

		Functions['ApplyBackdrop']( self['Swing'] )

		self['Swing']['bg'] = self['Swing']:CreateTexture( nil, 'BORDER' )
		self['Swing']['bg']:SetAllPoints( self['Swing'] )
		self['Swing']['bg']:SetTexture( Config['Textures']['StatusBar'] )
		self['Swing']['bg']:SetAlpha( 0.20 )
	end

	--------------------------------------------------
	-- ClassBars
	--------------------------------------------------
	local TotemBar = CreateFrame( 'Frame', '$parent_TotemBar', self )
	TotemBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	TotemBar:SetSize( 182, 5 )
	TotemBar:Hide()

	Functions['ApplyBackdrop']( TotemBar )

	TotemBar.activeTotems = 0
	TotemBar.Override = Functions['Totems_Override']

	for i = 1, MAX_TOTEMS do
		TotemBar[i] = Config['StatusBar']( nil, TotemBar )
		TotemBar[i]:GetStatusBarTexture():SetHorizTile( false )
		TotemBar[i]:SetFrameLevel( TotemBar:GetFrameLevel() + 1 )
		TotemBar[i]:EnableMouse( true )
		TotemBar[i]:SetMinMaxValues( 0, 1 )

		if( i == 1 ) then
			TotemBar[i]:SetSize( 44, 5 )
		else
			TotemBar[i]:SetSize( 45, 5 )
		end

		if i == 1 then
			TotemBar[i]:SetPoint( 'LEFT', TotemBar, 'LEFT', 0, 0 )
		else
			TotemBar[i]:SetPoint( 'LEFT', TotemBar[i - 1], 'RIGHT', 1, 0 )
		end

		TotemBar[i]['bg'] = TotemBar[i]:CreateTexture( nil, 'BORDER' )
		TotemBar[i]['bg']:SetAllPoints( TotemBar[i] )
		TotemBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )
		TotemBar[i]['bg']['multiplier'] = 0.3
	end

	self['Totems'] = TotemBar

	if( Config['PlayerClass'] == 'DEATHKNIGHT' ) then
		local RuneBar = CreateFrame( 'Frame', '$parent_RuneBar', self )
		RuneBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
		RuneBar:SetSize( 182, 5 )

		Functions['ApplyBackdrop']( RuneBar )

		for i = 1, 6 do
			RuneBar[i] = Config['StatusBar']( self:GetName() .. '_RuneBar', RuneBar )
			RuneBar[i]:GetStatusBarTexture():SetHorizTile( false )
			RuneBar[i]:SetFrameLevel( RuneBar:GetFrameLevel() + 1 )

			if( i == 1 or i == 3 or i == 6 ) then
				RuneBar[i]:SetSize( 29, 5 )
			else
				RuneBar[i]:SetSize( 30, 5 )
			end

			RuneBar[i]['bg'] = RuneBar[i]:CreateTexture( nil, 'BORDER' )
			RuneBar[i]['bg']:SetAllPoints( RuneBar[i] )
			RuneBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )
			RuneBar[i]['bg']:SetAlpha( 0.2 )

			if( i == 1 ) then
				RuneBar[i]:SetPoint( 'LEFT', RuneBar )
			else
				RuneBar[i]:SetPoint( 'LEFT', RuneBar[i - 1], 'RIGHT', 1, 0 )
			end
		end

		self['Runes'] = RuneBar
	end

	if( Config['PlayerClass'] == 'DRUID' ) then
		local DruidMana = Config['StatusBar']( '$parent_DruidMana', self['Health'], Config['Textures']['StatusBar'], { 0.30, 0.52, 0.90, 1 } )
		DruidMana:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
		DruidMana:SetSize( 182, 5 )

		Functions['ApplyBackdrop']( DruidMana )

		DruidMana['Background'] = DruidMana:CreateTexture( nil, 'BORDER' )
		DruidMana['Background']:SetAllPoints()
		DruidMana['Background']:SetTexture( 0.30, 0.52, 0.90, 0.2 )

		local EclipseBar = CreateFrame( 'Frame', '$parent_EclipseBar', self )
		EclipseBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
		EclipseBar:SetSize( 182, 5 )

		Functions['ApplyBackdrop']( EclipseBar )

		EclipseBar:Hide()

		EclipseBar['LunarBar'] = Config['StatusBar']( '$parent_EclipseLunarBar', EclipseBar, Config['Textures']['StatusBar'], { 0.50, 0.52, 0.70, 1 } )
		EclipseBar['LunarBar']:SetPoint( 'LEFT', EclipseBar, 'LEFT', 0, 0 )
		EclipseBar['LunarBar']:SetSize( EclipseBar:GetWidth(), EclipseBar:GetHeight() )

		EclipseBar['SolarBar'] = Config['StatusBar']( '$parent_EclipseSolarBar', EclipseBar, Config['Textures']['StatusBar'], { 0.80, 0.82, 0.60, 1 } )
		EclipseBar['SolarBar']:SetPoint( 'LEFT', EclipseBar['LunarBar']:GetStatusBarTexture(), 'RIGHT', 0, 0 )
		EclipseBar['SolarBar']:SetSize( EclipseBar:GetWidth(), EclipseBar:GetHeight() )

		EclipseBar:SetScript( 'OnShow', Functions['ClassBars_Druid'] )
		EclipseBar:SetScript( 'OnHide', Functions['ClassBars_Druid'] )

		self['DruidMana'] = DruidMana
		self['DruidMana']['bg'] = DruidMana['Background']
		self['EclipseBar'] = EclipseBar

		Config['Colors']['Totems'][1] = { 0.38, 0.87, 0.38 }
		Config['Colors']['Totems'][2] = { 0.38, 0.87, 0.38 }
		Config['Colors']['Totems'][3] = { 0.38, 0.87, 0.38 }

		local TotemBar = self['Totems']
		for i = 1, 3 do
			TotemBar[i]:ClearAllPoints()
			TotemBar[i]:SetHeight( 5 )
			TotemBar[i]:SetStatusBarColor( unpack( Config['Colors']['Totems'][i] ) )

			if( i == 1 ) then
				TotemBar[i]:SetPoint( 'LEFT', TotemBar )
			else
				TotemBar[i]:SetPoint( 'LEFT', TotemBar[i - 1], 'RIGHT', 1, 0 )
			end

			if( i == 1 or i == 2 ) then
				TotemBar[i]:SetSize( 59, 5 )
			else
				TotemBar[i]:SetSize( 60, 5 )
			end

			TotemBar[i].OriginalWidth = TotemBar[i]:GetWidth()
		end

		TotemBar[4]:Hide()

		TotemBar:SetScript( 'OnShow', Functions['ClassBars_Druid'] )
		TotemBar:SetScript( 'OnHide', Functions['ClassBars_Druid'] )
	end


















	if( Config['PlayerClass'] == 'PRIEST' ) then
		local ShadowOrbsBar = CreateFrame( 'Frame', '$parent_ShadowOrbsBar', self )
		ShadowOrbsBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
		ShadowOrbsBar:SetSize( 182, 5 )

		Functions['ApplyBackdrop']( ShadowOrbsBar )

		for i = 1, 5 do
			ShadowOrbsBar[i] = Config['StatusBar']( '$parent_ShadowOrbsBar', ShadowOrbsBar )
			ShadowOrbsBar[i]:GetStatusBarTexture():SetHorizTile( false )
			ShadowOrbsBar[i]:SetFrameLevel( ShadowOrbsBar:GetFrameLevel() + 1 )

			ShadowOrbsBar[i]['bg'] = ShadowOrbsBar[i]:CreateTexture( nil, 'BORDER' )
			ShadowOrbsBar[i]['bg']:SetAllPoints( ShadowOrbsBar[i] )
			ShadowOrbsBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )

			if( i == 1 or i == 2 ) then
				ShadowOrbsBar[i]:SetSize( 35, 5 )
			else
				ShadowOrbsBar[i]:SetSize( 36, 5 )
			end

			if( i == 1 ) then
				ShadowOrbsBar[i]:SetPoint( 'LEFT', ShadowOrbsBar )
			else
				ShadowOrbsBar[i]:SetPoint( 'LEFT', ShadowOrbsBar[i - 1], 'RIGHT', 1, 0 )
			end
		end

		local WeakenedSoul = Config['StatusBar']( '$parent_WeakendSoulBar', self['Power'], nil, { 0.75, 0.04, 0.04 } )
		WeakenedSoul:SetAllPoints( self['Power'] )
		WeakenedSoul:SetFrameLevel( self['Power']:GetFrameLevel() )

		Config['Colors']['Totems'][1] = { 0.93, 0.87, 0.51 }

		local TotemBar = self['Totems']
		TotemBar[1]:ClearAllPoints()
		TotemBar[1]:SetAllPoints()

		for i = 2, MAX_TOTEMS do
			TotemBar[i]:Hide()
		end

		TotemBar:SetScript( "OnShow", Functions['ClassBars_Priest'] )
		TotemBar:SetScript( "OnHide", Functions['ClassBars_Priest'] )

		local SerendipityBar = CreateFrame( 'Frame', '$parent_SerendipityBar', self )
		SerendipityBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
		SerendipityBar:SetSize( 182, 5 )

		Functions['ApplyBackdrop']( SerendipityBar )

		for i = 1, 2 do
			SerendipityBar[i] = Config['StatusBar']( '$parent_ShadowOrbsBar', SerendipityBar )
			SerendipityBar[i]:GetStatusBarTexture():SetHorizTile( false )
			SerendipityBar[i]:SetFrameLevel( SerendipityBar:GetFrameLevel() + 1 )

			if( i == 1 ) then
				SerendipityBar[i]:SetSize( 91, 5 )
			else
				SerendipityBar[i]:SetSize( 90, 5 )
			end

			if( i == 1 ) then
				SerendipityBar[i]:SetPoint( 'LEFT', SerendipityBar )
			else
				SerendipityBar[i]:SetPoint( 'LEFT', SerendipityBar[i - 1], 'RIGHT', 1, 0 )
			end
		end

		SerendipityBar:SetScript( 'OnShow', Functions['ClassBars_Priest'] )
		SerendipityBar:SetScript( 'OnHide', Functions['ClassBars_Priest'] )

		self['ShadowOrbsBar'] = ShadowOrbsBar
		self['WeakenedSoul'] = WeakenedSoul
		self['SerendipityBar'] = SerendipityBar
	end

	--------------------------------------------------
	-- Indicators
	--------------------------------------------------
	self['Leader'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
	self['Leader']:SetPoint( 'CENTER', self['Title'], 'CENTER', 0, 4 )
	self['Leader']:SetSize( 12, 12 )

	self['MasterLooter'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
	self['MasterLooter']:SetPoint( 'CENTER', self['Title'], 'CENTER', -14, 5 )
	self['MasterLooter']:SetSize( 12, 12 )

	self['RaidIcon'] = self['RaisedFrame']:CreateTexture( nil, 'OVERLAY' )
	self['RaidIcon']:SetPoint( 'TOP', self['Title'], 'CENTER', 0, 10 )
	self['RaidIcon']:SetSize( 18, 18 )
end

oUF:RegisterStyle( 'hypocrisy:player', ApplyStyle )
oUF:SetActiveStyle( 'hypocrisy:player' )
oUF:Spawn( 'player', 'oUF_Player' )
