::Hardened.HooksMod.hook("scripts/skills/special/rf_reach", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\nGain " + ::MSU.Text.colorizeMult(::Reforged.Reach.ReachAdvantageMult) + " more [Melee skill|Concept.MeleeSkill] when attacking someone with shorter reach. Characters who are [stunned|Skill+stunned_effect], fleeing, or without a melee attack have no Reach.");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local properties = this.getContainer().getActor().getCurrentProperties();

		if (properties.IsAffectedByReach)
		{
			if (properties.getReachAdvantageBonus() != 0)
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString("Reach Advantage grants " + ::MSU.Text.colorizeValue(properties.getReachAdvantageBonus()) + " [Melee Skill|Concept.MeleeSkill]"),
				});
			}

			if (properties.getReachAdvantageMult() > 1.0)
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString("Reach Advantage grants " + ::MSU.Text.colorizeMult(properties.getReachAdvantageMult()) + " more [Melee Skill|Concept.MeleeSkill]"),
				});
			}
		}
		else
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("You will never have [Reach Advantage|Concept.ReachAdvantage]"),
			});
		}

		if (!properties.CanEnemiesHaveReachAdvantage || !properties.IsAffectedByReach)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Enemies will never have [Reach Advantage|Concept.ReachAdvantage] against you"),
			});
		}

		return ret;
	}

// Overwrites
	q.onUpdate = @() function( _properties )	// we overwrite reforged functions
	{
		local actor = this.getContainer().getActor();
		if (!actor.hasZoneOfControl())
		{
			_properties.ReachMult = 0.0;
		}
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		this.m.CurrBonus = 0;

		if (_skill.isRanged()) return;
		if (!_properties.IsAffectedByReach) return;
		if (_targetEntity == null) return;
		if (!_targetEntity.getCurrentProperties().CanEnemiesHaveReachAdvantage || !_targetEntity.getCurrentProperties().IsAffectedByReach) return;

		local targetReach = 0;
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
	if (q.contains("onTargetMissed")) delete q.onTargetMissed;
	if (q.contains("onTurnStart")) delete q.onTurnStart;
	if (q.contains("onTurnEnd")) delete q.onTurnEnd;
	if (q.contains("onWaitTurn")) delete q.onWaitTurn;
	if (q.contains("onPayForItemAction")) delete q.onPayForItemAction;
	if (q.contains("onCombatFinished")) delete q.onCombatFinished;
});
