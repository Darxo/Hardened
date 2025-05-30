::Hardened.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		// Complete replacement of vanilla tooltips
		switch (_elementId)
		{
			// We overwrite the vanilla tooltip because we change and improve several parts. We also mention the new injury mechanic change
			case "assets.Medicine":
			{
				local desc = "Medical Supplies consist of bandages, herbs, salves and the like, and are used to heal the more severe injuries sustained by your men in battle.";	// Fluff
				desc += "\n\nEvery Injury requires " + ::MSU.Text.colorPositive(::Const.World.Assets.MedicinePerInjuryDay) + " Medical Supplies each day to improve and ultimately heal."	// Vanilla Mechanic
				desc += "\nIf you run out of medicine supplies, Injuries have only a " + ::MSU.Text.colorNegative("50%") + " chance to improve each day.";	// New Hardened mechanic
				desc += "\nLost hitpoints heal on their own.";	// Vanilla info

				local heal = ::World.Assets.getHealingRequired();
				if (heal.MedicineMin > 0)
				{
					// We adjust the MedicineMin cost, if the player would run out of medicine in the meantime
					// if (heal.MedicineMin > ::World.Assets.getMedicine()) heal.MedicineMin = ::World.Assets.getMedicine();
					// if (heal.MedicineMax > ::World.Assets.getMedicine()) heal.MedicineMax = ::World.Assets.getMedicine();
					desc += format("\n\nHealing up all your men will take between %s and %s days. Longer, if you run out of Medical Supplies.", ::MSU.Text.colorPositive(heal.DaysMin), ::MSU.Text.colorPositive(heal.DaysMax));
					desc += format(
						"\nThis will requires between %s and %s Medical Supplies.",
						(heal.MedicineMin <= ::World.Assets.getMedicine()) ? ::MSU.Text.colorPositive(heal.MedicineMin) : ::MSU.Text.colorNegative(heal.MedicineMin),
						(heal.MedicineMax <= ::World.Assets.getMedicine()) ? ::MSU.Text.colorPositive(heal.MedicineMax) : ::MSU.Text.colorNegative(heal.MedicineMax)
					);
				}

				local medicineMax = ::Const.Difficulty.MaxResources[::World.Assets.getEconomicDifficulty()].Medicine + ::World.Assets.m.MedicineMaxAdditional;
				desc += ("\n\nYou can carry " + ::MSU.Text.colorPositive(medicineMax) + " supplies at most.");

				return [
					{
						id = 1,
						type = "title",
						text = "Medical Supplies",
					},
					{
						id = 2,
						type = "description",
						text = desc,
					},
				];
			}
		}

		local ret = __original(_entityId, _elementId, _elementOwner);

		// Adjustments of vanilla tooltips
		switch (_elementId)
		{
			case "menu-screen.new-campaign.EasyDifficulty":
				foreach (entry in ret)
				{
					if (entry.id == 2)
					{
						entry.text = "Your men gain experience slightly faster and are slightly stronger, to ease you into the game.\n\nRecommended for players new to the game."
						break;
					}
				}
				::Const.Difficulty.generateTooltipInfo(ret, ::Const.Difficulty.Easy);
				return ret;

			case "menu-screen.new-campaign.NormalDifficulty":
				::Const.Difficulty.generateTooltipInfo(ret, ::Const.Difficulty.Normal);
				return ret;

			case "menu-screen.new-campaign.HardDifficulty":
				::Const.Difficulty.generateTooltipInfo(ret, ::Const.Difficulty.Hard);
				return ret;

			case "tactical-screen.topbar.options-bar-module.FleeButton":
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("Your characters have " + ::MSU.Text.colorizeValue(1, {AddSign = true}) + " [Action Point(s)|Concept.ActionPoints] during retreat"),
				});
				return ret;
			}

			case "character-screen.left-panel-header-module.Experience":
			{
				local entity = _entityId == null ? null : ::Tactical.getEntityByID(_entityId);
				if (entity != null && entity != ::MSU.getDummyPlayer())
				{
					ret.extend([
						{
							id = 3,
							type = "text",
							icon = "/ui/icons/xp_received.png",
							text = "Current XP Mult: " + ::MSU.Text.colorizePct(entity.getXPMult(), {CompareTo = 1.0}),
						},
					]);
				}
				return ret;
			}

			case "world-relations-screen.Relations":
			{
				// This is a recreation of the vanilla algorithm for deciding how much relation influences price
				// For Buy price this must be subtracted from the multiplier, for Sell price it must be added to the multiplier
				local r = ::World.FactionManager.getFaction(_entityId).getPlayerRelation();
				local priceMultAdd = -0.3;
				priceMultAdd += ::Math.min(50, r) * 0.003 + r * 0.003;

				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Buyprice: " + ::MSU.Text.colorizePct(-1 * priceMultAdd, {AddSign = true, InvertColor = true}),
				});

				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Sellprice: " + ::MSU.Text.colorizePct(priceMultAdd, {AddSign = true}),
				});
				break;
			}

			case "world-screen.topbar.options-module.CampButton":
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/vision.png",
					text = ::MSU.Text.colorizeMultWithText(0.75) + " Vision",		// This is implemented in getVisionRadius() of player_party.nut
				});
				if (::World.Assets.m.CampingMult != 1.0)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/asset_supplies.png",
						text = ::MSU.Text.colorizeMultWithText(::World.Assets.m.CampingMult) + " Repair Speed",
					});
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/health.png",
						text = ::MSU.Text.colorizeMultWithText(::World.Assets.m.CampingMult) + " Hitpoint Recovery",
					});
				}

				break;
			}

			case "assets.BusinessReputation":
			{
				if (::Hardened.Mod.ModSettings.getSetting("AlwaysDisplayRenownValue").getValue())
				{
					// Remove the square bracket reputation number because we add that from within the asset_manager
					foreach (entry in ret)
					{
						if ("id" in entry && entry.id == 1)
						{
							entry.text = "Renown: " + ::World.Assets.getBusinessReputationAsText();
							break;
						}
					}
				}
				break;
			}

			case "character-screen.dismiss-popup-dialog.Compensation":
			{
				// Add an additional section explaining sharing of experience when paying compensation
				foreach (entry in ret)
				{
					if ("id" in entry && entry.id == 2)
					{
						entry.text += "\n\nWhen you pay compensation to a brother, he will share " + ::MSU.Text.colorPositive("50%") + " of his experience with all other brothers in your company. Each brother can receive up to " + ::MSU.Text.colorPositive("10%") + " of this shared experience.";
						break;
					}
				}
				break;
			}
		}

		return ret;
	}

	// Setting: No longer show the tooltips for characters, while it is not the turn of the player
	q.tactical_queryEntityTooltipData = @(__original) function( _entityId, _isTileEntity )
	{
		if (::Hardened.Mod.ModSettings.getSetting("HideTileTooltipsDuringNPCTurn").getValue())
		{
			local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
			if (activeEntity == null || !activeEntity.isPlayerControlled()) return null;
		}

		return __original(_entityId, _isTileEntity);
	}

	q.tactical_queryTileTooltipData = @(__original) function()
	{
		local ret = __original();

		if (ret != null)
		{
			local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
			// Setting: No longer show the tooltips for tiles, while it is not the turn of the player
			if (::Hardened.Mod.ModSettings.getSetting("HideTileTooltipsDuringNPCTurn").getValue())
			{
				if (activeEntity == null || !activeEntity.isPlayerControlled()) return null;
			}

			// Feat: show round number when the corpse on this tile was slain
			local lastTileHovered = ::Tactical.State.getLastTileHovered();
			if (lastTileHovered.IsCorpseSpawned)
			{
				local corpse = lastTileHovered.Properties.get("Corpse");
				foreach (entry in ret)
				{
					if ("id" in entry && entry.id == 3 && "RoundAdded" in corpse)
					{
						entry.text = corpse.CorpseName + " was slain here on round " + corpse.RoundAdded;
					}
				}
			}

			// Feat: show duration of tile effect as a tooltip
			// Straight up copy of vanilla condition. I didnt bother rewriting/inverting it yet
			if (lastTileHovered.IsDiscovered && !lastTileHovered.IsEmpty && (!lastTileHovered.IsOccupiedByActor || lastTileHovered.IsVisibleForPlayer))
			{
			}
			else if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.Properties.Effect != null)
			{
				local remainingRounds = lastTileHovered.Properties.Effect.Timeout - ::Time.getRound();
				local tooltipText = null;
				if (remainingRounds == 1)
				{
					tooltipText = "Lasts until the end of this round";
				}
				else if (remainingRounds > 1)
				{
					tooltipText = "Lasts for " + ::MSU.Text.colorPositive(remainingRounds) + " Round(s)";
				}

				if (tooltipText != null)
				{
					ret.push({
						id = 101,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = tooltipText
					});
				}
			}

			// Feat: show hitchance tooltip when moving out of zone of control
			if (::MSU.isKindOf(activeEntity, "player") && activeEntity.isPlayerControlled())
			{
				activeEntity.getZOCHitFactors(ret);
			}
		}

		return ret;
	}

	// Refactor every occurence of "Max Fatigue" in any effect tooltips into "Stamina".
	// Not good for overall performance: better would be going into each individual effect replacing the term there
	q.general_queryStatusEffectTooltipData = @(__original) function(_entityId, _statusEffectId)
	{
		local ret = __original(_entityId, _statusEffectId);

		if (ret != null)
		{
			foreach (entry in ret)
			{
				if (!("text" in entry)) continue;
				entry.text = ::MSU.String.replace(entry.text, "Max Fatigue", "Stamina", true);
				entry.text = ::MSU.String.replace(entry.text, "Maximum Fatigue", "Stamina", true);
			}
		}

		return ret;
	}
});

