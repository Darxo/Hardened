::Hardened.HooksMod.hook("scripts/skills/racial/unhold_racial", function(q) {
	// Public
	q.m.HD_RecoveredHitpointPct <- 0.15;	// This percentage of maximum Hitpoints is recovered at the start of each turn
	q.m.HD_NegativeStatusEffectDurationModifier <- -1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/health.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("At the start of each [turn|Concept.Turn], recover " + ::MSU.Text.colorizePct(this.m.HD_RecoveredHitpointPct) + " of Maximum [Hitpoints|Concept.Hitpoints]");
				break;
			}
		}

		if (this.m.HD_NegativeStatusEffectDurationModifier != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Negative [status effects|Concept.StatusEffect] on you last " + ::MSU.Text.colorizeValue(this.m.HD_NegativeStatusEffectDurationModifier, {InvertColor = true, AddSign = true}) + " [turn(s)|Concept.Turn] (to a minimum of 1)"),
			});
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.NegativeStatusEffectDuration += this.m.HD_NegativeStatusEffectDurationModifier;
	}

	// Overwrite, because we re-implement the hard-coded vanilla hitpoint recovery.
	// As a consequence we also need to re-implement the reforged change
	q.onTurnStart = @() function()
	{
		local actor = this.getContainer().getActor();

		local hitpointsToRecover = ::Math.floor(actor.getHitpointsMax() * this.m.HD_RecoveredHitpointPct);
		local actuallyRecoveredHitpoints = actor.recoverHitpoints(hitpointsToRecover, !actor.isHiddenToPlayer());
		if (actuallyRecoveredHitpoints > 0 && !actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			}
		}

		// Copy of Reforged Bleeding mitigation
		local bleed = this.getContainer().getSkillByID("effects.bleeding");
		if (bleed != null)
		{
			bleed.m.Stacks /= 2;
			if (bleed.m.Stacks == 0)
				bleed.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " had some of his bleeding wounds close");
		}
	}
});
