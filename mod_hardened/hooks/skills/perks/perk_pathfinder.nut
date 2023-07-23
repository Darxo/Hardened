::mods_hookExactClass("skills/perks/perk_pathfinder", function (o) {
	// Prevent pathfinder from adding sprint skill
	o.onAdded = function() {}
	o.onRemoved = function() {}
});
