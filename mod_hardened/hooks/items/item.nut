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
			// This improves visual clarity on the battlefield so lootbags only signal stuff you can actually pick up
			::Tactical.CombatResultLoot.add(this);
		}
		else
		{
			__original(_tile);
		}
	}
});

