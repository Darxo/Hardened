::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fresh_and_furious", function(q) {
	q.m.ActionPointModifier <- -5;	// Attacks Action Point Cost is modified by this, while this effect is active

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = "Your next Skill costs " + ::MSU.Text.colorizeValue(this.m.ActionPointModifier, {AddSign = true, InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Points|Concept.ActionPoints]");
			}
		}

		foreach (index, entry in ret)
		{
			if (entry.id == 12)
			{
				ret.remove(index);	// Remove mention about being disabled after using recover, as it currently is disabled. so that line is not relevant
				break;
			}
		}

		return ret;
	}

	q.isHidden = @(__original) function()
	{
		this.skill.isHidden();
	}

	// Overwrite because we change the discount, its condition and make it also affect skills which cost 1 AP
	q.onAfterUpdate = @() function( _properties )
	{
		if (this.m.IsSpent || this.m.RequiresRecover) return;

		local actor = this.getContainer().getActor();
		if (!actor.isPreviewing() || actor.getPreviewMovement() != null)
		{
			foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
			{
				if (this.isSkillValid(skill))
				{
					// Compared to Reforged: We no longer check for Action Point cost of >1 and we apply an additive discount instead of multiplicate one
					skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.m.ActionPointModifier);
				}
			}
		}
	}

	// Overwrite because we implement this logic now in the more accurate onReallyBeforeSkillExecuted function
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree ) {}

	// Overwrite because the fatigue check no longer happens at the start of the turn
	q.onTurnStart = @() function() {}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.turnEffectOff();
	}

	q.onCombatStarted = @(__original) function()
	{
		__original();
		this.turnEffectOn();
	}

// Hardened Functions
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (this.isSkillValid(_skill) && this.getContainer().getActor().isActiveEntity())
			this.turnEffectOff();

		if (_skill.getID() == "actives.recover" && (this.m.IsSpent || this.m.RequiresRecover))
		{
			this.turnEffectOn();
			this.spawnIcon("perk_rf_fresh_and_furious", _targetTile);
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill.isType(::Const.SkillType.Active) && _skill.isAttack();
	}

	// Check whether this character surpasses the fatigue threshold and turn this effect off if so
	q.checkFatigueThreshold <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getFatigue() >= this.m.FatigueThreshold * actor.getFatigueMax())
		{
			this.turnEffectOff();
		}
	}

	q.turnEffectOn <- function()
	{
		this.m.RequiresRecover = false;
		this.m.IsSpent = false;
		this.m.Icon = ::Const.Perks.findById(this.getID()).Icon;
		this.m.IsHidingIconMini = false;
	}

	q.turnEffectOff <- function()
	{
		this.m.RequiresRecover = true;
		this.m.IsSpent = true;
		this.m.Icon = ::Const.Perks.findById(this.getID()).IconDisabled;
		this.m.IsHidingIconMini = true;
	}
});
