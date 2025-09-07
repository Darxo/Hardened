::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_warlord", function(q) {
	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();

		// We always remove the shield from Orc Warlords to make them more aggressive
		::Hardened.util.replaceOffhand(this);
	}}.assignRandomEquipment;
});
