::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.m.HardenedShieldConditionMax <- null;	// Condition this item would have in hardened
	q.m.ReforgedShieldConditionMax <- null;	// Condition this item would have in reforged
	q.m.ShieldConditionMult <- 1.0;	// Bonus Condition rolled by named items

	// Hook, in order to implement the new character properties ShieldDamageMult and ShieldDamageReceivedMult
	// The information to calculate those are fetched at the start of `function use` of `skill.nut` and saved in a global variable
	// Known Issues:
	// - Shield damage which is generated outside of skill use (e.g. tile effects, or passive skills) will be use the last used Skill for calculation
	q.applyShieldDamage = @(__original) function( _damage, _playHitSound = true )
	{
		local receiver = this.getContainer().getActor();
		local attacker = null;
		local attackerProps = null;
		local defenderProps = null;
		local skill = ::Hardened.Temp.LastUsedSkill;
		if (!::MSU.isNull(skill) && !::MSU.isNull(::Hardened.Temp.LastUsedSkillOwner))
		{
			attacker = ::Hardened.Temp.LastUsedSkillOwner;

			attackerProps = attacker.getSkills().buildPropertiesForUse(skill, receiver);
			defenderProps = receiver.getSkills().buildPropertiesForDefense(attacker, skill);
		}
		else	// at least apply the defender values fetched from his CurrentProperties
		{
			defenderProps = receiver.getCurrentProperties();
		}

		// Event: Give skills a last chance to do some changes or calculations, before the shield gets damaged
		receiver.getSkills().onBeforeShieldDamageReceived( _damage, this, defenderProps, attacker, attackerProps, skill );

		// Do final damage adjustments until we pass it off to the vanilla function
		if (attackerProps != null) _damage *= attackerProps.ShieldDamageMult;
		if (defenderProps != null) _damage *= defenderProps.ShieldDamageReceivedMult;
		_damage = ::Math.max(1, ::Math.round(_damage));		// Vanilla Mechanic: damage is rounded and must always be at least 1

		local conditionBefore = this.getCondition();
		__original(_damage, _playHitSound);

		// Event:
		receiver.getSkills().onAfterShieldDamageReceived( _damage, conditionBefore - this.getCondition(), this, attacker, skill );
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
	q.recordReforgedCondition <- function()
	{
		this.m.ReforgedShieldConditionMax = this.m.ConditionMax;
	}

	// Only used during serialization and deserialization
	// Convert the shield condition values to the unit system of Hardened
	q.convertToHardened <- function()
	{
		local conditionFraction = (this.m.Condition * 1.0) / this.m.ConditionMax;

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
			local conditionFraction = (this.m.Condition * 1.0) / this.m.ConditionMax;

			// Apply the Reforged shield condition changes again
			this.m.ConditionMax = ::Math.round(this.m.ReforgedShieldConditionMax * this.m.ShieldConditionMult);

			// Scale the condition relative to what it was under hardened
			// This must be rounded very little, otherwise we get float rounding errors which turn a 100 into a 99.99999
			this.m.Condition = ::Hardened.controlledRound(conditionFraction * this.m.ConditionMax);
		}
	}
});

::Hardened.HooksMod.hookTree("scripts/items/shields/shield", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We hook onPaintInCompanyColors here, because it is not present on all shields and we can't do the following check during regular hooking
		if ("onPaintInCompanyColors" in this)
		{
			local oldOnPaintInCompanyColors = this.onPaintInCompanyColors;
			this.onPaintInCompanyColors = function()
			{
				oldOnPaintInCompanyColors();
				// We make sure this only happens for player as some mods might use onPaintInCompanyColors to color enemies shields
				if (this.isEquipped() && ::MSU.isKindOf(this.getContainer().getActor(), "player"))
				{
					::World.Statistics.getFlags().increment("PaintUsedOnShields");
				}
			}
		}
	}
});
