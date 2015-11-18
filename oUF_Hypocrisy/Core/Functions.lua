local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']

local Functions = CreateFrame( 'Frame' )
NameSpace['Functions'] = Functions

local ceil = math.ceil
local floor = math.floor
local format = string.format

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

Functions['FormatTime'] = function( s )
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

Functions['ApplyBackdrop'] = function( self )
	if( not self ) then
		return
	end

	self:SetBackdrop( Config['Backdrop'] )
	self:SetBackdropColor( 0, 0, 0, 1 )
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

--------------------------------------------------
-- UnitFrames: Health
--------------------------------------------------
Functions['PostUpdateHealth'] = function( self, Unit, Min, Max )
	local R, G, B

	local Duration = floor( Min / Max * 100 )

	if( Max ~= 0 ) then
		R, G, B = oUF.ColorGradient( Min, Max, 1, 0, 0, 1, 1, 0, 1, 1, 1 )
	end

	if( not UnitIsConnected( Unit ) ) then
		self['Value']:SetText( '' )
		self['Percent']:SetText( 'offline' )
		self['Percent']:SetTextColor( 0.8, 0.8, 0.8 )
	elseif( UnitIsGhost( Unit ) ) then
		self['Value']:SetText( '' )
		self['Percent']:SetText( 'ghost' )
		self['Percent']:SetTextColor( 0.8, 0.8, 0.8 )
	elseif( UnitIsDead( Unit ) ) then
		self['Value']:SetText( '' )
		self['Percent']:SetText( 'dead' )
		self['Percent']:SetTextColor( 0.8, 0.8, 0.8 )
	elseif( Unit == "player" ) then
		self['Value']:SetText( Min .. '/' .. Max )
		self['Percent']:SetText( Duration .. '%' )
		self['Percent']:SetTextColor( R, G, B )
	elseif( Unit == "target" or Unit == "focus" or self:GetParent():GetName():match"oUF_Party" ) then
		self['Value']:SetText( Min .. "/" .. Max )
		self['Percent']:SetText( Duration .. "%" )
		self['Percent']:SetTextColor( R, G, B )
	else
		self['Value']:SetText( '' )
		self['Percent']:SetText( Duration .. "%" )
	end
end

--------------------------------------------------
-- UnitFrames: Power
--------------------------------------------------
Functions['PreUpdatePower'] = function( self, Unit )
	local PowerType = select( 2, UnitPowerType( Unit ) )
	local Colors = Config['Colors']['Power'][PowerType]

	if( Colors ) then
		self:SetStatusBarColor( Colors[1], Colors[2], Colors[3] )
	end
end

Functions['PostUpdatePower'] = function( self, Unit, Min, Max )
	if( not UnitIsPlayer( Unit ) ) then
		self['Value']:SetText( '' )
		self['Percent']:SetText( '' )
	else
		local PowerType = select( 2, UnitPowerType( Unit ) )
		local Colors = Config['Colors']['Power'][PowerType]

		self['Value']:SetText( Min .. '/' .. Max )
		if( PowerType == "MANA" ) then
			self['Percent']:SetText( floor( Min / Max * 100 ) .. "%" )
		else
			self['Percent']:SetText( Min )
		end
	end
end

--------------------------------------------------
-- Auras
--------------------------------------------------
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
				local Time = Functions['FormatTime']( self.TimeLeft )
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

Functions['PostCreateAura'] = function( element, button, remaining )
	Functions['ApplyBackdrop']( button )

	button['Remaining'] = Config['FontString']( button, 'OVERLAY', Config['Fonts']['Font'], element:GetHeight() / 2, 'THINOUTLINE', 'CENTER', true )
	button['Remaining']:SetPoint( 'CENTER', button, 'CENTER', 0, 0 )

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

	button['count']:SetPoint( 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', 4, 0 )
	button['count']:SetJustifyH( 'RIGHT' )
	button['count']:SetFont( Config['Fonts']['Font'], Config['Fonts']['Size'], 'THINOUTLINE' )
	button['count']:SetTextColor( 0.8, 0.8, 0.7 )

	button['OverlayFrame'] = CreateFrame( 'Frame', nil, button, nil )
	button['OverlayFrame']:SetFrameLevel( button['cd']:GetFrameLevel() + 1 )
	button['overlay']:SetParent( button['OverlayFrame'] )
	button['count']:SetParent( button['OverlayFrame'] )
	button['Remaining']:SetParent( button['OverlayFrame'] )

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