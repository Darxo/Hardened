::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		this.paintShieldsInCompanyColors();
	}
});
