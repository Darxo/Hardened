// Ijirok Charge skill
::Hardened.HooksMod.hook("scripts/skills/actives/teleport_skill", function(q) {
// Public
	q.m.HD_MinimumDistanceToEnemies <- 4;
	q.m.HD_FadeDuration <- 900;		// Time in Milliseconds in that the Ijirok will fade in/out during teleport

	q.create = @(__original) function()
	{
		__original();

		this.m.MinRange = 3;
		this.m.MaxRange = 7;

		this.m.ActionPointCost = 6;		// Vanilla: 3
		this.m.FatigueCost = 0;			// Vanilla: 10

		this.m.HD_Cooldown = 1;
	}

	// Overwrite, because we remove the vanilla condition where the line from us to the target must be "free"/"empty"
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Target an empty tile with no enemy within " + ::MSU.Text.colorNeutral(this.m.HD_MinimumDistanceToEnemies) + " tiles",
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Apply [$ $|Skill+chilled_effect] to all adjacent enemies and transform your current tile and all adjacent tiles into snow"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Teleport to the chosen tile and transform it and all adjacent tiles into snow"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Summon " + ::MSU.Text.colorPositive(1) + ::MSU.Text.colorNeutral(" Hollenhund") + " at your previous position"),
		});

		return ret;
	}}.getTooltip;

	// Overwrite, because we remove the vanilla condition where the line from us to the target must be "free"/"empty"
	q.onVerifyTarget = @() { function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		if (!_targetTile.IsEmpty) return false;

		local nearbyHostiles = ::Tactical.Entities.getHostileActors(this.getContainer().getActor().getFaction(), _targetTile, this.m.HD_MinimumDistanceToEnemies);
		return nearbyHostiles.len() == 0;
	}}.onVerifyTarget;

	// Overwrite, because we remove the vanilla condition where the line from us to the target must be "free"/"empty"
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		local originTile = _user.getTile();
		if (originTile.IsVisibleForPlayer)
		{
			// Play Animation
			foreach (particles in ::Const.Tactical.SpiritWalkStartParticles)
			{
				::Tactical.spawnParticleEffect(false, particles.Brushes, _user.getTile(), particles.Delay, particles.Quantity, particles.LifeTimeQuantity, particles.SpawnRate, particles.Stages);
			}
		}

		this.HD_coverAreaInSnow(originTile, 350);

		local tag = {
			Skill = this,
			User = _user,
			OriginTile = originTile,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone.bindenv(this),
			OnFadeIn = this.onFadeIn.bindenv(this),
			OnFadeDone = this.onFadeDone.bindenv(this),
			OnTeleportStart = this.onTeleportStart.bindenv(this),
			IgnoreColors = false
		};

		local teleportDelay = 1;
		if (originTile.IsVisibleForPlayer)
		{
			teleportDelay = this.m.HD_FadeDuration;
		}

		// Fade all sprites towards full transparency to make movement seem like real teleport
		if (originTile.IsVisibleForPlayer || _targetTile.IsVisibleForPlayer)
		{
			_user.storeSpriteColors();
			_user.fadeTo(::createColor("4cccf300"), teleportDelay);
		}
		else
		{
			tag.IgnoreColors = true;
		}

		::Time.scheduleEvent(::TimeUnit.Virtual, teleportDelay, this.onTeleportStart, tag);

		return true;
	}}.onUse;

	// Due to our rework of onUse, we now guarantee, that this event is always called during onUse
	q.onTeleportStart = @(__original) { function onTeleportStart( _tag )
	{
		_tag.Skill.HD_chillAdjacentHostiles(_tag.OriginTile);

		// This triggers a teleport, emptying the originTile in the process
		__original(_tag);
	}}.onTeleportStart;

	// Overwrite, because we
	//	- chill and terraform right here, instead of in onFadeIn
	//	- trigger onFadeIn instantly instead of after a 100ms delay
	//	- improve formatting of vanilla code
	q.onTeleportDone = @() { function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			// Play Animation
			foreach (particles in ::Const.Tactical.SpiritWalkEndParticles)
			{
				::Tactical.spawnParticleEffect(false, particles.Brushes, _entity.getTile(), particles.Delay, particles.Quantity, particles.LifeTimeQuantity, particles.SpawnRate, particles.Stages);
			}
		}

		_tag.Skill.HD_summonHollenhund(_tag);
		_tag.Skill.HD_chillAdjacentHostiles(_tag.TargetTile);
		_tag.Skill.HD_coverAreaInSnow(_tag.TargetTile, 1);

		_tag.OnFadeIn(_tag);
	}}.onTeleportDone;

	// Overwrite, because we extract the chill and terraform logic and use a member variable instead of magic number for duration
	q.onFadeIn = @() { function onFadeIn( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			if (_tag.User.isHiddenToPlayer())
			{
				_tag.User.restoreSpriteColors();
			}
			else
			{
				_tag.User.fadeToStoredColors(this.m.HD_FadeDuration);
				::Time.scheduleEvent(::TimeUnit.Virtual, this.m.HD_FadeDuration, _tag.OnFadeDone, _tag);
			}
		}
	}}.onFadeIn;

// New Functions
	// Apply chilled_effect to all hostiles adjacent to _tile
	q.HD_chillAdjacentHostiles <- function( _tile )
	{
		local actor = this.getContainer().getActor();
		foreach (neighborTile in ::MSU.Tile.getNeighbors(_tile))
		{
			if (!neighborTile.IsOccupiedByActor) continue;
			if (neighborTile.getEntity().isAlliedWith(actor)) continue;

			neighborTile.getEntity().getSkills().add(::new("scripts/skills/effects/chilled_effect"));
		}
	}

	// Cover _tile and all adjacent tiles into snow
	q.HD_coverAreaInSnow <- function( _tile, _delay = 350 )
	{
		local tilesToTransform = [_tile];
		tilesToTransform.extend(::MSU.Tile.getNeighbors(_tile));
		foreach (tile in tilesToTransform)
		{
			this.HD_coverInSnow(tile, _delay);
		}
	}

	// Change the Terrain of a single _tile into snow
	q.HD_coverInSnow <- function( _tile, _delay = 350 )
	{
		if (_tile.Subtype == ::Const.Tactical.TerrainSubtype.Snow) return;
		if (_tile.Subtype == ::Const.Tactical.TerrainSubtype.LightSnow) return;

		::Time.scheduleEvent(::TimeUnit.Virtual, _delay, function ( _data )
		{
			_data.Tile.clear();
			_data.Tile.Type = 0;
			_data.Skill.m.SnowTiles[::Math.rand(0, _data.Skill.m.SnowTiles.len() - 1)].onFirstPass({
				X = _data.Tile.SquareCoords.X,
				Y = _data.Tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = true,
				SpawnObjects = false,
			});
		}, {
			Tile = _tile,
			Skill = this,
		});
	}

	// Play a unique spawn animation on _tile, summon a single Hollenhund on _tile and change the faction of that character to that of the owner of this skill
	q.HD_summonHollenhund <- function( _tag )
	{
		_tag.Skill.HD_spawnSpawnEffect(_tag.OriginTile);
		local entity = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/hd_trickster_hollenhund", _tag.OriginTile.Coords);
		entity.setFaction(_tag.User.getFaction());
	}

	// Copy of how the vanilla zombie_boss creates effects when summoning geists
	q.HD_spawnSpawnEffect <- function( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_01",
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					SpawnOffsetMin = ::createVec(-10, -10),
					SpawnOffsetMax = ::createVec(10, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0),
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0),
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0),
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}
});
