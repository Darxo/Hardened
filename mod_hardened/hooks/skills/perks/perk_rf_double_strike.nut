::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_double_strike", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Having just landed a hit, this character is ready to perform a powerful followup strike!";	// We just remove the second sentence added by reforged as it is redundant
	}

	// Double Strike no longer turns off if you switch weapons
	q.onPayForItemAction = @() function( _skill, _items ) {}

	// Double Strike no longer turns off if you switch weapons
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree ) {}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 20 && entry.icon == "ui/icons/warning.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will be lost upon moving, missing an attack, [waiting|Concept.Wait] or ending the [turn|Concept.Turn]");
			}
		}

		return ret;
	}

// Reforged Functions
	// Overwrite because we now also allow ranged attacks
	q.isSkillValid = @() function( _skill )
	{
		return _skill.isAttack() && !_skill.isAOE();
	}
});
