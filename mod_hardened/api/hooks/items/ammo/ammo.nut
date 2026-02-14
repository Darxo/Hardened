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

// New Events
	// This Event is triggered after this ammo item has been used to reload an item
	q.HD_onReload <- function( _reloadedItem )
	{
	}
});
