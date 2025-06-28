::Hardened.HooksMod.hook("scripts/skills/injury/injury", function(q) {
	q.m.AffectedBodyPart <- -1;		// -1 means no location is specified. So any body part check will fail

	// Private
	q.m.RoundAdded <- 0;

	q.getName = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret += " (Fresh)";
		}

		return ret;
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/injury/injury", function(q) {
	q.addTooltipHint = @(__original) function( _tooltip )
	{
		// We switcheroo the medicine, to be always enough for one healing, so that vanilla always displays the amount of days left for healing
		local oldMedicine = ::World.Assets.getMedicine();
		::World.Assets.setMedicine(::Const.World.Assets.MedicinePerInjuryDay);
		__original(_tooltip);
		::World.Assets.setMedicine(oldMedicine);

		if (!this.isFresh() && ::World.Assets.getMedicine() == 0)
		{
			_tooltip.push({
				id = 20,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Has only a " + ::MSU.Text.colorPositive("50%") + " chance to improve each day, because you have no medical supplies",
			});
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Was received on [Round|Concept.Round] " + ::MSU.Text.colorPositive(this.m.RoundAdded)),
			});
		}

		return ret;
	}

	// We need to implement this as hookTree, because some injuries might overwrite this without calling the base function
	q.onAdded = @(__original) function()
	{
		__original();
		if (::Tactical.isActive())
		{
			this.m.RoundAdded = ::Tactical.TurnSequenceBar.getCurrentRound();
		}
		else
		{
			this.m.IsFresh = false;
		}
	}

	q.onNewDay = @(__original) function()
	{
		// Feature: Injuries now have a 50% chance to improve each day, if you dont have enough medicine
		local oldIsHealingMentioned = this.m.IsHealingMentioned;
		if (::World.Assets.getMedicine() < ::Const.World.Assets.MedicinePerInjuryDay)
		{
			// We make it so that no matter how little medicine you have, it will always be enough for at least one healing
			if (::World.Assets.getMedicine() > 0)
			{
				::World.Assets.setMedicine(0);
				this.m.IsHealingMentioned = false;
			}
			else if (::Math.rand(1, 100) > 50)	// If the player really has 0 medicine left, then the chance is only 50%
			{
				this.m.IsHealingMentioned = false;
			}
		}
		__original();
		this.m.IsHealingMentioned = oldIsHealingMentioned;
	}
});
