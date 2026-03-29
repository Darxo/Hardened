::Hardened.HooksMod.hook("scripts/items/weapons/oriental/composite_bow", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/quick_shot"));
		this.addSkill(::new("scripts/skills/actives/aimed_shot"));
	}}.onEquip;
});
