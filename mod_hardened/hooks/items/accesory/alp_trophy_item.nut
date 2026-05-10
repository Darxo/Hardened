::Hardened.HooksMod.hook("scripts/items/accessory/alp_trophy_item", function(q) {
	q.m.HD_BraveryModifier <- 5;
	q.m.HD_SkillsToIgnore <- [
		"actives.sleep",
		"actives.nightmare",
	];
	q.m.HD_SkillValueMult <- 0.5;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/bravery.png")
			{
				entry.text = ::MSU.Text.colorizeValue(this.m.HD_BraveryModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]");
			}
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::MSU.Text.colorizeMultWithText(this.m.HD_SkillValueMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" likely to be targeted with [$ $|Skill+sleep_skill] or [$ $|Skill+nightmare_skill]"),
		});

		return ret;
	}

	q.onEquip = @(__original) function()
	{
		__original();
		this.addSkill(::new("scripts/skills/items/hd_skill_ignore_accessory_effect"));
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		// Revert the Resolve, that vanilla applies, because we apply our own Resolve
		local oldBravery = _properties.Bravery;
		__original(_properties);
		_properties.Bravery = oldBravery;

		_properties.Bravery += this.m.HD_BraveryModifier;
	}
});
