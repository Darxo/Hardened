// T1 Tough Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_outlaw", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		// No longer spawn with two-handed wooden flail or greatsword
		local weapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/rf_battle_axe"],
			[1, "scripts/items/weapons/two_handed_mace"],
			[1, "scripts/items/weapons/two_handed_wooden_hammer"],
		]).roll();

		::Hardened.util.replaceMainhand(this, weapon);
	}
});
