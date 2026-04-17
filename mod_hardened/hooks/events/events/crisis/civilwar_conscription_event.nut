::Hardened.HooksMod.hook("scripts/events/events/crisis/civilwar_conscription_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "B")
			{
				// Feat: We double the Relation gained from this event path, resulting in +7.5 Relation (up from +2.5)
				local oldStart = screen.start;
				screen.start = function ( _event )
				{
					local oldRelationNobleContractSuccess = ::Const.World.Assets.RelationNobleContractSuccess;
					::Const.World.Assets.RelationNobleContractSuccess *= 2;
					oldStart(_event);
					::Const.World.Assets.RelationNobleContractSuccess = oldRelationNobleContractSuccess;
				}
				break;
			}
		}
	}
});
