::Hardened.HooksMod.hook("scripts/skills/actives/rf_ethereal_bite_skill", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// We slightly reduce the maximum possible damage so that their damage is less spiky
		_properties.DamageRegularMax -= 5;	// Reforged: 25
	}

	// Overwrite, because we remove mention of the grave chill effect from this skill
	q.getTooltip = @(__original) function()
	{
		return this.skill.getDefaultTooltip();
	}

	// Overwrite, because we remove the grave chill effect from this skill
	q.onUse = @() function( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}
});
