// T4 Tough Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_marauder", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		// No longer spawn with two-handed wooden flail. Twice as likely to spawn with greatsword
		local weapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/rf_battle_axe"],
			[1, "scripts/items/weapons/two_handed_mace"],
			[1, "scripts/items/weapons/two_handed_wooden_hammer"],
			[1, "scripts/items/weapons/rf_greatsword"],
		]).roll();

		::Hardened.util.replaceMainhand(this, weapon);
	}
});
