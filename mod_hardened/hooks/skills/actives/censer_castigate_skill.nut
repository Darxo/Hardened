::Hardened.HooksMod.hook("scripts/skills/actives/censer_castigate_skill", function(q) {
	q.m.HD_ArcSize <- 4;	// Vanilla: 3

	q.create = @(__original) { function create()
	{
		__original();

		// Remove any mention of the amount of tiles we can hit
		this.m.Description = "A sweeping strike that hits a wide arc in counter-clockwise order and leaves a harmful miasma in its wake. Be careful around your own men unless you want to relieve your payroll!";

		this.m.IsTargetingActor = false;
	}}.create;

	// Overwrite, because we make the target selection in this function standardized and more moddable
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Target an tile. Attack that target and the next " + ::MSU.Text.colorPositive(this.m.HD_ArcSize - 1) + " tiles in a counter-clockwise order",
		});

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Create harmful miasma on the target and the next " + ::MSU.Text.colorPositive(this.m.HD_ArcSize) + " tiles in a counter-clockwise order",
		});

		return ret;
	}}.getTooltip;

	// Overwrite, because we make the target selection in this function standardized and more moddable
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSwing);

		local ret = false;
		foreach (tile in this.HD_getAffectedTiles(_targetTile))
		{
			::Tactical.State.spawnMiasmaOnTile(tile);

			if (tile.IsEmpty) continue;
			if (!tile.getEntity().isAttackable()) continue;

			ret = ret || this.attackEntity(_user, tile.getEntity());

			if (!_user.isAlive()) break;
		}

		return ret;
	}}.onUse;

	// Overwrite, because we make the target selection in this function standardized and more moddable
	q.onTargetSelected = @() { function onTargetSelected( _targetTile )
	{
		foreach (tile in this.HD_getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}}.onTargetSelected;

// New Functions
	// Get all attackable tiles that belong to an attack targeting _targetTile
	q.HD_getAffectedTiles <- function( _targetTile, _clockWise = false )
	{
		local affectedTiles = [];

		local actor = this.getContainer().getActor();
		foreach (tile in ::Hardened.util.getAllTilesHalfMoon(actor.getTile(), _targetTile, this.m.HD_ArcSize, _clockWise))
		{
			if (this.HD_isUsableOnForFree(tile, actor.getTile()))
			{
				affectedTiles.push(tile);
			}
		}

		return affectedTiles;
	}
});
