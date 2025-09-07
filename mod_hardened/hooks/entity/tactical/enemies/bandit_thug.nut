// T1 Tough Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_thug", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		local weapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/greenskins/orc_wooden_club"],
			[1, "scripts/items/weapons/woodcutters_axe"]
		]).roll();

		::Hardened.util.replaceMainhand(this, weapon);
	}
});
