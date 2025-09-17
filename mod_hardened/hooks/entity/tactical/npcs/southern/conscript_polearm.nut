// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/conscript_polearm", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/polemace"],
			[12, "scripts/items/weapons/oriental/swordlance"],
		]);

		this.m.OffhandWeightContainer = null;
	}

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @() function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_ConscriptPolearm);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
	}
});
