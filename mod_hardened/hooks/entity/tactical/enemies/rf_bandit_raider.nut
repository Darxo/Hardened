// T3 Balanced Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_raider", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
	}

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		local shield = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/shields/wooden_shield"],
			[1, "scripts/items/shields/worn_kite_shield"],
			[1, "scripts/items/shields/worn_heater_shield"],
		]).roll();
		::Hardened.util.replaceOffhand(this, shield);
	}
});
