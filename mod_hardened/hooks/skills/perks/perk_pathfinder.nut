::Hardened.HooksMod.hook("scripts/skills/perks/perk_pathfinder", function(q) {
	// Prevent pathfinder from adding sprint skill
	if (q.contains("onAdded")) delete q.onAdded;
	if (q.contains("onRemoved")) delete q.onRemoved;
});
