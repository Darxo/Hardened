::Hardened.HooksMod.hook("scripts/skills/effects/charmed_effect", function (q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Perk+perk_hold_out]"),
		});

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// Feat: Charmed characters now also gain resilient, making them impossible to double-stun
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hold_out", function(o) {
			o.m.IsSerialized = false;
		}));
	}

	q.onRemoved = @(__original) function()
	{
		__original();
		// We need to use "removeByStackByID" (added by Stack-Based-Skills), because its hook of the vanilla removeByID , used on perks, only remove the serialized version of them
		this.getContainer().removeByStackByID("perk.hold_out", false);
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		local actor = this.getContainer().getActor();
		if (_target.getID() == actor.getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			// It is not a good idea to attack someone who was only temporarily charmed
			ret *= 0.8;
		}

		return ret;
	}
});
