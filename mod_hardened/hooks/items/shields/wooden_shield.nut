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
		this.m.Value = 150;		// In Vanilla this is 100
	}

// Hardened Funnctions
	q.paintInCompanyColors = @() function( _bannerID )
	{
		if (_bannerID >= 0)
		{
			this.setVariant(_bannerID + 10);
			this.updateAppearance();
		}
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
