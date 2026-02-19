::Hardened.HooksMod.hook("scripts/skills/actives/ghastly_touch", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// We slightly reduce the maximum possible damage but increase their melee skill so that their damage is less spiky
		_properties.DamageRegularMax -= 5;	// Vanilla: 25
	}
});
