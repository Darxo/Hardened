::Hardened.HooksMod.hook("scripts/items/accessory/bandage_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description += " They can also treat fresh injuries if applied timely.";
		this.m.Value = 40;	// In Vanilla this is 25

		// Hardened values
		this.m.HD_IsMedical = true;
		this.m.HD_BaseDropChance = 60;	// Vanilla: 100
	}
});
