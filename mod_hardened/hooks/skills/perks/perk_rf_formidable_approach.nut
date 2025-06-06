::Hardened.wipeClass("scripts/skills/perks/perk_rf_formidable_approach", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_formidable_approach", function(q) {
	q.m.MeleeSkillBonus <- 15;

	q.create = @(__original) function()
	{
		__original();
		this.m.Overlay = "perk_rf_formidable_approach";
		this.m.IconMini = "perk_rf_formidable_approach_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
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
				});
			}
		}

		return tooltip;
	}

	q.isHidden <- function()
	{
		if (this.requirementsMet() == false) return true;

		return (this.m.Enemies.len() == 0);
	}

	q.onMovementFinished <- function()
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

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this effect removes targets from its list based on proximity

		this.validateEnemies();
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

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _target
		{
			if (_user.getID() != _target.getID()) return ret;		// _user and _target must not be the same

			if (_skill != null && _skill.isAttack() && this.hasEnemy(_user))
			{
				ret *= 1.2;	// _user should try asap to remove themselves from the enemy list of FormidableApproach to remove the bonus hitchance
			}
		}

		return ret;
	}

// New Private Functions
	q.requirementsMet <- function()
	{
		if (this.getContainer().getActor().isDisarmed()) return false;

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

	// Check whether all enemy in this.m.Enemies are still valid and unregister anyone who isn't anymore
	// A valid enemy must exist, be placed on the map and be adjacent to us
	q.validateEnemies <- function()
	{
		local areRequirementsMet = this.requirementsMet();	// If we dont even wield a two-handed weapon, then we lose the whole effect
		for (local index = this.m.Enemies.len() - 1; index >= 0; index--)
		{
			local enemy = ::Tactical.getEntityByID(this.m.Enemies[index]);
			if (!areRequirementsMet || ::MSU.isNull(enemy) || !enemy.isPlacedOnMap() || this.getContainer().getActor().getTile().getDistanceTo(enemy.getTile()) > 1)
			{
				this.m.Enemies.remove(index);	// We cant use unregisterEnemy here, because enemy might be null
			}
		}
	}
});
