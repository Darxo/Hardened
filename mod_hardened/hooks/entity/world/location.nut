::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.TemporarilyShowingName <- false;	// is this location currently displaying its name?

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		if (!this.isAlliedWithPlayer())
		{
			if (!this.m.IsShowingDefenders)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "ui/orientation/player_01_orientation.png",
					text = "Hides defender",
				});
			}
			else if (this.m.HideDefenderAtNight)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "skills/status_effect_35.png",
					text = "Hides defender during night",
				});
			}
		}
		return ret;
	}

	q.setShowName = @(__original) function( _b )
	{
		__original(_b);

		if (_b && this.getDefenderSpawnList() != null && this.getResources() != 0 && ::Hardened.Mod.ModSettings.getSetting("DisplayLocationNumerals").getValue())
		{
			if (this.isShowingDefenders())
			{
				this.getTooltip();	// We call getTooltip, to force this location to spawn a defender line-up

				local nameWithNumeral = this.getName();
				if (this.getTroops().len() != 0)	// A location with 0 troops after getTooltip is called, is probably a special location, so the default name should show
				{
					nameWithNumeral += " (" + ::Hardened.Numerals.getNumeralString(this.getTroops().len(), true) + ")";
				}
				this.getLabel("name").Text = nameWithNumeral;
			}
			else
			{
				this.getLabel("name").Text = this.getName() + " (?)";
			}
		}
		else
		{
			this.getLabel("name").Text = this.getName();
		}
	}

	q.onSpawned = @(__original) function()
	{
		// We interecept the (hopefully) only rand roll using 20 and 100 as its arguments, and make it instead become a roll from 1 to 100
		// That will increase the chance for named weapons to be chosen to 40% and reduce the chance of any other type down to 20%
		local mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (vargv.len() == 2 && vargv[0] == 20 && vargv[1] == 100)
			{
				return { done = true, value = ::Math.rand(1, 100) };
			}
		});

		__original();

		mockObjectRand.cleanup();
	}
});
