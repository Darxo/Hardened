::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/marketplace_building", function(q) {
	q.getDefaultShopList = @(__original) function()
	{
		local ret = __original();

		foreach (entry in _list)
		{
			if (entry.S == "shields/wooden_shield")
			{
				// We increase the rarity because all towns supplement wooden shields with old/worn variants
				entry.R = 50;	// In Vanilla this is 20
			}
			else if (entry.S == "shields/buckler_shield")
			{
				// We increase the rarity in bigger settlements because buckler are not that useful beyond the early game
				if (this.getSettlement().getSize() == 3 || this.getSettlement().isMilitary())
				{
					entry.R = 40;	// In Vanilla this is 15
				}
			}
			else if (entry.S == "weapons/javelin")
			{
				entry.R = 25;	// In Vanilla this is 30
				entry.S = "weapons/greenskins/orc_javelin";
			}
			else if (entry.S == "accessory/warhound_item")
			{
				entry.R = 95;	// Reforged: 70
			}
			else if (entry.S == "accessory/armored_warhound_item")
			{
				entry.R = 99;	// Reforged: 80
			}
			else if (entry.S == "accessory/wardog_item")
			{
				entry.R = 95;	// Reforged: 70
			}
			else if (entry.S == "accessory/armored_wardog_item")
			{
				entry.R = 99;	// Reforged: 80
			}
		}

		if (this.getSettlement().getSize() <= 2 && !this.getSettlement().isMilitary())
		{
			// Add old wooden shields to lower tier settlements
			_list.push({
				R = 30,
				P = 1.0,
				S = "shields/wooden_shield_old",
			});

			// Add lute to lower tier settlements
			_list.push({
				R = 90,
				P = 1.0,
				S = "weapons/lute",
			});
		}

		// Add worn kite/heater shields to higher tier settlements
		if (this.getSettlement().getSize() == 3 || this.getSettlement().isMilitary())
		{
			_list.push({
				R = 60,
				P = 1.0,
				S = "shields/worn_kite_shield",
			});

			_list.push({
				R = 60,
				P = 1.0,
				S = "shields/worn_heater_shield",
			});
		}

		return ret;
	}
});
