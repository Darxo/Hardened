this.hd_trickster_sweep_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},

	function create()
	{
		this.m.ID = "actives.hd_trickster_sweep";
		this.m.Name = "Antler Sweep";
		this.m.Description = "Sweep your massive antlers in a broad arc, driving enemies back.";
		this.m.KilledString = "Impaled";
		this.m.Icon = "skills/active_177.png";		// Same icon as antler_cleaver attack
		this.m.IconDisabled = "skills/active_177_sw.png";
		this.m.Overlay = "active_177";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/thing_charge_01.wav",
			"sounds/enemies/dlc4/thing_charge_02.wav",
			"sounds/enemies/dlc4/thing_charge_03.wav",
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav",
			"sounds/enemies/unhold_swipe_hit_04.wav",
			"sounds/enemies/unhold_swipe_hit_05.wav",
		];
		this.m.IsTargetingActor = true;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = ::Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.PiercingHead;

		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.DirectDamageMult = 0.4;

	// MSU
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Swing;

	// Hardened
		this.m.HD_Cooldown = 2;		// So that it is only used every second turn
		this.m.HD_KnockBackDistance = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Target an adjacent character. Attack that character and the next two adjacent tiles in a counter-clockwise order",
		});

		if (this.m.HD_KnockBackDistance > 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Knock all attacked characters back " + ::MSU.Text.colorPositive(this.m.HD_KnockBackDistance) + " tiles",
			});

			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Apply [$ $|Skill+staggered_effect] to anyone who was knocked back"),
			});
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSwing);

		local ret = false;
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			if (!this.HD_isUsableOnForFree(tile)) continue;

			local targetEntity = tile.getEntity();
			local wasHit = this.attackEntity(_user, targetEntity);
			this.HD_onTargetAttacked(targetEntity, wasHit);
			ret = wasHit || ret;

			if (!_user.isAlive()) return ret;
		}

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 20;
		}
	}

// New Functions
	function HD_onTargetAttacked( _targetEntity, _wasHit )
	{
		if (!_targetEntity.isAlive()) return;
		if (this.m.HD_KnockBackDistance == 0) return;
		if (_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab) return;
		if (_targetEntity.getCurrentProperties().IsRooted) return;

		local actor = this.getContainer().getActor();
		local knockToTile = this.findTileToKnockBackTo(actor.getTile(), _targetEntity.getTile());
		if (knockToTile != null)
		{
			// Todo: Interruption
			local skills = _targetEntity.getSkills();

			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");

			_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.State.handleInvoluntaryMovement(_targetEntity, actor, _targetEntity.getTile(), knockToTile, this, null, null);
		}
	}

	// Similar implementation logic as the vanilla reap skill has
	function getAffectedTiles( _targetTile )
	{
		local myTile = this.m.Container.getActor().getTile();
		local distance = myTile.getDistanceTo(_targetTile);
		local onQueryTilesHit = function( _tile, _result ) {
			_result.push(_tile);
		}
		local possibleTiles = [];

		this.Tactical.queryTilesInRange(myTile, distance, distance, false, [], onQueryTilesHit, possibleTiles);

		local affectedTiles = [];
		for (local i = 0; i != possibleTiles.len(); ++i)
		{
			if (possibleTiles[i].ID != _targetTile.ID) continue;

			affectedTiles.push(possibleTiles[i]);
			if (--i < 0) i += possibleTiles.len();

			affectedTiles.push(possibleTiles[i]);
			if (--i < 0) i += possibleTiles.len();

			affectedTiles.push(possibleTiles[i]);
			break;
		}

		return affectedTiles;
	}
});
