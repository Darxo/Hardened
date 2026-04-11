local hookGetResult = function( _option )
{
	local oldGetResult = _option.getResult;
	_option.getResult = function() {
		// We make hasFollower return true, so that Vanilla never applies its Relation penalty, because we want full control over that outselves
		local mockObject = ::Hardened.mockFunction(::World.Retinue, "hasFollower", function( _id ) {
			if (_id == "follower.negotiator")
			{
				return { done = true, value = true };
			}
		});

		// Feat: Negotiator no longer removes the relation penalty for negotiating
		::World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(::Hardened.Global.ContractNegotiationRelationCost);

		// We revert the pool change, so that we can change the pool ourselves
		local oldPool = this.Contract.m.Payment.Pool;
		local ret = oldGetResult();
		this.Contract.m.Payment.Pool = oldPool;

		if (ret == "Negotiation.Fail") return ret;

		// Feat: Make Negotiation Payment Multiplier moddable
		if (!this.Contract.m.Payment.IsFinal)
		{
			local paymentMult = ::MSU.Math.randf(::Hardened.Global.ContractNegotiationPaymentMult[0], ::Hardened.Global.ContractNegotiationPaymentMult[1]);
			paymentMult -= 1.0;
			paymentMult *= ::World.Assets.m.HD_NegotiationPaymentMult;
			paymentMult += 1.0;
			this.Contract.m.Payment.Pool *= paymentMult;
		}

		mockObject.cleanup();

		return ret;
	};
}

// We hook exactly the second option of 3 vanilla negotiation templates, to make them more moddable
// For some reason, this hookiking can't happen before "afterhooks", as "NegotiationDefault" does not exist yet then
foreach (template in [::Const.Contracts.NegotiationDefault[0], ::Const.Contracts.NegotiationPerHead[0], ::Const.Contracts.NegotiationPerHeadAtDestination[0]])
{
	local oldStart = template.start;
	template.start = function() {
		oldStart.call(this);

		// In Vanilla the second option is always the "We need to be paid more for this.", which is what we want to hook
		hookGetResult(this.Options[1]);
	};
}
