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

// Hardened Functions
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
