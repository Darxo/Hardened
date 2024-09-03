::Hardened.HooksMod.hook("scripts/items/shields/wooden_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.ConditionMax = 24;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Bandit Raider
	Bandit Thug
	Bountry Hunter
	Caravan Guard
	Mercenary
	Militia

Reforged
	Bandit Raider
	Mercenary
	Bandit Scoundrel
	Bandit Vandal
*/
