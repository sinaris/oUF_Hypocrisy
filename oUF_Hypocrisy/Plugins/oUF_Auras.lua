local A, L, M = select( 2, ... ):Unpack()

local _, PlugIn = ...
local oUF = PlugIn['oUF'] or oUF

local function multicheck( check, ... )
	for i = 1, select( "#", ... ) do
		if( check == select( i, ... ) ) then
			return true
		end
	end

	return false
end

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
	count:SetPoint( "TOPLEFT", -4, 4 )
	count:SetJustifyH( "LEFT" )
	count:SetTextColor( 1, 0.5, 0.8 )

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

local dispelClass = {
	PRIEST = { Disease = true, Magic = true, },
	SHAMAN = { Curse = true, Magic = true, },
	PALADIN = { Poison = true, Disease = true, Magic = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, Magic = true, },
	MONK = { Disease = true, Poison = true, Magic = true, },
}

local checkTalents = CreateFrame( "Frame" )
checkTalents:RegisterEvent( "PLAYER_ENTERING_WORLD" )
checkTalents:SetScript( "OnEvent", function( self, event )
	if( multicheck( A["MyClass"], "SHAMAN", "PALADIN", "DRUID", "PRIEST", "MONK" ) ) then
		if( A["MyClass"] == "SHAMAN" ) then
			local tree = GetSpecialization()
			dispelClass[A["MyClass"]].Magic = tree == 1 and true
		elseif( A["MyClass"] == "PALADIN" ) then
			local tree = GetSpecialization()
			dispelClass[A["MyClass"]].Magic = tree == 1 and true
		elseif( A["MyClass"] == "DRUID" ) then
			local tree = GetSpecialization()
			dispelClass[A["MyClass"]].Magic = tree == 4 and true
		elseif( A["MyClass"] == "PRIEST" ) then
			local tree = GetSpecialization()
			dispelClass[A["MyClass"]].Magic = ( tree == 1 or tree == 2 ) and true
		elseif( A["MyClass"] == "MONK" ) then
			local tree = GetSpecialization()
			dispelClass[A["MyClass"]].Magic = tree == 2 and true
		end
	end

	if( event == "PLAYER_ENTERING_WORLD" ) then
		self:UnregisterEvent( "PLAYER_ENTERING_WORLD" )
		self:RegisterEvent( "PLAYER_TALENT_UPDATE" )
	end
end )

local dispellist = dispelClass[A["MyClass"]] or {}
local dispelPriority = {
	Magic = 4,
	Curse = 3,
	Poison = 2,
	Disease = 1,
}

local function CustomFilter( icons, ... )
	local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

	icon.asc = false
	icon.priority = 0

	if( aCoreCDB["CooldownAura"]["Debuffs"][name] ) then
		icon.priority = aCoreCDB["CooldownAura"]["Debuffs"][name].level
		return true
	elseif( IsInInstance() ) then
		local ins = GetInstanceInfo()

		if( aCoreCDB["RaidDebuff"][ins] ) then
			for boss, debufflist in pairs( aCoreCDB["RaidDebuff"][ins] ) do
				if( debufflist[name] ) then
					icon.priority = debufflist[name].level
					return true
				end
			end
		end
	elseif( dispellist[dtype] ) then
		icon.priority = dispelPriority[dtype]
		return true
	end
end

local function AuraTimerAsc( self, elapsed )
	self.elapsed = ( self.elapsed or 0 ) + elapsed

	if( self.elapsed < 0.2 ) then
		return
	end

	self.elapsed = 0

	local timeLeft = self.expires - GetTime()
	if( timeLeft <= 0 ) then
		self.remaining:SetText( nil )
	else
		local duration = self.duration - timeLeft
		self.remaining:SetText( A.FormatTime( duration ) )
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

local function updateDebuff( backdrop, icon, texture, count, dtype, duration, expires )
	local color = DebuffTypeColor[dtype] or DebuffTypeColor.none

	icon.Backdrop:SetBackdropColor( M["Colors"]['General']["Backdrop"]['r'], M["Colors"]['General']["Backdrop"]['g'], M["Colors"]['General']["Backdrop"]['b'],M["Colors"]['General']["Backdrop"]['a'] )
	if( dispellist[dtype] ) then
		icon.Backdrop:SetBackdropBorderColor( color.r / 2, color.g / 2, color.b / 2 )
	else
		icon.Backdrop:SetBackdropBorderColor( color.r, color.g, color.b )
	end

	icon.icon:SetTexture( texture )
	icon.count:SetText( ( count > 1 and count ) )

	icon.expires = expires
	icon.duration = duration

	if( icon.asc ) then
		icon:SetScript( "OnUpdate", AuraTimerAsc )
	else
		icon:SetScript( "OnUpdate", AuraTimer )
	end
end

local function Update( self, event, unit )
	if( self.unit ~= unit ) then
		return
	end

	local cur
	local hide = true
	--local hide = false
	local auras = self.AsphyxiaUIAuras
	local icon = auras.button
	local backdrop = self.Backdrop
	local index = 1

	while true do
		local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitDebuff( unit, index )

		if( not name ) then
			break
		end

		local show = CustomFilter( auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID )

		if( show ) then
			if( not cur ) then
				cur = icon.priority
				updateDebuff( backdrop, icon, texture, count, dtype, duration, expires )
			else
				if( icon.priority > cur ) then
					updateDebuff( backdrop, icon, texture, count, dtype, duration, expires )
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
	local auras = self.AsphyxiaUIAuras

	if( auras ) then
		auras.button = CreateAuraIcon( auras )
		self:RegisterEvent( "UNIT_AURA", Update )

		return true
	end
end

local function Disable( self )
	local auras = self.AsphyxiaUIAuras

	if( auras ) then
		self:UnregisterEvent( "UNIT_AURA", Update )
	end
end

oUF:AddElement( "AsphyxiaUIAuras", Update, Enable, Disable )
