::Hardened.HooksMod.hook("scripts/skills/backgrounds/paladin_background", function(q) {
	q.getPerkGroupCollectionMin = @(__original) function( _collection )
	{
		switch (_collection.getID())
		{
			case "pgc.rf_weapon":
				return _collection.getMin() + 1;
		}
		return __original(_collection);
	}
});
