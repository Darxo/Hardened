::Hardened.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
	q.addCharacterToUIData = @(__original) function( _entity, _target )
	{
		__original(_entity, _target);
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
