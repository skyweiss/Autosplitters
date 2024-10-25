state("Maddening Euphoria")
{
	double timer     : 0xC07C38, 0x50, 0x490, 0x1C0;
	double theme     : 0xC07C38, 0x50, 0x690, 0x390;
	double challenge : 0xC07C38, 0x50, 0xA30, 0x130;
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