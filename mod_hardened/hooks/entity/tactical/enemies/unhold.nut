::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/unhold", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		local racialSkill = this.getSkills().getSkillByID("racial.unhold");
		if (racialSkill != null)
		{
			racialSkill.m.HD_RecoveredHitpointPct = 0.1;	// Reforged: 0.15;
		}
	}
});

// Since All types of unhold inherit from the base unhold script, the following will affect all unhold variants
::Hardened.HooksMod.hookTree("scripts/entity/tactical/enemies/unhold", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = ::Const.Strings.EntityName[this.m.Type];	// Unhold Names during combat now reflect their names on the world map instead of all being called "Unhold"
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_rattle");		// Remove Full Force
		this.getSkills().removeByID("perk.rf_dismantle");	// Remove Dismantle
	}
});

