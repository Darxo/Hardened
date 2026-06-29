::Hardened.HooksMod.hook("scripts/ambitions/ambitions/ranged_mastery_ambition", function(q) {
	// We overwrite the vanilla function in order to check for skills, rather than the IsSpecialized flag, because that one is no longer supported in Hardened
	q.getBrosWithMastery = @() function()
	{
		local count = 0;
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (bro.getSkills().hasSkill("perk.mastery.bow") || bro.getSkills().hasSkill("perk.mastery.crossbow")) count++;
		}
		return count;
	}
});
