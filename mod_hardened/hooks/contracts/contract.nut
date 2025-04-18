::Hardened.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	/*
	We have a feature, where Renown/Reputation/Relation changes will be pushed as list-items into the currently viewed Contract/Event screen
	Problem:
	- Many vanilla Contracts hand out those values during the getResult() of the only option. So for those we can't display them automatically
	Possible Soluition:
	1. Adjust all those vanilla contracts manually and move those changes forward
	2. Move those List-Items showing the chages into the next screen shown. If that was the last screen, we generate a new dummy screen to display them
	3. When only one option is available, we execute it during start(), so that all its changes (which would be applied anyways) are triggered earlier
		- However here we must ignore a handful of function calls, which mess up the contract screen, when called too early
	Goal (Option 3):
	- All screens with a specific ID ("Success*") and only 1 option will be hooked in a complicated way so that
		- The getResult of their only option is called during the start() function of that screen
		- During that preponed call, a handful of destructive calls are mocked so they dont execute, but we save their parameter list
		- When the option is pressed, we execute all of those destructive calls, which we witnessed happening
	Note:
	- Initiatilly we didn't check for the "Success*", but there are just too many events with just one option and the weirdest function calls, that we can't catch or where debugging is very annoying.
		- For example the Bandit Camp twitch with the Robber Baron likes to bug out
	*/

	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.Options.len() != 1) continue;
			if (screen.ID.find("Success") != 0) continue;	// ID must start with "Success*". Those are the most important and safest screens to manipulate
			if ("HD_screen_hooked" in screen) continue;

			screen.HD_screen_hooked <- true;	// Otherwise we accidentally hook negotiation and intro contract screens multiple times

			local returnValue = null;

			// The regular getResult function barely does anything anymore. Most of its functions were already executed during start
			local oldOption = screen.Options[0].getResult;
			screen.Options[0].getResult = function()
			{
				if (::MSU.Serialization.IsLoading) return oldOption.acall([this]);

				return returnValue;
			}

			// Dummy function that is only meant to be hooked by our preponeFunction
			screen.earlyGetResult <- function()
			{
				return oldOption();
			}

			local oldStart = "start" in screen ? screen.start : function() {};
			screen.start <- function()
			{
				oldStart();

				// While the game is still deserializing, we skip the early execution of the getResult function, because at this time its execution is unstable
				// For example `this.Contract.getActiveState()` might not have a value yet and still returns `null`
				if (::MSU.Serialization.IsLoading) return;

				returnValue = this.earlyGetResult();
			}

			local self = this;
			// These are vanilla functions which all screw with our preponing action, so we need to mock them during that
			this.preponeFunction(screen, ::World.Contracts, "finishActiveContract");
			this.preponeFunction(screen, ::World.Contracts, "removeContract");
			this.preponeFunction(screen, ::World.Contracts, "startScriptedCombat");
			this.preponeFunction(screen, null, "setScreen");
			// TODO: Maybe include "showActiveContract" too? For bandit robber contract twist
			this.preponeFunction(screen, ::World.Contracts, "showActiveContract");
		}
	}

	// Mock _functionName from _table, during the new earlyGetResult function of _screen so it does nothing there, and then execute it in getResult of _screen, if it was triggered during start
	/// @param _screen the contrat screen, we want to hook
	/// @param _table reference to the table in which the function resides, which we want to mock. If Null, it will be dynamically replaced with this.Contract during mocking
	/// @param _functionName name of the function we want to mock and not execute early
	q.preponeFunction <- function( _screen, _table, _functionName )
	{
		local preponedArguments = null;

		local oldGetResult = _screen.Options[0].getResult;
		_screen.Options[0].getResult = function()
		{
			local ret = oldGetResult();
			if (::MSU.Serialization.IsLoading) return ret;

			if (preponedArguments != null)
			{
				preponedArguments.insert(0, this);
				if (_table == null)
				{
					this.Contract[_functionName].acall(preponedArguments);
				}
				else
				{
					_table[_functionName].acall(preponedArguments);
				}
			}

			return ret;
		}

		local oldEarlyGetResult = _screen.earlyGetResult;
		_screen.earlyGetResult = function()
		{
			preponedArguments = null;

			// We mock '_functionName'. If we really interecepted such a call, we then will actually call it during getResult with the interceptet arguments
			local mockObject = ::Hardened.mockFunction(_table == null ? this.Contract : _table, _functionName, function( ... ) {
				preponedArguments = vargv;
				return { done = true, value = null };
			});

			local ret = oldEarlyGetResult();

			mockObject.cleanup();

			return ret;
		}
	}
});
