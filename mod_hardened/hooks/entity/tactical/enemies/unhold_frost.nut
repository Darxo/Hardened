::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/unhold_frost", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		// We do this for safety reasons, to overwrite the 10% recovery adjusted into regular unholds
		local racialSkill = this.getSkills().getSkillByID("racial.unhold");
		if (racialSkill != null)
		{
			racialSkill.m.HD_RecoveredHitpointPct = 0.15;	// Reforged: 0.15;
		}
	}
});
