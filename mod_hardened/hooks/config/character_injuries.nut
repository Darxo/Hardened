// Feat: all low-tier injuries are now easier to inflict
// This is a global balance change that goes hand-in-hand with all player characters gaining +5 Hitpoints (see character_background)
foreach (injuryTable in ::Const.Injury.All)
{
	if (injuryTable.Threshold == 0.25)
	{
		injuryTable.Threshold = 0.2;
	}
}
