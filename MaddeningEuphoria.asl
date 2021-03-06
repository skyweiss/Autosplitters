state("Maddening Euphoria")
{
	double timer     : 0x040794C, 0x44, 0x10, 0x94, 0x0;
	double theme     : 0x040794C, 0x44, 0x10, 0x490, 0x370;
	double challenge : 0x040794C, 0x44, 0x10, 0x49C, 0x180;
}

init
{
	vars.timer = 0;
	vars.theme_change = 0;
	vars.challenge_change = 0;
}

update
{	
	if (current.timer == 0)
	{
		vars.timer += Math.Floor(old.timer);
	}
	
	if (settings["Theme"] && current.theme != old.theme)
	{
		vars.theme_change = 1;
	}
	
	if (settings["Challenge"] && current.challenge != old.challenge)
	{
		vars.challenge_change = 1;
	}
}

startup
{
	settings.Add("Challenge", true, "Split on new challenge");
	settings.Add("Theme", false, "Split on new theme");
}

start
{
	if (current.timer > old.timer)
	{
		vars.timer = 0;
		vars.theme_change = 0;
		vars.challenge_change = 0;
		return true;
	}
}

split
{
	if (current.timer < old.timer && vars.timer > 0)
	{
		if (vars.theme_change == 1)
		{
			vars.theme_change = 0;
			return true;
		}
		if (vars.challenge_change == 1)
		{
			vars.challenge_change = 0;
			return true;
		}
	}
}

gameTime
{
	return TimeSpan.FromSeconds((vars.timer / 100) + (Math.Floor(current.timer) / 100));
}

isLoading
{
	return true;
}
