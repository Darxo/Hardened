/// Returns true, if the passed data looks like it belongs to a "minor save", e.g. an autosave or a quicksave
var isMinorSavegame = function( _data )
{
	if (_data == null) return false;

	if (_data["name"].search(/autosave/) !== -1) return true;
	if (_data["name"].search(/quicksave/) !== -1) return true;

	return false;
}

var oldCreateListCampaign = $.fn.createListCampaign;
$.fn.createListCampaign = function(_campaignData, _classes)
{
	var ret = oldCreateListCampaign.apply(this, arguments);

	if (isMinorSavegame(_campaignData))
	{
		ret.addClass('variant-minor');	// These campaign-entries now have a different style (less height)
	}

	return ret;
}
