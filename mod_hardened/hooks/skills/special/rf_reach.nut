::mods_hookExactClass("skills/special/rf_reach", function (o) {
	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\n[Melee skill|Concept.MeleeSkill] is increased by " + ::MSU.Text.colorGreen((::Reforged.Reach.ReachAdvantageMult * 100.0 - 100.0) + "%") + " when attacking opponents with shorter reach. Characters who are [stunned|Skill+stunned_effect], fleeing, or without a melee attack have no Reach.");
	}

	local oldGetTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = oldGetTooltip();

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
	o.onAnySkillUsed = function( _skill, _targetEntity, _properties )
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

	o.onGetHitFactors = function( _skill, _targetTile, _tooltip )
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
	o.calculateBonus <- function( _properties )
	{
		local bonus = _properties.getReachAdvantageBonus() + ::Math.floor(_properties.MeleeSkill * (_properties.getReachAdvantageMult() - 1.0));
		this.m.CurrBonus = bonus;
		return bonus;
	}

// Deleted Functions
	o.onUpdate = function(...){};
	o.onTargetMissed = function(...){};
	o.onTurnStart = function(...){};
	o.onTurnEnd = function(...){};
	o.onWaitTurn = function(...){};
	o.onPayForItemAction = function(...){};
	o.onCombatFinished = function(...){};
});
