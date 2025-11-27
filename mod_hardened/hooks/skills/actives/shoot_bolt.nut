::Hardened.HooksMod.hook("scripts/skills/actives/shoot_bolt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy = 25;		// Reforged: 15
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

		// Copy of how vanilla adds the reload skill duing onUse
		this.getItem().addSkill(::new("scripts/skills/actives/reload_bolt"));
	}
});
