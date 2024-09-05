::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_leader", function(q) {
	q.onSetupEntity = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
	}
});
