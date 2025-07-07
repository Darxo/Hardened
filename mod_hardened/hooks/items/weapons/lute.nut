::Hardened.HooksMod.hook("scripts/items/weapons/lute", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.1
	}

	// Overwrite, because that makes adjusting the stunchance a bit simpler
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/knock_out", function(o) {
			o.m.IsFromLute = true;
			o.m.Icon = "skills/active_88.png";
			o.m.IconDisabled = "skills/active_88_sw.png";
			o.m.Overlay = "active_88";
			o.m.StunChance = 100;	// In Vanilla this is 30
		}));

		this.addSkill(::new("scripts/skills/actives/hd_battle_song_skill"));
	}
});
