::Hardened.HooksMod.hook("scripts/skills/actives/rf_halberd_sunder_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 30;	// Reforged: 25
	}
});
