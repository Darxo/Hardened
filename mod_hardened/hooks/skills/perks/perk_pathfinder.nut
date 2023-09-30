::mods_hookExactClass("skills/perks/perk_pathfinder", function (o) {
	// Prevent pathfinder from adding sprint skill
	if ("onAdded" in o) delete o.onAdded;
	if ("onRemoved" in o) delete o.onRemoved;
});
