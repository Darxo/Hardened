this.hd_skill_ignore_accessory_effect <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.hd_skill_ignore_accessory";
		this.m.Name = "Skill Ignore Accessory Effect (Hidden)";
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = this.skill.getQueryTargetValueMult(_user, _target, _skill);

		if (_skill == null) return ret;
		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _target
		{
			if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

			foreach (skillID in this.getItem().m.HD_SkillsToIgnore)
			{
				if (_skill.getID() == skillID)
				{
					ret *= this.getItem().m.HD_SkillValueMult;
				}
			}
		}

		return ret;
	}
});
