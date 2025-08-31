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

		this.addSkill(::Reforged.new("scripts/skills/actives/split", function(o) {
			// Rusty Warblade has a DirectDamageAdd of 0.1 and a total Armor Pen of 0.35. So we need to adjust the Armor Pen of Split with that in mind
			o.m.DirectDamageMult = 0.25;	// Vanilla: 0.3
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield", function(o) {
			o.m.ActionPointCost += 2;
			o.m.FatigueCost += 5;
		}));
	}}.onEquip;
});
