// Since All types of unhold inherit from the base unhold script, the following will affect all unhold variants
::Hardened.HooksMod.hookTree("scripts/entity/tactical/enemies/unhold", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = ::Const.Strings.EntityName[this.m.Type];	// Unhold Names during combat now reflect their names on the world map instead of all being called "Unhold"
	}
});

