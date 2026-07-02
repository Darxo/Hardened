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
		this.m.Value = 400;		// In Vanilla this is 250
		this.m.MeleeDefense = 25;
	}

	// Overwrite because Reforged skill preview does not work with removing skills
	q.onEquip = @() function()
	{
		this.shield.onEquip();
		// this.addSkill(::new("scripts/skills/actives/shieldwall"));
		this.addSkill(::new("scripts/skills/actives/knock_back"));
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

	q.HD_hasCompanyColors = @() function()
	{
		// This might stop working, if someone ever introduces more variants than 11 or uses strings
		return this.getVariant() > 11;
	}
});
