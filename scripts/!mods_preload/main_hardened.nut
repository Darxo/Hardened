::Hardened <- {
	ID = "mod_hardened",
	Name = "Hardened",
	Version = "0.18.1",
	GitHubURL = "https://github.com/Darxo/Hardened",
	Temp = {},	// Used to globally store variables between function calls to implement more advanced, albeit hacky behavior
	Const = {},
}

::Hardened.HooksMod <- ::Hooks.register(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);
::Hardened.HooksMod.require(["mod_reforged"]);
::Hardened.HooksMod.conflictWith(
	"mod_heal_repair_fix"	// We already fix the cook and camping recovery, so using both mods together is undefined behavior. Unfortunately we don't fix the blacksmith
);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::Hardened.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::Hardened.GitHubURL);
	::Hardened.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_hardened/load");		// Load Hardened-Adjustments and other hooks
	::include("mod_hardened/ui/load");	// Load Hardened JS Adjustments and Hooks

	// Remove the Fangshire Helmet
	foreach (index, itemScript in ::Const.World.Assets.NewCampaignEquipment)
	{
		if (itemScript == "scripts/items/helmets/legendary/fangshire")
		{
			::Const.World.Assets.NewCampaignEquipment.remove(index);
			break;
		}
	}

	::Hardened.Const.CaravanBannerOffset <- ::createVec(0, 50);
});	// QueueBucket.Normal

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_early"));
}, ::Hooks.QueueBucket.Early);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_afterhooks"));
}, ::Hooks.QueueBucket.AfterHooks);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_first_world_init"));
}, ::Hooks.QueueBucket.FirstWorldInit);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_last"));
}, ::Hooks.QueueBucket.Last);


// Delete all functions in the passed class so that its shell can be repurposed without changing every instance that was pointing to the old script
// @param _functionsToIgnore array of function names that should not be wiped
::Hardened.wipeClass <- function( _classPath, _functionsToIgnore = [] )
{
	::Hardened.HooksMod.rawHook(_classPath, function(p) {
		local toDelete = [];
		foreach (name, func in p)
		{
			if (typeof func == "function")
			{
				if (_functionsToIgnore.find(name) == null)
				{
					toDelete.push(name);
				}
				else
				{
					::logWarning(name + " exists in _functionsToIgnore and will be skipped");
				}
			}
		}

		foreach (functionName in toDelete)
		{
			delete p[functionName];
		}
	});
}

// Round a number only if it falls within 0.01 of the next whole number
::Hardened.controlledRound <- function( _value, _tolerance = 0.01)
{
	local roundedValue = ::Math.round(_value);
	if (::fabs(_value - roundedValue) < _tolerance)
	{
		return roundedValue;
	}
	else
	{
		return _value;
	}
}

::Hardened.snipeHook <- function( _src, _modID )
{
	if (_src in ::Hooks.BBClass)
	{
		local modIDFound = false;
		for (local i = ::Hooks.BBClass[_src].RawHooks.len() - 1; i >= 0; --i)
		{
			if (::Hooks.BBClass[_src].RawHooks[i].Mod.ID == _modID)
			{
				::Hooks.BBClass[_src].RawHooks.remove(i);
				modIDFound = true;
			}
		}
		if (!modIDFound)
		{
			::logWarning("Warning: modID " + _modID + " was never sniped. You might have mistyped it");
		}
	}
	else
	{
		::logWarning("Warning: Path " + _src + " is never hooked. Hooks from mod " + _modID + " could not be sniped");
	}
}

