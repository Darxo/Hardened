::Hardened.wipeClass("scripts/skills/perks/perk_rf_vanquisher", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_vanquisher", function(q) {
	// Public
	q.m.DamageReceivedTotalMult <- 0.75;

	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "perk_rf_vanquisher_mini";
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.DamageReceivedTotalMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = format("Take %s Damage", ::MSU.Text.colorizeMultWithText(this.m.DamageReceivedTotalMult, {InvertColor =true})),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to [Displacement|Concept.Displacement]"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		return ret;
	}

	q.isHidden <- function()
	{
		return !this.m.IsInEffect;
	}

	q.onAdded <- function()
	{
		this.getContainer().add(::new("scripts/skills/actives/rf_gain_ground_skill"));
	}

	q.onRemoved <- function()
	{
		this.getContainer().removeByID("actives.rf_gain_ground");
	}

	q.onUpdate <- function( _properties )
	{
		if (this.m.IsInEffect)
		{
			_properties.DamageReceivedTotalMult *= this.m.DamageReceivedTotalMult;
		}
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	q.onMovementFinished <- function()
	{
		local tile = this.getContainer().getActor().getTile();
		if (!this.m.IsInEffect && this.isTileValid(tile))
		{
			this.m.IsInEffect = true;
			this.spawnIcon("perk_rf_vanquisher", tile);
		}
	}

	q.onTurnStart <- function()
	{
		this.m.IsInEffect = false;
	}

	q.onCombatFinished <- function()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

// MSU Functions
	q.onQueryTileTooltip <- function( _tile, _tooltip )
	{
		if (this.isTileValid(_tile))
		{
			_tooltip.push({
				id = 90,
				type = "text",
				icon = this.getIcon(),
				text = "Can be used for " + ::MSU.Text.colorPositive(this.getName()),
			});
		}
	}

// New Functions
	q.isTileValid <- function( _tile )
	{
		if (_tile.IsCorpseSpawned && _tile.Properties.has("Corpse"))
		{
			local corpse = _tile.Properties.get("Corpse");
			if ("RoundAdded" in corpse)
			{
				return corpse.RoundAdded == ::Tactical.TurnSequenceBar.getCurrentRound();
			}
		}

		return false;
	}
});
