::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
	q.onInit = @(__original) function()
	{
		__original.onInit();

		local b = this.m.BaseProperties;
		b.Hitpoints += 15;

		this.getSkills().removeByID("perk.nine_lives");		// This is replaced with +15 Hitpoints
	}
});
