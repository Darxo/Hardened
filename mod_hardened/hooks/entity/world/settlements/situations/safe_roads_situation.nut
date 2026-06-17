::Hardened.HooksMod.hook("scripts/entity/world/settlements/situations/safe_roads_situation", function(q) {
	q.onUpdateDraftList = @(__original) function( _draftList )
	{
		__original(_draftList);

		for (local i = _draftList.len() - 1; i >= 0; --i)
		{
			if (_draftList[i] == "caravan_hand_background" || _draftList[i] == "caravan_hand_southern_background" || _draftList[i] == "peddler_background" || _draftList[i] == "peddler_southern_background")
			{
				_draftList.remove(i);
			}
		}
	}
});
