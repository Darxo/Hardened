::Hardened.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		local ret = __original(_entityId, _elementId, _elementOwner);

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
		}

		return ret;
	}

	q.tactical_queryTileTooltipData = @(__original) function()
	{
		local ret = __original();

		if (ret != null)
		{
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

