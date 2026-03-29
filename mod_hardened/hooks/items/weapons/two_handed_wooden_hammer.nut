::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_wooden_hammer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;		// Vanilla: 500
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/smite_skill"));
		this.addSkill(::new("scripts/skills/actives/shatter_skill"));
		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield", function(o) {
			o.m.FatigueCost += 5;
		}));
	}}.onEquip;
});
