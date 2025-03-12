::Hardened.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.getContainer().getActor().getSize() != 1)
		{
			// We reduced the base Melee Defense of small Ghouls by 10, but that effects all sizes of Ghouls
			// Therefor, we offset that change within this effect
			_properties.MeleeDefense += 10;
		}
	}
});
