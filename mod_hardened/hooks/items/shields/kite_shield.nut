::Hardened.HooksMod.hook("scripts/items/shields/kite_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -16;
		this.m.ConditionMax = 48;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Bandit Leader
	Bandit Raider
	Hedge Knight
	Mercenary
	Militia Captain

Reforged
	Bandit Leader
	Bandit Raider
	Mercenary
	Bandit Baron
	Bandit Highwayman
	Bandit Vandal
*/
