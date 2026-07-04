::Hardened.HooksMod.hook("scripts/crafting/blueprints/paint_set_blueprint", function(q) {
	q.getName = @(__original) { function getName()
	{
		return __original() + " (x3)";	// We adjust the name of the recipe to communicate that you receive three of them
	}}.getName;

	q.onCraft = @(__original) { function onCraft( _stash )
	{
		__original(_stash);

		// crafting gives two additional yield over vanilla
		_stash.add(::new(::IO.scriptFilenameByHash(this.m.PreviewCraftable.ClassNameHash)));
		_stash.add(::new(::IO.scriptFilenameByHash(this.m.PreviewCraftable.ClassNameHash)));
	}}.onCraft;
});
