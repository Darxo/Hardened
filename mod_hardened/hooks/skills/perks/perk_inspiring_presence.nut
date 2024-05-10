::Hardened.HooksMod.hook("scripts/skills/perks/perk_inspiring_presence", function(q) {
	q.m.IsEnabledForThisCombat <- false;
	q.m.BonusActionPoints <- 3;

	q.getTooltip = @() function()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the start of each round any adjacent ally with less [Resolve|Concept.Bravery] gains " + ::MSU.Text.colorizeValue(this.m.BonusActionPoints) + " [Action Points|Concept.ActionPoints] if they are adjacent to an enemy, or have an adjacent ally who is adjacent to an enemy."),
		});

		return tooltip;
	}

	// Overwrite the vanilla function to nullify its effects. Reverting the effect of making allies confident is annoying
	q.onCombatStarted = @() function()
	{
		this.skill.onCombatStarted();

		this.m.IsEnabledForThisCombat = false;	// That way we don't have to reset this value onCombatFinished or anywhere else

		local actor = this.getContainer().getActor();
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()))
		{
			if (ally.getID() == actor.getID()) continue;	// We don't check ourself

			local inspiringPresencePerk = ally.getSkills().getSkillByID(this.getID());
			if (inspiringPresencePerk == null) continue;					// Only other brothers with this exact perk may prevent our perk from going active

			if (inspiringPresencePerk.isEnabled()) return;
			if (ally.getCurrentProperties().getBravery() > actor.getCurrentProperties().getBravery()) return;	// Another Inspire brother has more resolve than us
		}

		this.m.IsEnabledForThisCombat = true;
	}

	q.onNewRound = @(__original) function()
	{
		__original();
		if (!this.isEnabled()) return;

		local actor = this.getContainer().getActor();
		local allies = ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true);
		foreach (ally in allies)
		{
			if (ally.getCurrentProperties().getBravery() > actor.getCurrentProperties().getBravery()) continue;
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;

			local adjacentEnemies = ::Tactical.Entities.getHostileActors(ally.getFaction(), ally.getTile(), 1, true);
			if (adjacentEnemies.len() != 0)	// We found adjacent enemies
			{
				local skill = ::new("scripts/skills/effects/hd_inspiring_presence_buff_effect");
				skill.m.BonusActionPoints = this.m.BonusActionPoints;
				ally.getSkills().add(skill);
				continue;
			}

			// We didn't find directly adjacent enemies
			local grandAllies = ::Tactical.Entities.getFactionActors(ally.getFaction(), ally.getTile(), 1, true);
			foreach (grandAlly in grandAllies)
			{
				local adjacentGrandEnemies = ::Tactical.Entities.getHostileActors(grandAlly.getFaction(), grandAlly.getTile(), 1, true);
				if (adjacentGrandEnemies.len() != 0)	// We found enemies 2 tiles away with an ally in between
				{
					local skill = ::new("scripts/skills/effects/hd_inspiring_presence_buff_effect");
					skill.m.BonusActionPoints = this.m.BonusActionPoints;
					ally.getSkills().add(skill);
					break;
				}
			}
		}
	}

	q.isEnabled = @() function()
	{
		if (this.m.IsForceEnabled) return true;

		return this.m.IsEnabledForThisCombat;
	}
});
