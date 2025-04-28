::Hardened.HooksMod.hook("scripts/items/shields/wooden_shield", function(q) {
	q.m.HD_BraveryModifierInCompanyColors <- 5;		// This shield provides this much Resolve, while any company colors are used

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
	q.getBraveryModifier = @(__original) function()
	{
		local braveryModifier = __original();
		if (this.getVariant() > 10)	// This might stop working, if someone ever introduces more variants than 10 or uses strings
		{
			braveryModifier += this.m.HD_BraveryModifierInCompanyColors;
		}
		return braveryModifier;
	}

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
