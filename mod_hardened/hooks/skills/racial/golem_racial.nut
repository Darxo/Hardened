::Hardened.HooksMod.hook("scripts/skills/racial/golem_racial", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Todo: reactive this feature, when ArmorMult with Natural Armor is fixed
		// _properties.HitpointsMult *= 0.5;
		// _properties.ArmorMult[0] *= 1.5;
		// _properties.ArmorMult[1] *= 1.5;	// Not really needed because ifrits have no head
	}
});
