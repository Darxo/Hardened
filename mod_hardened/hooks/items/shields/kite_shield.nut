::Hardened.HooksMod.hook("scripts/items/shields/kite_shield", function(q) {
	q.m.HD_BraveryModifierInCompanyColors <- 5;		// This shield provides this much Resolve, while any company colors are used

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

// Hardened Functions
	q.getBraveryModifier = @(__original) function()
	{
		local braveryModifier = __original();
		if (this.getVariant() > 11)	// This might stop working, if someone ever introduces more variants than 11 or uses strings
		{
			braveryModifier += this.m.HD_BraveryModifierInCompanyColors;
		}
		return braveryModifier;
	}

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
