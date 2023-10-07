::mods_hookExactClass("entity/tactical/actor", function(o) {

	// Prevent Armor Penetration of 100%+ from ever trivialising armor
	local oldOnDamageReceived = o.onDamageReceived;
	o.onDamageReceived = function( _attacker, _skill, _hitInfo )
	{
		if (_skill != null)
		{
			if (_skill.m.IsIgnoringArmorReduction)
			{
				_hitInfo.DamageDirect = 1.0;
			}
			else
			{
				_hitInfo.DamageDirect = ::Math.minf(0.9999, _hitInfo.DamageDirect);
			}
		}

		oldOnDamageReceived(_attacker, _skill, _hitInfo);
	}

	local oldWait = o.wait;
	o.wait = function()
	{
		oldWait();
		this.getSkills().add(::new("scripts/skills/effects/hd_wait_effect"));
	}
});
