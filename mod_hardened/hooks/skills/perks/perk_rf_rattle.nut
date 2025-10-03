::Hardened.wipeClass("scripts/skills/perks/perk_rf_rattle", [
	"create",
]);

// Our Implementation is not perfect. It can't deal with any delayed skills like Ranged Attacks or Lunge/Charge like abilities
// However we can deal with proxy-activations where one skill activates another one within it, if those happen instantly with no delay of course
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_rattle", function(q) {
	// Public
	q.m.DamagePctPerActionPoint <- 0.1;
	q.m.OneHandedMultiplier <- 2.0;		// One Handed weapons gain this much more damage

	// Private
	q.m.CurrentDamageMult <- 1.0;	// Damage bonus so its preserved throughout multiple skill uses
	q.m.FullForcedInitiatorSkill <- null;	// Reference of the last FullForcedSkill while we are still within that skills execution

// Hardened Events
	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);

		if (this.isSkillValid(_skill) && ::MSU.isNull(this.m.FullForcedInitiatorSkill))	// New Full Force was just newly initiated
		{
			local actor = this.getContainer().getActor();
			if (actor.isActiveEntity() && !actor.isDisarmed() && this.isSkillValid(_skill))
			{
				local spendableActionPoints = actor.getActionPoints();
				if (spendableActionPoints > 0)	// Full Force requires at least 1 AP to even trigger
				{
					if (_skill.getItem().isItemType(::Const.Items.ItemType.OneHanded))
					{
						spendableActionPoints *= this.m.OneHandedMultiplier;
					}

					this.m.CurrentDamageMult = 1.0 + (spendableActionPoints * this.m.DamagePctPerActionPoint);
					actor.setActionPoints(0);

					// This line mark the official activation of Full Force for the skill that was just executed
					this.m.FullForcedInitiatorSkill = _skill;
				}
			}
		}
	}

	q.onReallyAfterSkillExecuted = @(__original) function( _skill, _targetTile, _success )
	{
		__original(_skill, _targetTile, _success);

		if (_skill == this.m.FullForcedInitiatorSkill)
		{
			this.m.FullForcedInitiatorSkill = null;		// We end the execution window of our skill. There might still be
		}
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (this.isEnabled() && this.isSkillValid(_skill))	// Any valid skill between our initial activation and end, will be buffed
		{
			_properties.DamageTotalMult *= this.m.CurrentDamageMult;
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		if (this.m.FullForcedInitiatorSkill == null) return false;
		if (this.getContainer().getActor().isDisarmed()) return false;
		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Hammer);
	}
});
