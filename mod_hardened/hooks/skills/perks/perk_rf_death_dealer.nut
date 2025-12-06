::Hardened.wipeClass("scripts/skills/perks/perk_rf_death_dealer", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_death_dealer", function(q) {
	// Public
	q.m.DamagePctPerEnemy <- 0.05;
	q.m.TileDistance <- 2;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Like wheat before a scythe!";
		this.addType(::Const.SkillType.StatusEffect);	// We add StatusEffect so that this perk can produce a status effect icon
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		local damageMult = this.getDamageMult();
		if (damageMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::Reforged.Mod.Tooltips.parseString("AoE Attacks deal " + ::MSU.Text.colorizeMultWithText(damageMult) + " Damage"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return this.getDamageMult() == 1.0;
	}

	q.onUpdate <- function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because our bonus is applied depending on how many nearby enemies there are
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.DamageTotalMult *= this.getDamageMult();
		}
	}

	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);

		if (!this.isSkillValid(_skill)) return;

		local actor = _skill.getContainer().getActor();
		local removedRootEffect = ::Const.Tactical.Common.removeRooted(actor);
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " breaks free from " + ::MSU.Text.colorNegative(removedRootEffect.getName()));
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill.isAttack() && _skill.isAOE();
	}

	q.getDamageMult <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 1.0;
		local numNearbyEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), this.m.TileDistance, false).len();
		return 1.0 + numNearbyEnemies * this.m.DamagePctPerEnemy;
	}
});
