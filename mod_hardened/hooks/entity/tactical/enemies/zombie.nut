::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
	q.onResurrected = @(__original) function( _info )
	{
		__original(_info);
		this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Resurrected skeletons no longer grant any experience on death

		if (!_info.IsHeadAttached)
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		}
	}
});
