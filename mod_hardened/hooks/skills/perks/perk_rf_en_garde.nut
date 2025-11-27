// We wipe many vanilla functions with the goal to de-couple the tail from the head
::Hardened.wipeClass("scripts/skills/perks/perk_rf_en_garde", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_en_garde", function(q) {
	q.m.MeleeSkillModifier <- 10;
	q.m.ActionPointsRecovered <- 1;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.isEnabled() && this.getContainer().getActor().isActiveEntity())
		{
			_properties.MeleeSkill += this.m.MeleeSkillModifier;
		}
	}

	q.onMissed = @(__original) function( _attacker, _skill )
	{
		__original(_attacker, _skill);
		local actor = this.getContainer().getActor();
		if (this.isEnabled() && this.isSkillValid(_skill) && !_attacker.isAlliedWith(actor))
		{
			actor.recoverActionPoints(this.m.ActionPointsRecovered);
		}
	}

// Hardened Functions
	q.onOtherSkillAdded = @() function( _skill )
	{
		if (_skill.getID() == "effects.riposte")
		{
			_skill.m.IsRemovedWhenHit = false;
			_skill.m.OnlyOneCounterAttack = false;
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		if (this.getContainer().getActor().isDisarmed())
			return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
		{
			return false;
		}

		return true;
	}

	// Determines whether the Action Point recovery on a miss is active
	q.isSkillValid <- function( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged();
	}
});
