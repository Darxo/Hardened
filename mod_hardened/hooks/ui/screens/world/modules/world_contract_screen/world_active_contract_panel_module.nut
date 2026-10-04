::Hardened.HooksMod.hook("scripts/ui/screens/world/modules/world_contract_screen/world_active_contract_panel_module", function(q)
{
	q.convertToUI = @(__original) { function convertToUI( _contract )
	{
		local ret = __original(_contract);

		ret.HD_ContractTierImage <- _contract.HD_getDifficultyImage();

		return ret;
	}}.convertToUI;

// New Functions
	q.HD_onContractDetailsToggled <- function()
	{
		// Feat: play simple sound effect, when the player expands or collapses the contract details
		::Sound.play("sounds/cloth_01.wav", ::MSU.Math.randf(0.9, 1.1), ::World.State.getPlayer().getPos(), ::MSU.Math.randf(0.9, 1.1));	// We add some variation in volume and pitch
	}
});
