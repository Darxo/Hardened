::Hardened.HooksMod.hook("scripts/items/weapons/named/named_warbrand", function(q) {
	q.setValuesBeforeRandomize = @(__original) function( _baseItem )
	{
		__original(_baseItem);

		// Revert damage bonus added by Reforged
		this.m.RegularDamage -= 15;
		this.m.RegularDamageMax -= 5;
	}
});
