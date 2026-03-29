::Hardened.HooksMod.hook("scripts/items/weapons/scramasax", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/cleave"));
		this.addSkill(::new("scripts/skills/actives/decapitate"));
	}}.onEquip;
});
