local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Constructors = NameSpace['Constructors']
local Functions = NameSpace['Functions']

local Resources = CreateFrame( 'Frame' )
NameSpace['Resources'] = Resources

--------------------------------------------------
-- Death Knight
--------------------------------------------------
Resources['DEATHKNIGHT'] = function( self, Unit )
	local RuneBar = CreateFrame( 'Frame', self:GetName() .. '_RuneBar', self )
	RuneBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	RuneBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( RuneBar )

	for i = 1, 6 do
		RuneBar[i] = Constructors['StatusBar']( self:GetName() .. '_RuneBar', RuneBar )
		RuneBar[i]:GetStatusBarTexture():SetHorizTile( false )
		RuneBar[i]:SetFrameLevel( RuneBar:GetFrameLevel() + 1 )

		if( i == 1 ) then
			RuneBar[i]:SetSize( 30, 5 )
		else
			RuneBar[i]:SetSize( 29, 5 )
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

	Config['Colors']['Totems'][1] = { 0.60, 0.40, 0 }

	local TotemBar = Constructors['TotemBar']( self, Unit )
	TotemBar[1]:ClearAllPoints()
	TotemBar[1]:SetAllPoints()

	for i = 2, MAX_TOTEMS do
		TotemBar[i]:Hide()
	end

	self['Runes'] = RuneBar
	self['Totems'] = TotemBar
end

--------------------------------------------------
-- Druid
--------------------------------------------------
Resources['DRUID'] = function( self, Unit )
	Config['Colors']['Totems'][1] = { 0.38, 0.87, 0.38 }
	Config['Colors']['Totems'][2] = { 0.38, 0.87, 0.38 }
	Config['Colors']['Totems'][3] = { 0.38, 0.87, 0.38 }

	local TotemBar = Constructors['TotemBar']( self, Unit )
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

	self['Totems'] = TotemBar

	TotemBar:SetScript( 'OnShow', Functions['UnitFrames_DruidBars'] )
	TotemBar:SetScript( 'OnHide', Functions['UnitFrames_DruidBars'] )

	local DruidMana = Constructors['StatusBar']( self:GetName() .. '_DruidMana', self['Health'], Config['Textures']['StatusBar'], { 0.30, 0.52, 0.90, 1 } )
	DruidMana:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	DruidMana:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( DruidMana )

	DruidMana['Background'] = DruidMana:CreateTexture( nil, 'BORDER' )
	DruidMana['Background']:SetAllPoints()
	DruidMana['Background']:SetTexture( 0.30, 0.52, 0.90, 0.2 )

	local EclipseBar = CreateFrame( 'Frame', self:GetName() .. '_EclipseBar', self )
	EclipseBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	EclipseBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( EclipseBar )

	EclipseBar:Hide()

	EclipseBar['LunarBar'] = Constructors['StatusBar']( self:GetName() .. '_EclipseLunarBar', EclipseBar, Config['Textures']['StatusBar'], { 0.50, 0.52, 0.70, 1 } )
	EclipseBar['LunarBar']:SetPoint( 'LEFT', EclipseBar, 'LEFT', 0, 0 )
	EclipseBar['LunarBar']:SetSize( EclipseBar:GetWidth(), EclipseBar:GetHeight() )

	EclipseBar['SolarBar'] = Constructors['StatusBar']( self:GetName() .. '_EclipseSolarBar', EclipseBar, Config['Textures']['StatusBar'], { 0.80, 0.82, 0.60, 1 } )
	EclipseBar['SolarBar']:SetPoint( 'LEFT', EclipseBar['LunarBar']:GetStatusBarTexture(), 'RIGHT', 0, 0 )
	EclipseBar['SolarBar']:SetSize( EclipseBar:GetWidth(), EclipseBar:GetHeight() )

	EclipseBar['Value'] = Constructors['FontString']( self['RaisedFrame'], 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], nil, 'CENTER', true )
	EclipseBar['Value']:SetPoint( 'BOTTOM', EclipseBar, 'TOP', 0, 25 )

	EclipseBar['PostUpdatePower'] = Functions['UnitFrames_EclipseDirection']

	EclipseBar:SetScript( 'OnShow', Functions['UnitFrames_DruidBars'] )
	EclipseBar:SetScript( 'OnHide', Functions['UnitFrames_DruidBars'] )

	self['DruidMana'] = DruidMana
	self['DruidMana']['bg'] = DruidMana['Background']
	self['EclipseBar'] = EclipseBar
end

--------------------------------------------------
-- Hunter
--------------------------------------------------
Resources['HUNTER'] = function( self, Unit )

end

--------------------------------------------------
-- Mage
--------------------------------------------------
Resources['MAGE'] = function( self, Unit )
	local ArcaneChargeBar = CreateFrame( 'Frame', self:GetName() .. '_ArcaneChargeBar', self )
	ArcaneChargeBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	ArcaneChargeBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( ArcaneChargeBar )

	for i = 1, 4 do
		ArcaneChargeBar[i] = Constructors['StatusBar']( self:GetName() .. '_ArcaneChargeBar', ArcaneChargeBar )
		ArcaneChargeBar[i]:GetStatusBarTexture():SetHorizTile( false )
		ArcaneChargeBar[i]:SetFrameLevel( ArcaneChargeBar:GetFrameLevel() + 1 )

		ArcaneChargeBar[i]['bg'] = ArcaneChargeBar[i]:CreateTexture( nil, 'BORDER' )
		ArcaneChargeBar[i]['bg']:SetAllPoints( ArcaneChargeBar[i] )
		ArcaneChargeBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )

		if( i == 1 ) then
			ArcaneChargeBar[i]:SetSize( 89, 5 )
			ArcaneChargeBar[i]:SetPoint( 'LEFT', ArcaneChargeBar )
		else
			ArcaneChargeBar[i]:SetSize( 90, 5 )
			ArcaneChargeBar[i]:SetPoint( 'LEFT', ArcaneChargeBar[i - 1], 'RIGHT', 1, 0 )
		end
	end

	Config['Colors']['Totems'] = {
		[1] = { 0.52, 0.44, 1 },
		[2] = { 0.52, 0.44, 1 },
	}

	local TotemBar = Constructors['TotemBar']( self, Unit )
	TotemBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 15 )

	for i = 1, 2 do
		TotemBar[i]:ClearAllPoints()

		if( i == 1 ) then
			TotemBar[i]:SetSize( 89, 5 )
			TotemBar[i]:SetPoint( 'LEFT', TotemBar, 'LEFT', 0, 0 )
		else
			TotemBar[i]:SetSize( 90, 5 )
			TotemBar[i]:SetPoint( 'LEFT', TotemBar[i - 1], 'RIGHT', 1, 0 )
		end
	end

	TotemBar[3]:Hide()
	TotemBar[4]:Hide()

	self['ArcaneChargeBar'] = ArcaneChargeBar
	self['Totems'] = TotemBar
end

--------------------------------------------------
-- Monk
--------------------------------------------------
Resources['MONK'] = function( self, Unit )

end

--------------------------------------------------
-- Paladin
--------------------------------------------------
Resources['PALADIN'] = function( self, Unit )

end

--------------------------------------------------
-- Priest
--------------------------------------------------
Resources['PRIEST'] = function( self, Unit )
	local ShadowOrbsBar = CreateFrame( 'Frame', self:GetName() .. '_ShadowOrbsBar', self )
	ShadowOrbsBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	ShadowOrbsBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( ShadowOrbsBar )

	for i = 1, 5 do
		ShadowOrbsBar[i] = Constructors['StatusBar']( self:GetName() .. '_ShadowOrbsBar', ShadowOrbsBar )
		ShadowOrbsBar[i]:GetStatusBarTexture():SetHorizTile( false )
		ShadowOrbsBar[i]:SetFrameLevel( ShadowOrbsBar:GetFrameLevel() + 1 )

		ShadowOrbsBar[i]['bg'] = ShadowOrbsBar[i]:CreateTexture( nil, 'BORDER' )
		ShadowOrbsBar[i]['bg']:SetAllPoints( ShadowOrbsBar[i] )
		ShadowOrbsBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )

		if( i == 1 ) then
			ShadowOrbsBar[i]:SetPoint( 'LEFT', ShadowOrbsBar )
		else
			ShadowOrbsBar[i]:SetPoint( 'LEFT', ShadowOrbsBar[i - 1], 'RIGHT', 1, 0 )
		end

		if( i == 1 ) then
			ShadowOrbsBar[i]:SetSize( 45, 5 )
		else
			ShadowOrbsBar[i]:SetSize( 46, 5 )
		end
	end

	local WeakenedSoul = Constructors['StatusBar']( self:GetName() .. '_WeakendSoulBar', self['Power'], nil, { 0.75, 0.04, 0.04 } )
	WeakenedSoul:SetAllPoints( self['Power'] )
	WeakenedSoul:SetFrameLevel( self['Power']:GetFrameLevel() )

	self['ShadowOrbsBar'] = ShadowOrbsBar
	self['WeakenedSoul'] = WeakenedSoul
end

--------------------------------------------------
-- Rogue
--------------------------------------------------
Resources['ROGUE'] = function( self, Unit )
	local ComboPointsBar = CreateFrame( 'Frame', self:GetName() .. '_ComboPointsBar', self )
	ComboPointsBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	ComboPointsBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( ComboPointsBar )

	for i = 1, 5 do
		ComboPointsBar[i] = Constructors['StatusBar']( self:GetName() .. '_ComboPointsBar', ComboPointsBar )
		ComboPointsBar[i]:GetStatusBarTexture():SetHorizTile( false )
		ComboPointsBar[i]:SetFrameLevel( ComboPointsBar:GetFrameLevel() + 1 )

		ComboPointsBar[i]['bg'] = ComboPointsBar[i]:CreateTexture( nil, 'BORDER' )
		ComboPointsBar[i]['bg']:SetAllPoints( ComboPointsBar[i] )
		ComboPointsBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )

		if( i == 1 ) then
			ComboPointsBar[i]:SetPoint( 'LEFT', ComboPointsBar )
		else
			ComboPointsBar[i]:SetPoint( 'LEFT', ComboPointsBar[i - 1], 'RIGHT', 1, 0 )
		end

		if( i == 5 or i == 2 or i == 3 or i == 4 ) then
			ComboPointsBar[i]:SetSize( 35, 5 )
		else
			ComboPointsBar[i]:SetSize( 36, 5 )
		end
	end

	local AnticipationBar = CreateFrame( 'Frame', self:GetName() .. '_AnticipationBar', self )
	AnticipationBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 15 )
	AnticipationBar:SetSize( 180, 5 )

	Functions['ApplyBackdrop']( AnticipationBar )

	for i = 1, 5 do
		AnticipationBar[i] = Constructors['StatusBar']( self:GetName() .. '_AnticipationBar', AnticipationBar )
		AnticipationBar[i]:GetStatusBarTexture():SetHorizTile( false )
		AnticipationBar[i]:SetFrameLevel( AnticipationBar:GetFrameLevel() + 1 )

		AnticipationBar[i]['bg'] = AnticipationBar[i]:CreateTexture( nil, 'BORDER' )
		AnticipationBar[i]['bg']:SetAllPoints( AnticipationBar[i] )
		AnticipationBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )

		if( i == 1 ) then
			AnticipationBar[i]:SetPoint( 'LEFT', AnticipationBar )
		else
			AnticipationBar[i]:SetPoint( 'LEFT', AnticipationBar[i - 1], 'RIGHT', 1, 0 )
		end

		if( i == 5 or i == 2 or i == 3 or i == 4 ) then
			AnticipationBar[i]:SetSize( ( 180 / 5 ) - 1, 5 )
		else
			AnticipationBar[i]:SetSize( 180 / 5, 5 )
		end
	end

	self['ComboPointsBar'] = ComboPointsBar
	self['AnticipationBar'] = AnticipationBar
end

--------------------------------------------------
-- Shaman
--------------------------------------------------
Resources['SHAMAN'] = function( self, Unit )
	local TotemBar = Constructors['TotemBar']( self, Unit )

	self['Totems'] = TotemBar
end

--------------------------------------------------
-- Warrior
--------------------------------------------------
Resources['WARRIOR'] = function( self, Unit )

end

--------------------------------------------------
-- Warlock
--------------------------------------------------
Resources['WARLOCK'] = function( self, Unit )

end
