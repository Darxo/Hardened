::Hardened.HooksMod.hook("scripts/skills/traits/weasel_trait", function(q) {
	q.m.RetreatingDefenseModifier <- 25;
	q.m.FleeingDefenseModifier <- 25;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::MSU.Text.colorizeValue(this.m.RetreatingDefenseModifier, {AddSign = true}) + " Melee Defense during your turn while retreating";
				break;
			}
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = ::MSU.Text.colorizeValue(this.m.FleeingDefenseModifier, {AddSign = true}) + " Melee Defense during your turn while fleeing",
		});

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		local actor = this.getContainer().getActor();
		if (!actor.isActiveEntity()) return;

		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			_properties.MeleeDefense += this.m.FleeingDefenseModifier;
		}

		if (::Tactical.State.isAutoRetreat())
		{
			_properties.MeleeDefense += this.m.RetreatingDefenseModifier;
		}
	}

	q.onBeingAttacked = @() function( _attacker, _skill, _properties )
	{
		// Do nothing. We overwrite and replicate this behavior in the onUpdate function
	}

});
