local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Constructors = NameSpace['Constructors']
local Functions = NameSpace['Functions']
local Resources = NameSpace['Resources']

local UnitFramesFunctions = CreateFrame( 'Frame' )
NameSpace['UnitFramesFunctions'] = UnitFramesFunctions

Functions['PostUpdateHealth'] = function( Health, Unit, Min, Max )
	if( not UnitIsConnected( Unit ) or UnitIsDead( Unit ) or UnitIsGhost( Unit ) ) then
		if( Health['Value'] ) then
			Health['Value']:SetText( '' )
		end

		if( Health['Percent'] ) then
			Health['Percent']:SetTextColor( 0.8, 0.8, 0.8 )
		end

		if( not UnitIsConnected( Unit ) ) then
			if( Health['Percent'] ) then
				Health['Percent']:SetText( '|cffd7bea5' .. 'Offline' .. '|r' )
			end
		elseif( UnitIsDead( Unit ) ) then
			if( Health['Percent'] ) then
				Health['Percent']:SetText( '|cffd7bea5' .. 'Dead' .. '|r' )
			end
		elseif( UnitIsGhost( Unit ) ) then
			if( Health['Percent'] ) then
				Health['Percent']:SetText( '|cffd7bea5' .. 'Ghost' .. '|r' )
			end
		end
	else
		local R, G, B
		local Percent = floor( ( Min / Max ) * 100 )

		if( Min ~= Max ) then
			R, G, B = Functions['ColorGradient']( Min, Max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33 )
			Health:SetStatusBarColor( R, G, B )
		end

		if( Health['Value'] ) then
			Health['Value']:SetText( Min .. '/' .. Max )
		end

		if( Health['Percent'] ) then
			Health['Percent']:SetText( Percent .. '%' )
		end
	end
end

Functions['PreUpdatePower'] = function( Power, Unit )
	local PowerType = select( 2, UnitPowerType( Unit ) )
	local Color = Config['Colors']['Power'][PowerType]

	if( Color ) then
		Power:SetStatusBarColor( Color[1], Color[2], Color[3] )
	end
end

Functions['PostUpdatePower'] = function( Power, Unit, Min, Max )
	if( not UnitIsPlayer( Unit ) ) then
		if( Power['Value'] ) then
			Power['Value']:SetText( ' ' )
		end

		if( Power['Percent'] ) then
			Power['Percent']:SetText( ' ' )
		end
	else
		local pType, pToken = UnitPowerType( Unit )
		local Color = Config['Colors']['Power'][pToken]

		if( Color ) then
			Power:SetStatusBarColor( Color[1], Color[2], Color[3] )
		end

		if( not UnitIsPlayer( Unit ) and not UnitPlayerControlled( Unit ) or not UnitIsConnected( Unit ) ) then
			if( Power['Value'] ) then
				Power['Value']:SetText( ' ' )
			end
		elseif( UnitIsDead( Unit ) or UnitIsGhost( Unit ) ) then
			if( Power['Value'] ) then
				Power['Value']:SetText( ' ' )
			end
		else
			if( Power['Value'] ) then
				Power['Value']:SetText( Min .. '/' .. Max )
			end

			if( Power['Percent'] ) then
				Power['Percent']:SetText( pToken )
			end

			if( pToken ~= 'MANA' ) then
				if( Power['Percent'] ) then
					Power['Percent']:SetText( Min )
				end
			else
				if( Power['Percent'] ) then
					Power['Percent']:SetText( floor( Min / Max * 100 ) .. '%' )
				end
			end
		end
	end
end

--------------------------------------------------
-- CastBars
--------------------------------------------------
Functions['UnitFrames_CastBars_CustomCastTimeText'] = function( self, Duration )
	local Value = format( '%.1f / %.1f', self.channeling and Duration or self.max - Duration, self.max )

	self['Time']:SetText( Value )
end

Functions['UnitFrames_CastBars_CustomCastDelayText'] = function( self, Duration )
	local Value = format( '%.1f |cffaf5050%s %.1f|r', self.channeling and Duration or self.max - Duration, self.channeling and '- ' or '+', self.delay )

	self['Time']:SetText( Value )
end

Functions['UnitFrames_CastBars_PostCastStart'] = function( self, Unit, Name, Rank, CastID )
	if( Unit == 'vehicle' ) then
		Unit = 'player'
	end

	if( Name == 'Opening' and self['Text'] ) then
		self['Text']:SetText( 'Opening' )
	elseif( self['Text'] ) then
		if( Unit ~= 'player' ) then
			self['Text']:SetText( Functions['ShortenString']( Name, 20, true ) )
		else
			self['Text']:SetText( Functions['ShortenString']( Name, 20, true ) )
		end
	end

	if( self['interrupt'] and Unit ~= 'player' ) then
		if( UnitCanAttack( 'player', Unit ) ) then
			self:SetStatusBarColor( unpack( Config['Units']['CastBars']['NoInterruptColor'] ) )
		else
			self:SetStatusBarColor( unpack( Config['Units']['CastBars']['NoInterruptColor'] ) )
		end
	else
		if( Config['Units']['CastBars']['ClassColor'] and ( Unit == 'player' or Unit == 'target' ) ) then
			self:SetStatusBarColor( unpack( Config['Colors']['Class'][Config.PlayerClass] ) )
		else
			self:SetStatusBarColor( unpack( Config['Units']['CastBars']['Color'] ) )
		end
	end
end

--------------------------------------------------
-- Totems
--------------------------------------------------
local hasbit = function( x, p )
	return x % ( p + p ) >= p
end

local setbit = function( x, p )
	return hasbit( x, p ) and x or x + p
end

local clearbit = function( x, p )
	return hasbit( x, p ) and x - p or x
end

Functions['UnitFrames_Totems_UpdateTimers'] = function( self, elapsed )
	self.TimeLeft = self.TimeLeft - elapsed

	if( self.TimeLeft > 0 ) then
		self:SetValue( self.TimeLeft )
	else
		self:SetValue( 0 )
		self:SetScript( 'OnUpdate', nil )
	end
end

Functions['UnitFrames_Totems_Override'] = function( self, event, slot )
	local Bar = self.Totems
	local Priorities = Bar.__map

	if( Bar.PreUpdate ) then
		Bar:PreUpdate( Priorities[slot] )
	end

	local Totem = Bar[Priorities[slot]]
	local HaveTotem, Name, Start, Duration, Icon = GetTotemInfo( slot )
	local Colors = Config['Colors']['Totems']

	if( not Colors[slot] ) then
		return
	end

	local R, G, B = unpack( Colors[slot] )

	if( HaveTotem ) then
		Totem.TimeLeft = ( Start + Duration ) - GetTime()
		Totem:SetMinMaxValues( 0, Duration )
		Totem:SetScript( 'OnUpdate', Functions['UnitFrames_Totems_UpdateTimers'] )
		Totem:SetStatusBarColor( R, G, B )

		Bar.activeTotems = setbit( Bar.activeTotems, 2 ^ ( slot - 1 ) )
	else
		Totem:SetValue( 0 )
		Totem:SetScript( 'OnUpdate', nil )

		Bar.activeTotems = clearbit( Bar.activeTotems, 2 ^ ( slot - 1 ) )
	end

	if( Totem.bg ) then
		local Multiplier = Totem.bg.multiplier or 0.3

		R, G, B = R * Multiplier, G * Multiplier, B * Multiplier

		Totem.bg:SetVertexColor( R, G, B )
	end

	if( Bar.activeTotems > 0 ) then
		Bar:Show()
	else
		Bar:Hide()
	end

	if( Bar.PostUpdate ) then
		return Bar:PostUpdate( Priorities[slot], HaveTotem, Name, Start, Duration, Icon )
	end
end

Constructors['TotemBar'] = function( self, Unit )
	local TotemBar = CreateFrame( 'Frame', self:GetName() .. '_TotemBar', self )
	TotemBar:SetPoint( 'BOTTOM', self, 'TOP', 0, 5 )
	TotemBar:SetSize( 180, 5 )
	TotemBar:Hide()

	TotemBar:SetBackdrop( Config['Backdrop'] )
	TotemBar:SetBackdropColor( 0, 0, 0, 1 )

	TotemBar.activeTotems = 0
	TotemBar.Override = Functions['UnitFrames_Totems_Override']

	for i = 1, MAX_TOTEMS do
		TotemBar[i] = Constructors['StatusBar']( nil, TotemBar )
		TotemBar[i]:GetStatusBarTexture():SetHorizTile( false )
		TotemBar[i]:SetFrameLevel( TotemBar:GetFrameLevel() + 1 )
		TotemBar[i]:EnableMouse( true )
		TotemBar[i]:SetMinMaxValues( 0, 1 )

		if( i == 1 or i == 2 or i == 3 ) then
			TotemBar[i]:SetSize( 44, 5 )
		else
			TotemBar[i]:SetSize( 45, 5 )
		end

		if i == 1 then
			TotemBar[i]:SetPoint( 'LEFT', TotemBar, 'LEFT', 0, 0 )
		else
			TotemBar[i]:SetPoint( 'LEFT', TotemBar[i-1], 'RIGHT', 1, 0 )
		end

		TotemBar[i]['bg'] = TotemBar[i]:CreateTexture( nil, 'BORDER' )
		TotemBar[i]['bg']:SetAllPoints( TotemBar[i] )
		TotemBar[i]['bg']:SetTexture( Config['Textures']['StatusBar'] )
		TotemBar[i]['bg']['multiplier'] = 0.3
	end

	return TotemBar
end

--------------------------------------------------
-- Classes
--------------------------------------------------
Functions['UnitFrames_EclipseDirection'] = function( EclipseBar )
	local Power = UnitPower( 'Player', SPELL_POWER_ECLIPSE )

	if( Power < 0 ) then
		EclipseBar['Value']:SetText( '|cffE5994CStar Fire|r' )
	elseif( Power > 0 ) then
		EclipseBar['Value']:SetText( '|cff4478BCWrath|r' )
	else
		EclipseBar['Value']:SetText( '' )
	end
end

Functions['UnitFrames_DruidBars'] = function( self )
	local Frame = self:GetParent()
	local EclipseBar = Frame['EclipseBar']
	local Totems = Frame['Totems']
	local Specialization = GetSpecialization()

	if( Specialization == 1 ) then
		Totems[1]:SetWidth( Totems[1].OriginalWidth )
		Totems[2]:Show()
		Totems[3]:Show()
	elseif( Specialization == 4 ) then
		Totems[1]:SetWidth( 180 )
		Totems[2]:Hide()
		Totems[3]:Hide()
	end

	if( EclipseBar and EclipseBar:IsShown() ) and ( Totems and Totems:IsShown() ) then
		Totems:ClearAllPoints()
		Totems:SetPoint( 'BOTTOM', Frame, 'TOP', 0, 15 )
	elseif( EclipseBar and EclipseBar:IsShown() ) or ( Totems and Totems:IsShown() ) then
		Totems:ClearAllPoints()
		Totems:SetPoint( 'BOTTOM', Frame, 'TOP', 0, 5 )
	end
end