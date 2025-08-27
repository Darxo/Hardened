::Hardened.HooksMod.hook("scripts/skills/actives/disarm_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (!this.__original(_originTile, _targetTile)) return false;

		local target = _targetTile.getActor();
		if (target.getCurrentProperties().IsImmuneToDisarm) return false;
		if (target.getCurrentProperties().IsStunned) return false;			// Stun already skips the turn which would also wait out the disarm, so we prevent this
		if (target.getSkills().hasSkill("effects.disarmed")) return false;	// Disarm does not stack so we prevent the player from making a mistake

		return true;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Apply [disarmed|Skill+disarmed_effect] on a hit");	// We improve vanillas tooltip by making it shorter and featuring a nested tooltip
				break;
			}
		}

		return ret;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_skill == null || this.getID() != _skill.getID()) return ret;	// We only care about situations, where this skill is used

		if (_user.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _user
		{
			if (_target.getSkills().hasSkill("actives.spearwall") || _target.getSkills().hasSkill("actives.riposte"))
			{
				ret *= 1.5;	// Disarm will cancel spearwall and riposte so we are encouraged to disarm such a character
			}
		}

		return ret;
	}
});
