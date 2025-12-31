::Hardened.wipeClass("scripts/skills/perks/perk_rf_unstoppable", [
	"create",
	"getName",	// add stack number in brackets of perk name
	"isHidden",	// hide perk, while you have 0 stacks
	"onQueryTooltip",	// keep tooltip on recover about losing all stacks
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_unstoppable", function(q) {
	// Public
	q.m.ActionPointsPerStack <- 1;
	q.m.InitiativePctPerStack <- 0.1;
	q.m.MaxStacks = 3;	// In Reforged this is 5

	// Private
	q.m.Stacks = 0;		// In Reforged this is 0
	q.m.RoundWhenStackGained <- 0;	// This is the last round where a stack was gained

	q.getTooltip = @(__original) function()
	{
		local ret = this.skill.getTooltip();

		if (this.getActionPointModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getActionPointModifier(), {AddSign = true}) + " [Action Points|Concept.ActionPoints]"),
			});
		}

		if (this.getInitiativeMult() != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.getInitiativeMult()) + " [Initiative|Concept.Initiative]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lose 1 stack when you [wait|Concept.Wait]"),
		});

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lose 1 stack when you end your [turn|Concept.Turn] with more than " + this.getActionPointThreshold() + " [Action Points|Concept.ActionPoints] remaining"),
		});

		ret.push({
			id = 22,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lose all stacks when you use [Recover|Skill+recover_skill], get [stunned|Skill+stunned_effect], or [staggered|Skill+staggered_effect]"),
		});

		return ret;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.m.Stacks > 0)	// Just for performance
		{
			if (_properties.IsStunned || this.getContainer().hasSkill("effects.staggered"))
			{
				this.setStacks(0);
			}
		}
	}

	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);
		if (_skill.getID() == "actives.recover")
		{
			this.setStacks(0);
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		_properties.ActionPoints += this.getActionPointModifier();
		_properties.InitiativeMult *= this.getInitiativeMult();
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.Stacks = 0;
		this.m.RoundWhenStackGained = 0;
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor)
		if (::Time.getRound() != this.m.RoundWhenStackGained && this.isSkillValid(_skill) && this.getContainer().getActor().isActiveEntity())
		{
			this.m.RoundWhenStackGained = ::Time.getRound();
			this.setStacks(this.m.Stacks + 1);
		}
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getActionPoints() > this.getActionPointThreshold())
		{
			this.setStacks(this.m.Stacks - 1);
		}
	}

	q.onWaitTurn = @(__original) function()
	{
		__original();
		this.setStacks(this.m.Stacks - 1);
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _target
		{
			if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

			if (this.canSkillStagger(_skill))
			{
				ret *= 1.0 + (0.2 * this.m.Stacks);	// _user try to apply staggered on _target to neutralize all built-up stacks
			}
		}

		return ret;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill.isAttack();
	}

	q.getActionPointModifier <- function()
	{
		return this.m.Stacks * this.m.ActionPointsPerStack;
	}

	q.getInitiativeMult <- function()
	{
		return 1.0 + this.m.Stacks * this.m.InitiativePctPerStack;
	}

	// return the maximum allowed current action points, to preserve stacks
	q.getActionPointThreshold <- function()
	{
		return ::Math.floor(this.getContainer().getActor().getActionPointsMax() / 2);
	}

	q.setStacks <- function( _newStacks )
	{
		_newStacks = ::Math.max(0, _newStacks);
		_newStacks = ::Math.min(this.m.MaxStacks, _newStacks);

		if (_newStacks == this.m.Stacks) return;

		this.m.Stacks = _newStacks;
		local actor = this.getContainer().getActor()
		actor.setDirty(true);	// We force another update on this character as its stacks have changes
		if (actor.isPlacedOnMap())
		{
			this.spawnIcon("perk_rf_unstoppable", actor.getTile());
		}
	}

	// Return true, if _skill will always or sometimes apply staggered on use or hit
	// This list does not yet include perks, which make certain skills suddenly stagger, like offhand training, toolbox, breakthrough or line breaker
	q.canSkillStagger <- function( _skill )
	{
		if (::MSU.isNull(_skill)) return false;

		// These skills will always, or sometimes apply staggered on use or hit
		local staggerableSkillIDs = [
			"actives.smite",
			"actives.repel",
			"actives.hook",
			"actives.serpent_hook",
			"actives.flesh_pull",
			"actives.gore",
			"actives.shatter",
			"actives.unstoppable_charge",
			"actives.uproot",
			"actives.uproot_small",
			"actives.rf_pummel",
			"actives.rf_swordmaster_charge",
			"actives.rf_swordmaster_kick",
			"actives.rf_swordmaster_push_through",
			"actives.rf_net_pull",
		];

		return staggerableSkillIDs.find(_skill.getID()) != null;
	}
});
