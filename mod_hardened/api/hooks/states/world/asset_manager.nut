::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.IsAlwaysShowingScoutingReport <- false;		// Same effect as Vanilla Poacher Origin
	q.m.TerrainTypeVisionMult <- [];

	q.create = @(__original) function()
	{
		__original();
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);
	}

	q.resetToDefaults = @(__original) function()
	{
		this.m.IsAlwaysShowingScoutingReport = false;
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);
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
});
