::Hardened.HooksMod.hook("scripts/skills/effects/spider_poison_effect", function (q) {
	q.m.HitpointRecoveryMult <- 0.5;
	q.m.DurationInTurns <- 3;

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Poisoned (Spider)";		// Vanilla: Poisoned
		this.m.Description = "This character has a vicious poison running through his veins.";

		this.m.HD_LastsForTurns = this.m.DurationInTurns;
	}

	// Overwrite, because we prefer a static description
	q.getDescription = @() function()
	{
		return this.skill.getDescription();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.HitpointRecoveryMult *= this.m.HitpointRecoveryMult;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/hd_toxic_damage.png",
			text = ::Reforged.Mod.Tooltips.parseString("Once per [round|Concept.Round], when you [wait|Concept.Wait] or end your [turn|Concept.Turn], take " + ::MSU.Text.colorNegative(this.m.Damage) + " Toxic Damage to [Hitpoints|Concept.Hitpoints]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/damage_received.png",
			text = ::Reforged.Mod.Tooltips.parseString("Recover " + ::MSU.Text.colorizeMultWithText(this.m.HitpointRecoveryMult) + " [Hitpoints|Concept.Hitpoints]"),
		});

		return ret;
	}

	// Overwrite, because we no longer support this.m.TurnsLeft and instead utilize this.m.HD_LastsForTurns and this.m.DurationInTurns
	// Reset the duration of this effect to its default duration, as defined in this.m.DurationInTurns
	q.resetTime = @() function()
	{
		this.m.HD_LastsForTurns = ::Math.max(1, this.m.DurationInTurns + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		if (this.getContainer().hasSkill("trait.ailing")) ++this.m.HD_LastsForTurns;
	}

	// Overwrite, because we no longer support this.m.TurnsLeft and instead utilize this.m.HD_LastsForTurns and this.m.DurationInTurns
	q.onAdded = @() function()
	{
		this.resetTime();
	}

	q.applyDamage = @(__original) function()
	{
		local mockObject;
		mockObject = ::Hardened.mockFunction(this.getContainer().getActor(), "onDamageReceived", function( _attacker, _skill, _hitInfo ) {
			// Feat: We turn the miasma damage type into our newly introduced "Toxic" damage type
			_hitInfo.DamageType <- ::Const.Damage.DamageType.Toxic;

			// Feat: We change the damage source to null, as opposed to be the receiver itself
			_attacker = null;

			// We call the original manually, so that our custom _attacker is passed correctly
			mockObject.original(_attacker, _skill, _hitInfo);

			return { done = true, value = null };
		});

		__original();

		mockObject.cleanup();
	}
});
