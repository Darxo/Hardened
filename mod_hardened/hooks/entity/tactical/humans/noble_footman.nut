::Hardened.HooksMod.hook("scripts/entity/tactical/humans/noble_footman", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
	}
});
