::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		if (!this.isAlliedWithPlayer())
		{
			if (!this.m.IsShowingDefenders)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "ui/orientation/player_01_orientation.png",
					text = "Hides defender",
				});
			}
			else if (this.m.HideDefenderAtNight)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "skills/status_effect_35.png",
					text = "Hides defender during night",
				});
			}

			if (!this.isAttackable() && this.isLocationType(::Const.World.LocationType.Unique) && this.hasCloseByHostileParty())
			{
				ret.push({
					id = 40,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Cannot be attacked because there is another hostile party nearby",
				});
			}
		}
		return ret;
	}

	q.isAttackable = @(__original) function()
	{
		local ret = __original();
		if (!ret) return false;

		if (!this.isLocationType(::Const.World.LocationType.Unique)) return true;

		// Feat: Unique Locations are only attackable, if there is no entity on top of them, which might otherwise drag them into a fight with the player
		// This prevents third parties from forcing the player into a fight with the unique location
		return !this.hasCloseByHostileParty();
	}

	q.setShowName = @(__original) function( _b )
	{
		__original(_b);

		if (_b && this.getDefenderSpawnList() != null && this.getResources() != 0 && ::Hardened.Mod.ModSettings.getSetting("DisplayLocationNumerals").getValue())
		{
			if (this.isShowingDefenders())
			{
				this.getTooltip();	// We call getTooltip, to force this location to spawn a defender line-up

				local nameWithNumeral = this.getName();
				if (this.getTroops().len() != 0)	// A location with 0 troops after getTooltip is called, is probably a special location, so the default name should show
				{
					nameWithNumeral += " (" + ::Hardened.Numerals.getNumeralString(this.getTroops().len(), true) + ")";
				}
				this.getLabel("name").Text = nameWithNumeral;
			}
			else
			{
				this.getLabel("name").Text = this.getName() + " (?)";
			}
		}
		else
		{
			this.getLabel("name").Text = this.getName();
		}
	}

	q.onSpawned = @(__original) function()
	{
		// We interecept the (hopefully) only rand roll using 20 and 100 as its arguments, and make it instead become a roll from 1 to 100
		// That will increase the chance for named weapons to be chosen to 40% and reduce the chance of any other type down to 20%
		local mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (vargv.len() == 2 && vargv[0] == 20 && vargv[1] == 100)
			{
				return { done = true, value = ::Math.rand(1, 100) };
			}
		});

		__original();

		mockObjectRand.cleanup();
	}

// New Functions
	// Determines, whether there is another party in CombatPlayerDistance range, which is hostile to the player
	q.hasCloseByHostileParty <- function()
	{
		local allNearbyEntitities = ::World.getAllEntitiesAtPos(this.getPos(), ::Const.World.CombatSettings.CombatPlayerDistance * 2.0);
		foreach (nearbyEntity in allNearbyEntitities)
		{
			if (::MSU.isEqual(nearbyEntity, this)) continue;
			if (nearbyEntity.isAlliedWith(::World.State.getPlayer())) continue;

			return true;
		}
		return false;
	}
});
