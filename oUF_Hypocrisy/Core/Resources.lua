local AddOn, NameSpace = ...
local oUF = NameSpace['oUF'] or oUF

local Config = NameSpace['Config']
local Constructors = NameSpace['Constructors']
local Functions = NameSpace['Functions']

local Resources = CreateFrame( 'Frame' )
NameSpace['Resources'] = Resources

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
			ComboPointsBar[i]:SetSize( ( 180 / 5 ) - 1, 5 )
		else
			ComboPointsBar[i]:SetSize( 180 / 5, 5 )
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
