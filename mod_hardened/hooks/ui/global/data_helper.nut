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
			if (xpEntry >= nextLevelXPThreshold) break;
			prevLevelXPThreshold = xpEntry;
		}
		_target.xpValue = currentXP- prevLevelXPThreshold;
		_target.xpValueMax = nextLevelXPThreshold - prevLevelXPThreshold;

		_target.id <- _entity.getID();	// This is a little redundant, but we need it for the experience tooltip

		// We hijack isPlayerCharacter in order to disable the dismiss button for characters who are angry and may desert at any moment
		// This has no sideffects, because in Vanilla isPlayerCharacter is only ever used to disable that button the js side
		if (_entity.getMoodState() <= ::Const.MoodState.Angry)
		{
			_target.isPlayerCharacter = true;
		}
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
			if (armorParts.ArmorParts > 0)
			{
				ret.RepairHoursLeft <- armorParts.ArmorParts;
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

	q.convertEntityToUIData = @(__original) function( _entity, _activeEntity )
	{
		local ret = __original(_entity, _activeEntity);

		// Feat: we display the ammo warning on the character figure in the character screen
		if (::Hardened.Mod.ModSettings.getSetting("DisplayAmmoWarningIcon").getValue())
		{
			local noAmmoWarning = _entity.getSkills().getSkillByID("special.no_ammo_warning");
			if (noAmmoWarning != null && !noAmmoWarning.isHidden())
			{
				ret.injuries.push({
					id = noAmmoWarning.getID(),
					imagePath = noAmmoWarning.getIconColored(),
				});
			}
		}

		// Feat: we display the encumbrance warning on the character figure in the character screen
		if (::Hardened.Mod.ModSettings.getSetting("DisplayEncumbranceIcon").getValue())
		{
			local encumbrance = _entity.getSkills().getSkillByID("effects.rf_encumbrance");
			if (encumbrance != null && !encumbrance.isHidden())
			{
				ret.injuries.push({
					id = encumbrance.getID(),
					imagePath = encumbrance.getIconColored(),
				});
			}
		}

		return ret;
	}
});
