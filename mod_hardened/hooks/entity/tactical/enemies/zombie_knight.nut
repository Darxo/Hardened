::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
	// Overwrite, because damage is now redirected/handled by hd_headless_effect
	q.onDamageReceived = @() function( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	q.onResurrected = @(__original) function( _info)
	{
		__original(_info);
		if (!_info.IsHeadAttached)
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		}
	}

	q.makeMiniboss = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.nine_lives");
	}
});
