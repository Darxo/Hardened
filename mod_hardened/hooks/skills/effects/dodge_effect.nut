::mods_hookExactClass("skills/effects/dodge_effect", function (o) {
	o.m.BaseMultiplier <- 5.0;
	o.m.MultiplierPerEmptyTile <- 2.5;

	// Overwrite of Vanilla function to stop its effects and apply our own
	o.onAfterUpdate = function( _properties )
	{
		local defenseValue = this.calculateBonus();
		_properties.MeleeDefense += defenseValue;
		_properties.RangedDefense += defenseValue;
	}

	// Overwrite of Vanilla function to stop its effects and apply our own
	o.getTooltip = function()
	{
		local ret = this.skill.getTooltip();	// Get name and description the way that the base class does it
		local defenseValue = this.calculateBonus();
		if (defenseValue != 0)
		{
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
			])
		}
		return ret;
	}

	// new function to have a variable description text
	o.getDescription <- function()
	{
		local ret = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorGreen(this.m.BaseMultiplier + "%") + " + an additional " + ::MSU.Text.colorGreen(this.m.MultiplierPerEmptyTile + "%") + " per empty adjacent tile of this character\'s current [Initiative|Concept.Initiative] as a bonus to Melee- and Ranged Defense.");
		return ret;
	}

	// private
	o.calculateBonus <- function()
	{
		local combinedMultiplier = this.m.BaseMultiplier;
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

		local defenseValue = ::Math.floor(this.getContainer().getActor().getInitiative() * (combinedMultiplier / 100.0));
		return ::Math.max(0, defenseValue);
	}
});
