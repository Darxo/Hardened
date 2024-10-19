::Hardened.HooksMod.hook("scripts/skills/items/generic_item", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		// Revert vanilla Stamina change as we manage that ourselves now from within actor.nut
		local oldStamina = _properties.Stamina;
		__original(_properties);
		_properties.Stamina = oldStamina;
	}
});
