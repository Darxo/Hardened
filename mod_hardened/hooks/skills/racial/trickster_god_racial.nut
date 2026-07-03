::Hardened.HooksMod.hook("scripts/skills/racial/trickster_god_racial", function(q) {
// Public
	q.m.HD_RecoveredHitpointPct <- 0.05;	// Vanilla: 0.06
	q.m.HD_BleedStacksRemoved <- 1;

	q.create = @(__original) function()
	{
		__original();

		this.m.Name = "Ijirok";
		this.m.IsHidden = false;
		this.m.Type = this.m.Type | ::Const.SkillType.StatusEffect;		// So that this displays a tooltip
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the start of each [turn|Concept.Turn], recover " + ::MSU.Text.colorizePct(this.m.HD_RecoveredHitpointPct) + " of Maximum [Hitpoints|Concept.Hitpoints]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the start of each [turn|Concept.Turn], remove " + ::MSU.Text.colorPositive(this.m.HD_BleedStacksRemoved) + " stacks of [$ $|Skill+bleeding_effect]"),
		});

		return ret;
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

		local bleed = this.getContainer().getSkillByID("effects.bleeding");
		if (bleed != null)
		{
			bleed.m.Stacks -= this.m.HD_BleedStacksRemoved;
			if (bleed.m.Stacks <= 0) bleed.removeSelf();

			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " loses " + ::MSU.Text.colorPositive(this.m.HD_BleedStacksRemoved) + " bleed stacks");
			}
		}
	}
});
