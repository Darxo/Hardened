::mods_hookExactClass("skills/effects/dodge_effect", function (o) {
    o.m.MeleeDefenseModifier <- -10;
    o.m.InitiativeToDefenseMultiplier <- 0.2;

	o.getTooltip = function()
	{
		local bonus = ::Math.floor(this.getContainer().getActor().getInitiative() * this.m.InitiativeToDefenseMultiplier);
        local ret = this.skill.getTooltip();
        ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::MSU.Text.colorizeValue(::Math.max(0, bonus + this.m.MeleeDefenseModifier)) + " Melee Defense"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::MSU.Text.colorizeValue(bonus) + " Ranged Defense"
			}
        ]);
        return ret;
	}

    o.onAfterUpdate = function( _properties )   // Overwrite because I replace both effects
    {
		local bonus = ::Math.floor(this.getContainer().getActor().getInitiative() * this.m.InitiativeToDefenseMultiplier);
		_properties.MeleeDefense += ::Math.max(0, bonus + this.m.MeleeDefenseModifier);
		_properties.RangedDefense += ::Math.max(0, bonus);
    }
});
