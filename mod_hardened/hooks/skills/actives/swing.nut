::Hardened.HooksMod.hook("scripts/skills/actives/swing", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png")
			{
				ret.remove(index);
				break;
			}
		}

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has " + ::MSU.Text.colorNegative("-10%") + ::Reforged.Mod.Tooltips.parseString(" [chance to hit|Concept.Hitchance]"),
			});
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier
			this.m.HitChanceBonus = (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords) ? 0 : -10;	// Vanilla never adjusted this variable
		}
	}
});
