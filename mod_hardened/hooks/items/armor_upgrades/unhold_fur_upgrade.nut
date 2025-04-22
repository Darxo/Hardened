::Hardened.HooksMod.hook("scripts/items/armor_upgrades/unhold_fur_upgrade", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionModifier = 15;	// In Vanilla this is 10
	}
});
