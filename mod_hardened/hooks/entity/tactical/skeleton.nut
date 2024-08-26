::Hardened.HooksMod.hook("scripts/entity/tactical/skeleton", function(q) {
	q.onResurrected = @(__original) function( _info )
	{
		__original(_info);
		this.m.GrantsXPOnDeath = false;		// Resurrected skeletons no longer grant any experience on death
	}
});
