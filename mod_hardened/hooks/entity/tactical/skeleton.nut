::Hardened.HooksMod.hook("scripts/entity/tactical/skeleton", function(q) {
	q.onResurrected = @(__original) function( _info )
	{
		__original(_info);
		this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Resurrected skeletons no longer grant any experience on death
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/skeleton", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.XP *= 1.2;	// All zombies now grant 20% more experience. This balances out the fact that they no longer grant xp when ressurected
	}
});
