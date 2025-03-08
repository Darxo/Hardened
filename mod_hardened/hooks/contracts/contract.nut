::Hardened.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	// Private
	q.m.HD_Temp_ReturnValue <- null;	// Used to preserve return value of an options getResult function, when we move its execution into that screens start function
	q.m.HD_Temp_SkipHook <- false;	// Used to skip this hooking behavior during deserialization, as that can cause crashes
	q.m.HD_Temp_InterceptedArgument <- false;	// Used to preserve the argument of the the "finishActiveContract" call, when we move a getResult execution into that screens start function

	// These variables are used to keep track of a handful of special calls that might happen in the last option of a contract (e.g. Barbarian King fight, Over-Negotiating, Finishing Contract)
	// If those functions trigger too early, that will cause complications. So we skip their execution, when we trigger the last getResult early, and trigger them later
	q.m.HD_Temp_InterceptedFinish <- false;	// Used to preserve whether we intercepted a "finishActiveContract" call, when we move a getResult execution into that screens start function
	q.m.HD_Temp_InterceptedRemoveContract <- null;	// Used to preserve whether we intercepted a "finishActiveContract" call, when we move a getResult execution into that screens start function
	q.m.HD_Temp_InterceptedStartScriptedCombat <- null;	// Used to preserve whether we intercepted a "finishActiveContract" call, when we move a getResult execution into that screens start function

	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			// Usually the id is followed by a number. We assume that any success screen is ID'ed this way and just dont care about others
			if (screen.Options.len() == 1 && !("HD_screen_hooked" in screen))
			{
				screen.HD_screen_hooked <- true;	// Otherwise we accidentally hook negotiation and intro contract screens multiple times

				// We hook every screen which only has 1 option, will have all actions, which would happen during the button press, moved forward
				// That way changes to Renown and Morale Reputation will happen earlier and we can dynamically and globally showcase them in the List
				// "finishActiveContract" is the only currently known function, that we are not allowed to call earlier/during start. So we mock it to prevent that
				// We don't know whether getResult actually includes a 'finishActiveContract'. Some "Success" screens might still lead to further screens. So we specifically check for whether that function would be called
				local oldStart = "start" in screen ? screen.start : function() {};
				local oldOption = screen.Options[0];

				screen.Options[0] = {	// Whatever happened in getResult of the only option before now happens directly in start()
					Text = screen.Options[0].Text,
					function getResult() {
						if (::Hardened.Temp.IsLoading)
						{
							oldOption.getResult.acall([this]);
						}
						else
						{
							if (this.Contract.m.HD_Temp_InterceptedFinish) ::World.Contracts.finishActiveContract();
							if (this.Contract.m.HD_Temp_InterceptedRemoveContract != null)
							{
								::World.Contracts.removeContract(this.Contract.m.HD_Temp_InterceptedRemoveContract);
							}
							if (this.Contract.m.HD_Temp_InterceptedStartScriptedCombat != null)
							{
								::logWarning("Hardened: this.m.HD_Temp_InterceptedStartScriptedCombat != null");
								local shortArray = this.Contract.m.HD_Temp_InterceptedRemoveContract;
								::World.Contracts.startScriptedCombat(shortArray[0], shortArray[1], shortArray[2], shortArray[3]);
							}

							return this.Contract.m.HD_Temp_ReturnValue;
						}
					},
				}

				screen.start <- function()
				{
					oldStart();

					this.Contract.m.HD_Temp_SkipHook = false;
					if (::Hardened.Temp.IsLoading)
					{
						// While the game is still deserializing, we skip the early execution of the getResult function, because at this time its execution is unstable
						// For example `this.Contract.getActiveState()` might not have a value yet and still returns `null`
						this.Contract.m.HD_Temp_SkipHook = true;
					}
					else
					{
						// We mock 'finishActiveContract' to prevent start() from finishing the contract too early. If we really interecepted such a call, we then will actually call it during getResult
						local interceptedFinish = false;
						local interceptedArgument = false;
						local finishMockObject = ::Hardened.mockFunction(::World.Contracts, "finishActiveContract", function( _isCancelled = false ) {
							if (::Hardened.getFunctionCaller(1) == "getResult")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
							{
								interceptedFinish = true;
								interceptedArgument = _isCancelled;
								return { done = true, value = null };
							}
						});

						local removeContractArgument = null
						local removeContractMockObject = ::Hardened.mockFunction(::World.Contracts, "removeContract", function( _contract ) {
							if (::Hardened.getFunctionCaller(1) == "getResult")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
							{
								removeContractArgument = _contract;
								return { done = true, value = null };
							}
						});

						local scriptedContractArguments = null;
						local scriptedContractMockObject = ::Hardened.mockFunction(::World.Contracts, "startScriptedCombat", function( _properties = null, _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true ) {
							if (::Hardened.getFunctionCaller(1) == "getResult")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
							{
								scriptedContractArguments = [_properties, _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking];
								return { done = true, value = null };
							}
						});

						// We call this now directly during start() so that changes to renown and reuputation, which would be inevitable, can be displayed in the list
						this.Contract.m.HD_Temp_ReturnValue = oldOption.getResult.acall([this]);

						finishMockObject.cleanup();
						removeContractMockObject.cleanup();
						scriptedContractMockObject.cleanup();

						this.Contract.m.HD_Temp_InterceptedFinish = interceptedFinish;
						this.Contract.m.HD_Temp_InterceptedArgument = interceptedArgument;
						this.Contract.m.HD_Temp_InterceptedRemoveContract = removeContractArgument;
						this.Contract.m.HD_Temp_InterceptedStartScriptedCombat = scriptedContractArguments;
					}
				}
			}
		}
	}
});
