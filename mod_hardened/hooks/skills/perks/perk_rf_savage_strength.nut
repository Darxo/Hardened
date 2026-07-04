::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_savage_strength", function(q) {
	q.m.Mult = 0.8;		// Reforged: 0.75

	// Overwrite, because we improve the check for what is considered a "Weapon Skill"
	q.onAfterUpdate = @() function( _properties )
	{
		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (::MSU.isNull(skill.getItem())) continue;
			if (!skill.getItem().isItemType(::Const.Items.ItemType.Weapon)) continue;

			skill.m.FatigueCostMult *= this.m.Mult;
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.IsImmuneToDisarm = true;
	}
});
