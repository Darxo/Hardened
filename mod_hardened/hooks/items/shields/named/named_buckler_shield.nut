::Hardened.HooksMod.hook("scripts/items/shields/named/named_buckler_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 500;		// Vanilla: 150
	}

	q.setValuesBeforeRandomize = @(__original) { function setValuesBeforeRandomize( _baseItem )
	{
		__original(_baseItem);

		this.m.MeleeDefense += 5;
		this.m.RangedDefense += 5;
	}}.setValuesBeforeRandomize;
});
