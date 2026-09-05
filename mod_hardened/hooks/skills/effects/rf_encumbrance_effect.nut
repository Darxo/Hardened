::Hardened.HooksMod.hook("scripts/skills/effects/rf_encumbrance_effect", function(q) {
	q.m.HD_EncumbranceLevelMax <- 4;
	q.m.HD_EncumbranceMinWeight <- 30;
	q.m.HD_EncumbranceWeightForLevel <- 20;		// This effect has 1 Level for every this much Weight (full) above HD_EncumbranceMinWeight
	q.m.HD_TravelFatiguePerLevel <- 1;		// Travel Fatigue modifier per Level

	q.create = @(__original) function()
	{
		__original();
		// Overwrite, because we remove mention of the 20 weight threshold and explicit mention of heavy armor as the cause for encumbrance
		this.m.Description = "This character is carrying too much weight!";
	}

	q.getName = @(__original) function()
	{
		return this.skill.getName() + " (x" + this.getEncumbranceLevel() + ")";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")
			{
				// Replace the reforged tooltip
				entry.text = ::Reforged.Mod.Tooltips.parseString("[$ $|Skill+rf_encumbrance_effect] Level: " + ::MSU.Text.colorPositive(this.getEncumbranceLevel()) + "/" + ::MSU.Text.colorNeutral(this.m.HD_EncumbranceLevelMax));
				break;
			}
		}

		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bag.png",
				text = ::Reforged.Mod.Tooltips.parseString("Have " + ::MSU.Text.colorNeutral(1) + " Level of Encumbrance for every " + ::MSU.Text.colorNeutral(this.m.HD_EncumbranceWeightForLevel) + " [$ $|Concept.Weight] above " + ::MSU.Text.colorNeutral(this.m.HD_EncumbranceMinWeight)),
			});

			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Travelling costs " + ::MSU.Text.colorizeValue(this.m.HD_TravelFatiguePerLevel, {AddSign = true, InvertColor = true}) + " [$ $|Concept.Fatigue] per Level"),
			});
		}

		if (this.getEncumbranceLevel() > 0)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Previous Level at " + ::MSU.Text.colorPositive((this.getRequiredWeightForLevel(this.getEncumbranceLevel()) - 1)) + " [$ $|Concept.Weight]"),
			});
		}

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/warning.png",	// We use the warning icon only so that this information is sorted to the bottom between the other warnings
			text = ::Reforged.Mod.Tooltips.parseString("Current [$ $|Concept.Weight]: " + ::MSU.Text.colorNeutral(this.getContainer().getActor().getItems().getWeight())),
		});

		if (this.getEncumbranceLevel() < this.m.HD_EncumbranceLevelMax)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Next Level at " + ::MSU.Text.colorNegative(this.getRequiredWeightForLevel(this.getEncumbranceLevel() + 1)) + " [$ $|Concept.Weight]"),
			});
		}

		return ret;
	}

	// Overwrite, because we any check for a weight threshold
	q.getEncumbranceLevel = @() function()
	{
		local totalWeight = this.getContainer().getActor().getItems().getWeight();
		totalWeight -= this.m.HD_EncumbranceMinWeight;

		local level = 0;
		while (totalWeight >= this.m.HD_EncumbranceWeightForLevel)
		{
			totalWeight -= this.m.HD_EncumbranceWeightForLevel;
			++level;
		}

		return ::Math.min(level, this.m.HD_EncumbranceLevelMax);
	}

	q.getMovementFatigueCostModifier = @() function( _encumbranceLevel )
	{
		return _encumbranceLevel * this.m.HD_TravelFatiguePerLevel;
	}

	q.getFatigueOnTurnStart = @() function( _encumbranceLevel )
	{
		return 0;
	}

// New Functions
	q.getRequiredWeightForLevel <- function( _level )
	{
		local nextThreshold = this.m.HD_EncumbranceMinWeight + (this.m.HD_EncumbranceWeightForLevel * _level);
		return nextThreshold;
	}
});
