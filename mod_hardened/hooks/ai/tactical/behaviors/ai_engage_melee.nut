::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_engage_melee", function(q) {
	q.onExecute = @(__original) function( _entity )
	{
		if (this.m.TargetTile == null || _entity.getTile().getDistanceTo(this.m.TargetTile) > 1)
		{
			return __original(_entity);
		}

		// Swichertoo to make NPCs ignore the state of PreferWait, if their engage_melee destination is adjacent to them
		// This is supposed to improve situations where NPCs with PreferWait would otherwise start their turn 2 tiles from an enemy, and wait, instead of engaging right away,
		// Due to the close distance, the enemy can then immediately punish that waiting and kill the NPC before they can do anything
		local oldPreferWait = this.getProperties().PreferWait;
		this.getProperties().PreferWait = false;
		local ret = __original(_entity);
		this.getProperties().PreferWait = oldPreferWait;

		return ret;
	}
});
