::Hardened.HooksMod.hook("scripts/skills/actives/rf_sprint_skill", function(q) {
	// Private
	q.m.IsEffectActive <- false,	// This skill will apply a debuff for the rest of this turn, controlled by this flag

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 1;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Disable all Attack-Skills until you [wait|Concept.Wait] or end your [turn|Concept.Turn]"),
		});

		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		this.m.IsEffectActive = true;
		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.m.IsEffectActive)
		{
			this.setSkillsIsUsable(false, function(_skill) {return _skill.isAttack()});
		}
	}

	q.onWaitTurn = @(__original) function()
	{
		__original();
		if (this.m.IsEffectActive)
		{
			this.m.IsEffectActive = false;
			this.setSkillsIsUsable(true, function(_skill) {return _skill.isAttack()});
		}
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		if (this.m.IsEffectActive)
		{
			this.m.IsEffectActive = false;
			this.setSkillsIsUsable(true, function(_skill) {return _skill.isAttack()});
		}
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		if (this.m.IsEffectActive)
		{
			this.m.IsEffectActive = false;
			this.setSkillsIsUsable(true, function(_skill) {return _skill.isAttack()});
		}
	}

// MSU Events
	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (this.m.IsEffectActive)
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
			});
		}
	}
});
