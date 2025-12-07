// The modular vanilla hook for this perk is being sniped in
::Hardened.HooksMod.hook("scripts/skills/actives/reload_handgonne_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 7;		// Vanilla: 9
		this.m.FatigueCost = 25;		// Vanilla: 20

	// Hardened
		this.m.HD_IsUnique = true;		// Vanilla adds this skill multiple times over the course of a battle. We only ever want one instance to prevent a MSU log spam about FatigueCost
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		this.getContainer().add(::new("scripts/skills/effects/hd_reload_disorientation_effect"));
		return __original(_user, _targetTile);
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local reloadDisorientationEffect = ::new("scripts/skills/effects/hd_reload_disorientation_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [Reload Orientation|Skill+hd_reload_disorientation_effect]"),
			children = reloadDisorientationEffect.getTooltip().slice(2),	// Remove name and description tooltip lines
		});

		return ret;
	}
});
