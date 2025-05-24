this.hd_goblin_racial <- this.inherit("scripts/skills/skill", {
	m = {
		ShieldMeleeDefensePct = 0.5,
		ShieldRangedDefensePct = 0.5,
	},

	function create()
	{
		this.m.ID = "racial.HD_goblin";
		this.m.Name = "Goblin";
		this.m.Description = "This character is a goblin.";
		this.m.Icon = "ui/orientation/goblin_01_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/sturdiness.png",
			text = ::Reforged.Mod.Tooltips.parseString("Can use [Shieldwall|Skill+shieldwall] with any shield"),
		});

		if (this.m.ShieldMeleeDefensePct != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizePct(this.m.ShieldMeleeDefensePct) + " more [Melee Defense|Concept.MeleeDefense] from equipped shield"),
			});
		}

		if (this.m.ShieldRangedDefensePct != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizePct(this.m.ShieldRangedDefensePct) + " more [Ranged Defense|Concept.RangeDefense] from equipped shield"),
			});
		}

		return ret;
	}

	function onAdded()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null) this.onEquip(shield);
	}

	function onEquip( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Shield))
		{
			_item.addSkill(::new("scripts/skills/actives/shieldwall"));	// Always add shieldwall
		}
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
