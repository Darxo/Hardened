this.hd_dynamic_image_holder <- this.inherit("scripts/entity/tactical/player", {
	m = {
	},
	function create()
	{
		// We skip all create logic from the player class to keep this object as simple as possible
		this.actor.create();
	}

	function onInit()
	{
		// We skip all onInit logic from the player class to keep this object as simple as possible
		this.actor.onInit();

		this.addSprite("socket");	// getImagePath requires this sprite to be present. Otherwise it produces errors
		this.addSprite("body");
		this.addDefaultStatusSprites();
	}

// New Functions
	function HD_assignBrush( _brush )
	{
		this.getSprite("body").setBrush(_brush);
	}
});
