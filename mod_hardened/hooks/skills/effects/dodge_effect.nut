::Hardened.HooksMod.hook("scripts/skills/effects/dodge_effect", function(q) {
	q.m.BaseMultiplier <- 5.0;
	q.m.MultiplierPerEmptyTile <- 2.5;

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
					text = ::MSU.Text.colorizeValue(defenseValue) + " Melee Defense"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = ::MSU.Text.colorizeValue(defenseValue) + " Ranged Defense"
				}
			]);
		}
		else
		{
			local minValue = this.calculateBonus(0);
			local maxValue = this.calculateBonus(6);
			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "Grants between " + ::MSU.Text.colorizeValue(minValue) + " and " + ::MSU.Text.colorizeValue(maxValue) + " Melee Defense during combat"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "Grants between " + ::MSU.Text.colorizeValue(minValue) + " and " + ::MSU.Text.colorizeValue(maxValue) + " Ranged Defense during combat"
				}
			])
		}

		return ret;
	}

	// new function to have a variable description text
	q.getDescription <- function()
	{
		local ret = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorPositive(this.m.BaseMultiplier + "%") + " + an additional " + ::MSU.Text.colorPositive(this.m.MultiplierPerEmptyTile + "%") + " per empty adjacent tile of this character\'s current [Initiative|Concept.Initiative] as a bonus to Melee- and Ranged Defense.");
		return ret;
	}

	// private
	q.calculateBonus <- function( _emptyTilesOverwrite = null )
	{
		local combinedMultiplier = this.m.BaseMultiplier;

		if (_emptyTilesOverwrite == null)
		{
			if (this.getContainer().getActor().isPlacedOnMap())
			{
				local myTile = this.getContainer().getActor().getTile();
				for( local i = 0; i < 6; i = ++i )
				{
					if (!myTile.hasNextTile(i)) continue;

					if (myTile.getNextTile(i).IsEmpty)
					{
						combinedMultiplier += this.m.MultiplierPerEmptyTile;
					}
				}
			}
		}
		else
		{
			combinedMultiplier += (_emptyTilesOverwrite * this.m.MultiplierPerEmptyTile);
		}

		local defenseValue = ::Math.floor(this.getContainer().getActor().getInitiative() * (combinedMultiplier / 100.0));
		return ::Math.max(0, defenseValue);
	}
});
