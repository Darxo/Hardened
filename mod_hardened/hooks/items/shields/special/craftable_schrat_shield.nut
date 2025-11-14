::Hardened.HooksMod.hook("scripts/items/shields/special/craftable_schrat_shield", function(q) {
	// Private
	q.m.SoundOnRecovery <- [
		"sounds/enemies/dlc2/schrat_regrowth_01.wav",
		"sounds/enemies/dlc2/schrat_regrowth_02.wav",
		"sounds/enemies/dlc2/schrat_regrowth_03.wav",
		"sounds/enemies/dlc2/schrat_regrowth_04.wav",
	];

	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 17;
		this.m.StaminaModifier = -12;
		this.m.ConditionMax = 40;

	// Hardened Adjustments
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);	// Remove tooltip line about spawning saplings
				break;
			}
		}

		return ret;
	}

	q.onTurnStart = @(__original) function()
	{
		local oldCondition = this.getCondition();
		__original();
		local recoveredCondition = ::Math.round(this.getCondition() - oldCondition);

		local actor = this.getContainer().getActor();
		if (recoveredCondition > 0 && !actor.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " \'s shield recovers " + ::MSU.Text.colorPositive(recoveredCondition) + " Condition");
			::Sound.play(::MSU.Array.rand(this.m.SoundOnRecovery), ::Const.Sound.Volume.Skill, actor.getPos());
		}
	}

	q.onCombatStarted = @(__original) function()
	{
		__original();

		foreach (resource in this.m.SoundOnRecovery)
		{
			::Tactical.addResource(resource);	// Make it so these sfx will actually loaded and played immediately the first time
		}
	}

	// Overwrite, because we remove the effect which spawns saplings
	q.onShieldHit = @() function( _attacker, _skill ) {}
});
