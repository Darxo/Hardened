::Hardened.HooksMod.hook("scripts/entity/tactical/player", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		// Apply difficulty-specific damage multiplier
		this.m.BaseProperties.DamageReceivedRegularMult *= ::Const.Difficulty.getPlayerDamageReceivedMult();

		this.getSkills().add(::new("scripts/skills/actives/hd_retreat_skill"));
	}

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
		local baseProperties = this.getBaseProperties();

		foreach (attributeName, attribute in ::Const.Attributes)
		{
			if (attribute == ::Const.Attributes.COUNT) continue;
			if (this.m.Talents[attribute] != 2) continue;	// We only adjust attributes that have 2 stars

			local levelUpsRemaining = ::Math.max(::Const.XP.MaxLevelWithPerkpoints - this.getLevel() + this.getLevelUps(), 0);
			local attributeValue = attributeName == "Fatigue" ? baseProperties["Stamina"] : baseProperties[attributeName]; // Thank you Overhype

			ret[attribute] = [
				attributeValue + (::Const.AttributesLevelUp[attribute].Min + 1) * levelUpsRemaining,
				attributeValue + (::Const.AttributesLevelUp[attribute].Max + 1) * levelUpsRemaining
			];
		}

		return ret;
	}

	// Todo: remove this code, once some time has passed and enough player had chance to migrate
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		// For a brief period, we hijacked these perks
		// So to improve backwards compatibility, we transform old instances of those perks into new instances including changes to the perk tree
		// From the player pov nothing should change
		::Hardened.util.migratePerk(this, "perk.rf_through_the_ranks", "perk.hd_scout");
	}
});
