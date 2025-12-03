::Hardened.HooksMod.hook("scripts/items/weapons/heavy_crossbow", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueOnSkillUse = 2;	// In Vanilla this is 0
	}

	q.addSkill = @(__original) { function addSkill( _skill )
	{
		// We revert the AP increase done by Reforged
		if (_skill.getID() == "actives.reload_bolt")
		{
			_skill.m.ActionPointCost -= 1;
		}

		__original(_skill);
	}}.addSkill;
});
