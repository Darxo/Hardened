this.hd_grave_chill_effect <- ::inherit("scripts/skills/effects/rf_ethereal_shroud_effect", {
	m = {
	},

	function create()
	{
		this.rf_ethereal_shroud_effect.create();

		this.m.ID = "effects.hd_grave_chill";
		this.m.Name = "Grave Chill";
		this.m.Description = "A shroud of cold mist surrounds this character.";
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Melee attackers who inflict [Hitpoint|Concept.Hitpoints] damage to you, receive a stacking " + ::MSU.Text.colorPositive(2) + " turns of [$ $|Skill+chilled_effect]"),
		});

		return ret;
	}

	// Overwrite, because we apply a different effect
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && this.m.__IsBeingHitInMelee)
		{
			_attacker.getSkills().add(::new("scripts/skills/effects/chilled_effect"));
		}
	}
});
