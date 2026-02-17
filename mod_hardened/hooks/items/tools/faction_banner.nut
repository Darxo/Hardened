::Hardened.HooksMod.hook("scripts/items/tools/faction_banner", function(q) {
	// Overwrite, because we no longer grant "For the Realm" effect to enemies who carry a banner
	q.onCombatStarted = @() { function onCombatStarted()
	{
	}}.onCombatStarted;
});
