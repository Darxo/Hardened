::Hardened.HooksMod.hook("scripts/skills/effects/poison_coat_effect", function (q) {
	// Public
	q.m.HitpointDamageThreshold <- ::Const.Combat.PoisonEffectMinDamage;	// The poison is only applied when dealing at least this much hitpoint damage

	q.create = @(__original) { function create()
	{
		__original();
		this.m.Name = "Coated in Goblin Poison";	// Vanilla: Weapon coated with poison
		this.m.Description = "This character coated his weapons with a goblin poison.";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav",
		];
	}}.create;

	// Overwrite, because we want to revert Vanillas attempt at a semi-dynamic description tooltip
	q.getDescription = @() function()
	{
		return this.skill.getDescription();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local poisonEffect = ::new("scripts/skills/effects/goblin_poison_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_received.png",
			text = "Your Weapon Attacks, which deal at least " + ::MSU.Text.colorNeutral(this.m.HitpointDamageThreshold) + ::Reforged.Mod.Tooltips.parseString(" [Hitpoint|Concept.Hitpoints] damage, apply [Poisoned (Goblin)|Skill+goblin_poison_effect]"),
			children = poisonEffect.getTooltipWithoutChildren().slice(2),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Lasts for " + ::MSU.Text.colorPositive(this.m.AttacksLeft) + " Weapon Attacks",
		});

		return ret;
	}

	// Overwrite, because we prefer we remove the condition about undead
	// Our changes are:
	//	- we make the hitpoint threshold moddable
	//	- only uses a charge if skill was a Weapon Attack
	//	- having the "Undead" flag no longer makes you immune to this poison
	//	- remove 1.5 volume multiplier from sound effect
	//	- the _skill must be an attack from a weapon
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!this.isSkillValid(_skill)) return;

		--this.m.AttacksLeft;
		if (this.m.AttacksLeft <= 0) this.removeSelf();

		if (!_targetEntity.isAlive() || _targetEntity.getHitpoints() <= 0) return;
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison) return;
		if (_damageInflictedHitpoints < this.m.HitpointDamageThreshold) return;

		this.inflictPoison(_targetEntity);
	}

	// Overwrite, because we make the conditions for using charges a bit more strict
	q.onTargetMissed = @() function( _skill, _targetEntity )
	{
		if (!this.isSkillValid(_skill)) return;

		--this.m.AttacksLeft;
		if (this.m.AttacksLeft <= 0) this.removeSelf();
	}

// MSU Events
	q.onQueryTooltip = @() function( _skill, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will apply [Poisoned (Goblin),|Skill+goblin_poison_effect] when dealing at least ") + ::MSU.Text.colorNeutral(this.m.HitpointDamageThreshold) + ::Reforged.Mod.Tooltips.parseString(" [Hitpoint|Concept.Hitpoints] damage"),
			});
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;
		local item = _skill.getItem();
		if (::MSU.isNull(item)) return false;
		if (!item.isItemType(::Const.Items.ItemType.Weapon)) return false;

		return true;
	}

	q.inflictPoison <- function( _targetEntity )
	{
		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect, _targetEntity.getPos())
			}

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		local poison = _targetEntity.getSkills().getSkillByID("effects.goblin_poison");
		if (poison == null)
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/goblin_poison_effect"));
		}
		else
		{
			poison.resetTime();
		}
	}
});
