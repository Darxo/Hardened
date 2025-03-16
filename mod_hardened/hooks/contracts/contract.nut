::Hardened.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.Options.len() != 1 || "HD_screen_hooked" in screen) continue;
			screen.HD_screen_hooked <- true;	// Otherwise we accidentally hook negotiation and intro contract screens multiple times

			local returnValue = null;

			// The regular getResult function barely does anything anymore. Most of its functions were already executed during start
			local oldOption = screen.Options[0].getResult;
			screen.Options[0].getResult = function()
			{
				if (::Hardened.Temp.IsLoading) return oldOption.acall([this]);

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
				if (::Hardened.Temp.IsLoading) return;

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
			if (::Hardened.Temp.IsLoading) return ret;

			if (preponedArguments != null)
			{
				preponedArguments.insert(0, this);
				if (_table == null)
				{
					this.Contract.acall(preponedArguments);
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
