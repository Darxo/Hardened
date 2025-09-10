::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_vigorous_assault", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 20 && entry.icon == "ui/icons/warning.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("The effect is lost when you use an attack, [wait|Concept.Wait] or end your [turn|Concept.Turn]");
			}
		}

		return ret;
	}

	// Overwrite, because this perk no longer provides any fatigue discount
	q.getFatigueCostMultMult = @() function()
	{
		return 1.0;
	}

	// Overwrite because swapping weapons no longer disables this perks effect
	q.onPayForItemAction = @() function( _skill, _items ) {}

	// Overwrite, because we only reset the effect when attacks are used
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.isAttack())
		{
			this.m.NumTilesMoved = 0;
		}
	}
});
