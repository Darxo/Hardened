::Hardened.HooksMod.hook("scripts/skills/actives/lunge_skill", function(q) {
	// Public
	q.m.HD_DamageTotalMultMin <- 0.0;	// Lunge will never deal less damage than this value
	q.m.HD_DamageTotalMultMax <- 1.75;	// Lunge will never deal more damage than this value
	q.m.HD_DamageTotalPctPerInitiative <- 0.01;		// Lunge will deal this much more/less damage per Initiative above/below HD_InitiativeBaseValue
	q.m.HD_InitiativeBaseValue <- 100;		// Any point of initiative above or below this value, will trigger DamageTotalPctPerInitiative in the respective direction

	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus = -10;	// Reforged: -20
		this.m.HD_IgnoreForCrowded = true;	// This skill moves during its execution ending with a regular attack on an adjacent tile so we exclude it from crowded
	}

	// Overwrite, because we write a all tooltips different from Reforged
	q.getTooltip = @() function()
	{
		local ret = this.getDefaultTooltip();

		// Remove the existing tooltips
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			// We remove the tooltips about
			if (entry.id == 6 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
			}
		}

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Move next to your target before attacking, ignoring [Zone of Control|Concept.ZoneOfControl]"),
		});

		if (this.m.HD_DamageTotalPctPerInitiative != 0.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorizePct(this.m.HD_DamageTotalPctPerInitiative) + " more Damage for every [Initiative|Concept.Initiative] you have above " + ::MSU.Text.colorPositive(this.m.HD_InitiativeBaseValue) + ", up to a maximum of " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageTotalMultMax)),
			});

			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorizePct(this.m.HD_DamageTotalPctPerInitiative, {InvertColor = true}) + " less Damage for every [Initiative|Concept.Initiative] you have below " + ::MSU.Text.colorPositive(this.m.HD_InitiativeBaseValue) + ", down to a minimum of " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageTotalMultMin)),
			});
		}

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has " + ::MSU.Text.colorizeValue(this.m.HitChanceBonus, {AddSign = true, AddPercent = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitchance|Concept.Hitchance]"),
		});

		return ret;
	}

	// Overwrite, because we
	//	- make the damage formular more moddable and more readable
	//	- remove Reforged hitchance bonus for NPCs
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local relativeInitaitive = this.getContainer().getActor().getInitiative() - this.m.HD_InitiativeBaseValue;
			local damageMult = 1.0 + relativeInitaitive * this.m.HD_DamageTotalPctPerInitiative;
			damageMult = ::Math.clampf(damageMult, this.m.HD_DamageTotalMultMin, this.m.HD_DamageTotalMultMax);
			_properties.DamageTotalMult *= damageMult;

			_properties.MeleeSkill += this.m.HitChanceBonus;
		}
	}
});
