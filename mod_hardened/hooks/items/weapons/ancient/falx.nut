::Hardened.HooksMod.hook("scripts/items/weapons/ancient/falx", function(q) {
	// Overwrite, because we add different skills under different discounts, than reforged
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/cleave"));
		this.addSkill(::Reforged.new("scripts/skills/actives/decapitate"));
	}}.onEquip;
});
