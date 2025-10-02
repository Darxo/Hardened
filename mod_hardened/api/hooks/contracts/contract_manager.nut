::Hardened.HooksMod.hook("scripts/contracts/contract_manager", function(q) {
	q.showContract = @(__original) function( _c )
	{
		// Vanilla Fix: We set IsEventVisible = true at the very start, so that it is also true during the start() function of a contract
		this.m.IsEventVisible = true;
		_c.m.HD_CalledPrematureSetScreen = false;	// We disable this flag, as the contract is now officially visible
		__original(_c);
	}
});
