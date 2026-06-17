::Hardened.HooksMod.hook("scripts/entity/world/settlements/situations/preparing_feast_situation", function(q) {
	q.onUpdateDraftList = @(__original) function( _draftList )
	{
		__original(_draftList);

		for (local i = _draftList.len() - 1; i >= 0; --i)
		{
			if (_draftList[i] == "servant_background" || _draftList[i] == "servant_southern_background" || _draftList[i] == "butcher_background" || _draftList[i] == "butcher_southern_background")
			{
				_draftList.remove(i);
			}
		}
	}
});
