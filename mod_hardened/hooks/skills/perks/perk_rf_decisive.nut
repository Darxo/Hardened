::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_decisive", function(q) {
	// Private
	q.m.HD_InactiveIcon <- "ui/perks/perk_rf_decisive_sw.png";
	q.m.HD_ActiveIcon <- "ui/perks/perk_rf_decisive.png";

	q.create = @(__original) function()
	{
		__original();
		this.m.BraveryMult = 1.0;
		this.m.Icon = this.m.HD_InactiveIcon;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.getDamageMult() > 1.0) _properties.ShowFrenzyEyes = true;
	}

// Reforged Functions
	q.setStacks = @(__original) function( _newStacks )
	{
		__original(_newStacks);

		// We also grey out the effect icon, while this perk is inactive to improve the visual feedback given to the player
		if (this.m.Stacks == 0)
		{
			this.m.Icon = this.m.HD_InactiveIcon;
		}
		else
		{
			this.m.Icon = this.m.HD_ActiveIcon;
		}
	}
});
