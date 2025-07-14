::Hardened.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.isDroppedAsLoot = @(__original) function()
	{
		if (this.isItemType(::Const.Items.ItemType.Named))
		{
			// Similar check as Vanilla does
			local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || this.getContainer() != null && !::MSU.isNull(this.getContainer().getActor()) && this.isKindOf(this.getContainer().getActor().get(), "player");

			// Feat: A named weapon that is worn by a non-player will now generally drop, even if it uses ammo
			// In Vanilla there are weird exceptions, like throwing weapons would sometimes not drop, which extended towards named weapons unfortunately
			if (!isPlayer) return this.item.isDroppedAsLoot();
		}

		return __original();
	}
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/named/named_weapon", function(q) {
	// We do this as a treehook as we can't guarantee that every weapon implementation calls the base function
	q.onPutIntoBag = @(__original) function()
	{
		__original();

		// Vanilla Fix: we assign a Name to a named weapon even if it is added to the bag.
		// In Vanilla that is only done during regular equipping and when it is added to any stash
		if (this.m.Name.len() == 0)
		{
			if (::Math.rand(1, 100) <= 25)
			{
				this.setName(this.getContainer().getActor().getName() + "\'s " + ::MSU.Array.rand(this.m.NameList));
			}
			else
			{
				this.setName(this.createRandomName());
			}
		}
	}
});
