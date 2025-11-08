::Hardened.HooksMod.hookTree("scripts/items/weapons/named/named_weapon", function(q) {
	// We do this as a treehook as we can't guarantee that every weapon implementation calls the base function
	q.onPutIntoBag = @(__original) function()
	{
		__original();

		// Vanilla Fix: we assign a Name to a named weapon even if it is added to the bag.
		// In Vanilla that is only done during regular equipping and when it is added to any stash
		if (this.m.Name.len() == 0)
		{
			if (::Math.rand(1, 100) <= 25)
			{
				this.setName(this.getContainer().getActor().getName() + "\'s " + ::MSU.Array.rand(this.m.NameList));
			}
			else
			{
				this.setName(this.createRandomName());
			}
		}
	}
});
