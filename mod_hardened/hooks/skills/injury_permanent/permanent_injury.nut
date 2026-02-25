::Hardened.HooksMod.hookTree("scripts/skills/injury_permanent/permanent_injury", function(q) {
	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		__original(_properties);

		// Feat: Every injury, now also reduces the strength of that character by 10%. This value is mainly relevant for NPC world map decision making
		_properties.MV_StrengthMult *= 0.9;
	}}.onUpdate;
});
