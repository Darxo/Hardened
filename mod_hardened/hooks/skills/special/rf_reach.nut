// We wipe many vanilla functions with the goal to de-couple the tail from the head
::Hardened.wipeClass("scripts/skills/special/rf_reach", [
	"create",
	"getTooltip",
]);

::Hardened.HooksMod.hook("scripts/skills/special/rf_reach", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\nGain " + ::MSU.Text.colorizeMultWithText(::Reforged.Reach.ReachAdvantageMult) + " [Melee skill|Concept.MeleeSkill] when attacking someone with shorter reach. Characters who are [stunned|Skill+stunned_effect], fleeing, or without a melee attack have no Reach.");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local properties = this.getContainer().getActor().getCurrentProperties();

		if (properties.IsAffectedByReach)
		{
			if (properties.getReachAdvantageMult() != 1.0)
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = ::Reforged.Mod.Tooltips.parseString("Reach Advantage grants " + ::MSU.Text.colorizeMultWithText(properties.getReachAdvantageMult()) + " [Melee Skill|Concept.MeleeSkill]"),
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
	q.onUpdate = @() function( _properties )
	{
		local actor = this.getContainer().getActor();
		// We could normally also just ask actor.hasZoneOfControl(). However in Hardened the ZOC can also be disabled by an additional character property, so this check is not correct anymore
		if (actor.getCurrentProperties().IsStunned || actor.m.MoraleState == ::Const.MoraleState.Fleeing || actor.getSkills().getAttackOfOpportunity() == null)
		{
			_properties.ReachMult = 0.0;
		}
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (this.hasReachAdvantage(_skill, _targetEntity, _properties))
		{
			_properties.MeleeSkillMult *= _properties.getReachAdvantageMult();
		}
	}

// MSU Functions
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		local targetEntity = _targetTile.getEntity();
		local properties = this.getContainer().buildPropertiesForUse(_skill, targetEntity);
		local approximateBonus = this.getApproximateBonus(properties);
		if (approximateBonus != 0 && this.hasReachAdvantage(_skill, targetEntity, properties))
		{
			_tooltip.push({
				icon = approximateBonus > 0 ? "ui/tooltips/positive.png" : "ui/tooltips/negative.png",
				text = ::MSU.Text.colorizeValue(approximateBonus, {AddPercent = true}) + " Reach Advantage"
			});
		}
	}

// New Functions
	// Do we have Reachadvantage over _targetEntity when using _skillUsed?
	q.hasReachAdvantage <- function( _skillUsed, _targetEntity, _properties )
	{
		if (::MSU.isNull(_skillUsed)) return false;
		if (!_skillUsed.isAttack()) return false;
		if (_skillUsed.isRanged()) return false;
		if (!_skillUsed.isUsingHitchance()) return false;

		if (!_properties.IsAffectedByReach) return false;

		if (::MSU.isNull(_targetEntity)) return true;
		if (!_targetEntity.getCurrentProperties().IsAffectedByReach) return false;
		if (!_targetEntity.getCurrentProperties().CanEnemiesHaveReachAdvantage) return false;

		local targetReach = 0;
		if (_targetEntity.getMoraleState() != ::Const.MoraleState.Fleeing && _targetEntity.getSkills().getAttackOfOpportunity() != null)
		{
			targetReach = _targetEntity.getSkills().buildPropertiesForDefense(this.getContainer().getActor(), _skillUsed).getReach();
		}
		local diff = _properties.getReach() - targetReach;

		return diff > 0;
	}

	// Return an approximate melee skill modifier, granted by Reachadvantage
	// This is only meant for displaying it in the Hitfactor Tooltip as Reachadvantage is the most relevant multiplier to learn about here
	q.getApproximateBonus <- function( _properties )
	{
		return ::Math.floor(_properties.MeleeSkill * (_properties.getReachAdvantageMult() - 1.0));
	}
});
