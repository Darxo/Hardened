::Hardened.HooksMod.hook("scripts/items/weapons/lute", function(q) {
	q.onEquip = @(__original) function()
	{
		__original();
		this.addSkill(::new("scripts/skills/actives/hd_battle_song_skill"));
	}
});
