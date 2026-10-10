::Hardened.HooksMod.hook("scripts/skills/effects/goblin_poison_effect", function (q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Poisoned (Goblin)";		// Vanilla: Poisoned

		this.m.HD_IsPoison = true;
		this.m.HD_PreventedByProperties = ["IsImmuneToPoison"];
	}

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = this.__original();

		// Feat: hide tooltip about initiative debuff
		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			return _entry.icon == "ui/icons/initiative.png";
		});

		return ret;
	}}.getTooltip;

	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		// Feat: remove initiative debuff from this poison
		local oldInitiative = _properties.Initiative;
		__original(_properties);
		_properties.Initiative = oldInitiative;
	}}.onUpdate;
});
