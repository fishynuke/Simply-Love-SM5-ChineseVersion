local gc = Var("GameCommand")
local index = gc:GetIndex()
local text = gc:GetName()

-- text description of each mode ("Casual", "ITG", "FA+")
return LoadFont("_jfonts/_jfonts 16px")..{
	Name="ModeName"..index,
	Text=ScreenString(text),

	InitCommand=function(self) self:halign(1):maxwidth(256) end,
	GainFocusCommand=function(self) self:stoptweening():linear(0.1):zoom(1.2):diffuse(PlayerColor(PLAYER_1)) end,
	LoseFocusCommand=function(self) self:stoptweening():linear(0.1):zoom(0.8):diffuse(color("#888888")) end,
	OffCommand=function(self) self:linear(0.2):diffusealpha(0) end
}