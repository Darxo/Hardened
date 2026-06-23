::Hardened.HooksMod.hook("scripts/events/events/dlc2/glutton_eats_apple_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Feat: We add a choice to deny the brother the poisonous apple but make him lose gluttonous from eating it
		{	// Vanilla Screen "A"
			local vanillaScreen = this.getScreen("A");
			vanillaScreen.ID = "C";

			// We keep most of the vanilla text the same and only adjust the very start and very end
			vanillaScreen.Text = "[img]gfx/ui/events/event_18.png[/img]{Not too long after you return to a commotion between %glutton% the glutton and a bucket. He\'s heaving into it so hard his back lurches like a cat and his hurls sound like an undead cow giving birth. When he lifts his head his face looks like a gourd, cheeks ballooned, his mouth still all agargle. %otherbrother% comes over.%SPEECH_ON%He ate the witch\'s apple.%SPEECH_OFF%Raising an eyebrow, you ask the glutton why he would do such a thing. Vomit strings wriggle from his wrist as he wipes his eyes.%SPEECH_ON%{Cause I\'m always hungr-hurgh, uh, hungregghhh! | I don\'t rightfully know sir can\'t I just be in pain without having to validate my actiiiherrrghh! | Would I have to explain myself if I wasn\'t losing my gouerrrghhhh! | Cause you told me to eat healthy and it was an apperrrghghh!}%SPEECH_OFF%He pitches his head back into the bucket like a man who dropped a million crowns down a well. You tell the mercenaries to keep an eye on him until it\'s all out of his system, that is if it ever will be.\n\nBy the time the sickness passes, the %glutton% wants nothing to do with mysterious food ever again.}";

			vanillaScreen.Options[0].Text = "Perhaps he has learned something.";

			local oldStart = vanillaScreen.start;
			vanillaScreen.start = function( _event )
			{
				oldStart(_event);

				local gluttonousSkill = _event.m.Glutton.getSkills().getSkillByID("trait.gluttonous");
				if (gluttonousSkill != null)
				{
					_event.m.Glutton.getSkills().remove(gluttonousSkill);
					this.List.push({
						id = 11,
						icon = gluttonousSkill.getIcon(),
						text = _event.m.Glutton.getName() + " loses " + gluttonousSkill.getName(),
					});
				}
			}
		}

		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You find %glutton% turning a strange apple over in his hand. The thing shines an unhealthy red. You recognize it at once - the witch\'s apple. The mercenary eyes it hungrily.%SPEECH_ON%Never seen fruit look this good.%SPEECH_OFF%He raises it toward his mouth.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Put that down, fool.",
					function getResult( _event )
					{
						return "B";
					},
				},
				{
					Text = "Let\'s see what happens.",
					function getResult( _event )
					{
						return "C";
					},
				},
			],
			function start( _event )
			{
			},
		});

		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You snatch the apple from his hand before he can bite it. The glutton stares in disbelief %SPEECH_ON%What\'s wrong with you?%SPEECH_OFF% he asks. You explain that the fruit is poisoned. He squints at it, unconvinced. %SPEECH_ON%Looks fine to me.%SPEECH_OFF%The man grumbles the rest of the day, robbed of what he still insists would\'ve been a perfectly good meal.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ll survive without it.",
					function getResult( _event )
					{
						return 0;
					},
				},
			],
			function start( _event )
			{
				_event.m.Glutton.worsenMood(1.0, "Was denied a perfectly good meal");
				if (_event.m.Glutton.getMoodState() <= ::Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Glutton.getMoodState()],
						text = _event.m.Glutton.getName() + ::Const.MoodStateEvent[_event.m.Glutton.getMoodState()],
					});
				}
			},
		});
	}
});
