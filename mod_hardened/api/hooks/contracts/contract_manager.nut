::Hardened.HooksMod.hook("scripts/contracts/contract_manager", function(q) {
	q.showContract = @(__original) function( _c )
	{
		// Vanilla Fix: We set IsEventVisible = true at the very start, so that it is also true during the start() function of a contract
		this.m.IsEventVisible = true;
		__original(_c);
	}
});
