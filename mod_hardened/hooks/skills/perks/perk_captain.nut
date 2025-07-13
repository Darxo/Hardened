::Hardened.HooksMod.hook("scripts/skills/perks/perk_captain", function(q) {
	q.m.TargetAttractionMult <- 1.5;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Similar to the Rally the Troops perk, this perk will make this character more attractive for NPCs to focus on
		_properties.TargetAttractionMult *= this.m.TargetAttractionMult;
	}
});
