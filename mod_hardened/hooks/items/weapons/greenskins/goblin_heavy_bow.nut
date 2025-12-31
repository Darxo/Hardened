::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_heavy_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// In Vanilla named goblin bows have +10% Armor Penetration. We choose to give that to every goblin bow now
		this.m.DirectDamageAdd = 0.1;	// Vanilla: 0.0
	}
});

