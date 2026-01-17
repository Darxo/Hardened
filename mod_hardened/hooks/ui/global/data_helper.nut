::Hardened.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
	q.addCharacterToUIData = @(__original) function( _entity, _target )
	{
		__original(_entity, _target);

		// Feat: We rework how experience is displayed to the player
		// Vanilla shows the total current XP and the XP Threshold for the next level
		// But those two values tend to become huge on higher levels and lose meaning to the player, because they include all previous experience in them
		// Also the progress bar tends to be almost always full because of this way of handling XP
		// We instead let each new level start with "0" XP and the maximum is only the XP needed to go from the previous threshold to the threshold
		local nextLevelXPThreshold = _entity.getXPForNextLevel();
		local currentXP = _entity.getXP();
		local prevLevelXPThreshold = 0;
		foreach (xpEntry in ::Const.LevelXP)
		{
			if (xpEntry > _entity.getXP()) break;
			prevLevelXPThreshold = xpEntry;
		}
		_target.xpValue = currentXP- prevLevelXPThreshold;
		_target.xpValueMax = nextLevelXPThreshold - prevLevelXPThreshold;

		_target.id <- _entity.getID();	// This is a little redundant, but we need it for the experience tooltip
	}

	q.convertAssetsInformationToUIData = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("DisplayFoodDuration").getValue())
		{
			local maximumFoodTime = 0;	// The companies food will never last longer than the food item with the longest remaining spoil-duration
			foreach (item in ::World.Assets.getStash().getItems())
			{
				if (item != null && item.isItemType(::Const.Items.ItemType.Food) && item.getSpoilInDays() > maximumFoodTime)
				{
					maximumFoodTime = item.getSpoilInDays();
				}
			}

			local dailyFood = ::Math.ceil(::World.Assets.getDailyFoodCost() * ::Const.World.TerrainFoodConsumption[::World.State.getPlayer().getTile().Type]);
			local time = ::Math.floor(::World.Assets.getFood() / dailyFood);
			ret.FoodDaysLeft <- ::Math.min(time, maximumFoodTime);
		}

		if (::Hardened.Mod.ModSettings.getSetting("DisplayRepairDuration").getValue())
		{
			local armorParts = ::World.Assets.getRepairRequired();	// .ArmorParts .Hours
			if (armorParts.Hours > 0)
			{
				ret.RepairHoursLeft <- armorParts.Hours;
			}
		}

		if (::Hardened.Mod.ModSettings.getSetting("DisplayMinMedicineCost").getValue())
		{
			local heal = ::World.Assets.getHealingRequired();
			if (heal.MedicineMin > 0)
			{
				ret.MedicineRequiredMin <- heal.MedicineMin;
			}
		}

		return ret;
	}
});
