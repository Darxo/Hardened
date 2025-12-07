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
