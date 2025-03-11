::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_bow", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		// We revert the vision change made by Vanilla
		local oldVision = _properties.Vision;
		__original(_properties);
		_properties.Vision = oldVision;
	}
});
