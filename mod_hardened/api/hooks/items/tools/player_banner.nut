::Hardened.HooksMod.hook("scripts/items/tools/player_banner", function(q) {
// Hardened Functions
	q.HD_getBrush = @() function()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		return "player_banner_" + variant;
	}
});
