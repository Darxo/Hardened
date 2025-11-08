::Hardened.HooksMod.hook("scripts/skills/effects/spider_poison_coat_effect", function (q) {
	q.m.HitpointDamagePerTurn <- 10;	// Vanilla: 10; In Vanilla the regular spider poison deals only 5 damage per turn
	q.m.HitpointDamageThreshold <- ::Const.Combat.PoisonEffectMinDamage;	// The poison is only applied when dealing at least this much hitpoint damage

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Coated in Spider Poison";		// Vanilla: Weapon coated with poison
		this.m.Description = "Your weapons are coated with concentrated webknecht poison.";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav",
		];
	}

	// Overwrite, because we prefer a static description
	q.getDescription = @() function()
	{
		return this.skill.getDescription();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_dealt.png",
			text = ::Reforged.Mod.Tooltips.parseString("Your Weapon Attacks, which deal at least " + ::MSU.Text.colorPositive(this.m.HitpointDamageThreshold) + " [Hitpoint|Concept.Hitpoints] damage, apply [Poisoned (Spider)|Skill+hd_spider_poison_effect_item]"),
			children = this.createSpiderPoisonEffect().getTooltipWithoutChildren().slice(2),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Lasts for " + ::MSU.Text.colorPositive(this.m.AttacksLeft) + " Attacks",
		});

		return ret;
	}

	// Overwrite, because we make
	//	- the hitpoint threshold moddable,
	//	- simplify the conditions
	//	- require the skill to be a weapon skill
	//	- trigger a seperat helper function for applying the actual effect
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_skill.isAttack()) return;

		local item = _skill.getItem();
		if (::MSU.isNull(item)) return;
		if (!item.isItemType(::Const.Items.ItemType.Weapon)) return;

		--this.m.AttacksLeft;
		if (this.m.AttacksLeft <= 0) this.removeSelf();

		if (!_targetEntity.isAlive() || _targetEntity.getHitpoints() <= 0) return;
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison) return;
		if (_damageInflictedHitpoints < this.m.HitpointDamageThreshold) return;

		this.inflictPoison(_targetEntity);
	}

// New Functions
	q.inflictPoison <- function( _targetEntity )
	{
		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
			}

			::Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		_targetEntity.getSkills().add(this.createSpiderPoisonEffect());
	}

	// Create a new spider poison effect how it would be then inflicted on our target
	q.createSpiderPoisonEffect <- function()
	{
		local poisonEffect = ::new("scripts/skills/effects/spider_poison_effect");
		poisonEffect.setDamage(this.m.HitpointDamagePerTurn);
		return poisonEffect;
	}
});
