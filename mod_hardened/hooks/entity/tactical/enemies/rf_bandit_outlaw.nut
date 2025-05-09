// T1 Tough Bandit
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_outlaw", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		// No longer spawn with two-handed wooden flail, greatsword or battle axe
		local weapon = ::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/two_handed_mace"],
			[1, "scripts/items/weapons/two_handed_wooden_hammer"],
		]).roll();

		::Hardened.util.replaceMainhand(this, weapon);
	}

	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));	// So that they can still move 2 tiles and attack, just like their lower variants
	}
});
