::Hardened.HooksMod.hook("scripts/items/weapons/light_crossbow", function(q) {
	q.addSkill = @(__original) { function addSkill( _skill )
	{
		// We revert the Fatigue reduction done by Reforged
		if (_skill.getID() == "actives.reload_bolt")
		{
			_skill.m.FatigueCost += 5;
		}

		__original(_skill);
	}}.addSkill;
});
