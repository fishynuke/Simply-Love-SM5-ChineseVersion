return Def.ActorFrame{

	LoadActor( THEME:GetPathG("", "_header.lua") ),

	Def.BitmapText{
		Name="GameModeText",
		Font="_jfonts/_jfonts 16px",
		InitCommand=function(self)
			self:diffusealpha(0):zoom( WideScale(0.9,1.0)):xy(_screen.w-70, 15):halign(1)
			if not PREFSMAN:GetPreference("MenuTimer") then
				self:x(_screen.w-10)
			end
		end,
		OnCommand=function(self)
			self:sleep(0.1):decelerate(0.33):diffusealpha(1)
				:settext(THEME:GetString("ScreenSelectPlayMode", SL.Global.GameMode))
		end,
	}
}