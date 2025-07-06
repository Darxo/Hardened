::Hardened.HooksMod.hook("scripts/items/accessory/bandage_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description += " They can also treat fresh injuries if applied timely.";
		this.m.Value = 40;	// In Vanilla this is 25

		this.m.HD_IsMedical = true;
	}
});
