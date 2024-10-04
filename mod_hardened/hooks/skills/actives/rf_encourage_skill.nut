::Hardened.HooksMod.hook("scripts/skills/actives/rf_encourage_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Encourage an ally from your faction to raise their current [Morale.|Concept.Morale] Cannot be used on [fleeing,|Concept.Morale] [steady|Concept.Morale] or [stunned|Skill+stunned_effect] allies.");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 16)
			{
				ret.remove(index);	// Remove entry about the faction restriction and the restriction about per tile distance
				break;
			}
		}

		return ret;
	}

	// Overwrite to remove the tile distance and morale difference condition of the skill
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (target.getCurrentProperties().IsStunned || target.getMoraleState() == ::Const.MoraleState.Fleeing) return false;
		if (target.getMoraleState() >= ::Const.MoraleState.Steady || target.getMoraleState() >= target.m.MaxMoraleState) return false;

		return this.getContainer().getActor().getFaction() == target.getFaction();
	}
});
