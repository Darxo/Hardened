::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/rusty_warblade", function(q) {
	// Overwrite, because we replace Decapitate with Split
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/cleave", function(o) {
			o.m.ActionPointCost += 2;
			o.m.FatigueCost += 5;	// Reforged: += 3
			o.m.Icon = "skills/active_182.png";
			o.m.IconDisabled = "skills/active_182_sw.png";
			o.m.Overlay = "active_182";
		}));

		this.addSkill(::new("scripts/skills/actives/split"));	// Split is already balanced around being on a 2H weapon so we dont need to adjust cost

		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield", function(o) {
			o.m.ActionPointCost += 2;
			o.m.FatigueCost += 5;
		}));
	}}.onEquip;
});
