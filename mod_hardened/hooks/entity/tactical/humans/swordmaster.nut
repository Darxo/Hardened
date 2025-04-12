::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();
		if (this.m.MyVariant == this.m.SwordmasterVariants.BladeDancer)
		{
			// BladeDancer no longer spawn with two-handed swords
			::Hardened.util.replaceMainhand(this, "scripts/items/weapons/noble_sword");
		}
	}

	q.makeMiniboss = @(__original) function()
	{
		__original();
		if (this.m.MyVariant == this.m.SwordmasterVariants.BladeDancer)
		{
			local mainhandItem = this.getMainhandItem();
			if (mainhandItem != null && mainhandItem.isNamed())
			{
				// BladeDancer no longer spawn with two-handed swords
				::Hardened.util.replaceMainhand(this, "scripts/items/weapons/named/named_sword");
			}
		}
	}
});
