::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_en_garde", function(q) {
	q.m.MeleeSkillModifier <- 15;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap())
		{
			if (this.isEnabled() && !::Tactical.TurnSequenceBar.isActiveEntity(actor))
			{
				_properties.MeleeSkill += this.m.MeleeSkillModifier;
			}
		}
	}

	// This perk no longer adds any skill
	q.onAdded = @() function() {}
	q.onRemoved = @() function() {}

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
});


