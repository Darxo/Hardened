::Hardened.HooksMod.hook("scripts/items/weapons/named/named_goblin_spear", function(q) {
	// Overwrite because we don't want Reforged to add Thrust or Riposte
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/stab"));	// In Vanilla/Reforged this is Thrust

		// Same as Reforged
		this.addSkill(::Reforged.new("scripts/skills/actives/spearwall", function(o) {
			o.m.ActionPointCost -= 1;
			// In Reforged this also costs -12 Fatigue
		}));

		// We no longer add Riposte
	}
});
