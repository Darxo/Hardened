::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/orientation_overlay/orientation_overlay", function(q) {
	q.update = @(__original) function()	// This is called during battle
	{
		local doUpdate = false;
		if (::Hardened.Private.IsPreviewingAttackWithHitChance)
		{
			// We check, whether the vanilla camera has moved in any way, similar to how they do it
			local camera = ::Tactical.getCamera();
			local cameraPos = camera.getPos();
			if (this.m.IsDirty == true || this.m.LastCameraLevel != camera.Level || this.m.LastCameraZoom != camera.Zoom || this.m.LastCameraPos.X != cameraPos.X || this.m.LastCameraPos.Y != cameraPos.Y)
			{
				doUpdate = true;
			}
		}

		__original();

		// We need to do our updates after __original, because they sometimes do an asyncCall("disableOverlays"), which will hide all our elements too
		// Our updates afterwards will turn the js objects visible again
		if (doUpdate)
		{
			this.HD_updateHitchanceOverlayPositions();
		}
	}

// New Function
	/// @param _ignore is an array of entity IDs whose position should not be updated; instead they will be hidden
	q.HD_updateHitchanceOverlayPositions <- function( _ignore = [] )
	{
		local updatedOverlays = this.HD_queryEntityHitchanceOverlayPositions();

		// We disable the visibility of anything from the _ignore array given to us
		foreach (overlay in updatedOverlays)
		{
			foreach (entityID in _ignore)
			{
				if (overlay.id == entityID)
				{
					overlay.visible = false;
					break;
				}
			}
		}

		if (updatedOverlays != null && updatedOverlays.len() > 0)
		{
			this.m.JSHandle.asyncCall("HD_updateHitchanceOverlays", updatedOverlays);
		}
	}

	q.HD_fullUpdateHitchanceOverlays <- function()
	{
		local updatedOverlays = this.HD_queryEntityHitchanceOverlays();
		if (updatedOverlays != null && updatedOverlays.len() > 0)
		{
			this.m.JSHandle.asyncCall("HD_updateHitchanceOverlays", updatedOverlays);
		}
	}

	// Query and array of the positions of the overlays of all actors, who currently display a hitchance for the player
	q.HD_queryEntityHitchanceOverlayPositions <- function()
	{
		local ret = [];

		local camera = ::Tactical.getCamera();
		local cameraPos = camera.getPos();
		foreach (otherActor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			// We check for these conditions twice to filter out all unnecessary overlay changes for efficiency
			if (!otherActor.isPlacedOnMap()) continue;
			if (otherActor.HD_getChanceToBeHit() == null) continue;

			ret.push(this.HD_getActorOverlayEntry(otherActor));
		}

		return ret;
	}

	// Query and array of the complete overlay information of all actors (even those who dont display anything)
	// This is a bit more costly and contains more information for the javascript frontend
	q.HD_queryEntityHitchanceOverlays <- function()
	{
		local ret = [];

		local camera = ::Tactical.getCamera();
		local cameraPos = camera.getPos();
		foreach (otherActor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			ret.push(this.HD_getActorOverlayEntry(otherActor));
		}

		return ret;
	}

	q.HD_getActorOverlayEntry <- function( _actor )
	{
		local entry = {
			id = _actor.getID(),
			chanceToBeHit = _actor.HD_getChanceToBeHit(),
			visible = false,
		};

		if (entry.chanceToBeHit != null && _actor.isPlacedOnMap())
		{
			local camera = ::Tactical.getCamera();
			local cameraPos = camera.getPos();
			local tile = _actor.getTile();

			entry.visible = true;
			entry.x <- (tile.Pos.X - cameraPos.X) / ::Tactical.getCamera().Zoom;
			entry.y <- (cameraPos.Y - tile.Pos.Y) / ::Tactical.getCamera().Zoom;
			entry.yOffset <- ::Math.max(tile.Level - camera.Level, 0) * 40.0 / camera.Zoom;
		}

		return entry;
	}
});
