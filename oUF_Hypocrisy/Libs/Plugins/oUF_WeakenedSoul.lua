local _, ns = ...
local oUF = ns.oUF or oUF

local GetDebuffInfo = function( unit )
	if( not UnitCanAssist( 'player', unit ) ) then
		return
	end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitAura( unit, i, 'HARMFUL' )

		if( spellId == 6788 ) then
			return true
		end

		i = i + 1
	until not spellId
end

local UpdateBar = function( self, event, unit )
	local duration = self.dur
	local timeLeft = self.exp-GetTime()
	local value

	if( timeLeft == 0 or duration == 0 ) then
		value = 0
	else
		value = ( timeLeft * 100 ) / duration
	end

	self:SetValue( value )
end

local Update = function( self, event, unit )
	if( self.unit ~= unit ) then
		return
	end

	local ws = self.WeakenedSoul

	if( ws.PreUpdate ) then
		ws:PreUpdate( unit )
	end

	if( GetDebuffInfo( unit ) ) then
		local _, _, _, _, _, duration, expirationTime = UnitDebuff( unit, GetSpellInfo( 6788 ) )

		ws.dur = duration
		ws.exp = expirationTime
		ws:Show()
		ws:SetScript( "OnUpdate", UpdateBar )
	else
		ws:Hide()
		ws:SetScript( "OnUpdate", nil )
	end

	if( ws.PostUpdate ) then
		ws:PostUpdate( unit )
	end
end

local Enable = function( self )
	local ws = self.WeakenedSoul

	if( ws ) then
		self:RegisterEvent( "UNIT_AURA", Update )
		ws:SetMinMaxValues( 0, 100 )

		ws.unit = self.unit

		return true
	end
end

local Disable = function( self )
	if( self.WeakenedSoul ) then
		self:UnregisterEvent( 'UNIT_AURA', Update )
	end
end

oUF:AddElement( 'WeakenedSoul', Update, Enable, Disable )
