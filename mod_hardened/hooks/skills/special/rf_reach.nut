::Hardened.HooksMod.hook("scripts/skills/special/rf_reach", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\n[Melee skill|Concept.MeleeSkill] is increased by " + ::MSU.Text.colorGreen((::Reforged.Reach.ReachAdvantageMult * 100.0 - 100.0) + "%") + " when attacking opponents with shorter reach. Characters who are [stunned|Skill+stunned_effect], fleeing, or without a melee attack have no Reach.");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local properties = this.getContainer().getActor().getCurrentProperties();
		if (properties.getReachAdvantageMult() > 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Reach Advantage increases Melee Skill by " + ::MSU.Text.colorGreen((properties.getReachAdvantageMult() * 100.0 - 100.0) + "%")
			});
		}

		if (properties.getReachAdvantageBonus() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Reach Advantage grants " + ::MSU.Text.colorizeValue(properties.getReachAdvantageBonus()) + " Melee Skill"
			});
		}

		return ret;
	}

// Overwrites
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		this.m.CurrBonus = 0;

		if (_skill.isRanged()) return;
		if (!_properties.IsAffectedByReach) return;
		if (_targetEntity == null || !_targetEntity.getCurrentProperties().IsAffectedByReach) return;

		local targetReach = 0
		if (_targetEntity.getMoraleState() != ::Const.MoraleState.Fleeing && _targetEntity.getSkills().getAttackOfOpportunity() != null)
		{
			targetReach = _targetEntity.getSkills().buildPropertiesForDefense(this.getContainer().getActor(), _skill).getReach();
		}
		local diff = _properties.getReach() - targetReach;

		if (diff > 0)
		{
			_properties.MeleeSkill += this.calculateBonus(_properties);
		}
	}

	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		if (this.m.CurrBonus > 0)
		{
			_tooltip.push({
				icon = this.m.CurrBonus > 0 ? "ui/tooltips/positive.png" : "ui/tooltips/negative.png",
				text = ::MSU.Text.colorizePercentage(this.m.CurrBonus, {AddSign = false}) + " Reach Advantage"
			});
		}
	}

// New Functions
	q.calculateBonus <- function( _properties )
	{
		local bonus = _properties.getReachAdvantageBonus() + ::Math.floor(_properties.MeleeSkill * (_properties.getReachAdvantageMult() - 1.0));
		this.m.CurrBonus = bonus;
		return bonus;
	}

	// Delete Functions
	if (q.contains("onUpdate")) delete q.onUpdate;
	if (q.contains("onTargetMissed")) delete q.onTargetMissed;
	if (q.contains("onTurnStart")) delete q.onTurnStart;
	if (q.contains("onTurnEnd")) delete q.onTurnEnd;
	if (q.contains("onWaitTurn")) delete q.onWaitTurn;
	if (q.contains("onPayForItemAction")) delete q.onPayForItemAction;
	if (q.contains("onCombatFinished")) delete q.onCombatFinished;
});
