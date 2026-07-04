::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.IsAlwaysShowingScoutingReport <- false;		// Same effect as Vanilla Poacher Origin
	q.m.HD_NegotiationPaymentMult <- 1.0;
	q.m.TerrainTypeVisionMult <- [];
	q.m.HD_AdditionalCivilianContracts <- 0;	// Factions have this many additional Contracts available
	q.m.HD_CivilianContractDayDelayModifier <- 0.0;		// Civilian Factions require this many additional days until they spawn another contract
	q.m.HD_FormationSlots <- 18;	// Number of visual formation slots in the character screen in which a brother can be moved into
	q.m.HD_ReserveSlots <- 9;		// Number of visual reserve slots in the character screen in which a brother can be moved into

	q.create = @(__original) function()
	{
		__original();
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);

		this.HD_calculateRosterSlots();
	}

	q.resetToDefaults = @(__original) function()
	{
		this.m.IsAlwaysShowingScoutingReport = false;
		this.m.HD_NegotiationPaymentMult = 1.0;
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);
		this.m.HD_AdditionalCivilianContracts = 0;
		this.m.HD_CivilianContractDayDelayModifier = 0.0;
		__original();
	}

// New Functions
	q.HD_getFormationSize <- function()
	{
		// Todo: test against the expanded reserve mod from discord
		local ret = 0;

		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (bro.getPlaceInFormation() < 18) ++ret;
		}

		return ret;
	}

	q.getTerrainTypeVisionMult <- function( _tileType )
	{
		return this.m.TerrainTypeVisionMult[_tileType];
	}

	// Return the maximum Ammo that the player can carry around
	q.HD_getAmmoMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].Ammo + this.m.AmmoMaxAdditional;
	}

	// Return the maximum Tools that the player can carry around
	q.HD_getArmorPartsMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].ArmorParts + this.m.ArmorPartsMaxAdditional;
	}

	// Return the maximum Medicine that the player can carry around
	q.HD_getMedicineMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].Medicine + this.m.MedicineMaxAdditional;
	}

	/// @return Array with all items from the player stash and those equipped to characters in the player roster
	q.HD_getAllItems <- function()
	{
		local ret = [];

		foreach (item in this.getStash().getItems())
		{
			if (item != null) ret.push(item);
		}

		foreach (brother in ::World.getPlayerRoster().getAll())
		{
			ret.extend(brother.getItems().getAllItems());
		}

		return ret;
	}

	// Remove the item _itemInstance, whether it is equipped to a brother or stored in the player stash
	q.HD_removeItemAnywhere <- function( _itemInstance )
	{
		foreach (brother in ::World.getPlayerRoster().getAll())
		{
			local item = brother.getItems().getItemByInstanceID(_itemInstance.getInstanceID());
			if (item == null) continue;

			return brother.getItems().HD_removeItemAnywhere(_itemInstance);
		}

		// The remove function always returns null, so we need a seperate check to confirm, whether _itemInstance was actually removed
		if (this.getStash().getItemByInstanceID(_itemInstance.getInstanceID()) == null) return false;

		this.getStash().remove(_itemInstance);
		return true;
	}

	// Calculate how many theoretical slots are available for Formation and Reserve
	// These values are very hard to fetch from Vanilla and the magic numbers used there become invalid, should any mod tweak them
	q.HD_calculateRosterSlots <- function()
	{
		local roster = ::World.getTemporaryRoster();
		local dummyArray = [];
		local dummyBroAmount = 45;
		for (local i = 1; i <= dummyBroAmount; ++i)
		{
			dummyArray.push(roster.create("scripts/entity/tactical/player"));
		}

		local oldGetPlayerRoster = ::World.getPlayerRoster;
		::World.getPlayerRoster = function() return { function getAll() { return dummyArray; } }
		this.updateFormation();
		::World.getPlayerRoster = oldGetPlayerRoster;

		local NOT_IN_FORMATION = 255;
		local combatSlots = dummyArray[this.getBrothersMaxInCombat()].getPlaceInFormation();
		local reserveSlots = dummyBroAmount - combatSlots;
		foreach (index, dummy in dummyArray)
		{
			if (dummy.getPlaceInFormation() == NOT_IN_FORMATION)
			{
				reserveSlots = dummyArray[index - 1].getPlaceInFormation() + 1 - combatSlots;
				break;
			}
		}

		this.m.HD_FormationSlots = combatSlots;
		this.m.HD_ReserveSlots = reserveSlots;
	}
});
