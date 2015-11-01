local A, L, M = select( 2, ... ):Unpack()

local _, PlugIn = ...
local oUF = PlugIn['oUF'] or oUF

local function CreateAuraIcon( auras )
	local button = CreateFrame( "Button", nil, auras )
	button:EnableMouse( false )
	button:SetAllPoints( auras )
	button:ApplyBackdrop()

	local icon = button:CreateTexture( nil, "ARTWORK" )
	icon:SetAllPoints( button )
	icon:SetTexCoord( unpack( A["TextureCoords"] ) )

	local count = button:CreateFontString( nil, "OVERLAY" )
	count:SetFont( M["Fonts"]["Asphyxia"], 10, "MONOCHROMEOUTLINE" )
	count:ClearAllPoints()
	count:SetPoint( "TOPLEFT", -2, 2 )
	count:SetJustifyH( "LEFT" )

	local remaining = button:CreateFontString( nil, "OVERLAY" )
	remaining:SetFont( M["Fonts"]["Asphyxia"], 10, "MONOCHROMEOUTLINE" )
	remaining:SetPoint( "BOTTOMRIGHT", 4, -2 )
	remaining:SetJustifyH( "RIGHT" )
	remaining:SetTextColor( 1, 1, 0 )

	button.parent = auras
	button.icon = icon
	button.count = count
	button.remaining = remaining
	button.cd = cd
	--button:Hide()

	return button
end

local function CustomFilter( icons, ... )
	local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

	icon.priority = 0

	if( aCoreCDB["CooldownAura"]["Buffs"][name] ) then
		icon.priority = aCoreCDB["CooldownAura"]["Buffs"][name].level
		icon.buff = true

		return true
	end
end

local function AuraTimer( self, elapsed )
self.elapsed = ( self.elapsed or 0 ) + elapsed

	if( self.elapsed < 0.2 ) then
		return
	end

	self.elapsed = 0

	local timeLeft = self.expires - GetTime()
	if( timeLeft <= 0 ) then
		self.remaining:SetText( nil )
	else
		self.remaining:SetText( A.FormatTime( timeLeft ) )
	end
end

local buffcolor = { r = 0.5, g = 1.0, b = 1.0 }
local function updateBuff( icon, texture, count, dtype, duration, expires, buff )
	local color = buffcolor

	icon.Backdrop:SetBackdropBorderColor( color.r, color.g, color.b )
	icon.icon:SetTexture( texture )
	icon.count:SetText( ( count > 1 and count ) )

	icon.expires = expires
	icon.duration = duration

	icon:SetScript( "OnUpdate", AuraTimer )
end

local function Update( self, event, unit )
	if( self.unit ~= unit ) then
		return
	end

	local cur
	local hide = true
	local auras = self.AsphyxiaUITankAuras
	local icon = auras.button
	local index = 1

	while true do
		local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitBuff( unit, index )

		if( not name ) then
			break
		end

		local show = CustomFilter( auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID )

		if( ( show ) and icon.buff ) then
			if( not cur ) then
				cur = icon.priority
				updateBuff( icon, texture, count, dtype, duration, expires, true )
			else
				if( icon.priority > cur ) then
					updateBuff( icon, texture, count, dtype, duration, expires, true )
				end
			end

			icon:Show()
			hide = false
		end

		index = index + 1
	end

	if( hide ) then
		icon:Hide()
	end
end

local function Enable( self )
	local auras = self.AsphyxiaUITankAuras

	if( auras ) then
		auras.button = CreateAuraIcon( auras )
		self:RegisterEvent( "UNIT_AURA", Update )

		return true
	end
end

local function Disable( self )
	local auras = self.AsphyxiaUITankAuras

	if( auras ) then
		self:UnregisterEvent( "UNIT_AURA", Update )
	end
end

oUF:AddElement( "AsphyxiaUITankAuras", Update, Enable, Disable )