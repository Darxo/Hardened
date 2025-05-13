::Hardened.HooksMod.hook("scripts/retinue/followers/blacksmith_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[2] = "Increases the amount of tools you can carry by 50";		// In Vanilla this is "Reduces tool consumption by 20%"

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
});
