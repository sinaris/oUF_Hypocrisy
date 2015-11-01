local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Constructors = NameSpace['Constructors']

local Functions = CreateFrame( 'Frame' )
NameSpace['Functions'] = Functions

local format = string.format

local floor = math.floor
local modf = math.modf
local ceil = math.ceil

Functions['Kill'] = function( Object )
	if( Object.IsProtected ) then
		if( Object:IsProtected() ) then
			error( 'Attempted to kill a protected object: <' .. Object:GetName() .. '>' )
		end
	end

	if( Object.UnregisterAllEvents ) then
		Object:UnregisterAllEvents()
	end

	Object.Show = function() end
	Object:Hide()
end

Functions['StripTextures'] = function( Object, Kill, Text )
	for i = 1, Object:GetNumRegions() do
		local Region = select( i, Object:GetRegions() )

		if( Region:GetObjectType() == 'Texture' ) then
			if( Kill ) then
				Functions['Kill']( Region )
			else
				Region:SetTexture( nil )
			end
		end
	end
end

Functions['SetInside'] = function( Object, Anchor, xOffset, yOffset )
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	Anchor = Anchor or Object:GetParent()

	if( Object:GetPoint() ) then
		Object:ClearAllPoints()
	end

	Object:SetPoint( 'TOPLEFT', Anchor, 'TOPLEFT', xOffset, -yOffset )
	Object:SetPoint( 'BOTTOMRIGHT', Anchor, 'BOTTOMRIGHT', -xOffset, yOffset )
end

Functions['SetOutside'] = function( Object, Anchor, xOffset, yOffset )
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	Anchor = Anchor or Object:GetParent()

	if( Object:GetPoint() ) then
		Object:ClearAllPoints()
	end

	Object:SetPoint( 'TOPLEFT', Anchor, 'TOPLEFT', -xOffset, yOffset )
	Object:SetPoint( 'BOTTOMRIGHT', Anchor, 'BOTTOMRIGHT', xOffset, -yOffset )
end

Functions['ApplyBackdrop'] = function( Parent )
	if( not Parent ) then
		return
	end

	Parent:SetBackdrop( Config['Backdrop'] )
	Parent:SetBackdropColor( 0, 0, 0, 1 )
end

Functions['ColorGradient'] = function( a, b, ... )
	local Percent

	if( b == 0 ) then
		Percent = 0
	else
		Percent = a / b
	end

	if( Percent >= 1 ) then
		local R, G, B = select( select( '#', ... ) - 2, ... )

		return R, G, B
	elseif( Percent <= 0 ) then
		local R, G, B = ...

		return R, G, B
	end

	local Num = ( select( '#', ... ) / 3 )
	local Segment, RelPercent = modf( Percent * ( Num - 1 ) )
	local R1, G1, B1, R2, G2, B2 = select( ( Segment * 3 ) + 1, ... )

	return R1 + ( R2 - R1 ) * RelPercent, G1 + ( G2 - G1 ) * RelPercent, B1 + ( B2 - B1 ) * RelPercent
end

local FormatTime = function( s )
	local Day, Hour, Minute = 86400, 3600, 60

	if( s >= Day ) then
		return format( '%dd', ceil( s / Day ) )
	elseif( s >= Hour ) then
		return format( '%dh', ceil( s / Hour ) )
	elseif( s >= Minute ) then
		return format( '%dm', ceil( s / Minute ) )
	elseif( s >= Minute / 12 ) then
		return floor( s )
	end

	return format( '%.1f', s )
end

Functions['ShortenString'] = function( string, numChars, dots )
	local bytes = string:len()

	if( bytes <= numChars ) then
		return string
	else
		local len, pos = 0, 1

		while( pos <= bytes ) do
			len = len + 1
			local c = string:byte( pos )

			if( c > 0 and c <= 127 ) then
				pos = pos + 1
			elseif( c >= 192 and c <= 223 ) then
				pos = pos + 2
			elseif( c >= 224 and c <= 239 ) then
				pos = pos + 3
			elseif( c >= 240 and c <= 247 ) then
				pos = pos + 4
			end

			if( len == numChars ) then
				break
			end
		end

		if( len == numChars and pos <= bytes ) then
			return string:sub( 1, pos - 1 ) .. ( dots and '...' or '' )
		else
			return string
		end
	end
end


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
			self['Text']:SetText( Functions['ShortenString']( Name, 100, true ) )
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






















Functions['CreateAuraTimer'] = function( self, elapsed )
	if( self.TimeLeft ) then
		self.Elapsed = ( self.Elapsed or 0 ) + elapsed

		if( self.Elapsed >= 0.1 ) then
			if( not self.First ) then
				self.TimeLeft = self.TimeLeft - self.Elapsed
			else
				self.TimeLeft = self.TimeLeft - GetTime()
				self.First = false
			end

			if( self.TimeLeft > 0 ) then
				local Time = FormatTime( self.TimeLeft )
				self.Remaining:SetText( Time )

				if( self.TimeLeft <= 5 ) then
					self.Remaining:SetTextColor( 1, 0.3, 0.3 )
				else
					self.Remaining:SetTextColor( 1, 1, 1 )
				end
			else
				self.Remaining:Hide()
				self:SetScript( 'OnUpdate', nil )
			end

			self.Elapsed = 0
		end
	end
end

Functions['PostCreateAura'] = function( element, button )
	Functions['ApplyBackdrop']( button )

	button['Remaining'] = Constructors['FontString']( button, 'OVERLAY', Config['Fonts']['Font'], Config['Fonts']['Size'], 'THINOUTLINE', 'CENTER', true )
	button['Remaining']:SetPoint( 'TOPLEFT', button, 'TOPLEFT', 0, 0 )

	button['cd'].noOCC = true
	button['cd'].noCooldownCount = true
	button['cd']:SetReverse()
	button['cd']:SetFrameLevel( button:GetFrameLevel() + 1 )
	button['cd']:ClearAllPoints()
	button['cd']:SetHideCountdownNumbers( true )
	Functions['SetInside']( button['cd'], 0, 0 )

	Functions['SetInside']( button['icon'], 0, 0 )
	button['icon']:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )
	button['icon']:SetDrawLayer( 'ARTWORK' )

	button['count']:SetPoint( 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', 0, 0 )
	button['count']:SetJustifyH( 'RIGHT' )
	button['count']:SetFont( Config['Fonts']['Font'], Config['Fonts']['Size'], 'THINOUTLINE' )
	button['count']:SetTextColor( 0.8, 0.8, 0.7 )

	button['Animation'] = button:CreateAnimationGroup()
	button['Animation']:SetLooping( 'BOUNCE' )
	button['Animation'].FadeOut = button['Animation']:CreateAnimation( 'Alpha' )
	button['Animation'].FadeOut:SetChange( -0.9 )
	button['Animation'].FadeOut:SetDuration( 0.6 )
	button['Animation'].FadeOut:SetSmoothing( 'IN_OUT' )
end

Functions['PostUpdateAura'] = function( icons, unit, button, index, offset, filter, isDebuff, duration, timeLeft )
	local _, _, _, _, DType, Duration, ExpirationTime, _, IsStealable = UnitAura( unit, index, button.filter )

	if( button ) then
		if( button['filter'] == 'HARMFUL' ) then
			if( not UnitIsFriend( 'player', unit ) and button['owner'] ~= 'player' and button['owner'] ~= 'vehicle' ) then
				button['icon']:SetDesaturated( true )
				button:SetBackdropColor( 0, 0, 0, 1 )
			else
				local Color = DebuffTypeColor[DType] or DebuffTypeColor['none']
				button['icon']:SetDesaturated( false )
				button:SetBackdropColor( Color['r'] * 0.8, Color['g'] * 0.8, Color['b'] * 0.8, 0.8 )
			end
		else
			if( ( IsStealable or DType == 'Magic' ) and not UnitIsFriend( 'player', unit ) and not button.Animation.Playing ) then
				button.Animation:Play()
				button.Animation.Playing = true
			else
				button.Animation:Stop()
				button.Animation.Playing = false
			end
		end

		if( Duration and Duration > 0 ) then
			button.Remaining:Show()
		else
			button.Remaining:Hide()
		end

		button['Duration'] = Duration
		button['TimeLeft'] = ExpirationTime
		button['First'] = true
		button:SetScript( 'OnUpdate', Functions['CreateAuraTimer'] )
	end
end
