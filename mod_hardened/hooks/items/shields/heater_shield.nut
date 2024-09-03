::Hardened.HooksMod.hook("scripts/items/shields/heater_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -14;
		this.m.ConditionMax = 32;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Bandit Leader
	Hedge Knight
	Mercenary
	Oathbringer

Reforged
	Bandit Leader
	Mercenary
	Oathrbinger
	Bandit Baron
	Bandit Highwayman
*/
