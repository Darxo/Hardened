::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fresh_and_furious", function(q) {
	q.m.ActionPointMult <- 0.5;

	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueThreshold = 0.5;	// In Reforged this is 0.3
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = "Your next skill costs " + ::MSU.Text.colorizeMultWithText(this.m.ActionPointMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Points|Concept.ActionPoints] (rounded down)");
			}
			else if (entry.id == 12)
			{
				entry.text = ::MSU.String.replace(entry.text, "starting", "ending");
			}
		}

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && this.m.IsSpent)
			{
				ret.remove(index);	// Remove mention about the free skill use, because it's already been used this turn
			}
		}

		return ret;
	}

	// Overwrite because we extend this effect to also affect skills which cost 1 AP
	q.onAfterUpdate = @() function( _properties )
	{
		if (this.m.IsSpent || this.m.RequiresRecover) return;

		local actor = this.getContainer().getActor();
		if (!actor.isPreviewing() || actor.getPreviewMovement() != null || actor.getPreviewSkill().getActionPointCost() == 0)
		{
			foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
			{
				// Compared to Reforged: We no longer check for Action Point cost of >1 and we explicitely floor the value as per description
				skill.m.ActionPointCost = ::Math.floor(skill.m.ActionPointCost * this.m.ActionPointMult);
			}
		}
	}

	// Overwrite because we implement this logic now in the more accurate onReallyBeforeSkillExecuted function
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree ) {}

	// Overwrite because the fatigue check no longer happens at the start of the turn
	q.onTurnStart = @() function()
	{
		this.m.IsSpent = false;	// Same as Reforged
	}

	q.onTurnEnd <- function()
	{
		this.checkFatigueThreshold();
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.turnEffectOn();
	}

// Hardened Functions
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (this.isSkillValid(_skill) && this.getContainer().getActor().isActiveEntity()) this.m.IsSpent = true;

		if (_skill.getID() == "actives.recover") this.turnEffectOn();
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill.isType(::Const.SkillType.Active);
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
		this.m.Icon = ::Const.Perks.findById(this.getID()).Icon;
		this.m.IsHidingIconMini = false;
	}

	q.turnEffectOff <- function()
	{
		this.m.RequiresRecover = true;
		this.m.Icon = ::Const.Perks.findById(this.getID()).IconDisabled;
		this.m.IsHidingIconMini = true;
	}
});
