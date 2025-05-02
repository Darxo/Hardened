::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Vanilla Fix: Overwrite, because Vanilla assumes that if the actor isPlacedOnMap, that then the TurnSequenceBar exists
	// 	That however is not the case during a very small window after combat. If a player update happens during that window, then we get errors
	//	In Vanilla that never happens. But in Hardened we restore equipped items during exactly this window, causing such errors, if not for this fix
	q.setDirty = @() function( _value )
	{
		if (!this.m.IsAlive || this.m.IsDying) return;

		this.updateOverlay();
		this.m.ContentID = ::Math.rand() + ::Math.rand();

		if (this.isPlacedOnMap() && ::Tactical.TurnSequenceBar != null)	// The != null check is new, compared to vanillas implementation
		{
			if (this.m.IsActingEachTurn && ::Tactical.TurnSequenceBar.getActiveEntity() == this)
			{
				this.m.IsDirty = _value;
			}
			else if (_value)
			{
				::Tactical.TurnSequenceBar.updateEntity(this.getID());
				this.m.IsDirty = false;
			}
		}
		else
		{
			this.m.IsDirty = true;
		}
	}

	// Overwrite because we don't want the Vanilla way of calculating
	q.getFatigueMax = @() function()
	{
		return this.getStamina();
	}

	// Overwrite because we don't want the Vanilla way of calculating
	// Changes:
	// 	- Weight now affects your Initiative AFTER multipliers (instead of before)
	// 	- Effects, which lower your Stamina below your BaseStamina no longer lower your Initiative
	q.getInitiative = @() function()
	{
		local initiative = this.m.CurrentProperties.getInitiative();	// This includes base initiative, modifier and multiplier
		initiative -= this.getFatigue() * this.m.CurrentProperties.FatigueToInitiativeRate;		// Subtract Accumulated Fatigue from Initiative
		initiative += this.getInitiativeModifierFromWeight();	// Subtract Weight from Initiative
		return ::Math.round(initiative);
	}
});
