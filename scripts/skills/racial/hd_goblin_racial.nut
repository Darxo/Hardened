this.hd_goblin_racial <- this.inherit("scripts/skills/skill", {
	m = {
		ShieldMeleeDefensePct = 0.5,
		ShieldRangedDefensePct = 0.5,
	},

	function create()
	{
		this.m.ID = "racial.goblin";
		this.m.Name = "Goblin";
		this.m.Icon = "ui/orientation/goblin_01_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ShieldMeleeDefensePct != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Gain " + ::MSU.Text.colorizePct(this.m.ShieldMeleeDefensePct) + " more Melee Defense from equipped shield",
			});
		}

		if (this.m.ShieldRangedDefensePct != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Gain " + ::MSU.Text.colorizePct(this.m.ShieldRangedDefensePct) + " more Ranged Defense from equipped shield",
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isArmedWithShield())
		{
			local shield = this.getContainer().getActor().getOffhandItem();
			_properties.MeleeDefense += ::Math.floor(shield.getMeleeDefenseBonus() * this.m.ShieldMeleeDefensePct);
			_properties.RangedDefense += ::Math.floor(shield.getRangedDefenseBonus() * this.m.ShieldRangedDefensePct);
		}
	}
});
