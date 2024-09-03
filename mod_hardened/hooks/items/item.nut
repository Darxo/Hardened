::Hardened.HooksMod.hook("scripts/items/item", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		this.m.Condition = ::Math.min(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}
});
