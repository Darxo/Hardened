"use strict";
{	// Hooks
	Hardened.Hooks.TacticalScreenOrientationOverlayModule_create = TacticalScreenOrientationOverlayModule.prototype.create;
	TacticalScreenOrientationOverlayModule.prototype.create = function( _parentDiv )
	{
		Hardened.Hooks.TacticalScreenOrientationOverlayModule_create.call(this, _parentDiv);
		this.mHD_HitchanceOverlays = {};
	};

	Hardened.Hooks.TacticalScreenOrientationOverlayModule_addOverlay = TacticalScreenOrientationOverlayModule.prototype.addOverlay;
	TacticalScreenOrientationOverlayModule.prototype.addOverlay = function( _overlay )
	{
		Hardened.Hooks.TacticalScreenOrientationOverlayModule_addOverlay.call(this, _overlay);

		if (_overlay === null || typeof(_overlay) !== 'object') return;
		if (!(TacticalScreenIdentifier.OrientationOverlay.Id in _overlay)) return;

		// Everytime that Vanilla creates an overlay for an actor, we use that chance and also create a hitchance label for them
		if (this.HD_findHitchanceOverlayById(_overlay[TacticalScreenIdentifier.OrientationOverlay.Id]) === null)
		{
			var overlayDiv = this.HD_createHitchanceOverlayDIV(_overlay);
			this.mHD_HitchanceOverlays[_overlay[TacticalScreenIdentifier.OrientationOverlay.Id]] = overlayDiv;
			this.mContainer.append(overlayDiv);
		}
	};

	Hardened.Hooks.TacticalScreenOrientationOverlayModule_removeOverlay = TacticalScreenOrientationOverlayModule.prototype.removeOverlay;
	TacticalScreenOrientationOverlayModule.prototype.removeOverlay = function( _overlay )
	{
		Hardened.Hooks.TacticalScreenOrientationOverlayModule_removeOverlay.call(this, _overlay);

		if (_overlay === null || typeof(_overlay) !== 'object') return;
		if (!(TacticalScreenIdentifier.OrientationOverlay.Id in _overlay)) return;

		// Everytime that Vanilla removes an overlay from an actor, we use that chance and also remove the corresponding hitchance label from them
		var overlayHitchanceDiv = this.HD_findHitchanceOverlayById(_overlay[TacticalScreenIdentifier.OrientationOverlay.Id]);
		if (overlayHitchanceDiv !== null)
		{
			overlayHitchanceDiv.remove();
			delete this.mHD_HitchanceOverlays[_overlay[TacticalScreenIdentifier.OrientationOverlay.Id]];
		}
		else
		{
			console.error('ERROR: Failed to remove overlay hitchance. Reason: Overlay not found.');
		}
	}

	Hardened.Hooks.TacticalScreenOrientationOverlayModule_removeOverlays = TacticalScreenOrientationOverlayModule.prototype.removeOverlays;
	TacticalScreenOrientationOverlayModule.prototype.removeOverlays = function()
	{
		Hardened.Hooks.TacticalScreenOrientationOverlayModule_removeOverlays.call(this);
		this.mHD_HitchanceOverlays = {};
	};
}

{	// New Functions
	TacticalScreenOrientationOverlayModule.prototype.HD_createHitchanceOverlayDIV = function ( _overlay )
	{
		var hitchanceOverlay = $('<div class="overlay hitchance-overlay is-enabled"/>');
		var label = $('<div class="overlay-label-debug"/>').text('???')
		hitchanceOverlay.append(label);
		hitchanceOverlay.data('overlayLabel', label);

		return hitchanceOverlay;
	};

	TacticalScreenOrientationOverlayModule.prototype.HD_findHitchanceOverlayById = function(_id)
	{
		if (_id in this.mHD_HitchanceOverlays)
		{
			return this.mHD_HitchanceOverlays[_id];
		}
		return null;
	};

	// Update a Hitchance overlay
	TacticalScreenOrientationOverlayModule.prototype.HD_updateHitchanceOverlay = function(_overlay)
	{
		if (_overlay === null || typeof(_overlay) !== 'object')
		{
			console.error('ERROR(Hardened): Failed to update hitchance overlay. Reason: Overlay data missing.');
			return;
		}

		if (!(TacticalScreenIdentifier.OrientationOverlay.Id in _overlay))
		{
			console.error('ERROR(Hardened): Failed to update hitchance overlay. Reason: Invalid overlay id.');
			return;
		}

		var overlayHitchanceDiv = this.HD_findHitchanceOverlayById(_overlay[TacticalScreenIdentifier.OrientationOverlay.Id]);
		if (overlayHitchanceDiv !== null)
		{
			if (TacticalScreenIdentifier.OrientationOverlay.PositionX in _overlay && TacticalScreenIdentifier.OrientationOverlay.PositionY in _overlay)
			{
				this.HD_updateHitchancePosition(overlayHitchanceDiv, _overlay);
			}

			if ("chanceToBeHit" in _overlay)
			{
				this.HD_updateHitchanceLabel(overlayHitchanceDiv, _overlay);
			}

			this.updateVisibility(overlayHitchanceDiv, _overlay);
		}
	}

	TacticalScreenOrientationOverlayModule.prototype.HD_updateHitchancePosition = function(_overlayDiv, _overlay)
	{
		var overlayLeft = _overlay[TacticalScreenIdentifier.OrientationOverlay.PositionX];
		var overlayTop = _overlay[TacticalScreenIdentifier.OrientationOverlay.PositionY];

		// The coordinates we get from squirrel are relative values (from 0, 0)
		// If we took them like that, we would position our labels at the top left corner, or relative to it
		// Since the Camera in BB is always in the center, we can easily calculate the offset and add it to get the correct position
		var containerWidth = this.mContainer.innerWidth();
		var containerHeight = this.mContainer.innerHeight();
		overlayLeft += (containerWidth / 2);
		overlayTop += (containerHeight / 2);

		// adjust y position (depending on camera level in relation to entity level)
		if (TacticalScreenIdentifier.OrientationOverlay.OffsetY in _overlay)
		{
			overlayTop += _overlay[TacticalScreenIdentifier.OrientationOverlay.OffsetY];
		}

		_overlayDiv.css({ top: overlayTop + 'px', left: overlayLeft + 'px' });
	};

	TacticalScreenOrientationOverlayModule.prototype.HD_updateHitchanceOverlays = function(_overlays)
	{
		if (_overlays === null || jQuery.isArray(_overlays) !== true)
		{
			console.error('ERROR(Hardened): Failed to update hitchance overlays. Reason: Overlay data is invalid.');
			return;
		}

		for (var i = 0; i < _overlays.length; ++i)
		{
			this.HD_updateHitchanceOverlay(_overlays[i]);
		}
	};

	TacticalScreenOrientationOverlayModule.prototype.HD_updateHitchanceLabel = function ( _overlayDiv, _overlay )
	{
		var $overlay = $(_overlayDiv);
		var $label = $overlay.data('overlayLabel');
		if ($label && $label.length > 0)
		{
			this.HD_customizeHitchanceText($label, _overlay);

			// Text adjustment
			$label.text(_overlay.chanceToBeHit + '%');
		}
		else
		{
			console.error("Hardened: label does not exist!");
		}
	}

	TacticalScreenOrientationOverlayModule.prototype.HD_customizeHitchanceText = function ( _overlayLabel, _overlay )
	{
		function HD_interpolateMultiColor(t)
		{
			var colors = [
				{ stop: 5, color: { r: 255, g: 30,  b: 0   } }, // red
				{ stop: 33, color: { r: 255, g: 132, b: 0   } }, // orange
				{ stop: 66, color: { r: 255, g: 234, b: 0   } }, // yellow
				{ stop: 95, color: { r: 192, g: 255, b: 0   } }  // green
			];
			if (t <= colors[0].stop) return colors[0].color;

			for (var i = 0; i < colors.length - 1; ++i)
			{
				var c1 = colors[i];
				var c2 = colors[i + 1];

				if (t >= c1.stop && t <= c2.stop)
				{
					var localT = (t - c1.stop) / (c2.stop - c1.stop);
					return {
						r: Math.round(c1.color.r + (c2.color.r - c1.color.r) * localT),
						g: Math.round(c1.color.g + (c2.color.g - c1.color.g) * localT),
						b: Math.round(c1.color.b + (c2.color.b - c1.color.b) * localT)
					};
				}
			}

			return colors[colors.length - 1].color;
		}

		// CSS adjustments depending on MSU Settings
		var colorScheme = MSU.getSettingValue("mod_hardened", "HitchanceOverlayColoring");
		if (colorScheme === "Green <-> Red")
		{
			var rgb = HD_interpolateMultiColor(_overlay.chanceToBeHit);
			var color = 'rgb(' + rgb.r + ',' + rgb.g + ',' + rgb.b + ')';
			_overlayLabel.css('color', color);
		}
		else if (colorScheme === "Black & White")
		{
			_overlayLabel.css('color', "#fff");	// The outline is already black
		}

		var fonzSize = MSU.getSettingValue("mod_hardened", "HitchanceOverlayFontSize");
		_overlayLabel.css('font-size', fonzSize + 'rem');	// The outline is already black
	}
}
