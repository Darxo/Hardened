::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_fencer", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		local item = this.getMainhandItem();
		if (!::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.TwoHanded))
		{
			// Duelist does not work for two-handed weapons so we replace this guaranteed perk with its two-handed equivalent
			this.getSkills().removeByID("perk.duelist");
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		}
	}
});
