::Hardened.HooksMod.hook("scripts/ui/screens/tooltip/modules/tooltip", function(q) {
	q.hide = @(__original) function()
	{
		::Const.Faction.Player = 1;		// Revert Switcheroo from tactical_state
		__original();
	}
});
