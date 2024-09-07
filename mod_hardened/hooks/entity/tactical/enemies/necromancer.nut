::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/necromancer", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.m.Skills.removeByID("perk.inspiring_presence");
	}
});
