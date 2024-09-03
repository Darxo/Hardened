::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.m.HardenedShieldConditionMax <- null;	// Condition this item would have in hardened
	q.m.ReforgedShieldConditionMax <- null;	// Condition this item would have in reforged
	q.m.ShieldConditionMult <- 1.0;	// Bonus Condition rolled by named items

	q.applyShieldDamage = @(__original) function( _damage, _playHitSound = true )
	{
		_damage = ::Math.max(1, ::Math.ceil(_damage * this.getContainer().getActor().getCurrentProperties().ShieldDamageReceivedMult));

		return __original(_damage, _playHitSound);
	}

// Reforged Functions
	q.RF_getDefenseMult = @() function()
	{
		return 1.0;	// Fatigue no longer affects the shield defense in any way
	}

// New Functions
	// Save the reforged shield condition
	// Calculate the multiplier on how well this named shields condiiton rolled
	// This can be called twice per item (curing create() and durin deSerialize()) so it must be robust against that
	q.recordReforgedCondition <- function( _named = false )
	{
		this.m.ReforgedShieldConditionMax = this.m.ConditionMax;
	}

	// Only used during serialization and deserialization
	// Convert the shield condition values to the unit system of Hardened
	q.convertToHardened <- function()
	{
		local conditionFraction = this.m.Condition / this.m.ConditionMax;

		// Revert the Reforged shield condition changes
		this.m.ConditionMax = ::Math.round(this.m.HardenedShieldConditionMax * this.m.ShieldConditionMult);

		// Scale the condition relative to what it was under reforged
		// This must be rounded very little, otherwise we get float rounding errors which turn a 100 into a 99.99999
		this.m.Condition = ::Hardened.controlledRound(conditionFraction * this.m.ConditionMax);
	}

	// Only used during serialization
	// Convert the shield condition values back to the unit system of Reforged so that this remains savegame compatible, when switching mods
	q.convertToReforged <- function()
	{
		if (this.m.ReforgedShieldConditionMax != null)	// Some shields might snuck past the reforged condition grab
		{
			local conditionFraction = this.m.Condition / this.m.ConditionMax;
			this.m.ConditionMax = ::Math.round(this.m.ReforgedShieldConditionMax * this.m.ShieldConditionMult);

			// Scale the condition relative to what it was under hardened
			// This must be rounded very little, otherwise we get float rounding errors which turn a 100 into a 99.99999
			this.m.Condition = this.m.Condition = ::Hardened.controlledRound(conditionFraction * this.m.ConditionMax);
		}
	}
});
