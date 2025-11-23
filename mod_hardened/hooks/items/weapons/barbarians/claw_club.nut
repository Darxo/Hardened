::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/claw_club", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::Reforged.new("scripts/skills/actives/bash", function(o) {
			o.m.Icon = "skills/active_183.png";
			o.m.IconDisabled = "skills/active_183_sw.png";
			o.m.Overlay = "active_183";
		}));
		this.addSkill(::Reforged.new("scripts/skills/actives/knock_out", function(o) {
			o.m.Icon = "skills/active_186.png";
			o.m.IconDisabled = "skills/active_186_sw.png";
			o.m.Overlay = "active_186";
		}));
	}}.onEquip;
});
