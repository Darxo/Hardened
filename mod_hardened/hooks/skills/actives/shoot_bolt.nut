::Hardened.HooksMod.hook("scripts/skills/actives/shoot_bolt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy = 25;		// Reforged: 15

	// Hardened
		// Feat: We change it so shoot_bolt no longer works, while engaged in melee
		this.m.HD_UsableWhileEngagedInMelee = false;
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
