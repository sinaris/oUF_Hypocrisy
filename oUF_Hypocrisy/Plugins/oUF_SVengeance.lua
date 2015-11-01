------------------
--
-- oUF_SVengeance by Weakling @ Crushridge EU
--
--	oUF Element: .Vengeance
--
--	Options:
--	Vengeange:SetStatusBarTexture
--		Set a Statusbar texture, default will be used if none specified
--
-- 	Vengeance.Value
--		Fontstring, default will be created if none specified. Requires Usetext to not be false.
--
--	Vengeance.Usetext = [true | "perc" | false]
--		true = shows the amount of vengeance on the bar as ex: 850 / 16.20k if <1000 otherwise will show ex: 1.3k / 16.20k
--		"perc" = shows the value as a % of the max venge, implies true. Ex: 8%
--		"buff" = shows the amount of bonus AP from vengeance, implies true. Ex: 1300
--		"ap" = shows the current amount of ap you have (the same number displayed in the character info pane), implies true.	Ex: 6800
--		false = doesn't show any text
--
--	Vengeance.Orientation = ["VERTICAL" | "HORIZONTAL"]
--		by default is HORIZONTAL, meaning left to right.
--		Set to "VERTICAL" to have a bar that fills from bottom to top
--
--	Vengeance.InverseOrientation = [true | false]
--		Inverts the fill method: 
--			left to right becomes right to left
--			bottom to top becomes top to bottom
--
--	Vengeance.TextOverride = function(element, curvengeance)
--		Can be used to override the default text, requires Vengeance.Usetext to not be false
--		curvengeance is the venge you have, ex: 1200
--		element.max can be used to retrieve the max venge you can obtain
--		Use element.Value:SetText() to set the text.
--
--	Vengeance.PostUpdate = function(element,curvengeance, vengepercent, attackpower)
--		element.max can be used to retrieve the max venge you can obtain
--		Can be used for further customization, if no function is provided the bar will be colored red if at low venge value, green at high vengeance value
--
------------------

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF_SVengeance was unable to locate oUF install')

local _, value1--, stat, posBuff, basehealth
local apbase, apbuff, apdebuff = 0,0,0
local floor = math.floor
local spell = (GetSpellInfo(84839))

-- local Cgvb = {
	-- 1, 0, 0,	-- Red
	-- 1, 1, 0,	-- Yellow
	-- 0, 1, 0,	-- Green
	-- }

local Cgvb = {
	255/255, 0/255, 0/255,	-- Red
	255/255, 255/255, 0/255,	-- Yellow
	0/255, 255/255, 0/255,	-- Green
	}
	
local function Update(self,event,unit)

	if unit ~= "player" then return end
	
	local Venge = self.Vengeance

	if Venge.isTank == false then
		Venge:Hide()
		return
	end
	
	value1 = nil
	_, _, _, _, _, _, _, _, _, _, _, _, _, _, value1 = UnitBuff(unit, spell, nil)

	if value1 == nil then
		Venge:Hide()
		return 
	else
		if value1 > Venge.max then
			Venge.max = value1
			oUF_SVengeanceBarMax[Venge.bossname] = value1
		end
		Venge:Show()
	end

	
	Venge:SetMinMaxValues(0, Venge.max)
	Venge:SetValue(value1)
	
	if Venge.Usetext then
		
		if Venge.TextOverride then
			Venge:TextOverride(value1)
		else
		
			if Venge.Usetext == "perc" then
		
				Venge.Value:SetFormattedText('%d',  value1 * 100 / Venge.max)
			
			elseif Venge.Usetext == "ap" then
				
				apbase, apbuff, apdebuff = UnitAttackPower(unit)
				Venge.Value:SetFormattedText('%d',  apbase + apbuff - apdebuff)
			
			elseif Venge.Usetext == "buff" then
				
				Venge.Value:SetFormattedText('%d',  value1)
				
			else
		
				if value1 < 1e3 then
					Venge.Value:SetFormattedText("%d / %.2fk", value1, floor(Venge.max/1e3))
				else
					Venge.Value:SetFormattedText("%.2fk / %.2fk", floor(value1/1e3), floor(Venge.max/1e3))
				end
				
			end
		end
	end
	
	if (Venge.PostUpdate) then
		return Venge:PostUpdate(value1, (value1 * 100 / Venge.max), (apbase + apbuff - apdebuff))
	else
		Venge:SetStatusBarColor(oUF.ColorGradient(value1, Venge.max, unpack(Cgvb)))
	end
	return
end

local function Path(self, ...)
	return (self.Vengeance.Override or Update) (self, ...)
end

local function isTank(self, event)

	local masteryIndex = GetSpecialization()
	local class = select(2, UnitClass("player"))	
	local Venge = self.Vengeance
	
	if masteryIndex then
		if class == "DRUID" and masteryIndex == 3 then
			Venge.isTank = true
		elseif class == "DEATHKNIGHT" and masteryIndex == 1 then
			Venge.isTank = true
		elseif class == "PALADIN" and masteryIndex == 2 then
			Venge.isTank = true
		elseif class == "WARRIOR" and masteryIndex == 3 then
			Venge.isTank = true
		elseif class == "MONK" and masteryIndex == 1 then
			Venge.isTank = true
		else
			Venge.isTank = false
			Venge:Hide()
		end
	else
		Venge.isTank = false
		Venge:Hide()
	end
	return
end

local function setMax(self)

	self.Vengeance.bossname = GetUnitName("boss1")
	if self.Vengeance.bossname == nil then
		self.Vengeance.bossname = "noOne"
	end
	
	local max = oUF_SVengeanceBarMax[bossname]
	if max ~= nil then
		self.Vengeance.max = max
	else
		self.Vengeance.max = 1
	end
	
end


local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local Vengeance = self.Vengeance
	if(Vengeance) then
		
		if unit ~= "player" then return end
		
		Vengeance.__owner = self
		
		isTank(self, nil)
		--[[
		if oUF_SVengeanceBarMax ~= nil then
			Vengeance.max = oUF_SVengeanceBarMax/2
		else
			Vengeance.max = 1
		end
		]]--
		Vengeance.max = 1
		if not oUF_SVengeanceBarMax then
			oUF_SVengeanceBarMax = {}
		end
		Vengeance.bossname = "noOne"
		
		Vengeance:SetMinMaxValues(0, Vengeance.max)
		
		if(not Vengeance:GetStatusBarTexture()) then
			Vengeance:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end
		
		if Vengeance.Orientation then
			Vengeance:SetOrientation(Vengeance.Orientation)
		end
		
		if Vengeance.InverseOrientation then
			Vengeance:SetReverseFill(true)
		end
		
		if Vengeance.Usetext then
			if not Vengeance.Value then
			
				Vengeance.Value = Vengeance:CreateFontString(nil, "OVERLAY")
				Vengeance.Value:SetPoint("CENTER", Vengeance, "CENTER", 0, 0)
				Vengeance.Value:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
				Vengeance.Value:SetTextColor(1, 1, 1, 1)

			end
		end
		Vengeance.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_ATTACK_POWER', Path)
		self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', isTank)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', isTank)
		self:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT', setMax)
		return true
	end
end

local function Disable(self)
	if(self.Vengeance) then
		self:UnregisterEvent('UNIT_ATTACK_POWER', Path)
		self:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED', isTank)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', isTank)
		self:UnregisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT', setMax)
	end
end

oUF:AddElement('Vengeance', Path, Enable, Disable)
