::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_thrall", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		// In order to improve progression, Thralls with throwing weapons spawn with an orc javeling in 66% of the time (up from 33%)
		::Hardened.util.replaceBagItem(this, "scripts/items/weapons/greenskins/orc_javelin", ["weapon.throwing_axe"]);

		// And in 33% of the cases they spawn with either of the higher quality throwing weapons
		local throwingWeapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/throwing_axe"],
			[1, "scripts/items/weapons/javelin"],
		]).roll();
		::Hardened.util.replaceBagItem(this, throwingWeapon, ["weapon.javelin"]);
	}

	q.onSpawned = @(__original) function()
	{
		__original();
		// Replace Survival Instinct with Base Defense to reduce bloat
		this.getSkills().removeByID("perk.rf_survival_instinct");
		local b = this.m.BaseProperties;
		b.MeleeDefense += 5;
		b.RangedDefense += 5;
	}
});
