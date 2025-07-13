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
