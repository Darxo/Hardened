::Hardened.HooksMod.hook("scripts/entity/world/settlements/situations/rebuilding_effort_situation", function(q) {
	q.onUpdateDraftList = @(__original) function( _draftList )
	{
		__original(_draftList);

		for (local i = _draftList.len() - 1; i >= 0; --i)
		{
			if (_draftList[i] == "mason_background" || _draftList[i] == "lumberjack_background")
			{
				_draftList.remove(i);
			}
		}
	}
});
