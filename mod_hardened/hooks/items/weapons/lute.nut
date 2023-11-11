::Hardened.HooksMod.hook("scripts/items/weapons/lute", function(q) {
	q.onEquip = @(__original) function()
	{
		__original();
		this.addSkill(::MSU.new("scripts/skills/actives/rf_battle_song_skill"));
	}
});
