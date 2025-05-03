::Hardened.HooksMod.hook("scripts/skills/effects/killing_frenzy_effect", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.ShowFrenzyEyes = true;
	}
});
