
// Vanilla Fix: We reduce the scroll speed of the origin list to 0.5 (down from 5)
Hardened.Hooks.NewCampaignMenuModule_buildOriginSelectionPanel = NewCampaignMenuModule.prototype.buildOriginSelectionPanel;
NewCampaignMenuModule.prototype.buildOriginSelectionPanel = function ( _container )
{
	// We switcheroo the jquery createList function as that is the simplest way to switch out the high vanilla delta with a smaller one
	var oldCreateList = $.fn.createList;
	$.fn.createList = function(_scrollDelta, _classes, _withoutFrame)
	{
		return oldCreateList.call(this, 0.5, _classes, _withoutFrame);
	};

	Hardened.Hooks.NewCampaignMenuModule_buildOriginSelectionPanel.call(this, _container);

	$.fn.createList = oldCreateList;
}
