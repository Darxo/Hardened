::Hardened.HooksMod.hook("scripts/skills/actives/rf_throw_grave_chill_bomb_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways

		this.m.Description = "Throw a fragile pot filled with the remains of creatures touched by unnatural frost towards a target, where it will shatter and blanket the area in an intense cold. Anyone caught in the freezing cloud will be chilled, friend and foe alike.";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Target a character. Apply a stacking " + ::MSU.Text.colorPositive(2) + " turns of [$ $|Skill+chilled_effect] to the target"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Every character adjacent to the target has a 33% chance to receive a stacking " + ::MSU.Text.colorPositive(2) + " turns of [$ $|Skill+chilled_effect]"),
		});

		return ret;
	}

	// Feat: grave bomb now applies chilled_effect instead of grave_chill
	q.onApply = @(__original) function( _data )
	{
		// We mock ::newn in order to replace rf_grave_chill_effect with chilled_effect without rewriting __original
		local mockObject;
		mockObject = ::Hardened.mockFunction(::getroottable(), "new", function( _script ) {
			if (_script == "scripts/skills/effects/rf_grave_chill_effect")
			{
				return { done = true, value = mockObject.original("scripts/skills/effects/chilled_effect") };
			}
		});

		__original(_data);

		mockObject.cleanup();
	}

// Reforged Functions
	q.isActorValid = @() function( _actor )
	{
		return !_actor.getCurrentProperties().HD_ImmuneToChilled;
	}
});
