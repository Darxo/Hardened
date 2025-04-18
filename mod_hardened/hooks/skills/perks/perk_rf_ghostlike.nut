::Hardened.wipeClass("scripts/skills/perks/perk_rf_ghostlike", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_ghostlike", function(q) {
	// Public
	q.m.ResolveAsMeleeDefensePct <- 0.5;
	q.m.DamageTotalMult = 1.15;
	q.m.DirectDamageModifier = 0.15;

	// Private
	q.m.IsInEffect <- false;

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.IsInEffect)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " Damage when attacking adjacent targets",
			});

			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizePct(this.m.DirectDamageModifier, {AddSign = true}) + " [Armor Penetration|Concept.ArmorPenetration] when attacking adjacent targets"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return !this.m.IsInEffect;
	}

	q.onAfterUpdate <- function( _properties )
	{
		_properties.MeleeDefense += this.getMeleeDefenseModifier(_properties);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (this.m.IsInEffect && _targetEntity != null && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) <= 1)
		{
			_properties.DamageDirectAdd += this.m.DirectDamageModifier;
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
		}
	}

	q.onTurnStart <- function()
	{
		local actor = this.getContainer().getActor();
		local adjacentHostileCount = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true).len();
		if (adjacentHostileCount == 0)
		{
			this.m.IsInEffect = true;
		}
	}

	q.onResumeTurn <- function()
	{
		this.onTurnStart();
	}

	q.onTurnEnd <- function()
	{
		this.m.IsInEffect = false;
	}

	q.onWaitTurn <- function()
	{
		this.m.IsInEffect = false;
	}

// MSU Functions
	q.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		if (this.m.IsInEffect && !_targetTile.IsEmpty && _targetTile.IsOccupiedByActor && this.getContainer().getActor().getTile().getDistanceTo(_targetTile) <= 1)
		{
			_tooltip.push({
				icon = "ui/icons/damage_dealt.png",
				text = this.getName(),
			});
		}
	}

// New Functions
	q.getMeleeDefenseModifier <- function( _properties )
	{
		if (this.getContainer().getActor().isActiveEntity())
		{
			return ::Math.ceil(_properties.getBravery() * this.m.ResolveAsMeleeDefensePct);
		}

		return 0;
	}
});
