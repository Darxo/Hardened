// T1 Balanced Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_scoundrel", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		local shield = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/shields/buckler_shield"],
			[1, "scripts/items/shields/wooden_shield_old"],
		]).roll();
		::Hardened.util.replaceOffhand(this, shield);

		// In order to improve progression, Scoundrels no longer drop Dagger and instead appear with Knifes
		::Hardened.util.replaceMainhand(this, "scripts/items/weapons/knife", ["weapon.dagger"]);
	}
});
