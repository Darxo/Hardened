::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/unhold_bog", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/actives/hd_beast_split_shield"));
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		local racialSkill = this.getSkills().getSkillByID("racial.unhold");
		if (racialSkill != null)
		{
			racialSkill.m.HD_RecoveredHitpointPct = 0.2;	// Reforged: 0.15;
		}
	}
});
