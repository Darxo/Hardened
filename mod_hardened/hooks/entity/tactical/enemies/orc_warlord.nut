::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_warlord", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));	// This will grant them immunity to disarm
	}

	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();

		// We always remove the shield from Orc Warlords to make them more aggressive
		::Hardened.util.replaceOffhand(this);
	}}.assignRandomEquipment;
});
