::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("special.double_grip");
		this.m.BaseProperties.MeleeSkill += 5;	// To offset the loss of double grip
	}
});
