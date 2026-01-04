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

				local medicineMax = ::World.Assets.HD_getMedicineMax();
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
				::Const.Difficulty.generateCombatDifficultyTooltip(ret, ::Const.Difficulty.Easy);
				return ret;

			case "menu-screen.new-campaign.NormalDifficulty":
				::Const.Difficulty.generateCombatDifficultyTooltip(ret, ::Const.Difficulty.Normal);
				return ret;

			case "menu-screen.new-campaign.HardDifficulty":
				::Const.Difficulty.generateCombatDifficultyTooltip(ret, ::Const.Difficulty.Hard);
				return ret;

			case "menu-screen.new-campaign.EasyDifficultyEconomic":
				::Const.Difficulty.generateEconomicDifficultyTooltip(ret, ::Const.Difficulty.Easy);
				return ret;

			case "menu-screen.new-campaign.NormalDifficultyEconomic":
				::Const.Difficulty.generateEconomicDifficultyTooltip(ret, ::Const.Difficulty.Normal);
				return ret;

			case "menu-screen.new-campaign.HardDifficultyEconomic":
				::Const.Difficulty.generateEconomicDifficultyTooltip(ret, ::Const.Difficulty.Hard);
				return ret;

			case "menu-screen.new-campaign.EasyDifficultyBudget":
				::Const.Difficulty.generateStartingDifficultyTooltip(ret, ::Const.Difficulty.Easy);
				return ret;

			case "menu-screen.new-campaign.NormalDifficultyBudget":
				::Const.Difficulty.generateStartingDifficultyTooltip(ret, ::Const.Difficulty.Normal);
				return ret;

			case "menu-screen.new-campaign.HardDifficultyBudget":
				::Const.Difficulty.generateStartingDifficultyTooltip(ret, ::Const.Difficulty.Hard);
				return ret;

			case "tactical-screen.topbar.options-bar-module.FleeButton":
			{
				local retreatDefenseBonus = ::Const.Difficulty.RetreatDefenseBonus[::World.Assets.getDifficulty()];
				if (retreatDefenseBonus != 0)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = "Your characters have " + ::MSU.Text.colorizeValue(retreatDefenseBonus, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Melee Defense|Concept.MeleeDefense] during Auto-Retreat"),
					});
				}

				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("Your characters have " + ::MSU.Text.colorizeValue(1, {AddSign = true}) + " [Action Point(s)|Concept.ActionPoints] during Auto-Retreat"),
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

			case "character-screen.left-panel-header-module.Level":
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Level",
					},
					{
						id = 2,
						type = "description",
						text = ::Reforged.Mod.Tooltips.parseString("The character\'s level measures [experience|Concept.Experience] in battle. Characters rise in levels as they gain experience and are able to increase their [attributes|Concept.CharacterAttribute] and gain [perks|Concept.Perk] that make them better at the mercenary profession.\n\nBeyond the " + ::Const.XP.MaxLevelWithPerkpoints + "th character level, characters are veterans will no longer gain perk points. They can still improve their attributes but the attribute gain per level is small."),
					},
				];
			}

			case "world-relations-screen.Relations":
			{
				// Feat: Add simple tooltip line indicating whether you are currently allies or hostile with this faction
				local relation = ::World.FactionManager.getFaction(_entityId).getPlayerRelation();
				if (relation < 20.0)	// 20.0 is a magic number by vanilla, defined in faction::updatePlayerRelation
				{
					ret.push({
						id = 14,
						type = "text",
						icon = "ui/icons/icon_contract_swords.png",
						text = "Hostile",
					});
				}
				else
				{
					ret.push({
						id = 14,
						type = "text",
						icon = "ui/icons/relations.png",
						text = "Allied",
					});
				}

				// This is a recreation of the vanilla algorithm for deciding how much relation influences price
				// For Buy price this must be subtracted from the multiplier, for Sell price it must be added to the multiplier
				local pricePct = ::World.FactionManager.getFaction(_entityId).HD_getRelationPricePct();

				ret.push({
					id = 15,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Buyprice: " + ::MSU.Text.colorizePct(-1 * pricePct, {AddSign = true, InvertColor = true}),
				});

				ret.push({
					id = 16,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Sellprice: " + ::MSU.Text.colorizePct(pricePct, {AddSign = true}),
				});

				// Remove all vanilla relation entries, as we add them slightly differently
				for (local i = ret.len() - 1; i >= 0; --i)
				{
					if (ret[i].id == 11 && (ret[i].icon == "ui/tooltips/positive.png" || ret[i].icon == "ui/tooltips/negative.png"))
					{
						ret.remove(i);
					}
				}

				local changes = ::World.FactionManager.getFaction(_entityId).getPlayerRelationChanges();
				foreach (change in changes)
				{
					local changeText = change.Text;
					if (change.Combined > 1) changeText += " (x" + change.Combined + ")";	// We add the number of combined entries dynamically

					ret.push({
						id = 11,
						type = "hint",
						icon = change.Positive ? "ui/tooltips/positive.png" : "ui/tooltips/negative.png",
						text = changeText,
					});
				}
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

				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/contract_scroll.png",
					text = "Contracts pay " + ::MSU.Text.colorizeMultWithText(::Hardened.Global.getWorldContractMult()) + " Crowns",
				});

				ret.push({
					id = 14,
					type = "text",
					icon = "ui/icons/miniboss.png",
					text = "Contracts are " + ::MSU.Text.colorizeMultWithText(::Hardened.Global.getWorldContractMult(), {InvertColor = true}) + " difficult",
				});
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

			case "character-stats.SightDistance":
			{
				foreach (entry in ret)
				{
					if ("id" in entry && entry.id == 2)
					{
						entry.text = ::Reforged.Mod.Tooltips.parseString(
							"Vision determines how far a character can see on the battlefield and how much of the fog of war they uncover.\n\n" +
							"Most attacks and skills require the user to have line of sight and sufficient Vision to the targeted tile.\n\n" +
							"Tiles revealed by a character remain visible until the start of the next [Round|Concept.Round] unless still within sight.\n\n" +
							"Vision can never be reduced below " + ::MSU.Text.colorPositive("2") + "."
						);
						break;
					}
				}
				break;
			}

			case "character-stats.ChanceToHitHead":
			{
				foreach (entry in ret)
				{
					if ("id" in entry && entry.id == 2)
					{
						// We add an explanation about the softcap and emphasize that this stat also helps against animals and two-tile attacks
						entry.text = ::Reforged.Mod.Tooltips.parseString(
							"Determines the likelihood of striking an enemy's head instead of their body.\n\n" +
							"A hit to the head deals " + ::MSU.Text.colorizeMult(::Const.CharacterProperties.DamageAgainstMult[::Const.BodyPart.Head], {AddSign = true}) + " [Critical Damage.|Concept.CriticalDamage]\n\n" +
							"The default chance to hit the head is " + ::MSU.Text.colorPositive(::Const.CharacterProperties.HitChance[::Const.BodyPart.Head] + "%") + ", but this can be modified by perks or specific attacks.\n\n" +
							"Some enemies lack a head, resulting in all attacks hitting the body."
						);
						break;
					}
				}
				break;
			}
		}

		return ret;
	}

	q.tactical_helper_addHintsToTooltip = @(__original) function( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local ret = __original(_activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);

		switch(_itemOwner)
		{
			case "world-town-screen-shop-dialog-module.stash":
			{
				if (_item.m.HD_BuyBackPrice != null)
				{
					ret.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/special.png",
						text = "Can be sold again for its buy price",
					});
				}
				break;
			}
			case "world-town-screen-shop-dialog-module.shop":
			{
				if (_item.m.HD_BuyBackPrice != null && this.Stash.hasEmptySlot())
				{
					ret.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/special.png",
						text = "Can be bought back for its sell price",
					});
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
						if (corpse.HD_FatalityType == ::Const.FatalityType.Unconscious)
						{
							entry.text = ::Hardened.util.getColorizedCorpseName(corpse) + " was " + ::MSU.Text.colorPositive("struck down") + " here on round " + corpse.RoundAdded;
						}
						else
						{
							entry.text = ::Hardened.util.getColorizedCorpseName(corpse) + " was " + ::MSU.Text.colorPositive("slain") + " here on round " + corpse.RoundAdded;
						}
						break;
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
		}

		return ret;
	}

// Reforged Functions
	q.RF_getZOCAttackTooltip = @(__original) function( _entity )
	{
		// We call the original, because we still want its fatigue tooltip and tooltip for moving into spearwall
		local ret = __original(_entity);

		// We only show the ZOC hitfactors, if this actor is previewing movement
		if (::MSU.isNull(_entity) || _entity.getCurrentProperties().IsImmuneToZoneOfControl || _entity.getPreviewMovement() == null)
		{
			return ret;
		}

		// We remove the Reforged tooltips about chance to be hit when moving, except about fatigue cost
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];

			if (entry.id == 100 && entry.icon != "ui/icons/fatigue.png")
			{
				ret.remove(index);
			}
		}

		// First we generate hitchances for when we are standing in enemy ZoC
		if (_entity.getTile().Properties.Effect == null || _entity.getTile().Properties.Effect.Type != "smoke")	// onMovementInZoneOfControl does not check for this, so we do it here now
		{
			if (_entity.getTile().getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) == 0)
			{
				ret.insert(0, {
					id = 200,
					type = "text",
					// icon = "ui/icons/hitchance.png",
					text = ::Reforged.Mod.Tooltips.parseString("You are not in an enemy [Zone of Control|Concept.ZoneOfControl]"),
				});
			}
			else
			{
				local aooInformation = [];
				local expectedChanceToBeHit = 0;
				local childId = 201;
				foreach (tile in ::MSU.Tile.getNeighbors(_entity.getTile()))
				{
					if (!tile.IsOccupiedByActor) continue;
					if (!tile.getEntity().onMovementInZoneOfControl(_entity, false)) continue;		// The entity in that tile does not exert zone of control onto us

					local aooSkill = tile.getEntity().getSkills().getAttackOfOpportunity();
					if (!aooSkill.onVerifyTarget(tile, _entity.getTile())) continue;	// The aooSkill found can actually hit us (this will cover cases of tile height difference being too large)

					local chanceToBeHit = aooSkill.getHitchance(_entity);
					if (expectedChanceToBeHit == 0)
					{
						expectedChanceToBeHit = chanceToBeHit;
					}
					else
					{
						local expectedChanceToDodge = (100 - expectedChanceToBeHit) * (100 - chanceToBeHit) / 100;
						expectedChanceToBeHit = 100 - expectedChanceToDodge;
					}

					aooInformation.push({
						id = childId++,
						type = "text",
						icon = "ui/orientation/" + tile.getEntity().getOverlayImage() + ".png",
						children = aooSkill.getHitFactors(_entity.getTile()),
						text = ::MSU.Text.colorNegative(chanceToBeHit + "%") + ::Reforged.Mod.Tooltips.parseString(" [Chance to be hit|Concept.ZoneOfControl] by " + ::Const.UI.getColorizedEntityName(tile.getEntity())),
					});
				}

				ret.insert(0, {
					id = 200,
					type = "text",
					icon = "ui/icons/hitchance.png",
					children = aooInformation,
					text = ::MSU.Text.colorNegative(expectedChanceToBeHit + "%") + ::Reforged.Mod.Tooltips.parseString(" [Expected chance to be hit|Concept.ZoneOfControl]"),
				});
			}
		}

		return ret;
	}

	// We need to manually recalculate the fatigue tooltip, because Reforged uses actor::getFatigueMax, to try to fetch the base value.
	// But that function always includes the penalty from item weight in Hardened
	q.getBaseAttributesTooltip = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		local ret = __original(_entityId, _elementId, _elementOwner);

		if (!(_elementId == "character-stats.Fatigue")) return ret;		// We only adjust Fatigue

		local entity = _entityId == null ? null : ::Tactical.getEntityByID(_entityId);
		if (entity == null || entity == ::MSU.getDummyPlayer()) return ret;

		local baseValue = entity.getBaseProperties().getStamina();
		local currentValue = entity.getStamina();
		foreach (entry in ret)
		{
			if (entry.id == 3)
			{
				entry.text = "Base: " + ::MSU.Text.colorizeValue(baseValue, {AddSign = baseValue < 0});
			}
			else if (entry.id == 4)
			{
				entry.text = "Modifier: " + ::MSU.Text.colorizeValue(currentValue - baseValue, {AddSign = true});
			}
		}

		return ret;
	}
});
