::Hardened.HooksMod.hook("scripts/skills/skill", function(q) {
	// Private
	q.m.HD_PreviousRandomResult <- 0;	// We save the previous damage roll here, so we can make sure that armor and hitpoint rolls are exactly the same

	q.getHitFactors = @(__original) function( _targetTile )
	{
		local ret = __original(_targetTile);

		// New Entries
		if (_targetTile.IsOccupiedByActor)
		{
			local target = _targetTile.getEntity();
			local properties = this.getContainer().buildPropertiesForUse(this, target);

			// Headshot chance
			if (this.isAttack())
			{
				// First remove remove the headshot entry, created by reforged
				foreach (index, entry in ret)
				{
					// We know only ever one of these two can exist in ret at the same time, so we can remove them like this
					if (entry.text.find("chance to hit head") != null)
					{
						ret.remove(index);
						break;
					}
				}

				// We want a hyperlinked one-liner, that is more accurately calculated
				local headshotChance = properties.getHeadHitchance(::Const.BodyPart.Head, this.getContainer().getActor(), this, target);
				ret.insert(0, {
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(headshotChance, {AddPercent = true}) + " [Headshot chance|Concept.ChanceToHitHead]"),
				});
			}
		}

		return ret;
	}

// Modular Vanilla Functions
	/* This change will make it so both, armor and health damage use the exact same base damage roll
	 * No longer is it possible to low-roll on armor damage and high-roll on the hightpoint damage part.
	 * That issue is only confusing: when trying to understand the damage dealt in combat and can create additional frustration
	 */
	 q.MV_getDamageRegular = @(__original) function( _properties, _targetEntity = null )
	 {
		 local damageRegularResult = null;

		 local mockObjectRand;
		 mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			 if (vargv.len() == 2 && vargv[0] == _properties.DamageRegularMin && vargv[1] == _properties.DamageRegularMax)
			 {
				 local ret = mockObjectRand.original(vargv[0], vargv[1]);
				 damageRegularResult = ret;	// We save the result of the random hitpoint damage roll, so we can later apply it also to the random armor damage roll
				 return { done = true, value = ret };
			 }
		 });

		 local ret = __original(_properties, _targetEntity);

		 this.m.HD_PreviousRandomResult = damageRegularResult;
		 mockObjectRand.cleanup();

		 return ret;
	 }

	 q.MV_onAttackRolled = @(__original) { function MV_onAttackRolled( _attackInfo )
	 {
		// We switcheroo CombatDifficulty to be any value other than 0 in order to disable the vanilla hidden hitchance/defense bonus granted by playing on easy
		local oldCombatDifficulty = ::World.Assets.m.CombatDifficulty;
		::World.Assets.m.CombatDifficulty = 1;
		__original(_attackInfo);
		::World.Assets.m.CombatDifficulty = oldCombatDifficulty;
	 }}.MV_onAttackRolled;

	 q.MV_getDamageArmor = @(__original) function( _properties, _targetEntity = null )
	 {
		 local damageArmorResult = this.m.HD_PreviousRandomResult;

		 local mockObjectRand;
		 mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			 if (vargv.len() == 2 && vargv[0] == _properties.DamageRegularMin && vargv[1] == _properties.DamageRegularMax)
			 {
				 return { done = true, value = damageArmorResult };	// We apply the previously saved result, so that the armor damage roll is now equal to the hp damage roll
			 }
		 });

		 local ret = __original(_properties, _targetEntity);

		 this.m.HD_PreviousRandomResult = 0;	// Setting this to null can cause battle crashes in rare compatibility cases. Setting it to 0 is less intrusive and should still cause bug-reports
		 mockObjectRand.cleanup();

		 return ret;
	 }

	 q.MV_getDiversionTarget = @(__original) { function MV_getDiversionTarget( _user, _targetEntity, _propertiesForUse = null )
	 {
		// We switcheroo CombatDifficulty to be any value other than 0 in order to disable the vanilla hidden hitchance/defense bonus granted by playing on easy

		local divertedTarget
		local roll = 0;
		local chance = 0;
		local aboutToRoll = false;

		local blockedTiles = ::Const.Tactical.Common.getBlockedTiles(_user.getTile(), _targetEntity.getTile(), _user.getFaction());
		// Target is not in cover, or the setting is not active, so we do nothing
		if (blockedTiles.len() == 0 || !::Hardened.Mod.ModSettings.getSetting("ShowCoverCombatLogs").getValue())
		{
			return __original(_user, _targetEntity, _propertiesForUse);
		}

		local aboutToRollObject;
		aboutToRollObject = ::Hardened.mockFunction(::Const.Tactical.Common, "getBlockedTiles", function( _userTile, _targetTile, _userFaction ) {
			local ret = aboutToRollObject.original(_userTile, _targetTile, _userFaction);
			aboutToRoll = true;
			return { done = true, value = ret };
		});

		local rollMockObject;
		rollMockObject = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (aboutToRoll && vargv.len() == 2 && vargv[0] == 1 && vargv[1] == 100)
			{
				roll = rollMockObject.original(vargv[0], vargv[1]);
				return { done = true, value = roll };
			}
		});

		local chanceMockObject;
		chanceMockObject = ::Hardened.mockFunction(::Math, "ceil", function( _value ) {
			if (aboutToRoll)
			{
				chance = chanceMockObject.original(_value);
				return { done = true, value = chance };
			}
		});

		local ret = __original(_user, _targetEntity, _propertiesForUse);
		aboutToRollObject.cleanup();
		rollMockObject.cleanup();
		chanceMockObject.cleanup();

		// roll and chance are reversed in the vanilla check, so we invert them to be in line with regular hitchance logs
		roll = 100 - roll;
		chance = 100 - chance;

		// Now we build a log message to describe how the cover influenced our hitchance and target
		local logMessage = ::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " uses " + this.getName() + " and ";
		if (ret == null)	// Cover is avoided and main target will be hit
		{
			logMessage += ::MSU.Text.colorPositive("bypasses") + " the cover (Chance: " + chance + ", Rolled: " + roll + ")";
		}
		else	// The cover (object in ret) is hit instead
		{
			local newTarget = ::MSU.isKindOf(ret, "actor") ? ::Const.UI.getColorizedEntityName(ret) : ::MSU.Text.colorNeutral(ret.getName());
			logMessage += ::MSU.Text.colorNegative("fails to bypass") + " the cover (Chance: " + chance + ", Rolled: " + roll + "). The shot diverts to " + newTarget + " instead of " + ::Const.UI.getColorizedEntityName(_targetEntity);
		}
		::Tactical.EventLog.log(logMessage);

		return ret;
	 }}.MV_getDiversionTarget;

// Reforged Functions
	// Overwrite, because we have different conditions for duelistValid
	// This is more for mod-compatibility, because our Duelist Perk is reworked and does not use this check
	q.isDuelistValid = @() function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (::MSU.isNull(mainhandItem)) return false;
		if (!mainhandItem.isItemType(::Const.Items.ItemType.OneHanded)) return false;

		return true;
	}

// New Functions
	// Call several functions to make sure that other entities/factions know about the action this skill just did, if they see the action
	// Important: this.getContainer().getActor() must be placed on a tile, so do make sure that is the case before caling this function
	q.revealUser <- function( _targetedTile )
	{
		local user = this.getContainer().getActor();

		if (_targetedTile.IsVisibleForPlayer && !user.getTile().IsVisibleForPlayer)
		{
			if (!user.m.HD_IsDiscovered) user.setDiscovered(true);	// If the user was not discovered before by the player, they will be discovered now
			// We always reveal the user-tile, when it's targeting a tile already visible to the player, allowing the player to see the entity on top of it
			user.getTile().addVisibilityForFaction(::Const.Faction.Player);
		}

		if (!_targetedTile.IsOccupiedByActor) return;

		local target = _targetedTile.getEntity();
		if (target.getAttackers().find(user.getID()) == null)
		{
			target.getAttackers().push(user.getID());
		}

		if (!target.isPlayerControlled())
		{
			user.getTile().addVisibilityForFaction(target.getFaction());
			target.onActorSighted(user);

			foreach (targetAlly in ::Tactical.Entities.getInstancesOfFaction(target.getFaction()))
			{
				if (targetAlly.getID() != target.getID() && targetAlly.isAlive())
				{
					targetAlly.onActorSighted(user);
					// Maybe also add user to getAttackers of any ally?
				}
			}
		}
	}

	// Generate an array of tags which describe this skill
	q.HD_getSkillTags <- function()
	{
		local itemTags = "";
		if (this.isAttack())
		{
			itemTags += "Attack, ";
			if (this.isRanged())
			{
				itemTags += "Ranged, ";
			}
			else
			{
				itemTags += "Melee, ";
			}
		}
		else itemTags += "Non-Attack, ";

		if (this.isAOE()) itemTags += "AoE, ";

		local item = this.getItem();
		if (!::MSU.isNull(item))
		{
			if (item.isItemType(::Const.Items.ItemType.Weapon))
			{
				itemTags += "Weapon (";

				foreach (weaponType in ::Const.Items.WeaponType)
				{
					if (item.isWeaponType(weaponType))
					{
						itemTags += ::Const.Items.getWeaponTypeName(weaponType) + "/";
					}
				}
				itemTags = itemTags.slice(0, -1);
				itemTags += "), ";
			}

			if (item.isItemType(::Const.Items.ItemType.Shield)) itemTags += "Shield, ";
			if (item.isItemType(::Const.Items.ItemType.Tool)) itemTags += "Tool, ";
			if (item.isItemType(::Const.Items.ItemType.OneHanded)) itemTags += "One-Handed, ";
			if (item.isItemType(::Const.Items.ItemType.TwoHanded)) itemTags += "Two-Handed, ";
		}

		if (this.m.DamageType.len() != 0 && !this.m.DamageType.contains(::Const.Damage.DamageType.None))
		{
			foreach (d in this.m.DamageType.toArray())
			{
				local probability = ::Math.round(this.m.DamageType.getProbability(d) * 100);
				if (probability < 100)
				{
					itemTags += probability + "% ";
				}

				itemTags += ::Const.Damage.getDamageTypeName(d) + " Damage, ";
			}
		}

		if (itemTags != "") itemTags = itemTags.slice(0, -2);

		return ::MSU.Text.color("#1e468f", "Tags: ") + itemTags;
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/skill", function(q) {
	if (q.contains("create"))	// The base skill class does not contain a create function
	{
		q.create = @(__original) function()
		{
			__original();
			this.m.IsAudibleWhenHidden = false;		// In Hardened you will never hear skills if the user is hidden to you
		}
	}

	// Fix: display the actual minimum armor penetration (ignoring remaining armor reduction) as the minimum value for weapon skills instead of hard-coded 0
	// Some skills do some custom calculation and show slightly different tooltip value (e.g. Split Man) and need to be handled
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 4 && entry.type == "text" && entry.icon == "ui/icons/regular_damage.png")
			{
				local p = this.getContainer().buildPropertiesForUse(this, null);
				local damage_regular_min = ::Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * p.MeleeDamageMult);
				local damage_direct_min = ::Math.floor(damage_regular_min * ::Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd + p.DamageDirectMeleeAdd)));
				entry.text = ::MSU.String.replace(entry.text, "of which [color=" + ::Const.UI.Color.DamageValue + "]0[/color]", "of which " + ::MSU.Text.colorDamage(damage_direct_min));
				break;
			}
		}

		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		// We make sure everyone who needs to know, now knows about the action we just did onto _targetTile, no matter what kind of skill we used
		this.revealUser(_targetTile);

		return __original(_user, _targetTile);
	}

	// We need to do hookTree, because some skills (mostly vanilla) overwrite the getDescription function to deliver dynamic descriptions
	q.getDescription = @(__original) function()
	{
		// Feat: Active Skills may now display a selection of skill tags, if the respective setting has been turned on
		if (this.isActive() && ::Hardened.Mod.ModSettings.getSetting("DisplaySkillTags").getValue())
		{
			// We switcheroo ExpandedSkillTooltips to false, so that MSU does not add their damage types, because we add those now within our tag system
			local oldExpandedSkillTooltipsSetting = ::MSU.Mod.ModSettings.getSetting("ExpandedSkillTooltips").getValue();
			::MSU.Mod.ModSettings.getSetting("ExpandedSkillTooltips").Value = false;
			local ret = this.HD_getSkillTags() + "\n\n" + __original();
			::MSU.Mod.ModSettings.getSetting("ExpandedSkillTooltips").Value = oldExpandedSkillTooltipsSetting;

			return ret
		}
		else
		{
			return __original();
		}
	}

	// Feat: replace every occurence of "Max Fatigue" or "Maximum Fatigue" in any skill tooltip into "Stamina"
	// Better for performance would be going into each individual effect replacing the term there
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (ret != null)
		{
			foreach (entry in ret)
			{
				if (!("text" in entry)) continue;
				entry.text = ::MSU.String.replace(entry.text, "Max Fatigue", ::Reforged.Mod.Tooltips.parseString("[Stamina|Concept.MaximumFatigue]"), true);
				entry.text = ::MSU.String.replace(entry.text, " Maximum Fatigue", ::Reforged.Mod.Tooltips.parseString(" [Stamina|Concept.MaximumFatigue]"), true);
				entry.text = ::MSU.String.replace(entry.text, "Maximum Fatigue", "Stamina", true);	// This covers nested tooltips from Reforged
			}
		}

		return ret;
	}

// Hardened Functions
	// Overwrite, because we use our new centralized function and support the HD_KnockBackDistance member
	// Vanilla implements this for various skills. In order to overwrite those implementations, we require hookTree
	q.findTileToKnockBackTo = @() function( _userTile, _targetTile )
	{
		return ::Hardened.util.findTileToKnockBackTo(_userTile, _targetTile, this.m.HD_KnockBackDistance);
	}
});
