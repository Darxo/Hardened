// T2 Balanced Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_vandal", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		local shield = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/shields/wooden_shield_old"],
			[1, "scripts/items/shields/wooden_shield"],
		]).roll();
		::Hardened.util.replaceOffhand(this, shield);
	}
});
