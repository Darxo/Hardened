::Hardened.HooksMod.hook("scripts/skills/racial/trickster_god_racial", function(q) {
// Public
	q.m.HD_RecoveredHitpointPct <- 0.05;	// Vanilla: 0.06
	q.m.HD_BleedStacksRemoved <- 1;
	q.m.HD_HollenhundSpawnsOnCombatStart <- 3;

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

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the start of each battle, summon " + ::MSU.Text.colorPositive(this.m.HD_HollenhundSpawnsOnCombatStart) + ::MSU.Text.colorNeutral(" Hollenhund")),
		});

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to [$ $|Skill+chilled_effect] and [$ $|Skill+rf_frostbound_effect]"),
		});

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		this.getContainer().getActor().getBaseProperties().HD_ImmuneToChilled = true;
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

	q.onSpawned = @(__original) function()
	{
		__original();

		local dogsToSummon = this.m.HD_HollenhundSpawnsOnCombatStart;

		local actor = this.getContainer().getActor();
		foreach (tile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (!tile.IsEmpty) continue;

			local entity = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/hd_trickster_hollenhund", tile.Coords);
			entity.setFaction(actor.getFaction());

			--dogsToSummon;
			if (dogsToSummon <= 0) return;
		}
	}
});
