::Hardened.HooksMod.hook("scripts/skills/effects/hex_master_effect", function (q) {
	q.m.HD_DamageReceivedRegularMult <- 0.5;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.DamageReceivedRegularMult *= this.HD_getDamageReceivedRegularMult();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.HD_getDamageReceivedRegularMult() != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(this.HD_getDamageReceivedRegularMult(), {InvertColor = true}) + " [Hitpoint|Concept.Hitpoints] Damage"),
			});
		}

		return ret;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		local actor = this.getContainer().getActor();
		if (_target.getID() == actor.getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (this.m.Slave.getContainer().getActor().isAlliedWith(_user))
			{
				if (_skill != null && _skill.m.StunChance >= 50)
				{
					// It's a good idea to use a skill that can stun on a Hexen with an active hex to cancel it, if its target is an ally
					ret *= 1.2;
				}
				else
				{
					// It is not a good idea to attack into a hex, which would cause an ally to take damage
					ret *= 0.5;
				}
			}
		}

		return ret;
	}

// new Functions
	q.HD_getDamageReceivedRegularMult <- function()
	{
		return this.m.HD_DamageReceivedRegularMult;
	}
});
