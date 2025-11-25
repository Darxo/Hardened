::Hardened.HooksMod.hook("scripts/skills/actives/rf_halberd_impale_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.DamageArmorMultAdd = 0.0;	// Reforged: -0.2
	}

	// Overwrite, because we dont to show the armor damage tooltip anymore
	q.getTooltip = @() function()
	{
		return this.impale.getTooltip();
	}
});
