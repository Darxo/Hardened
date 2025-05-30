::Hardened.HooksMod.hook("scripts/items/tools/player_banner", function(q) {
// Hardened Functions
	q.HD_getBrush = @() function()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		return "player_banner_" + variant;
	}

	// We overwrite the weapon.nut implementation, because player_banner always has ShowArmamentIcon = false
	// But we want it to display a silhouette
	q.HD_getSilhouette = @() function()
	{
		return this.item.HD_getSilhouette();
	}
});
