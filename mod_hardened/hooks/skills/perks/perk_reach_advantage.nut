::Hardened.wipeClass("scripts/skills/perks/perk_reach_advantage");

// This unused Vanilla perk is hijacked an renamed into "Parry"
::Hardened.HooksMod.hook("scripts/skills/perks/perk_reach_advantage", function(q) {
	// Public
	q.m.BaseRangeDefenseAsMeleeDefensePct <- 1.0;	// This much of the Base Ranged Defense is added to Melee Defense while engaged with a
	q.m.RangedDefenseMultWhenEngaged <- 0.3;

	// Private
	q.m.OriginalIconMini <- "perk_hd_parry_mini";
	q.m.SoundOnParry <- ::Const.Sound.ShieldHitMetal;

	q.create <- function()
	{
		this.m.ID = "perk.reach_advantage";
		this.m.Name = this.Const.Strings.PerkName.ReachAdvantage;
		this.m.Description = "Your attention is fully on deflecting weapon strikes, making it potentially harder to guard against distant threats.";
		this.m.Icon = "ui/perks/perk_hd_parry.png";
		this.m.IconMini = "";
		this.m.Type = ::Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		local meleeDefenseModifier = this.getMeleeDefenseModifier();
		if (meleeDefenseModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizeValue(meleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense] against melee attacks"),
			});
		}

		if (this.m.RangedDefenseMultWhenEngaged != 1.0 && this.isEnabledRangedLoss())
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMultWhenEngaged) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return !this.__isEnabled();
	}

	q.onUpdate <- function( _properties )
	{
		if (this.isEnabledRangedLoss())
		{
			_properties.RangedDefenseMult *= this.m.RangedDefenseMultWhenEngaged;
			this.m.IconMini = this.m.OriginalIconMini;
		}
		else
		{
			this.m.IconMini = "";
		}
	}

	q.onBeingAttacked <- function( _attacker, _skill, _properties )
	{
		if (this.isSkillParryable(_skill))
		{
			_properties.MeleeDefense += this.getMeleeDefenseModifier();
		}
	}

	q.onMissed <- function( _attacker, _skill )
	{
		if (::Hardened.Temp.LastAttackInfo != null)
		{
			if (this.isSkillParryable(_skill))
			{
				// parryChance is an approximation of how much this perk contributed to us dodging. It's not accurate because vanilla halves the melee defense above 50
				local parryChance = ::Math.round(this.getMeleeDefenseModifier() * ::Hardened.Temp.LastAttackInfo.TargetProperties.MeleeDefenseMult);

				// Our Parry perk was the deciding factor to make us dodge this attack
				if (::Hardened.Temp.LastAttackInfo.Roll - parryChance <= ::Hardened.Temp.LastAttackInfo.ChanceToHit)
				{
					local actor = this.getContainer().getActor();
					::Sound.play(::MSU.Array.rand(this.m.SoundOnParry), ::Const.Sound.Volume.Skill, actor.getPos());
				}
			}
		}
	}

// New Functions
	q.getMeleeDefenseModifier <- function()
	{
		local meleeDefenseModifier = this.getContainer().getActor().getBaseProperties().RangedDefense * this.m.BaseRangeDefenseAsMeleeDefensePct;
		return ::Math.max(0, ::Math.round(meleeDefenseModifier));
	}

	// Requirements for the Ranged Defense reduction to be active
	q.isEnabledRangedLoss <- function()
	{
		if (!this.__isEnabled()) return false;

		// Check, if we are adjacent to another person with a melee weapon
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap())
		{
			local adjacentHostile = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
			foreach (enemy in adjacentHostile)
			{
				local mainhandItem = enemy.getMainhandItem();
				if (mainhandItem != null && mainhandItem.isItemType(::Const.Items.ItemType.MeleeWeapon))
				{
					return true;
				}
			}
		}
		return false;
	}

	// Requirements for an incoming skill to trigger the Melee Defense Bonus
	q.isSkillParryable <- function( _skill )
	{
		if (!this.__isEnabled()) return false;

		local item = _skill.getItem();
		if (item != null && item.isItemType(::Const.Items.ItemType.MeleeWeapon) && _skill.isAttack())
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	// Minimum shared requirements for any of this perks effects to work
	q.__isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) return false;
		if (actor.getCurrentProperties().IsStunned) return false;
		if (actor.isDisarmed()) return false;
		if (actor.isArmedWithShield()) return false;

		local mainhandItem = actor.getMainhandItem();
		if (mainhandItem == null || !mainhandItem.isItemType(::Const.Items.ItemType.MeleeWeapon)) return false;	// User needs a melee weapon equipped

		return true;
	}
});
