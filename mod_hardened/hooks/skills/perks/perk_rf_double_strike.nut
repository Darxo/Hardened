::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_double_strike", function(q) {
	// Double Strike no longer turns off if you switch weapons
	q.onPayForItemAction = @() function( _skill, _items ) {}

// Reforged Functions
	// Overwrite because we now also allow ranged attacks
	q.isSkillValid = @() function( _skill )
	{
		return _skill.isAttack() && !_skill.isAOE();
	}
});
