::Hardened.HooksMod.hook("scripts/items/weapons/light_crossbow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 400;				// Vanilla: 300
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.6
	}

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
