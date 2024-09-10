// T4 Balanced Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_highwayman", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		local shield = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/shields/worn_kite_shield"],
			[1, "scripts/items/shields/worn_heater_shield"],
			[1, "scripts/items/shields/kite_shield"],
			[1, "scripts/items/shields/heater_shield"],
		]).roll();
		::Hardened.util.replaceOffhand(this, shield);
	}
});