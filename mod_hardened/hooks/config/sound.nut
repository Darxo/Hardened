// We raise the minimum duration between idle sounds, so that you don't get spammed as much with them during busy fights
::Const.Sound.IdleSoundMinDelay = 10;	// Vanilla: 5

// We lower the base idle sound delay, because 60 seconds is way too much during small scale fights, being barely able to hear those nice idle sounds
::Const.Sound.IdleSoundBaseDelay = 40;	// Vanilla: 60

// We lower the reduction in the delay per enemy, so that you need a larger enemy force to reach the minimum delay
::Const.Sound.IdleSoundReducedDelay = 2;	// Vanilla: 5

function lowerAnnoyingKid( _soundArray )
{
	foreach (soundTable in ::Const.SoundAmbience.GeneralSettlement)
	{
		if (soundTable.File != "ambience/settlement/settlement_people_08.wav") continue;
		soundTable.Volume *= 0.85;
		break;
	}
}

lowerAnnoyingKid(::Const.SoundAmbience.GeneralSettlement);
lowerAnnoyingKid(::Const.SoundAmbience.LargeSettlement);
lowerAnnoyingKid(::Const.SoundAmbience.VeryLargeSettlement);

// New Entries
{
	::Const.Sound.HD_UniqueLocationDiscoveredOnWorldmap <- [
		"sounds/world/hd_fanfare_announcement_01.wav",
		"sounds/world/hd_fanfare_announcement_02.wav",
	];
}
