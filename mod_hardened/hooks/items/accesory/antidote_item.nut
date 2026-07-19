::Hardened.HooksMod.hook("scripts/items/accessory/antidote_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = ::MSU.String.replace(this.m.Description, "poisons", "toxins");
		this.m.Value = 100;	// In Vanilla this is 150

		this.m.HD_IsMedical = true;
	}
});
