::Hardened.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.m.LastVisited <- -1;	// the day that the player last entered this location

	q.getResources = @(__original) function()
	{
		// Feat: the effective resources of settlements now also grow with the world difficulty

		local ret = __original();
		ret *= ::Hardened.Global.getWorldDifficultyMult();

		if (this.isSouthern())		// Anything CityState
		{
			ret *= ::Hardened.Global.FactionDifficulty.CityState;
		}
		else if (this.isMilitary())		// Northern Military Settlements (Noble Forts)
		{
			ret *= ::Hardened.Global.FactionDifficulty.Nobles;
		}
		else	// Northern Civilian Settlements
		{
			ret *= ::Hardened.Global.FactionDifficulty.Militia;
		}

		return ret
	}

	q.getProduce = @(__original) function()
	{
		local ret = __original();

		// Feat: Any settlement that currently has no produce, will instead transport money in their caravans
		if (ret.len() == 0)
		{
			ret.push("supplies/money_item");
		}

		return ret;
	}

	q.getUIInformation = @(__original) function()
	{
		local ret = __original();

		// We reset all situation UI information and recalculate them
		// This fixes the vanilla issue where they purposefully hide duplicate situation
		// But this information is very important in order to understand certain weird town prices or states
		ret.Situations = [];
		foreach (situation in this.getSituations())
		{
			ret.Situations.push({
				ID = situation.getID(),
				Icon = situation.getIcon(),
			});
		}

		return ret;
	}

	q.onUpdateShopList = @(__original) function( _id, _list )
	{
		__original(_id, _list);

		// We go over the item pool after items from attached locations have been added
		for (local index = (_list.len() - 1); index >= 0; --index)
		{
			local entry = _list[index];
			switch (entry.S)
			{
				case "weapons/rf_poleaxe":
				{
					_list.remove(index);	// We prevent any poleaxes from being sold at all
					break;
				}
				case "weapons/rf_battle_axe":
				{
					entry.R = 40;	// Down from 40-85
					break;
				}
				case "weapons/rf_kriegsmesser":
				{
					entry.R = 80;	// Up from 40-60
					break;
				}
			}
		}
	}

	q.onLeave = @(__original) function()
	{
		__original();

		// We reset the HD_BuyBackPrice of all items in the player inventory
		foreach (item in ::World.Assets.getStash().getItems())
		{
			if (item == null) continue;
			item.m.HD_BuyBackPrice = null;
		}

		// We reset the HD_BuyBackPrice of all items in all buildings whenever the player leaves the town
		foreach (building in this.m.Buildings)
		{
			if (building == null) continue;
			if (building.getStash() == null) continue;

			foreach (item in building.getStash().getItems())
			{
				if (item == null) continue;

				item.m.HD_BuyBackPrice = null;
			}
		}
	}

	q.updatePlayerRelation = @(__original) function()
	{
		__original();

		// We now also update the nameplates of all attached locations of this settlement
		if (this.isPlayerControlled()) return;
		if (!this.hasLabel("name")) return;

		foreach (attachedLocation in this.m.AttachedLocations)
		{
			attachedLocation.updatePlayerRelation();
		}
	}
});
