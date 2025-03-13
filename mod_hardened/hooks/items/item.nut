::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	// We replace the vanilla weight tooltip on all items with a more descriptive and hyperlinked term
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if ("text" in entry)
			{
				if (entry.text.find("Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]") != null)	// Regular weight tooltip line for items
				{
					if (this.getWeight() == 0)	// Since we made Vanilla produce weight tooltips for weapons even while the item has no weight, we need to clean them up now
					{
						ret.remove(index);
					}
					else
					{
						entry.icon = "ui/icons/bag.png";
						entry.text = ::Reforged.Mod.Tooltips.parseString("[Weight|Concept.Weight]: ") + ::MSU.Text.colorNegative(this.getWeight());
					}
					break;
				}
				else if (entry.text.find("[/color] Maximum Fatigue") != null)	// Weight tooltip line for attachements
				{
					entry.icon = "ui/icons/bag.png";
					entry.text = ::MSU.Text.colorNegative("+" + this.getWeight()) + ::Reforged.Mod.Tooltips.parseString(" [Weight|Concept.Weight]");
					break;
				}
			}
		}

		return ret;
	}

	// This is often times not called, if no corpse was generated, but that is a vanilla issue and not our concern here
	q.drop = @(__original) function( _tile )
	{
		// This is a replica of the vanilla function for deciding, whether this is allowed to be dropped at all
		local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || this.m.Container != null && this.m.Container.getActor() != null && !this.m.Container.getActor().isNull() && this.isKindOf(this.m.Container.getActor().get(), "player");
		local isDropped = this.isDroppedAsLoot() && (::Tactical.State.getStrategicProperties() == null || !::Tactical.State.getStrategicProperties().IsArenaMode || isPlayer);
		if (isDropped && !this.isChangeableInBattle())
		{
			// Goal: Items which are not changeable during battle, are no longer dropped on the tile but instead directly pushed into the CombatResultLoot
			// However if one of those items is stackable, then we try to merge it into an existing item first
			// This improves visual clarity on the battlefield so lootbags only signal stuff you can actually pick up

			// Right now this is hard-coded list
			// We could check for the existance of this.m.Amount on them, but that includes food and we dont wanna allow stacking of food without enforcing a maximum
			local stackableItems = [
				"supplies.ammo",
				"supplies.armor_parts",
				"supplies.medicine",
				"supplies.money",
			];

			// Now we take a look if our item is stackable and already present in the stash_container
			if (stackableItems.find(this.getID()) != null)
			{
				foreach (lootItem in ::Tactical.CombatResultLoot.getItems())
				{
					if (lootItem.getID() == this.getID())
					{
						// We were able to add the amount of our item to an existing item in the loot pool. So we dont need to drop it manually
						lootItem.setAmount(lootItem.getAmount() + this.getAmount());
						return;
					}
				}
			}

			// If the item was equipped, we detach it from that character
			if (this.getContainer() != null)
			{
				if (this.m.CurrentSlotType == ::Const.ItemSlot.Bag)
				{
					this.getContainer().removeFromBag(this);
				}
				else
				{
					this.getContainer().unequip(this);
				}
			}

			::Tactical.CombatResultLoot.add(this);
		}
		else
		{
			__original(_tile);
		}
	}
});

