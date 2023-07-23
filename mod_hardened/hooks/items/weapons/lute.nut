::mods_hookExactClass("items/weapons/lute", function(o) {
	local oldOnEquip = o.onEquip;
	o.onEquip = function()
	{
		oldOnEquip();
		this.addSkill(::MSU.new("scripts/skills/actives/rf_battle_song_skill"));
	}
});
