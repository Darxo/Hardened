::Hardened <- {
	ID = "mod_hardened",
	Name = "Hardened",
	Version = "1.0.0-alpha-8",
	GitHubURL = "https://github.com/Darxo/Hardened",
	Temp = {	// Used to globally store variables between function calls to implement more advanced, albeit hacky behavior
		RootSkillCounter = null,	// This variable will have the SkillCounter of the root skills during the execution of any skill executions and delayed executions
	},
	Const = {
		ActionPointChangeOnRally = -3,	// Whenever this actor rallies (going from fleeing to wavering) its action points change by this amount
		ContractScalingBase = 1.0,	// This contract scaling is happening from day one. This scales additively with PerRep scaling
		ContractScalingPerReputation = 0.001,	// Each Reputation point causes contracts to be this much more lucrative and dangerous
		ContractScalingMin = 0.5,	// Contracts never scale below this value
		ContractScalingMax = 10.0,	// Contracts never scale beyond this value
		WorldScalingBase = 1.0,		// This world scaling is happening from day one. This scales additively with PerDay scaling
		WorldScalingMin = 0.5,		// The world will never scale below this value
		WorldScalingMax = 4.0,		// The world will never scale beyond this value
		WorldScalingPerDay = 0.01,	// Each passed day causes the world to be this much more dangerous
	},
	Global = {
		// Anything that uses spawntables to spawn/add troops, will its available resources adjusted by this value
		// Minimum Scaling is 0.5
		getWorldDifficultyMult = function() {
			local ret = ::Hardened.Const.WorldScalingBase + ::World.getTime().Days * ::Hardened.Const.WorldScalingPerDay;
			return ::Math.clampf(ret, ::Hardened.Const.WorldScalingMin, ::Hardened.Const.WorldScalingMax);
		},
		// All contracts will be this much harder and also yield this much more rewards
		// Minimum Scaling is 0.5
		getWorldContractMult = function() {
			local ret = ::Hardened.Const.ContractScalingBase + ::World.Assets.getBusinessReputation() * ::Hardened.Const.ContractScalingPerReputation;
			return ::Math.clampf(ret, ::Hardened.Const.WorldScalingMin, ::Hardened.Const.ContractScalingMax);
		},
	},
}

::Hardened.HooksMod <- ::Hooks.register(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);
::Hardened.HooksMod.require(["mod_reforged >= 0.7.7"]);
::Hardened.HooksMod.conflictWith([
	"mod_heal_repair_fix [Camping Hitpoint Recovery is fixed in Hardened]",
	"mod_RREI [This mods featureset is integrated into Hardened]",
	"EndsBuyback [This mods featureset is integrated into Hardened]",
	"mod_settlement_situations_msu [This mods featureset is integrated into Hardened]",
	"mod_consume [This mods featureset is integrated into Hardened]",
]);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::Reforged.Mod.Debug.setFlag("onAnySkillExecutedFully", false);
	::Reforged.Mod.Debug.setFlag("AIAgentFixes", false);

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
	::includeFiles(::IO.enumerateFiles("mod_hardened/api/hooks_early"));
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_early"));
}, ::Hooks.QueueBucket.Early);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_late"));
}, ::Hooks.QueueBucket.Late);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_last"));
}, ::Hooks.QueueBucket.Last);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_afterhooks"));
}, ::Hooks.QueueBucket.AfterHooks);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks_first_world_init"));
}, ::Hooks.QueueBucket.FirstWorldInit);


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
					// ::logWarning(name + " exists in _functionsToIgnore and will be skipped");
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
			::logWarning("Warning: modID " + _modID + " was never sniped. You might have misstyped it");
		}
	}
	else
	{
		::logWarning("Warning: Path " + _src + " is never hooked. Hooks from mod " + _modID + " could not be sniped");
	}
}

/// return the first function name in the function caller chain of the function you are currently in, which is not "unkown" (probably because its a low or anonymous function)
/// _skipFunctions allows you to skip this many valid functions
/// @return the name of the caller function, if it exists
/// @return an empty string if the caller function does not exists
/// @info when calling this from within a mockFunction, you must use 1 as argument because there is an additional function inbetween us and our caller there
::Hardened.getFunctionCaller <- function( _skipFunctions = 0 )
{
	// 0 = "getstackinfos"; 1 = "getFunctionCaller"; 2 = whatever function wanted to know its caller
	local currentLevel = 3;

	while (true)
	{
		local stackInfo = ::getstackinfos(currentLevel);
		if (stackInfo == null) return "";

		if (stackInfo.func != "unknown")	// We skip all "unknown" levels by default. Those are probably anonymous/lambda functions or low level functions
		{
			if (_skipFunctions <= 0)
			{
				return stackInfo.func;
			}
			else
			{
				--_skipFunctions;	// We found a valid caller name but we are still tasked to skip those
			}
		}

		++currentLevel;	// We didn't find a sufficient name on this stack level so we go to the next
	}
}

/// [[nodiscard]] Change the behavior of an existing function for a limited number of times
/// @important You should always call the cleanup() of this functions return value once you know you are done
///
/// _table must either be a table or an instance (delegation is allowed) containing the function _functionName somewhere in it
/// _functionName is the name of the function we want to mock
/// _mockedBehavior is a function with the same parameters (including defaults) as _functionName
///   However it must return a table with these optionals entries:
///     "done == false" (optional) is a bool signalising if we can start cleaning up
///     "value" (optional) is the return value we want the mocked function to return instead
///       If this is empty the original function is called to gain the return value. In this case we must make sure to not change the arguments that came by reference, unless that is our intention
/// @return object with a:
/// 	cleanup() function, which can be used to manually trigger the cleanup
///		original(...) function, which can be used to manually call the original to trigger its effect or get its return value
///			You must declared the variable for the mockObject in the line before you initiative it with the mockFunction return value, if you want to use mockObject.original in the mockFunction function argument
::Hardened.mockFunction <- function( _table, _functionName, _mockedBehavior )
{
	if (_table == null)
	{
		::logError("Hardened: mockFunction cannot mock '" + _functionName + "' because the passed _table is null");
		::MSU.Log.printStackTrace();
		throw ::MSU.Exception.InvalidType(_table);
	}
	else if (::MSU.isNull(_table))
	{
		::logError("Hardened: mockFunction cannot mock '" + _functionName + "' because the passed _table is a weakRef which is no longer valid");
		::MSU.Log.printStackTrace();
		throw ::MSU.Exception.InvalidType(_table);
	}

	local oldFunction = ::MSU.getMember(_table, _functionName);	// Store the original function

	// Find the actual table where the function is defined (if inheritance is at play)
	local currentTable = _table;
	while (!::MSU.isIn(_functionName, currentTable))
	{
		if (currentTable instanceof ::WeakTableRef)	// weak table check must be first
		{
			currentTable = currentTable.get();
		}
		else if (typeof currentTable == "table")
		{
			currentTable = currentTable.getdelegate();
		}
		else if (typeof currentTable == "instance")
		{
			currentTable = currentTable.getclass();
		}
		else
		{
			throw ::MSU.Exception.InvalidType(currentTable);
		}
	}

	if (currentTable instanceof ::WeakTableRef)	// weak table check must be first
	{
		currentTable = currentTable.get();
	}

	local hasCleanupHappened = false;
	local cleanupMockedFunction = function()
	{
		if (!hasCleanupHappened)
		{
			hasCleanupHappened = true;
			currentTable[_functionName] = oldFunction;		// Restore the original function
		}
	}

	currentTable[_functionName] = function (...)
	{
		vargv.insert(0, _table);
		local mockResult = _mockedBehavior.acall(vargv);	// Todo: check, how many arguments _mockedBehavior expects/can handle. Only if it can handle exactly this many, call it, otherwise dont call it

		if ("done" in mockResult && mockResult.done)	// the mock function signals that it is done and we can begin the clean up process
		{
			cleanupMockedFunction();
		}

		if ("value" in mockResult)
		{
			return mockResult.value;
		}
		else
		{
			return oldFunction.acall(vargv);
		}
	};

	return {
		cleanup = cleanupMockedFunction,
		original = function(...) {
			vargv.insert(0, _table);
			return oldFunction.acall(vargv);
		},
	};
}

/// Revert any changes to hitchance during onAnySkillUsed to revert effects like penalty from attacking close targets or generic hitchance differences
/// Remove tooltip about penalty from attacking too close
::Hardened.removeTooClosePenalty <- function( _script )
{
	::Hardened.HooksMod.hook(_script, function(q) {
		q.create = @(__original) function()
		{
			__original();
			this.m.HitChanceBonus = 0;
		}

		q.getTooltip = @(__original) function()
		{
			local ret = __original();

			foreach (index, entry in ret)
			{
				if (entry.text.find("chance to hit targets directly adjacent") != null)
				{
					ret.remove(index);
					break;
				}
			}

			return ret;
		}

		// Revert any changes to hitchance in order to completely remove the penalty from attacking at distance of 1
		// This will also revert skill-specific penalties, so beware of that
		q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
		{
			local oldMeleeSkill = _properties.MeleeSkill;
			local oldHitCHanceBonus = this.m.HitChanceBonus;

			__original(_skill, _targetEntity, _properties);

			_properties.MeleeSkill = oldMeleeSkill;
			this.m.HitChanceBonus = oldHitCHanceBonus;
		}
	});
}
