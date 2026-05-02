::Hardened.HooksMod.hook("scripts/skills/effects/rf_frostbound_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/fatigue.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Enemies starting their [turn|Concept.Turn] adjacent to you, gain [$ $|Skill+rf_worn_down_effect]");
			}
		}

		return ret;
	}

// Reforged Functions
	q.onEnemyTurnStart = @() function( _enemy )
	{
		_enemy.getSkills().add(::new("scripts/skills/effects/rf_worn_down_effect"));
	}
});
