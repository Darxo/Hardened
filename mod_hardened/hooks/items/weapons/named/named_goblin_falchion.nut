::Hardened.HooksMod.hook("scripts/items/weapons/named/named_goblin_falchion", function(q) {
	// Overwrite because we don't want Reforged to add Riposte or Slash with a discount
	q.onEquip = @(__original) function()
	{
		this.weapon.onEquip();

		// Slash is no longer discounted
		this.addSkill(::Reforged.new("scripts/skills/actives/stab", function(o) {
			o.m.IsIgnoredAsAOO = true;	// We ignore this skill because Slash should always be used for AOO or Riposte attacks
		}));

		// Slash is no longer discounted
		this.addSkill(::Reforged.new("scripts/skills/actives/slash", function(o) {
			// In Reforged this also costs -1 AP
			// In Reforged this also costs -2 Fatigue
			o.m.Icon = "skills/active_78.png";
			o.m.IconDisabled = "skills/active_78_sw.png";
			o.m.Overlay = "active_78";
		}));

		this.addSkill(::new("scripts/skills/actives/riposte"));
		// In Reforged this also costs -1 AP
		// In Reforged this also costs -5 Fatigue
	}
});
