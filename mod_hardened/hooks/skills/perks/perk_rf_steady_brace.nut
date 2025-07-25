::Hardened.wipeClass("scripts/skills/perks/perk_rf_steady_brace", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_steady_brace", function(q) {		// This is now called "Ready to go"
	// Private
	q.m.ReloadSkills <- [	// List of all known reload skills from crossbows or firearms
		"actives.reload_bolt",
		"actives.reload_handgonne",
	];

	q.create = @(__original) function()
	{
		__original();
		this.removeType(::Const.SkillType.StatusEffect);	// We no longer list this perk in the effects list of an entity
	}

	q.onSpawned = @(__original) function()
	{
		__original();

		this.reloadCrossbowsAndFirearms();
	}

// New Functions
	q.reloadCrossbowsAndFirearms <- function()
	{
		local actor = this.getContainer().getActor();

		local mainHandItem = actor.getMainhandItem();
		if (mainHandItem != null && mainHandItem.isItemType(::Const.Items.ItemType.Weapon))
		{
			mainHandItem.HD_tryReload();
		}

		// We manually reload all weapons in the bag
		foreach (bagItem in actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag))
		{
			if (!bagItem.isItemType(::Const.Items.ItemType.Weapon)) continue;

			bagItem.HD_tryReload();
		}
	}
});
