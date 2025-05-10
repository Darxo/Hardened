::Hardened.HooksMod.hook("scripts/entity/world/player_party", function(q) {
	q.onInit = @(__original) function()
	{
		// We introduce a new "HD_camp_banner" sprite, which is drawn behind Banner, so that later during camping the banner is shown in front of the camp
		local mockObject = ::Hardened.mockFunction(this, "addSprite", function( _spriteName ) {
			if (_spriteName == "zoom_banner")
			{
				local campSprite = this.addSprite("HD_camp_banner");		// We add the new sprite HD_camp_banner directly before "zoom_banner"
				return { done = true };
			}
			return { done = false };
		});
		__original();
		mockObject.cleanup();
	}

	q.setCamping = @(__original) function( _isCamping )
	{
		__original(_isCamping);

		// Feat: display the player banner during camping
		if (_isCamping)
		{
			// Currently the banner brush is set during onInit but that might change in the future or via a mod, so we fetch it here freshly just in case
			local bannerBrush = this.getSprite("banner").getBrush().Name;
			this.getSprite("HD_camp_banner").setBrush(bannerBrush);
		}

		this.getSprite("HD_camp_banner").Visible = _isCamping;	// This Sprite is now containing the camp-brush so we make it visble during camping
	}
});
