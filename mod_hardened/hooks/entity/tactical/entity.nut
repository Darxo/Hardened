::Hardened.HooksMod.hookTree("scripts/entity/tactical/entity", function(q) {
	q.create = @(__original) function()
	{
		__original();

		if (!::MSU.isKindOf(this, "actor"))
		{
			this.assignObjectHitBehavior();
		}
	}
});

::Hardened.HooksMod.hook("scripts/entity/tactical/entity", function(q) {
// New Functions
	// This function tries to infer from the getName of this object, which animation and sound to play, when this object is hit by any projectile
	q.assignObjectHitBehavior <- function()
	{
		this.m.HD_ShakeTypeOnHit = 3;	// All objects will at the very least slightly move when hit by a stray projectile

		// Wood noises with leaf animation
		if (this.getName().find(::Const.Strings.Tactical.EntityName.Tree) != null
				|| this.getName().find(::Const.Strings.Tactical.EntityName.Cart) != null
				|| this.getName().find(::Const.Strings.Tactical.EntityName.Cartwheel) != null
				|| this.getName().find("Brazier") != null		// This is half wood, half metal but we default to wood
				|| this.getName().find("Fireplace") != null		// Some fireplaces have cauldrons on top but some are pure wood, so we default to pure wood
				|| this.getName().find("Furniture") != null
				|| this.getName().find("Graves") != null		// Often this also contains a stone structure but we default to wood
				|| this.getName().find("Idol") != null		// These often times consist of Bones, but we default to wood for now
				|| this.getName().find("Marquee") != null		// This consist of majority fabric, but also a little bit of wood
				|| this.getName().find("Nithing Pole") != null
				|| this.getName().find("Palisade") != null
				|| this.getName().find("Spiked Head") != null	// We assume that the material of the spike is wood
				|| this.getName().find("Standard") != null
				|| this.getName().find("Supplies") != null	// They consist of a variety of materials (wood, fabrid, clay)
				|| this.getName().find("Weapons") != null	// This is only used for the nomad "standard", which consist of wooden weapons
				|| this.getName().find("Wood") != null)
		{
			this.m.HD_BloodType = ::Const.BloodType.Wood;
			this.m.HD_SoundOnHit = [
				"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav",
			];
		}
		// Stone noises with dust animation
		else if (this.getName().find("Ruins") != null
				|| this.getName().find("Sarcophagus") != null
				|| this.getName().find("Wall") != null
				|| this.getName().find(::Const.Strings.Tactical.EntityName.Boulder) != null
				|| this.getName().find(::Const.Strings.Tactical.EntityName.Ruin) != null)
		{
			this.m.HD_BloodType = ::Const.BloodType.Sand;
			// this.m.HD_SoundOnHitVolume = 0.7;	// A projectile wouldnt cause much
			this.m.HD_SoundOnHit = [
				"sounds/ambience/terrain/mountain_rocks_00.wav",
				"sounds/ambience/terrain/mountain_rocks_01.wav",
				// We don't use 02 because its a bit loud
				"sounds/ambience/terrain/mountain_rocks_03.wav",
				"sounds/ambience/terrain/mountain_rocks_04.wav",
				"sounds/ambience/terrain/mountain_rocks_05.wav",
				"sounds/ambience/terrain/mountain_rocks_06.wav",
				"sounds/ambience/terrain/mountain_rocks_07.wav",
				"sounds/ambience/terrain/mountain_rocks_08.wav",
				// We don't use 09 because its too heavy
			];
		}
		// Bush noises with leaf animation
		else if (this.getName().find(::Const.Strings.Tactical.EntityName.Brush) != null
				|| this.getName().find(::Const.Strings.Tactical.EntityName.Plant) != null)
		{
			this.m.HD_BloodType = ::Const.BloodType.Wood;
			this.m.HD_SoundOnHit = [
				"sounds/enemies/dlc2/schrat_hurt_shield_down_01.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_down_02.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_down_03.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_down_04.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_down_05.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_down_06.wav",
			];
		}
		// Wood/Metal noises. An object consisting of both types of material
		else if (this.getName().find("Brazier") != null
				|| this.getName().find("Fireplace") != null)		// They usually have wood at the bottom and a cooking pot on top
		{
			this.m.HD_SoundOnHit = [
				"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
				"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav",
				"sounds/combat/shield_hit_metal_01.wav",
				"sounds/combat/shield_hit_metal_02.wav",
				"sounds/combat/shield_hit_metal_03.wav",
			];
		}
		// Metal noises
		else if (this.getName().find("Weapon Display") != null
				|| this.getName().find("Cage") != null)
		{
			this.m.HD_SoundOnHit = [
				"sounds/combat/shield_hit_metal_01.wav",
				"sounds/combat/shield_hit_metal_02.wav",
				"sounds/combat/shield_hit_metal_03.wav",
			];
		}
		// Blood noises
		else if (this.getName().find("Gruesome Display") != null
				|| this.getName().find("Flesh Cradle") != null)
		{
			this.m.HD_SoundOnHit = [
				"sounds/combat/whip_bleed_01.wav",
				"sounds/combat/whip_bleed_02.wav",
				"sounds/combat/whip_bleed_03.wav",
			];
		}
	}
});
