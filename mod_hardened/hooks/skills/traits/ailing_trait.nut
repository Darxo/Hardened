::Hardened.HooksMod.hook("scripts/skills/traits/ailing_trait", function(q) {
	// Public
	q.m.InjuryDurationMult <- 1.5;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character is frail and sickly, causing injuries to linger and poisons to stay in his system for longer.";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("[Temporary Injuries|Concept.InjuryTemporary] you receive during combat last " + ::MSU.Text.colorizeMult(this.m.InjuryDurationMult, {InvertColor = true}) + " longer"),
		});

		return ret;
	}

// Hardened Events
	q.onOtherSkillAdded = @(__original) function( _skill )
	{
		// We can't allow this effect outside of combat because we manipulate member which are serialized
		// Otherwise our changes would be applied on each load of a savegame
		if (_skill.m.IsNew && _skill.isType(::Const.SkillType.TemporaryInjury))
		{
			_skill.m.HealingTimeMin *= this.m.InjuryDurationMult;
			_skill.m.HealingTimeMax *= this.m.InjuryDurationMult;
		}
	}
});

