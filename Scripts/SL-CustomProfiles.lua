local path =  "UserPrefs/" .. THEME:GetThemeDisplayName() .."/";

-- these are the custom player options that Simply Love uses via getenv and setenv
local prefs = { "ScreenFilter", "SpeedModType", "SpeedMod", "JudgmentGraphic", "Mini" };


-- reset a particular player's custom preferences to nil
function ResetPlayerCustomPrefs(pn)
	for k,v in pairs(prefs) do
		setenv(v..ToEnumShortString(pn), nil )
	end
end


-- Hook called during profile load
function LoadProfileCustom(profile, dir)

	local PrefPath =  dir .. path;
	local Players, pname;
		
	-- we've been passed a profile object as the variable "profile"
	-- see if it matches against anything returned by PROFILEMAN:GetProfile(pn)
	local Players = GAMESTATE:GetHumanPlayers();
	
	if Players then
		for pn in ivalues(Players) do
			if profile == PROFILEMAN:GetProfile(pn) then
				pname = ToEnumShortString(pn);
			end
		end
	
	end
	
	
	-- ...and then, if a player profile exists, set the env table values
	if pname then
		
		ResetPlayerCustomPrefs(pname);
		
		local f = RageFileUtil.CreateRageFile()
		local setting

		for k,v in pairs(prefs) do
			
			local fullFilename = PrefPath..v..".cfg"
			
			if f:Open(fullFilename,1) then
				
				setting = tostring( f:Read() )
				setenv(v..pname, setting )
			else
				local fError = f:GetError()
				Trace( "[FileUtils] Error reading ".. fullFilename ..": ".. fError )
				f:ClearError()
			end
		end
		
		-- don't destroy the RageFile until we've tried to load all custom options
		-- and set them to the env table to make them accessible from anywhere in SM
		f:destroy()
	end
	
	return true
end

-- Hook called during profile save
function SaveProfileCustom(profile, dir)

	local PrefPath =  dir .. path;
	local pname;
	

	local Players = GAMESTATE:GetHumanPlayers();
	for pn in ivalues(Players) do
		if profile == PROFILEMAN:GetProfile(pn) then
			pname = ToEnumShortString(pn);
		end
	end
	
	if pname then
		-- a generic ragefile (?)
		local f = RageFileUtil.CreateRageFile();

		
		-- then loop through the prefs, saving one .cfg file per available setting
		-- if a particular value is nil, nothing gets written
		for k,v in pairs(prefs) do
		
			local fullFilename = PrefPath..v..".cfg"

			if f:Open(fullFilename, 2) then
				
				local setting = getenv( v..pname )
				if setting then
					f:Write( tostring( setting ) )
				end
			else
				local fError = f:GetError()
				Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
				f:ClearError()
			end
		end
		
		-- again, don't destroy the file until after we're done looping
		-- through all possible custom options
		f:destroy()
	end
	
	return true	
end