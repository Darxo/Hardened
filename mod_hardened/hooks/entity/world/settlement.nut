::Hardened.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.m.LastVisited <- -1;	// the day that the player last entered this location

	q.onEnter = @(__original) function()
	{
		this.m.LastVisited = ::World.getTime().Days;
		return __original();
	}

	q.onSerialize = @(__original) function( _out )
	{
		this.getFlags().set("hd_LastVisited", this.m.LastVisited);
		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.getFlags().has("hd_LastVisited")) this.m.LastVisited = this.getFlags().get("hd_LastVisited");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 12,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = this.getLastVisitedString()
		});

		return ret;
	}

	q.onUpdateShopList = @(__original) function( _id, _list )
	{
		switch (_id)
		{
			case "building.marketplace":
			{
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
						if (this.getSize() == 3 || this.isMilitary())
						{
							entry.R = 40;	// In Vanilla this is 15
						}
					}
					else if (entry.S == "weapons/javelin")
					{
						entry.R = 25;	// In Vanilla this is 30
						entry.S = "weapons/greenskins/orc_javelin";
					}
				}

				// Add old wooden shields to lower tier settlements
				if (this.getSize() <= 2 && !this.isMilitary())
				{
					_list.push({
						R = 30,
						P = 1.0,
						S = "shields/wooden_shield_old",
					});
				}

				// Add worn kite/heater shields to higher tier settlements which are not southern
				if (!this.isSouthern() && (this.getSize() == 3 || this.isMilitary()))
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
				break;
			}
			case "building.fletcher":		// Note that this building has an inherent price multiplier of 1.25
			{
				foreach (entry in _list)
				{
					if (entry.S == "weapons/throwing_spear")
					{
						// We reduce the rarity and increase price to make Throwing Spears on par with throwing nets that are also now sold here
						entry.R = 20;	// In Vanilla this is 90
						entry.P = 1.5;	// In Vanilla this is 1.0
					}
					else if (entry.S == "tools/throwing_net")
					{
						entry.P = 2.0;	// In Reforged this is 3.0
					}
				}
				// We add throwing spears a second time similar to how nets have two entries
				_list.push({
					R = 20,
					P = 1.5,
					S = "weapons/throwing_spear",
				});

				break;
			}
			case "building.weaponsmith":
			case "building.weaponsmith_oriental":
			case "building.armorsmith":
			case "building.armorsmith_oriental":
			{
				_list.push({
					R = 0,
					P = 1.25,	// Note that these buildings have an inherent price multiplier of 1.25
					S = "supplies/armor_parts_item",
				});
				break;
			}
		}

		__original(_id, _list);
	}

// New Functions
	q.getLastVisitedString <- function()
	{
		local ret = "Last visited: ";
		if (this.isVisited() == false) return ret + "never";
		if (this.getLastVisited() == -1) return ret + "unknown";	// This should only ever happen when loading old save games

		local dayDifference = ::World.getTime().Days - this.getLastVisited();
		if (dayDifference == 0) return ret + "today";
		if (dayDifference == 1) return ret + "1 day ago";
		return ret + dayDifference + " days ago";
	}

	q.getLastVisited <- function()
	{
		return this.m.LastVisited;
	}
});
