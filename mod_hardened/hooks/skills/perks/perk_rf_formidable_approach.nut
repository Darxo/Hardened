::Hardened.wipeClass("scripts/skills/perks/perk_rf_formidable_approach");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_formidable_approach", function(q) {
	q.m.MeleeSkillBonus <- 15;

	q.create <- function()
	{
		this.m.ID = "perk.rf_formidable_approach";
		this.m.Name = ::Const.Strings.PerkName.RF_FormidableApproach;
		this.m.Description = ::Const.Strings.PerkDescription.RF_FormidableApproach;
		this.m.Icon = "ui/perks/rf_formidable_approach.png";
		this.m.Overlay = "rf_formidable_approach";
		// TODO: add IconMini
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	q.getTooltip <- function()
	{
		local tooltip = this.skill.getTooltip();

		if (this.requirementsMet())
		{
			foreach (enemyID in this.m.Enemies)
			{
				local enemy = ::Tactical.getEntityByID(enemyID);
				tooltip.push({
					id = 10,
					type = "text",
					icon = "ui/icons/damage_dealt.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MeleeSkillBonus, {AddSign = true}) + " [Melee Skill|Concept.MeleeSkill] against " + ::Const.UI.getColorizedEntityName(enemy)),
				})
			}
		}

		return tooltip;
	}

	q.isHidden <- function()
	{
		if (this.requirementsMet() == false) return true;

		return (this.m.Enemies.len() == 0);
	}

	q.onMovementFinished <- function( _tile )
	{
		if (this.requirementsMet() == false) return;

		local actor = this.getContainer().getActor();
		if (actor.m.CurrentMovementType == ::Const.Tactical.MovementType.Involuntary) return;	// Pushing/Pulling an enemy does not trigger formidable approach

		// MoraleCheck
		local adjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
		foreach (enemy in adjacentEnemies)
		{
			this.registerEnemy(enemy);
			if (actor.getHitpointsMax() > enemy.getHitpointsMax() && enemy.getMoraleState() == ::Const.MoraleState.Confident)
			{
				this.spawnIcon(this.m.Overlay, enemy.getTile());
				enemy.setMoraleState(::Const.MoraleState.Steady);
			}
		}
	}

	q.onDamageReceived <- function( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker != null && this.hasEnemy(_attacker))
		{
			this.unregisterEnemy(_attacker);
			this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		}
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (this.requirementsMet() == false) return;

		if (_skill.isAttack() && !_skill.isRanged() && _targetEntity != null && this.hasEnemy(_targetEntity))
		{
			_properties.MeleeSkill += this.m.MeleeSkillBonus;
		}
	}

// MSU Functions
	q.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		if (this.requirementsMet() == false) return;

		if (!_skill.isAttack() || _skill.isRanged() || !_targetTile.IsOccupiedByActor || !this.hasEnemy(_targetTile.getEntity()))
			return;

		_tooltip.push({
			icon = "ui/tooltips/positive.png",
			text = ::MSU.Text.colorPositive(this.m.MeleeSkillBonus + "% ") + this.getName()
		});
	}

	q.onOtherActorDeath <- function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		this.unregisterEnemy(_victim);
	}

	q.onCombatFinished <- function()
	{
		this.skill.onCombatFinished();
		this.m.Enemies.clear();
	}

// Hardened Functions
	// If _user is evaluating our value, potentially targeting us with _usedSkill, how would that change our perceived value for them?
	q.getQueryTargetMultAsTarget = @(__original) function( _user, _usedSkill = null )
	{
		local ret = __original(_user, _usedSkill);
		if (_usedSkill == null) return ret;

		if (_usedSkill.isAttack() && this.hasEnemy(_user))
		{
			ret *= 1.2;	// _user should try asap to remove themselves from the enemy list of FormidableApproach to remove the bonus hitchance
		}

		return ret;
	}

// New Private Functions
	q.requirementsMet <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();

		return (weapon != null && weapon.isItemType(::Const.Items.ItemType.TwoHanded));
	}

	q.registerEnemy <- function( _actor )
	{
		if (this.m.Enemies.find(_actor.getID()) == null)
		{
			this.m.Enemies.push(_actor.getID());
		}
	}

	q.unregisterEnemy <- function( _actor )
	{
		::MSU.Array.removeByValue(this.m.Enemies, _actor.getID());
	}

	q.hasEnemy <- function( _actor )
	{
		return this.m.Enemies.find(_actor.getID()) != null;
	}
});
