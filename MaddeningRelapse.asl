state("Maddening Relapse")
{
	double seconds	 : 0x029F5B8, 0x28, 0x8;
	double ms        : 0x029F5B8, 0x2C, 0x8;
}

init
{
	vars.timer = 0;
}

update
{	
	if (current.seconds + Math.Floor(current.ms) / 100 == 0) {
		vars.timer += old.seconds + Math.Floor(old.ms) / 100;
	}
}

start
{
	if (current.seconds + Math.Floor(current.ms) / 100 > old.seconds + Math.Floor(old.ms) / 100) {
		vars.timer = 0;
		return true;
	}
}

gameTime
{
	return TimeSpan.FromSeconds(vars.timer + current.seconds + Math.Floor(current.ms) / 100);
}

isLoading
{
	return true;
}