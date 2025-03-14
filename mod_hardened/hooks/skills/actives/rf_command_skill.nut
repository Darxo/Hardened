::Hardened.HooksMod.hook("scripts/skills/actives/rf_command_skill", function(q) {
	q.m.CommandBonusPct <- 0.5;		// This percentage of this characters current resolve is added for the morale check on fleeing allies

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Command an ally from your faction to act now!\nCannot be used on stunned allies or those who already ended their turn.";	// Remove mention of fleeing
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::MSU.String.replace(entry.text, "Move the target", "If the target is not fleeing, move it");

				local actualResolveBonus = "";
				if (this.getContainer().getActor().getID() != ::MSU.getDummyPlayer().getID())
				{
					actualResolveBonus = " (" + ::MSU.Text.colorizeValue(this.getCommandBonus(), {AddSign = true}) + ")";
				}

				// We insert a new tooltip line at the first regular position
				ret.insert(index, {
					id = 13,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::Reforged.Mod.Tooltips.parseString(format("If the target is fleeing, trigger a rallying [Morale Check|Concept.Morale] for it with a bonus of %s%s of your [Resolve|Concept.Bravery]", ::MSU.Text.colorizePct(this.m.CommandBonusPct), actualResolveBonus)),
				});
				break;	// Otherwise we enter an infinite loop, where the next object is always id 10
			}
		}

		return ret;
	}

	// Overwrite because we remove the not-fleeing condition
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;

		local target = _targetTile.getEntity();

		if (this.getContainer().getActor().getFaction() != target.getFaction()) return false;
		if (target.isTurnDone()) return false;
		if (target.getCurrentProperties().IsStunned) return false;
		// if (target.getMoraleState() == ::Const.MoraleState.Fleeing) return false;
		if (target.getSkills().hasSkill("effects.rf_commanded")) return false;

		return true;
	}

	// Overwrite, because Reforged produces a combat log, which we need to produce earlier
	q.onUse = @() function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (!_user.isHiddenToPlayer())
		{
			local logText = ::Const.UI.getColorizedEntityName(_user) + " uses Command";
			if (!target.isHiddenToPlayer())
			{
				logText += " on " + ::Const.UI.getColorizedEntityName(target);
			}
			::Tactical.EventLog.log(logText);
		}

		if (target.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			// The morale check must be at least +2 if the target is fleeing
			if (!target.checkMorale(2, this.getCommandBonus(), ::Const.MoraleCheckType.Default))
			{
				return true;	// We didn't succeed the rally, but this skill still executed correctly
			}
		}

		// By this point the target should not be fleeing anymore, but a mod might do some funky behaviors, so we check the morale state again just in case
		if (target.getMoraleState() != ::Const.MoraleState.Fleeing)
		{
			::Tactical.TurnSequenceBar.moveEntityToFront(target.getID());
			target.recoverActionPoints(this.m.ActionPointsRecovered);
			target.getSkills().add(::new("scripts/skills/effects/rf_commanded_effect"));
			this.spawnIcon("rf_command_effect", _targetTile);
			return true;
		}

		return false;
	}

// New Functions
	q.getCommandBonus <- function()
	{
		local commandBonus = this.getContainer().getActor().getCurrentProperties().getBravery() * this.m.CommandBonusPct;
		return ::Math.max(0, commandBonus);	// The bonus can never be negative
	}
});
