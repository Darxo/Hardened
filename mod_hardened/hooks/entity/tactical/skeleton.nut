::Hardened.HooksMod.hook("scripts/entity/tactical/skeleton", function(q) {
	q.onResurrected = @(__original) function( _info )
	{
		__original(_info);
		this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Resurrected skeletons no longer grant any experience on death
	}
});
