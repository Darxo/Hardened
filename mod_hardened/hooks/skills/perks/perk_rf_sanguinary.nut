::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_sanguinary", function(q) {
	// Public
	q.m.RecoveredActionPointsMovement <- 3;

	// Private
	q.m.HD_IsMovementBonusGained <- false;

	q.create = @(__original) function()
	{
		__original();
		this.m.MaxUses = 1;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (!this.m.HD_IsMovementBonusGained)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(format("Recover %s [Action Points|Concept.ActionPoints] the next time you move next to an injured enemy during your [turn|Concept.Turn]", ::MSU.Text.colorizeValue(this.m.RecoveredActionPointsMovement))),
			});
		}

		return ret;
	}

	q.isHidden = @(__original) function()
	{
		return __original() && this.m.HD_IsMovementBonusGained;
	}

	q.onMovementFinished = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		if (!this.m.HD_IsMovementBonusGained && this.getInjuredEnemyAmount(actor.getTile()) > 0)
		{
			this.m.HD_IsMovementBonusGained = true;
			actor.recoverActionPoints(this.m.RecoveredActionPointsMovement);
			this.spawnIcon("perk_rf_sanguinary", actor.getTile());
		}
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.HD_IsMovementBonusGained = false;
	}

// New Private Functions
	q.getInjuredEnemyAmount <- function( _tile )
	{
		local adjacentEnemies = ::Tactical.Entities.getHostileActors(this.getContainer().getActor().getFaction(), _tile, 1, true);
		local injuredEnemies = 0;
		foreach (enemy in adjacentEnemies)
		{
			if (enemy.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury))
			{
				injuredEnemies++;
			}
		}
		return injuredEnemies;
	}
});
