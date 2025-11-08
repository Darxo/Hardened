::Hardened.HooksMod.hook("scripts/skills/actives/coat_with_poison_skill", function(q) {
	// Overwrite, because we don't grant any AP discount during the first Round
	q.onAfterUpdate = @() function( _properties ) {}
});
