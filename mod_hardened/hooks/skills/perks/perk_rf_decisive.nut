::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_decisive", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.InitiativeModifier = 0;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.getDamageMult() > 1.0) _properties.ShowFrenzyEyes = true;
	}
});
