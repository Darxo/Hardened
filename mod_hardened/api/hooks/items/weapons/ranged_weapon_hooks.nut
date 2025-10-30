/*
This file contains various new functions and support for "ranged weapons", which it adds to weapon.h via hooks
It also contains a method to automatically convert old loaded weapons to use this new system

Goal:
- We want to support all ranged weapons
	- Infinite Shots (Slings): HD_LoadedShotsMax = 0; HD_RequiredAmmoType = ::Const.Items.AmmoType.None;
	- Finite Shots (Throwing): HD_LoadedShotsMax = X; HD_RequiredAmmoType = ::Const.Items.AmmoType.None;
	- Using Ammo (Bow): HD_LoadedShotsMax = 0; HD_RequiredAmmoType = ::Const.Items.AmmoType.Arrow;
	- Reloadable (Crossbow Gun): HD_LoadedShotsMax = X; HD_RequiredAmmoType = ::Const.Items.AmmoType.Bolt;

Features:
- getAmmoID() Fix:
	- getRangedWeaponInfo rewrite in actor.nut
	- hasRangedWeapon rewrite in actor.nut
	- isHidden rewrite in no_ammo_warning.nut
	- hasDefensiveItem rewrite in item_container.nut
- allow loaded weapons to
	- have more than 1 shot loaded
	- shots costing more than 1 ammo from the equipped ammo-item
*/

::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	// Public
	q.m.HD_RequiredAmmoType <- ::Const.Items.AmmoType.None;		// What type of ammo do we need to operate/reload this weapon during combat?
	q.m.HD_LoadedShotsMax <- 0;			// how many shots can be loaded into this weapon at most
	q.m.HD_LoadedShotsCost <- 1;		// how much Ammo from the equipped ammo-container it takes to refill one of its shots
	q.m.HD_StartsBattleLoaded <- false;		// if true, then at the start of battle, this character will reload for free (if the correct ammo is equipped)

	// Private
	q.m.IsLoaded <- false;	// We still support this vanilla variable as some vanilla logic uses it so we put it into the weapon base class
	q.m.HD_LoadedShots <- 0;			// how many shots are currently loaded into this weapon

// New Getter Setter
	q.HD_getAmmoType <- function()
	{
		return this.m.HD_RequiredAmmoType;
	}

	q.HD_getLoadedShots <- function()
	{
		return this.m.HD_LoadedShots;
	}

	q.HD_getLoadedShotsMax <- function()
	{
		return this.m.HD_LoadedShotsMax;
	}

	q.HD_getLoadedShotsCost <- function()
	{
		return this.m.HD_LoadedShotsCost;
	}

// Minor Helper
	// Determines, whether this weapon can currently shoot
	q.HD_canShoot <- function()
	{
		if (this.getAmmo() > 0) return true;	// support vanilla throwing weapons
		if (this.HD_isLoaded()) return true;	// A weapon that is loaded can theoretically shoot (crossbow, gun)
		if (this.HD_getLoadedShotsMax() > 0) return false;	// the weapon is not loaded, so it can't shoot (empty javelin, crossbow, guns)
		if (this.HD_getAmmoType() == ::Const.Items.AmmoType.None) return true;	// this weapon has infinite ammo (slings)

		return this.HD_hasEnoughAmmoForReload();	// weapons that use ammo on demand out of the quiver (bows)
	}

	// Determines, whether this ranged weapon is loaded.
	// This can only be true for weapon that "carry around" shots in them
	// Weapons that are not reliant on ammo or have infinite shots are always "loaded"
	q.HD_isLoaded <- function()
	{
		if (this.getAmmo() > 0) return true;	// support vanilla throwing weapons
		return this.HD_getLoadedShots() > 0;
	}

	q.HD_isFullyLoaded <- function()
	{
		if (this.getAmmo() > 0 && this.getAmmo() == this.getAmmoMax()) return true;	// support vanilla throwing weapons
		return this.HD_isLoaded() && this.HD_getLoadedShots() == this.HD_getLoadedShotsMax();
	}

	// Determines, whether our equipped ammo item has enough ammo to reload this weapon
	q.HD_hasEnoughAmmoForReload <- function( _shotsToReload = 1 )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlayerControlled()) return true;	// NPCs don't care about their quiver having ammo in it

		local ammoItem = actor.getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
		if (ammoItem == null) return false;			// We have no ammo equipped
		if (ammoItem.getAmmoType() != this.HD_getAmmoType()) return false;	// wrong kind of ammo is equipped

		return ammoItem.getAmmo() >= _shotsToReload * this.HD_getLoadedShotsCost();
	}

	// @return true, if this weapon can currently be loaded or false otherwise
	q.HD_canBeLoaded <- function()
	{
		if (this.HD_isFullyLoaded()) return false;
		if (!this.HD_hasEnoughAmmoForReload()) return false;

		return true;
	}

	// Consume ammo from the equipped ammo item (if one is equipped)
	// @param _shotAmount amount of shots for which we want to consume ammo
	q.HD_consumeAmmo <- function( _shotAmount = 1 )
	{
		local ammoItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
		if (ammoItem == null) return;			// We have no ammo equipped

		local ammoToBeConsumed = _shotAmount * this.HD_getLoadedShotsCost();
		for (local i = 1; i <= ammoToBeConsumed; ++i)
			ammoItem.consumeAmmo();		// Vanilla ammo is designed so that consumeAmmo only uses a single ammo from it, so we sometimes need to call it multiple times
	}

	// Consume shots from the equipped weapon (i.e. when you shoot the weapon)
	// @param _shotAmount amount of shots that are consumed from the weapon
	// @return amount of shots that were consumed
	q.HD_consumeShot <- function( _shotAmount = 1 )
	{
		if (_shotAmount == null) _shotAmount = this.HD_getLoadedShots();

		local oldShots = this.HD_getLoadedShots();
		this.m.HD_LoadedShots = ::Math.max(this.HD_getLoadedShots() - _shotAmount, 0);
		this.m.IsLoaded = this.HD_isLoaded();		// We still support vanilla logic

		return oldShots - this.HD_getLoadedShots();
	}

	// Try to reload this weapon using ammo from the equipped ammobag
	// @return true, if the loading was successful, false otherwise
	q.HD_tryReload <- function( _shotsToReload = 1 )
	{
		if (!this.HD_canBeLoaded()) return false;

		this.HD_consumeAmmo(_shotsToReload);
		this.HD_loadWeapon(_shotsToReload);
		return true;
	}

	// Load shots into this weapon
	// @param _loadedAmount amount of shots that should be put into this weapon. If null, the weapon will be fully loaded
	// @return amount of shots that were loaded
	q.HD_loadWeapon <- function( _loadedShots = null )
	{
		if (_loadedShots == null) _loadedShots = this.HD_getLoadedShotsMax();

		local ammoBefore = this.HD_getLoadedShots();
		this.m.HD_LoadedShots = ::Math.min(this.HD_getLoadedShots() + _loadedShots, this.HD_getLoadedShotsMax());
		local loadedShots =  this.HD_getLoadedShots() - ammoBefore;

		this.m.IsLoaded = this.HD_isLoaded();		// We still support vanilla logic

		return loadedShots;
	}

	// Remove all shots from this weapon (TODO: and return it to the equipped bag, or the players ammo stash)
	// @param _unloadAmount amount of ammo that should be unloaded from this weapon. If null, all ammo will be unloaded
	// @return amount of ammo that was unloaded
	q.HD_unloadWeapon <- function( _unloadAmount = null )
	{
		if (_unloadAmount == null) _unloadAmount = this.HD_getLoadedShots();
		if (_unloadAmount == 0) return 0;

		local ammoBefore = this.HD_getLoadedShots();
		this.m.HD_LoadedShots = ::Math.max(this.HD_getLoadedShots() - _unloadAmount, 0);
		local unloadedAmmo = ammoBefore - this.HD_getLoadedShots();
		// Do we really wanna return the ammo here? could also do with the return value

		this.m.IsLoaded = this.HD_isLoaded();		// We still support vanilla logic

		return unloadedAmmo;
	}

	// This is called once during create for any weapon, that is identified as a "loaded weapon" in the vanilla style
	// Those weapons need to be converted so that they work under the new Hardened internal changes
	q.HD_convertVanillaLoadedWeapon <- function()
	{
		this.m.IsLoaded = false;	// We set all loaded weapons to be unloaded by default
		this.m.HD_LoadedShotsMax = 1;

		// We adjust some common vanilla functions
		this.isLoaded = this.HD_isLoaded;
		this.setLoaded = function( _bool )
		{
			if (_bool)
			{
				this.HD_loadWeapon(1);
			}
			else
			{
				this.HD_consumeShot(1);
			}
		}
	}

	// Unload this weapon and return its shots to the ammo supply of the player
	q.HD_unloadShotsToAmmoSupply <- function()
	{
		if (this.getAmmoMax() > 0) return;		// This is an indicator that this is a throwing weapon. For those we don't want to do this logic
		if (this.HD_getLoadedShotsMax() == 0) return;		// This weapon doesnt load shots

		local unloadedShots = this.HD_unloadWeapon();
		if (unloadedShots == 0) return;

		if (("Assets" in ::World) && ::World.Assets != null)	// In Scenarios this might not be instantiated
		{
			::World.Assets.addAmmo(unloadedShots * this.HD_getLoadedShotsCost());
		}
	}
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();

		switch (this.getAmmoID())
		{
			case "ammo.arrows":
			{
				this.m.HD_RequiredAmmoType = ::Const.Items.AmmoType.Arrows;
				break;
			}
			case "ammo.bolts":
			{
				this.m.HD_RequiredAmmoType = ::Const.Items.AmmoType.Bolts;
				break;
			}
			case "ammo.powder":
			{
				this.m.HD_RequiredAmmoType = ::Const.Items.AmmoType.Powder;
				break;
			}
			default:
				return;		// If the ammotype could not be fetched corretly, then the default (None) is used
		}

		// We try to detect any vanilla/modded "loaded weapon" and classify them as such retroactively
		if (this.HD_getLoadedShotsMax() == 0 && "isLoaded" in this && "setLoaded" in this)
		{
			this.HD_convertVanillaLoadedWeapon();
		}
	}

	// We do this as a hookTree because some weapon implementations of this function might not call the base functions
	q.onCombatStarted = @(__original) function()
	{
		if (!("setLoaded" in this)) return __original();

		// We switcheroo the setLoaded to prevent vanilla from always pre-loading loaded weapons at the start of every fight
		local oldSetLoaded = this.setLoaded;
		this.setLoaded = function (_b) {};
		__original();
		this.setLoaded = oldSetLoaded;

		// If the weapon can be loaded (correct ammo equipped) and the flag allows it so, it will now get loaded at the start of the battle
		if (!this.HD_canBeLoaded()) return;

		if (this.m.HD_StartsBattleLoaded)
		{
			this.HD_tryReload();
		}
	}

	// We do this as a hookTree because some weapon implementations of this function might not call the base functions
	// Feat: empty out any equipped crossbow or firearm and return their ammunition to the ammo supply pool
	q.onCombatFinished = @(__original) function()
	{
		if ("setLoaded" in this)
		{
			// We switcheroo setLoaded and IsLoaded to prevent any vanilla logic from loading or unloading this weapon during onCombatFinished
			// Vanilla uses both variants at the same time but after overwriting, only "this.m.IsLoaded = true" is actually happening. A mod might use the other method though
			local oldIsLoaded = this.m.IsLoaded;
			local oldSetLoaded = this.setLoaded;
			this.setLoaded = function (_b) {};
			__original();
			this.setLoaded = oldSetLoaded;
			this.m.IsLoaded = oldIsLoaded;
		}
		else
		{
			__original();
		}

		this.HD_unloadShotsToAmmoSupply();
	}

	// We do this as a hookTree because some weapon implementations of this function might not call the base functions
	// Feat: empty out any looted crossbow or firearm and return their ammunition to the ammo supply pool
	q.onAddedToStash = @(__original) function( _stashID )
	{
		__original(_stashID);
		if (_stashID == "player") this.HD_unloadShotsToAmmoSupply();
	}
});

// TODO
/*
- replace hard-coded ammo check and ammo usage in shoot-skills so it uses this scripts new and superior functions
*/
