::Hardened.HooksMod.hook("scripts/items/ammo/ammo", function(q) {
// Hardened Functions
	q.HD_getBrush = @(__original) function()
	{
		if (this.m.Sprite == "")
			return __original();
		else
			return this.m.Sprite;
	}

	q.HD_getSilhouette = @(__original) function()
	{
		if (this.m.ShowQuiver)
			return __original();
		else
			return null;
	}
});
