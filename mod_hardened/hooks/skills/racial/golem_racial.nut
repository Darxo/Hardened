::Hardened.HooksMod.hook("scripts/skills/racial/golem_racial", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.HitpointsMult *= 0.5;

		local size = this.getContainer().getActor().getSize();
		if (size == 2)
		{
			_properties.DamageRegularMin -= 10;
			_properties.DamageRegularMax -= 10;
			// Medium Golems now deal -10 damage but gain Marksmanship perk in return
		}
		else if (size == 3)
		{
			// Large Golems now deal -10 damage but gain Marksmanship perk in return
			_properties.DamageRegularMin -= 10;
			_properties.DamageRegularMax -= 10;
		}
	}
});
