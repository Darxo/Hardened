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

	q.onEnemyTurnEnd = @(__original) function( _enemy )
	{
		// We delete the combat log produced by Reforged, because our recoverHitpoints mechanic automatically produces its own better combat log
		local mockObject = ::Hardened.mockFunction(::Tactical.EventLog, "logEx", function( _text ) {
			if (_text.find(" heals for ") != null && _text.find(" points") != null)
			{
				return { done = true, value = null };
			}
		});

		local ret = __original(_enemy);

		mockObject.cleanup();
	}

// Reforged Functions
	q.onEnemyTurnStart = @() function( _enemy )
	{
		_enemy.getSkills().add(::new("scripts/skills/effects/rf_worn_down_effect"));
	}
});
