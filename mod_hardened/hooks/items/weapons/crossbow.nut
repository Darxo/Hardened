::Hardened.HooksMod.hook("scripts/items/weapons/crossbow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We replace the vanilla crossbow with a version that's 25% larger to make it easier to differentiate from light crossbows
		this.m.ArmamentIcon = "icon_HD_crossbow_01";	// Vanilla: icon_crossbow_01
	}

	q.addSkill = @(__original) { function addSkill( _skill )
	{
		// We revert the Fatigue reduction done by Reforged
		if (_skill.getID() == "actives.reload_bolt")
		{
			_skill.m.FatigueCost += 2;
		}

		__original(_skill);
	}}.addSkill;
});
