::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/drum_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsDoubleGrippable = false;	// Vanilla Fix: This is a two-handed weapon so it should never be double-grippable
	}
});
