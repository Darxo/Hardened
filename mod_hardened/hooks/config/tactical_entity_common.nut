local oldOnApplyFire = ::Const.Tactical.Common.onApplyFire;
::Const.Tactical.Common.onApplyFire = function( _tile, _entity )
{
	local burnedRootEffect = ::Const.Tactical.Common.removeRooted(_entity);
	if (burnedRootEffect != null)
	{
		::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(_entity) + " breaks free (Flames burn away " + burnedRootEffect.getName() + ")");
	}

	oldOnApplyFire(_tile, _entity);
}

::Const.Tactical.Common.removeRooted <- function( _entity, _spawnDecal = true, _rootSkillIDs = ["effects.net", "effects.rooted", "effects.web", "effects.kraken_ensnare", "effects.serpent_ensnare"] )
{
	local skills = _entity.getSkills();

	local rootEffect = null;
	foreach (rootEffectID in _rootSkillIDs)
	{
		rootEffect = skills.getSkillByID(rootEffectID);
		if (rootEffect != null) break;
	}
	if (rootEffect == null) return null;	// No rootSkill was detected/removed

	local breakFreeEffect = skills.getSkillByID("actives.break_free");	// If this skill is not present then this root effect is probably not meant to be removable
	if (breakFreeEffect == null) return null;

	// Spawn a decal that corresponds to the respective root-effect (e.g. a piece of net/web or a severed tentacle?)
	if (_spawnDecal && breakFreeEffect.m.Decal != "")
	{
		local ourTile = _entity.getTile();
		local candidates = [];

		if (ourTile.Properties.has("IsItemSpawned") || ourTile.IsCorpseSpawned)
		{
			foreach (tile in ::MSU.Tile.getNeighbors(ourTile))
			{
				if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
				{
					candidates.push(tile);
				}
			}
		}
		else
		{
			candidates.push(ourTile);
		}

		if (candidates.len() != 0)
		{
			local tileToSpawnAt = ::MSU.Array.rand(candidates);
			tileToSpawnAt.spawnDetail(breakFreeEffect.m.Decal);
			tileToSpawnAt.Properties.add("IsItemSpawned");
		}
	}

	// Clear sprites
	_entity.getSprite("status_rooted").Visible = false;
	_entity.getSprite("status_rooted_back").Visible = false;

	// Remove skills
	rootEffect.removeSelf(); 	// we assume that only one of the root effects is present at the same time
	breakFreeEffect.removeSelf();
	_entity.setDirty(true);

	return rootEffect;
}
