::Hardened.HooksMod.hook("scripts/items/weapons/staff_sling", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/sling_stone_skill"));
	}}.onEquip;
});
