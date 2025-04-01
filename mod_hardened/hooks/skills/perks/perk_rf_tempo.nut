::Hardened.wipeClass("scripts/skills/perks/perk_rf_tempo", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_tempo", function(q) {
	// Public
	q.m.InitiativeModifierPerTile <- 15;
	q.m.IsForceEnabled <- false;

	// Private
	q.m.PrevTile <- null;	// Used to calculate distance when teleported
	q.m.TilesMoved <- 0;

	q.isHidden <- function()
	{
		if (!this.isEnabled()) return true;
		if (this.m.TilesMoved == 0) return true;
		return this.skill.isHidden();
	}

	q.getName <- function()
	{
		local name = this.m.Name;

		if (this.m.TilesMoved > 0)
		{
			name += " (x" + this.m.TilesMoved + ")";
		}

		return name;
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.getInitiativeModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getInitiativeModifier(), {AddSign = true}) + " [Initiative|Concept.Initiative]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		return ret;
	}

	q.onUpdate <- function( _properties )
	{
		if (this.isEnabled())
		{
			_properties.Initiative += this.getInitiativeModifier();
		}
	}

	q.onTurnStart <- function()
	{
		this.m.TilesMoved = 0;
	}

	q.onCombatFinished <- function()
	{
		this.m.TilesMoved = 0;
	}

	q.onMovementStarted <- function( _tile, _numTiles )
	{
		if (this.getContainer().getActor().isActiveEntity()) this.m.TilesMoved += _numTiles;

		if (_numTiles == 0)	// This is an indicator, that we were "teleported", instead of having moved naturally
		{
			this.m.PrevTile = _tile;
		}
	}

	q.onMovementFinished <- function()
	{
		if (this.m.PrevTile != null)
		{
			local actor = this.getContainer().getActor();
			if (actor.isActiveEntity()) this.m.TilesMoved += actor.getTile().getDistanceTo(this.m.PrevTile);

			this.m.PrevTile = null;
		}
	}

	q.onEquip <- function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Sword))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_kata_step_skill"));
		}
	}

	q.onAdded <- function()
	{
		local mainhandItem = this.getContainer().getActor().getMainhandItem();
		if (mainhandItem != null) this.onEquip(mainhandItem);
	}

// New Functions
	q.isEnabled <- function()
	{
		if (this.m.IsForceEnabled) return true;

		local actor = this.getContainer().getActor();
		if (actor.isDisarmed()) return false;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
		{
			return false;
		}

		return true;
	}

	q.getInitiativeModifier <- function()
	{
		return this.m.TilesMoved * this.m.InitiativeModifierPerTile;
	}
});


