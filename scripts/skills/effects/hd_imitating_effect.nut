this.hd_imitating_effect <- ::inherit("scripts/skills/skill", {
	m = {
	// Public
		MissingMasteryHitchanceModifier = -10,	// Hitchance Modifier if the weapon mastery for the copied weapon type is missing

	// Private
		ChosenWeaponType = null,	// This must be set to a valid weapon type, before this effect is added to a character
		ChosenWeaponTypeName = "",

		AddedWeaponType = null,		// If null, then that means we have not added a new weapon type to the currently equipped weapon
		PerksAdded = [],
	},

	function create()
	{
		this.m.ID = "effects.hd_imitating";
		this.m.Name = "Imitating";
		this.m.Description = "Every fighter has something worth copying.";
		this.m.Icon = "ui/perks/perk_hd_copycat.png";
		this.m.Overlay = "hd_imitating_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First;		// We need to be first, because our added itemtypes decide, which other perk triggers its effect during onEquip
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;

		this.m.HD_LastsForTurns = 1;
	}

	function onAdded()
	{
		if (this.m.ChosenWeaponType == null) return;

		// Find out weapon type name
		foreach (weaponTypeName, weaponType in ::Const.Items.WeaponType)
		{
			if (weaponType == this.m.ChosenWeaponType)
			{
				this.m.ChosenWeaponTypeName = weaponTypeName;
				break;
			}
		}

		this.learnWeaponPerks(this.m.ChosenWeaponType);

		// We refresh our mainhand item to generate weapon types for it and add skills coming from our just own newly added perks
		this.HD_refreshMainhandItem();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ChosenWeaponType == null)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Your mainhand weapon gains the chosen weapon type"),
			});

			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain all perks from the perk group of the chosen weapon type"),
			});

			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MissingMasteryHitchanceModifier, {AddSign = true, AddPercent = true}) + " [$ $|Concept.Hitchance], if you have not unlocked the weapon mastery from the chosen weapon type"),
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Your mainhand weapon gains " + ::MSU.Text.colorPositive(this.m.ChosenWeaponTypeName) + " weapon type"),
			});

			local perkTooltipID = 15;
			foreach (perk in this.m.PerksAdded)
			{
				ret.push({
					id = perkTooltipID,
					type = "text",
					icon = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedPerkImage(perk)),
					text = "Gain " + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedPerkName(perk)),
				});
				++perkTooltipID;
			}

			if (!this.hasNativeWeaponMasteryForType(this.m.ChosenWeaponType))
			{
				local weaponMasteryDef = this.getWeaponMasteryDefForType(this.m.ChosenWeaponType);
				if (weaponMasteryDef != null)
				{
					local weaponMasteryPerk = ::new(weaponMasteryDef.Script);
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/hitchance.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MissingMasteryHitchanceModifier, {AddSign = true, AddPercent = true}) + " [$ $|Concept.Hitchance], because you have not unlocked " + ::Reforged.NestedTooltips.getNestedPerkName(weaponMasteryPerk)),
					});
				}
			}
		}

		return ret;
	}

	function onEquip( _item )
	{
		if (this.m.ChosenWeaponType == null) return;
		if (_item.getCurrentSlotType() != ::Const.ItemSlot.Mainhand) return;
		if (!_item.isItemType(::Const.Items.ItemType.Weapon)) return;

		this.HD_addWeaponType(_item, this.m.ChosenWeaponType);
	}

	function onUnequip( _item )
	{
		::logWarning("Hardened: hd_imitating_effect::onUnequip");
		if (_item.getCurrentSlotType() != ::Const.ItemSlot.Mainhand) return;
		if (!_item.isItemType(::Const.Items.ItemType.Weapon)) return;

		this.HD_removeWeaponType(_item);
	}

	function onUpdate( _properties )
	{
		if (!this.hasNativeWeaponMasteryForType(this.m.ChosenWeaponType))
		{
			_properties.MeleeSkill += this.m.MissingMasteryHitchanceModifier;
			_properties.RangedSkill += this.m.MissingMasteryHitchanceModifier;
		}
	}

	function onRemoved()
	{
		// Remove all perks, that we added
		foreach (perk in this.m.PerksAdded)
		{
			// We need to use "removeByStackByID" (added by Stack-Based-Skills), because its hook of the vanilla removeByID , used on perks, only remove the serialized version of them
			this.getContainer().removeByStackByID(perk.getID(), false);
		}
		this.m.PerksAdded = [];

		// Remove the weapon type, we added to the currently held mainhand weapon
		local mainhandItem = this.getContainer().getActor().getMainhandItem();
		if (mainhandItem != null) this.onUnequip(mainhandItem);

		// Make sure that we lose skills from other sources granted only to use, because of our added weapon type or perks
		this.HD_refreshMainhandItem();
	}

// New Functions
	function HD_refreshMainhandItem()
	{
		local actor = this.getContainer().getActor();
		local mainhandItem = this.getContainer().getActor().getMainhandItem();
		if (mainhandItem != null)
		{
			mainhandItem.HD_refreshItem();
		}
	}

	// Add _weaponType to _item, if not already present, and register the addition in this skill
	function HD_addWeaponType( _item, _weaponType )
	{
		::logWarning("Hardened: hd_imitating_effect::HD_addWeaponType");
		if (!_item.isWeaponType(_weaponType))
		{
			::logWarning("Hardened: addWeaponType " + _weaponType);
			this.m.AddedWeaponType = _weaponType;
			_item.addWeaponType(_weaponType, true);
		}
	}

	// Remove the added weapon type from _item
	function HD_removeWeaponType( _item )
	{
		::logWarning("Hardened: hd_imitating_effect::HD_removeWeaponType");
		if (this.m.AddedWeaponType != null)
		{
			::logWarning("Hardened: removeWeaponType " + this.m.AddedWeaponType);
			_item.removeWeaponType(this.m.AddedWeaponType, true);
			this.m.AddedWeaponType = null;
		}
	}

	function learnWeaponPerks( _weaponType )
	{
		local perkGroup = this.getPerkGroupForWeaponType(_weaponType);
		if (perkGroup == null) return;

		foreach (row in perkGroup.getTree())
		{
			foreach (perkID in row)
			{
				local newPerk = ::Reforged.new(::Const.Perks.findById(perkID).Script, function(o) {
					o.m.IsSerialized = false;
					o.m.IsRefundable = false;
				})
				this.getContainer().add(newPerk);
				this.m.PerksAdded.push(newPerk);
			}
		}
	}

	function hasNativeWeaponMasteryForType( _weaponType )
	{
		if (_weaponType == null) return false;

		local weaponMasteryDef = this.getWeaponMasteryDefForType(_weaponType);
		if (weaponMasteryDef == null) return false;

		local skill = this.getContainer().getSkillByID(weaponMasteryDef.ID);
		if (skill == null) return false;	// We don't have this weapon mastery

		return skill.isSerialized();	// We only count naturally unlocked perks. Temporarily gained perks are generally not serialized
	}

	// Find and return the definition table for the weapon mastery for a given _weaponType
	function getWeaponMasteryDefForType( _weaponType )
	{
		local perkGroup = this.getPerkGroupForWeaponType(_weaponType);
		if (perkGroup == null) return null;	// No perk group exists for this weapon type

		foreach (row in perkGroup.getTree())
		{
			foreach (perkID in row)
			{
				local perkDef = ::Const.Perks.findById(perkID);
				if (perkDef.ID.find("perk.mastery.") != null) return perkDef;
			}
		}

		return null;
	}

	function getPerkGroupForWeaponType( _weaponType )
	{
		foreach (weaponTypeName, weaponType in ::Const.Items.WeaponType)
		{
			if (weaponType != _weaponType) continue;

			if (weaponTypeName == "Firearm") weaponTypeName = "Crossbow";
			return ::DynamicPerks.PerkGroups.findById("pg.rf_" + weaponTypeName.tolower());
		}

		return null;
	}
});
