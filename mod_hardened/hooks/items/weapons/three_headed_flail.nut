::Hardened.HooksMod.hook("scripts/items/weapons/three_headed_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Three separate striking heads attached to a handle by chains.  Each head can hit or miss a target separately and strike over or around shield cover.  Perks that interact with attacks (like [Overwhelm|Perk+perk_overwhelm] and [Pattern Recognition|Perk+perk_pattern_recognition]) will only trigger once per attack, but perks that interact with hits (like [Wear Them Down|Perk+perk_wear_them_down], [Fearsome|Perk+perk_fearsome], [Double Strike|Perk+perk_double_strike], and [Headhunter|Perk+perk_headhunter]) will independently trigger on each hit (for better or for worse).";

		this.m.Reach = 3;		// In Reforged this is 4
	}
});
