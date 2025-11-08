::Hardened.HooksMod.hook("scripts/skills/actives/coat_with_poison_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Name = "Use Goblin Poison";	// Vanilla: Use Poison
	}}.create;

	// Overwrite, because we don't grant any AP discount during the first Round
	q.onAfterUpdate = @() function( _properties ) {}
});
