::Hardened.HooksMod.hook("scripts/items/helmets/helmet", function(q) {
	// Overwrite, because we implement the value of condition-based items in a more moddable way
	q.getValue = @() function()
	{
		local value = this.item.getValue() * this.HD_getConditionMult();
		return ::Math.floor(value);
	}
});
