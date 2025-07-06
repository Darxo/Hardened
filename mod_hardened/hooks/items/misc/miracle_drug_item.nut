::Hardened.HooksMod.hook("scripts/items/misc/miracle_drug_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_IsMedical = true;
	}
});
