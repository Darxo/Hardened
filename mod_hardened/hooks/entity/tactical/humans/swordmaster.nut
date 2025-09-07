::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		// We need to check for empty slots because we dont want to overwrite named weapons, as makeMiniboss happens first
		// We need to this first, because after Reforged assigned their weapons, the mainhand will no longer be empty
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			// All Swordmaster now use named one-handed swords at all times
			if (this.m.MyVariant == this.m.SwordmasterVariants.Metzger)
			{
				this.getItems().equip(::new("scripts/items/weapons/shamshir"));
			}
			else
			{
				this.getItems().equip(::new("scripts/items/weapons/noble_sword"));
			}
		}

		__original();

		local shield = this.getOffhandItem();
		if (shield != null) this.getItems().unequip(shield);
	}

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
