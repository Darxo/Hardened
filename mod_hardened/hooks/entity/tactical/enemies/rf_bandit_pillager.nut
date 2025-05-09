// T1 Tough Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_pillager", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Thick;	// In Reforged this is ::Const.Bodies.AllMale
		__original();
	}

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		// No longer spawn with two-handed hammer or two-handed mace or woodcutters axe
		local weapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/goedendag"],
			[1, "scripts/items/weapons/two_handed_wooden_flail"],
			[1, "scripts/items/weapons/greenskins/orc_metal_club"],
		]).roll();

		::Hardened.util.replaceMainhand(this, weapon);
	}
});
