::Hardened.HooksMod.hook("scripts/entity/world/settlements/situations/good_harvest_situation", function(q) {
	q.onUpdateDraftList = @(__original) function( _draftList )
	{
		__original(_draftList);

		for (local i = _draftList.len() - 1; i >= 0; --i)
		{
			if (_draftList[i] == "farmhand_background" || _draftList[i] == "miller_background" || _draftList[i] == "daytaler_background" || _draftList[i] == "daytaler_southern_background")
			{
				_draftList.remove(i);
			}
		}
	}
});
