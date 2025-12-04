::Hardened.HooksMod.hook("scripts/items/weapons/rf_halberd", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1600;			// Reforged: 2500
		this.m.StaminaModifier = -14;	// Reforged: -16
		this.removeWeaponType(::Const.Items.WeaponType.Polearm);	// Reforged: Polearm, Hammer, Axe

		this.m.Reach = 6;	// In Reforged this is 7
	}

	// Overwrite, because we remove a skill and swap out another one
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/strike_skill", function(o) {
			o.m.Icon = "skills/rf_halberd_sunder_skill.png";
			o.m.IconDisabled = "skills/rf_halberd_sunder_skill_sw.png";
			o.m.Overlay = "rf_halberd_sunder_skill";
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/demolish_armor_skill", function(o) {
			o.m.Icon = "skills/rf_halberd_demolish_armor_skill.png";
			o.m.IconDisabled = "skills/rf_halberd_demolish_armor_skill_sw.png";
			o.m.Overlay = "rf_halberd_demolish_armor_skill";
		}));
	}
});
