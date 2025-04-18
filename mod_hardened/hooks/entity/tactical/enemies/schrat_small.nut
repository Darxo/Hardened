::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/schrat_small", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.steel_brow");
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}

	// Overwrite, because damage is now redirected/handled by hd_headless_effect
	q.onDamageReceived = @() function( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}
});
