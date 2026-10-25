::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
	// Complete overwrite of showCombatDialog with the goal of using getLocalCombatProperties as the one source of truth
	// We add a few new helper functions to improve modability
	q.showCombatDialog = @() function( _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null )
	{
	// Gather General Information
		if (_pos == null) _pos = this.m.Player.getPos();

		local allyBanners = [];
		local enemyBanners = [];

		if (_properties == null)
		{
			allyBanners.push(::World.Assets.getBanner());
			_properties = this.getLocalCombatProperties(_pos);
		}

		// Early return, if we have no enemies
		local hasOpponents = false;
		foreach (party in _properties.Parties)
		{
			if (party.isAlliedWithPlayer()) continue;
			hasOpponents = true;
			break;
		}
		foreach (troopDef in _properties.Entities)
		{
			if (hasOpponents) break;

			if (::World.FactionManager.isAlliedWithPlayer(troopDef.Faction) && _properties.TemporaryEnemies.find(troopDef.Faction) == null) continue;

			hasOpponents = true;
		}
		if (!hasOpponents)
		{
			::logWarning("Hardened: showCombatDialog has no opponent");
			return;
		}

		allyBanners.extend(_properties.AllyBanners);
		enemyBanners.extend(_properties.EnemyBanners);

		if (!_isPlayerInitiated && ::World.Assets.getOrigin().getID() != "scenario.rangers" && !::Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type] && !::World.getTime().IsDaytime)
		{
			_isCombatantsVisible = false;
		}

		if (!_isPlayerInitiated)
		{
			if (::World.Assets.isCamping() || ::Const.World.TerrainTypeLineBattle[this.m.Player.getTile().Type])
			{
				_allowFormationPicking = false;
			}
		}

		local engageImage = this.HD_getEngagementImage(_pos);

	// Gather Troops
		local centreTooltipEntries = [];

		// Fortification Entry
		foreach (party in _properties.Parties)
		{
			if (party.isLocation() && party.isShowingDefenders() && party.getCombatLocation().Template[0] != null && party.getCombatLocation().Fortification != 0 && !party.getCombatLocation().ForceLineBattle)
			{
				centreTooltipEntries.push({
					Name = "Fortifications",
					Icon = "palisade_01_orientation",
					Overlay = null,
				});
			}
		}

		local champions = [];
		local entityTypes = [];
		entityTypes.resize(::Const.EntityType.len(), 0);

		foreach (troopDef in _properties.Entities)
		{
			if (!this.HD_troopShownInCombatDialog(troopDef)) continue;

			if (troopDef.Variant != 0)
			{
				champions.push(troopDef);
			}
			else
			{
				++entityTypes[troopDef.ID];
			}
		}

		foreach (champion in champions)
		{
			centreTooltipEntries.push({
				Name = champion.Name,
				Icon = ::Const.EntityIcon[champion.ID],
				Overlay = "icons/miniboss.png",
			});
		}

		foreach (index, entityAmount in entityTypes)
		{
			if (entityAmount == 0) continue;

			local name = "";
			if (entityAmount == 1)
			{
				name = ::Const.Strings.EntityName[index];
				name = ::removeFromBeginningOfText("The ", name);
				local prefix = ::isFirstCharacter(name, ["A", "E", "I", "O", "U"]) ? "An" : "A";
				name = prefix + " " + name;
			}
			else
			{
				local amountString = ::Const.Strings.EngageEnemyNumbers[::Math.max(0, ::Math.floor(::Math.minf(1.0, entityTypes[index] / 14.0) * (::Const.Strings.EngageEnemyNumbers.len() - 1)))];
				name = amountString + " " + ::Const.Strings.EntityNamePlural[index];
			}

			centreTooltipEntries.push({
				Name = name,
				Icon = ::Const.EntityIcon[index],
				Overlay = null,
			});
		}

	// Final Adjustments
		local engagementTextOverwrite = "";
		if (!_isCombatantsVisible || centreTooltipEntries.len() == 0)
		{
			allyBanners = [];
			enemyBanners = [];
			engagementTextOverwrite = this.HD_getEngagementTextOverwrite(_isPlayerInitiated);
		}

	// Display Combat Dialog
		this.setAutoPause(true);
		this.Cursor.setCursor(::Const.UI.Cursor.Hand);
		this.m.EngageCombatPos = _pos;
		this.m.EngageByPlayer = _isPlayerInitiated;
		this.Tooltip.hide();
		this.m.WorldScreen.hide();
		this.m.CombatDialog.show(centreTooltipEntries, allyBanners, enemyBanners, _isPlayerInitiated || this.m.EscortedEntity != null, _allowFormationPicking, engagementTextOverwrite, engageImage, this.m.EscortedEntity != null ? "Flee!" : "Fall back!");
		this.m.MenuStack.push(function ()
		{
			this.m.EngageCombatPos = null;
			this.m.CombatDialog.hide();
			this.m.WorldScreen.show();
			this.stunPartiesNearPlayer(_isPlayerInitiated);
			this.setAutoPause(false);
		}, function ()
		{
			return !this.m.CombatDialog.isAnimating();
		}, _isPlayerInitiated);
	}

// New Functions
	q.HD_getEngagementTextOverwrite <- function( _isPlayerInitiated )
	{
		if (!_isPlayerInitiated)
		{
			return "You can\'t make out who is attacking you in time.<br/>You have to defend yourself!";
		}
		else
		{
			return "You can\'t make out who you\'ll be facing. Attack at your own peril and be prepared to retreat if need be!";
		}
	}

	q.HD_getEngagementImage <- function( _pos )
	{
		local tile = ::World.getTile(::World.worldToTile(_pos));
		local engageImage = ::Const.World.TerrainTacticalImage[tile.TacticalType];
		if (!::World.getTime().IsDaytime)
		{
			engageImage = engageImage + "_night";
		}
		engageImage = engageImage + ".png";
		return engageImage;
	}

	q.HD_troopShownInCombatDialog <- function( _troopDef )
	{
		if (!("Party" in _troopDef)) return true;

		local party = _troopDef.Party;
		if (party.isLocation() && !party.isShowingDefenders()) return false;

		return true;
	}
});
