::Hardened.HooksMod.hook("scripts/retinue/followers/blacksmith_follower", function(q) {
	q.m.HD_RequiredArmorConsumables <- 5;

	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[2] = "+50 Capacity for Tools and Supplies";		// In Vanilla this is "Reduces tool consumption by 20%"

	}

	// Overwrite, because we change almost everything about Vanilla effect
	q.onUpdate = @(__original) function()
	{
		// We revert changes to tool consumption as that is no longer part of this retinues effect
		local oldArmorPartsPerArmor = ::World.Assets.m.ArmorPartsPerArmor;
		__original();
		::World.Assets.m.ArmorPartsPerArmor = oldArmorPartsPerArmor;

		::World.Assets.m.ArmorPartsMaxAdditional += 50;
	}

	// Overwrite, because we enforce a different condition
	q.onEvaluate = @() function()
	{
		local armorConsumablesApplied = 0;
		armorConsumablesApplied += ::World.Statistics.getFlags().getAsInt("ArmorAttachementsApplied");	// This flag is incremented in armor_upgrade.nut
		armorConsumablesApplied += ::World.Statistics.getFlags().getAsInt("PaintUsedOnHelmets");	// This flag is incremented in helmet.nut
		armorConsumablesApplied += ::World.Statistics.getFlags().getAsInt("PaintUsedOnShields");	// This flag is incremented in shield.nut

		this.m.Requirements[0].Text = "Have " + ::Math.min(armorConsumablesApplied, this.m.HD_RequiredArmorConsumables) + "/" + this.m.HD_RequiredArmorConsumables + " paint or armor attachements used";
		if (armorConsumablesApplied >= this.m.HD_RequiredArmorConsumables)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}
});
