::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_raider", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
	}
});
