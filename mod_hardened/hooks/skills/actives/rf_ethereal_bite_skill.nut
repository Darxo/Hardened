::Hardened.HooksMod.hook("scripts/skills/actives/rf_ethereal_bite_skill", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// We slightly reduce the maximum possible damage so that their damage is less spiky
		_properties.DamageRegularMax -= 5;	// Reforged: 25
	}
});
