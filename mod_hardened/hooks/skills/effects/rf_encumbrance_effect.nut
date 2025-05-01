::Hardened.HooksMod.hook("scripts/skills/effects/rf_encumbrance_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// Overwrite, because we remove mention of the 20 weight threshold and explicit mention of heavy armor as the cause for encumbrance
		this.m.Description = "This character has too much weight!\nEncumbrance has 4 levels and it increases when the Stamina after gear is less than 50, 40, 30, 20.";
	}

	// Overwrite, because we any check for a weight threshold
	q.getEncumbranceLevel = @() function()
	{
		local stamina = this.getContainer().getActor().getFatigueMax();
		if (stamina < 20)
		{
			return 4;
		}
		else if (stamina < 30)
		{
			return 3;
		}
		else if (stamina < 40)
		{
			return 2;
		}
		else if (stamina < 50)
		{
			return 1;
		}

		return 0;
	}

	q.getMovementFatigueCostModifier = @() function( _encumbranceLevel )
	{
		return _encumbranceLevel;
	}

	q.getFatigueOnTurnStart = @() function( _encumbranceLevel )
	{
		return 0;
	}
});
