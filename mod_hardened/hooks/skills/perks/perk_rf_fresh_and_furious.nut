::Hardened.wipeClass("scripts/skills/perks/perk_rf_fresh_and_furious", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fresh_and_furious", function(q) {
	q.m.ActionPointModifier <- -5;	// Attacks Action Point Cost is modified by this, while this effect is active

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = "Your next Attack costs " + ::MSU.Text.colorizeValue(this.m.ActionPointModifier, {AddSign = true, InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Points|Concept.ActionPoints]"),
		});

		return ret;
	}

	q.isHidden = @(__original) function()
	{
		return !::Tactical.isActive();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		if (!this.m.IsSpent)
		{
			_properties.TargetAttractionMult *= 1.1;	// Character with active Fresh & Furious are larger threats
		}
	}

	// Overwrite because we change the discount, its condition and make it also affect skills which cost 1 AP
	q.onAfterUpdate = @() function( _properties )
	{
		if (this.m.IsSpent) return;

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

	q.onAdded = @(__original) function()
	{
		__original();

		// Receiving this perk mid-battle (e.g. on Large Ghouls), should always set it to active
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			this.turnEffectOn();
		}
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (::MSU.isNull(_skill)) return ret;
		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _user
		{
			if (!this.m.IsSpent && this.isSkillValid(_skill))
			{
				if (_skill.getID() == "actives.hand_to_hand" && _user.isDisarmed())
				{
					ret *= 0.1;		// We should not waste our fresh and furious charge while disarmed
				}
			}
		}

		return ret;
	}

// Hardened Functions
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (this.isSkillValid(_skill) && this.getContainer().getActor().isActiveEntity())
			this.turnEffectOff();

		if (_skill.getID() == "actives.recover" && this.m.IsSpent)
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
