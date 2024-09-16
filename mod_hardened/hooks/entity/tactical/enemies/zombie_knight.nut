::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/schrat_small", function(q) {

	q.onResurrected = @(__original) function( _info)
	{
		__original(_info);
		if (!_info.IsHeadAttached)
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		}
	}
});
