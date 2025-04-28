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
		this.m.Value = 400;		// In Vanilla this is 200
	}

	// Overwrite because Reforged skill preview does not work with removing skills
	q.onEquip = @() function()
	{
		this.shield.onEquip();
		this.addSkill(::new("scripts/skills/actives/shieldwall"));
		// this.addSkill(::new("scripts/skills/actives/knock_back"));
	}

// Hardened Funnctions
	q.paintInCompanyColors = @() function( _bannerID )
	{
		if (_bannerID >= 0)
		{
			this.setVariant(_bannerID + 11);
			this.updateAppearance();
		}
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
