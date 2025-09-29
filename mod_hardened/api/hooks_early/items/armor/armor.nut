::Hardened.HooksMod.hook("scripts/items/armor/armor", function(q) {
	// Overwrite, because we implement the value of condition-based items in a more moddable way
	q.getValue = @() function()
	{
		local value = this.item.getValue() * this.HD_getConditionMult();
		if (this.getUpgrade() != null) value += this.getUpgrade().getValue();
		return ::Math.floor(value);
	}
});
