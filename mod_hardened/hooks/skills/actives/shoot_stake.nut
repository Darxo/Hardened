::Hardened.HooksMod.hook("scripts/skills/actives/shoot_stake", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description += ::Reforged.Mod.Tooltips.parseString(" Can not be used while [engaged in melee|Concept.ZoneOfControl].");
		this.m.AdditionalAccuracy = 20;	// Reforged: 10
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local actor = this.getContainer().getActor();
		if (::Tactical.isActive() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 40,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can not be used because this character is [engaged in melee|Concept.ZoneOfControl]"),
			});
		}

		return ret;
	}

	q.isUsable = @(__original) function()
	{
		// We change it so shoot_stake no longer works, while engaged in melee
		return __original() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		// We prevent Vanilla from adding the reload skill at this point, as in Hardened it is always present
		local mockObject = ::Hardened.mockFunction(this.getContainer(), "add", function( _skillToAdd ) {
			if (_skillToAdd.getID() == "actives.reload_bolt")
			{
				// We just prevent this skill addition, nothing more
				return { done = true, value = null };
			}
		});

		local ret = __original(_user, _targetTile);

		mockObject.cleanup();

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// Don't add skill for the dummy player to prevent duplicate reload skills
		if (!::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			this.getItem().addSkill(::new("scripts/skills/actives/reload_bolt"));
		}
	}
});
