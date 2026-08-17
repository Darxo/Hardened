::Reforged.TacticalTooltip.getReachElement = function( _actor )
{
	local reachImg = "[img]gfx/ui/icons/rf_reach.png[/img]";
	local currentProperties = _actor.getCurrentProperties();
	if (currentProperties.IsAffectedByReach)
	{
		return format("<span class='rf_tacticalTooltipReach'>%s %i %s</span>", reachImg, currentProperties.getReach(), ::Reforged.Mod.Tooltips.parseString("[Reach|Concept.Reach]"));
	}
	else
	{
		return format("<span class='rf_tacticalTooltipReach'>%s Unaffected</span>", reachImg);
	}
}

local oldGetVisionElement = ::Reforged.TacticalTooltip.getVisionElement;
::Reforged.TacticalTooltip.getVisionElement = function( _actor )
{
	// Fix: Remove unwanted non-breaking spaces from actor tooltip elements
	// They get added by our hook of ::MSU.Text.color
	local ret = oldGetVisionElement(_actor);
	return ::MSU.String.replace(ret, "&nbsp", "", true);
}

local oldGetTooltipAttributesSmall = ::Reforged.TacticalTooltip.getTooltipAttributesSmall;
::Reforged.TacticalTooltip.getTooltipAttributesSmall = function( _actor, _startID )
{
	// Fix: Remove unwanted non-breaking spaces from actor tooltip elements
	// They get added by our hook of ::MSU.Text.color
	local ret = oldGetTooltipAttributesSmall(_actor, _startID);
	ret.text = ::MSU.String.replace(ret.text, "&nbsp", "", true);
	return ret;
}
