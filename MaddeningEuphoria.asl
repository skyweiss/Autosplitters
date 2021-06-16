state("Maddening Euphoria")
{
	double timer     : 0x040794C, 0x44, 0x10, 0x94, 0x0;
	double theme     : 0x040794C, 0x44, 0x10, 0x490, 0x370;
	double challenge : 0x040794C, 0x44, 0x10, 0x49C, 0x180;
	double goo       : 0x040794C, 0x44, 0x10, 0x5E0, 0x0;
}

init
{
	vars.timer = 0;
	vars.theme_change = 0;
	vars.challenge_change = 0;
	
	vars.estTime = 0;
	vars.thisGoo = 0;
	vars.checkEnd = 0;
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
	if (settings["Goo"])
	{
		if (current.timer == old.timer && current.goo > old.goo)
		{
			vars.thisGoo += current.goo - old.goo;
			vars.estTime += 100.0 / refreshRate;
		}
	}
	
	if (settings["Goo"])
	{
		if (current.goo == old.goo)
		{
			vars.checkEnd ++;
		}
		else
		{
			vars.checkEnd = 0;
		}
		
		// calculate goo time if goo has stayed the same for a while, or the timer unpaused
		if (vars.checkEnd > 5 || current.timer != old.timer)
		{
			vars.checkEnd = 0;
			if (vars.thisGoo > 0)
			{
				if (Math.Abs((100 * vars.thisGoo / 60) - vars.estTime) < Math.Abs((50 * vars.thisGoo / 60) - vars.estTime))
				{
					vars.timer += 100 * vars.thisGoo / 60;
				}
				else
				{
					vars.timer += 50 * vars.thisGoo / 60;
				}
				vars.thisGoo = 0;
				vars.estTime = 0;
			}
		}
	}
}

startup
{
	settings.Add("Goo", true, "Time goo pausing");
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
