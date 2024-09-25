::Hardened.HooksMod.hook("scripts/skills/backgrounds/swordmaster_background", function(q) {
	q.onAdded = @(__original) function()
	{
		local isNew = this.m.IsNew;	// This member is set to false during __original;

		__original();

		if (isNew)
		{
			this.getContainer().removeByID("perk.mastery.sword");	// Swordmaster no longer have this perk unlocked by default
		}
	}
});
