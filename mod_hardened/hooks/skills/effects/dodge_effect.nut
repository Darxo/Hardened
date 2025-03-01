::Hardened.HooksMod.hook("scripts/skills/effects/dodge_effect", function(q) {
	q.m.BaseFraction <- 0.00;
	q.m.FractionPerEmptyTile <- 0.05;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Harness your agility to evade attacks, bolstering your defenses with quick reflexes. The more space you have to move, the harder you are to hit."
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this effect grants defense depending on adjacent empty tiles
	}

	// Overwrite of Vanilla function to stop its effects and apply our own
	q.onAfterUpdate = @() function( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			local defenseValue = this.calculateBonus();
			_properties.MeleeDefense += defenseValue;
			_properties.RangedDefense += defenseValue;
		}
	}

	// Overwrite of Vanilla function to stop its effects and apply our own
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();	// Get name and description the way that the base class does it

		if (this.getContainer().getActor().isPlacedOnMap())
		{
			local defenseValue = this.calculateBonus();
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(defenseValue, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense]"),
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(defenseValue, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
				}
			]);
		}
		else
		{
			local baseBonus = this.calculateBonus(0);
			local bonusPerTile = this.calculateBonus(1) - baseBonus;

			if (this.m.BaseFraction != 0.0)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizePct(this.m.BaseFraction) + " (" + ::MSU.Text.colorPositive(baseBonus) + ") of this character\'s current [Initiative|Concept.Initiative] as a bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense]"),
				});
			}

			if (this.m.FractionPerEmptyTile != 0.0)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizePct(this.m.FractionPerEmptyTile) + " (" + ::MSU.Text.colorPositive(bonusPerTile) + ") of this character\'s current [Initiative|Concept.Initiative] as a bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] for every adjacent empty tile."),
				});
			}
		}

		return ret;
	}

	// private
	q.calculateBonus <- function( _emptyTilesOverwrite = null )
	{
		local combinedFraction = this.m.BaseFraction;

		if (_emptyTilesOverwrite == null)
		{
			if (this.getContainer().getActor().isPlacedOnMap())
			{
				local myTile = this.getContainer().getActor().getTile();
				for (local i = 0; i < 6; ++i)
				{
					if (!myTile.hasNextTile(i)) continue;

					if (myTile.getNextTile(i).IsEmpty)
					{
						combinedFraction += this.m.FractionPerEmptyTile;
					}
				}
			}
		}
		else
		{
			combinedFraction += (_emptyTilesOverwrite * this.m.FractionPerEmptyTile);
		}

		local defenseValue = ::Math.floor(this.getContainer().getActor().getInitiative() * combinedFraction);
		return ::Math.max(0, defenseValue);
	}
});
