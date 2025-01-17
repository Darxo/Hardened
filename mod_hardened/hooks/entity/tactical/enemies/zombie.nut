::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("special.double_grip");
		this.m.BaseProperties.MeleeSkill += 5;	// To offset the loss of double grip
	}

	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.overwhelm");	// Their Worn Down perk was buffed a bit and overwhelm feels too oppressive this early on
	}

	q.onResurrected = @(__original) function( _info )
	{
		__original(_info);

		this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Resurrected skeletons no longer grant any experience on death
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/enemies/zombie", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.XP *= 1.2;	// All zombies now grant 20% more experience. This balances out the fact that they no longer grant xp when ressurected
	}
});
