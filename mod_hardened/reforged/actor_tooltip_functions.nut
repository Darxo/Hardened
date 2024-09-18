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
