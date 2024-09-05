::Hardened.HooksMod.hook("scripts/skills/actives/shieldwall", function(q) {
	// Remove reforged shield sergeant effect
	q.onAfterUpdate = @() function( _properties ) {}
	q.onTurnStart = @() function() {}
	q.onTurnEnd = @() function() {}
});
