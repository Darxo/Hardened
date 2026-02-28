::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/flesh_cradle", function(q) {
// Reforged Functions
	q.getLootForTile = @(__original) function( _killer, _loot )
	{
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			_loot.push(this.new("scripts/items/supplies/strange_meat_item"));
		}

		return __original(_killer, _loot);
	}
});
