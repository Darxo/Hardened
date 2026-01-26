::Hardened.HooksMod.hook("scripts/entity/tactical/player", function(q) {
	// Private
	// Is set to true, when any hostile is discovered, while we have the "Cancel on Hostile Discovery" setting active
	// Is set to true, when any ally is discovered, while we have the "Cancel on Ally Discovery" setting active
	q.m.HD_HasDiscoveredSomething <- false;

	q.m.HD_LastSteppedTile <- null;	// Reference to the last tile that we virtually (not really) stepped on in a chain of onMovementStep. Is set to null on onMOvementFinish

	q.create = @(__original) function()
	{
		__original();

	// Hardened
		this.m.HD_XPValueBase = 50;				// Vanilla: 70
		this.m.HD_XPValuePerRegularLevel = 50;		// Vanilla: 30
		this.m.HD_XPValuePerVeteranLevel = 10;		// Vanilla: 30
	}

	q.improveMood = @(__original) function( _a = 1.0, _reason = "" )
	{
		local moodCheck = this.getSkills().getSkillByID("special.mood_check");
		if (moodCheck != null)
		{
			// Feat: Allow the mood_check skill to influence mood changes
			_a = moodCheck.HD_getNewMoodChange(_a);
			if (_a == 0.0) return;
		}

		if (_reason != "")
		{
			// Feat: Display the accurate mood change in brackets behind the reason
			_reason += format(" (%s)", ::MSU.Text.colorizeValue(_a, {AddSign = true}));
		}

		__original(_a, _reason);
	}

	q.worsenMood = @(__original) function( _a = 1.0, _reason = "" )
	{
		local moodCheck = this.getSkills().getSkillByID("special.mood_check");
		if (moodCheck != null)
		{
			// Feat: Allow the mood_check skill to influence mood changes
			// HD_getNewMoodChange requires positive numbers for positive changes and negative numbers for negative changes
			// This function however expects positive numbers for negative changes, so we need to invert it, before passing it to the function
			// And we need to invert the result too (which would have the same sign as the input), so it has the same sign as the input again
			_a = -moodCheck.HD_getNewMoodChange(-1 * _a);
			if (_a == 0.0) return;
		}

		if (_reason != "")
		{
			// Feat: Display the accurate mood change in brackets behind the reason
			_reason += format(" (%s)", ::MSU.Text.colorizeValue(-1 * _a, {AddSign = true}));
		}

		__original(_a, _reason);
	}

	q.onInit = @(__original) function()
	{
		__original();

		// Apply difficulty-specific damage multiplier
		this.m.BaseProperties.DamageReceivedTotalMult *= ::Const.Difficulty.getPlayerDamageReceivedMult();

		this.getSkills().add(::new("scripts/skills/actives/hd_retreat_skill"));
	}

	q.addXP = @(__original) { function addXP( _xp, _scale = true )
	{
		if (::Reforged.Config.XPOverride) return;

		// Temporary buff to vanilla drill sergeant until our Retinue Rework
		if (("State" in ::World) && ::World.State != null && _scale && ::World.Retinue.hasFollower("follower.drill_sergeant"))
		{
			local reforgedXPMult = ::Math.maxf(1.0, 1.1666 - 0.0166 * (this.m.Level - 1));	// 1.166666 is the exact multiplier to make a 1.2 multiplier into 1.4
			_xp /= reforgedXPMult;	// So if we divide _xp by it, we land by at the 1.2 mult from vanilla
		}

		// Vanilla Fix: Prevent Non-Scaling XP being scaled by GlobalXPVeteranLevelMult or the player specific XPGainMult
		local oldGlobalXPVeteranLevelMult = ::Const.Combat.GlobalXPVeteranLevelMult;
		local oldCurrentXPGainMult = this.getCurrentProperties().XPGainMult;
		if (!_scale)
		{
			::Const.Combat.GlobalXPVeteranLevelMult = 1.0;
			this.getCurrentProperties().XPGainMult = 1.0;
		}
		__original(_xp, _scale);
		::Const.Combat.GlobalXPVeteranLevelMult = oldGlobalXPVeteranLevelMult;
		this.getCurrentProperties().XPGainMult = oldCurrentXPGainMult;
	}}.addXP;

	q.fillAttributeLevelUpValues = @(__original) function( _amount, _maxOnly = false, _minOnly = false )
	{
		__original(_amount, _maxOnly, _minOnly);

		if (_amount == 0) return;
		if (_maxOnly || _minOnly) return;	// Stars do not influence these level-ups so we don't need to adjust anything

		for (local i = 0; i != ::Const.Attributes.COUNT; i++)
		{
			if (this.m.Talents[i] != 2) continue;	// We only change attributes with 2 stars

			for (local j = 0; j < _amount; j++)
			{
				// We re-calculate these entries because Reforged already tamperes with them and we currently can't revert those
				this.m.Attributes[i][j] = ::Math.rand(::Const.AttributesLevelUp[i].Min + 1, ::Const.AttributesLevelUp[i].Max + 1);
			}
		}
	}

	q.getProjectedAttributes = @(__original) function()
	{
		local ret = __original();

		local properties = this.getBaseProperties().getClone();
		// Apply the effects from all traits and permanent injuries. Same as what Reforged does
		local wasUpdating = this.getSkills().m.IsUpdating;
		this.getSkills().m.IsUpdating = true;
		foreach (s in this.getSkills().getSkillsByFunction(@( _skill ) _skill.isType(::Const.SkillType.Trait) || _skill.isType(::Const.SkillType.PermanentInjury)))
		{
			s.onUpdate(properties);
		}
		this.getSkills().m.IsUpdating = wasUpdating;

		foreach (attributeName, attribute in ::Const.Attributes)
		{
			if (attribute == ::Const.Attributes.COUNT) continue;
			if (this.m.Talents[attribute] != 2) continue;	// We only adjust attributes that have 2 stars

			local levelUpsRemaining = ::Math.max(::Const.XP.MaxLevelWithPerkpoints - this.getLevel() + this.getLevelUps(), 0);
			local attributeValue = attributeName == "Fatigue" ? properties["Stamina"] : properties[attributeName]; // Thank you Overhype

			ret[attribute] = [
				attributeValue + (::Const.AttributesLevelUp[attribute].Min + 1) * levelUpsRemaining,
				attributeValue + (::Const.AttributesLevelUp[attribute].Max + 1) * levelUpsRemaining
			];
		}

		return ret;
	}

	q.isReallyKilled = @(__original) function( _fatalityType )
	{
		local ret = __original(_fatalityType);

		// Feat: If any player character dies during combat, a simple death animation plays on their corpse
		if (ret)
		{
			local tile = this.getTile();

			foreach (effect in ::Const.Tactical.HD_PlayerDeath)
			{
				::Tactical.spawnParticleEffect(false, effect.Brushes, tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
			}
		}

		return ret;
	}

	q.onMovementFinish = @(__original) function( _tile )
	{
		__original(_tile);
		if (this.isPlayerControlled())
		{
			this.m.HD_LastSteppedTile = null;	// We finished the movement, so we now reset the value of this variable
		}
	}

	// MSU hooks this function from actor.nut aswell, but our hook will trigger earlier than theirs
	q.onMovementStep = @(__original) function( _tile, _levelDifference )
	{
		// Goal:
		// 	1. We no longer reveal tiles at the destination of a Step, before we are actually there. Instead we reveal the tiles at the position we were virtually at
		//	2. When we reveal something notable, we abort any further movement

		if (!this.isPlayerControlled()) return __original(_tile, _levelDifference);	// Some player character might briefly be autocontrolled or have switched factions

		// Switcheroo to prevent the vanilla implementation from calling updateVisibility for the next tile, before we are actually there
		local oldVision = 1;
		local oldFaction = 1;
		local oldUpdateVisibility = this.updateVisibility;
		this.updateVisibility = function( _tile, _vision, _faction ) {
			oldVision = _vision;
			oldFaction = _faction;
		};

		local ret = __original(_tile, _levelDifference);	// onMovementStep for skills will be triggered by this call

		this.updateVisibility = oldUpdateVisibility;

		if (ret)
		{
			if (this.m.HD_LastSteppedTile != null)
			{
				this.m.HD_HasDiscoveredSomething = false;
				this.updateVisibility(this.m.HD_LastSteppedTile, oldVision, oldFaction);	// We update the visibility at the current virtual tile we are standing at
				if (this.m.HD_HasDiscoveredSomething && this.m.HD_LastSteppedTile.IsEmpty)	// we discovered someone, while virtually standing on an empty tile
				{
					this.onMovementUndo( _tile, _levelDifference );	// We revert the movement cost
					return false;	// and stop our movement immediately
				}
			}

			this.m.HD_LastSteppedTile = _tile;
		}

		return ret;
	}

// Modular Vanilla Functions
	q.MV_getStrengthRaw = @() function()
	{
		local regularLevelUps = ::Math.clamp(getLevel(), 1, ::Const.XP.MaxLevelWithPerkpoints) - 1;		// -1 because the first level does not count
		local veteranLevelUps =	::Math.clamp(getLevel(), 0, ::Const.XP.MaxLevelWithPerkpoints);

		local strength = 10;	// Arbitruary base value just for being a meat bag on the battle field
		strength *= ::Math.pow(1.2, regularLevelUps);	// Every Regular Level increases the strength by 20% (Perk + Levelup)
		strength *= ::Math.pow(1.03, veteranLevelUps);	// Every Veteran Level increases our strength by 3% (Veteran Levelup), so that 6 Veteran Perks roughly equal to one Regular Level

		return strength;
	}

// Reforged Functions
	q.getProjectedAttributes = @(__original) function()
	{
		// Fix Reforged Projection: Reforged uses actor.getStamina as basis for projected attributes, but that function always includes Weight
		// As a solution we briefly switcheroo how that function works by redirecting it into the getStamina from currentProperties
		local oldGetStamina = this.getStamina;
		this.getStamina = function() { return this.getCurrentProperties().getStamina(); }

		local ret =  __original();

		this.getStamina = oldGetStamina;

		return ret;
	}
});
