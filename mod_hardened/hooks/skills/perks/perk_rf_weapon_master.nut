::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_weapon_master", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsRefundable = false;	// Otherwise this would be an autopick for pp and a bit abusable in general with refund items
	}

	q.onAdded = @(__original) function()
	{
		if (this.m.IsNew)
		{
			local actor = this.getContainer().getActor();
			local perkTree = actor.getPerkTree();

			local exclude = [];
			local category = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_weapon");
			foreach (groupID in category.getGroups())
			{
				if (perkTree.hasPerkGroup(groupID)) exclude.push(groupID);
			}
			local newPerkGroup = category.getRandomGroup(exclude);
			if (newPerkGroup != null)
			{
				perkTree.addPerkGroup(newPerkGroup);
			}
		}
	}

	q.onEquip = @(__original) function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isHybridWeapon())
		{
			return;		// Hybrid weapons no longer work with Weapon Master
		}

		return __original(_item);
	}
});
