::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.makeMiniboss = @(__original) function()
	{
		__original();

		local mainhandItem = this.getMainhandItem();
		if (mainhandItem != null && mainhandItem.isNamed())
		{
			// All Swordmaster now use named one-handed swords at all times
			if (this.m.MyVariant == this.m.SwordmasterVariants.Metzger)
			{
				::Hardened.util.replaceMainhand(this, "scripts/items/weapons/named/named_shamshir");
			}
			else
			{
				::Hardened.util.replaceMainhand(this, "scripts/items/weapons/named/named_sword");
			}
		}
	}
});
